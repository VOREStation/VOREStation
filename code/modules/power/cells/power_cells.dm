/obj/item/weapon/cell/crap
	name = "\improper rechargable AA battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = list(TECH_POWER = 0)
	maxcharge = 500
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 40)

/obj/item/weapon/cell/crap/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/secborg
	name = "security borg rechargable D battery"
	origin_tech = list(TECH_POWER = 0)
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 40)

/obj/item/weapon/cell/secborg/empty/New()
	..()
	charge = 0
	update_icon()

/obj/item/weapon/cell/apc
	name = "heavy-duty power cell"
	origin_tech = list(TECH_POWER = 1)
	maxcharge = 5000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 50)

/obj/item/weapon/cell/high
	name = "high-capacity power cell"
	origin_tech = list(TECH_POWER = 2)
	icon_state = "hcell"
	maxcharge = 10000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 60)

/obj/item/weapon/cell/high/empty/New()
	..()
	charge = 0
	update_icon()

/obj/item/weapon/cell/super
	name = "super-capacity power cell"
	origin_tech = list(TECH_POWER = 5)
	icon_state = "scell"
	maxcharge = 20000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 70)

/obj/item/weapon/cell/super/empty/New()
	..()
	charge = 0
	update_icon()

/obj/item/weapon/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = list(TECH_POWER = 6)
	icon_state = "hpcell"
	maxcharge = 30000
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 80)

/obj/item/weapon/cell/hyper/empty/New()
	..()
	charge = 0
	update_icon()

/obj/item/weapon/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	origin_tech =  null
	maxcharge = 30000 //determines how badly mobs get shocked
	matter = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 80)

/obj/item/weapon/cell/infinite/check_charge()
	return 1

/obj/item/weapon/cell/infinite/use()
	return 1

/obj/item/weapon/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = list(TECH_POWER = 1)
	icon = 'icons/obj/power.dmi' //'icons/obj/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	charge = 100
	maxcharge = 300
	minor_fault = 1

/obj/item/weapon/cell/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with phoron, it crackles with power."
	origin_tech = list(TECH_POWER = 4, TECH_BIO = 5)
	icon = 'icons/mob/slimes.dmi' //'icons/obj/harvest.dmi'
	icon_state = "yellow slime extract" //"potato_battery"
	description_info = "This 'cell' holds a max charge of 10k and self recharges over time."
	maxcharge = 10000
	matter = null
	self_recharge = TRUE

//Not actually a cell, but if people look for it, they'll probably look near other cells
/obj/item/device/fbp_backup_cell
	name = "backup battery"
	desc = "A small one-time-use chemical battery for synthetic crew when they are low on power in emergency situations."
	icon = 'icons/obj/power.dmi'
	icon_state = "fbp_cell"
	w_class = ITEMSIZE_SMALL
	var/amount = 100
	var/used = FALSE

/obj/item/device/fbp_backup_cell/Initialize()
	overlays += image(icon,"[icon_state]1")

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
	overlays.Cut()
	target.nutrition += amount
	user.custom_emote(message = "connects \the [src] to [user == target ? "their" : "[target]'s"] charging port, expending it.")

/obj/item/weapon/cell/emergency_light
	name = "miniature power cell"
	desc = "A tiny power cell with a very low power capacity. Used in light fixtures to power them in the event of an outage."
	maxcharge = 120 //Emergency lights use 0.2 W per tick, meaning ~10 minutes of emergency power from a cell
	matter = list("glass" = 20)
	w_class = ITEMSIZE_TINY

/obj/item/weapon/cell/emergency_light/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(!A.lightswitch || !A.light_power)
		charge = 0 //For naturally depowered areas, we start with no power