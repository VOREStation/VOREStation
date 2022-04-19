/*
 * Device
 */
/obj/item/weapon/cell/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "device_cell"
	item_state = "egg6"
	w_class = ITEMSIZE_SMALL
	force = 0
	throw_speed = 5
	throw_range = 7
	maxcharge = 480
	charge_amount = 5
	matter = list(MAT_STEEL = 350, MAT_GLASS = 50)
	preserve_item = 1

/obj/item/weapon/cell/device/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/*
 * Device Advanced
 */
/obj/item/weapon/cell/device/advanced
	name = "advanced device power cell"
	desc = "A small upgraded power cell designed to power handheld devices."
	icon_state = "high_device_cell"
	maxcharge = 2400
	charge_amount = 20
	origin_tech = list(TECH_POWER = 2)

/obj/item/weapon/cell/device/weapon/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/*
 * Device Super
 */
/obj/item/weapon/cell/device/super
	name = "super device power cell"
	desc = "A small upgraded power cell designed to power handheld devices."
	icon_state = "up_device_cell"
	maxcharge = 3600
	charge_amount = 20
	origin_tech = list(TECH_POWER = 3)

/obj/item/weapon/cell/device/super/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/*
 * Device Hyper
 */
/obj/item/weapon/cell/device/hyper
	name = "hyper device power cell"
	desc = "A small upgraded power cell designed to hold much more power for handheld devices."
	icon_state = "hype_device_cell"
	maxcharge = 4800
	charge_amount = 20
	origin_tech = list(TECH_POWER = 4)

/obj/item/weapon/cell/device/hyper/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/*
 * Device Infinite
 */
/obj/item/weapon/cell/infinite
	name = "infinite device power cell!"
	icon_state = "inf_device_cell"
	origin_tech =  null
	maxcharge = 6000 //determines how badly mobs get shocked

/obj/item/weapon/cell/infinite/check_charge()
	return 1

/obj/item/weapon/cell/infinite/use()
	return 1

/*
 * Weapon
 */
/obj/item/weapon/cell/device/weapon
	name = "weapon power cell"
	desc = "A small power cell designed to power handheld weaponry."
	icon_state = "weapon_cell"
	maxcharge = 2400
	charge_amount = 20

/obj/item/weapon/cell/device/weapon/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/*
 * EMP Proof Weapon
 */
/obj/item/weapon/cell/device/weapon/empproof
	name = "shielded weapon power cell"
	desc = "A small power cell designed to power handheld weaponry. This one is shielded from EMPs."
	icon_state = "emp_weapon_cell"
	matter = list(MAT_STEEL = 400, MAT_GLASS = 60)
	emp_proof = TRUE

/obj/item/weapon/cell/device/weapon/empproof/empty/Initialize()
	. = ..()
	charge = 0
	update_icon()

/*
 * Self-charging Weapon
 */
/obj/item/weapon/cell/device/weapon/recharge
	name = "self-charging weapon power cell"
	desc = "A small power cell designed to power handheld weaponry. This one recharges itself."
	icon_state = "sc_weapon_cell"
	matter = list(MAT_STEEL = 400, MAT_GLASS = 80)
	self_recharge = TRUE
	charge_amount = 120
	charge_delay = 75

/*
 * Captain's Self-charging Weapon
 */
/obj/item/weapon/cell/device/weapon/recharge/captain
	icon_state = "cap_weapon_cell"
	matter = list(MAT_STEEL = 400, MAT_GLASS = 100)
	charge_amount = 160	//Recharges a lot more quickly...
	charge_delay = 100	//... but it takes a while to get started

/*
 * Alien Void Cell
 */
/datum/category_item/catalogue/anomalous/precursor_a/alien_void_cell
	name = "Precursor Alpha Object - Void Cell"
	desc = "This is a very enigmatic and small machine. It is able to output a direct electrical current \
	from itself to another device or machine that it is connected to. Its shape has a similar form as \
	a battery cell, which might imply that the species who created these had a desire for some form of \
	a modular power supply.\
	<br><br>\
	These appear to be limited in throughput, only able to put out so much energy at a time. It is unknown \
	if this was intentional, or was a design constraint that the creators of this object had to work around. \
	Regardless, it will likely function inside of various devices which run off of conventional power cells.\
	<br><br>\
	Scanning similar objects may yield more information."
	value = CATALOGUER_REWARD_EASY

/obj/item/weapon/cell/device/weapon/recharge/alien
	name = "void cell"
	desc = "An alien technology that produces energy seemingly out of nowhere. Its small, cylinderal shape means it might be able to be used with human technology, perhaps?"
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_void_cell)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cell"
	charge_amount = 120 // 5%.
	charge_delay = 50 // Every five seconds, bit faster than the default.
	origin_tech = list(TECH_POWER = 8, TECH_ENGINEERING = 6)

/obj/item/weapon/cell/device/weapon/recharge/alien/update_icon()
	return // No overlays please.