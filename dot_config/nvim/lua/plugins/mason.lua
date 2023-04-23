return {
  {
    -- https://github.com/williamboman/mason.nvim
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- registry: https://mason-registry.dev/registry/list

        -- LSPs
        "bash-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "lua-language-server",
        "pyright",
        "ruff-lsp",
        "rust-analyzer",
        "taplo",
        "yaml-language-server",

        -- linters
        "actionlint",
        "markdownlint",
        "ruff",
        "yamllint",

        -- formatters
        "black",
        "rustfmt",
        "shfmt",
        "stylua",
        "yamlfmt",
      },
    },
  },
}
