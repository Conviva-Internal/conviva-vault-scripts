# conviva-vault-scripts
Wrappers for common Vault functions

## Terminology
| Term          | Description                                                            |
| -             | -                                                                      |
| secret        | Encrypted data stored in Vault that can be decrypted by authentication |
| secret_engine | The Key/Value table containing a list of secrets                       |

## Usage
```
./vault.sh [action] [argument]
```

| Action |
| -      |



| Argument |
| -        |

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
