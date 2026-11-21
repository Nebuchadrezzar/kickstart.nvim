return {
  -- Add Ack search/replace
  -- (search the word under the cursor with Telescope's <leader>sw instead)
  'wincent/ferret',
  opts = {},
  keys = {
    { '<Leader>r', '<Plug>(FerretAcks)', desc = 'Acks [R]eplace' },
    { '<Leader>a', '<Plug>(FerretAck)', desc = '[A]ck' },
  },
}
