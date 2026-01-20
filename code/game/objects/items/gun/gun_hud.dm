/* TGMC Ammo HUD Port Begin */
/obj/item/gun_new
	var/hud_enabled = TRUE

/obj/item/gun_new/proc/has_ammo_counter()
	return FALSE

/obj/item/gun_new/proc/get_ammo_type()
	return FALSE

/obj/item/gun_new/proc/get_ammo_count()
	return FALSE

/obj/item/gun_new/equipped(mob/living/user, slot) // When a gun is equipped to your hands, we'll add the HUD to the user. Pending porting over TGMC guncode where wielding is far more sensible.
	if(slot == slot_l_hand || slot == slot_r_hand)
		user.hud_used.add_ammo_hud(user, src)
	else
		user.hud_used.remove_ammo_hud(user, src)

	return ..()

/obj/item/gun_new/dropped(mob/living/user) // Ditto as above, we remove the HUD. Pending porting TGMC code to clean up this fucking nightmare of spaghetti.
	user.hud_used.remove_ammo_hud(user, src)

	..()
