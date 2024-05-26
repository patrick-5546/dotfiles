return {
  {
    -- https://github.com/stevearc/conform.nvim
    "stevearc/conform.nvim",
    -- enabled = false,
    -- opts = {
    --   formatters_by_ft = {
    --     c = { "clang_format" },
    --     cpp = { "clang_format" },
    --     lua = { "stylua" },
    --     markdown = { "markdownlint" },
    --     python = { "black", "isort" },
    --     sh = { "shfmt" },
    --     yaml = { "yamlfmt" },
    --   },
    --
    --   -- The options you set here will be merged with the builtin formatters.
    --   -- You can also define any custom formatters here.
    --   formatters = {
    --     -- # Example of using dprint only when a dprint.json file is present
    --     -- dprint = {
    --     --   condition = function(ctx)
    --     --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
    --     --   end,
    --     -- },
    --     --
    --     -- # Example of using shfmt with extra args
    --     -- shfmt = {
    --     --   prepend_args = { "-i", "2", "-ci" },
    --     -- },
    --     isort = {
    --       prepend_args = { "--profile", "black" },
    --     },
    --   },
    -- },
  },
}
