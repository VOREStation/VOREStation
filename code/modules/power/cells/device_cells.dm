/*
 * Device
 */
/obj/item/cell/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "device_cell"
	item_state = "egg6"
	w_class = ITEMSIZE_SMALL
	force = 0
	throw_speed = 5
	throw_range = 7
	charge = 480
	maxcharge = 480
	charge_amount = 5
	matter = list(MAT_STEEL = 350, MAT_GLASS = 50)
	preserve_item = 1

/obj/item/cell/device/empty
	charge = 0

/*
 * Crap Device
 */
/obj/item/cell/device/crap
	name = "\improper rechargable D battery"
	desc = "An older, cheap power cell designed to power handheld devices. It's probably been in use for quite some time now."
	description_fluff = "You can't top the rust top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = list(TECH_POWER = 0)
	icon_state = "device_crap"
	charge = 240
	maxcharge = 240
	matter = list(MAT_STEEL = 350, MAT_GLASS = 30)

/obj/item/cell/device/crap/update_icon() //No visible charge indicator
	return

/obj/item/cell/device/crap/empty
	charge = 0

/*
 * Hyper Device
 */
/obj/item/cell/device/hyper
	name = "hyper device power cell"
	desc = "A small power cell designed to power handheld devices. Has a better charge than a standard device cell."
	icon_state = "hype_device_cell"
	charge = 600
	maxcharge = 600
	matter = list(MAT_STEEL = 400, MAT_GLASS = 60)

/obj/item/cell/device/hyper/empty
	charge = 0

/*
 * EMP Proof Device
 */
/obj/item/cell/device/empproof
	name = "shielded device power cell"
	desc = "A small power cell designed to power handheld devices. Shielded from EMPs."
	icon_state = "up_device_cell"
	matter = list(MAT_STEEL = 400, MAT_GLASS = 60)
	emp_proof = TRUE

/obj/item/cell/device/empproof/empty
	charge = 0

/*
 * Weapon
 */
/obj/item/cell/device/weapon
	name = "weapon power cell"
	desc = "A small power cell designed to power handheld weaponry."
	icon_state = "weapon_cell"
	charge = 2400
	maxcharge = 2400
	charge_amount = 20

/obj/item/cell/device/weapon/empty
	charge = 0

/*
 * EMP Proof Weapon
 */
/obj/item/cell/device/weapon/empproof
	name = "shielded weapon power cell"
	desc = "A small power cell designed to power handheld weaponry. Shielded from EMPs."
	icon_state = "emp_weapon_cell"
	matter = list(MAT_STEEL = 400, MAT_GLASS = 60)
	emp_proof = TRUE

/obj/item/cell/device/weapon/empproof/empty
	charge = 0

/*
 * Self-charging Weapon
 */
/obj/item/cell/device/weapon/recharge
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
/obj/item/cell/device/weapon/recharge/captain
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

/obj/item/cell/device/weapon/recharge/alien
	name = "void cell (device)"
	desc = "An alien technology that produces energy seemingly out of nowhere. Its small, cylinderal shape means it might be able to be used with human technology, perhaps?"
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_void_cell)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cell"
	charge_amount = 120 // 5%.
	charge_delay = 50 // Every five seconds, bit faster than the default.
	origin_tech = list(TECH_POWER = 8, TECH_ENGINEERING = 6)
	var/swaps_to = /obj/item/cell/void
	standard_overlays = FALSE

/obj/item/cell/device/weapon/recharge/alien/update_icon()
	return // No overlays please.

/obj/item/cell/device/weapon/recharge/alien/attack_self(var/mob/user)
	user.remove_from_mob(src)
	to_chat(user, span_notice("You swap [src] to 'machinery cell' mode."))
	var/obj/item/cell/newcell = new swaps_to(null)
	user.put_in_active_hand(newcell)
	var/percentage = charge/maxcharge
	newcell.charge = newcell.maxcharge * percentage
	newcell.persist_storable = persist_storable
	qdel(src)

// Bloo friendlier hybrid tech
/obj/item/cell/device/weapon/recharge/alien/hybrid
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "cellb"
	swaps_to = /obj/item/cell/void/hybrid
