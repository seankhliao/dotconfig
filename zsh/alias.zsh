alias -s go='go run'
alias -s py='python'

(( $+commands[rg] )) \
    && alias grep='rg -S' \
    || alias grep='grep --color=auto'
(( $+commands[exa] )) \
    && alias l='exa -l --git --time-style iso --group-directories-first' \
    || alias l='ls -lh --color=auto';
(( $+commands[exa] )) \
    && alias ll='exa -l -a --git --time-style iso --group-directories-first' \
    || alias ll='ls -alh --color=auto';

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

alias cp='cp -v'
alias ln='ln -v'
alias mv='mv -v'
alias g='git'
alias h='htop'
alias k='kubectl'
alias rg='rg -N -S -p'
alias s='ssh'
alias v='${EDITOR}'
alias vbare='${EDITOR} -u NONE}'

case "${OSTYPE}" in
    linux*)
        alias cr='google-chrome-stable'
        alias diff='diff --color=always'
        alias goupdate='rm $XDG_DATA_HOME/go/bin/go && gotip download && ln -s $XDG_DATA_HOME/go/bin/gotip $XDG_DATA_HOME/go/bin/go'
        alias p='yay'
        alias sc='sudo systemctl'
        alias scu='systemctl --user'
    ;;
esac

# short git aliases
function {
    local gitconfig="${XDG_CONFIG_HOME}/git/config"
    [[ -f "${gitconfig}" ]] || gitconfig="${HOME}/.gitconfig"
    local start_alias=false
    while read line; do
        if "${start_alias}"; then
            [[ "${line}" =~ '\s*\[[a-z]*\]' ]] && return
            sub="${${line%%=*}// /}"
            [[ "${sub}" ]] && alias g${sub}="git ${sub}"
        else
            [[ $line =~ '\s*\[alias\]' ]] && start_alias=true
        fi
    done < "${gitconfig}"
}
