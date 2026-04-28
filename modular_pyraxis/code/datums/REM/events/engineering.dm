/datum/rem_event/ion_storm
	min_mode = REM_IRREGULAR
	max_mode = REM_ANOMALOUS
	departments = list(DEPARTMENT_ENGINEERING)
	event_path = /datum/event/ionstorm

/datum/rem_event/grubs
	min_mode = REM_IRREGULAR
	max_mode = REM_UNCONTROLLED
	departments = list(DEPARTMENT_ENGINEERING)
	event_path = /datum/event/grub_infestation

/datum/rem_event/atmos_leak
	min_mode = REM_CALM
	max_mode = REM_UNCONTROLLED
	departments = list(DEPARTMENT_ENGINEERING)
	event_path = /datum/event/atmos_leak

/datum/rem_event/apc_damage
	min_mode = REM_CALM
	max_mode = REM_ANOMALOUS
	departments = list(DEPARTMENT_ENGINEERING)
	event_path = /datum/event/apc_damage
	extra_value = 10

/datum/rem_event/window_break
	min_mode = REM_IRREGULAR
	max_mode = REM_ANOMALOUS
	departments = list(DEPARTMENT_ENGINEERING)
	event_path = /datum/event/window_break
	extra_value = 10
