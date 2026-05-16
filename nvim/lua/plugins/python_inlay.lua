return {
  -- Configure Pyrefly as the Python type-checking LSP.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}

      opts.servers.pyrefly = vim.tbl_deep_extend("force", opts.servers.pyrefly or {}, {
        init_options = {
          pyrefly = {
            typeCheckingMode = "auto",
            analysis = {
              diagnosticMode = "openFilesOnly",
              inlayHints = {
                callArgumentNames = "all",
                functionReturnTypes = true,
                pytestParameters = false,
                variableTypes = true,
              },
            },
          },
        },
      })

      return opts
    end,
  },
}
