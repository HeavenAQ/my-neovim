return {
  -- Configure Pyrefly as the Python type-checking LSP.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}

      local inlay_hints = {
        callArgumentNames = "all",
        functionReturnTypes = true,
        pytestParameters = false,
        variableTypes = true,
      }

      opts.servers.pyrefly = vim.tbl_deep_extend("force", opts.servers.pyrefly or {}, {
        init_options = {
          python = {
            analysis = {
              inlayHints = inlay_hints,
            },
          },
          pyrefly = {
            typeCheckingMode = "auto",
            analysis = {
              diagnosticMode = "openFilesOnly",
              inlayHints = inlay_hints,
            },
          },
        },
      })

      return opts
    end,
  },
}
