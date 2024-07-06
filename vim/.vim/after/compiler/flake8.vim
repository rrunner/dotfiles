" flake8 - The modular source code checker: pep8, pyflakes and co
"
" Perform additional checks if plugins are installed. For example, in Arch,
" the base package is community/flake8.
"
" The currently installed flake8 plugin packages are:
" - community/python-flake8-black
" - community/python-flake8-docstrings
" - community/python-flake8-isort
" - community/python-flake8-typing-imports
"
" This results in black, docstrings, isort and type checks are performed in
" a single 'make' vim command once 'compiler flake8' is set.
if exists("current_compiler")
  finish
endif
let current_compiler = "flake8"

CompilerSet makeprg=flake8\ --doctests\ --docstring-convention\ pep257\ --isort-show-traceback\ %
CompilerSet errorformat=%f:%l:%c:\ %m


" vim: filetype=vim
