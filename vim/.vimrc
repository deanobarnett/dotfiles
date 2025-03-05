execute pathogen#infect()
filetype plugin indent on
syntax on
colorscheme habamax

set nobackup
set noswapfile
set nocompatible
set backspace=indent,eol,start
set encoding=utf-8
set background=dark
set ignorecase
set smartcase
set wrap
set textwidth=80
set lbr
set tw=80
set relativenumber
set number
set showmode
set laststatus=2
set cursorline
set ttyfast

" auto reload changed files, helps with running formatters
set autoread
set updatetime=250
au CursorHold,CursorHoldI * checktime

set wildignore+=*.o,*.obj,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.pyc
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz,*.pdf

set statusline=
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number

let mapleader = " "

map <leader>v :vsplit<cr>
map <leader><space> :FZF .<cr>
map <leader>y "*y
map <leader>p "*p

nnoremap j gj
nnoremap k gk
imap jj <esc>
imap jk <esc>

map <c-s> <esc>:w!<cr>
map! <c-s> <esc>:w!<cr>
map <c-q> <esc>:q!<cr>
map! <c-q> <esc>:q!<cr>

au BufRead,BufNewFile *.jnl set filetype=jnl
au BufRead,BufNewFile *.klog,*.klg set filetype=klog
au BufRead,BufNewFile *.md,*.markdown set filetype=md
