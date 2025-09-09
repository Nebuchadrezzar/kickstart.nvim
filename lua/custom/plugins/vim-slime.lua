return {
  --Send text from one tmux pane to another
  {
    'jpalardy/vim-slime',
    keys = {
      { '<leader>zc', '<cmd>SlimeConfig<cr>', desc = 'Slime Config' },
      { '<leader>z', '<Plug>SlimeSendCell<BAR>/^# %%<CR>', desc = 'Slime Send Cell' },
      { '<leader>z', ":<C-u>'<,'>SlimeSend<CR>", mode = 'v', desc = 'Slime Send Selection' },
    },
    config = function()
      vim.g.slime_target = 'tmux'
      -- vim.g.slime_python_ipython = 1
      vim.g.slime_cell_delimiter = '# %%'
      vim.g.slime_bracketed_paste = 1
    end,
  },
}
