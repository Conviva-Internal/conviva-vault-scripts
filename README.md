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

### Examples
```
echo "Username: "
read VAULT_USER
echo "Password: "
read -s VAULT_PASS
wget https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh
chmod +x vault.sh
./vault.sh \
    get_secret \
    -w vault.prod.conviva.com \
    -a okta \
    -u ${VAULT_USER}  \
    -p ${VAULT_PASS} \
    -e techops \
    -s godaddy \
    -k password
```

```
echo "Username: "; read VAULT_USER; echo "Password: "; read -s VAULT_PASS; bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) get_secrets -w vault.prod.conviva.com -a okta -u ${VAULT_USER}  -p ${VAULT_PASS} -e techops -s godaddy -k password
```


