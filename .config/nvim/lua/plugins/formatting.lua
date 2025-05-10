local prettier = { "prettier" }

local prettier_langs = {
  "json",
  "jsonc",
  "yaml",
  "markdown",
  "html",
  "css",
  "scss",
  "sass",
  "vue",
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
}

local prettier_opts = {}
for _, lang in ipairs(prettier_langs) do
  prettier_opts[lang] = prettier
end

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = prettier_opts,
    },
  },
}
