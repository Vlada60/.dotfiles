sed -i '/<layout>/,/<\/layout>/ {
/<name>custom<\/name>/ {
:a
$!N
/<variantList\/>/!ba
c\
            <name>custom</name>\
            <shortDescription>custom</shortDescription>\
            <description>A Programmer layout</description>\
            <languageList>\
                <iso639Id>und</iso639Id>\
            </languageList>\
        </configItem>\
        <variantList>\
            <variant>\
            <configItem>\
                <name>latin</name>\
                <description>Standard Layout</description>\
            </configItem>\
            </variant>\
        </variantList>
}
}' evdevtest.xml

