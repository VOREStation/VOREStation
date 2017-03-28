/datum/alarm_handler/fire
	category = "Fire Alarms"

/datum/alarm_handler/fire/on_alarm_change(var/datum/alarm/alarm, var/was_raised)
	var/area/A = alarm.origin
	if(istype(A))
		if(was_raised)
			A.fire_alert()

			//VOREStation Add - Alarm for AR glasses uses
			var/atom/source = alarm.sources_assoc[1]
			broadcast_engineering_hud_message("Alarm in [alarm.origin]!", source)
			//VOREStation Add End
		else
			A.fire_reset()
	..()
