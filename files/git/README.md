# git

This document is follows the `.gitconfig`. The things defined there are not
repeated here.

## User

Set user email and user name in every repo (only `--local`).

```sh
git config --local user.name "<name>"
git config --local user.email "<email>"
```

## Remote

List the remotes.

```sh
git remote -v
```

Fetch and push with multiple remotes.

```sh
git remote add second git@github.com:strboul/workbench.git
git push second
```

## Signing

Provide the user signing key locally to the repo.

```sh
git config --local user.signingkey <path-privkey>
```

The public key selected for signing have to exist in the
`gpg.ssh.allowedSignersFile` file.

Disable signing requirement for a repo.

```sh
git config --local commit.gpgsign false
```
