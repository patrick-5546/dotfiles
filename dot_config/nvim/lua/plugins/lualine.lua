return {
  {
    "nvim-lualine/lualine.nvim",
    -- https://www.lazyvim.org/plugins/ui#lualinenvim
    opts = {
      sections = {
        lualine_c = {
          LazyVim.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = LazyVim.config.icons.diagnostics.Error,
              warn = LazyVim.config.icons.diagnostics.Warn,
              info = LazyVim.config.icons.diagnostics.Info,
              hint = LazyVim.config.icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path({ length = 8 }) },
        },
      },
    },
  },
}
