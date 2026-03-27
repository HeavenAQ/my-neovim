return {
  {
    "neovim/nvim-lspconfig",
    opts = {
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
