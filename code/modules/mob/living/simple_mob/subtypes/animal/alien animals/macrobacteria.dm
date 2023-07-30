/datum/category_item/catalogue/fauna/abyss_lurker
	name = "Alien Wildlife - Teppi"
	desc = "Teppi are large omnivorous quadrupeds with long fur.\
	Unlike many horned mammals, Teppi have developed paws with four toes rather than hooves.\
	This coupled with a thick, powerful tail makes them quite capable and balanced on many\
	kinds of terrain. A recently discovered species, their origins are something of a\
	mystery, but they have been discovered in more different regions of space with no apparent\
	connection to one another. Teppi are known to reproduce and grow rather quickly, which if\
	left unchecked can lead to serious problems for local ecology.\
	Teppi are very hardy, engaging them in combat is not recommended.\
	Teppi can be a good source of protein and materials for crafts and clothing in emergency\
	situations. They are not especially picky eaters, and have a rather mild temperament.\
	A pair of well fed Teppi can rather quickly become a small horde, so it is generally\
	advised to keep an eye on their numbers."
	value = CATALOGUER_REWARD_MEDIUM


/mob/living/simple_mob/vore/alienanimals/abyss_lurker
	name = "abyss lurker"
	desc = "A pale mass of heaving flesh that gropes around in the gloom. It doesn't appear to have any eyes."
	icon = 'icons/mob/alienanimals_x64.dmi'
	icon_state = "abyss_lurker"
	icon_living = "abyss_lurker"
	icon_dead = "abyss_lurker-dead"
	icon_rest = "abyss_lurker"

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


	attacktext = list("flashes", "slaps", "smothers", "grapples")
	attack_sound = 'sound/effects/attackblob.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/say_hostile

	mob_size = MOB_LARGE

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

/mob/living/simple_mob/vore/alienanimals/abyss_lurker/init_vore()
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

/datum/ai_holder/simple_mob/say_hostile
	hostile = FALSE
	retaliate = TRUE

/datum/ai_holder/simple_mob/say_hostile/on_hear_say(mob/living/speaker, message)
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
