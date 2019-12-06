/obj/item/weapon/melee/energy/sword/imperial
	name = "energy gladius"
	desc = "A broad, short energy blade.  You'll be glad to have this in a fight."
	icon_state = "sword0"
	icon = 'icons/obj/weapons_vr.dmi'
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi')

/obj/item/weapon/melee/energy/sword/imperial/activate(mob/living/user)
	..()
	icon_state = "sword1"

/obj/item/weapon/melee/energy/sword/green/New()
	lcolor = "#008000"

/obj/item/weapon/melee/energy/sword/red/New()
	lcolor = "#FF0000"

/obj/item/weapon/melee/energy/sword/blue/New()
	lcolor = "#0000FF"

/obj/item/weapon/melee/energy/sword/purple/New()
	lcolor = "#800080"

/obj/item/weapon/melee/energy/sword/white/New()
	lcolor = "#FFFFFF"