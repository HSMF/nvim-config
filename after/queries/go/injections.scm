; extends

((comment) @injection.content
  (#match? @injection.content "^// *\\@")
  (#offset! @injection.content 0 4 0 0)
  (#set! injection.language "gobra"))
