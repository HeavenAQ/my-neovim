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
    --floats = "transparent", -- style for floating windows
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
    undercurl = true,           -- enable undercurls
    commentStyle = { italic = false },
    functionStyle = {},
    keywordStyle = { italic = false},
    statementStyle = { bold = true },
    typeStyle = {},
    variablebuiltinStyle = { italic = false},
    specialReturn = true,       -- special highlight for the return keyword
    specialException = true,    -- special highlight for exception handling keywords
    transparent = true,        -- do not set background color
    dimInactive = false,        -- dim inactive window `:h hl-NormalNC`
    globalStatus = false,       -- adjust window separators highlight for laststatus=3
    terminalColors = true,      -- define vim.g.terminal_color_{0,17}
    theme = "default"           -- Load "default" theme or the experimental "light" theme
})

function Color(color)
  color = color or "kanagawa"
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg="none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg="none" })
  vim.api.nvim_set_hl(0, "CursorLineNR", { fg="#D2CEB3" })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { fg="#D2CEB3", bg="none" })
  vim.api.nvim_set_hl(0, "HarpoonBorder", { fg="#D2CEB3", bg="none" })
  vim.api.nvim_set_hl(0, "LineNR", { fg="#6e87b9" })
end

Color()


-- NOTE: Material settings
local status, material = pcall(require, "material")
if (not status) then return end

vim.g.material_style = "deep ocean"
material.setup({

    --contrast = {
        --terminal = true, -- Enable contrast for the built-in terminal
        --sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        --floating_windows = true, -- Enable contrast for floating windows
        --cursor_line = true, -- Enable darker background for the cursor line
        --non_current_windows = true, -- Enable darker background for non-current windows
        --filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
    --},

    --styles = { -- Give comments style such as bold, italic, underline etc.
        --variables = {},
        --operators = {},
        --types = {},
    --},

    --plugins = { -- Uncomment the plugins that you use to highlight them
        ---- Available plugins:
        --"dap",
        ----"dashboard",
        --"gitsigns",
        --"hop",
        --"indent-blankline",
        --"lspsaga",
        --"mini",
        --"neogit",
        --"nvim-cmp",
        --"nvim-navic",
        --"nvim-tree",
        --"nvim-web-devicons",
        --"sneak",
        --"telescope",
        --"trouble",
        --"which-key",
    --},

    --disable = {
        --colored_cursor = false, -- Disable the colored cursor
        --borders = true, -- Disable borders between verticaly split windows
        --background = true, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
        --term_colors = false, -- Prevent the theme from setting terminal colors
        --eob_lines = false -- Hide the end-of-buffer lines
    --},

    --high_visibility = {
        --lighter = false, -- Enable higher contrast text for lighter style
        --darker = true -- Enable higher contrast text for darker style
    --},

    lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )

    --async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)

    --custom_colors = nil, -- If you want to everride the default colors, set this to a function

    --custom_highlights = {}, -- Overwrite highlights with your own
})
--vim.cmd([[
  --colorscheme material
  --highlight! link SignColumn LineNr
  --highlight link CmpPmenuBorder NonText
  --highlight link TelescopeBorder Constant
  --hi CursorLineNR guifg= #35f3da
--]])
