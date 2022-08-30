# git

## Identity

Set user email and user name in every repo (only `--local`):

```sh
git config --local user.name "<name>"
git config --local user.email "<email>"
```

## GnuPG

Sign your commits with your GPG key:

```sh
git config --local user.signingkey <GPG-SIGN-KEY>
```

If you disable it in a repo:

```sh
git config --local commit.gpgsign false
```

If you temporarily disable it for next commit:

```sh
git commit --no-gpg-sign
# or
git -c commit.gpgsign=false commit
```
