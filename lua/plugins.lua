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
    use "MunifTanjim/prettier.nvim" -- Prettier

    -- LSP Support
    use "neovim/nvim-lspconfig"             -- Required
    use "williamboman/mason.nvim"           -- Optional
    use "williamboman/mason-lspconfig.nvim" -- Optional

    -- Autocompletion
    use "hrsh7th/nvim-cmp"         -- Required
    use "hrsh7th/cmp-nvim-lsp"     -- Required
    use "hrsh7th/cmp-buffer"       -- Optional
    use "hrsh7th/cmp-path"         -- Optional
    use "saadparwaiz1/cmp_luasnip" -- Optional
    use "hrsh7th/cmp-nvim-lua"     -- Optional

    -- Debugging
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use "folke/neodev.nvim"

    -- Snippets
    use "L3MON4D3/LuaSnip"             -- Required
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
    use "nanotee/sqls.nvim"
    use "jsborjesson/vim-uppercase-sql"
    use "Vimjas/vim-python-pep8-indent"
    use "lukas-reineke/indent-blankline.nvim"
    use "dkarter/bullets.vim"

    use "lewis6991/gitsigns.nvim"
    use "dinhhuy258/git.nvim" -- For git blame & browse
    use 'ThePrimeagen/git-worktree.nvim'
    use "tpope/vim-surround"
    use "ThePrimeagen/harpoon"
    use "zbirenbaum/copilot.lua"
    use "rebelot/kanagawa.nvim"
    use "donRaphaco/neotex"
    use "jmarkow/vim-matlab"
    use {
        'iamcco/markdown-preview.nvim',
        run = 'cd app && yarn install'
    }
    use {
        "michaelb/sniprun", run = "bash ./install.sh"
    }
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
        end,
    }

    use {
        "numToStr/Comment.nvim",
        requires = { "JoosepAlviste/nvim-ts-context-commentstring", }
    }
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
    }
    use {
        "ziontee113/color-picker.nvim",
        config = function()
            require("color-picker")
        end,
    }
    use {
        "glacambre/firenvim",
        run = function()
            vim.fn["firenvim#install"](0)
        end,
    }
    use {
        "nvim-neorg/neorg",
        config = function()
            require('neorg').setup {
                load = {
                    ["core.defaults"] = {},       -- Loads default behaviour
                    ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
                    ["core.norg.dirman"] = {      -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                        },
                    },
                },
            }
        end,
        run = ":Neorg sync-parsers",
        requires = "nvim-lua/plenary.nvim",
    }
end)
