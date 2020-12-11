compinit -d ${XDG_CACHE_HOME}/.zcompdump
bashcompinit

complete -o nospace -C kustomize kustomize
complete -o nospace -C terraform terraform

[[ -d ${XDG_DATA_HOME}/google-cloud-sdk/bin ]] && \
    export PATH="${PATH}:${XDG_DATA_HOME}/google-cloud-sdk/bin"
[[ -f ${XDG_DATA_HOME}/google-cloud-sdk/completion.zsh.inc ]] && \
    source ${XDG_DATA_HOME}/google-cloud-sdk/completion.zsh.inc
[[ -f ${ZDOTDIR}/_kubectl ]] && source ${ZDOTDIR}/_kubectl
