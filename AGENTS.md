# AGENTS.md

Notes for agents working in this repo. Update this file when the build
structure or conventions change.

## What this repo is

A personal build harness for OpenWrt firmware images. It does **not** contain
OpenWrt source. It downloads the official prebuilt **Image Builder** tarballs
from `downloads.openwrt.org`, extracts them under `builders/`, and runs
`make image` inside them using per-device package lists from `packages/`.
Output lands in `images/`.

Current release: `RELEASE=25.12.6` in `makefile` (tagged `v25.12.6`).

## Layout

```
makefile              release pin, per-device make targets, builder download/extract rules
scripts/make-image    wrapper: cd into an extracted builder, run `make image`
scripts/flash-image   scp newest sysupgrade image to a device, run sysupgrade
scripts/get-packages  ssh root@<host> apk info > packages/<host>
scripts/get-config    scp -r root@<host>:/etc/* configs/<host>
packages/<name>       one package per line; full installed-package list from a live device
configs/<name>        snapshot of a live device's /etc (NOT used by the build)
dl/                   downloaded image-builder tarballs          (gitignored)
builders/             extracted image builders + `bootstrap` stamp (gitignored)
images/               build output                              (gitignored)
.github/workflows/build.yml  CI: build on push/PR/tag, publish release on tags
```

`configs/` is currently untracked and not gitignored — see "Secrets" below.

## Build flow

```
make
  -> dl/openwrt-imagebuilder-$(RELEASEDASH)<target>.Linux-x86_64.tar.zst
  -> builders/openwrt-imagebuilder-$(RELEASEDASH)<target>.Linux-x86_64/  (+ `bootstrap` stamp)
  -> scripts/make-image $(RELEASEDASH)<target> <name> <profile> [extra pkg args]
       -> cd builder
       -> make image PROFILE=<profile> PACKAGES="$(cat packages/<name>) <args>" \
                   BIN_DIR=images EXTRA_IMAGE_NAME="-<name>-"
  -> images/openwrt-<ver>--<name>--<target>-<profile>-...
```

- `RELEASE` is the OpenWrt version. `RELEASEDASH=$(RELEASE)-` and
  `RELEASEFOLDER=releases/$(RELEASE)` are derived. Both `${}` and `$()`
  styles appear in the makefile; either works in GNU make.
- Builder rules extract `$?` (the tarball) and `touch` the `bootstrap` stamp.
- `make-image` does **not** clean the builder between runs (the `make clean`
  line is commented out), so state can persist across builds.
- Snapshot build (from README):
  `make RELEASE=snapshot RELEASEDASH= RELEASEFOLDER=snapshots`

### Flashing

`make flash-<name>` does **not** build. It flashes the newest existing
`images/openwrt-*--<name>--*sysupgrade*` file, so run `make` (or
`make <name>`) first; with no matching image the script fails with a hint.
The device targets are phony, so a `flash-<name>: <name>` dependency would
rebuild (and double-build after a separate `make`).

- `scripts/flash-image` picks the newest image, verifies it against
  `images/sha256sums` when an entry exists, `scp -O`s it to `/tmp` on the
  device, then runs `sysupgrade`.
- Hosts are ssh aliases from `~/.ssh/config` (`BANANAPI_HOST=bananapi`,
  `ZYXEL_EX5601_T0_HOST=zyxel`, `BUFFALO_HOST=buffalo`); each is
  `?=`-overridable with `user@host`. The aliases carry the LAN IPv4, user and
  key, so the repo encodes no addresses. SSH must be key-authorized with an
  active ssh-agent.
- Config is kept across a flash. `FLASH_ARGS=-n` wipes it; any other
  sysupgrade option can be passed the same way.
- Exit 255 from ssh is treated as success because sysupgrade reboots the box
  and drops the connection. A preflight `ssh ... test -x /sbin/sysupgrade`
  catches auth/reachability problems first.
- There is no aggregate `flash` target on purpose (flashing all devices
  sequentially reboots everything).
- Image selection is by name + mtime only, not release. If both a release and
  a snapshot buffalo image exist in `images/`, `flash-buffalo` picks whichever
  is newer. Build snapshot buffalo with
  `make RELEASE=snapshot RELEASEDASH= RELEASEFOLDER=snapshots buffalo`; note
  that plain `make`/`make all` still builds buffalo at the pinned release.

## Command cheat sheet

