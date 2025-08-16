// This is a somewhat special type of event, that bridges to the old event datum and makes it work with the new system.
// It acts as a compatability layer between the old event, and the new GM system.
// This is possible because the new datum is mostly a superset of the old one.
/datum/event2/event/legacy
	var/datum/event/legacy_event = null

	// Used to emulate legacy's `activeFor` tick counter.
	var/tick_count = 0

	// How 'severe' the legacy event should be. This should only be used for legacy events, as severity is an outdated concept for the GM system.
	var/severity = EVENT_LEVEL_MODERATE

/datum/event2/meta/legacy/get_weight()
	return 50

/datum/event2/event/legacy/process()
	..()
	tick_count++

/datum/event2/event/legacy/set_up()
	legacy_event = new legacy_event(null, external_use = TRUE)
	legacy_event.severity = severity
	legacy_event.setup()

/datum/event2/event/legacy/should_announce()
	return tick_count >= legacy_event.announceWhen

/datum/event2/event/legacy/announce()
	legacy_event.announce()


// Legacy events don't tick before they start, so we don't need to do `wait_tick()`.

/datum/event2/event/legacy/should_start()
	return tick_count >= legacy_event.startWhen

/datum/event2/event/legacy/start()
	legacy_event.start()

/datum/event2/event/legacy/event_tick()
	legacy_event.tick()


/datum/event2/event/legacy/should_end()
	return tick_count >= legacy_event.endWhen

/datum/event2/event/legacy/end()
	legacy_event.end()

/datum/event2/event/legacy/finish()
	legacy_event.kill(external_use = TRUE)
	..()

// Proof of concept.
/*
/datum/event2/meta/legacy_gravity
	name = "gravity (legacy)"
	reusable = TRUE
	event_type = /datum/event2/event/legacy/gravity

/datum/event2/event/legacy/gravity
	legacy_event = /datum/event/gravity
*/
