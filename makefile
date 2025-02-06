RELEASE=24.10.0
RELEASEFOLDER=releases/$(RELEASE)
RELEASEDASH=$(RELEASE)-

default: all

clean:
	rm -rf images builders dl

linksys: linksys-builder
	scripts/make-image $(RELEASEDASH)mvebu-cortexa9 linksys linksys_wrt1900acs -wireguard

linksys-builder: builders/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64/bootstrap

bananapi: bananapi-builder
	scripts/make-image $(RELEASEDASH)mediatek-filogic bananapi bananapi_bpi-r4

bananapi-builder: builders/openwrt-imagebuilder-${RELEASEDASH}mediatek-filogic.Linux-x86_64/bootstrap

zyxel: zyxel-builder
	scripts/make-image $(RELEASEDASH)ramips-mt7621 zyxel zyxel_nwa50ax -wpad-basic-mbedtls

zyxel-builder: builders/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64/bootstrap

netgear: netgear-builder
	scripts/make-image $(RELEASEDASH)ipq40xx-generic netgear netgear_ex6150v2

netgear-builder: builders/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64/bootstrap

buffalo: buffalo-builder
	scripts/make-image $(RELEASEDASH)ath79-generic buffalo buffalo_wzr-hp-g300nh-s -wpad-basic

buffalo-builder: builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap

all: linksys zyxel netgear buffalo

builders: linksys-builder bananapi-builder zyxel-builder netgear-builder buffalo-builder 

# ath79

builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.zst
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.zst:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/ath79/generic/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.zst

# linksys - mvebu

builders/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64.tar.zst
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64.tar.zst:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/mvebu/cortexa9/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64.tar.zst

# netgear ex6150v2 - ipq40xx

builders/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64.tar.zst
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64.tar.zst:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/ipq40xx/generic/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64.tar.zst

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
