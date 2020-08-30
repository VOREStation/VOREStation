//RD 'gun'
/obj/item/weapon/bluespace_harpoon
	name = "bluespace harpoon"
	desc = "For climbing on bluespace mountains!"

	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "harpoon-2"

	w_class = ITEMSIZE_NORMAL

	throw_speed = 4
	throw_range = 20

	origin_tech = list(TECH_BLUESPACE = 5)

	var/mode = 1  // 1 mode - teleport you to turf  0 mode teleport turf to you
	var/firable = TRUE
	var/transforming = 0
	var/failure_chance = 15 // This can become negative with part tiers above 3, which helps offset penalties
	var/obj/item/weapon/stock_parts/scanning_module/scanmod
	
	// Energy Variables here
	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 240 //How much energy is needed to fire.

	var/accept_cell_type = /obj/item/weapon/cell/device
	var/cell_type = /obj/item/weapon/cell/device/weapon
	
	var/charge_meter = 0	//if set, the icon state will be chosen based on the current charge. Currently we lack sprites for this, so no.

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/use_organic_power = 0 // If set, the weapon will draw from nutrition or blood.
	var/recharge_time = 4
	var/charge_tick = 0
	var/charge_delay = 75	//delay between firing and charging

	var/battery_lock = 0	//If set, weapon cannot switch batteries

/obj/item/weapon/bluespace_harpoon/Initialize()
	. = ..()
	scanmod = new(src)
	update_fail_chance()
	
	if(self_recharge)
		power_supply = new /obj/item/weapon/cell/device/weapon(src)
		START_PROCESSING(SSobj, src)
	else
		if(cell_type)
			power_supply = new cell_type(src)
		else
			power_supply = null

	update_icon()
	
/obj/item/weapon/bluespace_harpoon/Destroy()
	. = ..()
	
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)

/obj/item/weapon/bluespace_harpoon/examine(var/mob/user)
	. = ..()
	if(Adjacent(user))
		. += "It has [scanmod ? scanmod : "no scanner module"] installed."
	
	if(power_supply)
		if(charge_cost)
			var/uses_remaining = round(power_supply.charge / max(1, charge_cost))	// Paranoia
			. += "Has [uses_remaining] use\s remaining."
		else
			. += "Has infinite uses remaining."
	else
		. += "Does not have a power cell."
		
// Harpoon Energy stuff, stolen from energy.dm (gun/energy)

/obj/item/weapon/bluespace_harpoon/get_cell()
	return power_supply
	
/obj/item/weapon/bluespace_harpoon/process() // Here we handle self-recharging.
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the battery
		if(world.time > last_shot + charge_delay)	//Doesn't work if you've fired recently
			if(!power_supply || power_supply.charge >= power_supply.maxcharge)
				return 0 // check if we actually need to recharge

			charge_tick++
			if(charge_tick < recharge_time) return 0
			charge_tick = 0

			var/rechargeamt = power_supply.maxcharge*0.2

			if(use_external_power)
				var/obj/item/weapon/cell/external = get_external_power_supply()
				if(!external || !external.use(rechargeamt)) //Take power from the borg...
					return 0

			if(use_organic_power)
				var/mob/living/carbon/human/H
				if(ishuman(loc))
					H = loc

				if(istype(loc, /obj/item/organ))
					var/obj/item/organ/O = loc
					if(O.owner)
						H = O.owner

				if(istype(H))
					var/start_nutrition = H.nutrition
					var/end_nutrition = 0

					H.adjust_nutrition(-rechargeamt / 15)

					end_nutrition = H.nutrition

					if(start_nutrition - max(0, end_nutrition) < rechargeamt / 15)

						if(H.isSynthetic())
							H.adjustToxLoss((rechargeamt / 15) - (start_nutrition - max(0, end_nutrition)))

						else
							H.remove_blood((rechargeamt / 15) - (start_nutrition - max(0, end_nutrition)))

			power_supply.give(rechargeamt) //... to recharge 1/5th the battery
			update_icon()
		else
			charge_tick = 0
	return 1
	
