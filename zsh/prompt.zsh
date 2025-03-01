#!/usr/bin/env zsh

export PROMPT_EOL_MARK=''

function _preexec() {
    typeset -g prompt_timestamp=$EPOCHSECONDS
}

function _precmd() {
    local kubecontext=""
    if [[ ! -z "${KUBECONFIG}" ]]; then
        local context=$(rg --no-heading --no-line-number --only-matching --replace '$1' 'current-context: (.*)' "${KUBECONFIG}")
        local namespace=$(rg --no-heading --no-line-number --only-matching --replace '$1' --multiline 'namespace: (.*)\n\s+name: '"${context}" "${KUBECONFIG}")
        kubecontext="${context} :: ${namespace} "
    fi

    integer elapsed=$(( EPOCHSECONDS - ${prompt_timestamp:-$EPOCHSECONDS} ))
    local human="$(( elapsed / 3600 )):${(l:2::0:)$(( elapsed / 60 % 60 ))}:${(l:2::0:)$(( elapsed % 60 ))}"
    vcs_info 2>&1 >/dev/null
    local newline=$'\n%{\r%}'

    # https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html

    # %* current time
    # %~ current directory reltive to HOME
    PROMPT="$F{red}${kubecontext}%f"
    PROMPT+="%F{green}%*%f %F{blue}%~%f %F{yellow}${human}%f"
    PROMPT+="${newline}"

    PROMPT+="%F{242}${STY:+screen-}${VIRTUAL_ENV:+venv-}${vcs_info_msg_0_:+${vcs_info_msg_0_} }%f"
    # %(?.true.false) ternary on exit status
    # %n username
    # %m hostname
    PROMPT+="%(?.%F{magenta}.%F{red})${SSH_CONNECTION+%n@%m}»%f "
}

add-zsh-hook precmd  _precmd
add-zsh-hook preexec _preexec
