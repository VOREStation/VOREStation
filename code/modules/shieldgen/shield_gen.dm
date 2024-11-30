/obj/machinery/shield_gen
	name = "bubble shield generator"
	desc = "A machine that generates a field of energy optimized for blocking meteorites when activated."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "generator0"
	var/active = 0
	var/field_radius = 3
	var/max_field_radius = 150
	var/list/field = list()
	density = TRUE
	var/locked = 0
	var/average_field_strength = 0
	var/strengthen_rate = 0.2
	var/max_strengthen_rate = 0.5	//the maximum rate that the generator can increase the average field strength
	var/dissipation_rate = 0.030	//the percentage of the shield strength that needs to be replaced each second
	var/min_dissipation = 0.01		//will dissipate by at least this rate in renwicks per field tile (otherwise field would never dissipate completely as dissipation is a percentage)
	var/powered = 0
	var/check_powered = 1
	var/list/capacitors = list()
	var/target_field_strength = 10
	var/max_field_strength = 10
	var/time_since_fail = 100
	var/energy_conversion_rate = 0.0006	//how many renwicks per watt?  Higher numbers equals more effiency.
	var/z_range = 0 // How far 'up and or down' to extend the shield to, in z-levels.  Only works on MultiZ supported z-levels.
	use_power = USE_POWER_OFF	//doesn't use APC power
	interact_offline = TRUE // don't check stat & NOPOWER|BROKEN for our UI. We check BROKEN ourselves.
	var/id //for button usage

/obj/machinery/shield_gen/advanced
	name = "advanced bubble shield generator"
	desc = "A machine that generates a field of energy optimized for blocking meteorites when activated.  This version comes with a more efficent shield matrix."
	energy_conversion_rate = 0.0012

/obj/machinery/shield_gen/Initialize()
	if(anchored)
		for(var/obj/machinery/shield_capacitor/cap in range(1, src))
			if(!cap.anchored)
				continue
			if(cap.owned_gen)
				continue
			if(get_dir(cap, src) == cap.dir)
				capacitors |= cap
				cap.owned_gen = src
	return ..()

/obj/machinery/shield_gen/Destroy()
	QDEL_LIST_NULL(field)
	return ..()

/obj/machinery/shield_gen/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		src.locked = !src.locked
		to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
		. = 1
		updateDialog()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()

/obj/machinery/shield_gen/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id))
		var/obj/item/card/id/C = W
		if((access_captain in C.GetAccess()) || (access_security in C.GetAccess()) || (access_engine in C.GetAccess()))
			src.locked = !src.locked
			to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
			updateDialog()
		else
			to_chat(user, span_red("Access denied."))
	else if(W.has_tool_quality(TOOL_WRENCH))
		src.anchored = !src.anchored
		playsound(src, W.usesound, 75, 1)
		src.visible_message(span_blue("[icon2html(src,viewers(src))] [src] has been [anchored?"bolted to the floor":"unbolted from the floor"] by [user]."))

		if(active)
			toggle()
		if(anchored)
			spawn(0)
				for(var/obj/machinery/shield_capacitor/cap in range(1, src))
					if(cap.owned_gen)
						continue
					if(get_dir(cap, src) == cap.dir && src.anchored)
					//	owned_capacitor = cap
						capacitors |= cap
						cap.owned_gen = src
						updateDialog()
					//	break
		else
			for(var/obj/machinery/shield_capacitor/capacitor in capacitors)
				capacitor.owned_gen = null
	else
		..()

/obj/machinery/shield_gen/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/shield_gen/attack_hand(mob/user)
	if(stat & (BROKEN))
		return
	tgui_interact(user)

/obj/machinery/shield_gen/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShieldGenerator", name)
		ui.open()

/obj/machinery/shield_gen/tgui_status(mob/user)
	if(stat & BROKEN)
		return STATUS_CLOSE
	return ..()

/obj/machinery/shield_gen/tgui_data(mob/user)
	var/list/lockedData = list()

	if(!locked)
		var/list/caps = list()
		for(var/obj/machinery/shield_capacitor/C in capacitors)
			caps.Add(list(list(
				"active" = C.active,
				"stored_charge" = C.stored_charge,
				"max_charge" = C.max_charge,
				"failing" = (C.time_since_fail <= 2),
			)))
		lockedData["capacitors"] = caps

		lockedData["active"] = active
		lockedData["failing"] = (time_since_fail <= 2)
		lockedData["radius"] = field_radius
		lockedData["max_radius"] = max_field_radius
		lockedData["z_range"] = z_range
		lockedData["max_z_range"] = 10
		lockedData["average_field_strength"] = average_field_strength
		lockedData["target_field_strength"] = target_field_strength
		lockedData["max_field_strength"] = max_field_strength
		lockedData["shields"] = LAZYLEN(field)
		lockedData["upkeep"] = round(field.len * max(average_field_strength * dissipation_rate, min_dissipation) / energy_conversion_rate)
		lockedData["strengthen_rate"] = strengthen_rate
		lockedData["max_strengthen_rate"] = max_strengthen_rate
		lockedData["gen_power"] = round(field.len * min(strengthen_rate, target_field_strength - average_field_strength) / energy_conversion_rate)

	return list("locked" = locked, "lockedData" = lockedData)

