
# automatic openwrt image builder

My collection of scripts and config to automatically build
firmware-images for my OpenWRT-devices.

## dependencies

These scripts depends on the OpenWRT image-builder tool, which has the
following explicit dependencies:

````sh
sudo apt install build-essential libncurses5-dev libncursesw5-dev \
zlib1g-dev gawk git gettext libssl-dev xsltproc wget unzip python
````

## building images

To bootstrap and build the images use:

````sh
make
````

## flashing

Flash a device over ssh (this does not build; run `make` first):

````sh
make
make flash-bananapi
make flash-zyxel-ex5601-t0
make flash-buffalo
````

The device is addressed by an ssh alias from `~/.ssh/config` (`bananapi`,
`zyxel`, `buffalo`; override with `BANANAPI_HOST=`, etc.); ssh must be
pre-authorized with keys and an active ssh-agent. The script picks the newest
sysupgrade image, verifies its checksum when available, copies it to the
device and runs `sysupgrade`. Device config is kept; wipe it with:

````sh
make flash-bananapi FLASH_ARGS=-n
````

Flash picks the newest image for the device name, regardless of release. To
keep the buffalo dev box on snapshot, build it explicitly (plain `make` still
builds it at the pinned release):

````sh
make RELEASE=snapshot RELEASEDASH= RELEASEFOLDER=snapshots buffalo
make flash-buffalo
````

## upgrading

Edit `makefile` and update the `RELEASE` variable to match latest
OpenWRT release.

Optionally you can provide a release-name inline as a make varibale
to create a single build for a specific release.

````sh
make RELEASE=19.07.1
````

To make a snapshot-build, a more involved command-line is required:

````sh
make RELEASE=snapshot RELEASEDASH= RELEASEFOLDER=snapshots
````

