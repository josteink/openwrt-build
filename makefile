RELEASE=21.02.2

default: all

clean:
	rm -rf images builders dl

linksys: builders
	scripts/make-image $(RELEASE) linksys mvebu-cortexa9 linksys_wrt1900acs -wireguard

tplink-u: builders
	scripts/make-image $(RELEASE) tplink-u ath79-generic tplink_archer-c7-v2 -wpad-basic-wolfssl

tplink-1: builders
	scripts/make-image $(RELEASE) tplink-1 ath79-generic tplink_archer-c7-v2 -wpad-basic-wolfssl

tplink-2: builders
	scripts/make-image $(RELEASE) tplink-2 ath79-generic tplink_archer-c7-v4 -wpad-basic-wolfssl

tplink-shed: builders
	scripts/make-image $(RELEASE) tplink-shed ath79-generic tplink_archer-c7-v2 -wpad-basic-wolfssl

buffalo: builders
	scripts/make-image $(RELEASE) buffalo ath79-generic buffalo_wzr-hp-g300nh-s -wpad-basic

netgear: builders
	scripts/make-image $(RELEASE) netgear ipq40xx-generic netgear_ex6150v2

all: linksys tplink-u tplink-1 tplink-2 tplink-shed buffalo netgear

builders: builders/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASE)-ipq40xx-generic.Linux-x86_64

# ath79

builders/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/releases/$(RELEASE)/targets/ath79/generic/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64.tar.xz

# linksys - mvebu

builders/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/releases/$(RELEASE)/targets/mvebu/cortexa9/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64.tar.xz

# netgear ex6150v2 - ipq40xx

builders/openwrt-imagebuilder-$(RELEASE)-ipq40xx-generic.Linux-x86_64: dl/openwrt-imagebuilder-$(RELEASE)-ipq40xx-generic.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASE)-ipq40xx-generic.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O $@ https://downloads.openwrt.org/releases/$(RELEASE)/targets/ipq40xx/generic/openwrt-imagebuilder-$(RELEASE)-ipq40xx-generic.Linux-x86_64.tar.xz
