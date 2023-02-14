local status, packer = pcall(require, "packer")
if not status then
  print("Packer is not installed")
  return
end
vim.cmd([[packadd packer.nvim]])

packer.startup(function(use)
  use("wbthomason/packer.nvim")
  use("marko-cerovac/material.nvim")
  use("folke/tokyonight.nvim")
  use("nvim-lualine/lualine.nvim") -- Statusline
  use("nvim-lua/plenary.nvim") -- Common utilities
  use("onsails/lspkind-nvim") -- vscode-like pictograms
  use("hrsh7th/cmp-buffer") -- nvim-cmp source for buffer words
  use("hrsh7th/cmp-nvim-lsp") -- nvim-cmp source for neovim's built-in LSP
  use("hrsh7th/nvim-cmp") -- Completion
  use("neovim/nvim-lspconfig") -- LSP
  use("MunifTanjim/prettier.nvim") -- Prettier
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("lukas-reineke/lsp-format.nvim")

  use('godlygeek/tabular')
  use("glepnir/lspsaga.nvim") -- LSP UIs
  use("kyazdani42/nvim-web-devicons") -- File icons
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-file-browser.nvim")
  use("windwp/nvim-autopairs")
  use("windwp/nvim-ts-autotag")
  use("norcalli/nvim-colorizer.lua")
  use("folke/zen-mode.nvim")
  use("akinsho/nvim-bufferline.lua")
  use("preservim/nerdcommenter")
  use("mfukar/robotframework-vim")
  use("nanotee/sqls.nvim")
  use("jsborjesson/vim-uppercase-sql")
  use("Vimjas/vim-python-pep8-indent")
  use("fatih/vim-go")
  use("lukas-reineke/indent-blankline.nvim")
  use('nvim-telescope/telescope-media-files.nvim')

  use("lewis6991/gitsigns.nvim")
  use("dinhhuy258/git.nvim") -- For git blame & browse
  use("tpope/vim-surround")
  use("hrsh7th/cmp-path")
  use("ThePrimeagen/harpoon")
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use("zbirenbaum/copilot.lua")
  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  }
  use("rebelot/kanagawa.nvim")
  use({ "michaelb/sniprun", run = "bash ./install.sh" })
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  })
  use({ "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" })
  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function() end,
  })

  use({ "numToStr/Comment.nvim", requires = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  } })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
  })
  use({
    "dsznajder/vscode-es7-javascript-react-snippets",
    run = "yarn install --frozen-lockfile && yarn compile",
  })
  use({
    "ziontee113/color-picker.nvim",
    config = function()
      require("color-picker")
    end,
  })
  use({
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
  })
end)
