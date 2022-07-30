
//The device cell
/obj/item/cell/device/weapon/recharge/alien
	name = "void cell (device)"
	var/swaps_to = /obj/item/cell/void
	standard_overlays = FALSE

/obj/item/cell/device/weapon/recharge/alien/attack_self(var/mob/user)
	user.remove_from_mob(src)
	to_chat(user, "<span class='notice'>You swap [src] to 'machinery cell' mode.</span>")
	var/obj/item/cell/newcell = new swaps_to(null)
	user.put_in_active_hand(newcell)
	var/percentage = charge/maxcharge
	newcell.charge = newcell.maxcharge * percentage
	qdel(src)

//The machine cell
/obj/item/cell/void
	name = "void cell (machinery)"
	desc = "An alien technology that produces energy seemingly out of nowhere. Its small, cylinderal shape means it might be able to be used with human technology, perhaps?"
	origin_tech = list(TECH_POWER = 8, TECH_ENGINEERING = 6)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cell"
	maxcharge = 4800 //10x the device version
	charge_amount = 1200 //10x the device version
	self_recharge = TRUE
	charge_delay = 50
	matter = null
	standard_overlays = FALSE
	var/swaps_to = /obj/item/cell/device/weapon/recharge/alien

/obj/item/cell/void/attack_self(var/mob/user)
	user.remove_from_mob(src)
	to_chat(user, "<span class='notice'>You swap [src] to 'device cell' mode.</span>")
	var/obj/item/cell/newcell = new swaps_to(null)
	user.put_in_active_hand(newcell)
	var/percentage = charge/maxcharge
	newcell.charge = newcell.maxcharge * percentage
	qdel(src)

// Bloo friendlier hybrid tech
/obj/item/cell/device/weapon/recharge/alien/hybrid
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "cellb"
	swaps_to = /obj/item/cell/void/hybrid

/obj/item/cell/void/hybrid
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "cellb"
	swaps_to = /obj/item/cell/device/weapon/recharge/alien/hybrid
