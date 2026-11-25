-- Treesitter text objects: select, swap and move by syntax node.
-- Uses the `main` branch, which matches nvim-treesitter's `main` branch. It has no
-- setup-table keymaps: each key is an ordinary vim.keymap.set below.
-- Incremental selection (<C-space> / <BS>) is in init.lua (Neovim's built-in version).
return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  lazy = false, -- the main branch doesn't support lazy-loading
  init = function()
    -- Python's ftplugin maps ]m [m ]M [M ]] [[ per buffer, which would override the
    -- global move keys below. (Its [[ / ]] class jumps go too; use [c / ]c.)
    vim.g.no_python_maps = true
  end,
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
      },
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    }

    local select = require 'nvim-treesitter-textobjects.select'
    local swap = require 'nvim-treesitter-textobjects.swap'
    local move = require 'nvim-treesitter-textobjects.move'

    -- Select: {key, capture, description}
    local selects = {
      { 'a=', '@assignment.outer', 'Select outer part of an assignment' },
      -- In Python, i= matches both sides, so it picks whichever side the cursor is on. No l= / r=:
      -- in x/o mode they would make l (cl, dl) and r wait for timeoutlen.
      { 'i=', '@assignment.inner', 'Select the side of an assignment under the cursor' },

      { 'aa', '@parameter.outer', 'Select outer part of a parameter/argument' },
      { 'ia', '@parameter.inner', 'Select inner part of a parameter/argument' },

      { 'ai', '@conditional.outer', 'Select outer part of a conditional' },
      { 'ii', '@conditional.inner', 'Select inner part of a conditional' },

      { 'al', '@loop.outer', 'Select outer part of a loop' },
      { 'il', '@loop.inner', 'Select inner part of a loop' },

      { 'af', '@call.outer', 'Select outer part of a function call' },
      { 'if', '@call.inner', 'Select inner part of a function call' },

      { 'am', '@function.outer', 'Select outer part of a method/function definition' },
      { 'im', '@function.inner', 'Select inner part of a method/function definition' },

      { 'ac', '@class.outer', 'Select outer part of a class' },
      { 'ic', '@class.inner', 'Select inner part of a class' },
    }
    for _, s in ipairs(selects) do
      local key, capture, desc = s[1], s[2], s[3]
      vim.keymap.set({ 'x', 'o' }, key, function() select.select_textobject(capture, 'textobjects') end, { desc = desc })
    end

    -- Swap with the next / previous node
    vim.keymap.set('n', '<leader>na', function() swap.swap_next '@parameter.inner' end, { desc = 'Swap parameter with next' })
    vim.keymap.set('n', '<leader>nm', function() swap.swap_next '@function.outer' end, { desc = 'Swap function with next' })
    vim.keymap.set('n', '<leader>pa', function() swap.swap_previous '@parameter.inner' end, { desc = 'Swap parameter with previous' })
    vim.keymap.set('n', '<leader>pm', function() swap.swap_previous '@function.outer' end, { desc = 'Swap function with previous' })

    -- Move: {key, move function, capture, query group, description, window option}
    -- When the window option is set (diff, spell), the key falls back to its built-in meaning.
    local moves = {
      { ']f', 'goto_next_start', '@call.outer', 'textobjects', 'Next function call start' },
      { ']m', 'goto_next_start', '@function.outer', 'textobjects', 'Next method/function def start' },
      { ']c', 'goto_next_start', '@class.outer', 'textobjects', 'Next class start (diff: next change)', 'diff' },
      { ']i', 'goto_next_start', '@conditional.outer', 'textobjects', 'Next conditional start' },
      { ']l', 'goto_next_start', '@loop.outer', 'textobjects', 'Next loop start' },
      { ']s', 'goto_next_start', '@local.scope', 'locals', 'Next scope (spell: next misspelling)', 'spell' },

      { ']F', 'goto_next_end', '@call.outer', 'textobjects', 'Next function call end' },
      { ']M', 'goto_next_end', '@function.outer', 'textobjects', 'Next method/function def end' },
      { ']C', 'goto_next_end', '@class.outer', 'textobjects', 'Next class end' },
      { ']I', 'goto_next_end', '@conditional.outer', 'textobjects', 'Next conditional end' },
      { ']L', 'goto_next_end', '@loop.outer', 'textobjects', 'Next loop end' },

      { '[f', 'goto_previous_start', '@call.outer', 'textobjects', 'Prev function call start' },
      { '[m', 'goto_previous_start', '@function.outer', 'textobjects', 'Prev method/function def start' },
      { '[c', 'goto_previous_start', '@class.outer', 'textobjects', 'Prev class start (diff: prev change)', 'diff' },
      { '[i', 'goto_previous_start', '@conditional.outer', 'textobjects', 'Prev conditional start' },
      { '[l', 'goto_previous_start', '@loop.outer', 'textobjects', 'Prev loop start' },
      { '[s', 'goto_previous_start', '@local.scope', 'locals', 'Prev scope (spell: prev misspelling)', 'spell' },

      { '[F', 'goto_previous_end', '@call.outer', 'textobjects', 'Prev function call end' },
      { '[M', 'goto_previous_end', '@function.outer', 'textobjects', 'Prev method/function def end' },
      { '[C', 'goto_previous_end', '@class.outer', 'textobjects', 'Prev class end' },
      { '[I', 'goto_previous_end', '@conditional.outer', 'textobjects', 'Prev conditional end' },
      { '[L', 'goto_previous_end', '@loop.outer', 'textobjects', 'Prev loop end' },
    }
    for _, m in ipairs(moves) do
      local key, fn, capture, group, desc, builtin_when = m[1], m[2], m[3], m[4], m[5], m[6]
      if builtin_when then
        -- While the window option is set, return the key itself (expr maps are noremap, so it
        -- reaches Vim's own ]c / ]s etc., with counts and operators working as usual); otherwise
        -- run the treesitter move through <Cmd>, since an expr map can't move the cursor itself.
        local cmd = ('<Cmd>lua require("nvim-treesitter-textobjects.move").%s(%q, %q)<CR>'):format(fn, capture, group)
        vim.keymap.set({ 'n', 'x', 'o' }, key, function() return vim.wo[builtin_when] and key or cmd end, { expr = true, desc = desc })
      else
        vim.keymap.set({ 'n', 'x', 'o' }, key, function() move[fn](capture, group) end, { desc = desc })
      end
    end

    -- Repeating these moves (and f/F/t/T) with ; and , is done by vim-remotions:
    -- see the "Treesitter textobject moves" entries in lua/custom/plugins/vim-remotions.lua.
  end,
}
