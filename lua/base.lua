vim.cmd("autocmd!")

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 8
vim.opt.shell = 'fish'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.opt.spell = true

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = '*',
    command = "set nopaste"
})

-- python related settings
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = '*.py',
    command = "silent !isort % && black --quiet %"
})

-- java related settings
-- auto compile java files
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = '*.java',
    command = "silent !javac %"
})

-- c related settings
-- auto format c and cpp files
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = '*.cpp',
    command = "silent !clang-format -i -style='{BasedOnStyle: llvm, IndentWidth: 4, TabWidth: 4}' %"
})
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = '*.[ch]',
    command = "silent !clang-format -i -style='{BasedOnStyle: llvm, IndentWidth: 4, TabWidth: 4}' %"
})

-- go related settings
-- auto format go files
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = '*.go',
    command = "silent !gofmt -w % && goimports -w %"
})

-- journal and markdown related settings
-- set indent to 2 spaces
vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
    pattern = '*.md',
    command = "setlocal shiftwidth=2 tabstop=2"
})
vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
    pattern = '*.norg',
    command = "setlocal shiftwidth=2 tabstop=2"
})

-- align the entire file on save for norg files
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = '*.norg',
    command = "normal! mzgg=G`z"
})


-- Add asterisks in block comments
vim.opt.formatoptions:remove { 'o' } -- O and o, don't continue comments
vim.opt.formatoptions:append { 'r' }
