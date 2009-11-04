HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

function history-all { history -E 1 } # 全履歴の一覧を出力する

# プロンプトのカラー表示を有効
autoload -U colors
colors

# デフォルトの補完機能を有効
autoload -U compinit
compinit

# 補完侯補をEmacsのキーバインドで動き回る
zstyle ':completion:*:default' menu select=1

# 補完の時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

setopt auto_cd
setopt hist_ignore_dups
setopt autopushd
setopt share_history
setopt pushd_ignore_dups
setopt nolistbeep
setopt list_packed

alias ls="ls -vF"
alias pwd="pwd -P"
alias rr="rm -rf"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

#alias la="ls -lhAF --color=auto"
alias la="ls -lhAF"
alias cl="make -f ~/Makefile clean"
alias ps="ps -fU`whoami` --forest"

alias -g G='| grep'
alias -g L='| less'
alias -g T='| tail'
alias v='vim'
alias g='git'

alias gd='dirs -v; echo -n "select number: "; read newdir; cd -"$newdir"'

alias terminal="gnome-terminal"

PROMPT="$ "
RPROMPT_DEFAULT="[%~]"
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

typeset -ga chpwd_functions
typeset -ga precmd_functions
typeset -ga preexec_functions

function _rprompt() {
    # git
    local -A git_branch
    git_branch=`git branch -a --no-color 2> /dev/null`
    if [ $? = "0" ]; then
        git_branch=`echo $git_branch | grep '^*' | tr -d '\* '`
        # RPROMPT="%Sgit [$git_res]%s"
        RPROMPT=' %{[32m%}('$git_branch')%{[00m%} '$RPROMPT_DEFAULT
        return
    fi
    RPROMPT=$RPROMPT_DEFAULT
}
precmd_functions+=_rprompt
