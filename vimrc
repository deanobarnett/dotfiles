filetype plugin indent on
syntax on
colorscheme habamax

set nobackup
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
set statusline +=%2*0x%04B\ %*          "character under cursor

let mapleader = " "

nnoremap <leader><leader> <esc>:FZF<cr>
nnoremap <leader>v :vsplit<cr>

nnoremap j gj;
nnoremap k gk
imap jj <esc>
imap jk <esc>

map <c-s> <esc>:w!<cr>
map! <c-s> <esc>:w!<cr>
map <c-q> <esc>:q!<cr>
map! <c-q> <esc>:q!<cr>

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/bundle')
Plug 'tpope/vim-fugitive' " git
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim' " search
Plug 'vimwiki/vimwiki' " wiki
Plug 'pbrisbin/vim-mkdir' " Make missing dirs
Plug 'tpope/vim-repeat' " use . more
Plug 'tpope/vim-surround' " change quotes etc
Plug 'vim-scripts/tComment' " comment
Plug 'Chiel92/vim-autoformat' " all in one format
Plug 'ggandor/leap.nvim' " faster movement
call plug#end()
