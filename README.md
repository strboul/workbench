# workbench

## Setup

Set a directory to clone this repository, and then change directory into the
`workbench` folder.

```sh
echo 'export WORKBENCH_PATH="$HOME/.../workbench"' | tee -a "$HOME/.zshenv" "$HOME/.bash_profile"
git clone https://github.com/strboul/workbench.git "$WORKBENCH_PATH"
cd "$WORKBENCH_PATH"
```

Recommended steps to install the parts in the following order.

1. Install core `system/.../core`,

2. Link dotfiles `files` with `./files/symlink`.

3. Configure main system `system/.../main`.

## Development

- Run `pre-commit install` that installs the hook scripts at `.git/hooks`.
