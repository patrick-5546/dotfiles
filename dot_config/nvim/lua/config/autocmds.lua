-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Additional cpp files
vim.cmd("autocmd BufRead,BufNewFile *.llc_repl set filetype=cpp")
vim.cmd("autocmd BufRead,BufNewFile *.bpred set filetype=cpp")
