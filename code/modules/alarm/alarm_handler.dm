#define ALARM_RAISED 1
#define ALARM_CLEARED 0

/datum/alarm_handler
	var/category = ""
	var/list/datum/alarm/alarms = new		// All alarms, to handle cases when an origin has been deleted with one or more active alarms
	var/list/datum/alarm/alarms_assoc = new	// Associative list of alarms, to efficiently acquire them based on origin.
	var/list/listeners = new				// A list of all objects interested in alarm changes.

/datum/alarm_handler/process()
	for(var/datum/alarm/A in alarms)
		A.process()
		check_alarm_cleared(A)

/datum/alarm_handler/proc/triggerAlarm(var/atom/origin, var/atom/source, var/duration = 0, var/severity = 1, var/hidden = 0)
	var/new_alarm
	//Proper origin and source mandatory
	if(!(origin && source))
		return
	origin = origin.get_alarm_origin()

	new_alarm = 0
	//see if there is already an alarm of this origin
	var/datum/alarm/existing = alarms_assoc[origin]
	if(existing)
		existing.set_source_data(source, duration, severity, hidden)
	else
		existing = new/datum/alarm(origin, source, duration, severity, hidden)
		new_alarm = 1

	alarms |= existing
	alarms_assoc[origin] = existing
	if(new_alarm)
		alarms = dd_sortedObjectList(alarms)
		on_alarm_change(existing, ALARM_RAISED)

	return new_alarm

/datum/alarm_handler/proc/clearAlarm(var/atom/origin, var/source)
	//Proper origin and source mandatory
	if(!(origin && source))
		return
	origin = origin.get_alarm_origin()

	var/datum/alarm/existing = alarms_assoc[origin]
	if(existing)
		existing.clear(source)
		return check_alarm_cleared(existing)

/datum/alarm_handler/proc/major_alarms(var/z)
	return visible_alarms(z)

/datum/alarm_handler/proc/has_major_alarms(var/z)
	if(!LAZYLEN(alarms))
		return 0

	return LAZYLEN(major_alarms(z))

/datum/alarm_handler/proc/minor_alarms(var/z)
	return visible_alarms(z)

/datum/alarm_handler/proc/check_alarm_cleared(var/datum/alarm/alarm)
	if ((alarm.end_time && world.time > alarm.end_time) || !alarm.sources.len)
		alarms -= alarm
		alarms_assoc -= alarm.origin
		on_alarm_change(alarm, ALARM_CLEARED)
		return 1
	return 0

/datum/alarm_handler/proc/on_alarm_change(var/datum/alarm/alarm, var/was_raised)
	for(var/obj/machinery/camera/C in alarm.cameras())
		if(was_raised && !alarm.hidden)
			C.add_network(category)
		else
			C.remove_network(category)
	notify_listeners(alarm, was_raised)

/datum/alarm_handler/proc/get_alarm_severity_for_origin(var/atom/origin)
	if(!origin)
		return

	origin = origin.get_alarm_origin()
	var/datum/alarm/existing = alarms_assoc[origin]
	if(!existing)
		return

	return existing.max_severity()

/atom/proc/get_alarm_origin()
	return src

/turf/get_alarm_origin()
	return get_area(src)

/datum/alarm_handler/proc/register_alarm(var/object, var/procName)
	listeners[object] = procName

/datum/alarm_handler/proc/unregister_alarm(var/object)
	listeners -= object

/datum/alarm_handler/proc/notify_listeners(var/alarm, var/was_raised)
	for(var/listener in listeners)
		call(listener, listeners[listener])(src, alarm, was_raised)

/datum/alarm_handler/proc/visible_alarms(var/z)
	if(!LAZYLEN(alarms))
		return list()

	var/list/map_levels = using_map.get_map_levels(z)

	var/list/visible_alarms = new()
	for(var/datum/alarm/A in alarms)
		if(A.hidden || (z && !(A.origin?.z in map_levels)))
			continue
		visible_alarms.Add(A)
	return visible_alarms