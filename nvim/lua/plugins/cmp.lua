return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind-nvim",
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      -- Set up a custom highlight group for color items
      local function formatForTailwindCSS(entry, vim_item)
        if vim_item.kind == "Color" and type(entry.completion_item.documentation) == "string" then
          -- Match a valid hex color code (e.g., #RRGGBB)
          local color = entry.completion_item.documentation:match("#%x%x%x%x%x%x")
          if not color then
            print("No valid color found in documentation")
            return vim_item
          end

          local group = "Tw_" .. color:gsub("#", "")

          if vim.fn.hlID(group) < 1 then
            -- Dynamically create a highlight group with the parsed color
            vim.api.nvim_set_hl(0, group, { fg = color })
          end

          vim_item.kind = "●"
          vim_item.kind_hl_group = group -- Use the dynamic highlight group
          return vim_item
        end

        -- Fallback formatting
        vim_item.kind = lspkind.symbolic(vim_item.kind) or vim_item.kind
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
          expandable_indicator = true,
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
    end,
  },
}
