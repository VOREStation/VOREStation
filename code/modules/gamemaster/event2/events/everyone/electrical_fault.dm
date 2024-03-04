// Makes a spooky electrical thing happen, that can blow the lights or make the APCs turn off for a short period of time.
// Doesn't do any permanent damage beyond the small chance to emag an APC, which just unlocks it forever. As such, this is free to occur even with no engineers.
// Since this is an 'external' thing, the Grid Checker can't stop it.

/datum/event2/meta/electrical_fault
	name = "electrical fault"
	departments = list(DEPARTMENT_EVERYONE)
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	event_type = /datum/event2/event/electrical_fault

/datum/event2/meta/electrical_fault/get_weight()
	return 10 + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 5)


/datum/event2/event/electrical_fault
	start_delay_lower_bound = 30 SECONDS
	start_delay_upper_bound = 1 MINUTE
	length_lower_bound = 20 SECONDS
	length_upper_bound = 40 SECONDS
	var/max_apcs_per_tick = 6

	var/list/valid_apcs = null
	var/list/valid_z_levels = null

	var/apcs_disabled = 0
	var/apcs_overloaded = 0
	var/apcs_emagged = 0

/datum/event2/event/electrical_fault/announce()
	// Trying to be vague to avoid 'space lightning storms'.
	// This could be re-flavored to be a solar flare or something and have robots outside be sad.
	command_announcement.Announce("External conditions near \the [location_name()] are likely \
	to cause voltage spikes and other electrical issues very soon. Please secure sensitive electrical equipment until the situation passes.", "[location_name()] Sensor Array")

/datum/event2/event/electrical_fault/set_up()
	valid_z_levels = get_location_z_levels()
	valid_z_levels -= using_map.sealed_levels // Space levels only please!

	valid_apcs = list()
	for(var/obj/machinery/power/apc/A in GLOB.apcs)
		if(A.z in valid_z_levels)
			valid_apcs += A

/datum/event2/event/electrical_fault/start()
	command_announcement.Announce("Irregularities detected in \the [location_name()] power grid.", "[location_name()] Power Grid Monitoring")

/datum/event2/event/electrical_fault/event_tick()
	if(!valid_apcs.len)
		log_debug("ELECTRICAL EVENT: No valid APCs found for electrical fault event. Aborting.")
		abort()
		return

	var/list/picked_apcs = list()
	for(var/i = 1 to max_apcs_per_tick)
		picked_apcs |= pick(valid_apcs)

	for(var/A in picked_apcs)
		affect_apc(A)

/datum/event2/event/electrical_fault/end()
	command_announcement.Announce("The irregular electrical conditions inside \the [location_name()] power grid has ceased.", "[location_name()] Power Grid Monitoring")
	log_debug("Electrical Fault event caused [apcs_disabled] APC\s to shut off, \
	[apcs_overloaded] APC\s to overload lighting, and [apcs_emagged] APC\s to be emagged.")

/datum/event2/event/electrical_fault/proc/affect_apc(obj/machinery/power/apc/A)
	// Main breaker is turned off or is Special(tm). Consider it protected.
	// Important APCs like the AI or the engine core shouldn't get shut off by this event.
	if((!A.operating || A.failure_timer > 0) || A.is_critical)
		return

	// In reality this would probably make the lights get brighter but oh well.
	for(var/obj/machinery/light/L in get_area(A))
		L.flicker(rand(10, 20))

	// Chance to make the APC turn off for awhile.
	// This will actually protect it from further damage.
	if(prob(25))
		A.energy_fail(rand(60, 120))
//		log_debug("ELECTRICAL EVENT: Disabled \the [A]'s power for a temporary amount of time.")
		playsound(A, 'sound/machines/defib_success.ogg', 50, 1)
		apcs_disabled++
		return

	// Decent chance to overload lighting circuit.
	if(prob(30))
		A.overload_lighting()
//		log_debug("ELECTRICAL EVENT: Overloaded \the [A]'s lighting.")
		playsound(A, 'sound/effects/lightningshock.ogg', 50, 1)
		apcs_overloaded++

	// Relatively small chance to emag the apc as apc_damage event does.
	if(prob(5))
		A.emagged = TRUE
		A.update_icon()
//		log_debug("ELECTRICAL EVENT: Emagged \the [A].")
		playsound(A, 'sound/machines/chime.ogg', 50, 1)
		apcs_emagged++

