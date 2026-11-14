RELEASE=25.12.6
RELEASEFOLDER=releases/$(RELEASE)
RELEASEDASH=$(RELEASE)-

default: all

clean:
	rm -rf images builders dl

bananapi: bananapi-builder
	scripts/make-image $(RELEASEDASH)mediatek-filogic bananapi bananapi_bpi-r4

bananapi-builder: builders/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64/bootstrap

buffalo: buffalo-builder
	scripts/make-image $(RELEASEDASH)ath79-generic buffalo buffalo_wzr-hp-g300nh-s -wpad-basic

buffalo-builder: builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap

zyxel-ex5601-t0: bananapi-builder
	scripts/make-image $(RELEASEDASH)mediatek-filogic zyxel-ex5601-t0 zyxel_ex5601-t0-ubootmod

all: bananapi zyxel-ex5601-t0 buffalo

builders: bananapi-builder buffalo-builder

# flashing
#
# The flash targets do not build anything: they flash the newest sysupgrade
# image already present in images/. Run `make` (or `make <name>`) first.
# Hosts are ssh aliases from ~/.ssh/config (which map to each box's LAN IPv4
# and set user/key), so ssh must be pre-authorized with an active ssh-agent.
# Config is kept across the flash; wipe it with
# `make flash-bananapi FLASH_ARGS=-n`. Any other sysupgrade option can be
# passed the same way. Override a host with e.g.
# `make flash-bananapi BANANAPI_HOST=root@192.168.1.1`.

BANANAPI_HOST ?= bananapi
ZYXEL_EX5601_T0_HOST ?= zyxel
BUFFALO_HOST ?= buffalo
FLASH_ARGS ?=

.PHONY: flash-bananapi flash-zyxel-ex5601-t0 flash-buffalo

flash-bananapi:
	scripts/flash-image bananapi $(BANANAPI_HOST) $(FLASH_ARGS)

flash-zyxel-ex5601-t0:
	scripts/flash-image zyxel-ex5601-t0 $(ZYXEL_EX5601_T0_HOST) $(FLASH_ARGS)

flash-buffalo:
	scripts/flash-image buffalo $(BUFFALO_HOST) $(FLASH_ARGS)

# ath79

builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.zst
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.zst:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/ath79/generic/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.zst

# bananapi r4

builders/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64.tar.zst
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64.tar.zst:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/${RELEASEFOLDER}/targets/mediatek/filogic/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64.tar.zst
