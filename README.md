# conviva-vault-scripts
Wrappers for common Vault functions

## Usage
#### list_secrets
Return a list of secrets from a Secret Engine.
```
# Without supplied secret engine argument:
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) list_secrets 

# With secret engine argument:
bash <( curl -s https://raw.githubusercontent.com/Conviva-Internal/conviva-vault-scripts/master/vault.sh ) list_secrets {{secret_engine}}

# Sample Output:
["Apple", "Dell", "Microsoft"]
```
