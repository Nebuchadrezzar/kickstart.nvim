-- Human filesizes in netrw
vim.g.netrw_sizestyle = 'h'

-- Turn off word wrap
vim.o.wrap = false

-- Add project to the path
vim.opt.path = '**'

-- Center searches
vim.keymap.set({ 'n' }, 'n', 'nzz')
vim.keymap.set({ 'n' }, 'N', 'Nzz')

-- Keymapping for undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- Case searching
vim.o.infercase = true

-- Configure how new splits should be opened
vim.opt.splitkeep = 'screen'

-- adjust unimparied keymap to preview items in the location list
vim.keymap.set('n', ']l', 'j<CR><C-w>p', { desc = '[p]review the next location list item.' })
vim.keymap.set('n', '[l', 'k<CR><C-w>p', { desc = '[p]review the previous location list item.' })
