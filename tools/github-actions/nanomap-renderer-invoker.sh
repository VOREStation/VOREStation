#!/bin/bash
BASEDIR=$PWD
#Put directories to get maps from here. One per line.
mapdirs=(
    "maps/groundbase"
    "maps/stellar_delight"
    "maps/tether"
    "maps/offmap_vr/talon"
)
#DO NOT TOUCH THIS VARIABLE. It will automatically fill with any maps in mapdirs that are form MAPNAME-n.dmm where n is the z level.
map_files=()

#Fill up mapfiles list
for mapdir in ${mapdirs[@]}; do
    echo "Scanning $mapdir..."
    FULLMAPDIR=$BASEDIR/$mapdir
    map_files+=($FULLMAPDIR/*-*[0-9].dmm)
done

#Print full map list
echo "Full map list:"
for map in ${map_files[@]}; do
    echo $map
done

printf "\n\n\n"
echo "Rendering maps..."

#Render maps to initial images
~/dmm-tools minimap "${map_files[@]}"

cd data/minimaps

printf "\n\n\n"
echo "Starting image resizing..."

#Resize images to proper size and move them to the correct place
for map in ./*.png; do
    j=$(echo $map | sed -n "s/^\.\/\(.*\)-\([0-9]*\)\-1.png$/\1_nanomap_z\2.png/p")
    echo "Resizing $map and moving to icons/_nanomaps/$j"
    convert $map -resize 2240x2240 "$BASEDIR/icons/_nanomaps/$j"
done
