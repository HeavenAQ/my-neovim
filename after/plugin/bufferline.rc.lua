local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

bufferline.setup({
  options = {
    mode = "tabs",
    --indicator = {
    --icon = " 直",
    --},
    show_buffer_icons = false,
    separator_style = "thick",
    always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = false,
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    truncate_names = true, -- whether or not tab names should be truncated
    modified_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    custom_areas = {
      right = function()
        local result = {}
        local seve = vim.diagnostic.severity
        local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
        local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
        local info = #vim.diagnostic.get(0, { severity = seve.INFO })
        local hint = #vim.diagnostic.get(0, { severity = seve.HINT })

        if error ~= 0 then
          table.insert(result, { text = "  " .. error, fg = "#db4b4b" })
        end

        if warning ~= 0 then
          table.insert(result, { text = "  " .. warning, fg = "#e0af68" })
        end

        if hint ~= 0 then
          table.insert(result, { text = "  " .. hint, fg = "#2ac3de" })
        end

        if info ~= 0 then
          table.insert(result, { text = "  " .. info, fg = "#1abc9c" })
        end
        return result
      end,
    },

  },
  highlights = {
    separator = {
      fg = '#1f2126',
      bg = '#1f2126',
    },
    background = {
      fg = '#8f8d8e',
      bg = '#1f2126',
    },
    buffer_selected = {
      fg = '#1f2126',
      bg = '#fdf6e3',
    },
    offset_separator = {
      bg = '#1f2126',
      fg = '#fdf6e3',
    },
  }
})
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
