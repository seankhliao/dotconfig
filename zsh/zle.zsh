zle -N self-insert url-quote-magic
zle -N _sudo_cmdline
zle -N history-substring-search-up
zle -N history-substring-search-down

function _sudo_cmdline() {
    [[ -z ${BUFFER} ]] && zle up-history
    [[ ${BUFFER} == sudo\ * ]] && BUFFER=${BUFFER#sudo } || BUFFER="sudo ${BUFFER}"
}

bindkey -e
# ^[ == escape
bindkey '^[^[' _sudo_cmdline # esc esc
bindkey '^[w' vi-forward-word # esc w
bindkey '^[[1;5C' vi-forward-word # ctrl-right
bindkey '^[e' vi-forward-word-end # esc e
bindkey '^[b' vi-backward-word # esc b
bindkey '^[[A' history-substring-search-up # up
bindkey '\eOA' history-substring-search-up
bindkey '^[[B' history-substring-search-down # down
bindkey '\eOB' history-substring-search-down
bindkey '^[[H' beginning-of-line # home
bindkey '^[[F' end-of-line # end

zstyle ':completion:*:make:*:targets' call-command true # exec make to get targets
zstyle ':completion:*:make:*' tag-order targets # ignore make variables
zstyle ':completion:*' group-name ''
zstyle ':completion:*' gain-privileges true
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache true
zstyle ':completion:*' matcher-list '' \
    '+m:{a-z}={A-Z}' '+m:{A-Z}={a-z}' \
    'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
    'r:|?=** m:{a-z\-}={A-Z\_}'

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
