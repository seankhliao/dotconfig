
function mr() {
    local repo=${1// }
    [[ -z ${repo} ]] && echo "no repo name given" && return 1
    mkdir -p ${repo}
    cd ${repo}
    git init
    git commit --allow-empty -m "root-commit"
    git remote add origin s:${repo}

    cat << EOF > LICENSE
MIT License

Copyright (c) $(date +%Y) Sean Liao

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
}

function testrepo() {
    local vers=$(( $(cat ${XDG_CONFIG_HOME}/testrepo-version)+1))
    echo ${vers} > ${XDG_CONFIG_HOME}/testrepo-version
    mkdir -p ${HOME}/tmp
    cd ${HOME}/tmp
    mr testrepo-${vers}
    go mod init go.seankhliao.com/testrepo-${vers}
}

function mrgo() {
    local repo=${1// }
    [[ -z ${repo} ]] && echo "no repo name given" && return 1
    mr ${repo}
    go mod init go.seankhliao.com/${repo}

    cat << EOF >> README.md
[![Go Reference](https://pkg.go.dev/badge/go.seankhliao.com/${repo}.svg)](https://pkg.go.dev/go.seankhliao.com/${repo})
[![License](https://img.shields.io/github/license/seankhliao/${repo}.svg?style=flat-square)](LICENSE)
EOF
}
