set spell
nnoremap <buffer> <C-c> :! ~/dotfiles/tex/compile_tex_docker.sh '%:t'<CR>
nnoremap <buffer> <C-d> :! ~/dotfiles/tex/compile_tex_docker.sh clean<CR>
"nnoremap <buffer> <C-b> :! ~/useful_scripts/compile_beamer.sh '%:t'<CR>
nnoremap <buffer> <C-b> :call RunCommand("~/dotfiles/tex/compile_beamer.sh '%:t'", 0x2)<CR>
nnoremap <leader>c :! latexindent -m -s -g=/dev/null -l=/home/csegarra/dissemination/faabric-paper/faasmSettings.yaml -o=% %<CR>
