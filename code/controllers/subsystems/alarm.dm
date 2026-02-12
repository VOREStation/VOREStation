SUBSYSTEM_DEF(alarm)
	name = "Alarm"
	wait = 2 SECONDS
	priority = FIRE_PRIORITY_ALARM
	dependencies = list(
		/datum/controller/subsystem/mapping
	)
	var/list/datum/alarm/all_handlers
	var/tmp/list/currentrun = null
	var/static/list/active_alarm_cache = list()

/datum/controller/subsystem/alarm/Initialize()
	all_handlers = list(GLOB.atmosphere_alarm, GLOB.camera_alarm, GLOB.fire_alarm, GLOB.motion_alarm, GLOB.power_alarm)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/alarm/fire(resumed = FALSE)
	if(!resumed)
		src.currentrun = all_handlers.Copy()
		active_alarm_cache.Cut()

	var/list/currentrun = src.currentrun // Cache for sanic speed
	while (currentrun.len)
		var/datum/alarm_handler/AH = currentrun[currentrun.len]
		currentrun.len--
		AH.process()
		active_alarm_cache += AH.alarms

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/alarm/proc/active_alarms()
	return active_alarm_cache.Copy()

/datum/controller/subsystem/alarm/proc/number_of_active_alarms()
	return active_alarm_cache.len

/datum/controller/subsystem/alarm/stat_entry(msg)
	msg = "[number_of_active_alarms()] alarm\s"
	return ..()
