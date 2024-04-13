# TODO: simplify shell setup

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

plugins=(
  git
  dotenv
  macos
  tmux
  vi-mode
)

export TERM="xterm-256color"
export RUSTC_WRAPPER="sccache"
ZSH_TMUX_AUTOSTART=true

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*~*.zwc(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/(pre|post)/*|*.zwc)
          :
          ;;
        *)
          . $config
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*~*.zwc(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

source ~/Developer/src/github.com/marlonrichert/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source <(kubectl completion zsh)

export GPG_TTY=$(tty)

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
setopt autocd

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -n "$(pgrep gpg-agent)" ]; then
  export GPG_AGENT_INFO
else
  eval $(gpg-agent --daemon -q >/dev/null)
fi

export PATH=/Users/deanbarnett/.local/bin:$PATH

# tfswitch uses this for terraform
export PATH=$PATH:/Users/deanbarnett/bin

# switch most functionality to rust tooling
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Add colors to Terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Option startup programs
# Memento mori calendar
mori || true
