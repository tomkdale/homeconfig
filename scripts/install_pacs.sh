#!/bin/sh
set -ex
#Forked from https://github.com/qmk/qmk_firmware/blob/master/util/linux_install.sh
# Only modified for the distros that I use. To add a distro see above repo and edit

# Note: This file uses tabs to indent. Please don't mix tabs and spaces.

if grep ID /etc/os-release | grep -qE "fedora|rhel|centos|silverblue"; then
	sudo dnf install \
	  ansible \
	    golang \
		git \
		gcc \
		make \
		perl \
		python3 \
		unzip \
		wget \
		xclip \
		vim \
		curl \
		tree \
		ShellCheck \
		jq \
		w3m \
		tmux \
		zip \

	sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh

elif grep ID /etc/os-release | grep -qE 'debian|ubuntu|raspbian'; then
	DEBIAN_FRONTEND=noninteractive
	DEBCONF_NONINTERACTIVE_SEEN=true
	export DEBIAN_FRONTEND DEBCONF_NONINTERACTIVE_SEEN
	sudo apt-get update
	sudo apt-get -yq install \
		ansible \
		build-essential \
    		golang \
		gcc \
		net-utils \
		git \
		python3 \
		python3-pip \
		unzip \
		wget \
		xclip \
		vim \
		shellcheck \
		curl \
		tree \
		jq \
		w3m \
		tmux \
		zip \
	

elif grep ID /etc/os-release | grep -q 'arch\|manjaro'; then
	sudo pacman --needed -U https://archive.archlinux.org/packages/a/avr-gcc/avr-gcc-8.3.0-1-x86_64.pkg.tar.xz
	sudo pacman -S --needed \
		ansible \
		base-devel \
		clang \
		gcc \
		git \
		python \
		python-pip \
		unzip \
		wget \
		xclip \
		vim \
		curl \
		tree \
		shellcheck \
		jq \
		w3m \
		tmux \
		zip \
else
	echo "Sorry, looks like you're cool and use a rare distro. I just use Arch, Redhat, and Debian variants. Want to extend, make a PR!"
fi
