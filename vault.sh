#!/bin/bash

####################
# Helper Functions #
####################
get_token() {
    read -p "Vault URL (Example: vault.company.com): " URL
    read -p "Your Okta Username (Example: you@company.com): " USERNAME
    read -sp "Your Okta Password (Example: ********): " PASSWORD
    echo "Approve login through your Okta Verify App"
    TOKEN=$(curl -sk \
        --request POST \
        --data "{\"password\": \"${PASSWORD}\"}" \
        https://${URL}/v1/auth/okta/login/${USERNAME} \
            | grep -o '"client_token":"[a-z.A-Z0-9]*' | cut -d '"' -f4
    )
}

list_secrets() {
    SECRET_ENGINE=$1
    if [ -z ${SECRET_ENGINE} ]; then
        read -p "Enter a Secret Engine (Example: services): " SECRET_ENGINE
    fi
    curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        --request LIST \
        https://${URL}/v1/${SECRET_ENGINE}/metadata \
            | grep -o "\[.*\]"
}

get_secret() {
    SECRET_ENGINE=$1
    SECRET=$2
    if [ -z ${SECRET_ENGINE} ]; then
        read -p "Enter a Secret Engine (Example: services): " SECRET_ENGINE
    fi
    if [ -z ${SECRET} ]; then
        read -p "Enter a Secret Name (Example: service): " SECRET
    fi
    curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        https://${URL}/v1/${SECRET_ENGINE}/data/$SECRET
}

add_secret() {
    echo "TODO"
}

list_users() {
    curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        --request LIST \
        https://${URL}/v1/auth/okta/users \
            | grep -o '\[.*\]'
}

add_service_user() {
    echo "TODO"
}

#################
# Main Function #
#################
OPTIONS="get_token, list_secrets, get_secret, list_users"

if [ -z $1 ]; then echo "Invalid argument.  Options: $OPTIONS"; fi

get_token

case "$1" in
    "get_token"        ) echo "${TOKEN}"     ;;
    "list_secrets"     ) list_secrets $2     ;;
    "get_secret"       ) get_secret $2 $3    ;;
    "add_secret"       ) add_secret $2 $3    ;;
    "list_users"       ) list_users          ;;
    "add_service_user" ) add_service_user $1 ;;
    "*"                ) echo "Invalid argument.  Options: $OPTIONS"
esac
