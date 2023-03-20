let g:go_fmt_command = "goimports"

setlocal listchars=tab:\ \ ,trail:·,nbsp:·
setlocal noexpandtab

compiler go

let b:ale_linters = {'go': ['gofumpt', 'goimports', 'golines']}
let b:ale_fixers = {'go': ['remove_trailing_lines', 'trim_whitespace']}
let b:ale_fix_on_save = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
