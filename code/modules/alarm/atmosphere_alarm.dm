/datum/alarm_handler/atmosphere
	category = "Atmosphere Alarms"

/datum/alarm_handler/atmosphere/triggerAlarm(var/atom/origin, var/atom/source, var/duration = 0, var/severity = 1)
	..()

/datum/alarm_handler/atmosphere/major_alarms()
	var/list/major_alarms = new()
	for(var/datum/alarm/A in alarms)
		if(A.max_severity() > 1)
			major_alarms.Add(A)
	return major_alarms

/datum/alarm_handler/atmosphere/minor_alarms()
	var/list/minor_alarms = new()
	for(var/datum/alarm/A in alarms)
		if(A.max_severity() == 1)
			minor_alarms.Add(A)
	return minor_alarms

//VOREStation Add - Alarm for AR glasses
/datum/alarm_handler/atmosphere/on_alarm_change(var/datum/alarm/alarm, var/was_raised)
	..()
	var/atom/source = length(alarm.sources_assoc) ? alarm.sources_assoc[1] : alarm.alarm_area()
	broadcast_engineering_hud_message("Alarm in [alarm.origin] [was_raised ? "raised!" : "cleared."]", source)
//VOREStation Add End