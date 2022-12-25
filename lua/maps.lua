local keymap = vim.keymap

keymap.set('n', 'x', '"_x')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- New tab
keymap.set('n', 'te', ':tabedit')
-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w')
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
-- Move window
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
keymap.set('n', '<leader>z', ':LspRestart<cr>', { silent = true })

-- pythong settings
keymap.set('n', '<leader>g <cmd>Black', '<cr>')

-- Coc
keymap.set('n', '<leader>cl', ':CocDiagnostics<CR>', { silent = true })
keymap.set('n', '<leader>ch', ':call CocAction("doHover")<CR>', { silent = true })
keymap.set('n', '<leader>cf', '<plug>(coc-codeaction-cursor)', { silent = true })
keymap.set('n', '<leader>ca', '<plug>(coc-fix-current)', { silent = true })


-- Telescope mappings
keymap.set('n', '<leader>ff', ':Telescope find_files<cr>')
keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>')
keymap.set('n', '<leader>fb', ':Telescope buffers<cr>')
keymap.set('n', '<leader>fh', ':Telescope help_tags<cr>')
keymap.set('n', '<leader>fc', ':Telescope colorscheme<cr>')


-- Quick Compilation
vim.cmd(([[
  autocmd FileType python nmap <leader>d <cmd>Docstring <cr>
  autocmd FileType python nmap <leader>e <cmd>! python % <cr>
  autocmd FileType robot nmap <leader>g <cmd>! robotidy *robot <cr>
  autocmd FileType * let b:coc_suggest_disable = 1
  autocmd FileType c nmap <leader>w <cmd>! gcc %<cr>
  autocmd FileType c nmap <leader>e <cmd>! ./a.out<cr>
]]))
