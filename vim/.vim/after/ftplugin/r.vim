" R specific settings
setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
"setlocal colorcolumn=81

" vim-tmux-runner R specific settings
nnoremap <localleader>or :VtrOpenRunner {'cmd': 'R'}<cr>

" insert mode mappings
inoremap <> <-<space>
inoremap >> %>%<space>

" R specific abbreviations
iabbrev <buffer> true TRUE
iabbrev <buffer> false FALSE

" autoset compiler
compiler r
