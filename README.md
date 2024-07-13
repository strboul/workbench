# workbench

- Reproducible working environment

- Save all configurations as plain text and keep them under version control.

- Full responsibility over what's added and removed. Never copy any config
  blindly.

- Stick to defaults but customize as necessary. Keep customization minimal to
  ensure operability in any environment.

- "Unix is my IDE"

- Consider the [Lindy effect](https://en.wikipedia.org/wiki/Lindy_effect)
  before introducing new tools or configurations.

## Setup

Set a directory to clone this repository, and then change directory into the
`workbench` folder.

```sh
echo 'export WORKBENCH_PATH="$HOME/.../workbench"' | tee -a "$HOME/.zshenv" "$HOME/.bash_profile"
git clone https://github.com/strboul/workbench.git "$WORKBENCH_PATH"
cd "$WORKBENCH_PATH"
```

Recommended steps to install the parts in the following order.

1. Install core `system/.../core`

2. Link dotfiles `files` by running `./files/symlink`

3. Configure main system `system/.../main`

## Development

<details>

Check `setup.md` for more information.

</details>
