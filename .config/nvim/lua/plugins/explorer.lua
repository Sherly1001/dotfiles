return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      indent = {
        animate = { enabled = false },
      },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            auto_close = true,
          },
          files = { hidden = true },
        },
      },
    },
  },
}
