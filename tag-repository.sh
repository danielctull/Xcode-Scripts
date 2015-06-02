#!/bin/bash

if [[ "${PROJECT_TEMP_DIR}" != "" ]]; then
    mkdir -p "${PROJECT_TEMP_DIR}"
    export LOG="${PROJECT_TEMP_DIR}/tag-repository.log"
    rm -rf "$LOG"
    exec 3>&1 1>>"${LOG}" 2>&1
fi

cd "${PROJECT_DIR}"

scriptPath=${0%/*}
source "$scriptPath/version-info.sh"
echo ""

if [[ ${CONFIGURATION} != "Release" ]]; then
    echo "Not performing a release, exiting."
    exit
fi
 
PREVIOUSTAG=$(previous_tag)
TAG=$(current_tag)

if [[ $TAG == $PREVIOUSTAG ]]; then
    echo "Not a new tag, exiting."
    exit
fi

CHANGELOG=$(changelog)

echo "Creating new git tag: $TAG"
git tag -a -m "$CHANGELOG" $TAG
# git push origin --tags
