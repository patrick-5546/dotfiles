-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Shortcut to use blackhole register by default
vim.keymap.set("n", "d", '"_d', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "d", '"_d', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "D", '"_D', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "D", '"_D', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "c", '"_c', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "c", '"_c', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "C", '"_C', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "C", '"_C', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "x", '"_x', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "x", '"_x', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "X", '"_X', { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "X", '"_X', { noremap = true, desc = "which_key_ignore" })

-- Shortcut to use clipboard with <leader>
vim.keymap.set("n", "<leader>d", "d", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "<leader>d", "d", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>D", "D", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "<leader>D", "D", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>c", "c", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "<leader>c", "c", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>C", "C", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "<leader>C", "C", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>x", "x", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "<leader>x", "x", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>X", "X", { noremap = true, desc = "which_key_ignore" })
vim.keymap.set("v", "<leader>X", "X", { noremap = true, desc = "which_key_ignore" })
