return {
  {
    -- https://github.com/windwp/nvim-spectre
    "windwp/nvim-spectre",
    keys = {
      { "<leader>sp", function() require("spectre").open_file_search() end, desc = "Replace in current file (Spectre)" },
    },
  },
}
