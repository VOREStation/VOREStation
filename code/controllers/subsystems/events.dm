SUBSYSTEM_DEF(events)
	name = "Events"
	wait = 2 SECONDS

	var/tmp/list/currentrun = null

	var/list/datum/event/active_events = list()
	var/list/datum/event/finished_events = list()

	var/list/datum/event/allEvents
	var/list/datum/event_container/event_containers

	var/datum/event_meta/new_event = new

/datum/controller/subsystem/events/Initialize()
	allEvents = typesof(/datum/event) - /datum/event
	event_containers = list(
			EVENT_LEVEL_MUNDANE 	= new/datum/event_container/mundane,
			EVENT_LEVEL_MODERATE	= new/datum/event_container/moderate,
			EVENT_LEVEL_MAJOR 		= new/datum/event_container/major
		)
	if(global.using_map.use_overmap)
		GLOB.overmap_event_handler.create_events(global.using_map.overmap_z, global.using_map.overmap_size, global.using_map.overmap_event_areas)
	return ..()

/datum/controller/subsystem/events/fire(resumed)
	if (!resumed)
		src.currentrun = active_events.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while (currentrun.len)
		var/datum/event/E = currentrun[currentrun.len]
		currentrun.len--
		if(E.processing_active)
			E.process()
		if (MC_TICK_CHECK)
			return

	for(var/i = EVENT_LEVEL_MUNDANE to EVENT_LEVEL_MAJOR)
		var/list/datum/event_container/EC = event_containers[i]
		EC.process()

/datum/controller/subsystem/events/stat_entry()
	..("E:[active_events.len]")

/datum/controller/subsystem/events/Recover()
	if(SSevents.active_events)
		active_events |= SSevents.active_events
	if(SSevents.finished_events)
		finished_events |= SSevents.finished_events

/datum/controller/subsystem/events/proc/event_complete(var/datum/event/E)
	active_events -= E

	if(!E.event_meta || !E.severity)	// datum/event is used here and there for random reasons, maintaining "backwards compatibility"
		log_debug("Event of '[E.type]' with missing meta-data has completed.")
		return

	finished_events += E

	// Add the event back to the list of available events
	var/datum/event_container/EC = event_containers[E.severity]
	var/datum/event_meta/EM = E.event_meta
	if(EM.add_to_queue)
		EC.available_events += EM

	log_debug("Event '[EM.name]' has completed at [stationtime2text()].")

/datum/controller/subsystem/events/proc/delay_events(var/severity, var/delay)
	var/datum/event_container/EC = event_containers[severity]
	EC.next_event_time += delay

/datum/controller/subsystem/events/proc/RoundEnd()
	if(!report_at_round_end)
		return

	to_chat(world, "<br><br><br><font size=3><b>Random Events This Round:</b></font>")
	for(var/datum/event/E in active_events|finished_events)
		var/datum/event_meta/EM = E.event_meta
		if(EM.name == "Nothing")
			continue
		var/message = "'[EM.name]' began at [worldtime2stationtime(E.startedAt)] "
		if(E.isRunning)
			message += "and is still running."
		else
			if(E.endedAt - E.startedAt > MinutesToTicks(5)) // Only mention end time if the entire duration was more than 5 minutes
				message += "and ended at [worldtime2stationtime(E.endedAt)]."
			else
				message += "and ran to completion."
		to_chat(world, message)
