//
//	This file overrides settings on upstream simple animals to turn on vore behavior
//

/**
 * ## For anything that previously inhertited from: /mob/living/simple_mob/hostile/vore ##
 *
 *	vore_active = 1
 *	icon = 'icons/mob/vore.dmi'
 *
 * ## For anything that previously inhertied from: /mob/living/simple_mob/hostile/vore/large ##
 *
 *	vore_active = 1
 *	icon = 'icons/mob/vore64x64.dmi'
 *	old_x = -16
 *	old_y = -16
 *	pixel_x = -16
 *	pixel_y = -16
 *	vore_pounce_chance = 50
 */

//
// Okay! Here we go!
//

/mob/living/simple_mob/animal/space/alien
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenohunter"
	icon_living = "xenohunter"
	icon_dead = "xenohunter-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

/mob/living/simple_mob/animal/space/alien/drone
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenodrone"
	icon_living = "xenodrone"
	icon_dead = "xenodrone-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/alien/sentinel
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenosentinel"
	icon_living = "xenosentinel"
	icon_dead = "xenosentinel-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/alien/queen
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenoqueen"
	icon_living = "xenoqueen"
	icon_dead = "xenoqueen-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/alien/queen/empress
	vore_active = 1
	icon = 'icons/mob/vore64x64.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	vis_height = 64

	vore_capacity = 3
	vore_pounce_chance = 75

/mob/living/simple_mob/animal/space/alien/sentinel/praetorian
	icon = 'icons/mob/vore64x64.dmi'
	vis_height = 64
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_mob/animal/space/alien/queen/empress/mother
	vore_icons = 0 // NO VORE SPRITES

/mob/living/simple_mob/animal/space/bear
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "spacebear"
	icon_living = "spacebear"
	icon_dead = "spacebear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

/mob/living/simple_mob/animal/space/bear/hudson
	name = "Hudson"

/mob/living/simple_mob/animal/space/bear/brown
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	name = "brown bear"
	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/bear/brown/beastmode
	movement_cooldown = 2

	melee_damage_lower = 5
	melee_damage_upper = 15
	attack_armor_pen = 0

/* //VOREStation AI Temporary removal
/mob/living/simple_mob/hostile/creature/vore
	vore_active = 1
	// NO VORE SPRITES
	vore_capacity = 0
	vore_pounce_chance = 0	// Only pounces if you're crit.
	vore_escape_chance = 0	// As such, if you're a dibshit who feeds yourself to it, you're staying down.
	// Overrides to non-vore version
	speed = 4			// Slow it down a bit
	health = 80			// Increase health to compensate
	maxHealth = 80
*/
/*
/mob/living/simple_mob/animal/space/mimic
	vore_active = 1
	// NO VORE SPRITES
	vore_capacity = 0
	vore_pounce_chance = 33
	// Overrides to non-vore version
	maxHealth = 60
	health = 60
*/
/mob/living/simple_mob/animal/passive/cat
	vore_active = 1
	// NO VORE SPRITES
	//specific_targets = 0 // Targeting UNLOCKED //VOREStation Removal - Incompatable
	vore_max_size = RESIZE_TINY

/* //VOREStation AI Temporary removal
/mob/living/simple_mob/animal/passive/cat/PunchTarget()
	if(istype(target_mob,/mob/living/simple_mob/animal/passive/mouse))
		visible_message(span_warning("\The [src] pounces on \the [target_mob]!]"))
		target_mob.Stun(5)
		return EatTarget()
	else ..()

/mob/living/simple_mob/animal/passive/cat/Found(var/atom/found_atom)
	if(!SA_attackable(found_atom))
		return null
	if(istype(found_atom,/mob/living/simple_mob/animal/passive/mouse))
		return found_atom
	if(found_atom in friends)
		return null
	if(will_eat(found_atom))
		return found_atom

/mob/living/simple_mob/animal/passive/cat/fluff/Found(var/atom/found_atom)
	if (friend == found_atom)
		return null
	return ..()
*/
/mob/living/simple_mob/animal/passive/cat/fluff
	vore_ignores_undigestable = 0
	vore_pounce_chance = 100
	vore_digest_chance = 0 // just use the toggle
	vore_default_mode = DM_HOLD //can use the toggle if you wanna be catfood
	vore_standing_too = TRUE //gonna get pounced

/* //VOREStation AI Temporary Removal
/mob/living/simple_mob/animal/passive/cat/fluff/EatTarget()
	var/mob/living/TM = target_mob
	LAZYSET(prey_excludes, TM, world.time) //so they won't immediately re-eat someone who struggles out (or gets newspapered out) as soon as they're ate
	spawn(3600) // but if they hang around and get comfortable, they might get ate again
		if(src && TM)
			LAZYREMOVE(prey_excludes, TM)
	..() // will_eat check is carried out before EatTarget is called, so prey on the prey_excludes list isn't a problem.
*/

/mob/living/simple_mob/animal/passive/fox
	vore_active = 1
	// NO VORE SPRITES
	vore_max_size = RESIZE_TINY

/mob/living/simple_mob/animal/passive/fox/renault
	vore_ignores_undigestable = 0
	vore_pounce_chance = 100
	vore_digest_chance = 0 // just use the toggle
	vore_default_mode = DM_HOLD //can use the toggle if you wanna be foxfood
	vore_standing_too = TRUE // gonna get pounced

/mob/living/simple_mob/animal/space/goose
	vore_active = 1
	// NO VORE SPRITES
	vore_max_size = RESIZE_SMALL
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

/mob/living/simple_mob/animal/passive/penguin
	vore_active = 1
	// NO VORE SPRITES
	vore_max_size = RESIZE_SMALL
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

/mob/living/simple_mob/animal/space/carp/holographic
	vore_icons = 0 // NO VORE SPRITES
	vore_digest_chance = 0
	vore_absorb_chance = 0

// Override stuff for holodeck carp to make them not digest when set to safe!
/mob/living/simple_mob/animal/space/carp/holographic/init_vore()
	if(!voremob_loaded)
		return
	if(LAZYLEN(vore_organs))
		return
	. = ..()
	var/safe = (faction == FACTION_NEUTRAL)
	for(var/obj/belly/B as anything in vore_organs)
		B.digest_mode = safe ? DM_HOLD : vore_default_mode

/mob/living/simple_mob/animal/space/carp/holographic/set_safety(var/safe)
	. = ..()
	for(var/obj/belly/B as anything in vore_organs)
		B.digest_mode = safe ? DM_HOLD : vore_default_mode

/mob/living/simple_mob/animal/passive/mouse
	faction = FACTION_MOUSE //Giving mice a faction so certain mobs can get along with them.
