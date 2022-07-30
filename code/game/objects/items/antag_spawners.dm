/obj/item/antag_spawner
	w_class = ITEMSIZE_TINY
	var/used = 0
	var/ghost_query_type = null
	var/searching = FALSE
	var/datum/effect_system/spark_spread/sparks

/obj/item/antag_spawner/Initialize()
	. = ..()
	sparks = new /datum/effect_system/spark_spread()
	sparks.set_up(5, 0, src)
	sparks.attach(loc)

/obj/item/antag_spawner/Destroy()
	QDEL_NULL(sparks)
	return ..()

/obj/item/antag_spawner/proc/spawn_antag(client/C, turf/T)
	return

/obj/item/antag_spawner/proc/equip_antag(mob/target)
	return

/obj/item/antag_spawner/proc/request_player()
	if(!ghost_query_type)
		return
	if(searching)
		return // Already searching.
	searching = TRUE

	var/datum/ghost_query/Q = new ghost_query_type()
	var/list/winner = Q.query()
	if(winner.len)
		var/mob/observer/dead/D = winner[1]
		spawn_antag(D.client, get_turf(src))
	else
		reset_search()
	return

/obj/item/antag_spawner/proc/reset_search()
	searching = FALSE
	return

/obj/item/antag_spawner/technomancer_apprentice
	name = "apprentice teleporter"
	desc = "A teleportation device, which will bring a less potent manipulator of space to you."
	icon = 'icons/obj/objects.dmi'
	icon_state = "oldshieldoff"
	ghost_query_type = /datum/ghost_query/apprentice

/obj/item/antag_spawner/technomancer_apprentice/attack_self(mob/user)
	to_chat(user, "<span class='notice'>Teleporter attempting to lock on to your apprentice.</span>")
	request_player()

/obj/item/antag_spawner/technomancer_apprentice/request_player()
	icon_state = "oldshieldon"
	..()

/obj/item/antag_spawner/technomancer_apprentice/reset_search()
	..()
	if(!used)
		icon_state = "oldshieldoff"
		visible_message("<span class='warning'>The teleporter failed to find the apprentice.  Perhaps another attempt could be made later?</span>")

/obj/item/antag_spawner/technomancer_apprentice/spawn_antag(client/C, turf/T)
	sparks.start()
	var/mob/living/carbon/human/H = new/mob/living/carbon/human(T)
	C.prefs.copy_to(H)
	H.key = C.key

	to_chat(H, "<b>You are the Technomancer's apprentice!  Your goal is to assist them in their mission at the [station_name()].</b>")
	to_chat(H, "<b>Your service has not gone unrewarded, however. Studying under them, you have learned how to use a Manipulation Core \
	of your own.  You also have a catalog, to purchase your own functions and equipment as you see fit.</b>")
	to_chat(H, "<b>It would be wise to speak to your master, and learn what their plans are for today.</b>")

	spawn(1)
		technomancers.add_antagonist(H.mind, 0, 1, 0, 0, 0)
		equip_antag(H)
		used = 1
		qdel(src)

/obj/item/antag_spawner/technomancer_apprentice/equip_antag(mob/technomancer_mob)
	var/datum/antagonist/technomancer/antag_datum = all_antag_types[MODE_TECHNOMANCER]
	antag_datum.equip_apprentice(technomancer_mob)




/obj/item/antag_spawner/syndicate_drone
	name = "drone teleporter"
	desc = "A teleportation device, which will bring a powerful and loyal drone to you."
	icon = 'icons/obj/objects.dmi'
	icon_state = "oldshieldoff"
	ghost_query_type = /datum/ghost_query/syndicate_drone
	var/drone_type = null

/obj/item/antag_spawner/syndicate_drone/attack_self(mob/user)
	to_chat(user, "<span class='notice'>Teleporter attempting to lock on to an available unit.</span>")
	request_player()

/obj/item/antag_spawner/syndicate_drone/request_player()
	icon_state = "oldshieldon"
	..()

/obj/item/antag_spawner/syndicate_drone/reset_search()
	..()
	if(!used)
		icon_state = "oldshieldoff"
		visible_message("<span class='warning'>The teleporter failed to find any available.  Perhaps another attempt could be made later?</span>")

/obj/item/antag_spawner/syndicate_drone/spawn_antag(client/C, turf/T)
	sparks.start()
	var/mob/living/silicon/robot/R = new drone_type(T)

	// Put this text here before ckey change so that their laws are shown below it, since borg login() shows it.
	to_chat(C, "<span class='notice'>You are a <b>Mercenary Drone</b>, activated to serve your team.</span>")
	to_chat(C, "<span class='notice'><b>Be sure to examine your currently loaded lawset closely.</b>  It would be wise \
	to speak with your team, and learn what their plan is for today.</span>")

	R.key = C.key
//	R.Namepick() // Apparnetly making someone a merc lets them pick a name, so this isn't needed.

	spawn(1)
		mercs.add_antagonist(R.mind, FALSE, TRUE, FALSE, FALSE, FALSE)
		//add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)
		qdel(src)

/obj/item/antag_spawner/syndicate_drone/protector
	drone_type = /mob/living/silicon/robot/syndicate/protector

/obj/item/antag_spawner/syndicate_drone/combat_medic
	drone_type = /mob/living/silicon/robot/syndicate/combat_medic

/obj/item/antag_spawner/syndicate_drone/mechanist
	drone_type = /mob/living/silicon/robot/syndicate/mechanist
