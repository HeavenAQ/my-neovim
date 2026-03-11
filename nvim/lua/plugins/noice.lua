return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.lsp = opts.lsp or {}
      opts.lsp.signature = opts.lsp.signature or {}
      opts.lsp.signature.enabled = false
    end,
  },
}
