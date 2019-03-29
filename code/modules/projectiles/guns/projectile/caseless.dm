/obj/item/weapon/gun/projectile/caseless/prototype
	name = "prototype caseless rifle"
	desc = "A rifle cooked up in NanoTrasen's R&D labs that operates with Kraut Space Magic™ clockwork internals. Uses solid phoron 5mm caseless rounds."
	icon_state = "caseless"
	item_state = "caseless"
	w_class = ITEMSIZE_LARGE
	caliber = "5mm caseless"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = null // R&D builds this. Starts unloaded.
	allowed_magazines = list(/obj/item/ammo_magazine/m5mmcaseless)

/obj/item/weapon/gun/projectile/caseless/prototype/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/weapon/gun/projectile/caseless/prototype/loaded
	magazine_type = /obj/item/ammo_magazine/m5mmcaseless