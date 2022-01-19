#!/bin/bash

ALLURE_RESULTS_DIRECTORY=$1
PROJECT_ID=$2
IS_SECURE=$3

SECURITY_USER=$ALLURE_SERVER_USER
SECURITY_PASS=$ALLURE_SERVER_PASSWORD
ALLURE_SERVER=$ALLURE_SERVER_URL

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FILES_TO_SEND=$(ls -dp $DIR/$ALLURE_RESULTS_DIRECTORY/* | grep -v /$)

if [ -z "$FILES_TO_SEND" ]; then
    exit 1
fi

if [ -z "$ALLURE_SERVER_URL" ]; then
    echo "no allure server url provided"
    exit 1
fi


curl "$ALLURE_SERVER/allure-docker-service/version"

FILES=''
for FILE in $FILES_TO_SEND; do
    FILES+="-F files[]=@$FILE "
done



if [[ "$IS_SECURE" == "true" ]]; then
    if [ -z "$SECURITY_USER" ]; then
        echo "no auth username provided"
        exit 1
    fi
    if [ -z "$SECURITY_PASS" ]; then
        echo "no auth password provided"
        exit 1
    fi

    # set +o xtrace
    echo "------------------LOGIN-----------------"
    curl -X POST "$ALLURE_SERVER/allure-docker-service/login" \
    -H 'Content-Type: application/json' \
    -d "{
        "\""username"\"": "\""$SECURITY_USER"\"",
        "\""password"\"": "\""$SECURITY_PASS"\""
    }" -c cookiesFile -ik --silent --output /dev/null --show-error --fail
    echo "done"
    echo "------------------EXTRACTING-CSRF-ACCESS-TOKEN------------------"
    CRSF_ACCESS_TOKEN_VALUE=$(cat cookiesFile | grep -o 'csrf_access_token.*' | cut -f2)
    echo "done"
    # echo "csrf_access_token value: $CRSF_ACCESS_TOKEN_VALUE"

    echo "------------------SEND-RESULTS------------------"
    curl -X POST "$ALLURE_SERVER/allure-docker-service/send-results?project_id=$PROJECT_ID" \
    -H 'Content-Type: multipart/form-data' \
    -H "X-CSRF-TOKEN: $CRSF_ACCESS_TOKEN_VALUE" \
    -b cookiesFile $FILES -ik
    echo "done"
    set -o xtrace
else
    echo "------------------SEND-RESULTS------------------"
    curl -X POST "$ALLURE_SERVER/allure-docker-service/send-results?project_id=$PROJECT_ID" -H 'Content-Type: multipart/form-data' $FILES -ik
fi