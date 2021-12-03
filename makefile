RELEASE=21.02.1

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

all: linksys tplink-u tplink-1 tplink-2 tplink-shed buffalo

builders: builders/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64/bootstrap

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
