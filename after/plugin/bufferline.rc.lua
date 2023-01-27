local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

bufferline.setup({
  options = {
    mode = "tabs",
    --indicator = {
    --icon = " 直",
    --},
    separator_style = "slant",
    always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true,
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
      fg = '#16181C',
      bg = '#1f2126',
    },
    separator_selected = {
      fg = '#16181C',
      bg = '#282C34',
    },
    background = {
      fg = '#8f8d8e',
      bg = '#1f2126',
    },
    buffer_selected = {
      fg = '#fdf6e3',
      bg = '#282C34',
    },
    fill = {
      bg = '#16181C'
    },
  }
})
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})

local status2, groups = pcall(require, "bufferline.groups")
if (not status2) then return end

groups = {
  options = {
    toggle_hidden_on_enter = true -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
  },
  items = {
    {
      name = "Tests", -- Mandatory
      highlight = { underline = true, sp = "blue" }, -- Optional
      priority = 2, -- determines where it will appear relative to other groups (Optional)
      icon = "", -- Optional
      matcher = function(buf) -- Mandatory
        return buf.filename:match('%_test') or buf.filename:match('%_spec')
      end,
    },
    {
      name = "Docs",
      highlight = { undercurl = true, sp = "green" },
      auto_close = false, -- whether or not close this group if it doesn't contain the current buffer
      matcher = function(buf)
        return buf.filename:match('%.md') or buf.filename:match('%.txt')
      end,
      separator = { -- Optional
        style = require('bufferline.groups').separator.tab
      },
    }
  }
}
