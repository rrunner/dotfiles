" readline specific settings
" global formatoptions are not respected in readline files
" reset global options locally in readline files
setlocal formatoptions-=c
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal formatoptions+=j
setlocal formatoptions+=q