/obj/machinery/shield_gen/process()
	if (!anchored && active)
		toggle()

	average_field_strength = max(average_field_strength, 0)

	if(field.len)
		time_since_fail++
		var/total_renwick_increase = 0 //the amount of renwicks that the generator can add this tick, over the entire field
		var/renwick_upkeep_per_field = max(average_field_strength * dissipation_rate, min_dissipation)

		//figure out how much energy we need to draw from the capacitor
		if(active && capacitors.len)
			// Get a list of active capacitors to drain from.
			var/list/active_capacitors = list()
			for(var/obj/machinery/shield_capacitor/capacitor in capacitors) // Some capacitors might be off.  Exclude them.
				if(capacitor.active && capacitor.stored_charge > 0)
					active_capacitors |= capacitor

			var/target_renwick_increase = min(target_field_strength - average_field_strength, strengthen_rate) + renwick_upkeep_per_field //per field tile

			var/required_energy = field.len * target_renwick_increase / energy_conversion_rate

			// Gets the charge for all capacitors
			var/sum_charge = 0
			for(var/obj/machinery/shield_capacitor/capacitor in active_capacitors)
				sum_charge += capacitor.stored_charge

			var/assumed_charge = min(sum_charge, required_energy)
			total_renwick_increase = assumed_charge * energy_conversion_rate

			for(var/obj/machinery/shield_capacitor/capacitor in active_capacitors)
				capacitor.stored_charge -= max(assumed_charge / active_capacitors.len, 0) // Drain from all active capacitors evenly.

		else
			renwick_upkeep_per_field = max(renwick_upkeep_per_field, 0.5)

		var/renwick_increase_per_field = total_renwick_increase/field.len //per field tile

		average_field_strength = 0 //recalculate the average field strength
		for(var/obj/effect/energy_field/E in field)
			E.max_strength = target_field_strength
			var/amount_to_strengthen = renwick_increase_per_field - renwick_upkeep_per_field
			if(E.ticks_recovering > 0 && amount_to_strengthen > 0)
				E.adjust_strength( min(amount_to_strengthen / 10, 0.1), 0 )
				E.ticks_recovering -= 1
			else
				E.adjust_strength(amount_to_strengthen, 0)

			average_field_strength += E.strength

		average_field_strength /= field.len
		if(average_field_strength < 1)
			time_since_fail = 0
	else
		average_field_strength = 0

/obj/machinery/shield_gen/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("toggle")
			if (!active && !anchored)
				to_chat(ui.user, span_red("The [src] needs to be firmly secured to the floor first."))
				return
			toggle()
			. = TRUE
		if("change_radius")
			field_radius = clamp(text2num(params["val"]), 0, max_field_radius)
			. = TRUE
		if("strengthen_rate")
			strengthen_rate = clamp(text2num(params["val"]), 0, max_strengthen_rate)
			. = TRUE
		if("target_field_strength")
			target_field_strength = clamp(text2num(params["val"]), 1, max_field_strength)
			. = TRUE
		if("z_range")
			z_range = clamp(text2num(params["val"]), 0, 10)
			. = TRUE


/obj/machinery/shield_gen/ex_act(var/severity)
	if(active)
		toggle()
	return ..()

/obj/machinery/shield_gen/proc/toggle()
	set background = 1
	active = !active
	update_icon()
	if(active)
		var/list/covered_turfs = get_shielded_turfs()
		var/turf/T = get_turf(src)
		if(T in covered_turfs)
			covered_turfs.Remove(T)
		for(var/turf/O in covered_turfs)
			var/obj/effect/energy_field/E = new(O, src)
			field.Add(E)
		covered_turfs = null

		for(var/mob/M in view(5,src))
			to_chat(M, "[icon2html(src, M.client)] You hear heavy droning start up.")
		for(var/obj/effect/energy_field/E in field) // Update the icons here to ensure all the shields have been made already.
			E.update_icon()
	else
		for(var/obj/effect/energy_field/D in field)
			field.Remove(D)
			//D.loc = null
			qdel(D)

		for(var/mob/M in view(5,src))
			to_chat(M, "[icon2html(src, M.client)] You hear heavy droning fade out.")

/obj/machinery/shield_gen/update_icon()
	if(stat & BROKEN)
		icon_state = "broke"
		set_light(0)
	else
		if (src.active)
			icon_state = "generator1"
			set_light(4, 2, "#00CCFF")
		else
			icon_state = "generator0"
			set_light(0)

//grab the border tiles in a circle around this machine
/obj/machinery/shield_gen/proc/get_shielded_turfs()
	var/list/out = list()

	var/turf/T = get_turf(src)
	if (!T)
		return

	out += get_shielded_turfs_on_z_level(T)

	if(z_range)
		var/i = z_range
		while(HasAbove(T.z) && i)
			T = GetAbove(T)
			i--
			if(istype(T))
				out += get_shielded_turfs_on_z_level(T)

		T = get_turf(src)
		i = z_range

		while(HasBelow(T.z) && i)
			T = GetBelow(T)
			i--
			if(istype(T))
				out += get_shielded_turfs_on_z_level(T)

	return out

/obj/machinery/shield_gen/proc/get_shielded_turfs_on_z_level(var/turf/gen_turf)
	var/list/out = list()

	if (!gen_turf)
		return

	var/turf/T
	for (var/x_offset = -field_radius; x_offset <= field_radius; x_offset++)
		T = locate(gen_turf.x + x_offset, gen_turf.y - field_radius, gen_turf.z)
		if (T) out += T

		T = locate(gen_turf.x + x_offset, gen_turf.y + field_radius, gen_turf.z)
		if (T) out += T

	for (var/y_offset = -field_radius+1; y_offset < field_radius; y_offset++)
		T = locate(gen_turf.x - field_radius, gen_turf.y + y_offset, gen_turf.z)
		if (T) out += T

		T = locate(gen_turf.x + field_radius, gen_turf.y + y_offset, gen_turf.z)
		if (T) out += T

	return out
