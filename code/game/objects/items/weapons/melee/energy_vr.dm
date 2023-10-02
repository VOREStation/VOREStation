/obj/item/weapon/melee/energy/sword/imperial
	name = "energy gladius"
	desc = "A broad, short energy blade.  You'll be glad to have this in a fight."
	icon_state = "impsword"
	icon = 'icons/obj/weapons_vr.dmi'
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi')
	colorable = FALSE
	lcolor = "#FFFFFF"

/obj/item/weapon/melee/energy/sword/altevian
	name = "plasma blade cutter"
	desc = "A device that's seen use as both a defense, and standard cutter to melt through most metals. It's normally seen on engineers from the Altevian Hegemony when salvaging derelicts."
	icon_state = "altevian-cutter"
	item_state = "altevian-cutter"
	icon = 'icons/obj/weapons_vr.dmi'
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi')
	colorable = FALSE
	lcolor = "#FFFFFF"

/obj/item/weapon/melee/energy/sword/altevian/update_icon()
	..()
	if(active)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)
