#!/bin/bash

#############################
# Argument Helper Functions #
#############################
get_vault_url () {
    if [ -z $VAULT_URL ]; then
        echo "Vault URL (Example: vault.company.com): "
        read VAULT_URL
    fi
}

get_vault_username () {
    if [ -z $VAULT_USERNAME ]; then
        echo "Your Okta Username (Example: you@company.com): "
        read VAULT_USERNAME
    fi
}

get_vault_password () {
    if [ -z $VAULT_PASSWORD ]; then
        echo "Your Okta Password (Example: ********): "
        read -s VAULT_PASSWORD
    fi
    if [[ ${VAULT_AUTH_METHOD} == "okta" ]]; then
        echo "Approve login through your Okta Verify Mobile App"
    fi
}

get_vault_auth_method () {
    if [ -z ${VAULT_AUTH_METHOD} ]; then
        echo "Enter an authentication method (Examples: okta, userpass): "
        read VAULT_AUTH_METHOD
    fi
    if [[ ${VAULT_AUTH_METHOD} != "okta" ]] && [[ ${VAULT_AUTH_METHOD} != "userpass" ]]; then
        echo "Invalid auth method.  Options: [okta, userpass]"
        exit 1
    fi
}

get_secret_engine () {
    if [ -z ${SECRET_ENGINE} ]; then
        echo "Enter a Secret Engine (Example: databases): "
        read SECRET_ENGINE
    fi
}

get_secret_name () {
    if [ -z ${SECRET} ]; then
        echo "Enter a Secret (Example: mysql): "
        read SECRET
    fi
}

get_policy_name () {
    if [ -z ${POLICY_NAME} ]; then
        echo "Enter a Policy Name (Example: mysql-ro): "
        read POLICY_NAME
    fi
}

get_policy_path () {
    if [ -z ${POLICY_PATH} ]; then
        echo "Enter a Policy Path (Example: databases/mysql-dev): "
        read POLICY_PATH
    fi
}

get_policy_capabilities () {
    if [ -z ${POLICY_CAPABILITIES} ]; then
        echo "Enter a Policy Capability (Example: create, list, read): "
        read POLICY_CAPABILITIES
    fi
}

get_new_username () {
    if [ -z ${NEW_USERNAME} ]; then
        echo "Enter a New Username (Example: mysql-ro): "
        read NEW_USERNAME
    fi
}

get_new_password () {
    if [ -z ${NEW_PASSWORD} ]; then
        echo "Enter a New Password (Example: ********): "
        read NEW_PASSWORD
    fi
}

###################################
# Action/Command Helper Functions #
###################################
get_token () {
    get_vault_url
    get_vault_auth_method
    get_vault_username
    get_vault_password
    TOKEN=$(curl -sk \
        --request POST \
        --data "{\"password\": \"${VAULT_PASSWORD}\"}" \
        https://${VAULT_URL}/v1/auth/${VAULT_AUTH_METHOD}/login/${VAULT_USERNAME} \
            | grep -o '"client_token":"[a-z.A-Z0-9]*' | cut -d '"' -f4
    )
}

display_token () {
    echo "${TOKEN}"
}

list_secrets () {
    get_secret_engine
    curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        --request LIST \
        https://${VAULT_URL}/v1/${SECRET_ENGINE}/metadata \
            | grep -o "\[.*\]"
}

get_secret () {
    get_secret_engine
    get_secret_name
    OUTPUT=$(curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        https://${VAULT_URL}/v1/${SECRET_ENGINE}/data/${SECRET}
    )
    if ! [ -z ${KEY} ];then
        OUTPUT=$(echo "${OUTPUT}" \
            | sed "s/.*\"${KEY}\":\"//g" \
            | sed "s/\"},\"metadata\":.*//g" \
            | sed 's/\\\"/"/g'
        )
    fi
    echo "${OUTPUT}"
}

add_secret () {
    get_secret_engine
    get_secret_name
    curl \
        --header "X-Vault-Token: ${TOKEN}" \
        --request POST \
        --data $DATA \
        https://${VAULT_URL}/v1/${SECRET_ENGINE}/${${SECRET}}
}

list_users () {
    curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        --request LIST \
        https://${VAULT_URL}/v1/auth/userpass/users \
            | grep -o '\[.*\]'
}

add_service_policy () {
    get_policy_name
    get_policy_path
    get_policy_capabilities
    curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        --request PUT \
        --data "{\"policy\": \"path \"${POLICY_PATH}\" {capabilities = [${POLICY_CAPABILITIES}]\"}" \
        https://${VAULT_URL}/v1/sys/policy/${POLICY_NAME}
}

add_service_user () {
    get_new_username
    get_new_password
    get_policy_name
    curl -sk \
        --header "X-Vault-Token: ${TOKEN}" \
        --request POST \
        --data "{\"password\": \"${NEW_PASSWORD}\",\"policies\": \"${POLICY_NAME}\"}" \
        https://${VAULT_URL}/v1/auth/userpass/users/${NEW_USERNAME}
}

#################
# Main Function #
#################
if [ -z $1 ]; then echo "Invalid argument."; fi

while [[ "$#" -gt 0 ]]; do
    case $1 in
        display_token         ) ACTION="display_token"            ;;
        list_secrets          ) ACTION="list_secrets"             ;;
        get_secret            ) ACTION="get_secret"               ;;
        add_secret            ) ACTION="add_secret"               ;;
        list_users            ) ACTION="list_users"               ;;
        add_service_policy    ) ACTION="add_service_policy"       ;;
        add_service_user      ) ACTION="add_service_user"         ;;
        -w|--website|--url    ) VAULT_URL="$2"           ; shift  ;;
        -a|--auth-method      ) VAULT_AUTH_METHOD="$2"   ; shift  ;;
        -u|--username         ) VAULT_USERNAME="$2"      ; shift  ;;
        -p|--password         ) VAULT_PASSWORD="$2"      ; shift  ;;
        -e|--secret-engine    ) SECRET_ENGINE="$2"       ; shift  ;;
        -s|--secret           ) SECRET="$2"              ; shift  ;;
        -k|--key              ) KEY="$2"                 ; shift  ;;
        -d|--data             ) DATA="$2"                ; shift  ;;
        --policy-name         ) POLICY_NAME="$2"         ; shift  ;;
        --policy-path         ) POLICY_PATH="$2"         ; shift  ;;
        --policy-capabilities ) POLICY_CAPABILITIES="$2" ; shift  ;;
        --new-username        ) NEW_USERNAME="$2"        ; shift  ;;
        --new-password        ) NEW_PASSWORD="$2"        ; shift  ;;
        * ) echo "[$0]: Unknown parameter passed: $1"    ; exit 1 ;;
    esac
    shift
done

get_token
$ACTION
