# kickstart.nvim

A personal Neovim config built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), aimed at Python/Django work. Requires Neovim 0.12+.

```sh
git clone https://github.com/Nebuchadrezzar/kickstart.nvim ~/.config/nvim
nvim  # lazy.nvim installs the plugins on first start
```

## Keymaps

Every mapping below was taken from a live dump of the loaded config. Leader is `<space>`; press it and which-key shows what follows, or use `<leader>sk` to fuzzy-search every keymap.

Modes: **n** normal, **x** visual, **v** visual + select, **o** operator-pending, **i** insert, **c** command-line, **t** terminal.

- [General](#general)
- [Bracket pairs](#bracket-pairs-neovim-built-in)
- [LSP](#lsp)
- [blink.cmp](#blinkcmp)
- [Text objects](#text-objects-the-grammar)
- [nvim-treesitter-textobjects](#nvim-treesitter-textobjects)
- [Treesitter selection](#treesitter-selection-neovim-built-in)
- [mini.ai](#miniai)
- [mini.surround](#minisurround)
- [telescope.nvim](#telescopenvim)
- [gitsigns.nvim](#gitsignsnvim)
- [ferret](#ferret)
- [aerial.nvim](#aerialnvim)
- [vim-slime](#vim-slime)
- [marks.nvim](#marksnvim)
- [vim-remotions](#vim-remotions)
- [nvim-tmux-navigation](#nvim-tmux-navigation)
- [vim-vinegar](#vim-vinegar)
- [vim-fugitive](#vim-fugitive)
- [faster.nvim](#fasternvim)
- [Everyday combos](#everyday-combos)
- [Gotchas](#gotchas)

### General

| Key | Description | Mode |
| --- | --- | --- |
| `<Esc>` | Clear search highlight | **n** |
| `n` / `N` | Next / prev search result, centered | **n** |
| `<C-d>` / `<C-u>` | Scroll half a page (ignores stray counts) | **n**, **x** |
| `<leader>u` | Toggle undo tree (built-in `nvim.undotree`) | **n** |
| `<leader>;` | `:g//#` — list matching lines with numbers | **n** |
| `<leader>d` | Toggle diagnostics (virtual text, underline, signs) | **n** |
| `<Esc><Esc>` | Exit terminal mode | **t** |
| `<CR>` | Smart Enter: after `:ls` prompts `:b`, after `:g/…/#` prompts `:`, after `:marks` prompts a mark jump | **c** |
| `gc` / `gcc` | Toggle comment (operator) / line | **n**, **x** |
| `gc` | Comment text object | **o** |
| `gx` | Open path or URL under cursor | **n**, **x** |
| `[<space>` / `]<space>` | Add blank line above / below | **n** |

### Bracket pairs (Neovim built-in)

Unimpaired-style pairs that ship with Neovim. Capitals jump to the first/last item.

| Key | Description | Mode |
| --- | --- | --- |
| `[q` / `]q` | Prev / next quickfix item | **n** |
| `[Q` / `]Q` | First / last quickfix item | **n** |
| `[<C-q>` / `]<C-q>` | Prev / next file in quickfix | **n** |
| `[<C-l>` / `]<C-l>` | Prev / next file in location list | **n** |
| `[l` / `]l` | Preview prev / next item (inside a quickfix or location window only) | **n** |
| `[b` / `]b` | Prev / next buffer | **n** |
| `[B` / `]B` | First / last buffer | **n** |
| `[a` / `]a` | Prev / next argument-list file | **n** |
| `[t` / `]t` | Prev / next tag match | **n** |
| `[d` / `]d` | Prev / next diagnostic | **n** |
| `[D` / `]D` | First / last diagnostic | **n** |
| `<C-w>d` | Show diagnostics under cursor | **n** |
| `zj` / `zk` | Start of next fold / end of prev fold | **n**, **x**, **o** |
| `]z` / `[z` | End / start of the fold the cursor is in | **n**, **x**, **o** |

### LSP

Set on `LspAttach`, so they exist only in buffers with a language server. Pickers open in Telescope.

| Key | Description | Mode |
| --- | --- | --- |
| `grd` | Goto definition | **n** |
| `grD` | Goto declaration | **n** |
| `grr` | References | **n** |
| `gri` | Goto implementation | **n** |
| `grt` | Goto type definition | **n** |
| `grn` | Rename | **n** |
| `gra` | Code action | **n**, **x** |
| `grx` | Run codelens | **n** |
| `gO` | Document symbols | **n** |
| `gW` | Workspace symbols | **n** |
| `K` | Hover | **n** |
| `<C-s>` | Signature help | **i**, **s** |
| `<leader>th` | Toggle inlay hints | **n** |
| `<leader>f` | Format buffer (conform.nvim) | **n**, **x**, **o** |

### [blink.cmp](https://github.com/saghen/blink.cmp)

`default` preset; sources are LSP, paths and LuaSnip snippets.

| Key | Description | Mode |
| --- | --- | --- |
| `<C-y>` | Accept completion (auto-imports, expands snippets) | **i** |
| `<C-n>` / `<C-p>` | Next / prev item | **i** |
| `<Down>` / `<Up>` | Next / prev item | **i** |
| `<C-space>` | Open menu, or toggle docs if already open | **i** |
| `<C-e>` | Hide menu | **i** |
| `<C-b>` / `<C-f>` | Scroll docs up / down | **i** |
| `<C-k>` | Toggle signature help | **i** |
| `<Tab>` / `<S-Tab>` | Jump to next / prev snippet placeholder | **i**, **s** |

### Text objects: the grammar

A text object is typed after an operator (or in Visual mode): **operator + `i`/`a` + object**. `i` means *inner* (contents only); `a` means *around* (contents plus delimiters or trailing whitespace). The cursor only needs to be somewhere inside the object, not at its start.

| Keys | Reads as | Effect |
| --- | --- | --- |
| `diw` | delete inner word | Deletes the word, leaves surrounding spaces |
| `daw` | delete a word | Deletes the word plus one side's whitespace |
| `ci"` | change inner quotes | Clears text between `"` and enters Insert |
| `da(` | delete a paren block | Deletes the parentheses and their contents |
| `yip` | yank inner paragraph | Copies the paragraph without the blank line after it |
| `vat` | select a tag | Visually selects an HTML/XML element including its tags |

A count works too: `d2i(` deletes the contents of the *second* enclosing paren pair, and in Visual mode repeating `i(` / `a(` grows the selection outward one level at a time.

### Built-in text objects

These ship with Neovim; no plugins needed. Bracket objects accept either the opening or closing character, plus a letter alias.

| Object | Inner (`i`) selects | Around (`a`) selects | Aliases |
| --- | --- | --- | --- |
| `w` word | The word | Word + trailing (or leading) space | — |
| `W` WORD | Whitespace-delimited run, e.g. `foo.bar()` | WORD + space | — |
| `s` sentence | The sentence | Sentence + trailing space | — |
| `p` paragraph | Lines up to a blank line | Paragraph + following blank lines | — |
| `"` `'` `` ` `` quotes | Text between quotes on the line | Quotes + contents + trailing space | — |
| `(` `)` parens | Contents | Parens + contents | `b` |
| `{` `}` braces | Contents | Braces + contents | `B` |
| `[` `]` brackets | Contents | Brackets + contents | — |
| `<` `>` angle brackets | Contents | Angles + contents | — |
| `t` tag | Content between `<x>` and `</x>` | Element including both tags | — |

Quote objects are line-local, and Neovim searches forward on the current line: `ci"` works even when the cursor sits before the first quote.

### Operators that pair with them

Every operator below takes any text object, built-in or plugin.

| Operator | Does | Example |
| --- | --- | --- |
| `d` | Delete | `da[` removes an index expression |
| `c` | Change (delete + Insert) | `cit` rewrites a tag's content |
| `y` | Yank | `yi{` copies a block body |
| `v` | Visual select | `vip` then `:sort` |
| `>` / `<` | Indent / dedent | `>i{` indents a block body |
| `=` | Reindent | `=ap` reformats a paragraph of code |
| `gq` | Rewrap text | `gqip` reflows a comment paragraph |
| `gu` / `gU` / `g~` | Lower / upper / toggle case | `gUiw` uppercases a word |
| `gc` | Toggle comment (built in since 0.10) | `gcip` comments a paragraph |
| `"_d` | Delete without touching the yank register | `"_di(` keeps the clipboard intact |

All of these repeat with `.` — `ci"` + new text, then `.` on the next string, is the fastest bulk edit there is.

### [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)

Main branch, `lookahead = true`: each object jumps forward to the next match if the cursor isn't inside one. **`af` is a function *call***; function *definitions* are on `m`.

| Key | Description | Mode |
| --- | --- | --- |
| `am` / `im` | Method/function definition / its body | **x**, **o** |
| `ac` / `ic` | Class / class body | **x**, **o** |
| `af` / `if` | Function call / its arguments | **x**, **o** |
| `aa` / `ia` | Argument incl. comma / argument only | **x**, **o** |
| `ai` / `ii` | Conditional / its body | **x**, **o** |
| `al` / `il` | Loop / its body | **x**, **o** |
| `a=` / `i=` | Assignment / the side under the cursor | **x**, **o** |
| `]m` / `[m` | Next / prev method/function start | **n**, **x**, **o** |
| `]M` / `[M` | Next / prev method/function end | **n**, **x**, **o** |
| `]c` / `[c` | Next / prev class start; in a diff window, next / prev change | **n**, **x**, **o** |
| `]C` / `[C` | Next / prev class end | **n**, **x**, **o** |
| `]f` / `[f` | Next / prev function call start | **n**, **x**, **o** |
| `]F` / `[F` | Next / prev function call end | **n**, **x**, **o** |
| `]i` / `[i` | Next / prev conditional start | **n**, **x**, **o** |
| `]I` / `[I` | Next / prev conditional end | **n**, **x**, **o** |
| `]l` / `[l` | Next / prev loop start | **n**, **x**, **o** |
| `]L` / `[L` | Next / prev loop end | **n**, **x**, **o** |
| `]s` / `[s` | Next / prev scope; with `spell` on, next / prev misspelling | **n**, **x**, **o** |
| `<leader>na` / `<leader>pa` | Swap parameter with next / prev | **n** |
| `<leader>nm` / `<leader>pm` | Swap function with next / prev | **n** |

Moves set the jumplist (`<C-o>` goes back) and repeat with `;` / `,` via vim-remotions.

### Treesitter selection (Neovim built-in)

| Key | Description | Mode |
| --- | --- | --- |
| `<C-space>` | Start selection at the current node | **n** |
| `<C-space>` | Grow selection to parent node | **x** |
| `<BS>` | Shrink selection to child node | **x** |
| `an` / `in` | Parent (outer) / child (inner) node | **x**, **o** |
| `]n` / `[n` | Select next / prev node | **x** |
| `]N` / `[N` | Select next / prev sibling node | **x** |

### [mini.ai](https://github.com/nvim-mini/mini.nvim)

Defaults with `n_lines = 500` and the next/last modifiers off, so `cin(` / `cil"` don't exist. The treesitter keys above win wherever both define one (`aa`, `af`, `ai`, `al`, …).

| Key | Description | Mode |
| --- | --- | --- |
| `aq` / `iq` | Nearest quote of any kind | **x**, **o** |
| `ab` / `ib` | Nearest bracket of any kind | **x**, **o** |
| `a(` `a[` `a{` `a"` … | Built-in objects, searching up to 500 lines and across lines | **x**, **o** |
| `at` / `it` | Tag, with forward search | **x**, **o** |
| `a?` / `i?` | Prompt for left and right delimiters | **x**, **o** |
| `a_` `a-` `a,` … | Any punctuation as a delimiter pair | **x**, **o** |
| `g[` / `g]` | Move to left / right edge of an object, e.g. `g[(` | **n**, **x**, **o** |

### [mini.surround](https://github.com/nvim-mini/mini.nvim)

Default `s` prefix. Append `n` / `l` to act on the next / previous surrounding instead of the enclosing one (`sdn"`, `srl)'`).

| Key | Description | Mode |
| --- | --- | --- |
| `sa` | Add surrounding: `saiw)`, `saam"` | **n**, **x** |
| `sd` / `sdn` / `sdl` | Delete surrounding: `sd'` | **n** |
| `sr` / `srn` / `srl` | Replace surrounding: `sr)'` | **n** |
| `sf` / `sF` | Find right / left surrounding | **n**, **x**, **o** |
| `sh` | Highlight surrounding | **n** |

Surrounding ids: `(` `[` `{` `<` add inner spaces, `)` `]` `}` `>` don't; `q` any quote, `b` any bracket, `t` tag, `f` function call (prompts for the name), `?` custom.

### [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

| Key | Description | Mode |
| --- | --- | --- |
| `<leader><leader>` | Find open buffers | **n** |
| `<leader>/` | Fuzzy search in current buffer | **n** |
| `<leader>s/` | Grep in open files | **n** |
| `<leader>sf` | Search files | **n** |
| `<leader>sg` | Live grep | **n** |
| `<leader>w` / `<leader>sw` | Search word under cursor / selection | **n**, **v** |
| `<leader>s.` | Recent files | **n** |
| `<leader>sr` | Resume last search | **n** |
| `<leader>sd` | Diagnostics | **n** |
| `<leader>sh` | Help tags | **n** |
| `<leader>sk` | Keymaps | **n** |
| `<leader>sc` | Commands | **n** |
| `<leader>sn` | Files in the Neovim config | **n** |
| `<leader>ss` | Pick a Telescope picker | **n** |

### [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

Buffer-local, in files tracked by git.

| Key | Description | Mode |
| --- | --- | --- |
| `]h` / `[h` | Next / prev hunk (diff change in diff mode) | **n** |
| `ih` | Hunk text object: `vih`, `dih` | **x**, **o** |
| `<leader>hs` | Stage hunk (or selected lines) | **n**, **v** |
| `<leader>hr` | Reset hunk (or selected lines) | **n**, **v** |
| `<leader>hS` | Stage buffer | **n** |
| `<leader>hR` | Reset buffer | **n** |
| `<leader>hp` | Preview hunk | **n** |
| `<leader>hi` | Preview hunk inline | **n** |
| `<leader>hb` | Blame line (full commit) | **n** |
| `<leader>hd` | Diff against index | **n** |
| `<leader>hD` | Diff against last commit | **n** |
| `<leader>hq` | Hunks in this file → quickfix | **n** |
| `<leader>hQ` | Hunks in whole repo → quickfix | **n** |
| `<leader>tb` | Toggle inline blame | **n** |
| `<leader>tw` | Toggle word diff | **n** |

### [ferret](https://github.com/wincent/ferret)

| Key | Description | Mode |
| --- | --- | --- |
| `<leader>a` | `:Ack` — project search into quickfix | **n** |
| `<leader>r` | `:Acks` — search and replace across quickfix results | **n** |

### [aerial.nvim](https://github.com/stevearc/aerial.nvim)

| Key | Description | Mode |
| --- | --- | --- |
| `<leader>v` | Toggle symbol outline sidebar | **n** |

### [vim-slime](https://github.com/jpalardy/vim-slime)

Target is tmux; cells are delimited by `# %%`.

| Key | Description | Mode |
| --- | --- | --- |
| `<leader>za` | Send current cell, then jump to the next | **n** |
| `<leader>zz` | Send selection | **v** |
| `<leader>zc` | Configure target pane | **n** |
| `<C-c><C-c>` | Send paragraph / selection (plugin default) | **n**, **x** |
| `<C-c>v` | Configure target pane (plugin default) | **n** |

### [marks.nvim](https://github.com/chentoast/marks.nvim)

Defaults; marks show in the sign column.

| Key | Description | Mode |
| --- | --- | --- |
| `m{a-z}` | Set mark | **n** |
| `m,` | Set next available lowercase mark | **n** |
| `m;` | Toggle next available mark on this line | **n** |
| `m]` / `m[` | Next / prev mark | **n** |
| `m:` | Preview mark | **n** |
| `dm{a-z}` | Delete mark | **n** |
| `dm-` | Delete all marks on this line | **n** |
| `dm<space>` | Delete all marks in buffer | **n** |
| `m0`–`m9` | Set bookmark from group 0–9 | **n** |
| `dm0`–`dm9` | Delete all bookmarks in group | **n** |
| `m}` / `m{` | Next / prev bookmark | **n** |
| `dm=` | Delete bookmark under cursor | **n** |

### [vim-remotions](https://github.com/vds2212/vim-remotions)

After any motion below, `;` repeats it forward and `,` backward.

| Key | Description | Mode |
| --- | --- | --- |
| `;` / `,` | Repeat last motion forward / backward | **n**, **v** |
| `f` `F` `t` `T` | Character find (the classic `;` behaviour) | **n**, **v** |
| `}` `{` / `)` `(` | Paragraph / sentence | **n**, **v** |
| `]m` `]M` `]c` `]C` `]f` `]F` `]i` `]I` `]l` `]L` `]s` | Treesitter moves and their `[` partners | **n**, **v** |
| `]]` `[[` `][` `[]` | Section / class (built-in) | **n**, **v** |
| `]q` `]b` `]a` `]t` `]d` | Quickfix, buffer, argument, tag, diagnostic | **n**, **v** |
| `zj` / `zk` | Next / prev fold | **n**, **v** |
| `g;` / `g,` | Change list | **n**, **v** |
| `<C-o>` / `<C-i>` | Jump list | **n**, **v** |
| `<C-d>` `<C-u>` `<C-f>` `<C-b>` | Half and full page scroll | **n**, **v** |
| `<C-e>` `<C-y>` / `zh` `zl` | Line / column scroll | **n**, **v** |
| `u` / `<C-r>` | Undo / redo | **n**, **v** |
| `<C-w>>` `<C-w><` `<C-w>+` `<C-w>-` | Window resize | **n**, **v** |
| `h` `j` `k` `l` `w` `b` `e` `W` `B` `ge` | Only when given a count, e.g. `5j` then `;` | **n**, **v** |

### [nvim-tmux-navigation](https://github.com/alexghergh/nvim-tmux-navigation)

| Key | Description | Mode |
| --- | --- | --- |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Move to left / lower / upper / right window or tmux pane | **n** |
| `<C-\>` | Move to last active window or pane | **n** |

### [vim-vinegar](https://github.com/tpope/vim-vinegar)

| Key | Description | Mode |
| --- | --- | --- |
| `-` | Open netrw on the current file's directory; in netrw, go up | **n** |
| `.` | In netrw: put the file under cursor on the command line | **n** |
| `y.` | In netrw: yank the absolute path | **n** |
| `~` | In netrw: go to home directory | **n** |

### [vim-fugitive](https://github.com/tpope/vim-fugitive)

Mostly commands (`:Git`, `:Gdiffsplit`, `:Gread`, `:GBrowse`).

| Key | Description | Mode |
| --- | --- | --- |
| `y<C-g>` | Yank the current fugitive object's path | **n** |
| `<C-r><C-g>` | Insert that path on the command line | **c** |

### [faster.nvim](https://github.com/pteroctopus/faster.nvim)

| Key | Description | Mode |
| --- | --- | --- |
| `@` | Run macro with heavy features (treesitter, LSP, etc.) paused | **n** |

### Everyday combos

The ones worth drilling:

| Keys | Use it for |
| --- | --- |
| `ciw` | Rename a variable at the cursor |
| `ciq` | Replace a string literal, whatever its quote style |
| `cib` | Rewrite the contents of the nearest bracket of any kind |
| `daa` / `cia` | Drop or rewrite one argument, comma handled |
| `vam` / `yam` | Select or copy a whole view or method |
| `dac` | Delete a whole class, e.g. a serializer |
| `ci=` | Change the side of an assignment under the cursor, e.g. a model field definition |
| `cii` | Rewrite the body of an `if` |
| `<C-space>` (repeat) | Grow the selection node by node; `<BS>` to back off |
| `]m` then `;` `;` | Walk method by method through a file |
| `<leader>na` | Swap an argument with the next one |
| `vih` | Select the current git hunk |

### Gotchas

- mini.surround's `s` prefix replaces built-in `s` (substitute character). Use `cl` for that instead.
