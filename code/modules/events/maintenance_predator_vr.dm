/datum/event/maintenance_predator
	startWhen = 1
	endWhen = 30

/datum/event/maintenance_predator/start()

	var/obj/effect/landmark/spawnspot = null
	var/list/possibleSpawnspots = list()
	for(var/obj/effect/landmark/L in landmarks_list)
		if(L.name == "maint_pred")
			possibleSpawnspots += L
	if(possibleSpawnspots.len)
		spawnspot = pick(possibleSpawnspots)
	else
		kill()		// To prevent fake announcements
		return

	if(!spawnspot)
		kill()		// To prevent fake announcements
		return

	var/obj/structure/ghost_pod/ghost_activated/maintpred/M = new /obj/structure/ghost_pod/ghost_activated/maintpred(get_turf(spawnspot))
	
	if(prob(35))
		M.trigger(null,"A maint pred event has occurred and called for ghosts to activate it.")
