#!/bin/sh -e

# Define color codes using tput for better compatibility
RC=$(tput sgr0)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)

PACKAGER=""
SUDO_CMD=""
SUGROUP=""
FILEPATH="$(pwd)"

# Helper functions
print_colored() {
    printf "${1}%s${RC}\n" "$2"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_environment() {
    # Check for required commands
    REQUIREMENTS='curl groups sudo'
    for req in $REQUIREMENTS; do
        if ! command_exists "$req"; then
            print_colored "$RED" "To run me, you need: $REQUIREMENTS"
            exit 1
        fi
    done

    # Determine package manager
    PACKAGEMANAGER='nala apt dnf yum pacman zypper emerge xbps-install nix-env'
    for pgm in $PACKAGEMANAGER; do
        if command_exists "$pgm"; then
            PACKAGER="$pgm"
            printf "Using %s\n" "$pgm"
            break
        fi
    done

    if [ -z "$PACKAGER" ]; then
        print_colored "$RED" "Can't find a supported package manager"
        exit 1
    fi

    # Determine sudo command
    if command_exists sudo; then
        SUDO_CMD="sudo"
    elif command_exists doas && [ -f "/etc/doas.conf" ]; then
        SUDO_CMD="doas"
    else
        SUDO_CMD="su -c"
    fi
    printf "Using %s as privilege escalation software\n" "$SUDO_CMD"

    # Check write permissions
    if [ ! -w "$FILEPATH" ]; then
        print_colored "$RED" "Can't write to $FILEPATH"
        exit 1
    fi

    # Check superuser group
    SUPERUSERGROUP='wheel sudo root'
    for sug in $SUPERUSERGROUP; do
        if groups | grep -q "$sug"; then
            SUGROUP="$sug"
            printf "Super user group %s\n" "$SUGROUP"
            break
        fi
    done

    if ! groups | grep -q "$SUGROUP"; then
        print_colored "$RED" "You need to be a member of the sudo group to run me!"
        exit 1
    fi
}

install_dependencies() {
    DEPENDENCIES='bash bash-completion tar bat tree multitail fastfetch wget unzip fontconfig trash-cli fzf zoxide nvim'

    print_colored "$YELLOW" "Installing dependencies..."
    case "$PACKAGER" in
        pacman)
	    ${SUDO_CMD} ${PACKAGER} -S --noconfirm ${DEPENDENCIES}
	    install_aur_helper
            ;;
        nala)
            ${SUDO_CMD} ${PACKAGER} install -y ${DEPENDENCIES}
            ;;
        emerge)
            ${SUDO_CMD} ${PACKAGER} -v app-shells/bash app-shells/bash-completion app-arch/tar app-editors/neovim sys-apps/bat app-text/tree app-text/multitail app-misc/fastfetch app-misc/trash-cli
            ;;
        xbps-install)
            ${SUDO_CMD} ${PACKAGER} -v ${DEPENDENCIES}
            ;;
        nix-env)
            ${SUDO_CMD} ${PACKAGER} -iA nixos.bash nixos.bash-completion nixos.gnutar nixos.neovim nixos.bat nixos.tree nixos.multitail nixos.fastfetch nixos.pkgs.starship nixos.trash-cli
            ;;
        dnf)
            ${SUDO_CMD} ${PACKAGER} install -y ${DEPENDENCIES}
            ;;
        zypper)
            ${SUDO_CMD} ${PACKAGER} install -n ${DEPENDENCIES}
            ;;
        *)
            ${SUDO_CMD} ${PACKAGER} install -yq ${DEPENDENCIES}
            ;;
    esac

    install_font
}

install_aur_helper() {
    if ! command_exists yay && ! command_exists paru; then
        while true; do
            read -p "Do you want to install yay for aur [y/n]: " yn
            case $yn in
                [Yy]*) 
                    printf "Installing yay as AUR helper...\n"
                    ${SUDO_CMD} ${PACKAGER} --noconfirm -S base-devel
                    cd /opt && ${SUDO_CMD} git clone https://aur.archlinux.org/yay-git.git
                    ${SUDO_CMD} chown -R "${USER}:${USER}" /opt/yay-git
                    cd yay-git && makepkg --noconfirm -si
                    break  # Exit the loop after installation
                    ;;  
                [Nn]*) 
                    echo "Aborted" 
		    break
                    ;;
                *) 
                    echo "Please answer y or n." 
                    ;;  # Handle invalid input
            esac
        done
    else
        printf "AUR helper already installed\n"
    fi

    if command_exists yay; then
        AUR_HELPER="yay"
    elif command_exists paru; then
        AUR_HELPER="paru"
    else
        printf "No AUR helper found. \n"
    fi
}

