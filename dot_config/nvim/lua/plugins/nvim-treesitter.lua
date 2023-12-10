return {
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults: https://www.lazyvim.org/plugins/treesitter#nvim-treesitter
        "bash",
        "c",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
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
        "dockerfile",
        "jsonc",
        "rust",
        "verilog",
      },
    },
  },
}
