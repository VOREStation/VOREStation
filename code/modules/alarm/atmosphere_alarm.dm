/datum/alarm_handler/atmosphere
	category = "Atmosphere Alarms"

/datum/alarm_handler/atmosphere/major_alarms(var/z)
	var/list/major_alarms = new()
	var/list/map_levels = using_map.get_map_levels(z)
	for(var/datum/alarm/A in visible_alarms())
		if(z && !(A.origin?.z in map_levels))
			continue
		if(A.max_severity() > 1)
			major_alarms.Add(A)
	return major_alarms

/datum/alarm_handler/atmosphere/minor_alarms(var/z)
	var/list/minor_alarms = new()
	var/list/map_levels = using_map.get_map_levels(z)
	for(var/datum/alarm/A in visible_alarms())
		if(z && !(A.origin?.z in map_levels))
			continue
		if(A.max_severity() == 1)
			minor_alarms.Add(A)
	return minor_alarms

//VOREStation Add - Alarm for AR glasses
/*/datum/alarm_handler/atmosphere/on_alarm_change(var/datum/alarm/alarm, var/was_raised)
	..()
	var/atom/source = length(alarm.sources_assoc) ? alarm.sources_assoc[1] : alarm.alarm_area()
	broadcast_engineering_hud_message("Alarm in [alarm.origin] [was_raised ? "raised!" : "cleared."]", source)*/
//VOREStation Add End
