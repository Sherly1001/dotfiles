return {
  {
    "FabijanZulj/blame.nvim",
    event = "LazyFile",
    opts = {},
  },
  {
    "f-person/git-blame.nvim",
    event = "LazyFile",
    opts = {
      enabled = true,
      message_template = " <author> • <date> • <summary> • <<sha>>",
      date_format = "%r",
    },
  },
}
