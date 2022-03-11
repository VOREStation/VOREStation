/obj/item/weapon/magnetic_ammo
	name = "flechette magazine"
	desc = "A magazine containing steel flechettes."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "caseless-mag"
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 1800)
	origin_tech = list(TECH_COMBAT = 1)
	var/remaining = 9
	preserve_item = 1

/obj/item/weapon/magnetic_ammo/examine(mob/user)
	. = ..()
	. += "There [(remaining == 1)? "is" : "are"] [remaining] flechette\s left!"

/obj/item/weapon/magnetic_ammo/pistol
	name = "flechette magazine (small)"
	desc = "A magazine containing smaller steel flechettes, intended for a pistol."
	icon_state = "caseless-mag-short"

/obj/item/weapon/magnetic_ammo/pistol/khi
	name = "flechette magazine (small, khi)"
	desc = "A magazine containing smaller carbyne flechettes, intended for a pistol."
	icon_state = "caseless-mag-short-alt"
	remaining = 12