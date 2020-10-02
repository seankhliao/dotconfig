function testrepo() {
    set -xo pipefail
    local vers=$(( $(cat ${XDG_CONFIG_HOME}/testrepo-version)+1))
    local repo=testrepo-${vers}
    mkdir ${HOME}/${repo}
    cd ${HOME}/${repo}
    echo ${vers} > ${XDG_CONFIG_HOME}/testrepo-version
    git init
    git commit --allow-empty -m "root-commit"
    git remote add origin s:${repo}
    go mod init go.seankhliao.com/${repo}
}

function mr() {
    local repo=${1// }
    [[ -z ${repo} ]] && echo "no repo name given" && return 1
    mkdir -p ${repo}
    cd ${repo}
    git init
    git commit --allow-empty -m "root-commit"
    git remote add origin s:${repo}

    cat << EOF > .gitignore
${repo}
EOF

    cat << EOF > README.md
# ${repo}

A repo for ${repo}

[![License](https://img.shields.io/github/license/seankhliao/${repo}.svg?style=flat-square)](LICENSE)
EOF

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

function mrgo() {
    local repo=${1// }
    [[ -z ${repo} ]] && echo "no repo name given" && return 1
    mr ${repo}
    go mod init go.seankhliao.com/${repo}

    cat << EOF > README.md
# ${repo}

A repo for ${repo}
[![pkg.go.dev](http://img.shields.io/badge/godoc-reference-blue.svg?style=flat-square)](https://pkg.go.dev/go.seankhliao.com/${repo})
![Version](https://img.shields.io/github/v/tag/seankhliao/${repo}?sort=semver&style=flat-square)
[![License](https://img.shields.io/github/license/seankhliao/${repo}.svg?style=flat-square)](LICENSE)

\`\`\`go
import "go.seankhliao.com/${repo}"
\`\`\`

EOF

    cat << EOF > .dockerignore
.dockerignore
.git/
.github/
.gitignore

cloudbuild.yaml
Dockerfile
k8s/
LICENSE
Makefile
README.md
EOF

    cat << EOF > Dockerfile
FROM golang:alpine AS build

WORKDIR /workspace
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags='-s -w' -o /bin/${repo}


FROM scratch

COPY --from=build /bin/${repo} /bin/

ENTRYPOINT [ "/bin/${repo}" ]
EOF

    cat << EOF > cloudbuild.yaml
substitutions:
  _IMG: stream
  _REG: us.gcr.io
tags:
  - \$\SHORT_SHA
  - \$\COMMIT_SHA
steps:
  - id: build-push
    name: gcr.io/kaniko-project/executor:latest
    args:
      - -c=.
      - -f=Dockerfile
      - -d=\$_REG/\$PROJECT_ID/\$_IMG:latest
      - -d=\$_REG/\$PROJECT_ID/\$_IMG:\$SHORT_SHA
      - --reproducible
      - --single-snapshot
  - id: deploy
    name: gcr.io/cloud-builders/kubectl:latest
    entrypoint: /bin/sh
    args:
      - -c
      - |
        set -ex; \
        sed -i 's/# newTag: IMAGE_TAG/newTag: "\$SHORT_SHA"/' k8s/kustomization.yaml && \
        /builder/kubectl.bash apply -k k8s
    env:
      - CLOUDSDK_COMPUTE_ZONE=us-central1-c
      - CLOUDSDK_CONTAINER_CLUSTER=cluster23
EOF
}
