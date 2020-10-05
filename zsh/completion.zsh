compinit -d ${XDG_CACHE_HOME:-$HOME}/.zcompdump
bashcompinit

complete -o nospace -C /usr/bin/kustomize kustomize
complete -o nospace -C /usr/bin/terraform terraform

[[ -d /opt/google-cloud-sdk/bin ]] && export PATH="${PATH}:/opt/google-cloud-sdk/bin"
[[ -d $HOME/google-cloud-sdk/bin ]] && export PATH="${PATH}:$HOME/google-cloud-sdk/bin"
[[ -f /opt/google-cloud-sdk/completion.zsh.inc ]] && source /opt/google-cloud-sdk/completion.zsh.inc
[[ -f $HOME/google-cloud-sdk/completion.zsh.inc ]] && source $HOME/google-cloud-sdk/completion.zsh.inc
[[ -f $HOME/.zsh_kubetcl ]] && source $HOME/.zsh_kubetcl