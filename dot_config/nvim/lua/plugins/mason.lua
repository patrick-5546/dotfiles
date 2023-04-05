return {
  {
    -- https://github.com/williamboman/mason.nvim
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSPs: if I need linting/formatting I will use VS Code
        "bash-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "lua-language-server",
        "pyright",

        -- formatters that LSPs use
        "stylua",
      },
    },
  },
}
