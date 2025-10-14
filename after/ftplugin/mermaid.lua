vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = false
vim.opt_local.spell = true

vim.bo.makeprg = "mmdc -i % -o %:r.svg"
