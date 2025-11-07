; Keywords - match only standalone keywords, not within identifiers
"if" @keyword
"then" @keyword
"else" @keyword
"elseif" @keyword
"loop" @keyword
"do" @keyword
"switch" @keyword
"when" @keyword
"import" @keyword
"struct" @keyword
"enum" @keyword
"program" @keyword
"return" @keyword
"assert" @keyword
"defer" @keyword
"infer" @keyword
"void" @keyword

; Statement types - these are their own nodes
(halt_statement) @keyword.control
(next_statement) @keyword.control



; Function declarations
(function_declaration
  name: (identifier) @function)

; Function calls
(call_expression
  function: (identifier) @function.call)

; Built-in functions
((identifier) @function.builtin
  (#match? @function.builtin "^(ahoy|ahoyf|print|printf|sprintf|sahoyf)$"))

; Types
(type) @type

[
  "int"
  "float"
  "string"
  "bool"
  "char"
  "dict"
  "array"
  "vector2"
  "color"
  "void"
] @type.builtin

; Variables
(parameter
  name: (identifier) @variable.parameter)

(variable_declaration
  name: (identifier) @variable)

(constant_declaration
  name: (identifier) @constant)

(struct_declaration
  name: (identifier) @type)

(struct_field
  name: (identifier) @property)

(enum_declaration
  name: (identifier) @type)

(enum_member
  name: (identifier) @constant)

(field_assignment
  field: (identifier) @property)

(property_access
  property: (identifier) @property)

; Operators
[
  "plus"
  "minus"
  "times"
  "div"
  "mod"
  "greater_than"
  "less_than"
  "is"
  "and"
  "or"
  "not"
  "+"
  "-"
  "*"
  "/"
  "%"
  ">"
  "<"
  ">="
  "<="
  "??"
] @operator

; Punctuation
[
  ":"
  "::"
  ":="
  ","
  "|"
] @punctuation.delimiter

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

; Literals
(string) @string
(fstring) @string.special
(char) @character
(number) @number
(boolean) @boolean

; Typed object literals
(typed_object_literal
  type_name: (identifier) @type)

; Comments
(comment) @comment

; Imports
(import_statement
  path: (string) @string.special)

; Generic identifiers (fallback)
(identifier) @variable
