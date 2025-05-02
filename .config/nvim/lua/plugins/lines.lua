return {
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "both",
        separator_style = "slant",
        -- always_show_bufferline = true,
      },
    },
    keys = {
      { "<a-s-h>", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "<a-s-l>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_z = opts.sections.lualine_y
      opts.sections.lualine_y = opts.sections.lualine_x
      opts.sections.lualine_x = {}
    end,
  },
}
