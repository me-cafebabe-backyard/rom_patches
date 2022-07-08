#!/bin/bash -xe

MY_PATH=$(dirname "$0")
TOPDIR=$(pwd)

if [ $# -gt 0 ]; then
	CATEGORIES="$@"
else
	CATEGORIES="$(find -L $MY_PATH -mindepth 1 -maxdepth 1 -type d|sed s\|$MY_PATH/\|\|g|grep -vE '/debug$|/android-x86$')"
fi

mkdir .repo/local_manifests || true

for d in $CATEGORIES; do
	if [ -f "$MY_PATH/$d/local_manifest.xml" ]; then
		if [ ! -f ".repo/local_manifests/${d}.xml" ]; then
			SKIP_PATCH=1
		fi
		cp $MY_PATH/$d/local_manifest.xml .repo/local_manifests/${d}.xml
	fi # local_manifest

#	continue

	if [ -z "$SKIP_PATCH" ]; then
	for r in `dirname $(find -L $MY_PATH/$d -name *.patch)|sort|uniq|sed "s|$MY_PATH/$d/||g"`; do
		cd $r
		git am $MY_PATH/$d/$r/*.patch
		cd $TOPDIR
	done # repo
	fi
done # category
