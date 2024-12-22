// GHOST CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows ghosts to see turfs of non AREA_BLOCK_GHOST_SIGHT flagged areas within these chunks.

/datum/chunk/ghost
	var/list/hidden_areas = list()

/datum/chunk/ghost/add(mob/observer/dead/ghost, add_images = TRUE)
	if(add_images)
		var/client/client = ghost.client
		if(client)
			client.images += obscured
	ghost.visibleChunks += src
	visible++
	seenby += ghost
	if(changed && !updating)
		update()

/datum/chunk/ghost/remove(mob/observer/dead/ghost, remove_images = TRUE)
	if(remove_images)
		var/client/client = ghost.client
		if(client)
			client.images -= obscured
	ghost.visibleChunks -= src
	seenby -= ghost
	if(visible > 0)
		visible--

/datum/chunk/ghost/acquireVisibleTurfs(var/list/invisible)

	for(var/area/A in hidden_areas)

		for(var/turf/T in A.contents)
			invisible[T] = T

// Don't call the parernt, we work inverted!
/datum/chunk/ghost/New(loc, x, y, z)
	for(var/area/A in range(16, locate(x + 8, y + 8, z)))
		if(A.flag_check(AREA_BLOCK_GHOST_SIGHT))
			hidden_areas += A

	// 0xf = 15
	x &= ~0xf
	y &= ~0xf

	src.x = x
	src.y = y
	src.z = z

	for(var/turf/t in range(10, locate(x + 8, y + 8, z)))
		if(t.x >= x && t.y >= y && t.x < x + 16 && t.y < y + 16)
			turfs[t] = t

	acquireVisibleTurfs(obscuredTurfs)

	// Removes turf that isn't in turfs.
	obscuredTurfs &= turfs

	visibleTurfs = turfs - obscuredTurfs

	for(var/turf/t as anything in obscuredTurfs)
		LAZYINITLIST(t.obfuscations)
		if(!t.obfuscations[obfuscation.type])
			var/image/ob_image = image(obfuscation.icon, t, obfuscation.icon_state, OBFUSCATION_LAYER)
			ob_image.plane = PLANE_FULLSCREEN
			t.obfuscations[obfuscation.type] = ob_image
		obscured += t.obfuscations[obfuscation.type]

/datum/chunk/ghost/update()

	set background = 1

	var/list/newInvisibleTurfs = new()
	acquireVisibleTurfs(newInvisibleTurfs)

	// Removes turf that isn't in turfs.
	newInvisibleTurfs &= turfs

	var/list/visAdded = obscuredTurfs - newInvisibleTurfs
	var/list/visRemoved = newInvisibleTurfs - obscuredTurfs

	visibleTurfs = turfs - newInvisibleTurfs
	obscuredTurfs = newInvisibleTurfs

	for(var/turf/t as anything in visAdded)
		if(LAZYLEN(t.obfuscations) && t.obfuscations[obfuscation.type])
			obscured -= t.obfuscations[obfuscation.type]
			for(var/mob/observer/dead/m as anything in seenby)
				if(!m)
					continue
				var/client/client = m.client
				if(client)
					client.images -= t.obfuscations[obfuscation.type]

	for(var/turf/t as anything in visRemoved)
		if(obscuredTurfs[t])
			LAZYINITLIST(t.obfuscations)
			if(!t.obfuscations[obfuscation.type])
				var/image/ob_image = image(obfuscation.icon, t, obfuscation.icon_state, OBFUSCATION_LAYER)
				ob_image.plane = PLANE_FULLSCREEN
				t.obfuscations[obfuscation.type] = ob_image

			obscured += t.obfuscations[obfuscation.type]
			for(var/mob/observer/dead/m as anything in seenby)
				if(!m)
					seenby -= m
					continue
				if(!m.checkStatic())
					continue
				var/client/client = m.client
				if(client)
					client.images += t.obfuscations[obfuscation.type]
