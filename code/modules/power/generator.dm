GLOBAL_LIST_EMPTY(all_turbines)

/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon_state = "teg-unassembled"
	density = TRUE
	anchored = FALSE
	unacidable = TRUE

	use_power = USE_POWER_IDLE
	idle_power_usage = 100 //Watts, I hope.  Just enough to do the computer and display things.

	var/max_power = 500000
	var/thermal_efficiency = 0.65

	var/obj/machinery/atmospherics/binary/circulator/circ1
	var/obj/machinery/atmospherics/binary/circulator/circ2

	var/last_circ1_gen = 0
	var/last_circ2_gen = 0
	var/last_thermal_gen = 0
	var/stored_energy = 0
	var/lastgen1 = 0
	var/lastgen2 = 0
	var/effective_gen = 0
	var/lastgenlev = 0
	var/datum/looping_sound/generator/soundloop

/obj/machinery/power/generator/Initialize()
	soundloop = new(list(src), FALSE)
	desc = initial(desc) + " Rated for [round(max_power/1000)] kW."
	GLOB.all_turbines += src
	..() //Not returned, because...
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/power/generator/LateInitialize()
	reconnect()

/obj/machinery/power/generator/Destroy()
	QDEL_NULL(soundloop)
	GLOB.all_turbines -= src
	return ..()

//generators connect in dir and reverse_dir(dir) directions
//mnemonic to determine circulator/generator directions: the cirulators orbit clockwise around the generator
//so a circulator to the NORTH of the generator connects first to the EAST, then to the WEST
//and a circulator to the WEST of the generator connects first to the NORTH, then to the SOUTH
//note that the circulator's outlet dir is it's always facing dir, and it's inlet is always the reverse
/obj/machinery/power/generator/proc/reconnect()
	circ1 = null
	circ2 = null
	if(src.loc && anchored)
		if(src.dir & (EAST|WEST))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,WEST)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,EAST)

			if(circ1 && circ2)
				if(circ1.dir != NORTH || circ2.dir != SOUTH)
					circ1 = null
					circ2 = null

		else if(src.dir & (NORTH|SOUTH))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,NORTH)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,SOUTH)

			if(circ1 && circ2 && (circ1.dir != EAST || circ2.dir != WEST))
				circ1 = null
				circ2 = null

/obj/machinery/power/generator/update_icon()
	icon_state = anchored ? "teg-assembled" : "teg-unassembled"
	cut_overlays()
	if (circ1)
		circ1.temperature_overlay = null
	if (circ2)
		circ2.temperature_overlay = null
	if (stat & (NOPOWER|BROKEN))
		return 1
	else
		if (lastgenlev != 0)
			add_overlay("teg-op[lastgenlev]")
			if (circ1 && circ2)
				var/extreme = (lastgenlev > 9) ? "ex" : ""
				if (circ1.last_temperature < circ2.last_temperature)
					circ1.temperature_overlay = "circ-[extreme]cold"
					circ2.temperature_overlay = "circ-[extreme]hot"
				else
					circ1.temperature_overlay = "circ-[extreme]hot"
					circ2.temperature_overlay = "circ-[extreme]cold"
		return 1

/obj/machinery/power/generator/process()
	if(!circ1 || !circ2 || !anchored || stat & (BROKEN|NOPOWER))
		stored_energy = 0
		return

	updateDialog()

	var/datum/gas_mixture/air1 = circ1.return_transfer_air()
	var/datum/gas_mixture/air2 = circ2.return_transfer_air()

	lastgen2 = lastgen1
	lastgen1 = 0
	last_thermal_gen = 0
	last_circ1_gen = 0
	last_circ2_gen = 0

	if(air1 && air2)
		var/air1_heat_capacity = air1.heat_capacity()
		var/air2_heat_capacity = air2.heat_capacity()
		var/delta_temperature = abs(air2.temperature - air1.temperature)

		if(delta_temperature > 0 && air1_heat_capacity > 0 && air2_heat_capacity > 0)
			var/energy_transfer = delta_temperature*air2_heat_capacity*air1_heat_capacity/(air2_heat_capacity+air1_heat_capacity)
			var/heat = energy_transfer*(1-thermal_efficiency)
			last_thermal_gen = energy_transfer*thermal_efficiency

			if(air2.temperature > air1.temperature)
				air2.temperature = air2.temperature - energy_transfer/air2_heat_capacity
				air1.temperature = air1.temperature + heat/air1_heat_capacity
			else
				air2.temperature = air2.temperature + heat/air2_heat_capacity
				air1.temperature = air1.temperature - energy_transfer/air1_heat_capacity

	//Transfer the air
	if (air1)
		circ1.air2.merge(air1)
	if (air2)
		circ2.air2.merge(air2)

	//Update the gas networks
	if(circ1.network2)
		circ1.network2.update = 1
	if(circ2.network2)
		circ2.network2.update = 1

	//Exceeding maximum power leads to some power loss
	if(effective_gen > max_power && prob(5))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		stored_energy *= 0.5

	//Power
	last_circ1_gen = circ1.return_stored_energy()
	last_circ2_gen = circ2.return_stored_energy()
	stored_energy += last_thermal_gen + last_circ1_gen + last_circ2_gen
	lastgen1 = stored_energy*0.4 //smoothened power generation to prevent slingshotting as pressure is equalized, then restored by pumps
	stored_energy -= lastgen1
	effective_gen = (lastgen1 + lastgen2) / 2

	// Sounds.
	if(effective_gen > (max_power * 0.05)) // More than 5% and sounds start.
		soundloop.start()
		soundloop.volume = LERP(1, 40, effective_gen / max_power)
	else
		soundloop.stop()

	// update icon overlays and power usage only if displayed level has changed
	var/genlev = max(0, min( round(11*effective_gen / max_power), 11))
	if(effective_gen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
		update_icon()
	add_avail(effective_gen)

/obj/machinery/power/generator/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/power/generator/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 75, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet.")
		update_use_power(anchored ? USE_POWER_IDLE : USE_POWER_ACTIVE)
		if(anchored) // Powernet connection stuff.
			connect_to_network()
		else
			disconnect_from_network()
		reconnect()
		lastgenlev = 0
		effective_gen = 0
		update_icon()
	else
		..()

/obj/machinery/power/generator/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER) || !anchored) return
	if(!circ1 || !circ2) //Just incase the middle part of the TEG was not wrenched last.
		reconnect()
	tgui_interact(user)

