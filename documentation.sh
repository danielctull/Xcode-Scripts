#!/bin/bash
# Argument = -p -c -i

PROJECT_NAME=${PRODUCT_NAME}
PROJECT_COMPANY=
COMPANY_ID=
while getopts ":p:c:i:" OPTION; do
  case $OPTION in
    p) PROJECT_NAME="$OPTARG";;
    c) PROJECT_COMPANY="$OPTARG";;
    i) COMPANY_ID="$OPTARG";;
  esac
done

if [[ -z $PROJECT_NAME ]] || [[ -z $PROJECT_COMPANY ]] || [[ -z $COMPANY_ID ]]
then
  echo "Not enough information given." >&2
  exit 0
fi

# Add this to Xcode's PATH to find homebrew installation
PATH=$PATH:/usr/local/bin

appledoc=`which appledoc`

if [[ $appledoc ]]; then

uuid=`uuidgen`
outputPath="/tmp/${uuid}";

$appledoc \
--project-name "${PROJECT_NAME}" \
--project-company "${PROJECT_COMPANY}" \
--company-id "${COMPANY_ID}" \
--output "${outputPath}" \
--create-docset \
--install-docset \
--create-html \
--docset-platform-family "${PLATFORM_NAME}" \
--exit-threshold 2 \
--no-repeat-first-par \
"${CONFIGURATION_BUILD_DIR}/${PUBLIC_HEADERS_FOLDER_PATH}"

rm -rf ${outputPath}

fi
