# conviva-vault-scripts
Wrappers for common Vault functions

## Terminology
| Term          | Description                                                            |
| -             | -                                                                      |
| secret        | Encrypted data stored in Vault that can be decrypted by authentication |
| secret_engine | The Key/Value table containing a list of secrets                       |

## Usage
Choose one action, and add any optional arguments.  If you do not choose an optional argument you will ebe give a prompt to fill in the apropriate information.

| Arguments | 

| Action/Command   | Optional Arguments    | Example                                                                                                                                 |
| -                | -                     | -                                                                                                                                       |
| get_token        |
| list_secrets     | secret_engine         | `bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) list_secrets secret_engine` |
| get_secret       | secret_engine, secret | `bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) get_secret secret_engine secret`
| add_secret       | secret_engine, secret | TBD
| list_users       | 
| add_service_user |


### list_secrets [secret-engine]
With engine argument:
```shell
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) list_secrets services

curl -L https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh | bash -s -- 
```

Without engine argument:
```shell
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) list_secrets
```

Sample Output:
```shell
["Apple", "Dell", "Microsoft"]
```

### get_secret [secret-engine secret-name]
With engine and secret arguments:
```shell
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) get_secret services service
```

Without and secret arguments:
```shell
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) get_secret
```

Sample Output:
```json
{"request_id":"********","lease_id":"********","renewable":false,"lease_duration":0,"data":{"data":{"password":"********","username":"********"},"metadata":{"created_time":"********","deletion_time":"","destroyed":false,"version":1}},"wrap_info":null,"warnings":null,"auth":null}
```

### add_secret

### list_users

### add_service_user
