local motions = {
  para = { backward = "{", forward = "}" },
  sentence = { backward = "(", forward = ")" },
  change = { backward = "g,", forward = "g;" },
  class = { backward = "[[", forward = "]]" },
  classend = { backward = "[]", forward = "][" },
  -- Treesitter textobject moves (lua/custom/plugins/nvim-treesitter-textobjects.lua)
  method = { backward = "[m", forward = "]m" },
  methodend = { backward = "[M", forward = "]M" },
  call = { backward = "[f", forward = "]f" },
  callend = { backward = "[F", forward = "]F" },
  tsclass = { backward = "[c", forward = "]c" },
  tsclassend = { backward = "[C", forward = "]C" },
  conditional = { backward = "[i", forward = "]i" },
  conditionalend = { backward = "[I", forward = "]I" },
  loop = { backward = "[l", forward = "]l" }, -- in a quickfix/location window: preview items
  loopend = { backward = "[L", forward = "]L" },
  scope = { backward = "[s", forward = "]s" }, -- with 'spell' set: misspellings
  fold = { backward = "zk", forward = "zj" }, -- built-in; ]z/[z stay end/start of current fold

  line = { backward = "k", forward = "j", repeat_if_count = 1, repeat_count = 1 },
  char = { backward = "h", forward = "l", repeat_if_count = 1, repeat_count = 1 },
  word = { backward = "b", forward = "w", repeat_if_count = 1, repeat_count = 1 },
  fullword = { backward = "B", forward = "W", repeat_if_count = 1, repeat_count = 1 },
  wordend = { backward = "ge", forward = "e", repeat_if_count = 1, repeat_count = 1 },
  pos = { backward = "<C-i>", forward = "<C-o>" },
  page = { backward = "<C-u>", forward = "<C-d>" },
  pagefull = { backward = "<C-b>", forward = "<C-f>" },
  undo = { backward = "u", forward = "<C-r>", direction = 1 },
  linescroll = { backward = "<C-e>", forward = "<C-y>" },
  charscroll = { backward = "zh", forward = "zl" },
  vsplit = { backward = "<C-w><", forward = "<C-w>>" },
  hsplit = { backward = "<C-w>-", forward = "<C-w>+" },
  arg = { backward = "[a", forward = "]a" },
  buffer = { backward = "[b", forward = "]b" },
  quickfix = { backward = "[q", forward = "]q" },
  tag = { backward = "[t", forward = "]t" },
  diagnostic = { backward = "[d", forward = "]d" },
}

local leap_motions = {
  leap_fwd = {
    backward = "<Plug>(leapbackward)",
    forward = "<Plug>(leapforward)",
    motion = "s",
    motion_plug = "<Plug>(leap-forward-to)",
  },
  leap_bck = {
    backward = "<Plug>(leapforward)",
    forward = "<Plug>(leapbackward)",
    motion = "S",
    motion_plug = "<Plug>(leap-backward-to)",
  },
}

return {
  "vds2212/vim-remotions",
  event = { "BufRead", "BufWinEnter", "BufNewFile" },

  config = function()
    if vim.g.loaded_leap then
      vim.g.remotions_motions = vim.tbl_deep_extend("error", motions, leap_motions)
    else
      vim.g.remotions_motions = motions
    end
  end,
}
