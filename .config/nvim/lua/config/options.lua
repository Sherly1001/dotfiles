-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local g = vim.g
local opt = vim.opt
local is_mac = vim.fn.has("unix") and vim.fn.system("uname -s"):gsub("%s+", "") == "Darwin"

opt.clipboard = ""

opt.listchars = {
  tab = "»»",
  trail = "·",
  nbsp = "×",
  precedes = "❮",
  extends = "❯",
}

if g.neovide then
  g.neovide_input_macos_option_key_is_meta = "only_left"

  g.neovide_refresh_rate = 60
  g.neovide_refresh_rate_idle = 5

  g.neovide_cursor_antialiasing = true
  g.neovide_cursor_animation_length = 0.13
  g.neovide_cursor_vfx_opacity = 500.0
  g.neovide_cursor_vfx_mode = "railgun"
  g.neovide_cursor_vfx_particle_density = 10.0

  opt.guifont = "SauceCodePro Nerd Font Mono:h8"
  if is_mac then
    opt.guifont = "SauceCodePro Nerd Font Mono:h13"
  end
end
