-- NOTE: tokyonight settings

--local status, n = pcall(require, "tokyonight")
--if (not status) then return end

--n.setup({
--comment_italics = true,
--transparent = true,
--style = "night",
--styles = {
---- Style to be applied to different syntax groups
---- Value is any valid attr-list value for `:help nvim_set_hl`
--comments = { italic = false },
--keywords = { italic = false },
--functions = { bold = true },
--variables = { bold = true },
---- Background styles. Can be "dark", "transparent" or "normal"
--sidebars = "transparent", -- style for sidebars, see below
--floats = "transparent",   -- style for floating windows
--},
--on_highlights = function(hl, c)
--hl.TelescopeNormal = {
--bg = "NONE",
--fg = c.fg_dark,
--}
--hl.TelescopeBorder = {
--bg = "NONE",
--}
--end,
--})

-- Default options:
local status, kanagawa = pcall(require, "kanagawa")
if (not status) then return end

kanagawa.setup({
    compile = true,
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { bold = true },
    statementStyle = { bold = true },
    typeStyle = {},
    variablebuiltinStyle = { bold = false },
    specialReturn = true,    -- special highlight for the return keyword
    specialException = true, -- special highlight for exception handling keywords
    transparent = true,      -- do not set background color
    dimInactive = false,     -- dim inactive window `:h hl-NormalNC`
    globalStatus = false,    -- adjust window separators highlight for laststatus=3
    terminalColors = true,   -- define vim.g.terminal_color_{0,17}
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        }
    },
})

function Color(color)
    color = color or "kanagawa-wave"
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#FF5D63", bg = "none" })
    vim.api.nvim_set_hl(0, "HarpoonBorder", { fg = "#FF5D63", bg = "none" })
    vim.api.nvim_set_hl(0, "@function.macro", { fg = "#FF5D63" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#AAB0D6", bg = "none" })
    vim.api.nvim_set_hl(0, "Search", { fg = "black", bg = "#FF9A59" })
    vim.api.nvim_set_hl(0, "CurSearch", { fg = "black", bg = "#FF9A59" })
    vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#9BDDCC", bg = "none", bold = true })
    vim.api.nvim_set_hl(0, "PmenuSel", { fg = "black", bg = "#9BDDCC" })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "None" })
end

Color()


-- NOTE: Material settings
local status, material = pcall(require, "material")
if (not status) then return end

vim.g.material_style = "deep ocean"
material.setup({

    lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )
})
