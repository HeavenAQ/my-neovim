local M = {}

-- Compute project root (git > LSP > cwd)
local function get_project_root(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local dir = (name ~= "" and vim.fs.dirname(name)) or (vim.loop.cwd() or vim.fn.getcwd(0, 0))
  local gitdir = vim.fs.find(".git", { path = dir, upward = true })[1]
  if gitdir then
    return vim.fs.dirname(gitdir)
  end
  local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = bufnr }) or vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, c in ipairs(clients or {}) do
    local root = (c and c.config and c.config.root_dir) or c.root_dir
    if root and root ~= "" then return root end
  end
  return dir
end

local function relpath(root, path)
  if not root or root == "" then return path end
  local esc = root:gsub("([%%%-%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
  return (path:gsub("^" .. esc .. "/?", ""))
end

local function compute_group_for_buf(bufnr)
  local root = get_project_root(bufnr)
  local abs = vim.api.nvim_buf_get_name(bufnr)
  if abs == nil or abs == "" then return "(misc)" end
  local rel = relpath(root, abs)
  local first = rel:match("^([^/\\]+)") or rel
  if first == rel then
    return "(root)"
  end
  return first
end

local function buf_group(bufnr)
  local ok, val = pcall(vim.api.nvim_buf_get_var, bufnr, "buf_group")
  if ok and type(val) == "string" and val ~= "" then
    return val
  end
  local g = compute_group_for_buf(bufnr)
  pcall(vim.api.nvim_buf_set_var, bufnr, "buf_group", g)
  return g
end

local function update_current_buf_group()
  local buf = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.api.nvim_buf_set_var, buf, "buf_group", compute_group_for_buf(buf))
  end
end

local function current_tab_group()
  local tab = vim.api.nvim_get_current_tabpage()
  local ok, val = pcall(vim.api.nvim_tabpage_get_var, tab, "tab_group")
  if ok and type(val) == "string" then return val end
  -- derive from active window buffer
  local win = vim.api.nvim_tabpage_get_win(tab)
  local buf = vim.api.nvim_win_get_buf(win)
  return buf_group(buf)
end

local function list_group_buffers(group)
  local infos = vim.fn.getbufinfo({ buflisted = 1 })
  local bufs = {}
  for _, info in ipairs(infos) do
    if vim.api.nvim_buf_is_valid(info.bufnr) then
      if buf_group(info.bufnr) == group then
        table.insert(bufs, info.bufnr)
      end
    end
  end
  table.sort(bufs) -- simple deterministic order by bufnr
  return bufs
end

function M.next_in_group()
  local cur = vim.api.nvim_get_current_buf()
  local group = current_tab_group()
  local list = list_group_buffers(group)
  if #list <= 1 then return end
  local idx = 1
  for i, b in ipairs(list) do
    if b == cur then idx = i break end
  end
  local nxt = list[(idx % #list) + 1]
  if nxt and vim.api.nvim_buf_is_valid(nxt) then
    vim.api.nvim_set_current_buf(nxt)
  end
end

function M.prev_in_group()
  local cur = vim.api.nvim_get_current_buf()
  local group = current_tab_group()
  local list = list_group_buffers(group)
  if #list <= 1 then return end
  local idx = 1
  for i, b in ipairs(list) do
    if b == cur then idx = i break end
  end
  local prev = list[(idx - 2) % #list + 1]
  if prev and vim.api.nvim_buf_is_valid(prev) then
    vim.api.nvim_set_current_buf(prev)
  end
end

function M.setup()
  local aug = vim.api.nvim_create_augroup("HeavenBufferCycle", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufWinEnter", "TabEnter" }, {
    group = aug,
    callback = function()
      pcall(update_current_buf_group)
    end,
  })
end

return M

