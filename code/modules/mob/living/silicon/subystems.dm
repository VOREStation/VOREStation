/mob/living/silicon
	var/register_alarms = 1
	var/datum/tgui_module/alarm_monitor/all/robot/alarm_monitor
	var/datum/tgui_module/atmos_control/robot/atmos_control
	var/datum/tgui_module/crew_manifest/robot/crew_manifest
	var/datum/tgui_module/crew_monitor/robot/crew_monitor
	var/datum/tgui_module/law_manager/robot/law_manager
	var/datum/tgui_module/power_monitor/robot/power_monitor
	var/datum/tgui_module/rcon/robot/rcon

/mob/living/silicon
	var/list/silicon_subsystems = list(
		/mob/living/silicon/proc/subsystem_alarm_monitor,
		/mob/living/silicon/proc/subsystem_crew_manifest,
		/mob/living/silicon/proc/subsystem_law_manager
	)

/mob/living/silicon/ai
	silicon_subsystems = list(
		/mob/living/silicon/proc/subsystem_alarm_monitor,
		/mob/living/silicon/proc/subsystem_atmos_control,
		/mob/living/silicon/proc/subsystem_crew_manifest,
		/mob/living/silicon/proc/subsystem_crew_monitor,
		/mob/living/silicon/proc/subsystem_law_manager,
		/mob/living/silicon/proc/subsystem_power_monitor,
		/mob/living/silicon/proc/subsystem_rcon
	)

/mob/living/silicon/robot/syndicate
	register_alarms = 0
	silicon_subsystems = list(/mob/living/silicon/proc/subsystem_law_manager)

/mob/living/silicon/proc/init_subsystems()
	alarm_monitor 	= new(src)
	atmos_control 	= new(src)
	crew_manifest	= new(src)
	crew_monitor 	= new(src)
	law_manager 	= new(src)
	power_monitor	= new(src)
	rcon 			= new(src)

	if(!register_alarms)
		return

	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		AH.register_alarm(src, /mob/living/silicon/proc/receive_alarm)
		queued_alarms[AH] = list()	// Makes sure alarms remain listed in consistent order

/********************
*	Alarm Monitor	*
********************/
/mob/living/silicon/proc/subsystem_alarm_monitor()
	set name = "Alarm Monitor"
	set category = "Subystems"

	alarm_monitor.tgui_interact(usr)

/********************
*	Atmos Control	*
********************/
/mob/living/silicon/proc/subsystem_atmos_control()
	set category = "Subystems"
	set name = "Atmospherics Control"

	atmos_control.tgui_interact(usr)

/********************
*	Crew Manifest	*
********************/
/mob/living/silicon/proc/subsystem_crew_manifest()
	set category = "Subystems"
	set name = "Crew Manifest"

	crew_manifest.tgui_interact(usr)

/********************
*	Crew Monitor	*
********************/
/mob/living/silicon/proc/subsystem_crew_monitor()
	set category = "Subystems"
	set name = "Crew Monitor"

	crew_monitor.tgui_interact(usr)

/****************
*	Law Manager	*
****************/
/mob/living/silicon/proc/subsystem_law_manager()
	set name = "Law Manager"
	set category = "Subystems"

	law_manager.tgui_interact(usr)

/********************
*	Power Monitor	*
********************/
/mob/living/silicon/proc/subsystem_power_monitor()
	set category = "Subystems"
	set name = "Power Monitor"

	power_monitor.tgui_interact(usr)

/************
*	RCON	*
************/
/mob/living/silicon/proc/subsystem_rcon()
	set category = "Subystems"
	set name = "RCON"

	rcon.tgui_interact(usr)
