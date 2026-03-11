return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      local ensure = {
        "basedpyright", -- modern Pyright fork with inlay hints
        -- "pyright",   -- uncomment if you prefer upstream pyright
        "ruff",        -- ruff LSP (renamed from ruff_lsp)
      }
      for _, s in ipairs(ensure) do
        if not vim.tbl_contains(opts.ensure_installed, s) then
          table.insert(opts.ensure_installed, s)
        end
      end
      return opts
    end,
  },
}