```sh
make                  # all devices
make bananapi         # BPI-R4 only
make zyxel-ex5601-t0  # Zyxel only (reuses the mediatek builder)
make buffalo          # Buffalo only
make builders         # just download/extract builders
make flash-bananapi   # flash newest existing bananapi image (no rebuild)
make flash-bananapi FLASH_ARGS=-n   # same, but wipe the device config
make clean            # deletes images/, builders/ AND dl/ (re-downloads ~500 MB)

scripts/get-packages <host>   # refresh packages/<host> from a live device (apk)
scripts/get-config <host>     # snapshot /etc into configs/<host> (secrets!)
```

## Devices

| Make target | OpenWrt target | PROFILE | Packages file | Flash host | Extra |
|---|---|---|---|---|---|
| `bananapi` | `mediatek/filogic` | `bananapi_bpi-r4` | `packages/bananapi` | `bananapi` | — |
| `zyxel-ex5601-t0` | `mediatek/filogic` | `zyxel_ex5601_t0-ubootmod` | `packages/zyxel-ex5601-t0` | `zyxel` | depends on `bananapi-builder` (same builder) |
| `buffalo` | `ath79/generic` | `buffalo_wzr-hp-g300nh-s` | `packages/buffalo` | `buffalo` | passes `-wpad-basic` (likely stale, see below) |

`make all` builds all three; `make builders` only creates
`bananapi-builder` and `buffalo-builder` (the Zyxel target reuses the
mediatek one).

## Conventions

- Device names are lowercase and match the `packages/<name>` filename and the
  `EXTRA_IMAGE_NAME` tag, not necessarily the OpenWrt profile.
- Adding a device means: add a builder download/extract pair in `makefile`
  (unless the target already exists), add a `<name>` target, and add
  `packages/<name>` (usually via `scripts/get-packages`).
- Bumping releases means changing `RELEASE` only. Builder tarballs are keyed
  on it, so a bump triggers fresh downloads.
- Package lists are literal `make image` package arguments. Lines beginning
  with `-` remove default packages. The base lists include packages that are
  already defaults (kernel, libc, base-files), which is harmless.
- OpenWrt 25.x uses `apk`; package names differ from the opkg era. The
  packages files and `get-packages` were updated accordingly. Older branches
  (`openwrt24.12.5`, `origin/extra-files`) use the older conventions.

## Git and CI

- Branches: `master` (active), `openwrt24.12.5` (older revert point),
  `origin/extra-files` (very old 19.07.8 branch with tplink devices and a
  `FILES=` variant of `make-image`), `origin/renovate/configure`.
- CI (`.github/workflows/build.yml`) runs on pushes to `master`, PRs against
  `master`, `v*` tags, and manual dispatch: `make builders && make`, then
  uploads `images/` as an artifact.
- On tag pushes it creates a GitHub release containing `images/sha*` and
  `images/*squashfs*` only.
- Tags used: `v25.12.0-rc1`, `v25.12.0`, `v25.12.1` … `v25.12.6`. There is an
  outlier typo tag `v.25.12.5` — prefer the `v25.12.x` form.

## Gotchas

- `make clean` deletes `dl/` as well as `images/`, forcing a re-download of
  the large builder tarballs. Prefer deleting a single builder directory plus
  its `bootstrap` stamp when testing manifest changes.
- `configs/` is not consumed by any build step. It is a manual reference
  snapshot only.
- `brand`-style `EXTRA_IMAGE_NAME` means output files contain `--<name>--`;
  the checksum/manifest files use the same prefix.
- `-wpad-basic` on the buffalo target predates the `wpad-basic-mbedtls` rename
  and probably removes nothing; it does not conflict with the explicit
  `wpad-basic-mbedtls` in `packages/buffalo`.
- `SFP-FIXES.md` (if present) is **obsolete** — the SFP/DAC mismatch described
  there was worked around by other means. Do not implement its DTB patch /
  init-script plan.
- Newer image builders reject unknown packages. When a release bump breaks a
  build, check `packages/<name>` for renamed or dropped packages (e.g. an
  uncommitted buffalo edit removes `kmod-nf-conntrack6`).

## Secrets

`configs/bananapi/` is a copied live `/etc` and contains real credentials:
WireGuard private/preshared keys (`config/network`), `shadow`, `passwd`,
`uhttpd.key`, `dropbear/*_host_key`, `adguardhome.yaml`, `msmtprc`.
It is currently **untracked but not gitignored**, so `git add .` would commit
those secrets. Do not commit `configs/` without scrubbing it or adding it to
`.gitignore`. Never print or copy those values into commits, logs, or issues.
