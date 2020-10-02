function gcamp_patch(){
    _check_tidy && \
    git commit -a -m "${*}" && \
    git push && \
    git push origin "$(_semver_next patch)"
}
function gcamp_minor(){
    _check_tidy && \
    git commit -a -m "${*}" && \
    git push && \
    git push origin "$(_semver_next minor)"
}

function _check_tidy() {
    local currentdir=$(pwd)
    cd $(git rev-parse --show-toplevel)
    [[ ! -f go.mod ]] || go mod tidy
    [[ ! -d vendor ]] || go mod vendor
    cd "${currentdir}"
}


function _colortest () {
    for i in {0..255} ; do
        printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
        if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
            printf "\n";
        fi
    done
}

function _semver_next() {
    if [[ "$1" != "major" ]] && [[ "$1" != "minor" ]] && [[ "$1" != "patch" ]]; then
        echo "please specify one of: major|minor|patch"
        return 1
    fi
    IFS=$'\n' local tags=($(git tag -l))
    if [ ${#tags[@]} -eq 0 ]; then
        git tag v0.0.1
        return
    fi
    local max=$tags[1]
    for t in $tags; do
        max=$(_semver_gt $max $t)
    done
    local v=$(_semver_bump $max $1)
    git tag $v
    echo $v
}

function _semver_gt() {
    local r="^v(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(\\-([0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*))?(\\+([0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*))?$"
    if [[ "$1" =~ $r ]]; then
        local v1=(${match[1]} ${match[2]} ${match[3]})
        if [[ "$2" =~ $r ]]; then
            local v2=(${match[1]} ${match[2]} ${match[3]})

            for i in 1 2 3; do
                local vv1=${v1[$i]}
                local vv2=${v2[$i]}
                if (( vv1 > vv2 )); then
                    echo "v${v1[1]}.${v1[2]}.${v1[3]}"
                    return 0
                elif (( vv1 < vv2 )); then
                    echo "v${v2[1]}.${v2[2]}.${v2[3]}"
                    return 0
                fi
            done
            echo "v${v1[1]}.${v1[2]}.${v1[3]}"
            return 0
        fi
    fi
    return 1
}

function _semver_bump() {
    local r="^v(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(\\-([0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*))?(\\+([0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*))?$"
    if [[ "$1" =~ $r ]]; then
        integer maj=${match[1]}
        integer min=${match[2]}
        integer pat=${match[3]}

        case "$2" in
            major)
                echo "v$(( maj + 1 )).0.0"
            ;;
            minor)
                echo "v${maj}.$(( min +1 )).0"
            ;;
            patch)
                echo "v${maj}.${min}.$(( pat + 1 ))"
            ;;
            *)
            echo "v${maj}.${min}.${pat}"
        esac
        return 0
    fi
    return 1
}
