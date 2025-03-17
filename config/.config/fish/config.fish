# disable greeting
set fish_greeting ""

# vi mode
fish_vi_key_bindings

# Add colors to Terminal
set -x CLICOLOR 1
set -x LSCOLORS ExFxBxDxCxegedabagacad

set -x EDITOR nvim
set -x GPG_TTY (tty)
set -x TERM xterm-256color

set -x HOMEBREW_NO_AUTO_UPDATE 1

# Set up paths
set -x GOBIN ~/go/bin
set -x PATH ~/bin ~/.local/bin $GOBIN /opt/homebrew/bin /opt/homebrew/opt/sqlite/bin /opt/homebrew/opt/curl/bin /opt/homebrew/opt/ruby/bin /opt/homebrew/lib/ruby/gems/3.3.0/bin $PATH

source ~/.cargo/env.fish
~/.local/bin/mise activate fish | source
fzf --fish | source
starship init fish | source
zoxide init fish | source

# GPG Agent handling
if pgrep -q gpg-agent
    set -x GPG_AGENT_INFO
else
    gpg-agent --daemon -q >/dev/null
end

# Unix abbreviations
abbr -a ag rg
abbr -a cdate date +"%Y-%m-%d w%V %a"
abbr -a ls 'eza --icons'
abbr -a l 'ls -al'
abbr -a ln 'ln -v'
abbr -a mkdir 'mkdir -p'
abbr -a v nvim
abbr -a cd z
abbr -a c z
abbr -a ci zi
abbr -a t tmux
abbr -a ... 'z ../..'
abbr -a we 'watchexec --timings'

abbr -a todo 'vim ~/wiki/personal/todo/(date +"%Y-%m").jnl'
abbr -a diary 'vim ~/wiki/personal/diary.md'
abbr -a notes 'zk edit'
abbr -a work 'ZK_NOTEBOOK_DIR=~/wiki/work zk edit'

# Docker abbreviations
abbr -a dc docker-compose
abbr -a dstats 'docker stats --all --format "table {{.ID}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"'
abbr -a dtop 'docker run -it --rm --pid host busybox top'

# Git abbreviations
abbr -a lg gitui
abbr -a gl 'git log --decorate --oneline --graph -10'
abbr -a gaa 'git add --all'
abbr -a gco 'git checkout'
abbr -a gd 'git diff'
abbr -a gdc 'git diff --cached'
abbr -a gcm 'git commit -vS'
abbr -a gp 'git push'
abbr -a gpf 'git push -f'
abbr -a pull-master 'git pull --rebase origin master'
abbr -a gplm 'git pull --rebase origin main'
abbr -a grb 'git branch --sort=-committerdate | head -n 20'

# Kubernetes abbreviations
abbr -a k kubectl
abbr -a kc 'kubectl config view --minify | grep name'
abbr -a kdp 'kubectl describe pod'
abbr -a ke 'kubectl explain'
abbr -a kg 'kubectl get pods --show-labels'
abbr -a ks 'kubectl get namespaces'
abbr -a kga 'kubectl get pod --all-namespaces'
abbr -a kgaa 'kubectl get all --show-labels'

# Ruby / Rails abbreviations
abbr -a b bundle
abbr -a rb-lint-staged 'git diff --cached --stat --name-only | xargs rubocop -A'
abbr -a migrate 'rake db:migrate db:rollback && rake db:migrate'

# Python abbreviation
abbr -a py-lock-fix 'git checkout --theirs poetry.lock && poetry lock --no-update && git add poetry.lock'

# Pretty print the path
abbr -a path 'echo $PATH | tr -s ":" "\n"'

# Miscellaneous abbreviations
abbr -a weather 'curl v2.wttr.in/Armagh'

# Startup programs for interactive shell
status -i; and mori; or true
