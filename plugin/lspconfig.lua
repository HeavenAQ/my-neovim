--vim.lsp.set_log_level("debug")

local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local protocol = require('vim.lsp.protocol')

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local enable_format_on_save = function(_, bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end,
    })
end

-- setup lsp format plugin
local status_2, lsp_format = pcall(require, "lsp-format")
if (not status_2) then return end 
lsp_format.setup{}

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    --local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    --buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    --buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.offsetEncoding = { "utf-8" }

nvim_lsp.jdtls.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities,
    root_dir = function() return vim.loop.cwd() end,
}

nvim_lsp.tsserver.setup {
    on_attach = lsp_format.on_attach,
    cmd = { "typescript-language-server", "--stdio" },
    capabilities = capabilities
}

nvim_lsp.clangd.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities,
    cmd = { "clangd", "--offset-encoding=utf-16", "--clang-tidy", "--enable-config" },
    root_dir = function() return vim.loop.cwd() end,
}

--html
nvim_lsp.html.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities,
    filetypes = { 'html', 'htmldjango' }
}

--python
nvim_lsp.pyright.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities,
}

--gopls
nvim_lsp.gopls.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities,
    root_dir = function() return vim.loop.cwd() end,
}

nvim_lsp.robotframework_ls.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities,
    root_dir = function() return vim.loop.cwd() end,
}

nvim_lsp.sourcery.setup({
    init_options = {
        token = 'user_d9P2twMyl7H2kLjwNBZVll8moWwuctO08KKdm70SREj_r6dV5CMtCCYDlxQ',
        extension_version = 'vim.lsp',
        editor_version = 'vim'
    },

    --- the rest of your options...
})

nvim_lsp.tailwindcss.setup {}


nvim_lsp.bashls.setup {
    on_attach = lsp_format.on_attach,
    capabilities = capabilities,
    root_dir = function() return vim.loop.cwd() end,
}

--nvim_lsp.cssls.setup {
--on_attach = on_attach,
--capabilities = capabilities
--}

--nvim_lsp.astro.setup {
--on_attach = on_attach,
--capabilities = capabilities
--}

--nvim_lsp.sqls.setup {
--on_attach = on_attach,
--}

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = "??? ", Warn = "??? ", Hint = "??? ", Info = "??? " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Show source in diagnostics, not inline but as a floating popup
vim.diagnostic.config({
    virtual_text = {
        prefix = '???'
    },
    update_in_insert = true,
    float = {
        source = "always", -- Or "if_many"
    },
})

vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
