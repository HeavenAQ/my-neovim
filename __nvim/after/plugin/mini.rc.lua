local status, mini = pcall(require, "mini.indentscope")

if (not status) then
    print("Failed to load mini:", mini)
    return
end

mini.setup({
    options = {
        -- symbol = "▏",
        try_as_border = true ,
    },
    symbol = "│",
})
