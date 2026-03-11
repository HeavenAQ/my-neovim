-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Avoiding repeating movements key presses
local discipline = require("heaven.disciplines")
discipline.cowboy()

local keymap = vim.keymap

-- No Copy
keymap.set("n", "x", '"_x')
keymap.set("x", "p", '"_dP')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
-- vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Page up and down
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- Move Lines
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- New tab
keymap.set("n", "te", ":tabedit<CR>")

-- Split window
keymap.set("n", "ss", ":split<Return>")
keymap.set("n", "sv", ":vsplit<Return>")

-- Move around window (normal mode only)
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- From the terminal to the normal
keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Core
keymap.set("n", "\\", ":Neotree toggle<CR>")
keymap.set("n", "<leader><leader>", ":noh<CR>", { silent = true })

-- Toggle spell check
keymap.set("n", "<leader>ts", function()
  vim.wo.spell = not vim.wo.spell
  vim.notify("Spell: " .. (vim.wo.spell and "ON" or "OFF"))
end, { desc = "Toggle spell" })

-- Switch buffer
keymap.set("n", "<Tab>", ":tabnext<CR>")
keymap.set("n", "<S-Tab>", ":tabprevious<CR>")
-- Keep tab cycling within current group
-- (tab group navigation removed)

-- Cycle buffers only within current tab's group
keymap.set("n", "<S-l>", ":bnext<cr>", { desc = "Next buffer (group)" })
keymap.set("n", "<S-h>", ":bprev<cr>", { desc = "Prev buffer (group)" })
-- (tab grouping removed)

-- latex math
keymap.set("n", "<leader>p", function()
  require("nabla").popup()
end)

-- LSP/UI replacement for lspsaga using LazyVim stack (builtins, Trouble, fzf-lua)
local opts = { noremap = true, silent = true }

-- Helpers to prefer Trouble/fzf-lua when available
local function has(module)
  local ok = package.loaded[module] or pcall(require, module)
  return ok
end

local function open_trouble(mode)
  if has("trouble") then
    require("trouble").toggle(mode)
    return true
  end
  return false
end

local function fzf(cmd)
  if has("fzf-lua") then
    require("fzf-lua")[cmd]()
    return true
  end
  return false
end

-- Helpers to filter external library paths
local function is_excluded_path(fname)
  local patterns = {
    "/node_modules/",
    "/%.git/",
    "/venv/",
    "/%.venv/",
    "/site%-packages/",
    "/__pycache__/",
    "/go/pkg/mod/",
    "/%.cargo/registry/",
    "/target/",
    "/build/",
    "/dist/",
  }
  for _, pat in ipairs(patterns) do
    if fname:find(pat) then
      return true
    end
  end
  return false
end

local function to_items(result)
  if not result or vim.tbl_isempty(result) then
    return {}
  end
  local locations = {}
  if result[1] and result[1].targetUri then
    for _, loc in ipairs(result) do
      table.insert(locations, { uri = loc.targetUri, range = loc.targetRange })
    end
  else
    locations = result
  end
  return vim.lsp.util.locations_to_items(locations, 0) or {}
end

-- Project root + path helpers
local function get_project_root(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local dir = (fname ~= "" and vim.fs.dirname(fname)) or (vim.loop.cwd() or vim.fn.getcwd(0, 0))
  local gitdir = vim.fs.find(".git", { path = dir, upward = true })[1]
  if gitdir then
    return vim.fs.dirname(gitdir)
  end
  local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = bufnr })
    or vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, c in ipairs(clients or {}) do
    local root = (c and c.config and c.config.root_dir) or (c and c.root_dir)
    if root and root ~= "" then
      return root
    end
  end
  return dir
end

