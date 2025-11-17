return {
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "both",
        separator_style = "slant",
        always_show_bufferline = true,
        sort_by = "insert_after_current",
      },
    },
    keys = {
      { "<a-s-h>", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "<a-s-l>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
      { "<c-s-h>", "<cmd>tabmove -1<cr>", desc = "Move tab prev" },
      { "<c-s-l>", "<cmd>tabmove +1<cr>", desc = "Move tab next" },
      { "<leader><tab>c", "<cmd>windo bwipeout<cr>", desc = "Close tab and tab's buffers" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_z = opts.sections.lualine_y
      opts.sections.lualine_y = {}
    end,
  },
}
