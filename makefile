RELEASE=19.07.6

clean:
	rm -rf images builders dl

linksys:
	scripts/make-image linksys mvebu-cortexa9 linksys_wrt1900acs

tplink-u:
	scripts/make-image tplink-u ath79-generic tplink_archer-c7-v2 -wpad-basic

tplink-1:
	scripts/make-image tplink-1 ath79-generic tplink_archer-c7-v2 -wpad-basic

tplink-2:
	scripts/make-image tplink-2 ath79-generic tplink_archer-c7-v4 -wpad-basic

tplink-shed:
	scripts/make-image tplink-shed ath79-generic tplink_archer-c7-v2 -wpad-basic

all: builders linksys tplink-u tplink-1 tplink-2 tplink-shed

default: all

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
