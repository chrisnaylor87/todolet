#!/bin/sh
# Build dist/todolet_<version>_all.deb from the working tree.
# Needs only dpkg-deb (present on any Debian/Ubuntu/Mint box).
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root=$(dirname -- "$here")
version=$(sed -n "s/^__version__ = '\(.*\)'/\1/p" "$root/todolet")
[ -n "$version" ] || { echo 'could not read __version__ from todolet' >&2; exit 1; }

pkg="todolet_${version}_all"
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
dst="$stage/$pkg"

install -Dm755 "$root/todolet" "$dst/usr/bin/todolet"
install -Dm644 "$here/todolet.1" "$dst/usr/share/man/man1/todolet.1"
gzip -9n "$dst/usr/share/man/man1/todolet.1"

install -d "$dst/usr/share/doc/todolet"
cat > "$dst/usr/share/doc/todolet/copyright" <<EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: todolet
Source: https://todolet.app

Files: *
Copyright: 2026 Chris Naylor
License: MIT
EOF
sed 's/^$/./; s/^/ /' "$root/LICENSE" >> "$dst/usr/share/doc/todolet/copyright"

cat > "$dst/usr/share/doc/todolet/changelog.Debian" <<EOF
todolet ($version-1) unstable; urgency=medium

  * New upstream release.

 -- Chris Naylor <naylor.chris@gmail.com>  $(date -R)
EOF
gzip -9n "$dst/usr/share/doc/todolet/changelog.Debian"

chmod 644 "$dst/usr/share/doc/todolet/copyright" "$dst/usr/share/doc/todolet/changelog.Debian.gz"

install -d "$dst/DEBIAN"
cat > "$dst/DEBIAN/control" <<EOF
Package: todolet
Version: $version-1
Section: utils
Priority: optional
Architecture: all
Depends: python3
Maintainer: Chris Naylor <naylor.chris@gmail.com>
Homepage: https://todolet.app
Description: week-at-a-glance to-do list for the terminal
 Terminal companion to the todolet.app web app: see the week ahead, add
 tasks to a day, tick them off. No accounts, no cloud, no dependencies.
 .
 Tasks are stored in a local JSON file in the same format as the web
 app's backups, so data moves freely between phone and terminal.
EOF

mkdir -p "$root/dist"
dpkg-deb --build --root-owner-group "$dst" "$root/dist/$pkg.deb"
echo "built dist/$pkg.deb"
