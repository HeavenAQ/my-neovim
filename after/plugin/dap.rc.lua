local status, dap = pcall(require, "dap")
if (not status) then return end



local keymap = vim.keymap
keymap.set('n', '<leader>d', ':lua require("dapui").toggle()<CR>')
keymap.set('n', '<leader>b', ':DapToggleBreakpoint<CR>')
keymap.set('n', '<leader>n', ':DapStepOver<CR>')
keymap.set('n', '<leader>m', ':DapStepOut<CR>')
