return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      local function formatForTailwindCSS(entry, vim_item)
        if vim_item.kind == "Color" and entry.completion_item.documentation then
          local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
          if r then
            local color = string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
            local group = "Tw_" .. color
            if vim.fn.hlID(group) < 1 then
              vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
            end
            vim_item.kind = "●"
            vim_item.kind_hl_group = group
            return vim_item
          end
        end
        vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
        return vim_item
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
        }),
        completion = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          scrollbar = "║",
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lsp_signature_help" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            maxwidth = 50,
            before = function(entry, vim_item)
              vim_item = formatForTailwindCSS(entry, vim_item)
              return vim_item
            end,
          }),
        },
      })

      -- Example LSP setup (pyright)
      local nvim_lsp = require("lspconfig")
      nvim_lsp.pyright.setup({
        on_attach = function(client, bufnr)
          local opts = { noremap = true, silent = true }
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        end,
        flags = {
          debounce_text_changes = 150,
        },
      })
    end,
  },
}
