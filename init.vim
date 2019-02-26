set guicursor=
set nu
syntax enable
set mouse=a
set mousehide
set wrap
set autoindent
set shiftwidth=4
set expandtab
set tabstop=4
set softtabstop=4
set tags=tags;/
set splitright
set splitbelow
filetype plugin indent on
scriptencoding utf-8

" Plugins (from vim-plug)
call plug#begin('~/.vim/plugged')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'kaicataldo/material.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'kien/ctrlp.vim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'matze/vim-tex-fold'
    Plug 'derekwyatt/vim-scala'
    Plug 'scrooloose/nerdtree'
    Plug 'easymotion/vim-easymotion'
    Plug 'tpope/vim-obsession'
call plug#end()
let g:deoplete#enable_at_startup = 1

" CtrlP Settings
let g:ctrlp_root_markers = ['build.sbt', '*.latexmain', 'pom.xml']
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|log|toc|class|aux|blg|bbl|pdf|latexmain|out)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" Colors
set termguicolors
set background=dark
colorscheme material
let g:material_theme_style = 'dark'
let g:airline_theme = 'material'

" NERDTree Config
let NERDTreeQuitOnOpen=1
map <C-n> :NERDTreeToggle<CR>

" Easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Easymotion configuration
let mapleader = ","
let g:EasyMotion_leader_key = '<Leader>' 
map <Leader> <Plug>(easymotion-prefix)

" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Useful commands if sloppy fingers
:command WQ wq
:command Wq wq
:command W w
:command Q q

" Custom FileType Definition, for mappings see after/ftplugin/
au BufRead,BufNewFile *.gp setfiletype gnuplot

" Asynchronous run command using TMUX. All credits go to:
" https://gist.github.com/tracyone/65cffd685fc9b9308e50c1a1783d1fb0
" Flags:
"   0x1 hor split window
"   0x2 vertical split window
"   0x4 new window
"   0x8 run command in background
function! RunCommand(cmd, flag) abort
    let l:action = 'split-window -p 38 '
    "split
    if and(a:flag, 0x1)
        let l:action = 'split-window -p 38 '
    elseif and(a:flag, 0x2)
        let l:action = 'split-window -h -p 50 '
    elseif and(a:flag, 0x4)
        let l:action = 'new-window '
    endif
    if and(a:flag, 0x8)
        let l:action .= ' -d '
    endif
    call system('tmux '.l:action.string(a:cmd))
endfunction
