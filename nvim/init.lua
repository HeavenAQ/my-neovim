-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.neovim_mode = vim.env.NEOVIM_MODE or "default"

require("config.lazy")

-- remove nvim-cmp background color
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })

-- disable winbar color
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })

-- change comment colors
vim.api.nvim_set_hl(0, "Comment", { fg = "#717161", italic = true })
vim.cmd([[
        au BufNewFile,BufRead *.s,*.S set filetype=arm " arm = armv6/7
    ]])

-- remove background color for git signs and fold column
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#FFE073" })

-- remove background color for inlay hints
vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "none", fg = "#717161" })

-- mark nvim diff fg red
vim.api.nvim_set_hl(0, "DiffText", { fg = "#ff6660" })
-- Set transparent background for the Pmenu (completion menu) and PmenuSel (selected item)
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none", fg = "#CBE0F0", blend = 0 })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#275378", fg = "#FFFFFF", blend = 0 }) -- or set bg to "none" if you want it fully transparent

vim.cmd([[
  let g:loaded_ruby_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_node_provider = 0
]])

if vim.g.neovide then
  vim.o.guifont = "PlemolJP:i:h14"
  vim.g.neovide_transparency = 0.8
  vim.g.neovide_show_border = false
  vim.g.neovide_hide_mouse_when_typing = true
end

if vim.g.neovim_mode == "skitty" then
  vim.wait(500, function()
    return false
  end)
  -- Disable line numbers
  vim.opt.number = false
  vim.opt.relativenumber = false

  -- Disable the status line
  vim.opt.laststatus = 0

  -- Disable the command line
  vim.opt.cmdheight = 0
end
