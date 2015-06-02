#!/bin/bash

if [[ "${PROJECT_TEMP_DIR}" != "" ]]; then
    export LOG="${PROJECT_TEMP_DIR}/generate_info.log"
    rm -rf $LOG
    exec 3>&1 1>>${LOG} 2>&1
fi

scriptPath=${0%/*}
source "$scriptPath/version-info.sh"

cd "${PROJECT_DIR}"

infoPlist="${SRCROOT}/${INFOPLIST_FILE}"
infoPath="${infoPlist%.*}"
infoName=$(basename "${infoPath}")
infoHeader="${infoPath}.h"
infoImplementation="${infoPath}.m"
infoHeaderImport=$(basename "${infoHeader}")

rm -f "$infoHeader"
rm -f "$infoImplementation"
touch "$infoHeader"
touch "$infoImplementation"

displayName=`eval echo $(/usr/libexec/PlistBuddy -c "Print :CFBundleDisplayName" "$infoPlist")`
if [[ -z $displayName ]]; then
    displayName=`eval echo $(/usr/libexec/PlistBuddy -c "Print :CFBundleName" "$infoPlist")`
fi

bundleIdentifier=`eval echo $(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$infoPlist")`
bundleShortVersionString=`eval echo $(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$infoPlist")`
bundleVersion=$(version_number)

echo "#define ${PROJECT_NAME}_Bundle_Version $bundleVersion" >> "$infoHeader"
echo "" >> "$infoHeader"
echo "#ifdef __OBJC__" >> "$infoHeader"
echo "@import Foundation;" >> "$infoHeader"
echo "" >> "$infoHeader"
echo "extern const struct $infoName {" >> "$infoHeader"
echo "	__unsafe_unretained NSString *displayName;" >> "$infoHeader"
echo "	__unsafe_unretained NSString *bundleIdentifier;" >> "$infoHeader"
echo "	__unsafe_unretained NSString *bundleVersion;" >> "$infoHeader"
echo "	__unsafe_unretained NSString *bundleShortVersionString;" >> "$infoHeader"
echo "} $infoName;" >> "$infoHeader"
echo "#endif" >> "$infoHeader"

echo "#import \"${infoHeaderImport}\"" >> "$infoImplementation"
echo "" >> "$infoImplementation"
echo "const struct $infoName $infoName = {" >> "$infoImplementation"
echo "	.displayName = @\"$displayName\"," >> "$infoImplementation"
echo "	.bundleIdentifier = @\"$bundleIdentifier\"," >> "$infoImplementation"
echo "	.bundleVersion = @\"$bundleVersion\"," >> "$infoImplementation"
echo "	.bundleShortVersionString = @\"$bundleShortVersionString\"" >> "$infoImplementation"
echo "};" >> "$infoImplementation"
