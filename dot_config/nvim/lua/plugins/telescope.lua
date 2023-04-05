-- https://github.com/LazyVim/LazyVim/discussions/338#discussioncomment-5109479
local Util = require("lazyvim.util")
return {
  {
    -- https://github.com/nvim-telescope/telescope.nvim
    "telescope.nvim",
    keys = {
      -- mimic vs code quick open
      { "<C-p>", Util.telescope("find_files") },
    },
  },
}
