local status, saga = pcall(require, "lspsaga")
if (not status) then return end

saga.setup({
  ui = {
    -- currently only round theme
    theme = 'round',
    title = true,
    -- border type can be single,double,rounded,solid,shadow.
    border = 'rounded',
    winblend = 0,
    expand = '',
    collapse = '',
    preview = '  ',
    code_action = ' ',
    diagnostic = ' ',
    incoming = ' ',
    outgoing = ' ',
    colors = {
      --float window normal background color
      normal_bg = 'none',
      --title background color
      title_bg = '#61afef',
      red = '#f7585c',
      magenta = '#b33076',
      orange = '#FF8700',
      yellow = '#fcc04f',
      green = '#87cc9e',
      cyan = '#36d0e0',
      blue = '#61afef',
      purple = '#CBA6F7',
      white = '#ffffff',
      black = '#1c1c19',
    },
  },
  code_action = {
    num_shortcut = true,
    keys = {
      -- string |table type
      quit = 'q',
      exec = '<CR>',
    },
  },
  finder = {
    edit = { 'o', '<CR>' },
    vsplit = 's',
    split = 'i',
    tabe = 't',
    quit = 'q',
  },
  definition = {
    edit = '<C-c>o',
    vsplit = '<C-c>v',
    split = '<C-c>i',
    tabe = '<C-c>t',
    quit = 'q',
    close = '<C-c>',
  },
  symbol_in_winbar = {
    enable = true,
    separator = '  ',
    hide_keyword = true,
    show_file = true,
    folder_level = 2,
    respect_root = false,
    color_mode = true,
  },
})

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<C-m>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', '<C-p>', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
vim.keymap.set('n', '<leader>r', '<Cmd>Lspsaga show_buf_diagnostics<CR>', opts)
vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)
vim.keymap.set('n', 'gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
vim.keymap.set('i', '<C-y>', '<Cmd>Lspsaga signature_help<CR>', opts)
vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', opts)
vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename ++project<CR>', opts)
vim.keymap.set({ "n", "v" }, "<leader>k", "<cmd>Lspsaga code_action<CR>", { silent = true })
vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>")

-- Callhierarchy
vim.keymap.set("n", "<leader>cci", "<cmd>Lspsaga incoming_calls<CR>")
vim.keymap.set("n", "<leader>cco", "<cmd>Lspsaga outgoing_calls<CR>")

-- Float terminal
vim.keymap.set({ "n", "t" }, "<C-g>", "<cmd>Lspsaga term_toggle<CR>")
vim.keymap.set({ "n", "t" }, "<C-g>", "<cmd>Lspsaga term_toggle<CR>")
