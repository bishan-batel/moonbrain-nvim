(directive
  name: (identifier) @attribute) @attribute

(directive 
  (var_name_decl name: (identifier) @variable.parameter)
)

; (directive) @attribute.builtin

(comment) @comment

(number) @number

(string char: (char) @string)
(string escaped: (variable_ident)@string.escaped)

(string [ "\"" "\"\"\"" ] @string )

((identifier) @constant
  (#match? @constant "^[A-Z_][A-Z0-9_]+"))

(bool) @boolean

(variable_ident) @variable

((variable_ident) @variable.builtin
  (#any-of? @variable.builtin
        "self"
        "nil"
        "inputs"
        "outputs"
    ))

((variable_ident) @type
  (#match? @type "^[A-Z][A-Za-z0-9_]+"))

(type name: (identifier) @type)

(type 
  name: ((identifier) @type.builtin
  (#any-of? @type.builtin
   "number"
   "bool"
   "str"
   "dict"
   "any"
   "int"))
)

(fn_statement
	name: (identifier) @function)

(fn_statement
	param: (var_name_decl name: (identifier) @variable.parameter))


(function_call
  name: (identifier) @function.call)

(function_call
  name: (identifier) @function.call)

(property_expression
	property: (identifier) @field
)

[
 "let"
 "var"
] @keyword

(is_expression ["is" "not"] @keyword)

[
	"true"
	"false"
] @bool

[
 "func"
 "entrypoint"
] @keyword.function

[
 "if"
 "unless"
 "else"
 "match"
 "default"
] @keyword.conditional

[ "return" ] @keyword.return

[
 "("
 ")"
 "["
 "]"
 "{"
 "}"
] @punctuation.bracket

[
 "while"
 "for"
 "until"
] @repeat

[
 "\\n"
 "\\r"
] @string.escape

[
 ";"
 ","
 ":"
] @punctuation.delimeter


[
 "="
	"%="
	"^="
	"&="
	"*="
	"-="
	"+="
	"|="
	"/="
	"="
	"|"
	"^"
	"&"
	"=="
	"!="
  "<"
  "<="
  ">"
  ">="
  ">>"
  "<<"
  "+"
  "-"
  "/"
  "*"
  "%"
  "=>"
] @operator

[
  "mod"
  "not"
  "or"
  "and"
] @keyword.operator
