return {
  -- slime (REPL integration)
  {
    'jpalardy/vim-slime',
    keys = {
      { '<leader>zc', '<cmd>SlimeConfig<cr>', desc = 'Slime Config' },
      { '<leader>za', '<Plug>SlimeSendCell<BAR>/^# %%<CR>', desc = 'Slime Send Cell' },
      { '<leader>zz', ":<C-u>'<,'>SlimeSend<CR>", mode = 'v', desc = 'Slime Send Selection' },
    },
    config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_cell_delimiter = '# %%'
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_dont_ask_default = 1
    end,
  },
}
