-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.neovim_mode = vim.env.NEOVIM_MODE or "default"

require("config.lazy")

vim.cmd([[
  let g:loaded_ruby_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_node_provider = 0
]])


if vim.g.neovide then
  vim.o.guifont = "PlemolJP:i:h14"
  vim.g.neovide_opacity = 0.85
  vim.g.neovide_show_border = false
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_floating_corner_radius = 0.3
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

-- Force lualine to have no background regardless of theme/load order
local function set_lualine_transparent()
  local function set_bg_none(group)
    pcall(vim.api.nvim_set_hl, 0, group, { bg = "NONE" })
  end

  -- Generic statusline groups
  set_bg_none("StatusLine")
  set_bg_none("StatusLineNC")

  -- Lualine section groups across modes
  local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }
  local sections = { "a", "b", "c", "x", "y", "z" }
  for _, m in ipairs(modes) do
    for _, s in ipairs(sections) do
      set_bg_none(string.format("lualine_%s_%s", s, m))
    end
  end

  -- Also clear any transitional highlight groups created by lualine
  local ok, groups = pcall(vim.fn.getcompletion, "lualine", "highlight")
  if ok then
    for _, g in ipairs(groups) do
      set_bg_none(g)
    end
  end
end

-- Apply on startup and whenever colorscheme changes (after lualine/themes load)
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  callback = function()
    vim.schedule(set_lualine_transparent)
  end,
})
