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
        https://${URL}/v1/auth/userpass/users \
            | grep -o '\[.*\]'
}

add_service_policy() {
    POLICY=$1
    PATH=$2
    CAPABILTIES=$3
    if [ -z ${POLICY} ]; then
        read -p "Policy Name (Example: sql-ro): " POLICY
    fi
    if [ -z ${PATH} ]; then
        read -p "Policy path (Example: sql/sql-ro): " PATH
    fi
        if [ -z ${CAPABILTIES} ]; then
        read -p "Policy capabilities (Example: create, list): " CAPABILTIES
    fi
    curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        --request PUT \
        --data "{\"policy\": \"path \"${PATH}\" {capabilities = [${CAPABILITIES}]\"}" \
        https://${URL}/v1/sys/policy/${POLICY}
}

add_service_user() {
    NEW_USERNAME=$1
    NEW_PASSWORD=$2
    POLICIES=$3
    if [ -z ${NEW_USERNAME} ]; then
        read -p "Service Name (Example: sql): " NEW_USERNAME
    fi
    if [ -z ${NEW_PASSWORD} ]; then
        read -sp "Service Password (Example: ********): " NEW_PASSWORD
    fi
    if [ -z ${POLICIES} ]; then
        read -p "Service Policies (Example: sql-readonly): " POLICIES
    fi
    curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        --request POST \
        --data "{\"password\": \"${NEW_PASSWORD}\",\"policies\": \"${POLICIES}\"}" \
        https://${URL}/v1/auth/userpass/users/${NEW_USERNAME}
}

attach_service_policy() {
echo todo
}

#################
# Main Function #
#################
OPTIONS="get_token, list_secrets, get_secret, list_users"

if [ -z $1 ]; then echo "Invalid argument.  Options: $OPTIONS"; fi

get_token

case "$1" in
    "get_token"          ) echo "${TOKEN}"             ;;
    "list_secrets"       ) list_secrets $2             ;;
    "get_secret"         ) get_secret $2 $3            ;;
    "add_secret"         ) add_secret $2 $3            ;;
    "list_users"         ) list_users                  ;;
    "add_service_user"   ) add_service_user $2         ;;
    "add_service_policy" ) add_service_policy $2 $3 $4 ;;
    "*"                  ) echo "Invalid argument.  Options: $OPTIONS"
esac
