//
//	This file overrides settings on upstream simple animals to turn on vore behavior
//

/*
## For anything that previously inhertited from: /mob/living/simple_animal/hostile/vore ##

  	vore_active = 1
  	icon = 'icons/mob/vore.dmi'

## For anything that previously inhertied from: /mob/living/simple_animal/hostile/vore/large ##

	vore_active = 1
	icon = 'icons/mob/vore64x64.dmi'
	old_x = -16
	old_y = -16
	pixel_x = -16
	pixel_y = -16
	vore_pounce_chance = 50
*/

//
// Okay! Here we go!
//

/mob/living/simple_animal/hostile/alien
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenohunter"
	icon_living = "xenohunter"
	icon_dead = "xenohunter-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/hostile/alien/drone
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenodrone"
	icon_living = "xenodrone"
	icon_dead = "xenodrone-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/hostile/alien/sentinel
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenosentinel"
	icon_living = "xenosentinel"
	icon_dead = "xenosentinel-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/hostile/alien/queen
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenoqueen"
	icon_living = "xenoqueen"
	icon_dead = "xenoqueen-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/hostile/alien/queen/empress
	vore_active = 1
	icon = 'icons/mob/vore64x64.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	vore_icons = SA_ICON_LIVING
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	vore_capacity = 3
	vore_pounce_chance = 75

/mob/living/simple_animal/hostile/alien/sentinel/praetorian
	icon = 'icons/mob/vore64x64.dmi'

/mob/living/simple_animal/hostile/alien/queen/empress/mother
	vore_icons = 0 // NO VORE SPRITES

/mob/living/simple_animal/hostile/bear
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "spacebear"
	icon_living = "spacebear"
	icon_dead = "spacebear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/hostile/bear/hudson
	name = "Hudson"

/mob/living/simple_animal/hostile/bear/brown
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	name = "brown bear"
	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/hostile/carp
	icon = 'icons/mob/vore.dmi'
	vore_active = 1
	vore_icons = SA_ICON_LIVING

/mob/living/simple_animal/hostile/creature/vore
	vore_active = 1
	// NO VORE SPRITES
	vore_capacity = 0
	vore_pounce_chance = 0	// Only pounces if you're crit.
	vore_escape_chance = 0	// As such, if you're a dibshit who feeds yourself to it, you're staying down.
	// Overrides to non-vore version
	speed = 4			// Slow it down a bit
	health = 80			// Increase health to compensate
	maxHealth = 80

/mob/living/simple_animal/hostile/mimic
	vore_active = 1
	// NO VORE SPRITES
	vore_capacity = 0
	vore_pounce_chance = 33
	// Overrides to non-vore version
	maxHealth = 60
	health = 60

/mob/living/simple_animal/cat
	vore_active = 1
	// NO VORE SPRITES
	specific_targets = 0 // Targeting UNLOCKED
	vore_max_size = RESIZE_TINY

/mob/living/simple_animal/cat/PunchTarget()
	if(istype(target_mob,/mob/living/simple_animal/mouse))
		visible_message("<span class='warning'>\The [src] pounces on \the [target_mob]!]</span>")
		target_mob.Stun(5)
		return EatTarget()
	else ..()

/mob/living/simple_animal/cat/Found(var/atom/found_atom)
	if(!SA_attackable(found_atom))
		return null
	if(istype(found_atom,/mob/living/simple_animal/mouse))
		return found_atom
	if(found_atom in friends)
		return null
	if(will_eat(found_atom))
		return found_atom

/mob/living/simple_animal/cat/fluff/Found(var/atom/found_atom)
	if (friend == found_atom)
		return null
	return ..()

/mob/living/simple_animal/cat/fluff
	vore_ignores_undigestable = 0
	vore_pounce_chance = 100
	vore_digest_chance = 0 // just use the toggle
	vore_default_mode = DM_HOLD //can use the toggle if you wanna be catfood

/mob/living/simple_animal/cat/fluff/EatTarget()
	var/mob/living/TM = target_mob
	prey_excludes += TM //so they won't immediately re-eat someone who struggles out (or gets newspapered out) as soon as they're ate
	spawn(3600) // but if they hang around and get comfortable, they might get ate again
		if(src && TM)
			prey_excludes -= TM
	..() // will_eat check is carried out before EatTarget is called, so prey on the prey_excludes list isn't a problem.

/mob/living/simple_animal/fox
	vore_active = 1
	// NO VORE SPRITES
	vore_max_size = RESIZE_TINY

/mob/living/simple_animal/fox/PunchTarget()
	if(istype(target_mob,/mob/living/simple_animal/mouse))
		return EatTarget()
	else ..()

/mob/living/simple_animal/fox/Found(var/atom/found_atom)
	if(!SA_attackable(found_atom))
		return null
	if(istype(found_atom,/mob/living/simple_animal/mouse))
		return found_atom
	if(found_atom in friends)
		return null
	if(will_eat(found_atom))
		return found_atom

/mob/living/simple_animal/fox/fluff/Found(var/atom/found_atom)
	if (friend == found_atom)
		return null
	return ..()

/mob/living/simple_animal/fox/fluff
	vore_ignores_undigestable = 0
	vore_pounce_chance = 100
	vore_digest_chance = 0 // just use the toggle
	vore_default_mode = DM_HOLD //can use the toggle if you wanna be foxfood

/mob/living/simple_animal/fox/fluff/EatTarget()
	var/mob/living/TM = target_mob
	prey_excludes += TM //so they won't immediately re-eat someone who struggles out (or gets newspapered out) as soon as they're ate
	spawn(3600) // but if they hang around and get comfortable, they might get ate again
		if(src && TM)
			prey_excludes -= TM
	..() // will_eat check is carried out before EatTarget is called, so prey on the prey_excludes list isn't a problem.

/mob/living/simple_animal/hostile/goose
	vore_active = 1
	// NO VORE SPRITES
	vore_max_size = RESIZE_SMALL

/mob/living/simple_animal/penguin
	vore_active = 1
	// NO VORE SPRITES
	vore_max_size = RESIZE_SMALL


/mob/living/simple_animal/hostile/carp/pike
	vore_active = 1
	// NO VORE SPRITES

/mob/living/simple_animal/hostile/carp/holodeck
	vore_icons = 0 // NO VORE SPRITES
// Override stuff for holodeck carp to make them not digest when set to safe!
/mob/living/simple_animal/hostile/carp/holodeck/set_safety(var/safe)
	. = ..()
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		B.digest_mode = safe ? DM_HOLD : vore_default_mode
		B.digestchance = safe ? 0 : vore_digest_chance
		B.absorbchance = safe ? 0 : vore_absorb_chance
