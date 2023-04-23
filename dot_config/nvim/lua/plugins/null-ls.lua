return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- registry: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md

          -- linters
          nls.builtins.diagnostics.actionlint,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.ruff,
          nls.builtins.diagnostics.yamllint,

          -- formatters
          nls.builtins.formatting.black,
          nls.builtins.formatting.ruff,
          nls.builtins.formatting.rustfmt,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.yamlfmt,
        },
      }
    end,
  },
}
