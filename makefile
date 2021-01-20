clean:
	rm -rf images

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

all: linksys tplink-u tplink-1 tplink-2 tplink-shed

default: all
