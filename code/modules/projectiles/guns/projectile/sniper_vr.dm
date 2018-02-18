////////////// Dragunov Sniper Rifle //////////////

/obj/item/weapon/gun/projectile/SVD
	name = "\improper Dragunov"
	desc = "The SVD, also known as the Dragunov, was mass produced with an Optical Sniper Sight so simple that even Ivan can figure out how it works. Too bad for you that it's written in Russian. Uses 7.62mm rounds."
	icon_state = "SVD"
	item_state = "SVD"
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	force = 10
	slot_flags = SLOT_BACK // Needs a sprite.
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	recoil = 2 //extra kickback
	caliber = "a762"
	load_method = MAGAZINE
	accuracy = -45 //shooting at the hip
	scoped_accuracy = 0
	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	fire_sound = 'sound/weapons/SVD_shot.ogg'
	magazine_type = /obj/item/ammo_magazine/m762
	allowed_magazines = list(/obj/item/ammo_magazine/m762)

/obj/item/weapon/gun/projectile/SVD/update_icon()
	..()
//	if(istype(ammo_magazine,/obj/item/ammo_magazine/m762)
//		icon_state = "SVD-bigmag" //No icon for this exists yet.
	if(ammo_magazine)
		icon_state = "SVD"
	else
		icon_state = "SVD-empty"

/obj/item/weapon/gun/projectile/SVD/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)