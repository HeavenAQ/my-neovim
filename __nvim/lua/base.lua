vim.cmd("autocmd!")

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.wo.relativenumber = true
vim.o.number = true
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
vim.opt.shell = 'zsh'
vim.opt.backupskip = {'/tmp/*', '/private/tmp/*'}
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.backspace = {'start', 'eol', 'indent'}
vim.opt.path:append{'**'} -- Finding files - Search down into subfolders
vim.opt.wildignore:append{'*/node_modules/*'}
vim.opt.spell = true
vim.opt.cindent = true
vim.opt.cinoptions = {'l1', 'g0', 'i0'}
vim.opt.cursorcolumn = true
vim.opt.termguicolors = true
vim.opt.rtp:append{'/opt/homebrew/opt/fzf'}

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave",
                            {pattern = '*', command = "set nopaste"})

vim.opt.formatoptions:remove{'o'} -- O and o, don't continue comments
vim.opt.formatoptions:append{'r'}

-- Define a custom sign with a right arrow
vim.cmd [[
  sign define currentline text=󰆧 texthl=Keyword
]]

-- Config tabwidth when editing js related files
vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'javascript', 'typescript', 'typescriptreact', 'html', 'css', 'scss',
        'json', 'yaml', 'markdown', 'astro'
    },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end
})

local function update_line_indicator()
    -- Remove existing signs to clear previous indicators
    vim.fn.sign_unplace('currentlinegroup', {buffer = '%'})

    -- Get the current line number
    local current_line = vim.api.nvim_win_get_cursor(0)[1]

    -- Place the right arrow sign at the current line
    vim.fn.sign_place(0, 'currentlinegroup', 'currentline', '%',
                      {lnum = current_line})
end

-- Setup an autocmd to update the line indicator on cursor movements
vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI', 'InsertLeave'},
                            {pattern = '*', callback = update_line_indicator})
