#!/usr/bin/env zsh

export PROMPT_EOL_MARK=''

function _preexec() {
    typeset -g prompt_timestamp=$EPOCHSECONDS
}

function _precmd() {
    integer elapsed=$(( EPOCHSECONDS - ${prompt_timestamp:-$EPOCHSECONDS} ))
    local human="$(( elapsed / 3600 )):${(l:2::0:)$(( elapsed / 60 % 60 ))}:${(l:2::0:)$(( elapsed % 60 ))}"
    vcs_info
    local newline=$'\n%{\r%}'

    PROMPT="${newline}%F{green}%*%f %F{blue}%~%f %F{yellow}${human}%f${newline}"
    PROMPT+="%F{242}${STY:+${STY} }${VIRTUAL_ENV:+${VIRTUAL_ENV} }${vcs_info_msg_0_:+${vcs_info_msg_0_} }%f"
    PROMPT+="%(?.%F{magenta}.%F{red})${SSH_CONNECTION+%n@%m}»%f "
}

add-zsh-hook precmd  _precmd
add-zsh-hook preexec _preexec
