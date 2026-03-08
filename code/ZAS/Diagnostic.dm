ADMIN_VERB(Zone_Info, R_HOST, "ZAS Zone Info", "Prints the ZAS information of the zone (Only use on a test server).", ADMIN_CATEGORY_MAPPING_ZAS, turf/T)
	if(T)
		if(istype(T,/turf/simulated) && T:zone)
			T:zone:dbg_data(user)
		else
			to_chat(user, span_debug_warning("No zone here."))
			var/datum/gas_mixture/mix = T.return_air()
			to_chat(user, span_debug_info("[mix.return_pressure()] kPa [mix.temperature]C"))
			for(var/g in mix.gas)
				to_chat(user, span_debug_info("[g]: [mix.gas[g]]\n"))
	else
		if(user.zone_debug_images)
			for(var/zone in user.zone_debug_images)
				user.images -= user.zone_debug_images[zone]
			user.zone_debug_images = null

/client/var/list/zone_debug_images

ADMIN_VERB(Test_ZAS_Connection, R_HOST, "Test ZAS Connection", "Tests the ZAS zone connection (Only use on a test server).", ADMIN_CATEGORY_MAPPING_ZAS, turf/simulated/T)
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
	var/direction = tgui_input_list(user, "What direction do you wish to test?","Set direction", direction_list)
	if(!direction)
		return

	if(direction == "N/A")
		if(!(T.self_airblock() & AIR_BLOCKED))
			to_chat(user, span_debug_info("The turf can pass air! :D"))
		else
			to_chat(user, span_debug_warning("No air passage :x"))
		return

	var/turf/simulated/other_turf = get_step(T, direction_list[direction])
	if(!istype(other_turf))
		return

	var/t_block = T.c_airblock(other_turf)
	var/o_block = other_turf.c_airblock(T)

	if(o_block & AIR_BLOCKED)
		if(t_block & AIR_BLOCKED)
			to_chat(user, span_debug_warning("Neither turf can connect. :("))

		else
			to_chat(user, span_debug_warning("The initial turf only can connect. :\\"))
	else
		if(t_block & AIR_BLOCKED)
			to_chat(user, span_debug_warning("The other turf can connect, but not the initial turf. :/"))

		else
			to_chat(user, span_debug_info("Both turfs can connect! :)"))

	to_chat(user, span_debug_info("Additionally, \..."))

	if(o_block & ZONE_BLOCKED)
		if(t_block & ZONE_BLOCKED)
			to_chat(user, span_debug_warning("neither turf can merge."))
		else
			to_chat(user, span_debug_warning("the other turf cannot merge."))
	else
		if(t_block & ZONE_BLOCKED)
			to_chat(user, span_debug_warning("the initial turf cannot merge."))
		else
			to_chat(user, span_debug_warning("both turfs can merge."))

ADMIN_VERB(ZASSettings, R_ADMIN, "ZAS Settings", "Access the ZAS settings.", ADMIN_CATEGORY_DEBUG_DANGEROUS, turf/simulated/T)
	GLOB.vsc.SetDefault(user.mob)
