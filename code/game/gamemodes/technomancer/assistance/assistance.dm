/datum/technomancer/assistance
	var/one_use_only = 0

/datum/technomancer/assistance/apprentice
	name = "Friendly Apprentice"
	desc = "A one-time use teleporter that sends a less powerful manipulator of space to you, who will do their best to protect \
	and serve you.  They get their own catalog and can buy spells for themselves, however they have a smaller pool to buy with.  \
	If you are unable to receive an apprentice, the teleporter can be refunded like most equipment by sliding it into the \
	catalog.  Note that apprentices cannot purchase more apprentices."
	cost = 300
	obj_path = /obj/item/weapon/antag_spawner/technomancer_apprentice

/obj/item/weapon/antag_spawner
	w_class = ITEMSIZE_TINY
	var/used = 0

/obj/item/weapon/antag_spawner/proc/spawn_antag(client/C, turf/T)
	return

/obj/item/weapon/antag_spawner/proc/equip_antag(mob/target)
	return

/obj/item/weapon/antag_spawner/technomancer_apprentice
	name = "apprentice teleporter"
	desc = "A teleportation device, which will bring a less potent manipulator of space to you."
	icon = 'icons/obj/objects.dmi'
	icon_state = "oldshieldoff"
	var/searching = 0
	var/datum/effect/effect/system/spark_spread/sparks

/obj/item/weapon/antag_spawner/technomancer_apprentice/New()
	..()
	sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(5, 0, src)
	sparks.attach(loc)

/obj/item/weapon/antag_spawner/technomancer_apprentice/Destroy()
	qdel(sparks)
	return ..()

/obj/item/weapon/antag_spawner/technomancer_apprentice/attack_self(mob/user)
	user << "<span class='notice'>Teleporter attempting to lock on to your apprentice.</span>"
	searching = 1
	icon_state = "oldshieldon"
	for(var/mob/observer/dead/O in player_list)
		if(!O.MayRespawn())
			continue
		if(jobban_isbanned(O, "Syndicate") || jobban_isbanned(O, "wizard"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_WIZARD)
				question(O.client)
	spawn(1 MINUTE)
		searching = 0
		if(!used)
			icon_state = "oldshieldoff"
			user << "<span class='warning'>The teleporter failed to find your apprentice.  Perhaps you could try again later?</span>"


/obj/item/weapon/antag_spawner/technomancer_apprentice/proc/question(var/client/C)
	spawn(0)
		if(!C)
			return
		var/response = alert(C, "Someone is requesting a Technomancer apprentice  Would you like to play as one?",
		"Apprentice request","Yes", "No")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as an apprentice?", "Apprentice request", "Yes", "No")
		if(!C || used || !searching)
			return
		if(response == "Yes")
			spawn_antag(C, get_turf(src))

/obj/item/weapon/antag_spawner/technomancer_apprentice/spawn_antag(client/C, turf/T)
	sparks.start()
	var/mob/living/carbon/human/H = new/mob/living/carbon/human(T)
	C.prefs.copy_to(H)
	H.key = C.key

	H << "<b>You are the Technomancer's apprentice!  Your goal is to assist them in their mission at the [station_name()].</b>"
	H << "<b>Your service has not gone unrewarded, however. Studying under them, you have learned how to use a Manipulation Core \
	of your own.  You also have a catalog, to purchase your own functions and equipment as you see fit.</b>"
	H << "<b>It would be wise to speak to your master, and learn what their plans are for today.</b>"

	spawn(1)
		technomancers.add_antagonist(H.mind, 0, 1, 0, 0, 0)
		equip_antag(H)
		used = 1
		qdel(src)


/obj/item/weapon/antag_spawner/technomancer_apprentice/equip_antag(mob/technomancer_mob)
	var/datum/antagonist/technomancer/antag_datum = all_antag_types[MODE_TECHNOMANCER]
	antag_datum.equip_apprentice(technomancer_mob)


/*
// For when no one wants to play support.
/datum/technomancer/assistance/golem
	name = "Friendly GOLEM unit"
	desc = "Teleports a specially designed synthetic unit to you, which is very durable, has an advanced AI, and can also use \
	functions.  It knows Shield, Targeted Blink, Beam, Mend Life, Mend Synthetic, Lightning, Repel Missiles, Corona, Ionic Bolt, Dispel, and Chain Lightning.  \
	It also has a large storage capacity for energy, and due to it's synthetic nature, instability is less of an issue for them."
	cost = 350
	obj_path = null //TODO
	one_use_only = 1

/datum/technomancer/assistance/ninja
	name = "Neutral Cyberassassin"
	desc = "Someone almost as enigmatic as you will also arrive at your destination, with their own goals and motivations.  \
	This could prove to be a problem if they decide to go against you, so this is only recommended as a challenge."
	cost = 100
	obj_path = null //TODO
	one_use_only = 1

// Hardmode.
/datum/technomancer/assistance/enemy_technomancer
	name = "Enemy Technomancer"
	desc = "Another manipulator of space will arrive on the colony in addition to you, most likely wanting to oppose you in \
	some form, if you purchase this.  This is only recommended as a challenge."
	cost = 100
	obj_path = null //TODO
	one_use_only = 1
*/