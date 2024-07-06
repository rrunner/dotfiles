if exists("current_compiler")
  finish
endif
let current_compiler = "python"

" use python system interpreter when running files
CompilerSet makeprg=python\ %
CompilerSet errorformat=\%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
    \%C\ \ \ \ %.%#,
    \%+Z%.%#Error\:\ %.%#,
    \%A\ \ File\ \"%f\"\\\,\ line\ %l,
    \%+C\ \ %.%#,
    \%-C%p^,
    \%Z%m,
    \%-G%.%#


" vim: filetype=vim
