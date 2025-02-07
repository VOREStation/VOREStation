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
for mapdir in "${mapdirs[@]}"; do
	echo "Scanning $mapdir..."
	#https://stackoverflow.com/a/23357277
	while IFS= read -r -d $'\0'; do
		map_files+=("$REPLY")
	done < <(find "${BASEDIR}/${mapdir}" -maxdepth 1 -name '*[0-9]*.dmm' -print0)
done

#Print full map list
echo "Full map list (${#map_files[@]}):"
for map in "${map_files[@]}"; do
	echo $map
done
printf "\n\n\n"

#Duplicate stderr because dmm-tools doesn't return an error code for bad icons or bad path so we need to capture it
exec 5>&2

#Now render per group to initial images
any_errors=0
map_files=()
index=0
for mapdir in "${mapdirs[@]}"; do
	#https://stackoverflow.com/a/23357277
	while IFS= read -r -d $'\0'; do
		map_files+=("$REPLY")
	done < <(find "${BASEDIR}/${mapdir}" -maxdepth 1 -name '*[0-9]*.dmm' -print0)
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
	result=$(~/dmm-tools minimap "${map_files[@]}" --disable smart-cables,overlays,pretty,transit-tube 2>&1 | tee /dev/fd/5)

	#Check if anything errored
	if [[ ($? -ne 0) || ("${result}" =~ ("bad icon"|"bad path"|"error")) ]]; then
		any_errors=1
	fi

	#Undo changes for next iteration
	map_files=()
	if [[ "${cur_define}" != "" ]]; then
		sed -i '$ d' ${dme}
	fi

	printf "\n"
done

#Close the new file descriptor
exec 5>&-

#Give results if we're just testing
if [[ $1 == "--testing" ]]; then
	if [[ any_errors -ne 0 ]]; then
		echo -e "${RED}Errors occured during testing!"
		exit 1
	fi
	echo -e "${GREEN}Maps were successfully rendered."
	exit 0
fi

echo "Starting image resizing..."
cd data/minimaps

#Resize images to proper size and copy them to the correct place
for map in ./*.png; do
	j=$(echo $map | sed -nE "s/^\.\/([^-]*)(-[^1-9]*)?([1-9][0-9]*)(.*)-1\.png$/\1_nanomap_z\3.png/p")
	echo "Resizing $map and copying to icons/_nanomaps/$j"
	convert $map -resize 2240x2240 "$BASEDIR/icons/_nanomaps/$j"
done
