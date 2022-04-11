/datum/event/morph_spawn
	startWhen = 1
	endWhen = 30

/datum/event/morph_spawn/start()

	var/obj/effect/landmark/spawnspot = null
	var/list/possibleSpawnspots = list()
	for(var/obj/effect/landmark/newSpawnspot in landmarks_list)
		if(newSpawnspot.name == "morphspawn")
			possibleSpawnspots += newSpawnspot
	if(possibleSpawnspots.len)
		spawnspot = pick(possibleSpawnspots)
	else
		kill()		// To prevent fake announcements
		return

	if(!spawnspot)
		kill()		// To prevent fake announcements
		return

	new /obj/structure/ghost_pod/ghost_activated/morphspawn(get_turf(spawnspot))