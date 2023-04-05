-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- resume telescope search
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { noremap = true, silent = true, desc = "Resume" }
)

-- overwrite lazyvim mappings with vim-tmux-navigator mappings
-- https://github.com/christoomey/vim-tmux-navigator/blob/master/plugin/tmux_navigator.vim
-- https://github.com/LazyVim/LazyVim/discussions/277#discussioncomment-5004092
vim.cmd([[
  noremap <silent> <C-h> :<C-U>TmuxNavigateLeft<cr>
  noremap <silent> <C-j> :<C-U>TmuxNavigateDown<cr>
  noremap <silent> <C-k> :<C-U>TmuxNavigateUp<cr>
  noremap <silent> <C-l> :<C-U>TmuxNavigateRight<cr>
  noremap <silent> <C-\> :<C-U>TmuxNavigatePrevious<cr>
]])
