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
alias k='kubectl ${KUBECTL_CONTEXT+--context=${KUBECTL_CONTEXT}} ${KUBECTL_NAMESPACE+--namespace=${KUBECTL_NAMESPACE}}'
alias kctx='kubectx'
alias kns='kubens'
alias s='ssh'
alias title='printf "\033]0;%s\a"'
alias tf='terraform'
alias v='${EDITOR}'
alias vbare='${EDITOR} -u NONE'

case "${OSTYPE}" in
    linux*)
        alias cr='google-chrome-stable'
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

function kc() {
    export KUBECTL_CONTEXT=$1
}
function kn() {
    export KUBECTL_NAMESPACE=$1
}

_kube_contexts()
{
    local curr_arg;
    curr_arg=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(kubectl config get-contexts --output='name')" -- $curr_arg ) );
}
complete -F _kube_contexts kc

_kube_namespaces()
{
    local curr_arg;
    curr_arg=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(kubectl get namespaces -o=jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}')" -- $curr_arg ) );
}
complete -F _kube_namespaces kn
