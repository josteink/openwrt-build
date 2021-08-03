#!/bin/sh
opkg update
PKGS=`opkg list-upgradable | awk '{print $1}'`

if [[ "$PKGS" == "" ]]
then 
  echo All packages up to date!
else # else branch
  echo Following packages can be updated: $PKGS

  # upgrade manually with FORCE, because it causes errors otherwise
  opkg upgrade --force-overwrite openwrt-keyring

  # upgrade everything else as is
  opkg upgrade $PKGS
fi


