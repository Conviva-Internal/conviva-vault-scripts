# conviva-vault-scripts
Wrappers for common Vault functions

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

### Example
```
read -s VAULT_PASS
read -s VAULT_USER
wget https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh
chmod +x vault.sh
./vault.sh \
    get_secret \
    -w vault.prod.conviva.com \
    -u ${VAULT_USER}  \
    -a okta \
    -p ${VAULT_PASS} \
    -e techops \
    -s godaddy \
    -k password
```
