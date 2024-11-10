/*
 * Empty
 */
/obj/item/cell/empty
	charge = 0

/*
 * Crap
 */
/obj/item/cell/crap
	name = "\improper rechargable DD battery"
	desc = "An older, cheap power cell. It's probably been in use for quite some time now."
	description_fluff = "You can't top the rust top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = list(TECH_POWER = 0)
	icon_state = "crap"
	charge = 500
	maxcharge = 500
	matter = list(MAT_STEEL = 700, MAT_GLASS = 40)
	robot_durability = 20

/obj/item/cell/crap/update_icon() //No visible charge indicator
	return

/obj/item/cell/crap/empty
	charge = 0

/*
 * APC
 */
/obj/item/cell/apc
	name = "heavy-duty power cell"
	origin_tech = list(TECH_POWER = 1)
	icon_state = "apc"
	charge = 5000
	maxcharge = 5000
	matter = list(MAT_STEEL = 700, MAT_GLASS = 50)

/*
 * Robot
 */
/obj/item/cell/robot_station
	name = "standard robot power cell"
	charge = 7500
	maxcharge = 7500

/*
 * High
 */
/obj/item/cell/high
	name = "high-capacity power cell"
	origin_tech = list(TECH_POWER = 2)
	icon_state = "high"
	charge = 10000
	maxcharge = 10000
	matter = list(MAT_STEEL = 700, MAT_GLASS = 60)
	robot_durability = 55

/obj/item/cell/high/empty
	charge = 0

/*
 * Super
 */
/obj/item/cell/super
	name = "super-capacity power cell"
	origin_tech = list(TECH_POWER = 5)
	icon_state = "super"
	charge = 20000
	maxcharge = 20000
	matter = list(MAT_STEEL = 700, MAT_GLASS = 70)
	robot_durability = 60

/obj/item/cell/super/empty
	charge = 0

/*
 * Syndicate
 */
/obj/item/cell/robot_syndi
	name = "syndicate robot power cell"
	description_fluff = "Almost as good as a hyper."
	icon_state = "super" //We don't want roboticists confuse it with a low standard cell
	charge = 25000
	maxcharge = 25000
	robot_durability = 65

/*
 * Hyper
 */
/obj/item/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = list(TECH_POWER = 6)
	icon_state = "hyper"
	charge = 30000
	maxcharge = 30000
	matter = list(MAT_STEEL = 700, MAT_GLASS = 80)
	robot_durability = 70

/obj/item/cell/hyper/empty
	charge = 0

/*
 * Mecha
 */
/obj/item/cell/mech
	name = "mecha power cell"
	icon_state = "mech"
	connector_type = "mech"
	charge = 15000
	maxcharge = 15000
	matter = list(MAT_STEEL = 800, MAT_GLASS = 60)

/obj/item/cell/mech/lead
	name = "lead acid battery"
	desc = "An ancient battery design not commonly seen anymore. It looks like it'd fit inside a mech however..."
	origin_tech = list(TECH_POWER = 0) //Litteraly an old car battery, doesn't need tech
	icon_state = "lead"
	charge = 8000
	maxcharge = 8000
	matter = list(MAT_STEEL = 300, MAT_GLASS = 10)

/obj/item/cell/mech/lead/update_icon() //No visible charge indicator
	return

/obj/item/cell/mech/high
	name = "high-capacity mecha power cell"
	origin_tech = list(TECH_POWER = 3)
	icon_state = "blue"
	charge = 20000
	maxcharge = 20000
	matter = list(MAT_STEEL = 800, MAT_GLASS = 80)

/obj/item/cell/mech/super
	name = "super-capacity mecha power cell"
	origin_tech = list(TECH_POWER = 6)
	icon_state = "white"
	charge = 25000
	maxcharge = 25000
	matter = list(MAT_STEEL = 800, MAT_GLASS = 100)

/*
 * Infinite
 */
/obj/item/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "infinity"
	origin_tech =  null
	charge = 30000
	maxcharge = 30000 //determines how badly mobs get shocked
	matter = list(MAT_STEEL = 700, MAT_GLASS = 80)
	robot_durability = 200

/obj/item/cell/infinite/check_charge()
	return 1

