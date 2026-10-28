#!/bin/sh

set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ver=0.3.1
url="https://deb.debian.org/debian/pool/main/c/cage/cage_${ver}.orig.tar.xz"
work="${XDG_CACHE_HOME:-$HOME/.cache}/cage-build"
src="$work/cage-$ver"

mkdir -p "$work"
[ -f "$work/cage_$ver.orig.tar.xz" ] || curl -sfL -o "$work/cage_$ver.orig.tar.xz" "$url"

rm -rf "$src"
tar xJf "$work/cage_$ver.orig.tar.xz" -C "$work"
patch -d "$src" -p1 <"$here/force-1920x1080.patch"

meson setup "$src/build" "$src" -Dbuildtype=release -Dwerror=false
ninja -C "$src/build"
install -m755 "$src/build/cage" /usr/local/bin/cage

echo "Instalado: $(/usr/local/bin/cage -v 2>&1 | head -1)"
echo "Recordatorio: el greeter debe usar /usr/local/bin/cage en /etc/greetd/config.toml"
