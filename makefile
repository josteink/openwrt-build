RELEASE=19.07.6

default: all

clean:
	rm -rf images builders dl

linksys: builders
	scripts/make-image $(RELEASE) linksys mvebu-cortexa9 linksys_wrt1900acs

tplink-u: builders
	scripts/make-image $(RELEASE) tplink-u ath79-generic tplink_archer-c7-v2 -wpad-basic

tplink-1: builders
	scripts/make-image $(RELEASE) tplink-1 ath79-generic tplink_archer-c7-v2 -wpad-basic

tplink-2: builders
	scripts/make-image $(RELEASE) tplink-2 ath79-generic tplink_archer-c7-v4 -wpad-basic

tplink-shed: builders
	scripts/make-image $(RELEASE) tplink-shed ath79-generic tplink_archer-c7-v2 -wpad-basic

all: builders linksys tplink-u tplink-1 tplink-2 tplink-shed

builders: builders/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64/bootstrap builders/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64/bootstrap

# ath79

builders/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O dl/openwrt-imagebuilder-$(RELEASE)-ath79-generic.Linux-x86_64.tar.xz \
	 https://downloads.openwrt.org/releases/$(RELEASE)/targets/ath79/generic/openwrt-imagebuilder-19.07.6-ath79-generic.Linux-x86_64.tar.xz

# linksus - mvebu

builders/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64/bootstrap: dl/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64.tar.xz
	mkdir -p builders
	tar x -C builders -vf $?
	touch $@

dl/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64.tar.xz:
	mkdir -p dl
	wget -O dl/openwrt-imagebuilder-$(RELEASE)-mvebu-cortexa9.Linux-x86_64.tar.xz \
	 https://downloads.openwrt.org/releases/19.07.6/targets/mvebu/cortexa9/openwrt-imagebuilder-19.07.6-mvebu-cortexa9.Linux-x86_64.tar.xz
