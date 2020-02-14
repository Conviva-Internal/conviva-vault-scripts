# conviva-vault-scripts
Wrappers for common Vault functions

## Usage

### list_secrets
With engine argument:
```
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) list_secrets services
```

Without engine argument:
```
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) list_secrets
```

Sample Output:
```
["Apple", "Dell", "Microsoft"]
```

### get_secret
With engine and secret arguments:
```
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) get_secret services service
```

Without and secret arguments:
```
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) get_secret
```

Sample Output:
```
{"request_id":"********","lease_id":"********","renewable":false,"lease_duration":0,"data":{"data":{"password":"********","username":"********"},"metadata":{"created_time":"********","deletion_time":"","destroyed":false,"version":1}},"wrap_info":null,"warnings":null,"auth":null}
```

### add_secret

### list_users

### add_service_user
