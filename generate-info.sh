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
bundleIdentifier=`eval echo $(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$infoPlist")`
bundleName=`eval echo $(/usr/libexec/PlistBuddy -c "Print :CFBundleName" "$infoPlist")`
bundleShortVersionString=`eval echo $(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$infoPlist")`
bundleVersion=`eval echo $(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$infoPlist")`

echo "#ifdef __OBJC__" >> "$infoHeader"
echo "@import Foundation;" >> "$infoHeader"
echo "" >> "$infoHeader"
echo "extern const struct $infoName {" >> "$infoHeader"
echo "	__unsafe_unretained NSString *displayName;" >> "$infoHeader"
echo "	__unsafe_unretained NSString *bundleIdentifier;" >> "$infoHeader"
echo "	__unsafe_unretained NSString *bundleName;" >> "$infoHeader"
echo "	__unsafe_unretained NSString *bundleVersion;" >> "$infoHeader"
echo "	__unsafe_unretained NSString *bundleShortVersionString;" >> "$infoHeader"
echo "} $infoName;" >> "$infoHeader"
echo "#endif" >> "$infoHeader"

echo "#import \"${infoHeaderImport}\"" >> "$infoImplementation"
echo "" >> "$infoImplementation"
echo "const struct $infoName $infoName = {" >> "$infoImplementation"
echo "	.displayName = @\"$displayName\"," >> "$infoImplementation"
echo "	.bundleIdentifier = @\"$bundleIdentifier\"," >> "$infoImplementation"
echo "	.bundleName = @\"$bundleName\"," >> "$infoImplementation"
echo "	.bundleVersion = @\"$bundleVersion\"," >> "$infoImplementation"
echo "	.bundleShortVersionString = @\"$bundleShortVersionString\"" >> "$infoImplementation"
echo "};" >> "$infoImplementation"
