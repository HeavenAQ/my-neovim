local status, go = pcall(require, "go")
if not status then return end

go.setup({
    diagnostic = {
        virtual_text = {prefix = "", spacing = 4},
        underline = true,
        update_in_insert = true,
        float = {source = "always"}
    }
})
