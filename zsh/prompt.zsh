#!/usr/bin/env zsh

export PROMPT_EOL_MARK=''

function _preexec() {
    typeset -g prompt_timestamp=$EPOCHSECONDS
}

function _precmd() {
    integer elapsed=$(( EPOCHSECONDS - ${prompt_timestamp:-$EPOCHSECONDS} ))
    local human="$(( elapsed / 3600 )):${(l:2::0:)$(( elapsed / 60 % 60 ))}:${(l:2::0:)$(( elapsed % 60 ))}"
    vcs_info 2>&1 >/dev/null
    local newline=$'\n%{\r%}'

    PROMPT="%F{green}%*%f %F{blue}%~%f %F{yellow}${human}%f"
    PROMPT+="${KUBECTL_CONTEXT:+ ${KUBECTL_CONTEXT/gke*_/} / }${KUBECTL_NAMESPACE:+${KUBECTL_NAMESPACE}}"
    PROMPT+="${newline}"
    PROMPT+="%F{242}${STY:+screen-}${VIRTUAL_ENV:+venv-}${vcs_info_msg_0_:+${vcs_info_msg_0_} }%f"
    PROMPT+="%(?.%F{magenta}.%F{red})${SSH_CONNECTION+%n@%m}»%f "
}

add-zsh-hook precmd  _precmd
add-zsh-hook preexec _preexec
