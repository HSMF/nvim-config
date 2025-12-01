syntax match Operator "[+=<>|]"
syntax match Operator "\V<>"
syntax match Operator "\V->"

syntax match Delimiter "[(){}\[\]]"

syntax keyword Keyword default Role extends read update add null self caller value and or xor not implies create delete fullAccess anonymous

syntax match Identifier "\<\w*\>"
syntax match Type "\<[A-Z]\w*\>"
syntax match Label "\<[A-Z]+\>"
syntax match Label "\<[A-Z]\+\>"

syntax keyword Function any asBag asOrderedSet asSequence asSet collect count excludes excludesAll excluding exists flatten forAll includes
syntax keyword Function includesAll including isEmpty isUnique notEmpty one product reject select size sum

syntax keyword Function intersection symmetricDifference union

syntax keyword Function append at first indexOf insertAt last prepend subSequence union

syntax match Error "\V=="
