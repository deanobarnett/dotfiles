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

docker-debug() {
  if [ -z "$1" ]; then
    echo "usage: docker-debug CONTAINER-ID"
    return 1
  fi

  echo "Starting debug sidecar for container $1"

  [ ! -d "/tmp/debug-$1" ] && mkdir "/tmp/debug-$1"
  echo "Mounting /scratch to /tmp/debug-$1"

  docker run --rm -ti \
    --name="debug-${1:0:6}" \
    --workdir="/scratch" \
    --volume="/tmp/debug-$1:/scratch" \
    --pid="container:$1" \
    --network="container:$1" \
    --cap-add sys_admin \
    --cap-add sys_ptrace \
    hmarr/debug-tools
}

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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

autoload -U +X bashcompinit && bashcompinit

# # NVM
# echo "loading nvm..."
# export NVM_DIR="$HOME/.nvm"
#   [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
#   [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"

# move this to asdf
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Add colors to Terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# bun completions
[ -s "/Users/deanbarnett/.bun/_bun" ] && source "/Users/deanbarnett/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
