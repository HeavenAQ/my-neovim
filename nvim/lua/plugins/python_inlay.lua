return {
  -- Configure Pyrefly as the Python type-checking LSP.
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}

      opts.servers.ruff = vim.tbl_deep_extend("force", opts.servers.ruff or {}, { enabled = false })
      opts.servers.ruff_lsp = vim.tbl_deep_extend("force", opts.servers.ruff_lsp or {}, { enabled = false })

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
            typeCheckingMode = "default",
            runnableCodeLens = true,
            analysis = {
              diagnosticMode = "openFilesOnly",
              inlayHints = inlay_hints,
            },
          },
        },
        settings = {
          python = {
            analysis = {
              inlayHints = inlay_hints,
            },
          },
          pyrefly = {
            analysis = {
              inlayHints = inlay_hints,
            },
          },
        },
      })

      return opts
    end,
  },
}
