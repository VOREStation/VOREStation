/obj/structure/ghost_pod/ghost_activated/maintpred
	name = "maintenance hole"
	desc = "Looks like some creature dug its way into station's maintenance..."
	icon = 'icons/effects/effects.dmi'
	icon_state = "tunnel_hole"
	icon_state_opened = "tunnel_hole"
	density = FALSE
	ghost_query_type = /datum/ghost_query/maints_pred
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	spawn_active = TRUE
	var/announce_prob = 35
	var/list/possible_mobs = list("Space Bumblebee" = /mob/living/simple_mob/vore/bee,
								  "Voracious Lizard" = /mob/living/simple_mob/vore/aggressive/dino,
								  "Giant Frog" = /mob/living/simple_mob/vore/aggressive/frog,
								  "Giant Rat" = /mob/living/simple_mob/vore/aggressive/rat,
								  "Juvenile Solargrub" = /mob/living/simple_mob/vore/solargrub,
								  "Red Panda" = /mob/living/simple_mob/vore/redpanda,
								  "Fennec" = /mob/living/simple_mob/vore/fennec,
								  "Fennix" = /mob/living/simple_mob/vore/fennix,
								  "Jelly Blob" = /mob/living/simple_mob/animal/space/jelly,
								  "Wolf" = /mob/living/simple_mob/animal/wolf,
								  "Sect Queen" = /mob/living/simple_mob/vore/sect_queen,
								  "Defanged Xenomorph" = /mob/living/simple_mob/vore/xeno_defanged,
								  )

/obj/structure/ghost_pod/ghost_activated/maintpred/create_occupant(var/mob/M)
	..()
	var/choice
	var/randomize
	var/finalized = "No"

	while(finalized == "No" && M.client)
		choice = input(M,"What type of predator do you want to play as?") as null|anything in possible_mobs
		if(!choice)
			randomize = TRUE
			break

		if(choice)
			finalized = alert(M, "Are you sure you want to play as [choice]?","Confirmation","No","Yes")

	if(randomize)
		choice = pick(possible_mobs)

	var/mobtype = possible_mobs[choice]
	var/mob/living/simple_mob/newPred = new mobtype(get_turf(src))
	qdel(newPred.ai_holder)
	newPred.ai_holder = null
	//newPred.movement_cooldown = 0			// The "needless artificial speed cap" exists for a reason
	if(M.mind)
		M.mind.transfer_to(newPred)
	to_chat(M, "<span class='notice'>You are <b>[newPred]</b>, somehow having gotten aboard the station in search of food. \
	You are wary of environment around you, but you do feel rather peckish. Stick around dark, secluded places to avoid danger or, \
	if you are cute enough, try to make friends with this place's inhabitants.</span>")
	newPred.ckey = M.ckey
	newPred.visible_message("<span class='warning'>[newPred] emerges from somewhere!</span>")

	if(prob(announce_prob))
		spawn(2 MINUTES)
			command_announcement.Announce("Unexpected biosignature detected in the maintenance tunnels of [station_name()].", "Lifesign Alert")

	qdel(src)

/obj/structure/ghost_pod/ghost_activated/maintpred/no_announce
	announce_prob = 0

/obj/structure/ghost_pod/ghost_activated/morphspawn
	name = "weird goo"
	desc = "A pile of weird gunk... Wait, is it actually moving?"
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "morph"
	icon_state_opened = "morph_dead"
	density = FALSE
	ghost_query_type = /datum/ghost_query/morph
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	spawn_active = TRUE
	var/announce_prob = 50

/obj/structure/ghost_pod/ghost_activated/morphspawn/create_occupant(var/mob/M)
	..()
	var/mob/living/simple_mob/vore/hostile/morph/newMorph = new /mob/living/simple_mob/vore/hostile/morph(get_turf(src))
	if(M.mind)
		M.mind.transfer_to(newMorph)
	to_chat(M, "<span class='notice'>You are a <b>Morph</b>, somehow having gotten aboard the station in your wandering. \
	You are wary of environment around you, but your primal hunger still calls for you to find prey. Seek a convincing disguise, \
	using your amorphous form to traverse vents to find and consume weak prey.</span>")
	to_chat(M, "<span class='notice'>You can use shift + click on objects to disguise yourself as them, but your strikes are nearly useless when you are disguised. \
	You can undisguise yourself by shift + clicking yourself, but disguise being switched, or turned on and off has a short cooldown. You can also ventcrawl, \
	by using alt + click on the vent or scrubber.</span>")
	newMorph.ckey = M.ckey
	newMorph.visible_message("<span class='warning'>A morph appears to crawl out of somewhere.</span>")

	if(prob(announce_prob))
		spawn(2 MINUTES)
			command_announcement.Announce("Unexpected biosignature detected in the maintenance tunnels of [station_name()].", "Lifesign Alert")

	qdel(src)

/obj/structure/ghost_pod/ghost_activated/morphspawn/no_announce
	announce_prob = 0