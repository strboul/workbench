# workbench

## Setup

Clone this repository into your home (`$HOME/`) directory, and then change
directory into the `workbench` folder.

```sh
git clone https://github.com/strboul/workbench.git "$HOME"/workbench
cd "$HOME"/workbench
```

Recommended steps to install the parts in the following order.

1. Install core `system/.../core`,

2. Link dotfiles `files` with `./files/symlink`.

3. Configure main system `system/.../main`.

## Development

- Run `pre-commit install` that installs the hook scripts at `.git/hooks`.
