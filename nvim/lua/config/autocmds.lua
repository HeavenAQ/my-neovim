-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Autocmds are automatically loaded on the VeryLazy event
-- Add any additional autocmds here

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = "set nopaste" })

vim.opt.formatoptions:remove({ "o" }) -- O and o, don't continue comments
vim.opt.formatoptions:append({ "r" })

-- Define a custom sign with a right arrow
vim.cmd([[
  sign define currentline text=󰆧 texthl=Keyword
]])

-- Config tabwidth when editing js related files
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript",
    "typescript",
    "typescriptreact",
    "html",
    "css",
    "scss",
    "json",
    "yaml",
    "markdown",
    "astro",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

local function update_line_indicator()
  -- Remove existing signs to clear previous indicators
  vim.fn.sign_unplace("currentlinegroup", { buffer = "%" })

  -- Get the current line number
  local current_line = vim.api.nvim_win_get_cursor(0)[1]

  -- Place the right arrow sign at the current line
  vim.fn.sign_place(0, "currentlinegroup", "currentline", "%", { lnum = current_line })
end

-- Setup an autocmd to update the line indicator on cursor movements
vim.api.nvim_create_autocmd(
  { "CursorMoved", "CursorMovedI", "InsertLeave" },
  { pattern = "*", callback = update_line_indicator }
)

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
