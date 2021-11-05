# bootstrap-oh-my-wsl

This is a shortcut to bootstrapping `unibuddly-labs/oh-my-wsl`. It doesn't do a lot other than ensure the repo is 
readable, and making sure that the local `$UBSRC` folder (or the default `/ub`) exists and has correct permissions.

See the source code in `start.sh` for details if you want to do things slightly differently, like using an existing SSH key,
creating a key with a passphrase, creating a keyt specific to `github.com`, and so on.

To run the simplified bootstrap into oh-my-wsl run:

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/unibuddy-labs/bootstrap-oh-my-wsl/main/start.sh)"
```
