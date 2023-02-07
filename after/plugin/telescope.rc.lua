local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
    prompt_prefix = " ",
    selection_caret = " ",
    multi_icon = "落",
  },       
  extensions = {
    file_browser = {
      theme = "dropdown",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
  },
}

telescope.load_extension("file_browser")
telescope.load_extension("harpoon")

-- Telescope mappings
local keymap = vim.keymap
keymap.set('n', '<leader>ff', ':Telescope find_files<cr>')
keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>')
keymap.set('n', '<leader>fb', ':Telescope buffers<cr>')
keymap.set('n', '<leader>fh', ':Telescope help_tags<cr>')
keymap.set('n', '<leader>fc', ':Telescope colorscheme<cr>')
keymap.set('n', '<leader>fm', ':Telescope harpoon marks<cr>')
keymap.set('n', '\\', ':Telescope file_browser<cr>')
