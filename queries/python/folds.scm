; Replaces nvim-treesitter's Python folds (no ";extends" line, so this overrides it).
; Fold only classes, functions, while loops and import groups, not other blocks, brackets or strings.
[
  (function_definition)
  (class_definition)
  (while_statement)
] @fold

[
  (import_statement)
  (import_from_statement)
]+ @fold
