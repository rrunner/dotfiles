; extends

; SQL in string content for assignment: sql_query = "select * from test.table"
(assignment
  left: (identifier) @id
  right: (string (string_content) @injection.content)
  (#match? @id "sql")
  (#set! injection.language "sql"))

; SQL in string content for expressions: duckdb.sql("select * from test.table")
(expression_statement
  (call
    (attribute
      attribute: (identifier) @_attribute (#any-of? @_attribute "sql")
    )

    (argument_list
      (string
        (string_content) @injection.content
        (#set! injection.language "sql")
      )
    )
  )
)

; raw strings as regex if variable has a certain name: rgx = r"\*"
(
 assignment
  left: (identifier) @variable_name
  right: (string (string_content) @injection.content)
  (#any-of? @variable_name "pattern" "rgx")
  (#set! injection.language "regex")
)
