function fzf-select-history() {
    BUFFER=$(history -n 1 | \
        fzf --tac --reverse --scheme=history --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history
