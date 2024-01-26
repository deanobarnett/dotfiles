set encoding=utf-8

" Leader
let mapleader = " "

" Minimal setup
set ai nocp digraph hid ru sc vb wmnu noeb noet nosol
set bs=2 fo=cqrt ls=2 shm=at tw=72 ww=<,>,h,l
set comments=b:#,:%,n:>
set list listchars=tab:»·,trail:·

set signcolumn=yes
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
" hi User1 ctermbg=darkgrey ctermfg=green guibg=darkgrey guifg=green
" hi User2 ctermbg=lightyellow ctermfg=black guibg=lightyellow guifg=black
" hi User3 ctermbg=darkgrey ctermfg=darkred guibg=darkgrey guifg=darkred
" hi User9 ctermbg=darkgrey ctermfg=white guibg=darkgrey guifg=white

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
" augroup ale
"   autocmd!
"
"   if g:has_async
"     autocmd VimEnter *
"           \ set updatetime=1000 |
"           \ let g:ale_lint_on_text_changed = 0
"     autocmd CursorHold * call ale#Queue(0)
"     autocmd CursorHoldI * call ale#Queue(0)
"     autocmd InsertEnter * call ale#Queue(0)
"     autocmd InsertLeave * call ale#Queue(0)
"   endif
" augroup END
"
" let g:ale_fix_on_save = 1
" let g:ale_set_highlights = 1
" let b:ale_warn_about_trailing_whitespace = 0

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
" inoremap <silent><expr> <C-space> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"

if has('nvim')
  lua require("focus").setup({ autoresize = { enable = false } })
  lua require('onedark').load()
  lua require('nvim-treesitter.configs').setup{ensure_installed = {"lua", "vim", "go", "python", "ruby", "rust", "typescript", "javascript", "bash", "html"},auto_install = true, highlight = { enable = true}}
  lua require('gitsigns').setup()
  lua require("neo-tree").setup({window = {width = 20}})
  lua require("todo-comments").setup()
  lua require('leap').add_default_mappings()
  lua require("obsidian").setup({})
  lua require('refactoring').setup()

  " LSP
  lua require("mason").setup()
  lua require("mason-lspconfig").setup({ensure_installed = {"bashls", "cssls", "eslint", "gopls", "html", "jsonls", "rust_analyzer", "vimls", "yamlls", "sqlls", "ruby_ls"}})
  lua require("mason-lspconfig").setup_handlers {}
  lua require("lspconfig").pylsp.setup { settings = { pylsp = { plugins = { ruff = { enabled = true, lineLength=120, extendSelect = { "I","E","W","F","C" }, extendIgnore = { "E501" } }, pylint = { enabled = false } } } } }

  " Autoformat
  lua require("conform").setup({ format_on_save = { timeout_ms = 500, lsp_fallback = true, }, formatters_by_ft = { lua = { "stylua" }, python = { "ruff_fix" }, javascript =  { "prettier" }, }, })
  lua require("conform").formatters.ruff_fix = { prepend_args = { "--select", "E,W,F,C,I" }, }

  lua vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*", callback = function(args) require("conform").format({ bufnr = args.buf }) end, })
endif

" LSP keybindings
nmap <silent> gd <Plug>(coc-definition)
nnoremap <leader>gd :lua require('telescope.builtin').lsp_definitions()<CR>
nnoremap <leader>gr :lua require('telescope.builtin').lsp_references()<CR>
nnoremap <leader>dg :lua require('telescope.builtin').diagnostics()<CR>
nnoremap <leader>K :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>

nnoremap <leader>gb :Gitsigns blame_line<CR>

set list listchars=tab:»·,trail:·,nbsp:· " display whitespace
set nojoinspaces " use one space, not two, after punctuation.

" --vimgrep -> Needed to parse the rg response properly for ack.vim
" --type-not sql -> Avoid huge sql file dumps as it slows down the search
" --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'

" Auto close the Quickfix list after pressing '<enter>' on a list item
" let g:ack_autoclose = 1

" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1

" Don't jump to first match
cnoreabbrev Ack Ack!
nnoremap \ :Ack!<Space>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

" Make it obvious where 80 characters is
set textwidth=80
" set colorcolumn=+1 " highlight column after 'textwidth'
" hi ColorColumn ctermbg=darkgrey guibg=darkgrey
" lua require('onedark').setup { style = 'darker' }
" lua require('onedark').load()
" colorscheme onedark


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
let test#strategy = 'dispatch'

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Set tags for vim-fugitive
set tags^=.git/tags

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Move to wrapped lines
nnoremap j gj
nnoremap k gk

" Move between linting errors
" nnoremap ]r :ALENextWrap<CR>
" nnoremap [r :ALEPreviousWrap<CR>

" Map Ctrl + p to open fuzzy find
nnoremap <c-p> <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fr <cmd>Telescope resume<cr>

nnoremap <leader>rr :lua require('refactoring').select_refactor()<CR>
vnoremap <leader>rr :lua require('refactoring').select_refactor()<CR>

" Save and quit
imap <c-s> <esc>:w!<cr>
vmap <c-s> <esc>:w!<cr>
nmap <c-s> <esc>:w!<cr>
nnoremap <c-s> <esc>:w!<cr>
inoremap <c-s> <esc>:w!<cr>
nnoremap <c-x> <esc>:q!<cr>
nnoremap <c-q> <esc>:q!<cr>

" Escape
imap jj <esc>
imap jk <esc>

nnoremap <leader>e <esc>:Neotree filesystem toggle reveal_force_cwd<cr>
nnoremap <leader>v <esc>:FocusSplitNicely<cr>

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
" set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Local config

" copy paste
map <leader>y "*y
map <Leader>p :set paste<CR><esc>"*]p:set nopaste<cr>

map <leader>da :r !date<CR>

let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-tsserver', 'coc-go', 'coc-html', 'coc-css', 'coc-yaml', 'coc-python', 'coc-rls', 'coc-prettier', 'coc-eslint', 'coc-tslint', 'coc-markdownlint']
" " movement

" Golang
let g:go_fmt_command = "goimports"

" Docker shell
map <leader>sh :Start make shell.test<CR>

" Copilot
imap <silent><script><expr> <C-space> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
let g:copilot_filetypes = { '*': v:true, }

" vimwiki
map <leader>wd :VimwikiMakeDiaryNote<CR>
au BufNewFile ~/vimwiki/diary/*.wiki :silent 0r !~/.vim/bin/generate-vimwiki-diary-template '%'

let g:neo_tree_remove_legacy_commands = 1

" Colemak DH remaps
" movement keys
" noremap m h
" noremap n j
" noremap e k
" noremap i l

" next search, same place as 'n' was
" noremap h n
" noremap H N
" jump to end of work
" noremap j e
" insert mode, where 'i' used to be
" noremap l i
" noremao k m
"=================

if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
