(( $+commands[eza] )) \
    && alias l='eza -l --git --time-style iso --group-directories-first' \
    || alias l='ls -lh';
(( $+commands[eza] )) \
    && alias ll='eza -l -a --git --time-style iso --group-directories-first' \
    || alias ll='ls -alh';
(( $+commands[eza] )) \
    && alias ls='eza --group-directories-first' \
    || alias ls='ls -h';
(( $+commands[paru] )) \
    && alias p='paru' \
    || alias p='sudo pacman';
(( $+commands[tofu] )) \
    && alias tf='tofu' \
    || alias tf='terraform'

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

alias cdr='cd $(realpath .)'
alias cp='cp -v'
alias ln='ln -v'
alias mv='mv -v'
alias g='git'
alias h='htop'
alias icat='kitty +kitten icat'
source "${ZDOTDIR}/_switch"
alias k='kubectl'
# alias kctx='switch --kubeconfig-path ${XDG_CONFIG_HOME}/kube/config --state-directory ${XDG_CACHE_HOME}/switch'
# alias kns='switch namespace --kubeconfig-path ${XDG_CONFIG_HOME}/kube/config --state-directory ${XDG_CACHE_HOME}/switch'
alias kctx='kswitch context'
alias kns='kswitch namespace'
alias rr='cd $(git rev-parse --show-toplevel)'
alias s='ssh'
alias sc='sudo systemctl'
alias scu='systemctl --user'
alias title='printf "\033[1m%s\n==========\033[0m\n"'
alias tf='terraform'
alias v='${EDITOR}'
alias vbare='${EDITOR} -u NONE'
alias vf='fzf --bind "enter:become(nvim {})"'
alias wifi-portal='curl -sI http://neverssl.com | rg -o "(?:Location: (.*)|href=[\u{22}\u{27}](.*)[\u{22}\u{27}])" --replace "\$1" -N -L'

case "${OSTYPE}" in
    linux*)
        alias cr='${BROWSER}'
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
