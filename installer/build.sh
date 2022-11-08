#!/usr/bin/env bash

set -x

BUILD_VERSION="${PUB_VERSION:-0.0.0}"

function build() {
    goos=$1
    goarch=$2
    CGO_ENABLED=0 GOOS="${goos}" GOARCH="${goarch}" go build -ldflags="-X 'main.Version=${BUILD_VERSION}'" -a -installsuffix cgo -o bin/dot-file-installer-"${goos}-${goarch}-${BUILD_VERSION}"
}

build linux amd64
build linux 386
build linux arm
build darwin amd64
build darwin 386
build darwin arm
build darwin arm64
build windows 386
build windows amd64
