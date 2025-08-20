/*
 * Device
 */
/obj/item/cell/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "m_st"
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
	icon_state = "meb_m_st"
	charge = 4800
	maxcharge = 4800
	charge_amount = 20
	matter = list(MAT_STEEL = 400, MAT_GLASS = 60)

/obj/item/cell/device/hyper/empty
	charge = 0

/*
 * EMP Proof Device
 */
/obj/item/cell/device/empproof
	name = "shielded device power cell"
	desc = "A small power cell designed to power handheld devices. Shielded from EMPs."
	icon_state = "s_st"
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
	icon_state = "m_sup"
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
	icon_state = "s_hi"
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
	icon_state = "meb_m_nu"
	matter = list(MAT_STEEL = 400, MAT_GLASS = 80)
	self_recharge = TRUE
	charge_amount = 120
	charge_delay = 75
	origin_tech = list(TECH_POWER = 5, TECH_ARCANE = 1)

/*
 * Captain's Self-charging Weapon
 */
/obj/item/cell/device/weapon/recharge/captain
	icon_state = "infinite_m"
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
	charge = 5000
	maxcharge = 5000
	charge_amount = 130
	charge_delay = 50
	origin_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 6, TECH_PHORON = 6, TECH_ARCANE = 2, TECH_PRECURSOR = 2)
	var/swaps_to = /obj/item/cell/void
	standard_overlays = FALSE

/obj/item/cell/device/weapon/recharge/alien/update_icon()
	return // No overlays please.

/obj/item/cell/device/weapon/recharge/alien/attack_self(var/mob/user)
	if(!swaps_to)
		return
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

/obj/item/cell/device/weapon/recharge/alien/omni
	name = "omni weapon power cell"
	desc = "A mix between alien technology and phoron-based tech. Not quite as good as a true void cell though."
	charge_amount = 90 // 2.5%.
	charge = 3600
	maxcharge = 3600
	charge_delay = 50
	swaps_to = null
	origin_tech = list(TECH_POWER = 8, TECH_ENGINEERING = 6, TECH_PHORON = 6, TECH_ARCANE = 1, TECH_PRECURSOR = 1)

/obj/item/cell/device/weapon/recharge/alien/omni/empty
	charge = 0

/*
 * Giga
 */
/obj/item/cell/device/giga
	name = "giga device power cell"
	desc = "A small power cell that holds a blistering amount of energy, constructed by clever scientists using secrets gleaned from alien technology."
	icon_state = "meb_m_hi"
	charge = 10000
	maxcharge = 10000
	charge_amount = 20
	origin_tech = list(TECH_POWER = 8)

/obj/item/cell/device/giga/empty
	charge = 0

/obj/item/cell/device/super
	name = "super device power cell"
	desc = "A small upgraded power cell designed to power handheld devices."
	icon_state = "m_hy"
	charge = 3600
	maxcharge = 3600
	charge_amount = 20
	origin_tech = list(TECH_POWER = 3)

/obj/item/cell/device/super/empty
	charge = 0
