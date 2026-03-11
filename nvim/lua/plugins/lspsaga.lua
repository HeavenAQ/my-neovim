return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      ui = {
        border = "rounded",
        code_action = "",
      },
      symbol_in_winbar = {
        enable = true,
        folder_level = 2,
        separator = "  ",
        hide_keyword = true,
        show_file = true,
        color_mode = true,
        delay = 80,
      },
      lightbulb = { enable = false },
    },
  },
}

