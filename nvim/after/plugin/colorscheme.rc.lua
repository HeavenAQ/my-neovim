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

require("tokyonight").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  light_style = "day", -- The theme is used when the background is set to light
  transparent = true, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,
})

function Color(color)
    color = color or "kanagawa-wave"
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#58AFDD", bg = "none" })
    vim.api.nvim_set_hl(0, "HarpoonBorder", { fg = "#58AFDD", bg = "none" })
    vim.api.nvim_set_hl(0, "@function.macro", { fg = "#FF5D63" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#AAB0D6", bg = "none" })
    vim.api.nvim_set_hl(0, "Search", { fg = "black", bg = "#FF9A59" })
    vim.api.nvim_set_hl(0, "CurSearch", { fg = "black", bg = "#FF9A59" })
    vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#9BDDCC", bg = "none", bold = true })
    vim.api.nvim_set_hl(0, "PmenuSel", { fg = "black", bg = "#9BDDCC" })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "None" })
    vim.api.nvim_set_hl(0, "@string.escape", { fg="#6FB5CC" })
    vim.api.nvim_set_hl(0, "@string.special", { fg="#6FB5CC" })
    vim.api.nvim_set_hl(0, "@operator", { fg="#FF5D63"})
    vim.api.nvim_set_hl(0, "@text.emphasis", { fg = "#FF9A59", italic = true })
end

Color()


-- NOTE: Material settings
local status, material = pcall(require, "material")
if (not status) then return end

vim.g.material_style = "deep ocean"
material.setup({

    lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )
})
