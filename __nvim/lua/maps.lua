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
-- vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

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
keymap.set('n', '<leader><leader>', ':noh<CR>', {silent = true})
keymap.set('n', '<S-e>', ':bnext<CR>')
keymap.set('n', '<S-w>', ':bprevious<CR>')

-- Telescope
keymap.set('n', '<leader>ff', ':Telescope find_files<cr>')
keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>')
keymap.set('n', '<leader>fb', ':Telescope buffers<cr>')
keymap.set('n', '<leader>fh', ':Telescope help_tags<cr>')
keymap.set('n', '<leader>fc', ':Telescope colorscheme<cr>')
keymap.set('n', '<leader>fm', ':Telescope harpoon marks<cr>')
keymap.set('n', '<leader>fy', ':Telescope neoclip a extra=star,plus,unnamed<cr>')

-- latex math
keymap.set('n', '<leader>p', function() require('nabla').popup() end)

-- lsp
keymap.set('n', '<leader>z', ':LspRestart<CR>', {silent = true})

-- go err check -> insert if err != nil { return err }
keymap.set('n', '<leader>l', 'oif err != nil {\nreturn err \n}', {silent = true})

-- Quick Compilation
vim.cmd(([[
  autocmd FileType python nmap <leader>e <cmd>! python3 % <cr>
  autocmd FileType robot nmap <leader>g <cmd>! robotidy *robot <cr>
  autocmd FileType * let b:coc_suggest_disable = 1
  autocmd FileType c nmap <leader>w <cmd>! gcc %<cr>
  autocmd FileType c nmap <leader>e <cmd>! ./a.out<cr>
  autocmd FileType go nmap <leader>e <cmd>! go run .<cr>
  autocmd FileType cpp nmap <leader>w <cmd>! g++ %<cr>
  autocmd FileType cpp nmap <leader>e <cmd>! ./a.out<cr>
]]))
