if true then return {} end

return {
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    -- defaults: https://www.lazyvim.org/plugins/treesitter#nvim-treesitter
    -- opts = function(_, opts)
    --   if type(opts.ensure_installed) == "table" then
    --     vim.list_extend(opts.ensure_installed, { "verilog" })
    --   end
    -- end,
  },
}
