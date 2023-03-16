local status, cmp = pcall(require, "cmp")
if (not status) then return end


local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = ""
}


cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({
            -- this is the important line
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    completion = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, scrollbar = "║" },
    sources = cmp.config.sources({
        -- Copilot Source
        { name = "copilot",                group_dinex = 2 },

        -- Others
        { name = 'nvim_lsp' },
        { name = 'treesitter' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'path',                   option = { trailing_slash = true } },
        { name = 'nvim_lsp_signature_help' },
        { name = 'buffer' },
    }),
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Menu Icons
            vim_item.menu = ({
                    nvim_lsp = "",
                    nvim_lua = "",
                    luasnip = "",
                    buffer = "",
                    treesitter = "",
                    path = "",
                    nvim_lsp_signature_help = "",
                    copilot = "",
                })[entry.source.name]
            return vim_item
        end,
    },
})
