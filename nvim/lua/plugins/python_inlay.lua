return {
  -- Ensure Python LSP exposes inlay hints and enable useful defaults
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}

      local use_based = vim.fn.executable("basedpyright-langserver") == 1

      -- Configure Pyright as fallback (enabled unless basedpyright is present)
      opts.servers.pyright = use_based and { enabled = false } or {
        settings = {
          python = {
            analysis = {
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
                parameterTypes = true,
                callArgumentNames = "all",
              },
            },
          },
        },
      }

      -- Configure BasedPyright when available
      opts.servers.basedpyright = {
        settings = {
          basedpyright = {
            inlayHints = {
              variableTypes = true,
              functionReturnTypes = true,
              parameterTypes = true,
              callArgumentNames = true,
            },
            analysis = {
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
                parameterTypes = true,
                callArgumentNames = true,
              },
            },
          },
        },
      }

      return opts
    end,
  },
}
