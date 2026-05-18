RELEASE=25.12.4
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
