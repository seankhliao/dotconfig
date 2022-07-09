function gsall() {
    local bold=$(tput bold)
    local normal=$(tput sgr0)

    for dir in ./*; do
        if [[ -d ${dir} ]] && [[ -d ${dir}/.git ]]; then
            local printed=false
            local default=$(git -C ${dir} remote show origin | awk '/HEAD branch/ {print $NF}')
            if [[ "${default}" != "" ]]; then
                printf "\n${bold}$dir${normal}\n"
                if ! git -C ${dir} diff-index --quiet --exit-code origin/${default} ; then
                    git -C ${dir} log --oneline origin/${default}..HEAD
                    git -C ${dir} status -s
                    printed=true
                fi
            else
                printf "\n${bold}$dir${normal}\n"
                git -C ${dir} branch --show-current
                git -C ${dir} status -s
            fi
        fi
    done
}

function glall() {
    local bold=$(tput bold)
    local normal=$(tput sgr0)

    for dir in ./*; do
        if [[ -d ${dir} ]] && [[ -d ${dir}/.git ]]; then
            printf "\n${bold}$dir${normal}\n"
            git -C ${dir} checkout $(git -C ${dir} rev-parse --abbrev-ref origin/HEAD | sed 's|^.*||')
            git -C ${dir} fetch --tags --prune --prune-tags --force --jobs=10
            git -C ${dir} merge --ff-only --autostash
        fi
    done
}

function md() {
    [[ -z ${1// } ]] && echo "no directory name given" && return 1
    mkdir -p "$1" && cd "$1"
}

function t() {
    command t -i "$@"
    source /tmp/t_aliases 2>/dev/null
}

function colortest () {
    for i in {0..255} ; do
        printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
        if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
            printf "\n";
        fi
    done
}
