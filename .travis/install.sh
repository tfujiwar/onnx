#!/bin/bash
set -e
set -x

scripts_dir=$(dirname $(readlink -e "${BASH_SOURCE[0]}"))
source "$scripts_dir/common"

LOCAL_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOT_DIR=$(dirname "$LOCAL_DIR")
cd "$ROOT_DIR"

APT_INSTALL_CMD='sudo apt-get install -y --no-install-recommends'

if [ "$TRAVIS_OS_NAME" = 'linux' ]; then
    ####################
    # apt dependencies #
    ####################
    sudo apt-get update
    $APT_INSTALL_CMD \
        autoconf \
        automake \
        build-essential \
        protobuf-compiler \
        python \
        python-dev \
        python-pip \
        python-wheel \

elif [ "$TRAVIS_OS_NAME" = 'osx' ]; then
    #####################
    # brew dependencies #
    #####################
    brew update
    brew install python
    pip uninstall -y numpy  # use brew version (opencv dependency)
    brew tap homebrew/science  # for OpenCV
    brew install \
        protobuf

else
    echo "OS \"$TRAVIS_OS_NAME\" is unknown"
    exit 1
fi

####################
# pip dependencies #
####################
sudo pip install \
    future \
    numpy \
    protobuf \
    pytest

if [[ $USE_NINJA == true ]]; then
    pip install ninja
fi
