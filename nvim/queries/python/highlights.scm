;; extends

; Need to override lsp stuff which is usually around 125

((identifier) @variable.builtin
  (#eq? @variable.builtin "self")
  (#set! "priority" 130))

((identifier) @variable.builtin
  (#eq? @variable.builtin "cls")
  (#set! "priority" 130))
