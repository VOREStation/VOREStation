#!/bin/bash
BASEDIR=$PWD
#Put directories to get maps from here. One per line.
mapdirs=(
    "maps/groundbase"
    "maps/stellar_delight"
    "maps/tether"
    "maps/offmap_vr/talon"
)
#Put a define file to include. One per line matching mapdirs.
#If the same define is reused it will be batched if in sequence.
mapdefines=(
	"maps/groundbase/groundbase.dm"
	"maps/stellar_delight/stellar_delight.dm"
	"maps/tether/tether.dm"
	"maps/tether/tether.dm"
)
dme="vorestation.dme"
RED='\033[0;31m'
GREEN="\033[0;32m"
#This will automatically fill with any maps in mapdirs that are form MAPNAMEn.dmm.
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

#Duplicate stdout because dmm-tools doesn't return an error code for bad icons or bad path so we need to capture it
exec 5>&1

#Now render per group to initial images
any_errors=0
map_files=()
index=0
for mapdir in ${mapdirs[@]}; do
    FULLMAPDIR=$BASEDIR/$mapdir
    map_files+=($FULLMAPDIR/*[0-9]*.dmm)
	cur_define=${mapdefines[index++]}

	if [[ (index -lt ${#mapdefines[@]}) && ("${cur_define}" == "${mapdefines[$index]}") ]]; then
		# Next iteration uses the same define so batch it
		echo "Batching next iteration..."
		continue
	fi

	#Insert the define file into the dme if needed
	if [[ "${cur_define}" != "" ]]; then
		echo "Injecting ${cur_define} into ${dme}..."
		echo "#include \"${cur_define}\"" >> ${dme}
	fi

	#Render maps to initial images ignoring some tg specific icon_state handling
	result=$(~/dmm-tools minimap "${map_files[@]}" --disable smart-cables,overlays,pretty | tee /dev/fd/5)

	#Check if anything errored
	if [[ ($? -ne 0) || ("${result}" =~ ("bad icon"|"bad path")) ]]; then
		any_errors=1
	fi

	#Undo changes for next iteration
	map_files=()
	if [[ "${cur_define}" != "" ]]; then
		sed -i '$ d' ${dme}
	fi
	printf "\n"
done

#Give results if we're just testing
if [[ $1 == "--testing" ]]; then
	if [[ any_errors -ne 0 ]]; then
		echo -e "${RED}Errors occured during testing!"
		exit 1
	fi
	echo -e "${GREEN}Maps were successfully rendered."
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
