compinit -d ${XDG_CACHE_HOME:-$HOME}/.zcompdump
bashcompinit

complete -o nospace -C /usr/bin/kustomize kustomize
complete -o nospace -C /usr/bin/terraform terraform

[[ -d /opt/google-cloud-sdk/bin ]] && export PATH="${PATH}:/opt/google-cloud-sdk/bin"
[[ -d ${XDG_DATA_HOME}/google-cloud-sdk/bin ]] && \
    export "${PATH}:${XDG_DATA_HOME}/google-cloud-sdk/bin"
[[ -f /opt/google-cloud-sdk/completion.zsh.inc ]] && source /opt/google-cloud-sdk/completion.zsh.inc
[[ -f ${XDG_DATA_HOME}/google-cloud-sdk/completion.zsh.inc ]] && \
    source ${XDG_DATA_HOME}/google-cloud-sdk/completion.zsh.inc
[[ -f ${ZDOTDIR}/_kubectl ]] && source ${ZDOTDIR}/_kubectl
