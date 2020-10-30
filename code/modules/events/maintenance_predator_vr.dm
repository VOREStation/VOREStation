/datum/event/maintenance_predator
	startWhen = 1
	announceWhen = 50
	endWhen = 100
	var/announceProb = 35
	var/list/possible_mobs = list("Space Bumblebee" = /mob/living/simple_mob/vore/bee,
								  "Voracious Lizard" = /mob/living/simple_mob/vore/aggressive/dino,
								  "Giant Frog" = /mob/living/simple_mob/vore/aggressive/frog,
								  "Giant Rat" = /mob/living/simple_mob/vore/aggressive/rat,
								  "Juvenile Solargrub" = /mob/living/simple_mob/vore/solargrub,
								  "Red Panda" = /mob/living/simple_mob/vore/redpanda,
								  "Fennec" = /mob/living/simple_mob/vore/fennec,
								  "Fennix" = /mob/living/simple_mob/vore/fennix,
								  "Jelly Blob" = /mob/living/simple_mob/animal/space/jelly,
								  "Wolf" = /mob/living/simple_mob/animal/wolf)

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

	var/datum/ghost_query/Q = new /datum/ghost_query/maints_pred()
	var/list/winner = Q.query()

	if(winner.len)
		var/mob/observer/dead/D = winner[1]
		var/choice
		var/randomize
		var/finalized = "No"

		while(finalized == "No" && D.client)
			choice = input(D,"What type of predator do you want to play as?") as null|anything in possible_mobs
			if(!choice)
				randomize = TRUE
				break

			if(choice)
				finalized = alert(D, "Are you sure you want to play as [choice]?","Confirmation","No","Yes")

		if(randomize)
			choice = pick(possible_mobs)

		var/mobtype = possible_mobs[choice]
		var/mob/living/simple_mob/newPred = new mobtype(get_turf(spawnspot))
		qdel(newPred.ai_holder)
		newPred.ai_holder = null
		newPred.movement_cooldown = 0			// Remove the needless artificial speed cap
		if(D.mind)
			D.mind.transfer_to(newPred)
		to_chat(D, "<span class='notice'>You are <b>[newPred]</b>, somehow having gotten aboard the station in search of food. \
		You are wary of environment around you, but you do feel rather peckish. Stick around dark, secluded places to avoid danger or, \
		if you are cute enough, try to make friends with this place's inhabitants.</span>")
		newPred.ckey = D.ckey
		newPred.visible_message("<span class='warning'>[newPred] emerges from somewhere!</span>")
	else
		kill()		// To prevent fake announcements
		return


/datum/event/maintenance_predator/announce()
	if(prob(announceProb))
		command_announcement.Announce("Unexpected biosignature detected in the maintenance tunnels of [station_name()].", "Lifesign Alert")