-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- remove nvim-cmp background color
vim.api.nvim_set_hl(0, "CmpNormal", { bg = "none" })

-- highlight words during visual mode
vim.api.nvim_set_hl(0, "Visual", { bg = "#ffffff" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1c1c1c" })
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#1c1c4a" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#717161" })

-- disable winbar color
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })

-- change comment colors
vim.api.nvim_set_hl(0, "Comment", { fg = "#717161", italic = true })
vim.cmd([[
        au BufNewFile,BufRead *.s,*.S set filetype=arm " arm = armv6/7
    ]])

-- remove background color for git signs and fold column
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#FFE073" })

-- remove background color for inlay hints
vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "none", fg = "#713031" })
