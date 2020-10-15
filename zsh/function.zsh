function vsk(){
    nvim $(sk)
}

function gsall() {
    local bold=$(tput bold)
    local normal=$(tput sgr0)

    for dir in ./*; do
        if [[ -d ${dir} ]] && [[ -d ${dir}/.git ]]; then
            if ! git -C ${dir} diff-index --quiet HEAD || ! git -C ${dir} diff-index --quiet origin/HEAD; then
                echo "\n${bold}$dir${normal}"
                git -C ${dir} log --oneline origin/HEAD..HEAD
                git -C ${dir} status -s
            fi
        fi
    done
}

function md() {
    [[ -z ${1// } ]] && echo "no directory name gived" && return 1
    mkdir -p "$1" && cd "$1"
}

function t() {
    command t -i "$@"
    source /tmp/t_aliases 2>/dev/null
}
