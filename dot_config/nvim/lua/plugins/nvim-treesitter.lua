return {
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults: https://www.lazyvim.org/plugins/treesitter#nvim-treesitter
        "bash",
        "c",
        "html",
        "javascript",
        "json",
        "lua",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",

        -- additional
        "cmake",
        "cpp",
        "dockerfile",
      },
    },
  },
}
