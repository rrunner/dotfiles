" haskell specific settings
" global formatoptions are not respected in haskell files
" reset global options locally in haskell files
setlocal formatoptions-=c
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal formatoptions+=j
setlocal formatoptions+=q

" haskell specific abbreviations
iabbrev <buffer> true True
iabbrev <buffer> false False