install_font() {
    FONT_NAME="JetBrainsMono Nerd Font"
    FONT_NAME2="MesloLGS Nerd Font Mono"
    if fc-list :family | grep -iq "$FONT_NAME"; then
        printf "Font '%s' is installed.\n" "$FONT_NAME"
    else
        printf "Installing font '%s'\n" "$FONT_NAME"
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        FONT_DIR="$HOME/.local/share/fonts"
        if wget -q --spider "$FONT_URL"; then
            TEMP_DIR=$(mktemp -d)
            wget -q $FONT_URL -O "$TEMP_DIR"/"${FONT_NAME}".zip
            unzip "$TEMP_DIR"/"${FONT_NAME}".zip -d "$TEMP_DIR"
            mkdir -p "$FONT_DIR"/"$FONT_NAME"
            mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME"
            # Update the font cache
            fc-cache -fv
            rm -rf "${TEMP_DIR}"
            printf "'%s' installed successfully.\n" "$FONT_NAME"
        else
            printf "Font '%s' not installed. Font URL is not accessible.\n" "$FONT_NAME"
        fi
    fi
    if fc-list :family | grep -iq "$FONT_NAME2"; then
        printf "Font '%s' is installed.\n" "$FONT_NAME2"
    else
        printf "Installing font '%s'\n" "$FONT_NAME2"
        FONT_URL2="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
        FONT_DIR="$HOME/.local/share/fonts"
        if wget -q --spider "$FONT_URL2"; then
            TEMP_DIR=$(mktemp -d)
            wget -q $FONT_URL2 -O "$TEMP_DIR"/"${FONT_NAME2}".zip
            unzip "$TEMP_DIR"/"${FONT_NAME2}".zip -d "$TEMP_DIR"
            mkdir -p "$FONT_DIR"/"$FONT_NAME2"
            mv "${TEMP_DIR}"/*.ttf "$FONT_DIR"/"$FONT_NAME2"
            # Update the font cache
            fc-cache -fv
            rm -rf "${TEMP_DIR}"
            printf "'%s' installed successfully.\n" "$FONT_NAME2"
        else
            printf "Font '%s' not installed. Font URL is not accessible.\n" "$FONT_NAME2"
        fi
    fi
}

install_starship_and_fzf() {
    if ! command_exists starship; then
        if ! curl -sS https://starship.rs/install.sh | sh; then
            print_colored "$RED" "Something went wrong during starship install!"
            exit 1
        fi
    else
        printf "Starship already installed\n"
    fi

    if ! command_exists fzf; then
        if [ -d "$HOME/.fzf" ]; then
            print_colored "$YELLOW" "FZF directory already exists. Skipping installation."
        else
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install
        fi
    else
        printf "Fzf already installed\n"
    fi
}

install_zoxide() {
    if ! command_exists zoxide; then
        if ! curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; then
            print_colored "$RED" "Something went wrong during zoxide install!"
            exit 1
        fi
    else
        printf "Zoxide already installed\n"
    fi
}

create_fastfetch_config() {
    USER_HOME=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)
    CONFIG_DIR="$USER_HOME/.config/fastfetch"
    CONFIG_FILE="$CONFIG_DIR/config.jsonc"
    mkdir -p "$CONFIG_DIR"
    [ -e "$CONFIG_FILE" ] && mv "$CONFIG_FILE" "$CONFIG_DIR/oldconfig"
    
    if ! ln -svf "$FILEPATH/mybash/config.jsonc" "$CONFIG_FILE"; then
        print_colored "$RED" "Failed to create symbolic link for fastfetch config"
        exit 1
    fi
}

link_config() {
    USER_HOME=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)
    OLD_BASHRC="$USER_HOME/.bashrc"
    OLD_STARSHIP="$USER_HOME/.config/starship.toml"
    BASH_PROFILE="$USER_HOME/.bash_profile"
    
    if [ -e "$OLD_BASHRC" ]; then
        print_colored "$YELLOW" "Moving old bash config file to $USER_HOME/.bashrc.bak"
        if ! mv "$OLD_BASHRC" "$USER_HOME/.bashrc.bak"; then
            print_colored "$RED" "Can't move the old bash config file!"
        fi
    fi

    if [ -e "$OLD_STARSHIP" ]; then
        print_colored "$YELLOW" "Moving old starship config file to $USER_HOME/.config/starship.bak"
        if ! mv "$OLD_STARSHIP" "$USER_HOME/.config/starship.bak"; then
            print_colored "$RED" "Can't move the old bash config file!"
        fi
    fi

    if [ -e "$USER_HOME/.config/nvim" ]; then 
        print_colored "$YELLOW" "Moving old nvim config file to $USER_HOME/.config/nvim_bak"
        if ! mv "$USER_HOME/.config/nvim" "$USER_HOME/.config/nvim_bak"; then
            print_colored "$RED" "Can't move the old nvim config file!"
        fi
    fi

    print_colored "$YELLOW" "Linking new bash config file..."
    if ! ln -svf "$FILEPATH/mybash/.bashrc" "$USER_HOME/.bashrc"; then
        print_colored "$RED" "Failed to create symbolic links"
    fi

    print_colored "$YELLOW" "Linking new bash config file..."
    if ! ln -svf "$FILEPATH/mybash/.inputrc" "$USER_HOME/.inputrc"; then
        print_colored "$RED" "Failed to create symbolic links"
    fi

    print_colored "$YELLOW" "Linking new bash config file..."
    if ! ln -svf "$FILEPATH/mybash/starship.toml" "$USER_HOME/.config/starship.toml"; then
        print_colored "$RED" "Failed to create symbolic links"
    fi

    print_colored "$YELLOW" "Linking new nvim config file..."
    if ! ln -svf "$FILEPATH/nvim/" "$USER_HOME/.config/nvim"; then
        print_colored "$RED" "Failed to create symbolic links"
    fi

    # Create .bash_profile if it doesn't exist
    if [ ! -f "$BASH_PROFILE" ]; then
        print_colored "$YELLOW" "Creating .bash_profile..."
        echo "[ -f ~/.bashrc ] && . ~/.bashrc" > "$BASH_PROFILE"
        print_colored "$GREEN" ".bash_profile created and configured to source .bashrc"
    else
        print_colored "$YELLOW" ".bash_profile already exists. Please ensure it sources .bashrc if needed."
    fi
}

# Main execution
check_environment
install_dependencies
install_starship_and_fzf
install_zoxide
create_fastfetch_config
install_font

if link_config; then
    print_colored "$GREEN" "Done!\nrestart your shell to see the changes."
else
    print_colored "$RED" "Something went wrong!"
fi