local function relpath(root, path)
  if not root or root == "" then
    return path
  end
  local esc = root:gsub("([%%%-%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
  return (path:gsub("^" .. esc .. "/?", ""))
end

-- LSP offset encoding helpers to avoid warnings with mixed clients
local function get_offset_encoding(bufnr)
  local clients = {}
  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients({ bufnr = bufnr })
  else
    clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  end
  for _, c in ipairs(clients or {}) do
    if c and c.offset_encoding then
      return c.offset_encoding
    end
  end
  return "utf-16"
end

local function make_pos_params(bufnr)
  local enc = get_offset_encoding(bufnr)
  local ok, params = pcall(vim.lsp.util.make_position_params, 0, enc)
  if ok and params then
    return params
  end
  ok, params = pcall(vim.lsp.util.make_position_params, 0)
  if ok and params then
    params.position_encoding = enc
    return params
  end
  return { textDocument = vim.lsp.util.make_text_document_params(bufnr), position_encoding = enc }
end

local function show_defs_and_project_refs()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = make_pos_params(bufnr)
  local root = get_project_root(bufnr)
  local seen = {}
  local defs, calls = {}, {}
  local function push(dst, it)
    local key = (it.filename or it.bufnr) .. ":" .. (it.lnum or 0) .. ":" .. (it.col or 0)
    if not seen[key] then
      table.insert(dst, it)
      seen[key] = true
    end
  end

  vim.lsp.buf_request(bufnr, "textDocument/definition", params, function(_, def_result)
    for _, it in ipairs(to_items(def_result)) do
      push(defs, it)
    end

    local ref_params = vim.deepcopy(params)
    ref_params.context = { includeDeclaration = false }
    vim.lsp.buf_request(bufnr, "textDocument/references", ref_params, function(_, ref_result)
      for _, it in ipairs(to_items(ref_result)) do
        local fname = it.filename or (it.bufnr and vim.api.nvim_buf_get_name(it.bufnr)) or ""
        if fname ~= "" and not is_excluded_path(fname) then
          push(calls, it)
        end
      end

      if vim.tbl_isempty(defs) and vim.tbl_isempty(calls) then
        vim.notify("No definitions or project references found", vim.log.levels.INFO)
        return
      end

      local function color(code, s)
        return string.format("\27[%sm%s\27[0m", code, s)
      end
      local entries = {}
      local function add(kind, it)
        local abs = it.filename or (it.bufnr and vim.api.nvim_buf_get_name(it.bufnr)) or ""
        local rel = relpath(root, abs)
        local text = (it.text or ""):gsub("\t", "  ")
        local tag = kind == "DEF" and color(32, "[DEF]") or color(34, "[CALL]")
        -- entry is: "abs_path:lnum:col\t[TAG] rel:lnum:col: text"
        local left = string.format("%s:%d:%d", abs, it.lnum or 0, it.col or 0)
        local right = string.format("%s %s:%d:%d: %s", tag, rel, it.lnum or 0, it.col or 0, text)
        table.insert(entries, left .. "\t" .. right)
      end
      for _, it in ipairs(defs) do
        add("DEF", it)
      end
      for _, it in ipairs(calls) do
        add("CALL", it)
      end

      if not has("fzf-lua") then
        vim.notify("fzf-lua not installed", vim.log.levels.WARN)
        return
      end
      require("fzf-lua").fzf_exec(entries, {
        prompt = "Defs+Calls> ",
        fzf_opts = {
          ["--ansi"] = true,
          ["--no-sort"] = true,
          ["--delimiter"] = "\t",
          ["--with-nth"] = "2..",
        },
        previewer = "builtin",
        cwd = root,
        winopts = {
          width = 0.9,
          height = 0.7,
          preview = { layout = "horizontal", horizontal = "right:60%" },
        },
        actions = {
          ["default"] = function(selected)
            local sel = selected[1] or ""
            -- Parse left field "abs:lnum:col\t..."
            local left = sel:match("^(.-)\t") or sel
            local file, lnum, col = left:match("^(.-):(%d+):(%d+)$")
            if not file then
              return
            end
            vim.cmd.edit(file)
            vim.api.nvim_win_set_cursor(0, { tonumber(lnum) or 1, math.max(0, (tonumber(col) or 1) - 1) })
            vim.cmd.normal({ args = { "zz" }, bang = false })
          end,
        },
      })
    end)
  end)
end

-- Diagnostics next with float
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next({ wrap = true })
  -- Show diagnostics for the current line in a non-focusable float
  vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
end, opts)
keymap.set("n", "<C-p>", function()
  vim.diagnostic.goto_prev({ float = false })
end, opts)

-- Hover docs
keymap.set("n", "<C-k>", function()
  vim.lsp.buf.hover()
end, opts)

-- Also support the common Shift-K hover
keymap.set("n", "K", function()
  vim.lsp.buf.hover()
end, opts)

-- Finder equivalent: prefer Trouble lsp view; fallback to references
keymap.set("n", ",d", function()
  if not open_trouble("lsp") then
    if not fzf("lsp_references") then
      vim.lsp.buf.references()
    end
  end
end, opts)

-- Prefer in-project references + definitions, excluding external libs
keymap.set(
  "n",
  "<leader>d",
  show_defs_and_project_refs,
  vim.tbl_extend("force", opts, { desc = "Defs + Refs (project)" })
)

