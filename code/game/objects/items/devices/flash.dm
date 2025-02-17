/obj/item/flash
	name = "flash"
	desc = "Used for blinding and disorienting."
	icon = 'icons/obj/device.dmi'
	icon_state = "flash"
	item_state = "flashtool"
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)

	var/times_used = 0 //Number of times it's been used.
	var/broken = FALSE     //Is the flash burnt out?
	var/last_used = 0 //last world.time it was used.
	var/max_flashes = 10 // How many times the flash can be used before needing to self recharge.
	var/halloss_per_flash = 30
	var/break_mod = 3 // The percent to break increased by every use on the flash.

	var/can_break = TRUE // Can the flash break?
	var/can_repair = FALSE // Can you repair the flash?
	var/repairing = FALSE // Are we repairing right now?

	var/safe_flashes = 2 // How many flashes are kept in 1% breakchance?

	var/charge_only = FALSE // Does the flash run purely on charge?

	var/base_icon = "flash"

	var/obj/item/cell/power_supply //What type of power cell this uses
	var/charge_cost = 30 //How much energy is needed to flash.
	var/use_external_power = FALSE // Do we use charge from an external source?

	var/cell_type = /obj/item/cell/device

	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/flash/Initialize()
	. = ..()
	power_supply = new cell_type(src)

/obj/item/flash/attackby(var/obj/item/W, var/mob/user)
	if(W.has_tool_quality(TOOL_SCREWDRIVER) && broken)
		if(repairing)
			to_chat(user, span_notice("\The [src] is already being repaired!"))
			return
		user.visible_message(span_infoplain(span_bold("\The [user]") + " starts trying to repair \the [src]'s bulb."))
		repairing = TRUE
		if(do_after(user, (40 SECONDS + rand(0, 20 SECONDS)) * W.toolspeed) && can_repair)
			if(prob(30))
				user.visible_message(span_notice("\The [user] successfully repairs \the [src]!"))
				broken = FALSE
				update_icon()
			playsound(src, W.usesound, 50, 1)
		else
			user.visible_message(span_infoplain(span_bold("\The [user]") + " fails to repair \the [src]."))
		repairing = FALSE
	else
		..()

/obj/item/flash/update_icon()
	var/obj/item/cell/battery = power_supply

	if(use_external_power)
		battery = get_external_power_supply()

	if(broken || !battery || battery.charge < charge_cost)
		icon_state = "[base_icon]burnt"
	else
		icon_state = "[base_icon]"
	return

/obj/item/flash/get_cell()
	return power_supply

/obj/item/flash/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.get_rig())
				var/obj/item/rig/suit = H.get_rig()
				if(istype(suit))
					return suit.cell
	return null

/obj/item/flash/proc/clown_check(var/mob/user)
	if(user && (CLUMSY in user.mutations) && prob(50))
		to_chat(user, span_warning("\The [src] slips out of your hand."))
		user.drop_item()
		return 0
	return 1

/obj/item/flash/proc/flash_recharge()
	//Every ten seconds the flash doesn't get used, the times_used variable goes down by one, making the flash less likely to burn out,
	// as well as being able to flash more before reaching max_flashes cap.
	for(var/i=0, i < max_flashes, i++)
		if(last_used + 10 SECONDS > world.time)
			break

		else if(use_external_power)
			var/obj/item/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg or rig!
				break

		else if(!power_supply || !power_supply.checked_use(charge_cost))
			break

		last_used += 10 SECONDS
		times_used--

	last_used = world.time
	times_used = max(0,round(times_used)) //sanity
	update_icon()

// Returns true if the device can flash.
/obj/item/flash/proc/check_capacitor(var/mob/user)
	//spamming the flash before it's fully charged (60 seconds) increases the chance of it breaking
	//It will never break on the first use.
	var/obj/item/cell/battery = power_supply

	if(use_external_power)
		battery = get_external_power_supply()

	if(times_used <= max_flashes && battery && battery.charge >= charge_cost)
		last_used = world.time
		if(prob( max(0, times_used - safe_flashes) * 2 + (times_used >= safe_flashes)) && can_break)	//if you use it 10 times in a minute it has a 30% chance to break.
			broken = TRUE
			if(user)
				to_chat(user, span_warning("The bulb has burnt out!"))
			update_icon()
			return FALSE
		else
			times_used++
			update_icon()
			return TRUE
	else if(!charge_only)	//can only use it 10 times a minute, unless it runs purely on charge.
		if(user)
			update_icon()
			to_chat(user, span_warning(span_italics("click")))
			playsound(src, 'sound/weapons/empty.ogg', 80, 1)
		return FALSE
	else if(battery && battery.checked_use(charge_cost + (round(charge_cost / 4) * max(0, times_used - max_flashes)))) // Using over your maximum flashes starts taking more charge per added flash.
		times_used++
		update_icon()
		return TRUE

