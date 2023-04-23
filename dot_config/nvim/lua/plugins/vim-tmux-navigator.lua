return {
  {
    -- https://github.com/christoomey/vim-tmux-navigator
    "christoomey/vim-tmux-navigator",
    keys = {
      -- overwrite lazyvim mappings with vim-tmux-navigator mappings
      -- https://github.com/christoomey/vim-tmux-navigator/blob/master/plugin/tmux_navigator.vim
      -- https://github.com/LazyVim/LazyVim/discussions/277#discussioncomment-5004092
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", noremap = true, silent = true, desc = "Go to left window" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", noremap = true, silent = true, desc = "Go to lower window" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", noremap = true, silent = true, desc = "Go to upper window" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", noremap = true, silent = true, desc = "Go to right window" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", noremap = true, silent = true, desc = "Go to previous window" },
    },
  },
}
