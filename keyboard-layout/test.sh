sed -i '/<configItem>/,/<\/configItem>/ {
/<name>custom<\/name>/ {
h
n;n;n;n;n;n;n;n;n;n
c\
<configItem>\
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
d
}
}' evdevtest.xml
