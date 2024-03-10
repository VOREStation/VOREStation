/****************
* Debug Support *
****************/

/datum/all_observable_events
	var/list/events

/datum/all_observable_events/New()
	events = list()
	..()
