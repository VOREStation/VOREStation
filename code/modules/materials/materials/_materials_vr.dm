/obj/item/stack/material/attack(mob/living/M, mob/living/user, target_zone, attack_modifier)
	if(M.handle_eat_minerals(src, user))
		return ITEM_INTERACT_SUCCESS
	..()

/obj/item/stack/material/attack_generic(mob/living/user) //Allow adminbussed mobs to eat ore if they click it while NOT on help intent.
	if(user.handle_eat_minerals(src))
		return ITEM_INTERACT_SUCCESS
	..()
