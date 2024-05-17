local status, dap = pcall(require, "dap")
if not status then
    return
end

-- change break point appearance
-- warning icon
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })

-- python dap settings
dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                return cwd .. "/.venv/bin/python"
            elseif vim.fn.executable(cwd .. "/env/bin/python") == 1 then
                return cwd .. "/env/bin/python"
            elseif vim.fn.executable(cwd .. "/.env/bin/python") == 1 then
                return cwd .. "/.env/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/Scripts/python.exe") == 1 then
                return cwd .. "/.venv/Scripts/python.exe"
            elseif vim.fn.executable(cwd .. "/venv/Scripts/python.exe") == 1 then
                return cwd .. "/venv/Scripts/python.exe"
            elseif vim.fn.executable(cwd .. "/env/Scripts/python.exe") == 1 then
                return cwd .. "/env/Scripts/python.exe"
            elseif vim.fn.executable(cwd .. "/.env/Scripts/python.exe") == 1 then
                return cwd .. "/.env/Scripts/python.exe"
            elseif vim.fn.executable("/usr/bin/python3") == 1 then
                return "/usr/bin/python3"
            elseif vim.fn.executable("/usr/bin/python") == 1 then
                return "/usr/bin/python"
            else
                return "/usr/bin/python3"
            end
        end,
    },
}

-- go dap
dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
    }
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}"
    },
    {
        type = "delve",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }
}
dap.adapters.lldb = {
    type = 'executable',
    command = '/opt/homebrew/opt/llvm/bin/lldb-vscode', -- adjust as needed, must be absolute path
    name = 'lldb'
}


-- C dap
dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}

-- If you want to use this for Rust and C, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- keymaps
vim.api.nvim_set_keymap("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dt", ":lua require'dapui'.toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>df", ":DapStepInto<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dk", ":DapTerminate<CR>", { noremap = true, silent = true })
