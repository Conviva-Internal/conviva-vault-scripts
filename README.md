# conviva-vault-scripts
Wrappers for common Vault functions (https://www.vaultproject.io/api)

## Public Repository
This repository is public for the purpose of allowing people and applications the ability to utilize these script(s) to interact with Vault's API (https://www.vaultproject.io/api) without needing to authenticate with Github.  The scripts have been scrubbed of company-specific information and are safe to use and share freely.

## Usage
```
./vault.sh [action] [argument]
```

### Action: get_secret
| Argument | Description                            |
| -        | -                                      |
| -w       | Vault's URL                            |
| -a       | Authentication method [okta, userpass] |
| -u       | Okta (or service) username             |
| -p       | Okta (or service) password             |
| -e       | Secret engine                          |
| -s       | Secret name                            |
| -k       | Key for the value you wish to retrieve |

### Examples
```
echo "Username: "
read VAULT_USER
echo "Password: "
read -s VAULT_PASS
curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh > vault.sh
chmod +x vault.sh
./vault.sh \
    get_secret \
    -w vault.environment.company.tld \
    -a okta \
    -u ${VAULT_USER}  \
    -p ${VAULT_PASS} \
    -e mysql \
    -s mysql-1 \
    -k password
```

```
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh )
```