/obj/item/weapon/bluespace_harpoon/emp_act(severity) // If anyone wants to add emp-specific effects, do it here.
	..()

/obj/item/weapon/bluespace_harpoon/proc/load_cell(var/obj/item/C, mob/user)
	if(istype(C, /obj/item/weapon/cell))
		if(self_recharge || battery_lock)
			to_chat(user, "<span class='notice'>[src] does not have a battery port.</span>")
			return
		if(istype(C, accept_cell_type))
			var/obj/item/weapon/cell/P = C
			if(power_supply)
				to_chat(user, "<span class='notice'>[src] already has a power cell.</span>")
			else
				user.visible_message("[user] is reloading [src].", "<span class='notice'>You start to insert [P] into [src].</span>")
				if(do_after(user, 5 * P.w_class))
					user.remove_from_mob(P)
					power_supply = P
					P.loc = src
					user.visible_message("[user] inserts [P] into [src].", "<span class='notice'>You insert [P] into [src].</span>")
					playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
					update_icon()
					update_held_icon()
		else
			to_chat(user, "<span class='notice'>This cell is not fitted for [src].</span>")
	return
	
/obj/item/weapon/bluespace_harpoon/proc/unload_cell(mob/user)
	if(self_recharge || battery_lock)
		to_chat(user, "<span class='notice'>[src] does not have a battery port.</span>")
		return
	if(power_supply)
		user.put_in_hands(power_supply)
		power_supply.update_icon()
		user.visible_message("[user] removes [power_supply] from [src].", "<span class='notice'>You remove [power_supply] from [src].</span>")
		power_supply = null
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		update_icon()
		update_held_icon()
	else
		to_chat(user, "<span class='notice'>[src] does not have a power cell.</span>")
		
/obj/item/weapon/bluespace_harpoon/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user)
	else
		return ..()
		
/obj/item/weapon/bluespace_harpoon/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.get_rig())
				var/obj/item/weapon/rig/suit = H.get_rig()
				if(istype(suit))
					return suit.cell
	return null
	
/obj/item/weapon/bluespace_harpoon/proc/start_recharge()
	if(power_supply == null)
		power_supply = new /obj/item/weapon/cell/device/weapon(src)
	self_recharge = 1
	START_PROCESSING(SSobj, src)
	update_icon()
	
/obj/item/weapon/bluespace_harpoon/get_description_interaction()
	var/list/results = list()

	if(!battery_lock && !self_recharge)
		if(power_supply)
			results += "[desc_panel_image("offhand")]to remove the weapon cell."
		else
			results += "[desc_panel_image("weapon cell")]to add a new weapon cell."

	results += ..()

	return results
	
/obj/item/weapon/bluespace_harpoon/proc/update_charge(var/amount)
	if(!power_supply) // Do we not have a power supply? Stop.
		return null
	if(!power_supply.checked_use(charge_cost)) // Do we not have enough charge? Stop.
		return null
	return amount

// Harpoon-unique Procs
/obj/item/weapon/bluespace_harpoon/proc/update_fail_chance()
	if(scanmod)
		failure_chance = initial(failure_chance) - (scanmod.rating * 5)
	else
		failure_chance = 75 // You can't even use it if there's no scanmod, but why not.

/obj/item/weapon/bluespace_harpoon/attackby(var/obj/item/I, var/mob/living/user)
	if(!istype(user))
		return

	if(I.is_screwdriver())
		if(!scanmod)
			to_chat(user, "<span class='warning'>There's no scanner module installed!</span>")
			return
		var/turf/T = get_turf(src)
		to_chat(user, "<span class='notice'>You remove [scanmod] from [src].</span>")
		playsound(src, I.usesound, 75, 1)
		scanmod.forceMove(T)
		scanmod = null
		update_fail_chance()
	else if(istype(I, /obj/item/weapon/stock_parts/scanning_module))
		if(scanmod)
			to_chat(user, "<span class='warning'>There's already [scanmod] installed! Remove it first.</span>")
			return
		user.remove_from_mob(I)
		I.forceMove(src)
		scanmod = I
		to_chat(user, "<span class='notice'>You install [scanmod] into [src].</span>")
		update_fail_chance()
	else
		return ..()

