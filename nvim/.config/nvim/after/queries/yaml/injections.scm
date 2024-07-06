; extends
; sql: select * from cars where gear=4
(block_mapping_pair
  key: (flow_node) @_sql
  (#any-of? @_sql "sql")
  value:
    (flow_node
      (plain_scalar
        (string_scalar) @injection.content)
      (#set! injection.language "sql")))

; sql: "select * from cars where gear=4"
; or...
; sql: "
;   select
;   *
;   from cars
;   where gear=4
;   "
(block_mapping_pair
  key: (flow_node) @_sql
  (#any-of? @_sql "sql")
  value:
    (flow_node
        (double_quote_scalar) @injection.content)
    (#offset! @injection.content 0 1 0 -1) ; remove leading/trailing double quote
    (#set! injection.language "sql"))
