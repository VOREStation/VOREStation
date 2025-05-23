/datum/event2/meta/security_drill
	name = "security drill"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_EVERYONE)
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_HIGH_IMPACT // Don't run if we just got hit by meteors.
	event_type = /datum/event2/event/security_drill

/datum/event2/meta/security_drill/get_weight()
	var/sec = metric.count_people_in_department(DEPARTMENT_SECURITY)
	var/everyone = metric.count_people_in_department(DEPARTMENT_EVERYONE)

	if(!sec) // If there's no security, then there is no drill.
		return 0
	if(everyone - sec < 0) // If there's no non-sec, then there is no drill.
		return 0

	// Each security player adds +5 weight, while non-security adds +1.5.
	return (sec * 5) + ((everyone - sec) * 1.5)

/datum/event2/event/security_drill/announce()
	command_announcement.Announce("[pick("A NanoTrasen security director", "A Vir-Gov correspondant", "Local Sif authoritiy")] \
	has advised the enactment of [pick("a rampant wildlife", "a fire", "a hostile boarding", \
	"a bomb", "an emergent intelligence")] drill with the personnel onboard \the [location_name()].", "Security Advisement")
