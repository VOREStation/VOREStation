/datum/rem_event
	var/min_mode = REM_CALM
	var/max_mode = REM_ANOMALOUS
	var/extra_value = 0
	var/event_path

	var/list/departments = list()

/datum/rem_event/proc/start()
	if(!event_path)
		return

	new event_path
