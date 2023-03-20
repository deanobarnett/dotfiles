set encoding=utf-8

" Leader
let mapleader = ","

" Minimal setip
set ai nocp digraph hid ru sc vb wmnu noeb noet nosol
set bs=2 fo=cqrt ls=2 shm=at tw=72 ww=<,>,h,l
set comments=b:#,:%,n:>
set list listchars=tab:»·,trail:·

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set autowrite     " Automatically :write before running commands
set modelines=0   " Disable modelines as a security precaution
set nomodeline
set clipboard=unnamed
set nofoldenable

" Match case only when supplied
set ignorecase
set smartcase

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Status line colors
hi User1 ctermbg=darkgrey ctermfg=green guibg=darkgrey guifg=green
hi User2 ctermbg=lightyellow ctermfg=black guibg=lightyellow guifg=black
hi User3 ctermbg=darkgrey ctermfg=darkred guibg=darkgrey guifg=darkred
hi User9 ctermbg=darkgrey ctermfg=white guibg=darkgrey guifg=white

" Left-justified
set laststatus=2  " Always display the status line
set statusline=
set statusline+=%1*\ \ %{b:gitbranch}%9* "Git branch
set statusline+=%{expand('%:~:.')}\  " Relative file path
set statusline+=%3*%r%m%9* " Read-only, modified

" Right-justified
set statusline+=%=
set statusline+=%1*%l/%L:%c%9*\  " Line/column
set statusline+=%2*\ %{StatuslineMode()}\ %9* " Mode

function! StatuslineGitBranch()
  let b:gitbranch=""
  if &modifiable
    try
      let l:dir=expand('%:p:h')
      let l:gitrevparse = system("git -C ".l:dir." rev-parse --abbrev-ref HEAD")
      if !v:shell_error
        let b:gitbranch="(".substitute(l:gitrevparse, '\n', '', 'g').") "
      endif
    catch
    endtry
  endif
endfunction

augroup GetGitBranch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

function! StatuslineMode()
  let l:mode=mode()
  return l:mode
endfunction
" End status line

syntax on
set background=dark
" colorscheme onedark

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
  au BufRead,BufNewFile *.py set expandtab
  au BufRead,BufNewFile *.c set expandtab
  au BufRead,BufNewFile *.h set expandtab
  au BufRead,BufNewFile Makefile* set noexpandtab

augroup END

" ALE linting events
augroup ale
  autocmd!

  if g:has_async
    autocmd VimEnter *
          \ set updatetime=1000 |
          \ let g:ale_lint_on_text_changed = 0
    autocmd CursorHold * call ale#Queue(0)
    autocmd CursorHoldI * call ale#Queue(0)
    autocmd InsertEnter * call ale#Queue(0)
    autocmd InsertLeave * call ale#Queue(0)
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
augroup END

let g:ale_fix_on_save = 1
let g:ale_set_highlights = 1
let b:ale_warn_about_trailing_whitespace = 0

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
set autoindent

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-n>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
" inoremap <S-Tab> <C-n>

inoremap <silent><expr> <C-space> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"


" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Make it obvious where 80 characters is
set textwidth=80
" set colorcolumn=+1 " highlight column after 'textwidth'
" hi ColorColumn ctermbg=darkgrey guibg=darkgrey

" Numbers
set number
set numberwidth=5
set wildmode=list:longest,list:full

" Toggle relative numbers on focus
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>

let test#strategy = 'dispatch'
" let g:test#neovim#start_normal = 1
" let g:test#basic#start_normal = 1

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Set tags for vim-fugitive
set tags^=.git/tags

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Move to wrapped lines
nnoremap j gj
nnoremap k gk

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>

" Save and quit
imap <c-s> <esc>:w!<cr>
vmap <c-s> <esc>:w!<cr>
nmap <c-s> <esc>:w!<cr>
nnoremap <c-s> <esc>:w!<cr>
inoremap <c-s> <esc>:w!<cr>
nnoremap <c-x> <esc>:q!<cr>
nnoremap <c-q> <esc>:q!<cr>

nnoremap <leader>e <esc>:e %:h<cr>
" nnoremap <leader>v <esc>:Vex %:p<cr>
nnoremap <leader>v <esc>:FocusSplitNicely<cr>

" Ruby
map <leader>b orequire 'pry'; binding.pry<esc>
map <leader>sp :AV<cr>
map <leader>te Irequire 'rails_helper'<cr><cr>RSpec.describe Object do<cr><esc>:w<cr>
nnoremap <Leader><cr> :RuboCop -A<cr>


" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
" set diffopt+=vertical

" Local config

" copy paste
map <leader>y "*y
map <Leader>p :set paste<CR><esc>"*]p:set nopaste<cr>

map <leader>da :r !date<CR>

" movement
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Golang
let g:go_fmt_command = "goimports"

if has('nvim')
  lua require("focus").setup()
  lua require('onedark').load()
  lua require('nvim-treesitter.configs').setup{ensure_installed = {"lua", "vim", "go", "python", "ruby", "rust", "typescript", "javascript", "bash"},auto_install = true, highlight = { enable = true}}
endif

" Pomodoro
map <leader>po :Dispatch pomo<CR>

" Docker shell
map <leader>sh :Start make shell.test<CR>

set signcolumn=yes

nmap <leader>rn <Plug>(coc-rename)

imap <silent><script><expr> <C-space> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
let g:copilot_filetypes = {
      \ '*': v:true,
      \ }

if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
