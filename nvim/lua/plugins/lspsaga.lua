return {
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local saga = require("lspsaga")

      saga.setup({
        ui = {
          title = true,
          -- border type can be single, double, rounded, solid, shadow.
          border = "rounded",
        },
        diagnostic = {
          virtual_text = false,
          on_insert = false,
        },
        lightbulb = {
          enable = false,
          enable_in_insert = false,
          sign = false,
          sign_priority = 40,
          virtual_text = false,
        },
        code_action = {
          num_shortcut = true,
          show_server_name = false,
          extend_gitsigns = false,
          keys = {
            -- string | table type
            quit = "q",
            exec = "<CR>",
          },
        },
        finder = {
          edit = { "o", "<CR>" },
          vsplit = "s",
          split = "i",
          tabe = "t",
          quit = "q",
        },
        definition = {
          edit = "<C-c>o",
          vsplit = "<C-c>v",
          split = "<C-c>i",
          tabe = "<C-c>t",
          quit = "q",
          close = "<C-c>",
        },
        symbol_in_winbar = {
          enable = true,
          separator = " » ",
          hide_keyword = true,
          show_file = true,
          folder_level = 2,
          respect_root = false,
          color_mode = true,
        },
      })
    end,
  },
}
