/obj/item/weapon/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"
	fire_sound_text = "laser blast"

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 240 //How much energy is needed to fire.

	var/accept_cell_type = /obj/item/weapon/cell/device
	var/cell_type = /obj/item/weapon/cell/device/weapon
	projectile_type = /obj/item/projectile/beam/practice

	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/use_organic_power = 0 // If set, the weapon will draw from nutrition or blood.
	var/recharge_time = 4
	var/charge_tick = 0
	var/charge_delay = 75	//delay between firing and charging
	var/shot_counter = TRUE // does this gun tell you how many shots it has?

	var/battery_lock = 0	//If set, weapon cannot switch batteries

/obj/item/weapon/gun/energy/New()
	..()
	if(self_recharge)
		power_supply = new /obj/item/weapon/cell/device/weapon(src)
		START_PROCESSING(SSobj, src)
	else
		if(cell_type)
			power_supply = new cell_type(src)
		else
			power_supply = null

	update_icon()

/obj/item/weapon/gun/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/gun/energy/get_cell()
	return power_supply

/obj/item/weapon/gun/energy/process()
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
				var/mob/living/human/H
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
			var/mob/living/M = loc // TGMC Ammo HUD
			if(istype(M)) // TGMC Ammo HUD
				M?.hud_used.update_ammo_hud(M, src) // TGMC Ammo HUD
		else
			charge_tick = 0
	return 1

/obj/item/weapon/gun/energy/attackby(var/obj/item/A as obj, mob/user as mob)
	..()

/obj/item/weapon/gun/energy/switch_firemodes(mob/user)
	if(..())
		update_icon()

/obj/item/weapon/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/weapon/gun/energy/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	var/mob/living/M = loc // TGMC Ammo HUD 
	if(istype(M)) // TGMC Ammo HUD 
		M?.hud_used.update_ammo_hud(M, src)
	return new projectile_type(src)

/obj/item/weapon/gun/energy/proc/load_ammo(var/obj/item/C, mob/user)
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
					user.hud_used.update_ammo_hud(user, src) // TGMC Ammo HUD
		else
			to_chat(user, "<span class='notice'>This cell is not fitted for [src].</span>")
	return

/obj/item/weapon/gun/energy/proc/unload_ammo(mob/user)
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
		user.hud_used.update_ammo_hud(user, src) // TGMC Ammo HUD
	else
		to_chat(user, "<span class='notice'>[src] does not have a power cell.</span>")

/obj/item/weapon/gun/energy/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	load_ammo(A, user)

/obj/item/weapon/gun/energy/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user)
	else
		return ..()

/obj/item/weapon/gun/energy/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/human/H = module.holder.wearer
			if(istype(H) && H.get_rig())
				var/obj/item/weapon/rig/suit = H.get_rig()
				if(istype(suit))
					return suit.cell
	return null

/obj/item/weapon/gun/energy/examine(mob/user)
	. = ..()
	if(shot_counter)
		if(power_supply)
			if(charge_cost)
				var/shots_remaining = round(power_supply.charge / max(1, charge_cost))	// Paranoia
				. += "Has [shots_remaining] shot\s remaining."
			else
				. += "Has infinite shots remaining."
		else
			. += "Does not have a power cell."

/obj/item/weapon/gun/energy/update_icon(var/ignore_inhands)
	if(power_supply == null)
		if(modifystate)
			icon_state = "[modifystate]_open"
		else
			icon_state = "[initial(icon_state)]_open"
		return
	else if(charge_meter)
		var/ratio = power_supply.charge / power_supply.maxcharge

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"

	else if(power_supply)
		if(modifystate)
			icon_state = "[modifystate]"
		else
			icon_state = "[initial(icon_state)]"

	if(!ignore_inhands) update_held_icon()

/obj/item/weapon/gun/energy/proc/start_recharge()
	if(power_supply == null)
		power_supply = new /obj/item/weapon/cell/device/weapon(src)
	self_recharge = 1
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/weapon/gun/energy/get_description_interaction()
	var/list/results = list()

	if(!battery_lock && !self_recharge)
		if(power_supply)
			results += "[desc_panel_image("offhand")]to remove the weapon cell."
		else
			results += "[desc_panel_image("weapon cell")]to add a new weapon cell."

	results += ..()

	return results

// TGMC AMMO HUD
/obj/item/weapon/gun/energy/has_ammo_counter()
	return TRUE

/obj/item/weapon/gun/energy/get_ammo_type()
	if(!projectile_type)
		return list("unknown", "unknown")
	else
		var/obj/item/projectile/P = projectile_type
		return list(initial(P.hud_state), initial(P.hud_state_empty))

/obj/item/weapon/gun/energy/get_ammo_count()
	if(!power_supply)
		return 0
	else
		return FLOOR(power_supply.charge / max(charge_cost, 1), 1)