/datum/event2/meta/airlock_failure
	event_class = "airlock failure"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_MEDICAL)
	chaos = 15
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_MEDIUM_IMPACT
	event_type = /datum/event2/event/airlock_failure
	var/needs_medical = FALSE

/datum/event2/meta/airlock_failure/emag
	name = "airlock failure - emag"
	event_type = /datum/event2/event/airlock_failure/emag

/datum/event2/meta/airlock_failure/door_crush
	name = "airlock failure - crushing"
	event_type = /datum/event2/event/airlock_failure/door_crush
	needs_medical = TRUE

/datum/event2/meta/airlock_failure/shock
	name = "airlock failure - shock"
	chaos = 30
	event_type = /datum/event2/event/airlock_failure/shock
	needs_medical = TRUE


/datum/event2/meta/airlock_failure/get_weight()
	var/engineering = metric.count_people_in_department(DEPARTMENT_ENGINEERING)

	// Synths are good both for fixing the doors and getting blamed for the doors zapping people.
	var/synths = metric.count_people_in_department(DEPARTMENT_SYNTHETIC)
	if(!engineering && !synths) // Nobody's around to fix the door.
		return 0

	// Medical might be needed for some of the more violent airlock failures.
	var/medical = metric.count_people_in_department(DEPARTMENT_MEDICAL)
	if(!medical && needs_medical)
		return 0

	return (engineering * 20) + (medical * 20) + (synths * 20)



/datum/event2/event/airlock_failure
	announce_delay_lower_bound = 20 SECONDS
	announce_delay_upper_bound = 40 SECONDS
	var/announce_odds = 0
	var/doors_to_break = 1
	var/list/affected_areas = list()

/datum/event2/event/airlock_failure/emag
	announce_odds = 10 // To make people wonder if the emagged door was from a baddie or from this event.
	doors_to_break = 2 // Replacing emagged doors really sucks for engineering so don't overdo it.

/datum/event2/event/airlock_failure/door_crush
	announce_odds = 30
	doors_to_break = 5

/datum/event2/event/airlock_failure/shock
	announce_odds = 70

/datum/event2/event/airlock_failure/start()
	var/list/areas = find_random_areas()
	if(!LAZYLEN(areas))
		log_debug("Airlock Failure event could not find any areas. Aborting.")
		abort()
		return

	while(areas.len)
		var/area/area = pick(areas)
		areas -= area

		for(var/obj/machinery/door/airlock/door in area.contents)
			if(can_break_door(door))
				addtimer(CALLBACK(src, PROC_REF(break_door), door), 1) // Emagging proc is actually a blocking proc and that's bad for the ticker.
				door.visible_message(span("danger", "\The [door]'s panel sparks!"))
				playsound(door, "sparks", 50, 1)
				log_debug("Airlock Failure event has broken \the [door] airlock in [area].")
				affected_areas |= area
				doors_to_break--

			if(doors_to_break <= 0)
				return

/datum/event2/event/airlock_failure/announce()
	if(prob(announce_odds))
		command_announcement.Announce("An electrical issue has been detected in the airlock grid at [english_list(affected_areas)]. \
		Some airlocks may require servicing by a qualified technician.", "Electrical Alert")


/datum/event2/event/airlock_failure/proc/can_break_door(obj/machinery/door/airlock/door)
	if(istype(door, /obj/machinery/door/airlock/lift))
		return FALSE
	return door.arePowerSystemsOn()

// Override this for door busting.
/datum/event2/event/airlock_failure/proc/break_door(obj/machinery/door/airlock/door)

/datum/event2/event/airlock_failure/emag/break_door(obj/machinery/door/airlock/door)
	door.emag_act(1)

/datum/event2/event/airlock_failure/door_crush/break_door(obj/machinery/door/airlock/door)
	door.normalspeed = FALSE
	door.safe = FALSE

/datum/event2/event/airlock_failure/shock/break_door(obj/machinery/door/airlock/door)
	door.electrify(-1)
