/client/proc/ZoneTick()
	set category = "Debug.Misc"
	set name = "Process Atmos"
	set desc = "Manually run a single tick of the air subsystem"

	// TODO - This might be a useful diagnostic tool.  However its complicated to do with StonedMC
	// Therefore it is left unimplemented for now until its use actually becomes required. ~Leshana
	/*
	if(!check_rights(R_DEBUG)) return

	var/result = SSair.Tick()
	if(result)
		to_chat(src, "Successfully Processed.")

	else
		to_chat(src, "Failed to process! ([SSair.tick_progress])")
	*/

/client/proc/Zone_Info(turf/T as null|turf)
	set category = "Debug.Misc"
	if(T)
		if(istype(T,/turf/simulated) && T:zone)
			T:zone:dbg_data(src)
		else
			to_chat(mob, "No zone here.")
			var/datum/gas_mixture/mix = T.return_air()
			to_chat(mob, "[mix.return_pressure()] kPa [mix.temperature]C")
			for(var/g in mix.gas)
				to_chat(mob, "[g]: [mix.gas[g]]\n")
	else
		if(zone_debug_images)
			for(var/zone in  zone_debug_images)
				images -= zone_debug_images[zone]
			zone_debug_images = null

/client/var/list/zone_debug_images

/client/proc/Test_ZAS_Connection(var/turf/simulated/T as turf)
	set category = "Debug.Misc"
	if(!istype(T))
		return

	var/direction_list = list(\
	"North" = NORTH,\
	"South" = SOUTH,\
	"East" = EAST,\
	"West" = WEST,\
	#ifdef MULTIZAS
	"Up" = UP,\
	"Down" = DOWN,\
	#endif
	"N/A" = null)
	var/direction = tgui_input_list(usr, "What direction do you wish to test?","Set direction", direction_list)
	if(!direction)
		return

	if(direction == "N/A")
		if(!(T.self_airblock() & AIR_BLOCKED))
			to_chat(mob, "The turf can pass air! :D")
		else
			to_chat(mob, "No air passage :x")
		return

	var/turf/simulated/other_turf = get_step(T, direction_list[direction])
	if(!istype(other_turf))
		return

	var/t_block = T.c_airblock(other_turf)
	var/o_block = other_turf.c_airblock(T)

	if(o_block & AIR_BLOCKED)
		if(t_block & AIR_BLOCKED)
			to_chat(mob, "Neither turf can connect. :(")

		else
			to_chat(mob, "The initial turf only can connect. :\\")
	else
		if(t_block & AIR_BLOCKED)
			to_chat(mob, "The other turf can connect, but not the initial turf. :/")

		else
			to_chat(mob, "Both turfs can connect! :)")

	to_chat(mob, "Additionally, \...")

	if(o_block & ZONE_BLOCKED)
		if(t_block & ZONE_BLOCKED)
			to_chat(mob, "neither turf can merge.")
		else
			to_chat(mob, "the other turf cannot merge.")
	else
		if(t_block & ZONE_BLOCKED)
			to_chat(mob, "the initial turf cannot merge.")
		else
			to_chat(mob, "both turfs can merge.")

/client/proc/ZASSettings()
	set category = "Debug.Dangerous"

	vsc.SetDefault(mob)
