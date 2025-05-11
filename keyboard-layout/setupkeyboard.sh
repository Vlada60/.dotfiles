#!/bin/sh -e

# Define color codes using tput for better compatibility
RC=$(tput sgr0)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)

FILEPATH="$(pwd)"

if grep -q "ags" /usr/share/X11/xkb/rules/evdev.xml; then
  echo Keyboard layout already installed
else
  sudo sed -i '/<\/layoutList>/{
  c\
      <layout>\
	<configItem>\
	  <name>ags</name>\
	  <shortDescription>AGS</shortDescription>\
	  <description>A good serbian layout</description>\
	</configItem>\
	<variantList>\
	  <variant>\
	    <configItem>\
	      <name>programming</name>\
	      <description>Programming Layout</description>\
	    </configItem>\
	  </variant>\
	  <variant>\
	    <configItem>\
	      <name>cyrillic</name>\
	      <description>Good Serbian (Cyrillic)</description>\
	    </configItem>\
	  </variant>\
	  <variant>\
	    <configItem>\
	      <name>cyrillicnocaps</name>\
	      <description>Good Serbian (Cyrillic, No CapsLock to Escape)</description>\
	    </configItem>\
	  </variant>\
	  <variant>\
	    <configItem>\
	      <name>nocaps</name>\
	      <description>Good Serbian (Latin, No CapsLock to Escape)</description>\
	    </configItem>\
	  </variant>\
	  <variant>\
	    <configItem>\
	      <name>programmingnocaps</name>\
	      <description>Programming Layout (No CapsLock to Escape)</description>\
	    </configItem>\
	  </variant>\
	  <variant>\
	    <configItem>\
	      <name>latinyz</name>\
	      <description>Good Serbian (Latin, QWERTY)</description>\
	    </configItem>\
	  </variant>\
	</variantList>\
      </layout>\
    </layoutList>
  }' /usr/share/X11/xkb/rules/evdev.xml
fi

# Helper functions
print_colored() {
    printf "${1}%s${RC}\n" "$2"
}

print_colored "$YELLOW" "Linking the keyboard file..."
if ! sudo ln -svf "$FILEPATH/ags" "/usr/share/X11/xkb/symbols/ags"; then
    print_colored "$RED" "Failed to create symbolic link"
    exit 1
fi
