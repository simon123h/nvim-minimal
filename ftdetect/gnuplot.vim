au BufRead,BufNewFile *.plt set filetype=gnuplot
au BufRead,BufNewFile *.gnuplot set filetype=gnuplot
autocmd FileType gnuplot setlocal commentstring=#\ %s
