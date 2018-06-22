" Modeline and Notes {
"   This .vimrc file is based on the one by Steve Francia. I tweaked it myself
"   to use only the stuff I understand and I really use and so to make it as
"   expandable as possible fitting my needs.
"
"   Carlos Segarra - Barcelona 25th January 2018
"
" }
    execute pathogen#infect()

    set nocompatible        " Must be first line

        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif

    " Color related issues
    set t_Co=256    " Important to let vi know I want 256 colors
    syntax enable                   " Syntax highlighting
    let g:solarized_termcolors=256
"   Depending on your distribution you might want to uncomment the following
"   lines. You would need to do so if colorscheme is not working right.
"    let g:solarized_termtrans=1
    let g:solarized_contrast="normal"
    let g:solarized_visibility="normal"
    colorscheme solarized
    set background=dark        " Assume a dark background
    let g:airline_theme='solarized'
    filetype plugin indent on   " Automatically detect file types.
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    " Special programming languages highlights
    let g:python_highlight_all = 1  "Python syntax highlight
    let g:python_highlight_builtins = 1
    let g:python_highlight_operators = 1
    let g:python_highlight_exceptions = 1
    let g:python_highlight_string_formatting = 1
    let g:python_highlight_string_templates = 1
    let g:python_highlight_indent_errors = 1
    let g:python_highlight_space_errors = 1
    let g:python_highlight_class_vars = 1

    " Stuff for C-Lang
    let g:ycm_global_ycm_extra_conf = ''

    " Dealing with undo files
    set undodir=~/.vim/undo
    set backupdir=~/.vim/backup

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    "set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    "set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    "set virtualedit=onemore             " Allow for cursor beyond last character
    "set history=1000                    " Store a ton of history (default is 20)
    "set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    set backup                  " Backups are nice ...
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload



    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    "highlight clear SignColumn      " SignColumn should match background
    "highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode

    "set laststatus=2

    " Broken down into easily includeable segments
    "set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
"    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace


" Formatting {
    set wrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

    " autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    " autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    " autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    " autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    " autocmd FileType haskell,rust setlocal nospell

" }

    " Vim-LaTeX customisation
    let g:Tex_DefaultTargetFormat='pdf'
    let g:Tex_CompileRule_pdf='pdflatex -interacion=nonstopmode $*'
    let g:Tex_ViewRule_pdf='evince'
    let g:Tex_FoldedSections='section'

    " C++ configuration
    augroup project
        autocmd!
        autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
    augroup END

    " Setting leader keys
    let mapleader=','
    let localleader=','

    " Key remaps {
        map <C-n> :NERDTreeToggle<CR>
    " }
