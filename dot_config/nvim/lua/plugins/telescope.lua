-- https://github.com/LazyVim/LazyVim/discussions/338#discussioncomment-5109479
return {
  {
    -- https://github.com/nvim-telescope/telescope.nvim
    "telescope.nvim",
    keys = {
      -- show hidden files when searching files
      { "<leader><space>", LazyVim.pick("auto", { hidden = true }), desc = "Find Files (Root Dir)" },
      { "<leader>ff", LazyVim.pick("auto", { hidden = true }), desc = "Find Files (Root Dir)" },
      { "<leader>fF", LazyVim.pick("auto", { hidden = true, root = false }), desc = "Find Files (cwd)" },
      -- mimic vs code quick open
      { "<C-p>", LazyVim.pick("auto", { hidden = true }), desc = "Find Files (Root Dir)" },
    },
    opts = {
      defaults = {
        -- search contents of hidden files
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob",
          "!{**/.git/*,**/node_modules/*,**/pkg/mod/*,**/yarn.lock,**/.local/*}",
        },
      },
    },
  },
}
