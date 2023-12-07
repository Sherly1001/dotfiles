-- vi: ts=2 sw=2

local system_signs = require('settings.signs')

local cfg_ok, cfg = pcall(require, 'lspconfig')
local mason_ok, mason = pcall(require, 'mason')
local mason_lsp_ok, mason_lsp = pcall(require, 'mason-lspconfig')

if not cfg_ok or not mason_ok or not mason_lsp_ok then
  return
end

mason_lsp.setup()
mason.setup {
  ui = {
    border = 'rounded',
    icons = {
      package_pending = system_signs.pending,
      package_installed = system_signs.installed,
      package_uninstalled = system_signs.uninstalled,
    }
  }
}

-- setup lsp server
local cmp_ok, cmp = pcall(require, 'cmp')
local cap_ok, cap = pcall(require, 'cmp_nvim_lsp')

if not cmp_ok or not cfg_ok or not cap_ok then
  return
end

cap = cap.default_capabilities()
require('lspconfig.ui.windows').default_options.border = 'rounded'

local lsp = require('lsp.lsp')

local gopts = {
  capabilities = cap,
}

for name, opt in pairs(lsp) do
  if opt then
    opt = vim.tbl_deep_extend('force', gopts, opt)
  end

  cfg[name].setup(opt)
end

-- setup nvim-cmp
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  mapping = cmp.mapping.preset.insert({
    ['<c-space>'] = cmp.mapping.complete(),
    ['<cr>'] = cmp.mapping.confirm({ select = true }),

    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() and
          vim.tbl_contains({ 'html', 'css', 'xsl' }, vim.o.filetype) then
        feedkey('<Plug>(emmet-expand-abbr)', '')
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<s-tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 's' }),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'vsnip' },
    { name = 'omi' },
  }, {
    { name = 'path' },
    { name = 'buffer' },
  }, {
    { name = 'vim-dadbod-completion' },
  })
}

local signs = {
  { name = 'DiagnosticSignError', text = system_signs.error },
  { name = 'DiagnosticSignWarn',  text = system_signs.warn },
  { name = 'DiagnosticSignHint',  text = system_signs.hint },
  { name = 'DiagnosticSignInfo',  text = system_signs.info },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

local config = {
  virtual_text = false,
  update_in_insert = true,
  severity_sort = true,
  signs = {
    active = signs,
  },
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}

vim.diagnostic.config(config)

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = 'rounded',
  }
)
