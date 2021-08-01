#!/bin/sh
set -ex
#Forked from https://github.com/qmk/qmk_firmware/blob/master/util/linux_install.sh
# Only modified for the distros that I use. To add a distro see above repo and edit

# Note: This file uses tabs to indent. Please don't mix tabs and spaces.

if grep ID /etc/os-release | grep -qE "fedora|rhel|centos|silverblue"; then
  if grep ID /etc/os-release |grep -qE "fedora"; then
    echo "Using fedora/silverblue"
  else
    echo "Using RHEL/CENTOS need epel packages"
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  fi
	sudo dnf install \
	ansible \
	golang \
  tldr \
	git \
	gcc \
	make \
	perl \
	python3 \
	unzip \
	wget \
	xclip \
    yarn \
	vim \
  vim-X11 \
	curl \
	tree \
	ShellCheck \
	jq \
	w3m \
	tmux \
	zip \
  zsh

elif  grep ID /etc/os-release | grep -qE 'debian|ubuntu|raspbian'; then
	DEBIAN_FRONTEND=noninteractive
	DEBCONF_NONINTERACTIVE_SEEN=true
	export DEBIAN_FRONTEND DEBCONF_NONINTERACTIVE_SEEN
	sudo apt-get update
	sudo apt-get -yq install \
	ansible \
  golang \
    yarn \
	gcc \
	git \
	python3 \
  tldr \
	python3-pip \
	unzip \
	wget \
  zsh \
	xclip \
	vim \
	shellcheck \
	curl \
	tree \
	jq \
	w3m \
	tmux \
	zip \
  zsh \
  moreutils \
  neovim

	

elif grep ID /etc/os-release | grep -q 'arch\|manjaro'; then
	sudo pacman --needed -U https://archive.archlinux.org/packages/a/avr-gcc/avr-gcc-8.3.0-1-x86_64.pkg.tar.xz
	sudo pacman -S ansible --noconfirm
	sudo pacman -S base-devel --noconfirm
	sudo pacman -S clang --noconfirm
	sudo pacman -S gcc --noconfirm
	sudo pacman -S git --noconfirm
	sudo pacman -S python --noconfirm
	sudo pacman -S python-pip --noconfirm
	sudo pacman -S unzip --noconfirm
	sudo pacman -S wget --noconfirm
	sudo pacman -S xclip --noconfirm
	sudo pacman -S vim --noconfirm
	sudo pacman -S curl --noconfirm
	sudo pacman -S tree --noconfirm
	sudo pacman -S shellcheck --noconfirm
	sudo pacman -S jq --noconfirm
	sudo pacman -S w3m --noconfirm
	sudo pacman -S zsh --noconfirm
	sudo pacman -S tmux --noconfirm
	sudo pacman -S zip  --noconfirm
	sudo pacman -S github-cli --noconfirm
	sudo pacman -S nmap --noconfirm
	sudo pacman -S go --noconfirm
	sudo pacman -S moreutils--noconfirm
  sudo pacman -S neovim
else
	echo "Sorry, looks like you're cool and use a rare distro. I just use Arch, Redhat, and Debian variants. Want to extend, make a PR!"
fi
