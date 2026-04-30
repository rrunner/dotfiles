; extends

; conceal the backslash in backslash escapes
((backslash_escape) @conceal
  (#offset! @conceal 0 0 0 -1)
  (#set! conceal ""))
