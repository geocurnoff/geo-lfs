#!/usr/bin/bash

# A command interface for packages

die() {  printf %s "${@+$@$'\n'}" 1>&2 ; exit 1; }

using() {
	for u in $USE; do
		[ $u = $1 ] && return 0
	done
}

[ "$#" -lt 2 ] && die "USAGE: pkg-invoke.sh <command list> <package name>"

PACKAGES_DIR=$(readlink -f `dirname $0`)

. $PACKAGES_DIR/config.sh

PKG_DIR_NAME="${@:$#}"

check_package_exists() {
	pushd "$PACKAGES_DIR" > /dev/null
	for pkg in ./*/
	do
		[ "$1" = $(basename $pkg) ] && popd &> /dev/null && return 0
	done
	popd &> /dev/null
	return 1
}

check_package_exists $PKG_DIR_NAME || die "Package doesn't exist!"

# Recursively process each command

if [ "$#" -gt 2 ]; then
	$PACKAGES_DIR/pkg-invoke.sh $1 $PKG_DIR_NAME || die "Command $1 failed."
	shift
	$PACKAGES_DIR/pkg-invoke.sh $@ || die
else
	pushd $PACKAGES_DIR/$PKG_DIR_NAME/ > /dev/null || die
	PKGDIR=$(pwd)
	NAME=$(basename "$PACKAGES_DIR/$PKG_DIR_NAME/")
	[ -f common.sh ] && . common.sh
	echo "Invoking $1 command on package ${NAME-$2}"
	[ -f "$1".cmd.sh ] && . "$1".cmd.sh
	popd > /dev/null
fi

exit 0
