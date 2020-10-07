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
RUN apk add --update --no-cache ca-certificates
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags='-s -w' -o /bin/${repo}


FROM scratch

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /bin/${repo} /bin/

ENTRYPOINT [ "/bin/${repo}" ]
EOF

    cat << EOF > cloudbuild.yaml
substitutions:
  _IMG: ${repo}
  _REG: reg.seankhliao.com

tags:
  - \$SHORT_SHA
  - \$COMMIT_SHA
steps:
  - id: test
    name: golang:alpine
    entrypoint: go
    args:
      - test
      - ./...
    env:
      - CGO_ENABLED=0

  - id: login
    waitFor:
      - "-"
    name: gcr.io/cloud-builders/gcloud:latest
    entrypoint: bash
    args:
      - -c
      - >
        gcloud secrets versions access latest
        --secret=docker-registry-creds
        --format='get(payload.data)'
        | tr '_-' '/+'
        | base64 -d > /kaniko/.docker/config.json
        &&
        gcloud secrets versions access latest
        --secret=cluster-kubectl-creds
        --format='get(payload.data)'
        | tr '_-' '/+'
        | base64 -d > /kube/config
        &&
        gcloud secrets versions access latest
        --secret=github-personal-repo-token
        --format='get(payload.data)'
        | tr '_-' '/+'
        | base64 -d > /github/token
    volumes:
      - name: registry-creds
        path: /kaniko/.docker
      - name: cluster-creds
        path: /kube
      - name: github-creds
        path: /github

  - id: build-push
    waitFor:
      - "login"
    name: gcr.io/kaniko-project/executor:latest
    args:
      - -c=.
      - -f=Dockerfile
      - -d=\$_REG/\$_IMG:latest
      - -d=\$_REG/\$_IMG:\$SHORT_SHA
      - --reproducible
      - --single-snapshot
      - --cache=true
      - --use-new-run
    volumes:
      - name: registry-creds
        path: /kaniko/.docker

  - id: deploy
    name: gcr.io/cloud-builders/kubectl:latest
    entrypoint: /bin/sh
    args:
      - -c
      - >
        set -ex;
        cd k8s &&
        sed -i 's/# newTag: IMAGE_TAG/newTag: "\$SHORT_SHA"/' kustomization.yaml &&
        kubectl.1.18 kustomize | tee /deployed/\$_IMG.yaml | kubectl.1.18 apply -f -
    env:
      - KUBECONFIG=/kube/config
    volumes:
      - name: cluster-creds
        path: /kube
      - name: deployed
        path: /deployed

  - id: save-deployment
    name: gcr.io/cloud-builders/gcloud:latest
    entrypoint: bash
    args:
      - -c
      - >
        set -ex;
        export GITHUB_TOKEN=\$\$(cat /github/token) &&
        git clone https://x-access-token:\$\$GITHUB_TOKEN@github.com/seankhliao/kluster &&
        cd kluster/apps &&
        cp /deployed/\$_IMG.yaml \$_IMG.k8s.yaml &&
        git add \$_IMG.k8s.yaml &&
        git config user.email $(gcloud auth list --filter=status:ACTIVE --format='value(account)') &&
        git commit -m "update \$_IMG deployment to \$SHORT_SHA" &&
        git push
    volumes:
      - name: github-creds
        path: /github
      - name: deployed
        path: /deployed
EOF
}
