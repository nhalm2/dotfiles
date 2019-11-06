#!/usr/bin/env bash

platform=""

function _setup_platform() {
	local unameOut="$(uname -s)"

	case "${unameOut}" in
	    Linux*)     platform=Linux
		    	_linux
			;;
	    Darwin*)    platform=Mac
		    	_mac
			;;
	    CYGWIN*)    platform=Cygwin;;
	    MINGW*)     platform=MinGw;;
	    *)          platform="UNKNOWN:${unameOut}"
	esac
}

function _error_exit() {
	echo ""
	echo "Error while executing ${0##*/}."
	echo "Message: ${1}"
	echo ""

	exit 1
}

function _install_brew() {
	which -s brew
	if [[ $? != 0 ]]; then
		echo "installing brew"
		/usr/bin/ruby -e "$(curl -fssl https://raw.githubusercontent.com/homebrew/install/master/install)"
	else
		brew update
	fi
}

function _mac() {
	_install_brew

	local brew_prefix=$(brew --prefix)

	echo "Upgrading Brew"
	brew upgrade


	# Install GNU core utilities
	brew install coreutils

	# Install some other useful utilities like `sponge`.
	brew install moreutils
	# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
	brew install findutils
	# Install GNU `sed`, overwriting the built-in `sed`.
	brew install gnu-sed
	# Install a modern version of Bash.
	brew install bash
	brew install bash-completion2

	# Switch to using brew-installed bash as default shell
	if ! fgrep -q "${brew_prefix}/bin/bash" /etc/shells; then
		echo "${brew_prefix}/bin/bash" | sudo tee -a /etc/shells;
		chsh -s "${brew_prefix}/bin/bash";
	fi;


	# Install other useful binaries.
	brew install neovim
	brew install git
	brew install ack
	#brew install exiv2
	brew install git
	brew install git-lfs
	brew install gs
	brew install lua
	brew install lynx
	brew install p7zip
	brew install pigz
	brew install pv
	brew install rename
	brew install rlwrap
	brew install ssh-copy-id
	brew install tree
	brew install vbindiff
	brew install zopfli
	brew install tmux
	brew install openssh
	brew install grep

	brew cask install visual-studio-code

	# Remove outdated versions from the cellar.
	brew cleanup	
}

_setup_platform
