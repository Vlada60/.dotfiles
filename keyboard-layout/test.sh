sed -i -E '
  /<configItem>/,/<\/configItem>/ {
    /<name>custom<\/name>/ {
      # Store the replacement string in a variable.  This makes the sed command
      # much more readable and maintainable, especially with multi-line replacements.
      r /dev/stdin
      d
    }
  }
' <<<"
      <configItem>
    <name>custom</name>
           <shortDescription>custom</shortDescription>
           <description>A Programmer layout</description>
           <languageList>
             <iso639Id>und</iso639Id>
           </languageList>
         </configItem>
         <variantList>
           <variant>
             <configItem>
               <name>latin</name>
               <description>Standard Layout</description>
             </configItem>
           </variant>
         </variantList>
" $(pwd)/evdevtest.xml

