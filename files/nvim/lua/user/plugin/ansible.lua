local augroup_ansible = vim.api.nvim_create_augroup("Ansible", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Autodetect ansible file types",
  group = augroup_ansible,
  pattern = {
    "*/playbooks/*.yml",
  },
  command = "set filetype=yaml.ansible",
})
