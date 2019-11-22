#!/usr/bin/env zsh
#
function _preexec() {
    typeset -g prompt_timestamp=$EPOCHSECONDS
}

function _precmd() {
    # https://github.com/sindresorhus/pretty-time-zsh
    integer elapsed=$(( EPOCHSECONDS - ${prompt_timestamp:-$EPOCHSECONDS} ))
    local days=$(( elapsed / 60 / 60 / 24 ))
    local hours=$(( elapsed / 60 / 60 % 24 ))
    local minutes=$(( elapsed / 60 % 60 ))
    local seconds=$(( elapsed % 60 ))
    local human
    (( days > 0 )) && human+="${days}d "
    (( hours > 0 )) && human+="${hours}h "
    (( minutes > 0 )) && human+="${minutes}m "
    human+="${seconds}s"

    local git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local newline=$'\n%{\r%}'

    # time path exectime
    PROMPT="${newline}%F{green}%*%f %F{blue}%~%f %F{yellow}${human}%f${newline}%F{242}"
    [[ -n "${STY}" ]] && PROMPT+="${STY%.*} "
    [[ -n "${VIRTUAL_ENV}" ]] && PROMPT+="${VIRTUAL_ENV:t} "
    [[ -n "${git_branch}" ]] && PROMPT+="${git_branch} "
    PROMPT+="%f%(?.%F{magenta}.%F{red})"
    [[ -n "${SSH_CONNECTION}" ]] && PROMPT+="%n@%m"
    PROMPT+="» %f"
}
