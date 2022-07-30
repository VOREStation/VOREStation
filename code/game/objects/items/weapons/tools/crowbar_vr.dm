/*
 * Prybar
 */

/obj/item/tool/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge, designed specifically for opening unpowered doors in an emergency. It comes in a variety of configurations - collect them all!"
	icon = 'icons/obj/tools_vr.dmi'
	icon_state = "prybar"
	item_state = "crowbar"
	slot_flags = SLOT_BELT
	force = 4
	throwforce = 5
	pry = 1
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MAT_STEEL = 30)
	attack_verb = list("whapped", "smacked", "swatted", "thwacked", "hit")
	usesound = 'sound/items/crowbar.ogg'
	toolspeed = 1
	var/random_color = TRUE

/obj/item/tool/prybar/red
	icon_state = "prybar_red"
	item_state = "crowbar_red"
	random_color = FALSE

/obj/item/tool/prybar/New()
	if(random_color)
		icon_state = "prybar[pick("","_green","_aubergine","_blue")]"
	. = ..()
