return {
  {
    -- https://github.com/folke/tokyonight.nvim
    "folke/tokyonight.nvim",
    opts = {
      -- set style to night
      style = "night",

      -- make background transparent
      -- https://www.lazyvim.org/configuration/recipes#make-tokyonight-transparent
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