-- Workspace diagnostics picker (fzf with side-by-side preview)
local function show_workspace_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local root = get_project_root(bufnr)
  local diags = vim.diagnostic.get(nil)
  if not diags or vim.tbl_isempty(diags) then
    vim.notify("No diagnostics", vim.log.levels.INFO)
    return
  end
  local function sev_tag(sev)
    local map = {
      [vim.diagnostic.severity.ERROR] = { code = 31, label = "[ERROR]" },
      [vim.diagnostic.severity.WARN] = { code = 33, label = "[WARN]" },
      [vim.diagnostic.severity.INFO] = { code = 36, label = "[INFO]" },
      [vim.diagnostic.severity.HINT] = { code = 35, label = "[HINT]" },
    }
    local ent = map[sev] or { code = 37, label = "[DIAG]" }
    return string.format("\27[%sm%s\27[0m", ent.code, ent.label)
  end
  local entries = {}
  for _, d in ipairs(diags) do
    local abs = vim.api.nvim_buf_get_name(d.bufnr)
    if abs ~= "" and not is_excluded_path(abs) then
      local rel = relpath(root, abs)
      local lnum = (d.lnum or 0) + 1
      local col = (d.col or 0) + 1
      local src = d.source and (" (" .. d.source .. ")") or ""
      local msg = (d.message or ""):gsub("\n", " ")
      local tag = sev_tag(d.severity)
      local left = string.format("%s:%d:%d", abs, lnum, col)
      local right = string.format("%s %s:%d:%d:%s %s", tag, rel, lnum, col, src, msg)
      table.insert(entries, left .. "\t" .. right)
    end
  end
  if vim.tbl_isempty(entries) then
    vim.notify("No diagnostics (filtered)", vim.log.levels.INFO)
    return
  end
  if not has("fzf-lua") then
    vim.notify("fzf-lua not installed", vim.log.levels.WARN)
    return
  end
  require("fzf-lua").fzf_exec(entries, {
    prompt = "Diagnostics> ",
    fzf_opts = {
      ["--ansi"] = true,
      ["--no-sort"] = true,
      ["--delimiter"] = "\t",
      ["--with-nth"] = "2..",
    },
    previewer = "builtin",
    cwd = root,
    winopts = {
      width = 0.9,
      height = 0.7,
      preview = { layout = "horizontal", horizontal = "right:60%" },
    },
    actions = {
      ["default"] = function(selected)
        local sel = selected[1] or ""
        local left = sel:match("^(.-)\t") or sel
        local file, lnum, col = left:match("^(.-):(%d+):(%d+)$")
        if not file then
          return
        end
        vim.cmd.edit(file)
        vim.api.nvim_win_set_cursor(0, { tonumber(lnum) or 1, math.max(0, (tonumber(col) or 1) - 1) })
        vim.cmd.normal({ args = { "zz" }, bang = false })
      end,
    },
  })
end

-- Remap <leader>xx to diagnostics picker
keymap.set("n", "<leader>xx", show_workspace_diagnostics, vim.tbl_extend("force", opts, { desc = "Diagnostics (fzf)" }))

-- Signature help (insert)
keymap.set("i", "<C-y>", function()
  vim.lsp.buf.signature_help()
end, opts)

do
  -- Peek definition in a floating window and close with `q`
  local function peek_definition()
    local curbuf = vim.api.nvim_get_current_buf()
    local params = make_pos_params(curbuf)
    vim.lsp.buf_request(curbuf, "textDocument/definition", params, function(err, result)
      if err then
        vim.notify("LSP error: " .. (err.message or tostring(err)), vim.log.levels.ERROR)
        return
      end
      if not result or vim.tbl_isempty(result) then
        vim.notify("No definition found", vim.log.levels.INFO)
        return
      end

      local def = result[1]
      local uri = def.uri or def.targetUri
      local range = def.range or def.targetRange
      if not uri or not range then
        vim.notify("Invalid definition response", vim.log.levels.WARN)
        return
      end

      local fname = vim.uri_to_fname(uri)
      local target_buf = vim.fn.bufadd(fname)
      vim.fn.bufload(target_buf)

      local columns = vim.o.columns
      local lines = vim.o.lines - vim.o.cmdheight
      local width = math.floor(columns * 0.85)
      local height = math.floor(lines * 0.6)
      local row = math.floor((lines - height) / 2)
      local col = math.floor((columns - width) / 2)

      local root = get_project_root(curbuf)
      local rel = relpath(root, fname)
      local win = vim.api.nvim_open_win(target_buf, true, {
        relative = "editor",
        row = row,
        col = col,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
        title = "Peek " .. rel,
        title_pos = "center",
      })

      -- Window local options for readability
      pcall(vim.api.nvim_set_option_value, "cursorline", true, { win = win })
      pcall(vim.api.nvim_set_option_value, "wrap", false, { win = win })

      -- Jump to target range
      local start_line = (range.start and range.start.line or 0) + 1
      local start_col = (range.start and range.start.character or 0)
      pcall(vim.api.nvim_win_set_cursor, win, { start_line, start_col })
      -- Try to center the view
      pcall(vim.api.nvim_win_call, win, function()
        vim.cmd("normal! zz")
      end)

      -- Buffer-local `q` to close the peek window
      vim.keymap.set("n", "q", function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, { buffer = target_buf, nowait = true, silent = true })
    end)
  end

  keymap.set("n", "gp", peek_definition, opts)
