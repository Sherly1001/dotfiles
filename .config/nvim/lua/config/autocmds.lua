-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable autoformat for php files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "php" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- PHP indentation settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    vim.opt.smartcase = false
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    vim.opt.smartcase = true
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  group = vim.api.nvim_create_augroup("RestoreCursorShape", { clear = true }),
  command = "set guicursor=a:hor100",
})
