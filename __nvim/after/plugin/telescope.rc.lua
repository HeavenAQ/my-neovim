local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir() return vim.fn.expand('%:p:h') end

telescope.setup {
    defaults = {
        mappings = {n = {["q"] = actions.close}},
        prompt_prefix = " ",
        selection_caret = " ",
        multi_icon = "落"
    }
}

telescope.load_extension("harpoon")
telescope.load_extension("neoclip")
