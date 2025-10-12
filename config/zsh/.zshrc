export EDITOR="vim"

export DISABLE_AUTO_TITLE=true

alias ll='ls -alF'

#左のほうにユーザ名とカレントディレクトリを表示するPROMPT
# PROMPT='[%F{blue}%d%f]$ '
PROMPT='[%F{blue}%15>..>%c%<<%f]$ '

# http://futurismo.biz/archives/1363
## Screenでのコマンド共有用
## シェルを横断して.zshhistoryに記録
setopt inc_append_history

# 自動補完を有効にする
# コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
# 例： `cd path/to/<Tab>`, `ls -<Tab>`
autoload -U compinit; compinit -u

# cd した先のディレクトリをディレクトリスタックに追加する
# ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# `cd +<Tab>` でディレクトリの履歴が表示され、そこに移動できる
setopt auto_pushd
# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# http://qiita.com/PSP_T/items/c1a1567b2b76051f50c4 
# コマンドがスペースで始まる場合、コマンド履歴に追加しない
# 例： <Space>echo hello と入力
setopt hist_ignore_space

# 履歴ファイルの保存先
export HISTFILE="$XDG_STATE_HOME/zsh_history"

# メモリに保存される履歴の件数
export HISTSIZE=300000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=3000000

# 開始と終了を記録
setopt EXTENDED_HISTORY

setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# 余分な空白は詰めて記録
setopt hist_reduce_blanks

# 古いコマンドと同じものは無視
setopt hist_save_no_dups

# historyコマンドは履歴に登録しない
setopt hist_no_store

# 補完時にヒストリを自動的に展開
setopt hist_expand

# emacs風。明示しないと^Pが使えない時ある
bindkey -e

# http://qiita.com/ayakix/items/44b990335169ca9e3d39
# プロンプトのカラー表示を有効
autoload -U colors
# colors
# Color
setopt prompt_subst
# ls時のカラー表記
export LSCOLORS=gxfxcxdxbxegedabagacad
# ファイルリスト補完時、ディレクトリをシアン
zstyle ':completion:*' list-colors 'di=36;49'

# http://qiita.com/yuyuchu3333/items/e9af05670c95e2cc5b4d
function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter

# ghqで使うのでgoの設定は.zsh.d以下の読み込み前に行いたい
export GOPATH="$XDG_DATA_HOME/go"
export PATH=$PATH:$GOPATH/bin
# https://original-game.com/how-to-manage-zshrc-separately/ 
ZSH_D_DIR="${ZDOTDIR}/.zsh.d"

# .zsh.dがディレクトリで、読み取り、実行、が可能なとき
if [ -d $ZSH_D_DIR ] && [ -r $ZSH_D_DIR ] && [ -x $ZSH_D_DIR ]; then
    # zshディレクトリより下にある、.zshファイルの分、繰り返す
    for file in ${ZSH_D_DIR}/**/*.zsh; do
        # 読み取り可能ならば実行する
        [ -r $file ] && source $file
    done
fi

# キーリピートの速さ: 一度やれば良い
# https://qiita.com/seteen/items/5698089808612f6b87e0
# https://qiita.com/hajime-f/items/5f72b5109fd78f2da5d4
#
# 例1
# defaults write -g KeyRepeat -int 1
# defaults write -g InitialKeyRepeat -int 12
#
# 例2
# defaults write NSGlobalDomain KeyRepeat -int 2
# defaults write NSGlobalDomain InitialKeyRepeat -int 20

# 確認例
# $ defaults read -g InitialKeyRepeat
# 20
# $ defaults read -g KeyRepeat
# 2

# キーの押しっぱなし設定
# https://twitter.com/yamakawa_tw/status/1385128327954911237
# 例
# defaults write -g ApplePressAndHoldEnabled -bool false
# 確認例
# defaults read -g ApplePressAndHoldEnabled
# 0

# [api]$ port select --summary
# Name        Selected  Options
# ====        ========  =======
# postgresql  none      postgresql14 none
# python      none      python311 none
# python3     none      python311 none
# [api]$ sudo port select --set postgresql postgresql14
# Password:
# Selecting 'postgresql14' for 'postgresql' succeeded. 'postgresql14' is now active.
# [api]$ port select --summary
# Name        Selected      Options
# ====        ========      =======
# postgresql  postgresql14  postgresql14 none
# python      none          python311 none
# python3     none          python311 none
