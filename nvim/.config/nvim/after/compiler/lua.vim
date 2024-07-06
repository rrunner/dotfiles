if exists("current_compiler")
  finish
endif
let current_compiler = "lua"

CompilerSet makeprg=lua\ %
CompilerSet errorformat=%s:\ %f:%l:%m


" vim: filetype=vim
