// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/weapon/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/power_cells.dmi'
	icon_state = "standard"
	item_state = "cell"
	origin_tech = list(TECH_POWER = 1)
	force = 5.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	/// Are we EMP immune?
	var/emp_proof = FALSE
	var/static/cell_uid = 1		// Unique ID of this power cell. Used to reduce bunch of uglier code in nanoUI.
	var/c_uid
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	var/self_recharge = FALSE // If true, the cell will recharge itself.
	var/charge_amount = 25 // How much power to give, if self_recharge is true.  The number is in absolute cell charge, as it gets divided by CELLRATE later.
	var/last_use = 0 // A tracker for use in self-charging
	var/charge_delay = 0 // How long it takes for the cell to start recharging after last use
	matter = list(MAT_STEEL = 700, MAT_GLASS = 50)
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

	// Overlay stuff.
	var/standard_overlays = TRUE
	var/last_overlay_state = null // Used to optimize update_icon() calls.

/obj/item/weapon/cell/Initialize()
	. = ..()
	c_uid = cell_uid++
	charge = maxcharge
	update_icon()
	if(self_recharge)
		START_PROCESSING(SSobj, src)

/obj/item/weapon/cell/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/cell/get_cell()
	return src

/obj/item/weapon/cell/process()
	if(self_recharge)
		if(world.time >= last_use + charge_delay)
			give(charge_amount)
			// TGMC Ammo HUD - Update the HUD every time we're called to recharge.
			if(istype(loc, /obj/item/weapon/gun/energy)) // Are we in a gun currently?
				var/obj/item/weapon/gun/energy/gun = loc
				var/mob/living/user = gun.loc
				if(istype(user))
					user?.hud_used.update_ammo_hud(user, gun) // Update the HUD
	else
		return PROCESS_KILL

/obj/item/weapon/cell/drain_power(var/drain_check, var/surge, var/power = 0)

	if(drain_check)
		return 1

	if(charge <= 0)
		return 0

	var/cell_amt = power * CELLRATE

	return use(cell_amt) / CELLRATE

#define OVERLAY_FULL	2
#define OVERLAY_PARTIAL	1
#define OVERLAY_EMPTY	0

/obj/item/weapon/cell/update_icon()
	if(!standard_overlays)
		return
	var/ratio = clamp(round(charge / maxcharge, 0.25) * 100, 0, 100)
	var/new_state = "[icon_state]_[ratio]"
	if(new_state != last_overlay_state)
		cut_overlay(last_overlay_state)
		add_overlay(new_state)
		last_overlay_state = new_state

#undef OVERLAY_FULL
#undef OVERLAY_PARTIAL
#undef OVERLAY_EMPTY

/obj/item/weapon/cell/proc/percent()		// return % charge of cell
	return 100.0*charge/maxcharge

/obj/item/weapon/cell/proc/fully_charged()
	return (charge == maxcharge)

// checks if the power cell is able to provide the specified amount of charge
/obj/item/weapon/cell/proc/check_charge(var/amount)
	return (charge >= amount)

// Returns how much charge is missing from the cell, useful to make sure not overdraw from the grid when recharging.
/obj/item/weapon/cell/proc/amount_missing()
	return max(maxcharge - charge, 0)

// use power from a cell, returns the amount actually used
/obj/item/weapon/cell/proc/use(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0
	var/used = min(charge, amount)
	charge -= used
	last_use = world.time
	update_icon()
	return used

// Checks if the specified amount can be provided. If it can, it removes the amount
// from the cell and returns 1. Otherwise does nothing and returns 0.
/obj/item/weapon/cell/proc/checked_use(var/amount)
	if(!check_charge(amount))
		return 0
	use(amount)
	return 1

// recharge the cell
/obj/item/weapon/cell/proc/give(var/amount)
	if(rigged && amount > 0)
		explode()
		return 0

	if(maxcharge < amount)	return 0
	var/amount_used = min(maxcharge-charge,amount)
	charge += amount_used
	update_icon()
	if(loc)
		loc.update_icon()
	return amount_used


/obj/item/weapon/cell/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "It has a power rating of [maxcharge]."
		. += "The charge meter reads [round(src.percent() )]%."

/obj/item/weapon/cell/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W

		to_chat(user, "You inject the solution into the power cell.")

		if(S.reagents.has_reagent("phoron", 5))

			rigged = 1

			log_admin("LOG: [user.name] ([user.ckey]) injected a power cell with phoron, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a power cell with phoron, rigging it to explode.")

		S.reagents.clear_reagents()

/obj/item/weapon/cell/proc/explode()
	var/turf/T = get_turf(src.loc)
/*
 * 1000-cell	explosion(T, -1, 0, 1, 1)
 * 2500-cell	explosion(T, -1, 0, 1, 1)
 * 10000-cell	explosion(T, -1, 1, 3, 3)
 * 15000-cell	explosion(T, -1, 2, 4, 4)
 * */
	if (charge==0)
		return
	var/devastation_range = -1 //round(charge/11000)
	var/heavy_impact_range = round(sqrt(charge)/60)
	var/light_impact_range = round(sqrt(charge)/30)
	var/flash_range = light_impact_range
	if (light_impact_range==0)
		rigged = 0
		corrupt()
		return
	//explosion(T, 0, 1, 2, 2)

	log_admin("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")
	message_admins("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")

	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)

	qdel(src)

/obj/item/weapon/cell/proc/corrupt()
	charge /= 2
	maxcharge /= 2
	if (prob(10))
		rigged = 1 //broken batterys are dangerous

/obj/item/weapon/cell/emp_act(severity)
	if(emp_proof)
		return
	//remove this once emp changes on dev are merged in
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		severity *= R.cell_emp_mult

	charge -= charge / severity
	if (charge < 0)
		charge = 0

	update_icon()
	..()

/obj/item/weapon/cell/ex_act(severity)

	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
			if (prob(50))
				corrupt()
		if(3.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(25))
				corrupt()
	return

/obj/item/weapon/cell/proc/get_electrocute_damage()
	switch (charge)
/*		if (9000 to INFINITY)
			return min(rand(90,150),rand(90,150))
		if (2500 to 9000-1)
			return min(rand(70,145),rand(70,145))
		if (1750 to 2500-1)
			return min(rand(35,110),rand(35,110))
		if (1500 to 1750-1)
			return min(rand(30,100),rand(30,100))
		if (750 to 1500-1)
			return min(rand(25,90),rand(25,90))
		if (250 to 750-1)
			return min(rand(20,80),rand(20,80))
		if (100 to 250-1)
			return min(rand(20,65),rand(20,65))*/
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000-1)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000-1)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000-1)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000-1)
			return min(rand(10,20),rand(10,20))
		else
			return 0