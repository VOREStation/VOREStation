/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"
	var/can_cleave = FALSE // If true, a 'cleaving' attack will occur.
	var/cleaving = FALSE // Used to avoid infinite cleaving.

/obj/item/weapon/Bump(mob/M as mob)
	spawn(0)
		..()
	return

/obj/item/weapon/melee
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
			)

// Attacks mobs (atm only simple ones due to friendly fire issues) that are adjacent to the target and user.
/obj/item/weapon/proc/cleave(mob/living/user, atom/target)
	if(cleaving)
		return FALSE // We're busy.
	if(!target.Adjacent(user))
		return FALSE // Too far.
	if(get_turf(user) == get_turf(target))
		return FALSE // Otherwise we would hit all eight surrounding tiles.

	cleaving = TRUE
	var/hit_mobs = 0
	for(var/mob/living/simple_animal/SA in range(get_turf(target), 1))
		if(SA.stat == DEAD) // Don't beat a dead horse.
			continue
		if(SA == user) // Don't hit ourselves.  Simple mobs shouldn't be able to do this but that might change later to be able to hit all mob/living-s.
			continue
		if(SA == target) // We (presumably) already hit the target before cleave() was called.  orange() should prevent this but just to be safe...
			continue
		if(!SA.Adjacent(user) || !SA.Adjacent(target)) // Cleaving only hits mobs near the target mob and user.
			continue
		if(resolve_attackby(SA, user, attack_modifier = 0.5)) // Hit them with the weapon.  This won't cause recursive cleaving due to the cleaving variable being set to true.
			hit_mobs++

	cleave_visual(user, target)

	if(hit_mobs)
		to_chat(user, "<span class='danger'>You used \the [src] to attack [hit_mobs] other thing\s!</span>")
	cleaving = FALSE // We're done now.
	return hit_mobs > 0 // Returns TRUE if anything got hit.

// This cannot go into afterattack since some mobs delete themselves upon dying.
/obj/item/weapon/material/pre_attack(mob/living/target, mob/living/user)
	if(can_cleave && istype(target))
		cleave(user, target)
	..()

// This is purely the visual effect of cleaving.
/obj/item/weapon/proc/cleave_visual(var/mob/living/user, var/mob/living/target)
	var/obj/effect/temporary_effect/cleave_attack/E = new(get_turf(src))
	E.dir = get_dir(user, target)