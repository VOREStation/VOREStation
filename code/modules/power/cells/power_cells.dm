/*
 * Empty
 */
/obj/item/weapon/cell/empty/New()
	..()
	charge = 0

/*
 * Crap
 */
/obj/item/weapon/cell/crap
	name = "\improper rechargable DD battery"
	desc = "An older, cheap power cell. It's probably been in use for quite some time now."
	description_fluff = "You can't top the rust top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = list(TECH_POWER = 0)
	icon_state = "crap"
	maxcharge = 500
	matter = list(MAT_STEEL = 700, MAT_GLASS = 40)

/obj/item/weapon/cell/crap/update_icon() //No visible charge indicator
	return

/obj/item/weapon/cell/crap/empty/New()
	..()
	charge = 0

/*
 * APC
 */
/obj/item/weapon/cell/apc
	name = "heavy-duty power cell"
	origin_tech = list(TECH_POWER = 1)
	icon_state = "apc"
	maxcharge = 5000
	matter = list(MAT_STEEL = 700, MAT_GLASS = 50)

/*
 * High
 */
/obj/item/weapon/cell/high
	name = "high-capacity power cell"
	origin_tech = list(TECH_POWER = 2)
	icon_state = "high"
	maxcharge = 10000
	matter = list(MAT_STEEL = 700, MAT_GLASS = 60)

/obj/item/weapon/cell/high/empty/New()
	..()
	charge = 0
	update_icon()

/*
 * Super
 */
/obj/item/weapon/cell/super
	name = "super-capacity power cell"
	origin_tech = list(TECH_POWER = 5)
	icon_state = "super"
	maxcharge = 20000
	matter = list(MAT_STEEL = 700, MAT_GLASS = 70)

/obj/item/weapon/cell/super/empty/New()
	..()
	charge = 0
	update_icon()

/*
 * Hyper
 */
/obj/item/weapon/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = list(TECH_POWER = 6)
	icon_state = "hyper"
	maxcharge = 30000
	matter = list(MAT_STEEL = 700, MAT_GLASS = 80)

/obj/item/weapon/cell/hyper/empty/New()
	..()
	charge = 0
	update_icon()

/*
 * Mecha
 */
/obj/item/weapon/cell/mech
	name = "mecha power cell"
	icon_state = "mech"
	connector_type = "mech"
	charge = 15000
	maxcharge = 15000
	matter = list(MAT_STEEL = 800, MAT_GLASS = 60)

/obj/item/weapon/cell/mech/lead
	name = "lead acid battery"
	desc = "An ancient battery design not commonly seen anymore. It looks like it'd fit inside a mech however..."
	origin_tech = list(TECH_POWER = 0) //Litteraly an old car battery, doesn't need tech
	icon_state = "lead"
	charge = 8000
	maxcharge = 8000
	matter = list(MAT_STEEL = 300, MAT_GLASS = 10)

/obj/item/weapon/cell/mech/lead/update_icon() //No visible charge indicator
	return

/obj/item/weapon/cell/mech/high
	name = "high-capacity mecha power cell"
	origin_tech = list(TECH_POWER = 3)
	icon_state = "blue"
	charge = 20000
	maxcharge = 20000
	matter = list(MAT_STEEL = 800, MAT_GLASS = 80)

/obj/item/weapon/cell/mech/super
	name = "super-capacity mecha power cell"
	origin_tech = list(TECH_POWER = 6)
	icon_state = "white"
	charge = 25000
	maxcharge = 25000
	matter = list(MAT_STEEL = 800, MAT_GLASS = 100)

/*
 * Infinite
 */
/obj/item/weapon/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "infinity"
	origin_tech =  null
	maxcharge = 30000 //determines how badly mobs get shocked
	matter = list(MAT_STEEL = 700, MAT_GLASS = 80)

/obj/item/weapon/cell/infinite/check_charge()
	return 1

/obj/item/weapon/cell/infinite/use()
	return 1

/*
 * Potato
 */
/obj/item/weapon/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = list(TECH_POWER = 1)
	icon_state = "potato"
	charge = 100
	maxcharge = 300
	minor_fault = 1

/*
 * Slime
 */
/obj/item/weapon/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with phoron, it crackles with power."
	origin_tech = list(TECH_POWER = 4, TECH_BIO = 5)
	icon = 'icons/mob/slimes.dmi' //'icons/obj/harvest.dmi'
	icon_state = "yellow slime extract" //"potato_battery"
	connector_type = "slime"
	description_info = "This 'cell' holds a max charge of 10k and self recharges over time."
	maxcharge = 10000
	matter = null
	self_recharge = TRUE
	standard_overlays = FALSE

/*
 * Emergency Light
 */
/obj/item/weapon/cell/emergency_light
	name = "miniature power cell"
	desc = "A tiny power cell with a very low power capacity. Used in light fixtures to power them in the event of an outage."
	maxcharge = 120 //Emergency lights use 0.2 W per tick, meaning ~10 minutes of emergency power from a cell
	matter = list(MAT_GLASS = 20)
	icon_state = "em_light"
	connector_type = "emergency"
	w_class = ITEMSIZE_TINY

/obj/item/weapon/cell/emergency_light/update_icon() //No visible charge indicator
	return

/obj/item/weapon/cell/emergency_light/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(!A.lightswitch || !A.light_power)
		charge = 0 //For naturally depowered areas, we start with no power

/*
 * Backup Battery
 *
 * Not actually a cell, but if people look for it, they'll probably look near other cells
 */
/obj/item/device/fbp_backup_cell
	name = "backup battery"
	desc = "A small one-time-use chemical battery for synthetic crew when they are low on power in emergency situations."
	icon = 'icons/obj/power_cells.dmi'
	icon_state = "backup"
	w_class = ITEMSIZE_SMALL
	var/amount = 100
	var/used = FALSE

/obj/item/device/fbp_backup_cell/Initialize()
	. = ..()
	add_overlay("[icon_state]_100")

/obj/item/device/fbp_backup_cell/attack(mob/living/M as mob, mob/user as mob)
	if(!used && ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isSynthetic())
			if(H.nutrition <= amount)
				use(user,H)
			else
				to_chat(user,"<span class='warning'>The difference in potential is too great. [user == M ? "You have" : "[H] has"] too much charge to use such a small battery.</span>")
		else if(M == user)
			to_chat(user,"<span class='warning'>You lick the cell, and your tongue tingles slightly.</span>")
		else
			to_chat(user,"<span class='warning'>This cell is meant for use on humanoid synthetics only.</span>")

	. = ..()

/obj/item/device/fbp_backup_cell/proc/use(var/mob/living/user, var/mob/living/target)
	if(used)
		return
	used = TRUE
	desc += " This one has already been used."
	cut_overlays()
	target.adjust_nutrition(amount)
	user.custom_emote(message = "connects \the [src] to [user == target ? "their" : "[target]'s"] charging port, expending it.")