; extends

(list_lit
    .
    (sym_lit) @keyword
    (#any-of? @keyword
            "define-fun" "define-const"
            "assert" "push"
            "pop" "assert"
            "check-sat" "declare-const"
            "declare-fun" "get-model"
            "get-value" "declare-sort"
            "declare-datatypes" "reset"
            "eval" "set-logic"
            "help" "get-assignment"
            "exit" "get-proof"
            "get-unsat-core" "echo"
            "let" "forall"
            "exists" "define-sort"
            "set-option" "get-option"
            "set-info" "check-sat-using"
            "apply" "simplify"
            "display" "as" "!"
            "get-info" "declare-map"
            "declare-rel" "declare-var"
            "rule" "query"
            "get-user-tactics"))


(list_lit
    .
    (sym_lit) @function.builtin
    (#any-of? @function.builtin
    "mod" "div" "rem" "^" "to_real" "and" "or" "not" "distinct"
    "to_int" "is_int" "~" "xor" "if" "ite" "true" "false" "root-obj"
    "sat" "unsat" "const" "map" "store" "select" "sat" "unsat"
    "bit1" "bit0" "bvneg" "bvadd" "bvsub" "bvmul" "bvsdiv" "bvudiv" "bvsrem"
    "bvurem" "bvsmod"  "bvule" "bvsle" "bvuge" "bvsge" "bvult"
    "bvslt" "bvugt" "bvsgt" "bvand" "bvor" "bvnot" "bvxor" "bvnand"
    "bvnor" "bvxnor" "concat" "sign_extend" "zero_extend" "extract"
    "repeat" "bvredor" "bvredand" "bvcomp" "bvshl" "bvlshr" "bvashr"
    "rotate_left" "rotate_right" "get-assertions"))


(list_lit
    .
    (sym_lit) @operator
    (#any-of? @operator
    "=" ">" "<" "<=" ">=" "=>" "+" "-" "*" "/"
     ))
