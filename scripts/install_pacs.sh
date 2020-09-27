#!/bin/sh
#Forked from https://github.com/qmk/qmk_firmware/blob/master/util/linux_install.sh
# Only modified for the distros that I use. To add a distro see above repo and edit

# Note: This file uses tabs to indent. Please don't mix tabs and spaces.

if grep ID /etc/os-release | grep -qE "fedora"; then
	sudo dnf install \
	  ansible
    golang \
		arm-none-eabi-binutils-cs \
		arm-none-eabi-gcc-cs \
		arm-none-eabi-newlib \
		avr-binutils \
		avr-gcc \
		avr-libc \
		binutils-avr32-linux-gnu \
		clang \
		dfu-util \
		dfu-programmer \
		diffutils \
		git \
		gcc \
		glibc-headers \
		kernel-devel \
		kernel-headers \
		libusb-devel \
		make \
		perl \
		python3 \
		unzip \
		wget \
		xclip \
		vim \
		curl \
		tree \
		shellcheck \
		jq \
		w3m \
		zip

elif grep ID /etc/os-release | grep -qE 'debian|ubuntu'; then
	DEBIAN_FRONTEND=noninteractive
	DEBCONF_NONINTERACTIVE_SEEN=true
	export DEBIAN_FRONTEND DEBCONF_NONINTERACTIVE_SEEN
	sudo apt-get update
	sudo apt-get -yq install \
		ansible
		build-essential \
    golang \
		avr-libc \
		binutils-arm-none-eabi \
		binutils-avr \
		clang-format \
		dfu-programmer \
		dfu-util \
		diffutils \
		gcc \
		gcc-arm-none-eabi \
		gcc-avr \
		net-utils \
		git \
		libnewlib-arm-none-eabi \
		libusb-dev \
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
		zip

elif grep ID /etc/os-release | grep -q 'arch\|manjaro'; then
	sudo pacman --needed -U https://archive.archlinux.org/packages/a/avr-gcc/avr-gcc-8.3.0-1-x86_64.pkg.tar.xz
	sudo pacman -S --needed \
		ansible
		arm-none-eabi-binutils \
		arm-none-eabi-gcc \
		arm-none-eabi-newlib \
		avrdude \
		avr-binutils \
		avr-libc \
		base-devel \
		clang \
		dfu-programmer \
		dfu-util \
		diffutils \
		gcc \
		git \
		libusb-compat \
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
		zip

else
	echo "Sorry, looks like you're cool and use a rare distro. I just use Arch, Redhat, and Debian variants. Want to extend, make a PR!"
fi
