if true then return {} end

return {
  {
    -- https://github.com/williamboman/mason.nvim
    "mason-org/mason.nvim",
    -- enabled = false,
    -- registry: https://mason-registry.dev/registry/list
    -- opts = function(_, opts)
    --   opts.ensure_installed = opts.ensure_installed or {}
    --   vim.list_extend(opts.ensure_installed, { "verible", "bash-language-server", "lua-language-server" })
    -- end,
  },
}
