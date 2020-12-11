compinit -d ${XDG_CACHE_HOME}/.zcompdump
bashcompinit

complete -o nospace -C kustomize kustomize
complete -o nospace -C terraform terraform

fpath=(${ZDOTDIR} $fpath)

[[ -f ${XDG_DATA_HOME}/google-cloud-sdk/completion.zsh.inc ]] && \
    source ${XDG_DATA_HOME}/google-cloud-sdk/completion.zsh.inc
