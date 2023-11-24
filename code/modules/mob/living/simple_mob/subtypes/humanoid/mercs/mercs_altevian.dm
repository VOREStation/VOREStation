/mob/living/simple_mob/humanoid/merc/altevian
	name = "altevian naval officer"
	desc = "An Altevian Naval Slicer, adorned in the top of the line Heartbreaker suit. Armed with a handheld cutter."
	tt_desc = "E Rattus sapiens"
	icon = 'icons/mob/altevian_mercs_vr.dmi'
	icon_state = "merc_melee_cutter"
	icon_living = "merc_melee_cutter"
	icon_dead = "merc-dead"
	icon_gib = "merc_gib"

	faction = "altevian"
	movement_cooldown = 1

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_armor_pen = 50
	attack_sharp = TRUE
	attack_edge = 1
	attacktext = list("slashed")
	armor = list(melee = 90, bullet = 90, laser = 90, energy = 90, bomb = 90, bio = 100, rad = 100)			//matches stats of suit they drop. Basically tank. Rat tank. Ratank.

	corpse = /obj/effect/landmark/mobcorpse/altevian
	loot_list = list(/obj/item/weapon/melee/energy/sword/altevian = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/merc
	say_list_type = /datum/say_list/merc/altevian

/datum/say_list/merc/altevian
	speak = list("Operations going along as planned.",
				"No news to report, Mission Control. All is clear.",
				"Salvage operations still underway, no updates yet, Mission Control.")
	emote_see = list("squeaks", "flicks their tail", "looks around")

	say_understood = list("Order received.", "Understood, Mission Control.")
	say_cannot = list("Unable to fulfill that request.", "Sorry... Running into some issues.")
	say_maybe_target = list("Hey... You can't hide after causing us trouble, mate...", "If you're hiding... You better be hiding well...", "Yeah... You better have left after causing us trouble...")
	say_got_target = list("Mouse found!", "Hostile being culled!", "Removing unwanted salvage!", "Culling threats!", "Suppressing!")
	say_threaten = list("This area is marked for salvage by the Hegemony, please vacate the area until we're done!", "Sorry, but we're conducting operations here and civilians are not permitted around here for the time being!", "Please disperse from the area, or we will have to respond in kind.")
	say_stand_down = list("Thank you for listening! Please have a safe day!", "Carry along, and keep safe.", "You're cleared to depart, thank you for not causing problems.")
	say_escalate = list("Team, we have mice attempting to steal our salvage!", "We've warned you! Please know this is just us following orders!", "Apologies, but we have to attack due to failing to listen to our order!")

	threaten_sound = 'sound/weapons/TargetOn.ogg'
	stand_down_sound = 'sound/weapons/TargetOff.ogg'

/mob/living/simple_mob/humanoid/merc/altevian/sapper
	desc = "An Altevian Naval Sapper, adorned in the top of the line Heartbreaker suit. Armed with a giant fokken wrench."
	icon_state = "merc_melee_wrench"
	icon_living = "merc_melee_wrench"

	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_armor_pen = 0
	attack_sharp = FALSE
	attack_edge = 0
	attacktext = list("whacked", "slammed", "bashed", "clonked", "bonked")
	attack_sound = 'sound/weapons/smash.ogg'

	loot_list = list(/obj/item/weapon/tool/transforming/altevian = 100)

/mob/living/simple_mob/humanoid/merc/altevian/ranged
	desc = "An Altevian Naval Salvage Guard, adorned in the top of the line Heartbreaker suit. Armed with a small energy gun."
	icon_state = "merc_gun_smol"
	icon_living = "merc_gun_smol"


	melee_damage_lower = 15		// Let's just pretend they have tacknife
	melee_damage_upper = 15
	attack_armor_pen = 20
	base_attack_cooldown = 8

	loot_list = list(/obj/item/weapon/gun/energy/altevian = 100)

	needs_reload = TRUE
	reload_time = 1.5 SECONDS
	reload_max = 6
	projectiletype = /obj/item/projectile/beam/meeplaser
	projectilesound = 'sound/weapons/Laser.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged

/mob/living/simple_mob/humanoid/merc/altevian/ranged/strong
	desc = "An Altevian Naval Salvage Shield, adorned in the top of the line Heartbreaker suit. Armed with a large energy gun."
	icon_state = "merc_gun_big"
	icon_living = "merc_gun_big"

	base_attack_cooldown = 8

	loot_list = list(/obj/item/weapon/gun/energy/altevian/large = 100)

	needs_reload = TRUE
	reload_time = 3 SECONDS
	reload_max = 12
	projectiletype = /obj/item/projectile/beam/meeplaser/strong
	projectilesound = 'sound/weapons/Laser.ogg'

/mob/living/simple_mob/humanoid/merc/altevian/ranged/ballistic
	desc = "An Altevian Naval Shipbreaker, adorned in the top of the line Heartbreaker suit. Armed with a bolter gun."
	icon_state = "merc_gun_ballistic"
	icon_living = "merc_gun_ballistic"

	base_attack_cooldown = 10

	loot_list = list(/obj/item/weapon/storage/box/altevian_ammo = 100, /obj/item/weapon/gun/projectile/altevian = 100)

	needs_reload = TRUE
	reload_time = 5 SECONDS
	reload_max = 5
	projectiletype = /obj/item/projectile/bullet/sam48
	projectilesound = 'sound/weapons/Gunshot_heavy.ogg'

/mob/living/simple_mob/humanoid/merc/altevian/neutral
	faction = "neutral"

/mob/living/simple_mob/humanoid/merc/altevian/sapper/neutral
	faction = "neutral"

/mob/living/simple_mob/humanoid/merc/altevian/ranged/neutral
	faction = "neutral"

/mob/living/simple_mob/humanoid/merc/altevian/ranged/strong/neutral
	faction = "neutral"

/mob/living/simple_mob/humanoid/merc/altevian/ranged/ballistic/neutral
	faction = "neutral"
