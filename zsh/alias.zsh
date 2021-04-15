alias -s go='go run'
alias -s py='python'

(( $+commands[exa] )) \
    && alias l='exa -l --git --time-style iso --group-directories-first' \
    || alias l='ls -lh';
(( $+commands[exa] )) \
    && alias ll='exa -l -a --git --time-style iso --group-directories-first' \
    || alias ll='ls -alh';
(( $+commands[exa] )) \
    && alias ls='exa --group-directories-first' \
    || alias ll='ls -h';

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'
alias ............='cd ../../../../../../../../../../..'

alias cp='cp -v'
alias ln='ln -v'
alias mv='mv -v'
alias g='git'
alias h='htop'
alias k='kubectl'
alias kctx='kubectx'
alias kns='kubens'
alias s='ssh'
alias title='printf "\033]0;%s\a"'
alias tf='terraform'
alias v='${EDITOR}'
alias vbare='${EDITOR} -u NONE'

case "${OSTYPE}" in
    linux*)
        alias cr='${BROWSER}'
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
