" yaml specific settings
" global formatoptions are not respected in yaml files
" reset global options locally in yaml files
setlocal formatoptions-=c
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal formatoptions+=r
setlocal formatoptions+=q
setlocal formatoptions+=n
setlocal formatoptions+=l
setlocal formatoptions+=1
setlocal formatoptions+=j
setlocal formatoptions+=t
