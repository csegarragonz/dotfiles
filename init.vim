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
call plug#end()
let g:deoplete#enable_at_startup = 1

" CtrlP Settings
let g:ctrlp_root_markers = ['build.sbt', '.latexmain']
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll|log|toc)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" Colors
set termguicolors
set background=dark
colorscheme material
let g:material_theme_style = 'dark'
let g:airline_theme = 'material'

"Remaps
:command WQ wq
:command Wq wq
:command W w
:command Q q
nmap <C-c> :! ~/useful_scripts/compile_tex.sh '%:t'<CR><CR>
nmap <C-w> :CtrlPCurWD<CR>
