local Util = require("lazyvim.util")
return {
  {
    "telescope.nvim",
    keys = {
      -- mimic vs code quick open
      { "<C-p>", Util.telescope("find_files") },
    },
  },
}
