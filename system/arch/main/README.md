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
ansible-galaxy collection install -r requirements.yml
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
