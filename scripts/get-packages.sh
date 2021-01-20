#!/bin/sh

ROOT=/home/jostein/build/openwrt
NAME=$1
ssh root@$NAME opkg list-installed | sed -n ' s/\([a-z]*\) - .*/\1/p' >$ROOT/packages/$NAME