//attack_as_weapon
/obj/item/flash/attack(mob/living/M, mob/living/user, var/target_zone)
	if(!user || !M)	return	//sanity

	add_attack_logs(user,M,"Flashed (attempt) with [src]")

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(M)

	if(!clown_check(user))	return
	if(broken)
		to_chat(user, span_warning("\The [src] is broken."))
		return

	flash_recharge()

	if(!check_capacitor(user))
		return

	playsound(src, 'sound/weapons/flash.ogg', 100, 1)
	var/flashfail = 0

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.nif && H.nif.flag_check(NIF_V_FLASHPROT,NIF_FLAGS_VISION))
			flashfail = 1
			H.nif.notify("High intensity light detected, and blocked!",TRUE)
		if(FLASHPROOF in H.mutations)
			flashfail = 1

	if(iscarbon(M) && !flashfail) //VOREStation Add - NIF
		var/mob/living/carbon/C = M
		if(C.stat != DEAD)
			var/safety = C.eyecheck()
			if(safety <= 0)
				var/flash_strength = 10 //Vorestation edit, making flashes behave the same as flash rounds
				if(ishuman(C))
					var/mob/living/carbon/human/H = C
					flash_strength *= H.species.flash_mod

					if(flash_strength > 0)
						H.Confuse(flash_strength + 5)
						H.Blind(flash_strength)
						H.eye_blurry = max(H.eye_blurry, flash_strength + 5)
						H.flash_eyes()
						H.adjustHalLoss(halloss_per_flash * (flash_strength / 5)) // Should take four flashes to stun.
						H.apply_damage(flash_strength * H.species.flash_burn/5, BURN, BP_HEAD, 0, 0)

			else
				flashfail = 1

	else if(issilicon(M))
		flashfail = 0
		var/mob/living/silicon/S = M
		if(isrobot(S))
			var/mob/living/silicon/robot/R = S
			if(R.has_active_type(/obj/item/borg/combat/shield))
				var/obj/item/borg/combat/shield/shield = locate() in R
				if(shield)
					if(shield.active)
						shield.adjust_flash_count(R, 1)
						flashfail = 1
	else
		flashfail = 1

	if(isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	if(!flashfail)
		flick("flash2", src)
		if(!issilicon(M))

			user.visible_message(span_disarm("[user] blinds [M] with the flash!"))
		else

			user.visible_message(span_notice("[user] overloads [M]'s sensors with the flash!"))
			M.Weaken(rand(5,10))
	else

		user.visible_message(span_notice("[user] fails to blind [M] with the flash!"))

	return




/obj/item/flash/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user || !clown_check(user)) 	return

	user.setClickCooldown(user.get_attack_speed(src))

	if(broken)
		user.show_message(span_warning("The [src.name] is broken"), 2)
		return

	flash_recharge()

	if(!check_capacitor(user))
		return

	playsound(src, 'sound/weapons/flash.ogg', 100, 1)
	flick("flash2", src)
	if(user && isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	for(var/mob/living/carbon/C in oviewers(3, null))
		var/safety = C.eyecheck()
		if(!safety)
			if(!C.blinded)
				C.flash_eyes()

	return

/obj/item/flash/emp_act(severity)
	if(broken)	return
	flash_recharge()
	if(!check_capacitor())
		return

	if(istype(loc, /mob/living/carbon))
		var/mob/living/carbon/C = loc
		var/safety = C.eyecheck()
		if(safety <= 0)
			C.adjustHalLoss(halloss_per_flash)
			//C.Weaken(10)
			C.flash_eyes()
			for(var/mob/M in viewers(C, null))
				M.show_message(span_disarm("[C] is blinded by the flash!"))
	..()

/obj/item/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution."
	icon_state = "sflash"
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)
	base_icon = "sflash"
	can_repair = FALSE

//attack_as_weapon
/obj/item/flash/synthetic/attack(mob/living/M, mob/living/user, var/target_zone)
	..()
	if(!broken)
		broken = 1
		to_chat(user, span_warning("The bulb has burnt out!"))
		update_icon()

/obj/item/flash/synthetic/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	..()
	if(!broken)
		broken = 1
		to_chat(user, span_warning("The bulb has burnt out!"))
		update_icon()

/obj/item/flash/robot
	name = "mounted flash"
	can_break = FALSE
	use_external_power = TRUE
	charge_only = TRUE
