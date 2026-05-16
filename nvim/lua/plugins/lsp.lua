return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      codelens = {
        enabled = true,
      },
      servers = {
        sqls = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
      },
    },
  },
}
