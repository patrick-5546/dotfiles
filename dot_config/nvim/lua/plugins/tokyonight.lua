return {
  {
    -- https://github.com/folke/tokyonight.nvim
    "folke/tokyonight.nvim",
    opts = {
      style = "night",

      -- https://www.lazyvim.org/configuration/recipes#make-tokyonight-transparent
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
