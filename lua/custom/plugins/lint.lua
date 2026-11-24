-- Type checking for Python with mypy + django-stubs, run on save.
--
-- Pyright/basedpyright can't see what Django adds at runtime (implicit `id`, reverse relations such as
-- `deal_set`, `user.profile`), so its attribute errors are false positives on Django models. mypy's
-- django-stubs plugin runs django.setup() and knows those attributes. basedpyright stays the language
-- server for completion and navigation; mypy is the type checker.
--
-- The django-stubs plugin runs inside the mypy process, so mypy must come from the project's own
-- environment (a Mason or pipx mypy can't load it): the Poetry venv locally, the system Python in the
-- client containers (no venv there; `mypy` is on PATH from requirements-dev.txt).

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-lint',
  ft = 'python',
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = { python = { 'mypy' } }

    local python_env = require 'custom.python_env'
    -- mypy reads its config (setup.cfg: plugins, django_settings_module) from the project root and
    -- resolves `django_project.settings` relative to it, so run it there.
    local project_root = python_env.root

    lint.linters.mypy.cmd = function() return python_env.venv_bin(project_root(0), 'mypy') or 'mypy' end

    -- mypy takes a few seconds per run, so check on open and save rather than on every edit.
    local function run(bufnr)
      if vim.bo[bufnr].filetype == 'python' and vim.bo[bufnr].modifiable and vim.api.nvim_buf_get_name(bufnr) ~= '' then
        vim.api.nvim_buf_call(bufnr, function() lint.try_lint(nil, { cwd = project_root(bufnr) }) end)
      end
    end
    local group = vim.api.nvim_create_augroup('custom-lint', { clear = true })
    vim.api.nvim_create_autocmd('FileType', { group = group, pattern = 'python', callback = function(e) run(e.buf) end })
    vim.api.nvim_create_autocmd('BufWritePost', { group = group, pattern = '*.py', callback = function(e) run(e.buf) end })
    -- This plugin loads on the first Python buffer's FileType event, after it fired, so check that buffer now.
    run(vim.api.nvim_get_current_buf())
  end,
}
