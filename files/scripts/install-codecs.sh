#!/usr/bin/env bash
set -euo pipefail

# Preserve the source image's RPM Fusion setup and codec transactions.
dnf5 install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf5 install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf5 group install -y multimedia
dnf5 swap -y ffmpeg-free ffmpeg --allowerasing
dnf5 update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf5 install -y mesa-va-drivers-freeworld
