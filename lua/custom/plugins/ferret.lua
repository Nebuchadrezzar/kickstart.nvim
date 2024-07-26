return {
  -- Add Ack search/replace
  'wincent/ferret',
  opts = {},
  keys = {
    { '<Leader>s', '<Plug>(FerretAckWord)', { desc = 'Ack [S]earch' } },
    { '<Leader>r', '<Plug>(FerretAcks)', { desc = 'Acks [R]eplace' } },
    { '<Leader>a', '<Plug>(FerretAck)', { desc = '[A]ck' } },
  },
}
