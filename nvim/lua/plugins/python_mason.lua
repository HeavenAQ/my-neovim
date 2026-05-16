return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      local ensure = {
        "pyrefly",
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
