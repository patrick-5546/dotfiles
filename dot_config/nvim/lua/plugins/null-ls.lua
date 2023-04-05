return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- linters
          nls.builtins.diagnostics.flake8,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.mypy,

          -- formatters
          nls.builtins.formatting.black,
          nls.builtins.formatting.isort,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },
}
