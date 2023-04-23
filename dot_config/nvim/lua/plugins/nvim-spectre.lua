return {
  {
    -- https://github.com/nvim-pack/nvim-spectre
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>sp", function() require("spectre").open_file_search() end, desc = "Replace in current file (Spectre)" },
    },
  },
}
