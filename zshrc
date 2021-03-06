# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

docker-debug() {
  if [ -z "$1" ]; then
    echo "usage: docker-debug CONTAINER-ID"
    return 1
  fi

  docker run --rm -ti \
    --pid="container:$1" \
    --net="container:$1" \
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

export GOPATH=/Users/dean/Developer
export PATH=$PATH:$GOPATH/bin
export GPG_TTY=$(tty)

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
setopt autocd

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# added by travis gem
[ ! -s /Users/dean/.travis/travis.sh ] || source /Users/dean/.travis/travis.sh
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dean/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dean/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dean/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dean/google-cloud-sdk/completion.zsh.inc'; fi
