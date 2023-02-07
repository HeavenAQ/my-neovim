local status, harpoon = pcall(require, "harpoon")
if (not status) then return end

local keymap = vim.keymap
keymap.set('n', 'fa', ':lua require("harpoon.mark").add_file()<cr>')
keymap.set('n', 'ft', ':lua require("harpoon.ui").toggle_quick_menu()<cr>')
keymap.set('n', 'fn', ':lua require("harpoon.ui").nav_next()<cr>')
keymap.set('n', 'fp', ':lua require("harpoon.ui").nav_prev()<cr>')