/obj/item/weapon/bluespace_harpoon/afterattack(atom/A, mob/user as mob)
	if(!user || !A || isstorage(A))
		return
	if(!scanmod)
		to_chat(user,"<span class = 'warning'>The scanning module has been removed from [src]!</span>")
		return
	if(transforming)
		to_chat(user,"<span class = 'warning'>You can't fire while \the [src] transforming!</span>")
		return
	if(!firable || )
		to_chat(user,"<span class = 'warning'>\The [src] is recharging...</span>")
		return
	if(is_jammed(A) || is_jammed(user))
		firable = FALSE
		VARSET_IN(src, firable, TRUE, 30 SECONDS)
		to_chat(user,"<span class = 'warning'>\The [src] shot fizzles due to interference!</span>")
		playsound(src, 'sound/weapons/wave.ogg', 60, 1)
		return
	var/turf/T = get_turf(A)
	if(!T || (T.check_density() && mode == 1))
		to_chat(user,"<span class = 'warning'>That's a little too solid to harpoon into!</span>")
		return
	var/turf/ownturf = get_turf(src)
	if(ownturf.z != T.z || get_dist(T,ownturf) > world.view)
		to_chat(user, "<span class='warning'>The target is out of range!</span>")
		return
	if(get_area(A).flags & BLUE_SHIELDED)
		to_chat(user, "<span class='warning'>The target area protected by bluespace shielding!</span>")
		return
	if(!(A in view(user, world.view)))
		to_chat(user, "<span class='warning'>Harpoon fails to lock on the obstructed target!</span>")
		return

	firable = FALSE
	VARSET_IN(src, firable, TRUE, 30 SECONDS)
	playsound(src, 'sound/weapons/wave.ogg', 60, 1)

	user.visible_message("<span class='warning'>[user] fires \the [src]!</span>","<span class='warning'>You fire \the [src]!</span>")

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, A)
	s.start()
	s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, user)
	s.start()

	var/turf/FromTurf = mode ? get_turf(user) : get_turf(A)
	var/turf/ToTurf = mode ? get_turf(A) : get_turf(user)

	var/recievefailchance = failure_chance
	var/sendfailchance = failure_chance
	if(istype(user, /mob/living))
		var/mob/living/L = user
		if(LAZYLEN(L.buckled_mobs))
			for(var/rider in L.buckled_mobs)
				sendfailchance += 15

	if(mode)
		if(user in FromTurf)
			if(prob(sendfailchance))
				user.forceMove(pick(trange(24,user)))
			else
				user.forceMove(ToTurf)
	else
		for(var/obj/O in FromTurf)
			if(O.anchored) continue
			if(prob(recievefailchance))
				O.forceMove(pick(trange(24,user)))
			else
				O.forceMove(ToTurf)

		for(var/mob/living/M in FromTurf)
			if(prob(recievefailchance))
				M.forceMove(pick(trange(24,user)))
			else
				M.forceMove(ToTurf)

/obj/item/weapon/bluespace_harpoon/attack_self(mob/living/user as mob)
	return change_fire_mode(user)

/obj/item/weapon/bluespace_harpoon/verb/change_fire_mode(mob/user as mob)
	set name = "Change fire mode"
	set category = "Object"
	set src in oview(1)
	if(transforming) return
	mode = !mode
	transforming = 1
	to_chat(user,"<span class = 'info'>You change \the [src]'s mode to [mode ? "transmiting" : "receiving"].</span>")
	update_icon()

/obj/item/weapon/bluespace_harpoon/update_icon()
	if(transforming)
		switch(mode)
			if(0)
				flick("harpoon-2-change", src)
				icon_state = "harpoon-1"
			if(1)
				flick("harpoon-1-change",src)
				icon_state = "harpoon-2"
		transforming = 0
