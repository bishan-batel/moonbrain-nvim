
[
 "{"
 "}"
 "["
 "]"
 "("
 ")"
] @indent.branch

[
 (block)
 (match_statement)
 (directive)
 (paren_expression)
 (array)
] @indent.begin


(match_statement "}" @indent.end)
(block "}" @indent.end)
(directive ")" @indent.end)
(paren_expression ")" @indent.end)
(array "]" @indent.end)

[
 (comment)
] @indent.ignore
