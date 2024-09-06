; extends

((comment) @injection.content
  (#match? @injection.content "^// *\\@")
  (#offset! @injection.content 0 4 0 0)
  (#set! injection.language "gobra"))

((comment) @injection.content
  (#match? @injection.content "^/\\* *\\@.*\\@ *\\*/$")
  (#offset! @injection.content 0 4 0 -4)
  (#set! injection.language "gobra"))


(
  (call_expression
    function: (selector_expression
      operand: (_) @db
      field: (field_identifier) @exec
      )
    arguments: (argument_list . [ (raw_string_literal) (interpreted_string_literal) ] @injection.content)
   )
  (#match? @db "(pool|db|tx)$")
  (#match? @exec "^(Exec|Prepare|Query|QueryRow)$")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql")
)
