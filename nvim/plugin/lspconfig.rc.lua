local status, nvim_lsp = pcall(require, "lsp-zero")
if (not status) then return end

nvim_lsp.preset("recommended")
nvim_lsp.ensure_installed({
    "bashls", "clangd", "cssls", "gopls", "dockerls", "pyright", "tailwindcss",
    "tsserver", "astro", "eslint", "html"
})

-- vim.lsp.set_log_level("debug")
nvim_lsp.on_attach(function(bufnr)
    -- disable lsp highlight
    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()
    local opts = {buffer = bufnr, silent = true, remap = true}
    vim.keymap.set('n', 'fl', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
end)

-- Fix Undefined global 'vim'
nvim_lsp.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            }
        }
    }
})

-- custom config for lsp 

-- clangd
nvim_lsp.configure('clangd', {
    cmd = {
        "clangd", "--clang-tidy", "--offset-encoding=utf-16", "--enable-config"
    }
})

require("clangd_extensions").setup()

-- tailwindcss
nvim_lsp.configure('tailwindcss', {
    -- There add every filetype you want tailwind to work on
    filetypes = {
        "css", "scss", "sass", "postcss", "html", "javascript",
        "javascriptreact", "typescript", "typescriptreact", "svelte", "vue",
        "rust"
    },
    init_options = {
        -- There you can set languages to be considered as different ones by tailwind lsp I guess same as includeLanguages in VSCod
        userLanguages = {rust = "html"}
    }
})

-- assembly
nvim_lsp.configure('asm_lsp', {filetypes = {"asm", "s", "S"}})

-- Diagnostic symbols in the sign column (gutter)
nvim_lsp.set_preferences({
    suggest_lsp_server = false,
    sign_icons = {error = " ", warn = " ", hint = " ", info = " "}
})

-- Path: plugin/null-ls.rc.lua
nvim_lsp.setup()

-- override default diagnostic symbols
vim.diagnostic.config({
    virtual_text = {prefix = "", spacing = 4},
    underline = true,
    update_in_insert = true,
    float = {source = "always"}
})

local status3, null_ls = pcall(require, "null-ls")
if (not status3) then return end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client) return client.name == "null-ls" end,
        bufnr = bufnr
    })
end

null_ls.setup {
    sources = {
        null_ls.builtins.formatting.black, null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.pg_format,
        null_ls.builtins.formatting.rustywind,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.clang_check,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.clang_format.with({
            extra_args = {
                "-style",
                "{BasedOnStyle: llvm, IndentWidth: 4, BreakBeforeBraces: Linux, AccessModifierOffset: -4}"
            }
        }), null_ls.builtins.formatting.rustfmt.with({
            extra_args = function(params)
                local Path = require("plenary.path")
                local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

                if cargo_toml:exists() and cargo_toml:is_file() then
                    for _, line in ipairs(cargo_toml:readlines()) do
                        local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
                        if edition then
                            return {"--edition=" .. edition}
                        end
                    end
                end
                -- default edition when we don't find `Cargo.toml` or the `edition` in it.
                return {"--edition=2021"}
            end
        })
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function() lsp_formatting(bufnr) end
            })
        end
    end
}
