local status, packer = pcall(require, "packer")
if not status then
    print("Packer is not installed")
    return
end
vim.cmd([[packadd packer.nvim]])

packer.startup(function(use)
    use "wbthomason/packer.nvim"

    -- UI
    use "folke/tokyonight.nvim"
    use 'feline-nvim/feline.nvim'
    use 'RRethy/vim-illuminate'
    use "nvim-lua/plenary.nvim"     -- Common utilities
    use "onsails/lspkind-nvim"      -- vscode-like pictograms
    use 'echasnovski/mini.nvim'
    use "nvimdev/lspsaga.nvim"         -- LSP UIs
    use "akinsho/nvim-bufferline.lua"
    use "preservim/nerdcommenter"
    use "folke/neodev.nvim"
    use "ARM9/arm-syntax-vim"

    -- LSP Support
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use  {"folke/trouble.nvim", requires ={"nvim-tree/nvim-web-devicons"}}

    -- Debugging
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }

    -- Snippets
    use "kyazdani42/nvim-web-devicons" -- File icons
    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-file-browser.nvim"
    use "windwp/nvim-autopairs"
    use "windwp/nvim-ts-autotag"
    use "norcalli/nvim-colorizer.lua"
    use "folke/zen-mode.nvim"
    use "mfukar/robotframework-vim"
    use "dkarter/bullets.vim"
    use 'jose-elias-alvarez/null-ls.nvim'
    use "lewis6991/gitsigns.nvim"
    use "dinhhuy258/git.nvim" -- For git blame & browse
    use 'ThePrimeagen/git-worktree.nvim'
    use "tpope/vim-surround"
    use "ThePrimeagen/harpoon"
    use "zbirenbaum/copilot.lua"
    use 'simrat39/rust-tools.nvim'
    use "rebelot/kanagawa.nvim"
    use 'dhruvasagar/vim-table-mode'
    use 'CodeFalling/fcitx-vim-osx'
    use { "catppuccin/nvim", as = "catppuccin" }
    use 'iamcco/markdown-preview.nvim'
    use 'nvim-treesitter/playground'
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'
    use 'RaafatTurki/hex.nvim'
    use 'segeljakt/vim-silicon'
    use { "rest-nvim/rest.nvim", requires = { "nvim-lua/plenary.nvim" },}
    use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}
    --use 'luk400/vim-jukit'
    use 'APZelos/blamer.nvim'

    use {
        "kevinhwang91/nvim-ufo",
        requires = {
            "kevinhwang91/promise-async",
            "luukvbaal/statuscol.nvim",
        }
    }
    use({
        "folke/noice.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    })
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
    }
    use {
        "glacambre/firenvim",
        run = function()
            vim.fn["firenvim#install"](0)
        end,
    }

end)
