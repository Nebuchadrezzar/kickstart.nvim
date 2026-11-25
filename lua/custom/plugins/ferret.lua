return {
  -- Add Ack search/replace
  -- (search the word under the cursor with Telescope's <leader>sw instead)
  'wincent/ferret',
  -- Drop Ferret's default maps (<leader>s would shadow the Telescope <leader>s… prefix, plus
  -- <leader>l); the <Plug> maps below still work. Vimscript plugin, so no opts/setup().
  init = function() vim.g.FerretMap = 0 end,
  keys = {
    { '<Leader>r', '<Plug>(FerretAcks)', desc = 'Acks [R]eplace' },
    { '<Leader>a', '<Plug>(FerretAck)', desc = '[A]ck' },
  },
}
