-- vi: ts=2 sw=2

local vue_language_server_path = vim.fn.expand('$HOME/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server')

local function ignore_default_formatter(client)
  local rc = client.server_capabilities
  rc.documentFormattingProvider = false
  rc.documentRangeFormattingProvider = false
end

local prettier_fmt = {
  formatCommand = 'prettier --stdin-filepath ${INPUT}',
  formatStdin = true,
}

local python_fmt = {
  formatCommand = 'yapf --quiet',
  formatStdin = true,
}

local langs = {
  typescript = { prettier_fmt },
  javascript = { prettier_fmt },
  typescriptreact = { prettier_fmt },
  javascriptreact = { prettier_fmt },
  ["typescript.tsx"] = { prettier_fmt },
  ["javascript.jsx"] = { prettier_fmt },
  vue = { prettier_fmt },
  yaml = { prettier_fmt },
  toml = { prettier_fmt },
  json = { prettier_fmt },
  jsonc = { prettier_fmt },
  html = { prettier_fmt },
  scss = { prettier_fmt },
  css = { prettier_fmt },
  markdown = { prettier_fmt },
  python = { python_fmt },
}

local lsp = {
  texlab = {},
  html = {},
  vls = {},
  gopls = {},
  pyright = {},
  clangd = {},
  bashls = {},
  intelephense = {},
  rust_analyzer = {},
  tailwindcss = {},
  jsonls = {
    on_attach = ignore_default_formatter,
    settings = {
      json = {
        schemas = {
          {
            fileMatch = { 'package.json' },
            url = 'https://json.schemastore.org/package.json',
          },
          {
            fileMatch = { 'jsconfig.json', 'jsconfig.app.json', 'jsconfig.node.json' },
            url = 'https://json.schemastore.org/jsconfig.json',
          },
          {
            fileMatch = { 'tsconfig.json', 'tsconfig.app.json', 'tsconfig.node.json' },
            url = 'https://json.schemastore.org/tsconfig.json',
          },
          {
            fileMatch = { 'prettierrc.json', '.prettierrc' },
            url = 'https://json.schemastore.org/prettierrc.json',
          },
        },
      },
    },
  },
  volar = {
    on_attach = ignore_default_formatter,
    settings = {
      volar = {
        useWorkspaceDependencies = true,
      },
    },
  },
  ts_ls = {
    on_attach = ignore_default_formatter,
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vue_language_server_path,
          languages = { 'vue' },
        },
      },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  },
  efm = {
    filetypes = vim.tbl_keys(langs),
    init_options = {
      documentFormatting = true,
    },
    settings = {
      languages = langs,
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
      },
    },
  },
}

return lsp