end

-- Rename symbol (project/workspace behavior is language-server dependent)
keymap.set("n", "<leader>r", function()
  vim.lsp.buf.rename()
end, opts)

-- Code actions
keymap.set({ "n", "v" }, "<leader>k", function()
  vim.lsp.buf.code_action()
end, opts)

-- Outline: prefer Trouble symbols or fzf-lua document symbols; fallback to LSP
keymap.set("n", "<leader>o", function()
  if not open_trouble("symbols") then
    if not fzf("lsp_document_symbols") then
      vim.lsp.buf.document_symbol()
    end
  end
end, opts)

-- Call hierarchy
keymap.set("n", "<leader>cci", function()
  if not fzf("lsp_incoming_calls") then
    -- built-in fallback
    vim.lsp.buf.incoming_calls()
  end
end, opts)
keymap.set("n", "<leader>cco", function()
  if not fzf("lsp_outgoing_calls") then
    -- built-in fallback
    vim.lsp.buf.outgoing_calls()
  end
end, opts)

-- LSP management
keymap.set("n", "<leader>z", ":LspRestart<CR>", { silent = true })

-- Toggle inlay hints
keymap.set("n", "<leader>ti", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled
  local ok = pcall(function()
    enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  end)
  if ok then
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  else
    -- Neovim 0.9 fallback (no is_enabled)
    -- Just toggle by storing a buffer var
    local curr = vim.b.inlay_hints_enabled or false
    vim.b.inlay_hints_enabled = not curr
    pcall(vim.lsp.buf.inlay_hint, bufnr, vim.b.inlay_hints_enabled)
  end
end, { desc = "Toggle Inlay Hints" })

-- Latex
vim.keymap.set("n", "<leader>a", function()
  local lines = {
    "$$\\begin{align*}",
    "",
    "\\end{align*}$$",
  }
  vim.api.nvim_put(lines, "l", true, true)
  vim.cmd("normal! kA")
end, { noremap = true, silent = true })

do
  local term = { win = nil, buf = nil }

  local function term_is_open()
    return term.win and vim.api.nvim_win_is_valid(term.win)
  end

  local function buf_is_valid()
    return term.buf and vim.api.nvim_buf_is_valid(term.buf)
  end

  local function is_term_running()
    if not buf_is_valid() then
      return false
    end
    local ok, job = pcall(vim.api.nvim_buf_get_var, term.buf, "terminal_job_id")
    if not ok or type(job) ~= "number" or job <= 0 then
      return false
    end
    -- jobwait returns -1 if still running; non-negative exit code otherwise
    local status = vim.fn.jobwait({ job }, 0)[1]
    return status == -1
  end

  local function close_term()
    if term_is_open() then
      vim.api.nvim_win_close(term.win, true)
      term.win = nil
    end
  end

  local function open_term()
    if term_is_open() then
      close_term()
      return
    end

    if not buf_is_valid() then
      term.buf = vim.api.nvim_create_buf(false, true)
      -- Keep buffer around when hidden so we can reuse it
      pcall(vim.api.nvim_set_option_value, "bufhidden", "hide", { buf = term.buf })
    end

    local columns = vim.o.columns
    local lines = vim.o.lines - vim.o.cmdheight
    local width = math.floor(columns * 0.9)
    local height = math.floor(lines * 0.35)
    local row = math.floor((lines - height) / 2)
    local col = math.floor((columns - width) / 2)

    term.win = vim.api.nvim_open_win(term.buf, true, {
      relative = "editor",
      row = row,
      col = col,
      width = width,
      height = height,
      style = "minimal",
      border = "rounded",
    })

    -- Start a shell if this buffer doesn't have a running terminal job
    if not is_term_running() then
      vim.fn.termopen(vim.o.shell)
    end
    vim.cmd.startinsert()
  end

  -- Toggle floating terminal: reopen same session instead of spawning new ones
  keymap.set({ "n", "t" }, "<C-g>", function()
    if term_is_open() then
      close_term()
    else
      open_term()
    end
  end, { silent = true, desc = "Toggle terminal" })
end
-- (docs scrolling mappings removed by request)

-- Quarto related
local runner = require("quarto.runner")
vim.keymap.set("n", "<space>rc", runner.run_cell, { desc = "Run Quarto cell" })
vim.keymap.set("n", "<space>ra", runner.run_all, { desc = "Run all cells" })
vim.keymap.set("n", "<space>rl", runner.run_line, { desc = "Run line" })
vim.keymap.set("v", "<space>rv", runner.run_range, { desc = "Run selection" }) -- Quarto
