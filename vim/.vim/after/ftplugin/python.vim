" python specific settings
setlocal expandtab
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal foldmethod=indent
"setlocal colorcolumn=89

" vim-tmux-runner python specific settings
let g:VtrStripLeadingWhitespace = 0
let g:VtrClearEmptyLines = 1
let g:VtrAppendNewline = 1

" python specific abbreviations
iabbrev <buffer> true True
iabbrev <buffer> false False

" autoset compiler
compiler python
