local status, n = pcall(require, "tokyonight")
if (not status) then return end

n.setup({
  comment_italics = true,
})

vim.cmd(([[
  colorscheme tokyonight-night
  highlight NormalFloat guibg=NONE
	hi RegistersWindow ctermbg=NONE
  highlight Normal guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  set fillchars+=vert:\│
  highlight WinSeparator gui=NONE guibg=NONE guifg=#444444 cterm=NONE ctermbg=NONE ctermfg=gray
  highlight VertSplit gui=NONE guibg=NONE guifg=#444444 cterm=NONE ctermbg=NONE ctermfg=gray
  highlight! link SignColumn LineNr
  highlight Pmenu guibg=#363948
  highlight PmenuSbar guibg=#363948
  highlight link CmpPmenuBorder NonText
  highlight link TelescopeBorder Constant
  hi CursorLineNR guifg= #35f3da
]]))
