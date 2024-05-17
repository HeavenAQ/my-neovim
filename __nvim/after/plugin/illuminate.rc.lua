local status, illuminate = pcall(require, 'illuminate')
if (not status) then
    print("illuminate not found")
    return
end

local keymap = vim.keymap
keymap.set('n', '<space>n', function() illuminate.goto_next_reference(wrap) end)
keymap.set('n', '<space>p',function() illuminate.goto_prev_reference(wrap) end)

