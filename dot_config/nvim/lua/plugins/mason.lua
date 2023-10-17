return {
  {
    -- https://github.com/williamboman/mason.nvim
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- registry: https://mason-registry.dev/registry/list

        -- LSPs
        "bash-language-server",
        "clangd",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "lua-language-server",
        "pyright",
        "rust-analyzer",
        "taplo",
        "verible",
        "yaml-language-server",

        -- linters
        "actionlint",
        "markdownlint",
        "mypy",
        "ruff",
        "yamllint",

        -- formatters
        "black",
        "clang-format",
        "shfmt",
        "stylua",
        "yamlfmt",
      },
    },
  },
}
