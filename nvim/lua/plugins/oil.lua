return {

  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", false },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    lazy = false,

    keys = {
      {
        "<leader>e",
        "<cmd>Oil<CR>",
        desc = "Explorer",
      },

      {
        "<leader>s;",
        function()
          vim.cmd("terminal ssh sb-00477-login '/bin/bash -lc \"squeue -u user104001\"'")
        end,
        desc = "Slurm Queue",
      },
      {
        "<leader>s]",
        function()
          local jobid = vim.fn.input("Job ID: ")

          local cmd =
            string.format("terminal ssh sb-00477-login '/bin/bash -lc \"srun --overlap --jobid=%s --pty bash\"'", jobid)

          vim.cmd(cmd)
        end,
        desc = "Attach Slurm Job",
      },
      -- Open parent directory
      {
        "-",
        function()
          require("oil").open()
        end,
        desc = "Open parent directory",
      },

      -- Leader shortcut
      {
        "<leader>o",
        "<cmd>Oil<CR>",
        desc = "Open Oil",
      },

      -- Open floating oil
      {
        "<leader>O",
        function()
          require("oil").open_float()
        end,
        desc = "Open Oil Float",
      },
    },

    opts = {
      default_file_explorer = true,

      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },

      delete_to_trash = true,

      skip_confirm_for_simple_edits = true,

      view_options = {
        show_hidden = true,
        natural_order = true,
        is_hidden_file = function(name, _)
          return vim.startswith(name, ".")
        end,
      },

      float = {
        padding = 2,
        max_width = 100,
        max_height = 30,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },

      keymaps = {
        ["g?"] = "actions.show_help",

        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",

        ["<C-p>"] = "actions.preview",

        ["<C-c>"] = "actions.close",

        ["<C-l>"] = "actions.refresh",

        ["-"] = "actions.parent",

        ["_"] = "actions.open_cwd",

        ["`"] = "actions.cd",

        ["~"] = {
          "actions.cd",
          opts = { scope = "tab" },
        },

        ["gs"] = "actions.change_sort",

        ["gx"] = "actions.open_external",

        ["g."] = "actions.toggle_hidden",
      },
    },
  },
}
