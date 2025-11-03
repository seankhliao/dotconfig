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
alias k='kubectl'
alias kctx='kswitch context'
alias kns='kswitch namespace'

alias rr='cd $(git rev-parse --show-toplevel)'
alias sc='sudo systemctl'
alias scu='systemctl --user'
alias title='printf "\033[1m%s\n==========\033[0m\n"'

alias v='${EDITOR}'
alias vbare='${EDITOR} -u NONE'
alias vf='fzf --bind "enter:become(nvim {})"'

if (( $+commands[tailscale] )); then
    alias tsup='sudo systemctl start tailscaled'
    alias tsdown='sudo systemctl stop tailscaled'
    alias tsie='tailscale set --exit-node ie-dub-wg-101.mullvad.ts.net'
    alias tsjp='tailscale set --exit-node jp-tyo-wg-001.mullvad.ts.net'
    alias tsuk='tailscale set --exit-node gb-lon-wg-001.mullvad.ts.net'
fi

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
