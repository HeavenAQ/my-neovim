local keymap = vim.keymap

-- No Copy
keymap.set('n', 'x', '"_x')
keymap.set('x', 'p', '"_dP')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Page up and down
keymap.set('n', '<C-d>', '<C-d>zz')
keymap.set('n', '<C-u>', '<C-u>zz')

-- Move Lines
keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- New tab
keymap.set('n', 'te', ':tabedit<CR>')

-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w')
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')

-- Move around window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

-- Core
vim.g.mapleader = ","
keymap.set('n', '\\', ':NvimTreeFindFileToggle<CR>')
keymap.set('n', '<leader><leader>', ':noh<CR>', { silent = true })
keymap.set('n', '<S-e>', ':bnext<CR>')
keymap.set('n', '<S-w>', ':bprevious<CR>')

-- lsp
keymap.set('n', '<leader>z', ':LspRestart<CR>', { silent = true })

-- markdown settings
keymap.set('n', '<leader>g', ':MarkdownPreview<CR>')

-- Quick Compilation
vim.cmd(([[
  autocmd FileType python nmap <leader>e <cmd>! python % <cr>
  autocmd FileType robot nmap <leader>g <cmd>! robotidy *robot <cr>
  autocmd FileType * let b:coc_suggest_disable = 1
  autocmd FileType c nmap <leader>w <cmd>! gcc %<cr>
  autocmd FileType c nmap <leader>e <cmd>! ./a.out<cr>
  autocmd FileType cpp nmap <leader>w <cmd>! g++ %<cr>
  autocmd FileType cpp nmap <leader>e <cmd>! ./a.out<cr>
]]))
