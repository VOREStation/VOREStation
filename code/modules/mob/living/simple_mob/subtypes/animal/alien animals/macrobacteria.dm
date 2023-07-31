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

	mob_bump_flag = HEAVY
	mob_swap_flags = HEAVY
	mob_push_flags = HEAVY
	mob_size = MOB_LARGE


	attacktext = list("flashes", "slaps", "smothers", "grapples")
	attack_sound = 'sound/effects/attackblob.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/say_aggro

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

/mob/living/simple_mob/vore/vore_hostile
	name = "peeb"
	desc = "REPLACE ME"
	ai_holder_type = /datum/ai_holder/simple_mob/vore

/datum/ai_holder/simple_mob/vore
	hostile = FALSE
	retaliate = TRUE
	vore_hostile = TRUE
	forgive_resting = TRUE

/datum/ai_holder/simple_mob/vore/micro_hunter
	micro_hunt = TRUE
	micro_hunt_size = 0.8

/datum/ai_holder/simple_mob/vore/hostile
	hostile = TRUE

/datum/ai_holder/simple_mob/vore/find_target(list/possible_targets, has_targets_list)
	if(!vore_hostile)
		return ..()
	ai_log("find_target() : Entered.", AI_LOG_TRACE)

	. = list()
	if(!has_targets_list)
		possible_targets = list_targets()
	var/list/valid_mobs = list()
	for(var/mob/living/possible_target in possible_targets)
		if(!can_attack(possible_target))
			continue
		. |= possible_target
		if(!isliving(possible_target))
			continue
		if(vore_check(possible_target))
			valid_mobs |= possible_target

	var/new_target
	if(valid_mobs.len)
		new_target = pick(valid_mobs)
	else if(hostile)
		new_target = pick(.)
	if(!new_target)
		return null
	give_target(new_target)
	return new_target

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
