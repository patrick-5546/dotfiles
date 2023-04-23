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

-- Shortcut to use blackhole register by default
vim.keymap.set("n", "d", '"_d', { noremap = true })
vim.keymap.set("v", "d", '"_d', { noremap = true })
vim.keymap.set("n", "D", '"_D', { noremap = true })
vim.keymap.set("v", "D", '"_D', { noremap = true })
vim.keymap.set("n", "c", '"_c', { noremap = true })
vim.keymap.set("v", "c", '"_c', { noremap = true })
vim.keymap.set("n", "C", '"_C', { noremap = true })
vim.keymap.set("v", "C", '"_C', { noremap = true })
vim.keymap.set("n", "x", '"_x', { noremap = true })
vim.keymap.set("v", "x", '"_x', { noremap = true })
vim.keymap.set("n", "X", '"_X', { noremap = true })
vim.keymap.set("v", "X", '"_X', { noremap = true })

-- Shortcut to use clipboard with <leader>
vim.keymap.set("n", "<leader>d", "d", { noremap = true })
vim.keymap.set("v", "<leader>d", "d", { noremap = true })
vim.keymap.set("n", "<leader>D", "D", { noremap = true })
vim.keymap.set("v", "<leader>D", "D", { noremap = true })
vim.keymap.set("n", "<leader>c", "c", { noremap = true })
vim.keymap.set("v", "<leader>c", "c", { noremap = true })
vim.keymap.set("n", "<leader>C", "C", { noremap = true })
vim.keymap.set("v", "<leader>C", "C", { noremap = true })
vim.keymap.set("n", "<leader>x", "x", { noremap = true })
vim.keymap.set("v", "<leader>x", "x", { noremap = true })
vim.keymap.set("n", "<leader>X", "X", { noremap = true })
vim.keymap.set("v", "<leader>X", "X", { noremap = true })
