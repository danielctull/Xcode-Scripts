#!/bin/bash

scriptPath=${0%/*}
source "$scriptPath/ipa-info.sh"

if [[ "${PROJECT_TEMP_DIR}" != "" ]]; then
    mkdir -p "${PROJECT_TEMP_DIR}"
    export LOG="${PROJECT_TEMP_DIR}/create-ipa.log"
    rm -rf "$LOG"
    exec 3>&1 1>>"${LOG}" 2>&1
fi


APP=`readlink "${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}"`
IPA=$(ipa_path)

echo "$APP"
ls "${BUILT_PRODUCTS_DIR}"

xcrun -sdk iphoneos PackageApplication "$APP" -o "$IPA" -v
