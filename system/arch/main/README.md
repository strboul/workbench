# main

[Ansible](https://www.ansible.com/) system configuration.

Be sure that you run the changes from the path:

```sh
cd system/.../main
```

## 1. Setup Ansible

Install Ansible and Ansible Galaxy requirements.

```sh
sudo pacman -S ansible
ansible-galaxy collection install -r ansible-galaxy.yml
```

## 2. Run

Run a playbook:

```sh
./workbench playbook base
./workbench playbook base --tags='base.fonts,base.pass'
```

Run a profile:

```sh
./workbench profile personal
```

Run with step:

```sh
./workbench profile personal --step
```

See more at:
<https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_startnstep.html#step-mode>

Helper commands to list the playbooks:
TODO

```sh
ansible-playbook main.yml --list-tasks
ansible-playbook main.yml --list-tags
```

## 3. Encrypted content

Some content is encrypted with `ansible-vault` passphrase, which is encrypted
with `gpg`.

### Encrypted files

```sh
ansible-vault encrypt --vault-password-file="$(git rev-parse --show-toplevel)/vault_pass.sh" <file_vault>
```

View/decrypt the encrypted files with `view`, `decrypt` respectively.

Edit the encrypted file with your favorite editor.

```sh
ansible-vault edit --vault-password-file="$(git rev-parse --show-toplevel)/vault_pass.sh" <file_vault>
```

#### Resources

- [Encrypting content with Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html)

- [Encrypting the Ansible Vault passphrase using GPG](https://disjoint.ca/til/2016/12/14/encrypting-the-ansible-vault-passphrase-using-gpg/)
