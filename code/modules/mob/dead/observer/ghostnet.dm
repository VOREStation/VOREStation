// GHOST NET
//
// The datum containing all the hidden chunks.

/datum/visualnet/ghost
	chunk_type = /datum/chunk/ghost

/datum/visualnet/ghost/proc/addVisibility(list/moved_eyes, client/C)
	if(!islist(moved_eyes))
		moved_eyes = moved_eyes ? list(moved_eyes) : list()

	for(var/mob/observer/dead/ghost as anything in moved_eyes)
		for(var/datum/chunk/ghost/c as anything in ghost.visibleChunks)
			c.remove(ghost)

/datum/visualnet/ghost/proc/removeVisibility(list/moved_eyes, client/C)
	if(!islist(moved_eyes))
		moved_eyes = moved_eyes ? list(moved_eyes) : list()

	var/list/chunks_post_seen = list()

	for(var/mob/observer/dead/ghost as anything in moved_eyes)
		var/static_range = ghost.static_visibility_range

		var/x1 = max(0, ghost.x - static_range) & ~(CHUNK_SIZE - 1)
		var/y1 = max(0, ghost.y - static_range) & ~(CHUNK_SIZE - 1)
		var/x2 = min(world.maxx, ghost.x + static_range) & ~(CHUNK_SIZE - 1)
		var/y2 = min(world.maxy, ghost.y + static_range) & ~(CHUNK_SIZE - 1)

		for(var/x = x1; x <= x2; x += CHUNK_SIZE)
			for(var/y = y1; y <= y2; y += CHUNK_SIZE)
				var/datum/chunk/ghost/c = getChunk(x, y, ghost.z)
				if(!ghost.visibleChunks[c])
					c.add(ghost, FALSE)

		if(C)
			chunks_post_seen |= ghost.visibleChunks

	if(C)
		for(var/datum/chunk/c as anything in chunks_post_seen)
			C.images += c.obscured

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
	if(choice == 2 || !A.ghost_chunks)
		return

	for(var/datum/chunk/ghost/gchunk as anything in A.ghost_chunks)
		if(choice == 1 && gchunk.hidden_areas[A])
			continue
		if(choice == 0 && !gchunk.hidden_areas[A])
			continue

		onMajorChunkChange(A, choice, gchunk)
		gchunk.hasChanged(TRUE)

/datum/visualnet/ghost/onMajorChunkChange(atom/c, var/choice, var/datum/chunk/ghost/chunk)
// Only add actual areas to the list of areas
	if(istype(c, /area))
		if(choice == 0)
			// Remove the area.
			chunk.hidden_areas -= c
		else if(choice == 1)
			// You can't have the same area in the list twice.
			chunk.hidden_areas |= c
