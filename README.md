
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

## upgrading

Edit `makefile` and update the `RELEASE` variable to match latest
OpenWRT release.

Optionally you can provide a release-name inline as a make varibale
to create a single build for a specific release.

````sh
make RELEASE=19.07.1
````
