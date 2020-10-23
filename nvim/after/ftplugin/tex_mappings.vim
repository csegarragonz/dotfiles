set spell
nnoremap <buffer> <C-c> :! ~/dotfiles/tex/compile_tex.sh '%:t'<CR>
"nnoremap <buffer> <C-b> :! ~/useful_scripts/compile_beamer.sh '%:t'<CR>
nnoremap <buffer> <C-b> :call RunCommand("~/dotfiles/tex/compile_beamer.sh '%:t'", 0x2)<CR>
nnoremap <leader>t :! latexindent -m -s -g=/dev/null -l=/home/csegarra/dissemination/hpc-paper/faasmSettings.yaml -o=% %<CR>
