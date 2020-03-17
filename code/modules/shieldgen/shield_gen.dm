/obj/machinery/shield_gen
	name = "bubble shield generator"
	desc = "A machine that generates a field of energy optimized for blocking meteorites when activated."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "generator0"
	var/active = 0
	var/field_radius = 3
	var/max_field_radius = 150
	var/list/field = list()
	density = 1
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
	use_power = 0	//doesn't use APC power

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
	if(istype(W, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/C = W
		if(access_captain in C.access || access_security in C.access || access_engine in C.access)
			src.locked = !src.locked
			to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
			updateDialog()
		else
			to_chat(user, "<font color='red'>Access denied.</font>")
	else if(W.is_wrench())
		src.anchored = !src.anchored
		playsound(src, W.usesound, 75, 1)
		src.visible_message("<font color='blue'>[bicon(src)] [src] has been [anchored?"bolted to the floor":"unbolted from the floor"] by [user].</font>")

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
	interact(user)

/obj/machinery/shield_gen/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN)) )
		if (!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=shield_generator")
			return
	var/t = "<B>Shield Generator Control Console</B><BR><br>"
	if(locked)
		t += "<i>Swipe your ID card to begin.</i>"
	else
		t += "[capacitors.len ? "<font color=green>Charge capacitor(s) connected.</font>" : "<font color=red>Unable to locate charge capacitor!</font>"]<br>"
		var/i = 0
		for(var/obj/machinery/shield_capacitor/capacitor in capacitors)
			i++
			t += "Capacitor #[i]: [capacitor.active ? "<font color=green>Online.</font>" : "<font color=red>Offline.</font>"] \
			Charge: [round(capacitor.stored_charge/1000, 0.1)] kJ ([100 * round(capacitor.stored_charge/capacitor.max_charge, 0.01)]%) \
			Status: [capacitor.time_since_fail > 2 ? "<font color=green>OK.</font>" : "<font color=red>Discharging!</font>"]<br>"
		t += "This generator is: [active ? "<font color=green>Online</font>" : "<font color=red>Offline</font>" ] <a href='?src=\ref[src];toggle=1'>[active ? "\[Deactivate\]" : "\[Activate\]"]</a><br>"
		t += "Field Status: [time_since_fail > 2 ? "<font color=green>Stable</font>" : "<font color=red>Unstable</font>"]<br>"
		t += "Coverage Radius (restart required): \
		<a href='?src=\ref[src];change_radius=-50'>---</a> \
		<a href='?src=\ref[src];change_radius=-5'>--</a> \
		<a href='?src=\ref[src];change_radius=-1'>-</a> \
		[field_radius] m \
		<a href='?src=\ref[src];change_radius=1'>+</a> \
		<a href='?src=\ref[src];change_radius=5'>++</a> \
		<a href='?src=\ref[src];change_radius=50'>+++</a><br>"
		if(HasAbove(src.z) || HasBelow(src.z)) // Won't show up on maps lacking MultiZ support.
			t += "Vertical Shielding (restart required): \
			<a href='?src=\ref[src];z_range=-1'>-</a> \
			[z_range] Vertical Range \
			<a href='?src=\ref[src];z_range=1'>+</a><br>"
		t += "Overall Field Strength: [round(average_field_strength, 0.01)] Renwick ([target_field_strength ? round(100 * average_field_strength / target_field_strength, 0.1) : "NA"]%)<br>"
		t += "Upkeep Power: [format_SI(round(field.len * max(average_field_strength * dissipation_rate, min_dissipation) / energy_conversion_rate), "W")]<br>"
		t += "Charge Rate: <a href='?src=\ref[src];strengthen_rate=-0.1'>--</a> \
		[strengthen_rate] Renwick/s \
		<a href='?src=\ref[src];strengthen_rate=0.1'>++</a><br>"
		t += "Shield Generation Power: [format_SI(round(field.len * min(strengthen_rate, target_field_strength - average_field_strength) / energy_conversion_rate), "W")]<br>"
		t += "Maximum Field Strength: \
		<a href='?src=\ref[src];target_field_strength=-10'>\[min\]</a> \
		<a href='?src=\ref[src];target_field_strength=-5'>--</a> \
		<a href='?src=\ref[src];target_field_strength=-1'>-</a> \
		[target_field_strength] Renwick \
		<a href='?src=\ref[src];target_field_strength=1'>+</a> \
		<a href='?src=\ref[src];target_field_strength=5'>++</a> \
		<a href='?src=\ref[src];target_field_strength=10'>\[max\]</a><br>"
	t += "<hr>"
	t += "<A href='?src=\ref[src]'>Refresh</A> "
	t += "<A href='?src=\ref[src];close=1'>Close</A><BR>"
	user << browse(t, "window=shield_generator;size=500x400")
	user.set_machine(src)

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

/obj/machinery/shield_gen/Topic(href, href_list[])
	..()
	if( href_list["close"] )
		usr << browse(null, "window=shield_generator")
		usr.unset_machine()
		return
	else if( href_list["toggle"] )
		if (!active && !anchored)
			to_chat(usr, "<font color='red'>The [src] needs to be firmly secured to the floor first.</font>")
			return
		toggle()
	else if( href_list["change_radius"] )
		field_radius = between(0, field_radius + text2num(href_list["change_radius"]), max_field_radius)
	else if( href_list["strengthen_rate"] )
		strengthen_rate = between(0,  strengthen_rate + text2num(href_list["strengthen_rate"]), max_strengthen_rate)
	else if( href_list["target_field_strength"] )
		target_field_strength = between(1, target_field_strength + text2num(href_list["target_field_strength"]), max_field_strength)
	else if( href_list["z_range"] )
		z_range = between(0, z_range + text2num(href_list["z_range"]), 10) // Max is extending ten z-levels up and down.  Probably too big of a number but it shouldn't matter.

	updateDialog()

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
			to_chat(M, "[bicon(src)] You hear heavy droning start up.")
		for(var/obj/effect/energy_field/E in field) // Update the icons here to ensure all the shields have been made already.
			E.update_icon()
	else
		for(var/obj/effect/energy_field/D in field)
			field.Remove(D)
			//D.loc = null
			qdel(D)

		for(var/mob/M in view(5,src))
			to_chat(M, "[bicon(src)] You hear heavy droning fade out.")

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
