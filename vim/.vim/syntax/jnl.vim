syntax match JournalAll /.*/                 " captures the entire buffer
syntax match JournalDone /^×.*/              " lines containing 'done' items:  ×
syntax match JournalTodo /^·.*/              " lines containing 'todo' items:  ·
syntax match JournalEvent /^o.*/             " lines containing 'event' items: o
syntax match JournalNote /^- .*/             " lines containing 'note' items:  -
syntax match JournalMoved /^>.*/             " lines containing 'moved' items: >
syntax match JournalHeader /^\<\u\+\>.*/     " lines starting with caps

highlight JournalAll    ctermfg=8
highlight JournalHeader ctermfg=8
highlight JournalDone   ctermfg=8
highlight JournalTodo   ctermfg=10
highlight JournalEvent  ctermfg=6               " cyan
highlight JournalMoved  ctermfg=9               " pink
highlight JournalNote   ctermfg=3               " yellow
highlight VertSplit     ctermfg=0  ctermbg=0    " hide vert splits
