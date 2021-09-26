#!/bin/sh

set -e
set -u

UNDERLINE="\033[1;4m"
NO_UNDERLINE="\033[1;24m"
RED="\033[1;31m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
NO_COLOR="\033[0m"

function __check_exists {
    NAME=$1

    if command -v "$NAME" >/dev/null 2>&1
    then
        return 0
    else
        echo "${YELLOW}$NAME${NO_COLOR} not found"

        return 1
    fi
}

clear

echo "Begin setup, please wait..."

# for installing bundler
if ! __check_exists gem
then
    echo "Install ruby gems following instructions at ${UNDERLINE}${BLUE}https://rubygems.org/pages/download${NO_COLOR}${NO_UNDERLINE}"
    exit 1
fi

# for managing ruby dependencies, like cocoapods
if ! __check_exists bundle
then
    sudo gem install bundler
fi

# for brew install
if ! __check_exists brew
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# install from Brewfile
brew bundle || true

# install the correct gems locally
xcrun bundle install
# install our dependencies
bundle exec pod install

echo "Setup complete, follow remaining steps in ${CYAN}README.md${NO_COLOR}"