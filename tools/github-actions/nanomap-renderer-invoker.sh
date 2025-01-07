#!/bin/bash
BASEDIR=$PWD
#Put directories to get maps from here. One per line.
mapdirs=(
    "maps/groundbase"
    "maps/stellar_delight"
    "maps/tether"
    "maps/offmap_vr/talon"
)
RED='\033[0;31m'
GREEN="\033[0;32m"
#DO NOT TOUCH THIS VARIABLE. It will automatically fill with any maps in mapdirs that are form MAPNAMEn.dmm.
map_files=()

#Fill up mapfiles list
for mapdir in ${mapdirs[@]}; do
    echo "Scanning $mapdir..."
    FULLMAPDIR=$BASEDIR/$mapdir
    map_files+=($FULLMAPDIR/*[0-9]*.dmm)
done

#Print full map list
echo "Full map list:"
for map in ${map_files[@]}; do
    echo $map
done

printf "\n\n\n"
echo "Rendering maps..."

#Render maps to initial images
~/dmm-tools minimap "${map_files[@]}" --disable smart-cables,overlays,pretty

if [ $1 == "--testing" ]; then
	if [ $? -eq 0 ]; then
		#Errors occured during test
		echo "${RED}Errors occured during testing!"
		exit 1
	fi
	#Testing passed
	echo "${GREEN}Maps were successfully rendered."
	exit 0
fi

cd data/minimaps

printf "\n\n\n"
echo "Starting image resizing..."

#Resize images to proper size and move them to the correct place
for map in ./*.png; do
    j=$(echo $map | sed -n "s/^\.\/\(.*\)-\([0-9]*\)\-1.png$/\1_nanomap_z\2.png/p")
    echo "Resizing $map and moving to icons/_nanomaps/$j"
    convert $map -resize 2240x2240 "$BASEDIR/icons/_nanomaps/$j"
done
