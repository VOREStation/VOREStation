/datum/category_item/catalogue/fauna/stardog
	name = "Alien Wildlife - Star Dog"
	desc = "I appears to be a canine of some sort, though absolutely massive in scale and surrounded in radical redspace energies!"
	value = CATALOGUER_REWARD_SUPERHARD

/mob/living/simple_mob/vore/overmap/stardog
	name = "dog"
	desc = "It is a relatively ordinary looking canine mutt! It radiates mischief and otherworldly energy..."
	tt_desc = "E Canis lupus stellarus"

	scanner_desc = "I appears to be a canine of some sort, though absolutely massive in scale and surrounded in radical redspace energies!"
	catalogue_data = list(/datum/category_item/catalogue/fauna/stardog)

	icon = 'icons/mob/vore.dmi'
	icon_state = "woof"
	icon_living = "woof"
	icon_dead = "woof_dead"
	icon_rest = "woof_rest"

	om_child_type = /obj/effect/overmap/visitable/ship/simplemob/stardog

	response_help = "pets"
	response_disarm = "rudely paps"
	response_harm = "punches"

	attacktext = list("nipped", "chomped", "bullied", "gnaws on")
	attack_sound = 'sound/voice/bork.ogg'
	friendly = list("snoofs", "nuzzles", "ruffs happily at", "smooshes on")

	ai_holder_type = /datum/ai_holder/simple_mob/woof/stardog

	has_langs = list(LANGUAGE_ANIMAL, LANGUAGE_CANILUNZT, LANGUAGE_GALCOM)
	say_list_type = /datum/say_list/softdog
	swallowTime = 0.1 SECONDS

	loot_list = list(/obj/random/underdark/uncertain)

	armor = list(
		"melee" = 1000,
		"bullet" = 1000,
		"laser" = 1000,
		"energy" = 1000,
		"bomb" = 1000,
		"bio" = 1000,
		"rad" = 1000)

	armor_soak = list(
		"melee" = 1000,
		"bullet" = 1000,
		"laser" = 1000,
		"energy" = 1000,
		"bomb" = 1000,
		"bio" = 1000,
		"rad" = 1000
		)

	movement_cooldown = 0

/mob/living/simple_mob/vore/overmap/stardog/Life()
	. = ..()

	if(istype(loc, /turf/unsimulated/map))
		if(!invisibility)
			invisibility = INVISIBILITY_ABSTRACT
			child_om_marker.invisibility = 0
			ai_holder.base_wander_delay = 50
			ai_holder.wander_delay = 1
			melee_damage_lower = 50
			melee_damage_upper = 100
			mob_size = MOB_HUGE
			child_om_marker.set_light(5, 1, "#ff8df5")

	else if(invisibility)
		invisibility = 0
		child_om_marker.invisibility = INVISIBILITY_ABSTRACT
		ai_holder.base_wander_delay = 5
		ai_holder.wander_delay = 1
		melee_damage_lower = 1
		melee_damage_upper = 5
		mob_size = MOB_SMALL
		child_om_marker.set_light(0)

/mob/living/simple_mob/vore/overmap/stardog/Initialize()
	. = ..()
	child_om_marker.set_light(5, 1, "#ff8df5")

/obj/effect/overmap/visitable/ship/simplemob/stardog
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "space_dog"
	skybox_pixel_x = 0
	skybox_pixel_y = 0
	glide_size = 6
	parent_mob_type = /mob/living/simple_mob/vore/overmap/stardog
	scanner_desc = "CONFIGURE ME"

/datum/ai_holder/simple_mob/woof/stardog
	hostile = FALSE
	cooperative = TRUE
	retaliate = TRUE
	speak_chance = 1
	wander = TRUE
	wander_delay = 1
	base_wander_delay = 50
