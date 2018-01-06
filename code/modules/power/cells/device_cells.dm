//currently only used by energy-type guns, that may change in the future.
/obj/item/weapon/cell/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "dcell"
	item_state = "egg6"
	w_class = ITEMSIZE_SMALL
	force = 0
	throw_speed = 5
	throw_range = 7
	maxcharge = 480
	charge_amount = 5
	matter = list("metal" = 350, "glass" = 50)
	preserve_item = 1

/obj/item/weapon/cell/device/weapon
	name = "weapon power cell"
	desc = "A small power cell designed to power handheld weaponry."
	icon_state = "wcell"
	maxcharge = 2400
	charge_amount = 20

/obj/item/weapon/cell/device/weapon/empty/initialize()
	..()
	charge = 0
	update_icon()

/obj/item/weapon/cell/device/weapon/recharge
	name = "self-charging weapon power cell"
	desc = "A small power cell designed to power handheld weaponry. This one recharges itself."
//	icon_state = "wcell" //TODO: Different sprite
	self_recharge = TRUE
	charge_amount = 120
	charge_delay = 75

/obj/item/weapon/cell/device/weapon/recharge/captain
	charge_amount = 160	//Recharges a lot more quickly...
	charge_delay = 100	//... but it takes a while to get started

/obj/item/weapon/cell/device/weapon/recharge/alien
	name = "void cell"
	desc = "An alien technology that produces energy seemingly out of nowhere. Its small, cylinderal shape means it might be able to be used with human technology, perhaps?"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cell"
	charge_amount = 120 // 5%.
	charge_delay = 50 // Every five seconds, bit faster than the default.
	origin_tech = list(TECH_POWER = 8, TECH_ENGINEERING = 6)

/obj/item/weapon/cell/device/weapon/recharge/alien/update_icon()
	return // No overlays please.