/*
 * Prybar
 */

/obj/item/weapon/tool/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge, designed specifically for opening unpowered doors in an emergency. It comes in a variety of configurations - collect them all!"
	icon = 'icons/obj/tools_vr.dmi'
	icon_state = "prybar"
	item_state = "crowbar"
	force = 4
	throwforce = 1
	matter = list(DEFAULT_WALL_MATERIAL = 25)
	attack_verb = list("whapped", "smacked", "swatted", "thwacked", "hit")
	usesound = 'sound/items/crowbar.ogg'
	toolspeed = 1
	var/random_color = TRUE

// Todo: Prevent it from prying up floor boards. Only affect doors. I couldn't remember how to do this. -Ace
/*
/obj/item/weapon/tool/prybar/on_hit()
	if(istype(/obj/machinery/door/airlock))
		..()
	else if(istype(/mob)
		..()
	else
		// Tell the player that they can't use this on anything except airlocks.
		return
*/

/obj/item/weapon/tool/prybar/red
	icon_state = "prybar_red"
	item_state = "crowbar_red"
	random_color = FALSE

/obj/item/weapon/tool/prybar/New()
	if(random_color)
		icon_state = "prybar[pick("","_green","_aubergine","_blue")]"
	. = ..()
