" yaml specific settings
" global formatoptions are not respected in yaml files
" reset global options locally in yaml files
setlocal formatoptions-=c
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal formatoptions+=j
setlocal formatoptions+=q
