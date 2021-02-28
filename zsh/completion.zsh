fpath=(${ZDOTDIR} $fpath)

compinit -d ${XDG_CACHE_HOME}/.zcompdump
bashcompinit

complete -o nospace -C terraform terraform

[[ -f ${XDG_DATA_HOME}/google-cloud-sdk/completion.zsh.inc ]] && \
    source ${XDG_DATA_HOME}/google-cloud-sdk/completion.zsh.inc
