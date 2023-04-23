-- https://github.com/LazyVim/LazyVim/discussions/338#discussioncomment-5109479
local Util = require("lazyvim.util")
return {
  {
    -- https://github.com/nvim-telescope/telescope.nvim
    "telescope.nvim",
    keys = {
      -- show hidden files when searching files
      { "<leader><space>", Util.telescope("files", { hidden = true }), desc = "Find Files (root dir)" },
      { "<leader>ff", Util.telescope("files", { hidden = true }), desc = "Find Files (root dir)" },
      { "<leader>fF", Util.telescope("files", { hidden = true, cwd = false }), desc = "Find Files (cwd)" },
      -- mimic vs code quick open
      { "<C-p>", Util.telescope("files", { hidden = true }), desc = "Find Files (root dir)" },
    },
  },
}
