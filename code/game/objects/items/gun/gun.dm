//Every shared function that EVERY SINGLE GUN HAS. Consider this a universal bible and you'd better know what you're doing if you're editing this.
//The core
/obj/item/gun_new //gun_new is temporary, upon the guttening, replace with /gun
	name = "gun"
	desc = "Its a gun, it go pew."
	icon = 'icons/obj/gun.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi',
		)
	icon_state = "detective"
	item_state = "gun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(MAT_STEEL = 2000)
	w_class = ITEMSIZE_NORMAL
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	preserve_item = 1
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'
