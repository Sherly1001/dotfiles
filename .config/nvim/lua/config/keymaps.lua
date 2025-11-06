-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.api.nvim_set_keymap
local command = vim.api.nvim_create_user_command

local opts = { noremap = true, silent = false }
local opts_sl = { noremap = true, silent = true }

keymap("i", "<c-cr>", "<esc>A", opts_sl)
keymap("i", "<s-cr>", "<esc>A;<esc>", opts_sl)

for _, mode in pairs({ "i", "c", "t" }) do
  keymap(mode, "<c-s-v>", "<c-r><c-o>+", opts)
  keymap(mode, "<s-insert>", "<c-r><c-o>+", opts)
  keymap(mode, "<d-v>", "<c-r><c-o>+", opts)
end

keymap("t", "<c-s-v>", '<c-\\><c-n>"+pi', opts)
keymap("t", "<d-v>", '<c-\\><c-n>"+pi', opts)
keymap("t", "<a-\\>", "<c-\\><c-n>", opts)
keymap("t", "<a-p>", "<c-\\><c-n>pi", opts)

keymap("v", "<c-c>", '"+y', opts_sl)
keymap("v", "<c-x>", '"+x', opts_sl)

command("CopyFilePath", function()
  local file_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", file_path)
  print("Copied file path to clipboard: " .. file_path)
end, {})

command("CopyRelativeFilePath", function()
  local file_path = vim.fn.expand("%:.")
  vim.fn.setreg("+", file_path)
  print("Copied relative file path to clipboard: " .. file_path)
end, {})
