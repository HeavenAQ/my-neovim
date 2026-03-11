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

-- (removed heavy current-line sign indicator for performance)

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

-- (removed CursorMoved autocmds that updated the sign continuously)

-- cmp: use terminal background (fully transparent)

-- keep cmp and floating windows transparent across themes
local function _set_float_transparent()
  -- Global float backgrounds transparent
  pcall(vim.api.nvim_set_hl, 0, "NormalFloat", { bg = "none" })

  -- Use a clear white border for all floats (hover, diagnostics, cmp)
  local border_fg = "#FFFFFF"
  pcall(vim.api.nvim_set_hl, 0, "FloatBorder", { bg = "none", fg = border_fg })

  -- nvim-cmp groups (if present)
  pcall(vim.api.nvim_set_hl, 0, "CmpBorder", { bg = "none", fg = border_fg })
  pcall(vim.api.nvim_set_hl, 0, "CmpNormal", { bg = "none" })
  -- blink.cmp groups (if present)
  pcall(vim.api.nvim_set_hl, 0, "BlinkCmpMenu", { bg = "none" })
  pcall(vim.api.nvim_set_hl, 0, "BlinkCmpMenuBorder", { bg = "none", fg = border_fg })
  pcall(vim.api.nvim_set_hl, 0, "BlinkCmpDoc", { bg = "none" })
  pcall(vim.api.nvim_set_hl, 0, "BlinkCmpDocBorder", { bg = "none", fg = border_fg })
  -- Popup menu rows to follow window background
  pcall(vim.api.nvim_set_hl, 0, "Pmenu", { bg = "none", blend = 0 })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = _set_float_transparent,
})

_set_float_transparent()

-- highlight words during visual mode
vim.api.nvim_set_hl(0, "Visual", { bg = "#ffffff" })
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

-- centralized additional highlights
vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "none", fg = "#717161" })
vim.api.nvim_set_hl(0, "DiffText", { fg = "#ff6660" })
-- Match cmp item rows to the cmp window background
-- selection color remains explicit
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#275378", fg = "#FFFFFF", blend = 0 })

-- Diagnostics styling: softer virtual text + colored undercurl
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "none", fg = "#ff6b6b" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "none", fg = "#ffd166" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "none", fg = "#56c7ff" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "none", fg = "#7bd88f" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ff6b6b" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#ffd166" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#56c7ff" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#7bd88f" })

-- LSP hover/docs: add borders (applies to `K` and diagnostics floats)
do
  if not vim.lsp.util._open_floating_preview_original then
    vim.lsp.util._open_floating_preview_original = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      return vim.lsp.util._open_floating_preview_original(contents, syntax, opts, ...)
    end
  end
  -- Also set diagnostic UI/behavior (signs, virtual text, floats)
  pcall(vim.diagnostic.config, {
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = {
      spacing = 2,
      source = "if_many",
      -- Pretty icons by severity
      prefix = function(diagnostic)
        local icons = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        }
        return icons[diagnostic.severity] or "●"
      end,
      -- Show code if available: "message [code]"
      format = function(d)
        local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code) or ""
        if code ~= "" then
          return string.format("%s [%s]", d.message, code)
        end
        return d.message
      end,
    },
    signs = true,
    float = {
      border = "rounded",
      focusable = false,
      source = "if_many",
      severity_sort = true,
      header = "",
      -- Indent items a bit and prefix with icons
      prefix = function(diagnostic)
        local icons = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = " ",
        }
        return string.format(" %s", icons[diagnostic.severity] or "● ")
      end,
    },
  })
  -- Define beautiful diagnostic signs in the sign column
  pcall(vim.fn.sign_define, "DiagnosticSignError", { text = "", texthl = "DiagnosticSignError", numhl = "" })
  pcall(vim.fn.sign_define, "DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn", numhl = "" })
  pcall(vim.fn.sign_define, "DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo", numhl = "" })
  pcall(vim.fn.sign_define, "DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint", numhl = "" })
  -- Ensure LSP handlers use borders
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

-- scope spell checking to text-like filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "norg", "org", "rmd", "latex" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Enable inlay hints for Python buffers when the server supports it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    if vim.bo[bufnr].filetype ~= "python" then
      return
    end
    local client = vim.lsp.get_client_by_id(args.data and args.data.client_id or 0)
    if not client then
      return
    end
    local supports = false
    if client.server_capabilities and client.server_capabilities.inlayHintProvider then
      supports = true
    elseif client.supports_method and client.supports_method("textDocument/inlayHint") then
      supports = true
    end
    if not supports then
      return
    end
    -- Neovim 0.10+: vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    -- Neovim 0.9: vim.lsp.buf.inlay_hint(bufnr, true)
    local ok = pcall(function()
      return vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end)
    if not ok then
      pcall(vim.lsp.buf.inlay_hint, bufnr, true)
    end
  end,
})

-- (tab grouping removed)

-- Breadcrumbs handled by Lspsaga (see lua/plugins/lspsaga.lua)

-- (tab filtering removed)

-- Scope buffer cycling to current tab's group
pcall(function()
  require("heaven.buffercycle").setup()
end)
