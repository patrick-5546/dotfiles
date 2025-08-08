return {
  {
    "nvim-lualine/lualine.nvim",
    -- https://www.lazyvim.org/plugins/ui#lualinenvim
    -- https://github.com/LazyVim/LazyVim/discussions/3010#discussioncomment-13666237
    opts = function(_, opts)
      opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path({
        length = 8,
      }) }
    end,
  },
}
