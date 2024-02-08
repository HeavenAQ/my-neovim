local status, harpoon = pcall(require, "harpoon")
if (not status) then return end

local keymap = vim.keymap
keymap.set('n', '<leader>a', function() harpoon:list():append() end)
keymap.set('n', '<leader>q',
           function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
keymap.set('n', '<leader>g', function() harpoon:list():prev() end)
keymap.set('n', '<leader>e', function() harpoon:list():next() end)
