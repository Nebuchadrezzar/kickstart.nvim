-- Ctrl-h/j/k/l move between Neovim windows and, at the edge, on into the
-- neighboring tmux pane. The tmux side is the christoomey/vim-tmux-navigator
-- plugin in ~/.tmux.conf, which passes these keys to Neovim when it has focus.
-- (Replaces kickstart's plain <C-w> window keymaps in init.lua.)
return {
  'alexghergh/nvim-tmux-navigation',
  config = function()
    local nav = require 'nvim-tmux-navigation'
    nav.setup {
      disable_when_zoomed = true, -- don't leave a zoomed tmux pane
    }
    vim.keymap.set('n', '<C-h>', nav.NvimTmuxNavigateLeft, { desc = 'Move focus to the left window/pane' })
    vim.keymap.set('n', '<C-j>', nav.NvimTmuxNavigateDown, { desc = 'Move focus to the lower window/pane' })
    vim.keymap.set('n', '<C-k>', nav.NvimTmuxNavigateUp, { desc = 'Move focus to the upper window/pane' })
    vim.keymap.set('n', '<C-l>', nav.NvimTmuxNavigateRight, { desc = 'Move focus to the right window/pane' })
    vim.keymap.set('n', '<C-\\>', nav.NvimTmuxNavigateLastActive, { desc = 'Move focus to the last window/pane' })
  end,
}
