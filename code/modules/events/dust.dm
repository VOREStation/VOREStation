/datum/event/dust
	startWhen	= 10
	endWhen		= 30

/datum/event/dust/start()
	affecting_z -= global.using_map.sealed_levels // Space levels only please!
	..()

/datum/event/dust/announce()
	if(!victim)
		command_announcement.Announce("Debris resulting from activity on another nearby asteroid is approaching \the [location_name()]", "Dust Alert")

/datum/event/dust/tick()
	if(prob(10))
		dust_swarm(severity, affecting_z)

/datum/event/dust/end()
	..()
	if(!victim)
		command_announcement.Announce("\The [location_name()] is no longer in danger of impact from space debris.", "Dust Notice")

/datum/event/dust/proc/get_severity()
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			return "weak"
		if(EVENT_LEVEL_MODERATE)
			return prob(80) ? "norm" : "strong"
		if(EVENT_LEVEL_MAJOR)
			return "super"
	return "weak"

// Overmap version
/datum/event/dust/overmap/announce()
	return