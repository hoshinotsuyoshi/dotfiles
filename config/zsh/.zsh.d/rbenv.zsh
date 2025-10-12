export RBENV_ROOT=$XDG_DATA_HOME/rbenv
[[ -d $RBENV_ROOT ]] && \
  export PATH=~/.local/share/go/src/github.com/rbenv/rbenv/bin:${PATH} && \
    eval "$(rbenv init -)"
