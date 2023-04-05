return {
  {
    -- https://github.com/williamboman/mason.nvim
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSPs
        "bash-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "lua-language-server",
        "pyright",

        -- non-python linters
        "markdownlint",

        -- non-python formatters
        "shfmt",
        "stylua",
      },
    },
  },
}
