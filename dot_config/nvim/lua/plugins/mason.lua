return {
  {
    -- https://github.com/williamboman/mason.nvim
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- registry: https://mason-registry.dev/registry/list

        -- LSPs and linters and formatters
        "verible",

        -- LSPs
        "bash-language-server",
        "clangd",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "gopls",
        "jdtls",
        "lua-language-server",
        "pyright",
        "rust-analyzer",
        "taplo",
        "yaml-language-server",

        -- linters and formatters
        "markdownlint",

        -- linters
        "checkstyle",
        "flake8",
        "mypy",
        "yamllint",

        -- formatters
        "black",
        "clang-format",
        "google-java-format",
        "isort",
        "shfmt",
        "stylua",
        "yamlfmt",
      },
    },
  },
}
