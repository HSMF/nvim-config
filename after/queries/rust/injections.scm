; extends

(
  field_expression
  value: (macro_invocation
    macro: (scoped_identifier name: (identifier) @__sqlxquery)
    (token_tree (raw_string_literal) @sql)
  )
  (#eq? @__sqlxquery "query")
)

(
  field_expression
  value: (macro_invocation
    macro: (scoped_identifier name: (identifier) @__sqlxquery)
    (token_tree (raw_string_literal) @sql)
  )
  (#eq? @__sqlxquery "query_as")
)

(
 ((raw_string_literal) @glsl) (#match? @glsl "^r#\"[ \n]*#version") (#offset! @glsl 0 3 0 -2)
)

(
 ((raw_string_literal) @glsl) (#match? @glsl "^r##\"\s*#version") (#offset! @glsl 0 4 0 -3)
)
