RELEASE=22.03.3
RELEASEFOLDER=releases/$(RELEASE)
RELEASEDASH=$(RELEASE)-

default: all

clean:
	rm -rf images builders dl

linksys: builders
	scripts/make-image $(RELEASEDASH)mvebu-cortexa9 linksys linksys_wrt1900acs -wireguard

tplink-u: builders
	scripts/make-image $(RELEASEDASH)ath79-generic tplink-u tplink_archer-c7-v2 -wpad-basic-wolfssl

tplink-1: builders
	scripts/make-image $(RELEASEDASH)ath79-generic tplink-1 tplink_archer-c7-v2 -wpad-basic-wolfssl

tplink-2: builders
	scripts/make-image $(RELEASEDASH)ath79-generic tplink-2 tplink_archer-c7-v4 -wpad-basic-wolfssl

tplink-shed: builders
	scripts/make-image $(RELEASEDASH)ath79-generic tplink-shed tplink_archer-c7-v2 -wpad-basic-wolfssl

buffalo: builders
	scripts/make-image $(RELEASEDASH)buffalo ath79-generic buffalo_wzr-hp-g300nh-s -wpad-basic

netgear: builders
	scripts/make-image $(RELEASEDASH)netgear ipq40xx-generic netgear_ex6150v2

all: linksys tplink-u tplink-1 tplink-2 tplink-shed buffalo netgear

builders: builders/openwrt-imagebuilder-$(RELEASEDASH)ath79-generic.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASEDASH)mvebu-cortexa9.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64

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

builders/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64: dl/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/$(RELEASEFOLDER)/targets/ipq40xx/generic/openwrt-imagebuilder-$(RELEASEDASH)ipq40xx-generic.Linux-x86_64.tar.xz
