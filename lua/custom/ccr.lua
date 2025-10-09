-- CCR: Command-line <CR> behavior ported from vimrc to Lua for Neovim
-- Original Vimscript reference:
-- function! CCR()
--   let cmdline = getcmdline()
--   if cmdline =~ '\v\C^(ls|files|buffers)'
--     return "\<CR>:b"
--   elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
--     return "\<CR>:"
--   elseif cmdline =~ '\C^marks'
--     return "\<CR>:norm! `"
--   else
--     return "\<CR>"
--   endif
-- endfunction
-- cnoremap <expr> <CR> CCR()

local M = {}

-- Return a termcoded string that Neovim will feed as keys from a command-line mapping
local function t(keys)
  return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

--- Lua port of CCR()
--- Inspects the current command-line and decides what keys to feed when <CR> is pressed.
--- Returns: string (termcoded keys)
function M.ccr()
  local cmdline = vim.fn.getcmdline()

  -- Case-sensitive checks, mirroring the Vimscript's \C
  if cmdline:match '^ls' or cmdline:match '^files' or cmdline:match '^buffers' then
    -- like :ls but prompts for a buffer command
    return t '<CR>:b'
  end

  -- Does it end with '/#' or '/nu[m[ber]]'?
  local suffixes = { '/#', '/nu', '/num', '/numb', '/numbe', '/number' }
  for _, suf in ipairs(suffixes) do
    if cmdline:sub(-#suf) == suf then
      return t '<CR>:'
    end
  end

  -- Like :marks but prompts for a mark to jump to
  if cmdline:match '^marks' then
    return t '<CR>:norm! `'
  end

  -- Default: just press <CR>
  return t '<CR>'
end

--- Optional helper to set the command-line mapping in Lua.
--- If you prefer to define the mapping from your init.lua, skip calling setup() and
--- instead use: vim.keymap.set('c', '<CR>', require('custom.plugins.ccr').ccr, { expr = true })
function M.setup()
  vim.keymap.set('c', '<CR>', M.ccr, { expr = true, desc = 'Smart <CR> in command-line (CCR)' })
end

return M
