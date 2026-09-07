# dffo-bluebuild-os &nbsp; [![bluebuild build badge](https://github.com/dffo/dffo-bluebuild-os/actions/workflows/build.yml/badge.svg)](https://github.com/dffo/dffo-bluebuild-os/actions/workflows/build.yml)

Personal Fedora Sway Atomic 44 image, migrated from `custom-ublue-setup`.
Published as `ghcr.io/dffo/dffo-bluebuild-os:latest` by the existing BlueBuild workflow.

## Customization

- `recipes/recipe.yml`: Fedora packages, the dim-screen COPR, enabled services,
  file installation, image signing, and final bootc lint.
- `files/system/etc/`: journald/syslog persistence, console font, libvirt polkit
  permissions, libinput scrolling, DDC udev permissions, SDDM scaling, and SysRq.
- `files/scripts/install-codecs.sh`: RPM Fusion repositories and the original
  multimedia/FFmpeg transactions, retained as a script to preserve their ordering
  and package-manager options.

The Fedora Sway base supplies the desktop. The recipe retains the source image's
package selection, removes dunst, and enables rsyslog, Samba (smb/nmb), the Podman
socket, and libvirtd. The dim-screen COPR is disabled again after installation.
Template-only packages and Flatpak installation were removed.

v4l2loopback is not installed: its installation was commented out in the source
repository. Enabling it needs a separate kernel-matched build or a supported base;
simply adding BlueBuild's akmods module is not a supported path on stock Fedora.
The old optional disk/ISO build tooling is not part of this image recipe; see the
BlueBuild ISO instructions below if installation media is needed.

## Build and signing

The existing GitHub Actions workflow builds daily and on pushes/pull requests.
Keep this repository's `cosign.pub` and matching `SIGNING_SECRET` GitHub Actions
secret. Migration does not generate or replace signing keys. The presence and
validity of the GitHub secret must be confirmed by a signed build.

This is a new image address, so an installation tracking the old repository will
need an explicit switch after the new image has built successfully. No host switch
is performed by editing this repository. The instructions below are the template's
rpm-ostree installation path; use the appropriate bootc path if your host is managed
by bootc instead.

## Installation

> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/dffo/dffo-bluebuild-os:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/dffo/dffo-bluebuild-os:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/how-to/generate-iso/#_top). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/dffo/dffo-bluebuild-os
```