/obj/item/cell/infinite/use()
	return 1

/*
 * Potato
 */
/obj/item/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = list(TECH_POWER = 1)
	icon_state = "potato"
	charge = 100
	maxcharge = 300
	minor_fault = 1
	robot_durability = 30

/*
 * Slime
 */
/obj/item/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with phoron, it crackles with power."
	origin_tech = list(TECH_POWER = 4, TECH_BIO = 5)
	icon = 'icons/mob/slimes.dmi' //'icons/obj/harvest.dmi'
	icon_state = "yellow slime extract" //"potato_battery"
	connector_type = "slime"
	description_info = "This 'cell' holds a max charge of 10k and self recharges over time."
	charge = 10000
	maxcharge = 10000
	matter = null
	self_recharge = TRUE
	standard_overlays = FALSE

/*
 * Emergency Light
 */
/obj/item/cell/emergency_light
	name = "miniature power cell"
	desc = "A tiny power cell with a very low power capacity. Used in light fixtures to power them in the event of an outage."
	charge = 120
	maxcharge = 120 //Emergency lights use 0.2 W per tick, meaning ~10 minutes of emergency power from a cell
	matter = list(MAT_GLASS = 20)
	icon_state = "em_light"
	connector_type = "emergency"
	w_class = ITEMSIZE_TINY

/obj/item/cell/emergency_light/update_icon() //No visible charge indicator
	return

/obj/item/cell/emergency_light/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(!A.lightswitch || !A.light_power)
		charge = 0 //For naturally depowered areas, we start with no power

/*
 * Backup Battery
 *
 * Not actually a cell, but if people look for it, they'll probably look near other cells
 */
/obj/item/fbp_backup_cell
	name = "backup battery"
	desc = "A small one-time-use chemical battery for synthetic crew when they are low on power in emergency situations."
	icon = 'icons/obj/power_cells.dmi'
	icon_state = "backup"
	w_class = ITEMSIZE_SMALL
	var/amount = 100
	var/used = FALSE

/obj/item/fbp_backup_cell/Initialize()
	. = ..()
	add_overlay("[icon_state]_100")

/obj/item/fbp_backup_cell/attack(mob/living/M as mob, mob/user as mob)
	if(!used && ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			if(H.nutrition <= amount)
				use(user,H)
			else
				to_chat(user,span_warning("The difference in potential is too great. [user == M ? "You have" : "[H] has"] too much charge to use such a small battery."))
		else if(M == user)
			to_chat(user,span_warning("You lick the cell, and your tongue tingles slightly."))
		else
			to_chat(user,span_warning("This cell is meant for use on humanoid synthetics only."))

	. = ..()

/obj/item/fbp_backup_cell/proc/use(var/mob/living/user, var/mob/living/target)
	if(used)
		return
	used = TRUE
	desc += " This one has already been used."
	cut_overlays()
	target.adjust_nutrition(amount)
	user.custom_emote(message = "connects \the [src] to [user == target ? "their" : "[target]'s"] charging port, expending it.")

//The machine cell
/obj/item/cell/void
	name = "void cell (machinery)"
	desc = "An alien technology that produces energy seemingly out of nowhere. Its small, cylinderal shape means it might be able to be used with human technology, perhaps?"
	origin_tech = list(TECH_POWER = 8, TECH_ENGINEERING = 6)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cell"
	charge = 4800
	maxcharge = 4800 //10x the device version
	charge_amount = 1200 //10x the device version
	self_recharge = TRUE
	charge_delay = 50
	matter = null
	standard_overlays = FALSE
	var/swaps_to = /obj/item/cell/device/weapon/recharge/alien
	robot_durability = 100

/obj/item/cell/void/attack_self(var/mob/user)
	user.remove_from_mob(src)
	to_chat(user, span_notice("You swap [src] to 'device cell' mode."))
	var/obj/item/cell/newcell = new swaps_to(null)
	user.put_in_active_hand(newcell)
	var/percentage = charge/maxcharge
	newcell.charge = newcell.maxcharge * percentage
	newcell.persist_storable = persist_storable
	qdel(src)

/obj/item/cell/void/hybrid
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "cellb"
	swaps_to = /obj/item/cell/device/weapon/recharge/alien/hybrid
