RELEASE=23.05.3
RELEASEFOLDER=releases/$(RELEASE)
RELEASEDASH=$(RELEASE)-

default: all

clean:
	rm -rf images builders dl

linksys: builders
	scripts/make-image $(RELEASEDASH)mvebu-cortexa9 linksys linksys_wrt1900acs -wireguard

tplink-u: builders
	scripts/make-image $(RELEASEDASH)ath79-generic tplink-u tplink_archer-c7-v2 -wpad-basic-mbedtls

tplink-1: builders
	scripts/make-image $(RELEASEDASH)ath79-generic tplink-1 tplink_archer-c7-v4 -wpad-basic-mbedtls

tplink-2: builders
	scripts/make-image $(RELEASEDASH)ath79-generic tplink-2 tplink_archer-c7-v2 -wpad-basic-mbedtls

tplink-shed: builders
	scripts/make-image $(RELEASEDASH)ath79-generic tplink-shed tplink_archer-c7-v2 -wpad-basic-mbedtls

buffalo: builders
	scripts/make-image $(RELEASEDASH)ath79-generic buffalo buffalo_wzr-hp-g300nh-s -wpad-basic

netgear: builders
	scripts/make-image $(RELEASEDASH)ipq40xx-generic netgear netgear_ex6150v2

zyxel: builders
	scripts/make-image $(RELEASEDASH)ramips-mt7621 zyxel zyxel_nwa50ax

all: linksys tplink-u tplink-1 tplink-2 tplink-shed buffalo netgear zyxel

builders: builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64/bootstrap

# ath79

builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/ath79/generic/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64.tar.xz

# linksys - mvebu

builders/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/mvebu/cortexa9/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64.tar.xz

# netgear ex6150v2 - ipq40xx

builders/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/ipq40xx/generic/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64.tar.xz

# zyxel NWA50AX

builders/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/ramips/mt7621/openwrt-imagebuilder-$(RELEASEDASH)ramips-mt7621.Linux-x86_64.tar.xz
