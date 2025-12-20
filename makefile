RELEASE=25.12.0-rc1
RELEASEFOLDER=releases/$(RELEASE)
RELEASEDASH=$(RELEASE)-

default: all

clean:
	rm -rf images builders dl

bananapi: bananapi-builder
	scripts/make-image $(RELEASEDASH)mediatek-filogic bananapi bananapi_bpi-r4

bananapi-builder: builders/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64/bootstrap

zyxel: zyxel-builder
	scripts/make-image $(RELEASEDASH)ramips-mt7621 zyxel zyxel_nwa50ax -wpad-basic-mbedtls

zyxel-builder: builders/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64/bootstrap

buffalo: buffalo-builder
	scripts/make-image $(RELEASEDASH)ath79-generic buffalo buffalo_wzr-hp-g300nh-s -wpad-basic

buffalo-builder: builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap

all: zyxel bananapi

builders: bananapi-builder zyxel-builder buffalo-builder

# ath79

builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.zst
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.zst:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/ath79/generic/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.zst

# zyxel NWA50AX

builders/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64.tar.zst
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64.tar.zst:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/ramips/mt7621/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64.tar.zst

# bananapi r4

builders/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64.tar.zst
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64.tar.zst:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/${RELEASEFOLDER}/targets/mediatek/filogic/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64.tar.zst
