local lspstt_ok, lspstt, status_progress = pcall(require, 'lsp-status')
if lspstt_ok then status_progress = lspstt.status_progress end

local function DBUI() return 'DBUI' end

local setups = {
  ['nvim-autopairs'] = {
    map_c_w = true,
  },
  ['nvim-ts-autotag'] = {},
  ['ibl'] = {},
  ['Comment'] = {},
  ['nvim-treesitter.configs'] = {
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  },
  ['lualine'] = {
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', { 'diagnostics', update_in_insert = true } },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { status_progress, 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {
      lualine_a = {},
      lualine_b = { {
        'tabs',
        mode = 1,
        max_length = vim.o.columns,
        symbols = {
          modified = '',
        },
        fmt = function(_, context)
          return Funcs.tabname(context.tabnr)
        end,
      } },
      lualine_c = {},
      lualine_x = {},
      lualine_y = { 'Funcs.pertab()' },
      lualine_z = {}
    },
    extensions = { 'quickfix', 'nerdtree', 'ctrlspace', 'mason', 'fugitive', 'fzf', {
      filetypes = { 'dbui' },
      sections = {
        lualine_a = { DBUI },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { DBUI },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
    } },
  },
}

for plug, setup in pairs(setups) do
  local plug_ok, plug_setup = pcall(require, plug)
  if plug_ok then
    plug_setup.setup(setup)
  end
end
