local status, noice = pcall(require, "noice")
noice.setup({
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true -- add a border to hover docs and signature help
    },
    cmdline = {
        format = {
            -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
            -- view: (default is cmdline view)
            -- opts: any options passed to the view
            -- icon_hl_group: optional hl_group for the icon
            -- title: set to anything or empty string to hide
            cmdline = {pattern = "^:", icon = "", lang = "vim"},
            search_down = {
                kind = "search",
                pattern = "^/",
                icon = "",
                lang = "regex"
            },
            search_up = {
                kind = "search",
                pattern = "^%?",
                icon = "",
                lang = "regex"
            },
            filter = {pattern = "^:%s*!", icon = "$", lang = "bash"},
            lua = {
                pattern = {"^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*"},
                icon = "",
                lang = "lua"
            },
            help = {pattern = "^:%s*he?l?p?%s+", icon = ""},
            input = {} -- Used by input()
            -- lua = false, -- to disable a format, set to `false`
        }
    }
})
vim.keymap.set("c", "<S-Enter>",
               function() require("noice").redirect(vim.fn.getcmdline()) end,
               {desc = "Redirect Cmdline"})
