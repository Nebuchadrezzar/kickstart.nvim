-- Locate a Python project's root and its Poetry virtualenv, shared by the language server
-- (Zuban, init.lua) and the type checker (mypy, custom/plugins/lint.lua) so both see the same
-- packages.
--
-- Locally the project's packages live in a Poetry venv. In the client containers there is no Poetry
-- or venv: the packages are in the system Python, which is what both tools fall back to.

local M = {}

local ROOT_MARKERS = { 'setup.cfg', 'pyproject.toml', '.git' }

--- The project root for a buffer or a path, or nil.
---@param source integer|string
---@return string?
function M.root(source) return vim.fs.root(source, ROOT_MARKERS) end

local venvs = {}

--- The Poetry venv directory for a project root, or nil. Looked up once per root.
---@param root string?
---@return string?
function M.poetry_venv(root)
  if not root or vim.fn.executable 'poetry' == 0 then return nil end
  if venvs[root] == nil then
    local result = vim.system({ 'poetry', 'env', 'info', '-p' }, { cwd = root, text = true }):wait()
    local path = result.code == 0 and vim.trim(result.stdout or '') or ''
    venvs[root] = path ~= '' and path or false
  end
  return venvs[root] or nil
end

--- A tool from the project's Poetry venv (e.g. 'mypy', 'python'), or nil when there is no venv or
--- it lacks that tool.
---@param root string?
---@param tool string
---@return string?
function M.venv_bin(root, tool)
  local venv = M.poetry_venv(root)
  local path = venv and (venv .. '/bin/' .. tool)
  if path and vim.fn.executable(path) == 1 then return path end
  return nil
end

local system_prefix

--- The environment holding a project's packages, as a VIRTUAL_ENV value: its Poetry venv, else the
--- prefix of the `python3` on PATH (/usr/local in the containers), or nil when there is neither.
---@param root string?
---@return string?
function M.python_prefix(root)
  local venv = M.poetry_venv(root)
  if venv then return venv end
  if system_prefix == nil then
    system_prefix = false
    if vim.fn.executable 'python3' == 1 then
      local result = vim.system({ 'python3', '-c', 'import sys; print(sys.prefix)' }, { text = true }):wait()
      local path = result.code == 0 and vim.trim(result.stdout or '') or ''
      if path ~= '' then system_prefix = path end
    end
  end
  return system_prefix or nil
end

return M
