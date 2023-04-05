return {
  {
    -- https://github.com/projekt0n/github-nvim-theme
    "projekt0n/github-nvim-theme",
    opts = {
      -- make background transparent
      transparent = true,
    },
    config = function(_, opts)
      require("github-theme").setup(opts)
    end,
  },

  -- configure LazyVim to load github_dark_default
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark_default",
    },
  },
}
