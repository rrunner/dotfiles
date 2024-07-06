if exists("current_compiler")
  finish
endif
let current_compiler = "r"

CompilerSet makeprg=Rscript\ %
CompilerSet errorformat=%f:%l:%m


" vim: filetype=vim
