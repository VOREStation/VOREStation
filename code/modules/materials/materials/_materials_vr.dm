/obj/item/stack/material/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(M.handle_eat_minerals(src, user))
		return
	..()

/obj/item/stack/material/attack_generic(var/mob/living/user) //Allow adminbussed mobs to eat ore if they click it while NOT on help intent.
	if(user.handle_eat_minerals(src))
		return
	..()
