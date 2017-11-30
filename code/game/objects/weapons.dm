/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"
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
/obj/item/weapon/proc/cleave(var/mob/living/user, var/mob/living/target)
	if(cleaving)
		return // We're busy.
	cleaving = TRUE
	var/hit_mobs = 0
	for(var/mob/living/simple_animal/SA in orange(get_turf(target), 1))
		if(SA.stat == DEAD) // Don't beat a dead horse.
			continue
		if(SA == user) // Don't hit ourselves.  Simple mobs shouldn't be able to do this but that might change later to be able to hit all mob/living-s.
			continue
		if(SA == target) // We (presumably) already hit the target before cleave() was called.  orange() should prevent this but just to be safe...
			continue
		if(user.faction == SA.faction) // Avoid friendly fire.
			continue
		if(!SA.Adjacent(user) || !SA.Adjacent(target)) // Cleaving only hits mobs near the target mob and user.
			continue
		if(resolve_attackby(SA, user)) // Hit them with the weapon.  This won't cause recursive cleaving due to the cleaving variable being set to true.
			hit_mobs++

	if(hit_mobs)
		to_chat(user, "<span class='danger'>You used \the [src] to attack [hit_mobs] other thing\s!</span>")
	cleaving = FALSE // We're done now.