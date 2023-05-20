local status, packer = pcall(require, "packer")
if not status then
    print("Packer is not installed")
    return
end
vim.cmd([[packadd packer.nvim]])

packer.startup(function(use)
    use "wbthomason/packer.nvim"
    use "marko-cerovac/material.nvim"
    use "folke/tokyonight.nvim"
    use "nvim-lualine/lualine.nvim" -- Statusline
    use "nvim-lua/plenary.nvim"     -- Common utilities
    use "onsails/lspkind-nvim"      -- vscode-like pictograms

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

    -- Debugging
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use "folke/neodev.nvim"

    -- Snippets
    use "glepnir/lspsaga.nvim"         -- LSP UIs
    use "kyazdani42/nvim-web-devicons" -- File icons
    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-file-browser.nvim"
    use "windwp/nvim-autopairs"
    use "windwp/nvim-ts-autotag"
    use "norcalli/nvim-colorizer.lua"
    use "folke/zen-mode.nvim"
    use "akinsho/nvim-bufferline.lua"
    use "preservim/nerdcommenter"
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
    -- Packer
    use({
      "folke/noice.nvim",
      requires = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
        }
    })
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
        end,
    }

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
