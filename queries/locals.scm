; Scopes
[
  (source_file)
  (function_declaration)
  (block)
  (loop_statement)
] @local.scope

; Definitions
(function_declaration
  name: (identifier) @local.definition.function)

(parameter
  name: (identifier) @local.definition.parameter)

(variable_declaration
  name: (identifier) @local.definition.variable)

(constant_declaration
  name: (identifier) @local.definition.constant)

(enum_declaration
  name: (identifier) @local.definition.type)

(struct_declaration
  name: (identifier) @local.definition.type)

(tuple_assignment
  names: (identifier_list
    (identifier) @local.definition.variable))

; References
(identifier) @local.reference
