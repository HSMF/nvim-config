; extends

(
 (call
   function: (attribute
               object: (identifier) @_conn (#match? @_conn "^con|cur")
               attribute: (identifier) @_execute (#match? @_execute "execute")
               )
   arguments: (
               argument_list (string (string_content) @injection.content))
   )
 (#set! injection.language "sql")
 )


