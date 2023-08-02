/atom/proc/random_color()
	var/r = rand(1,255)
	var/g = rand(1,255)
	var/b = rand(1,255)

	if(r + g + b < 50)	//Let's make sure we don't get too close to pure black or pure white, as they won't look good with grayscale sprites
		r = r + rand(5,20)
		g = g + rand(5,20)
		b = b + rand(5,20)
	else if (r + g + b > 700)
		r = r - rand(5,50)
		g = g - rand(5,50)
		b = b - rand(5,50)

	var/color = rgb(r, g, b)
	return color

//Mobs who's primary purpose is to go eat people who have their vore prefs turned on. They're retaliate mobs to everyone else.
/mob/living/simple_mob/vore/vore_hostile
	name = "peeb"
	desc = "REPLACE ME"
	ai_holder_type = /datum/ai_holder/simple_mob/vore

/////ABYSS LURKER/////

/datum/category_item/catalogue/fauna/abyss_lurker
	name = "Alien Wildlife - Abyss Lurker"
	desc = "REPLACE ME"
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/vore_hostile/abyss_lurker
	name = "abyss lurker"
	desc = "A pale mass of heaving flesh that gropes around in the gloom. It doesn't appear to have any eyes."
	icon = 'icons/mob/alienanimals_x64.dmi'
	icon_state = "abyss_lurker"
	icon_living = "abyss_lurker"
	icon_dead = "abyss_lurker-dead"
	icon_rest = "abyss_lurker"
	vore_icons = 0

	faction = "macrobacteria"
	maxHealth = 600
	health = 600
	movement_cooldown = 3
	meat_amount = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	catalogue_data = list(/datum/category_item/catalogue/fauna/abyss_lurker)

	see_in_dark = 8

	pixel_x = -16
	default_pixel_x = -16

	mob_size = MOB_LARGE
	mob_bump_flag = HEAVY
	mob_swap_flags = HEAVY
	mob_push_flags = HEAVY
	mob_size = MOB_LARGE

	attacktext = list("flashes", "slaps", "smothers", "grapples")
	attack_sound = 'sound/effects/attackblob.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/say_aggro

	swallowTime = 2 SECONDS
	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 50
	vore_bump_emote	= "begins to absorb"
	vore_ignores_undigestable = 0
	vore_default_mode = DM_SELECT
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_default_item_mode = IM_DIGEST
	vore_pounce_chance = 50
	vore_pounce_cooldown = 10
	vore_pounce_successrate	= 75
	vore_pounce_falloff = 0
	vore_pounce_maxhealth = 100
	vore_standing_too = TRUE

/mob/living/simple_mob/vore/vore_hostile/abyss_lurker/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "interior"
	B.desc = "soft"
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_NUMBING
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 25

/mob/living/simple_mob/vore/vore_hostile/abyss_lurker/attack_hand(mob/living/user)

	if(client || !user.client || !ai_holder || !isliving(user))
		return ..()
	if(!user.devourable || !user.allowmobvore || !user.can_be_drop_prey)
		return ..()
	ai_holder.give_target(user, TRUE)
	ai_holder.track_target_position()
	ai_holder.set_stance(STANCE_FIGHT)

/datum/ai_holder/simple_mob/say_aggro
	hostile = FALSE
	forgive_resting = TRUE

/datum/ai_holder/simple_mob/say_aggro/on_hear_say(mob/living/speaker, message)
	. = ..()
	if(holder.client || !speaker.client)
		return
	if(!speaker.devourable || !speaker.allowmobvore || !speaker.can_be_drop_prey)
		return
	if(speaker.z != holder.z)
		return
	give_target(speaker, TRUE)
	track_target_position()
	set_stance(STANCE_FIGHT)

/////Gelatinous Cube/////
/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube
	name = "gelatinous cube"
	desc = "cyoob"
	icon = 'icons/mob/alienanimals_x64.dmi'
	icon_state = "cube"
	icon_living = "cube"
	icon_dead = "abyss_lurker-dead"
	icon_rest = "cube"
	vore_icons = 0

	faction = "macrobacteria"
	maxHealth = 500
	health = 500

	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 1

	movement_cooldown = 50
	meat_amount = 0
	meat_type = null
	catalogue_data = list(/datum/category_item/catalogue/fauna/abyss_lurker)

	see_in_dark = 8

	pixel_x = -16
	default_pixel_x = -16

	mob_size = MOB_LARGE
	mob_bump_flag = HUMAN
	mob_swap_flags = HEAVY
	mob_push_flags = HEAVY
	mob_size = MOB_LARGE

	attacktext = list("flashes", "slaps", "smothers", "grapples")
	attack_sound = 'sound/effects/attackblob.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/vore

	swallowTime = 0 SECONDS
	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 100
	vore_bump_emote	= "begins to absorb"
	vore_ignores_undigestable = 0
	vore_default_mode = DM_SELECT
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_default_item_mode = IM_DIGEST
	vore_pounce_chance = 50
	vore_pounce_cooldown = 10
	vore_pounce_successrate	= 75
	vore_pounce_falloff = 0
	vore_pounce_maxhealth = 100
	vore_standing_too = TRUE

/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "interior"
	B.desc = "wobl"
	B.mode_flags = DM_FLAG_NUMBING
	B.belly_fullscreen = "yet_another_tumby"
	B.colorization_enabled = TRUE
	B.belly_fullscreen_color = color
	B.digest_brute = 2
	B.digest_burn = 10
	B.digest_oxy = 12
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 10
	B.escapetime = 60 SECONDS
	B.selective_preference = DM_DIGEST

/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube/Initialize()
	. = ..()
	color = random_color()

/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube/death()
	. = ..()

	qdel(src)
