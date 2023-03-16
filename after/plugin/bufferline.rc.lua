local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

bufferline.setup({
  options = {
    mode = "tabs",
    --indicator = {
    --icon = " 直",
    --},
    show_buffer_icons = false,
    separator_style = "slant",
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

  },
  highlights = {
    separator = {
      fg = '#111113',
      bg = '#111113',
    },
    separator_selected = {
      fg = '#111113',
      bg = '#fdf6e3',
    },
    modified = {
      bg = '#111113'
    },
    duplicate_selected = {
      fg = '#EE4866',
      bg = '#fdf6e3',
      italic = true,
    },
    duplicate = {
      fg = '#EE4866',
      bg = '#111113',
    },
    modified_selected = {
      bg = '#fdf6e3'
    },
    background = {
      fg = '#8f8d8e',
      bg = '#111113',
    },
    buffer_selected = {
      fg = '#111113',
      bg = '#fdf6e3',
    },
    offset_separator = {
      bg = '#111113',
      fg = '#fdf6e3',
    },
  }
})
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
