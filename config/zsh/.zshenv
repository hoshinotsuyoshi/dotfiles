### macports ###
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

### irb ###
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

### bundler ###
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundler"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundler/configuration.yml"
export BUNDLE_USER_HOME="$XDG_DATA_HOME/bundler"
export BUNDLE_USER_PLUGIN="$BUNDLE_USER_HOME/plugin"

### その他 ###
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
