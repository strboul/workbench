# git

## User

Set user email and user name in every repo (only `--local`).

```sh
git config --local user.name "<name>"
git config --local user.email "<email>"
```

## Remote

Fetch and push with multiple remotes.

```sh
git remote add all git@github.com:strboul/workbench.git
git remote set-url --add all <remote-ssh>
git push all --all
```

## SSH signing

Sign commits with the SSH key.

```sh
git config --local gpg.format ssh
git config --local user.signingkey <path-to-keyfile>
git config --local commit.gpgsign true
```

If you get this error, create a file keeping the allowed signers.

> error: gpg.ssh.allowedSignersFile needs to be configured and exist for ssh signature verification

```sh
(mkdir -p ~/.config/git && touch ~/.config/git/allowed_signers) \
  && echo "$(git config --local user.email) namespaces=\"git\" $(cat </path-to-keyfile>)" >> ~/.config/git/allowed_signers
git config --local gpg.ssh.allowedSignersFile "$HOME/.config/git/allowed_signers"
```

## PGP/GPG

Sign commits with PGP/GPG key.

```sh
git config --local user.signingkey <GPG-SIGN-KEY>
```

If you disable it in a repo.

```sh
git config --local commit.gpgsign false
```

If you temporarily disable it for next commit.

```sh
git commit --no-gpg-sign
# or
git -c commit.gpgsign=false commit
```
