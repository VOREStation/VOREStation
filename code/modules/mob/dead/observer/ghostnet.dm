// GHOST NET
//
// The datum containing all the hidden chunks.

/datum/visualnet/ghost
	chunk_type = /datum/chunk/ghost

// Removes a area from a chunk.

/datum/visualnet/ghost/proc/removeArea(area/A)
	if(!A.flag_check(AREA_BLOCK_GHOST_SIGHT))
		majorChunkChange(A, 0)

// Add a area to a chunk.

/datum/visualnet/ghost/proc/addArea(area/A)
	if(A.flag_check(AREA_BLOCK_GHOST_SIGHT))
		majorChunkChange(A, 1)

// Used for ghost visible areas. Since portable areas can be in ANY chunk.

/datum/visualnet/ghost/proc/updateArea(area/A)
	if(A.flag_check(AREA_BLOCK_GHOST_SIGHT))
		majorChunkChange(A, 1)
	else
		majorChunkChange(A, 0)

/datum/visualnet/ghost/majorChunkChange(area/A, var/choice)
	for(var/entry in chunks)
		var/datum/chunk/ghost/gchunk = chunks[entry]
		for(var/turf/T in gchunk.turfs)
			if(T.loc == A)
				onMajorChunkChange(A, choice, gchunk)
				gchunk.hasChanged(TRUE)
				break

/datum/visualnet/ghost/onMajorChunkChange(atom/c, var/choice, var/datum/chunk/ghost/chunk)
// Only add actual areas to the list of areas
	if(istype(c, /area))
		if(choice == 0)
			// Remove the area.
			chunk.hidden_areas -= c
		else if(choice == 1)
			// You can't have the same area in the list twice.
			chunk.hidden_areas |= c
