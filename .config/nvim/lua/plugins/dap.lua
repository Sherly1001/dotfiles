return {
  {
    "mfussenegger/nvim-dap",
    init = function()
      local dap = require("dap")

      dap.adapters.php = {
        type = "executable",
        command = "bun",
        args = { vim.fn.expand("$HOME") .. "/.local/share/nvim/dap/vscode-php-debug/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          name = "Listen for Xdebug",
          type = "php",
          request = "launch",
          port = 9000,
          hostname = "0.0.0.0",
          pathMappings = {
            ["/var/www/html/comet/"] = "${workspaceFolder}",
          },
        },
      }
    end,
  },
}
