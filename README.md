# dotfiles

My custom config files

## Setup

Clone this repository into your home (`$HOME/`) directory, and then change
directory into the `dotfiles` folder. After all, execute the script that
creates the symbolic links.

```bash
git clone https://github.com/strboul/dotfiles.git "$HOME"/dotfiles
cd "$HOME"/dotfiles && ./.symlinks
```

## Development

- Run `pre-commit install` that installs the hook scripts at `.git/hooks`.
