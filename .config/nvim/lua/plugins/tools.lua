local text_case_maps = {
  ["u"] = "to_upper_case",
  ["l"] = "to_lower_case",
  ["s"] = "to_snake_case",
  ["d"] = "to_dash_case",
  ["n"] = "to_constant_case",
  ["."] = "to_dot_case",
  [","] = "to_comma_case",
  ["a"] = "to_phrase_case",
  ["c"] = "to_camel_case",
  ["p"] = "to_pascal_case",
  ["t"] = "to_title_case",
  ["f"] = "to_path_case",
}

local function upper(key)
  if key == "." then
    return ">"
  elseif key == "," then
    return "<"
  else
    return string.upper(key)
  end
end

local text_case_keys = {}
for _, method in ipairs({ "current_word", "lsp_rename", "visual" }) do
  for key, command in pairs(text_case_maps) do
    local k = key
    if method == "lsp_rename" then
      k = upper(key)
    end

    local mode = { "n" }
    if method == "visual" then
      mode = { "v" }
    end

    table.insert(text_case_keys, {
      "ga" .. k,
      function()
        require("textcase")[method](command)
      end,
      mode = mode,
      desc = method .. " " .. command,
    })
  end
end

return {
  {
    "johmsalas/text-case.nvim",
    lazy = true,
    keys = text_case_keys,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    lazy = true,
    dependencies = {
      {
        "tpope/vim-dadbod",
        lazy = true,
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        lazy = true,
        ft = { "sql", "mysql", "plsql" },
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_execute_on_save = 0
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    opts = {},
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
