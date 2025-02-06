RELEASE=24.10.0
RELEASEFOLDER=releases/$(RELEASE)
RELEASEDASH=$(RELEASE)-

default: all

clean:
	rm -rf images builders dl

linksys: builders
	scripts/make-image $(RELEASEDASH)mvebu-cortexa9 linksys linksys_wrt1900acs -wireguard

buffalo: builders
	scripts/make-image $(RELEASEDASH)ath79-generic buffalo buffalo_wzr-hp-g300nh-s -wpad-basic

netgear: builders
	scripts/make-image $(RELEASEDASH)ipq40xx-generic netgear netgear_ex6150v2

zyxel: builders
	scripts/make-image $(RELEASEDASH)ramips-mt7621 zyxel zyxel_nwa50ax -wpad-basic-mbedtls

all: linksys buffalo netgear zyxel

builders: builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64/bootstrap

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
