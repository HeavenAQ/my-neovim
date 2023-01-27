local status, n = pcall(require, "tokyonight")
if (not status) then return end

n.setup({
  comment_italics = true,
  transparent = true,
  on_highlights = function(hl, c)
    hl.TelescopeNormal = {
      bg = "NONE",
      fg = c.fg_dark,
    }
    hl.TelescopeBorder = {
      bg = "NONE",
    }
  end,
})


vim.cmd([[
  colorscheme tokyonight-night
  highlight! link SignColumn LineNr
  highlight link CmpPmenuBorder NonText
  highlight link TelescopeBorder Constant
  hi CursorLineNR guifg= #35f3da
]])
