local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

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

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap = true, silent = true }

    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
end


-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').default_capabilities()

nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
    capabilities = capabilities
}

nvim_lsp.lua_ls.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        enable_format_on_save(client, bufnr)
    end,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
        },
    },
}
nvim_lsp.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "clangd", "--offset-encoding=utf-16", "--clang-tidy", "--enable-config" },
    root_dir = function() return vim.loop.cwd() end,
}

--html
nvim_lsp.html.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { 'html', 'htmldjango' }
}

--python
nvim_lsp.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

--gopls
nvim_lsp.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function() return vim.loop.cwd() end,
}

nvim_lsp.robotframework_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function() return vim.loop.cwd() end,
}

nvim_lsp.sourcery.setup({
    init_options = {
        token = 'user_d9P2twMyl7H2kLjwNBZVll8moWwuctO08KKdm70SREj_r6dV5CMtCCYDlxQ',
        extension_version = 'vim.lsp',
        editor_version = 'vim'
    },
})

nvim_lsp.tailwindcss.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

nvim_lsp.bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = function() return vim.loop.cwd() end,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "" },
        severity_sort = true,
    }
)

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end


vim.diagnostic.config({
    virtual_text = {
        prefix = ''
    },
    float = {
        source = "always", -- Or "if_many"
    },
})