-- Locate a Python project's root and its Poetry virtualenv, shared by the language server
-- (basedpyright, init.lua) and the type checker (mypy, custom/plugins/lint.lua) so both see the same
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

return M
