/datum/event/morph_spawn
	startWhen = 1
	announceWhen = 15
	var/announceProb = 50

/datum/event/morph_spawn/start()
	processing_active = FALSE

	var/obj/effect/landmark/spawnspot = null
	var/list/possibleSpawnspots = list()
	for(var/obj/effect/landmark/newSpawnspot in landmarks_list)
		if(newSpawnspot.name == "morphspawn")
			possibleSpawnspots += newSpawnspot
		if(possibleSpawnspots.len)
			spawnspot = pick(possibleSpawnspots)
		else
			break

	if(!spawnspot)
		processing_active = TRUE
		return

	var/datum/ghost_query/Q = new /datum/ghost_query/morph()
	var/list/winner = Q.query()

	if(winner.len)
		var/mob/living/simple_mob/vore/hostile/morph/newMorph = new /mob/living/simple_mob/vore/hostile/morph(get_turf(spawnspot))
		var/mob/observer/dead/D = winner[1]
		if(D.mind)
			D.mind.transfer_to(newMorph)
		to_chat(D, "<span class='notice'>You are a <b>Morph</b>, somehow having gotten aboard the station in your wandering. \
		You are wary of environment around you, but your primal hunger still calls for you to find prey. Seek a convincing disguise, \
		using your amorphous form to traverse vents to find and consume weak prey.</span>")
		to_chat(D, "<span class='notice'>You can use shift + click on objects to disguise yourself as them, but your strikes are nearly useless when you are disguised. \
		You can undisguise yourself by shift + clicking yourself, but disguise being switched, or turned on and off has a short cooldown.</span>")
		newMorph.ckey = D.ckey
		newMorph.visible_message("<span class='warning'>A morph appears to crawl out of somewhere.</span>")
	else
		processing_active = TRUE
		return

	processing_active = TRUE

/datum/event/morph_spawn/announce()
	if(announceProb)
		command_announcement.Announce("Unknown entitity detected boarding [station_name()]. Exercise extra caution.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')