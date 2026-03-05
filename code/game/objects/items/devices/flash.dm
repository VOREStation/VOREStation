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

	///Number of times it's been used.
	var/times_used = 0
	//Is the flash burnt out?
	var/broken = FALSE
	///last world.time it was used.
	var/last_used = 0
	///How many times the flash can be used before needing to self recharge.
	var/max_flashes = 10
	///Halloss damage per flash.
	var/halloss_per_flash = 60
	/// The percent to break increased by every use on the flash.
	var/break_mod = 3

	/// If the flash can break or not
	var/can_break = TRUE
	/// If the flash can be repaired or not.
	var/can_repair = TRUE

	/// If the flash can only be used once before breaking
	var/one_use = FALSE

	var/safe_flashes = 2 // How many flashes are kept in 1% breakchance?

	var/charge_only = FALSE // Does the flash run purely on charge?

	var/base_icon = "flash"

	var/obj/item/cell/power_supply //What type of power cell this uses
	var/charge_cost = 30 //How much energy is needed to flash.
	var/use_external_power = FALSE // Do we use charge from an external source?

	var/cell_type = /obj/item/cell/device

	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/flash/Initialize(mapload)
	. = ..()
	power_supply = new cell_type(src)

/obj/item/flash/attackby(var/obj/item/W, var/mob/user)
	if(W.has_tool_quality(TOOL_SCREWDRIVER) && broken)
		user.visible_message(span_infoplain(span_bold("\The [user]") + " starts trying to repair \the [src]'s bulb."))
		if(do_after(user, (40 SECONDS + rand(0, 20 SECONDS)) * W.toolspeed, target = src) && can_repair)
			if(prob(30))
				user.visible_message(span_notice("\The [user] successfully repairs \the [src]!"))
				broken = FALSE
				update_icon()
			playsound(src, W.usesound, 50, 1)
		else
			user.visible_message(span_infoplain(span_bold("\The [user]") + " fails to repair \the [src]."))
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
	if(user && CLUMSY_FAIL_CHANCE(user))
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
/obj/item/flash/proc/check_capacitor(mob/user)
	//spamming the flash before it's fully charged (60 seconds) increases the chance of it breaking
	//It will never break on the first use.
	var/obj/item/cell/battery = power_supply

	if(use_external_power)
		battery = get_external_power_supply()

	if(times_used <= max_flashes && battery && battery.charge >= charge_cost)
		last_used = world.time
		if(one_use)
			broken = TRUE
			if(user)
				to_chat(user, span_warning("The bulb has burnt out!"))
			update_icon()
			return TRUE
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
/obj/item/flash/attack(mob/living/target, mob/living/user, var/target_zone)
	if(!user || !target)	return	//sanity

	add_attack_logs(user,target,"Flashed (attempt) with [src]")

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(target)

	if(!clown_check(user))	return
	if(broken)
		to_chat(user, span_warning("\The [src] is broken."))
		return

	flash_recharge()

	if(!check_capacitor(user))
		return

	playsound(src, 'sound/weapons/flash.ogg', 100, 1)

	if(isrobot(user))
		var/atom/movable/overlay/animation = new(user.loc)
		animation.layer = user.layer + 1
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = user
		flick("blspell", animation)
		QDEL_IN(animation, 5)

	if(attempt_flash(target))
		flick("flash2", src)
		if(issilicon(target))
			user.visible_message(span_notice("[user] overloads [target]'s sensors with the flash!"))
		else
			user.visible_message(span_disarm("[user] blinds [target] with the flash!"))
		return
	//fail message
	user.visible_message(span_notice("[user] fails to blind [target] with the flash!"))
	return

/// Sees if we can flash the target and if so, does the effects of it.
/// Returns TRUE if the flash went through, FALSE otherwise.
/obj/item/flash/proc/attempt_flash(mob/living/target)
	if(!istype(target))
		return FALSE
	if(target.stat == DEAD) //no point, they're already gone.
		return FALSE
	if(FLASHPROOF in target.mutations)
		return FALSE
	var/flash_strength = 5
	var/flash_burn = 0

	//Flashes can only flash THREE things: Humans, Silicons, and Robots. NOTHING ELSE!!!
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.nif && human_target.nif.flag_check(NIF_V_FLASHPROT,NIF_FLAGS_VISION))
			human_target.nif.notify("High intensity light detected, and blocked!",TRUE)
			return FALSE

		var/safety = human_target.eyecheck()
		if(safety <= 0)
			flash_strength = flash_strength * human_target.species.flash_mod
			flash_burn = human_target.species.flash_burn
		else
			return FALSE

	else if(issilicon(target))
		if(isrobot(target))
			var/mob/living/silicon/robot/R = target
			if(R.has_active_type(/obj/item/borg/combat/shield))
				var/obj/item/borg/combat/shield/shield = locate() in R
				if(shield)
					if(shield.active)
						shield.adjust_flash_count(R, 1)
						return FALSE
		target.Weaken(rand(5,10))
		return TRUE
	else
		return FALSE

	//Now do all the actual effects.
	target.Confuse(flash_strength + 5)
	target.Blind(flash_strength)
	target.eye_blurry = max(target.eye_blurry, flash_strength + 5)
	target.flash_eyes()
	target.adjustHalLoss(halloss_per_flash * (flash_strength / 5)) // Should take two flashes to stun.
	if(flash_burn)
		target.apply_damage(flash_burn * (flash_strength/5), BURN, BP_HEAD, 0)
	return TRUE


/obj/item/flash/attack_self(mob/living/carbon/user, flag = 0, emp = 0)
	. = ..(user)
	if(.)
		return TRUE
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
		var/atom/movable/overlay/animation = new(user.loc)
		animation.layer = user.layer + 1
		animation.icon_state = "blank"
		animation.icon = 'icons/mob/mob.dmi'
		animation.master = user
		flick("blspell", animation)
		QDEL_IN(animation, 5)

	for(var/mob/living/carbon/C in oviewers(3, null))
		var/safety = C.eyecheck()
		if(!safety)
			if(!C.blinded)
				C.flash_eyes()

	return

/obj/item/flash/emp_act(severity, recursive)
	if(broken)	return
	flash_recharge()
	if(!check_capacitor())
		return

	if(istype(loc, /mob/living/carbon))
		var/mob/living/carbon/C = loc
		var/safety = C.eyecheck()
		if(safety <= 0)
			C.adjustHalLoss(halloss_per_flash)
			C.flash_eyes()
			C.visible_message(span_disarm("[C] is blinded by the flash!"), span_danger("You're blinded by the flash!"), span_warning("You hear the sound of a flash!"))
	..()

/obj/item/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution."
	icon_state = "sflash"
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)
	base_icon = "sflash"
	can_repair = FALSE
	one_use = TRUE

/obj/item/flash/robot
	name = "mounted flash"
	can_break = FALSE
	use_external_power = TRUE
	charge_only = TRUE
