-- Human filesizes in netrw
vim.g.netrw_sizestyle = 'h'

-- Turn off word wrap
vim.o.wrap = false

-- Add project to the path
vim.opt.path = '**'

-- <C-d>/<C-u> always scroll half a window. Built in, a count (e.g. a stray `1<C-d>`)
-- permanently sets 'scroll' for the window, so every later <C-d> moves only that many lines.
-- Resetting 'scroll' to 0 (= half the window height) and running the key with :normal!
-- (which drops any typed count) keeps it at half a page.
for _, key in ipairs { '<C-d>', '<C-u>' } do
  vim.keymap.set({ 'n', 'x' }, key, function()
    vim.wo.scroll = 0
    vim.cmd.normal { vim.keycode(key), bang = true }
  end, { desc = key == '<C-d>' and 'Scroll half a page down' or 'Scroll half a page up' })
end

-- Center searches
vim.keymap.set({ 'n' }, 'n', 'nzz')
vim.keymap.set({ 'n' }, 'N', 'Nzz')

-- Built-in undo tree (Neovim 0.12): moving the cursor in its window steps through undo history
-- (loaded on first use: lazy.nvim resets the runtimepath at startup, which drops an earlier :packadd)
vim.keymap.set('n', '<leader>u', function()
  vim.cmd.packadd 'nvim.undotree'
  require('undotree').open()
end, { desc = 'Toggle [U]ndo tree' })

-- Built-in: clear search highlighting after 'updatetime' idle or on entering Insert mode
-- (replaces vim-cool; <Esc> also clears it, see init.lua)
vim.cmd.packadd 'nohlsearch'

-- Case searching
vim.o.infercase = true

-- Configure how new splits should be opened
vim.opt.splitkeep = 'screen'

-- Inside a location/quickfix list window, ]l / [l preview the next / previous item:
-- open it in the previous window and come back to the list. Buffer-local, so in code
-- buffers ]l / [l stay the treesitter "next/previous loop" moves.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  group = vim.api.nvim_create_augroup('custom-qf-preview', { clear = true }),
  callback = function(event)
    -- Scheduled: vim-remotions' own FileType handler runs after this one and replaces
    -- every buffer-local [x / ]x key with its wrapper of the global key.
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(event.buf) then return end
      vim.keymap.set('n', ']l', 'j<CR><C-w>p', { buffer = event.buf, desc = 'Preview the next list item' })
      vim.keymap.set('n', '[l', 'k<CR><C-w>p', { buffer = event.buf, desc = 'Preview the previous list item' })
    end)
  end,
})

-- Enable undercurl
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]

-- Normal-mode, non-recursive (default), no remap needed.
vim.keymap.set('n', '<leader>;', ':g//#<Left><Left>', { desc = 'Global :g/<pattern>/# (print line numbers for matches)' })
