/datum/alarm_handler/fire
	category = "Fire Alarms"

/datum/alarm_handler/fire/on_alarm_change(var/datum/alarm/alarm, var/was_raised)
	var/area/A = alarm.origin
	if(istype(A))
		if(was_raised)
			A.fire_alert()
		else
			A.fire_reset()
	//VOREStation Add - Alarm for AR glasses uses
	/*var/atom/source = length(alarm.sources_assoc) ? alarm.sources_assoc[1] : alarm.alarm_area()
	broadcast_engineering_hud_message("Alarm in [alarm.origin] [was_raised ? "raised!" : "cleared."]", source)*/
	//VOREStation Add End
	..()