/obj/machinery/power/generator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TEGenerator", name)
		ui.open()

/obj/machinery/power/generator/tgui_data(mob/user)
	// this is the data which will be sent to the ui
	var/vertical = 0
	if (dir == NORTH || dir == SOUTH)
		vertical = 1

	var/list/data = list()
	data["totalOutput"] = effective_gen
	data["maxTotalOutput"] = max_power
	data["thermalOutput"] = last_thermal_gen

	data["primary"] = list()
	if(circ1)
		//The one on the left (or top)
		data["primary"]["dir"] = vertical ? "top" : "left"
		data["primary"]["output"] = last_circ1_gen
		data["primary"]["flowCapacity"] = circ1.volume_capacity_used*100
		data["primary"]["inletPressure"] = circ1.air1.return_pressure()
		data["primary"]["inletTemperature"] = circ1.air1.temperature
		data["primary"]["outletPressure"] = circ1.air2.return_pressure()
		data["primary"]["outletTemperature"] = circ1.air2.temperature

	data["secondary"] = list()
	if(circ2)
		//Now for the one on the right (or bottom)
		data["secondary"]["dir"] = vertical ? "bottom" : "right"
		data["secondary"]["output"] = last_circ2_gen
		data["secondary"]["flowCapacity"] = circ2.volume_capacity_used*100
		data["secondary"]["inletPressure"] = circ2.air1.return_pressure()
		data["secondary"]["inletTemperature"] = circ2.air1.temperature
		data["secondary"]["outletPressure"] = circ2.air2.return_pressure()
		data["secondary"]["outletTemperature"] = circ2.air2.temperature

	return data

/obj/machinery/power/generator/power_change()
	..()
	update_icon()


/obj/machinery/power/generator/verb/rotate_clockwise()
	set category = "Object"
	set name = "Rotate Generator Clockwise"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, 270))

/obj/machinery/power/generator/verb/rotate_counterclockwise()
	set category = "Object"
	set name = "Rotate Generator Counterclockwise"
	set src in view(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, 90))

/obj/machinery/power/generator/power_spike(var/announce_prob = 30)
	if(!(effective_gen >= max_power / 2 && powernet)) // Don't make a spike if we're not making a whole lot of power.
		return

	var/list/powernet_union = powernet.nodes.Copy()
	for(var/obj/machinery/power/terminal/T in powernet.nodes)
		if(T.master && istype(T.master, /obj/machinery/power/smes))
			var/obj/machinery/power/smes/S = T.master
			powernet_union |= S.powernet.nodes

	var/found_grid_checker = FALSE
	for(var/obj/machinery/power/grid_checker/G in powernet_union)
		G.power_failure(announce_prob) // If we found a grid checker, then all is well.
		found_grid_checker = TRUE
	if(!found_grid_checker) // Otherwise lets break some stuff.
		spawn(1)
			command_announcement.Announce("Dangerous power spike detected in the power network.  Please check machinery \
			for electrical damage.",
			"Critical Power Overload")
			var/i = 0
			var/limit = rand(30, 50)
			for(var/obj/machinery/power/P in powernet_union)
				P.overload(src)
				i++
				if(i % 5)
					sleep(1)
				if(i >= limit)
					break

