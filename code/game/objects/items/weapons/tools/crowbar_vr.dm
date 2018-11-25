/*
 * Prybar
 */

/obj/item/weapon/tool/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge. It comes in a variety of configurations - collect them all."
	icon = 'icons/obj/tools_vr.dmi'
	icon_state = "prybar"
	item_state = "crowbar"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 4
	throwforce = 6
	pry = 1
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 30)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	usesound = 'sound/items/crowbar.ogg'
	toolspeed = 1
	var/random_color = TRUE

/obj/item/weapon/tool/prybar/red
	icon_state = "prybar_red"
	item_state = "crowbar_red"
	random_color = FALSE

/obj/item/weapon/tool/prybar/New()
	if(random_color)
		icon_state = "prybar[pick("","_green","_aubergine","_blue")]"
	. = ..()
