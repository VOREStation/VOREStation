//base type for controllers of two-door systems
/obj/machinery/embedded_controller/radio/airlock
	// Setup parameters only
	radio_filter = RADIO_AIRLOCK
	program = /datum/embedded_program/airlock
	var/tag_exterior_door
	var/tag_interior_door
	var/tag_airpump
	var/tag_chamber_sensor
	var/tag_exterior_sensor
	var/tag_interior_sensor
	var/tag_airlock_mech_sensor
	var/tag_shuttle_mech_sensor
	var/tag_secure = 0
	var/list/dummy_terminals = list()
	var/cycle_to_external_air = 0
	valid_actions = list("cycle_ext", "cycle_int", "force_ext", "force_int", "abort", "purge", "secure")
	layer = ABOVE_WINDOW_LAYER

/obj/machinery/embedded_controller/radio/airlock/Destroy()
	// TODO - Leshana - Implement dummy terminals
	//for(var/thing in dummy_terminals)
	//	var/obj/machinery/dummy_airlock_controller/dummy = thing
	//	dummy.master_controller = null
	//dummy_terminals.Cut()
	return ..()

/obj/machinery/embedded_controller/radio/airlock/tgui_status(mob/user, datum/tgui_state/state)
	. = ..()
	if(!allowed(user))
		return min(STATUS_UPDATE, .)

//Advanced airlock controller for when you want a more versatile airlock controller - useful for turning simple access control rooms into airlocks
/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller
	name = "Advanced Airlock Controller"

/obj/machinery/embedded_controller/radio/airlock/advanced_airlock_controller/tgui_data(mob/user)
	. = list(
		"chamber_pressure" = round(program.memory["chamber_sensor_pressure"]),
		"external_pressure" = round(program.memory["external_sensor_pressure"]),
		"internal_pressure" = round(program.memory["internal_sensor_pressure"]),
		"processing" = program.memory["processing"],
		"purge" = program.memory["purge"],
		"secure" = program.memory["secure"],
		"internalTemplateName" = "AirlockConsoleAdvanced",
	)


//Airlock controller for airlock control - most airlocks on the station use this
/obj/machinery/embedded_controller/radio/airlock/airlock_controller
	name = "Airlock Controller"
	tag_secure = 1
	valid_actions = list("cycle_ext", "cycle_int", "force_ext", "force_int", "abort")

/obj/machinery/embedded_controller/radio/airlock/airlock_controller/tgui_data(mob/user)
	. = list(
		"chamber_pressure" = round(program.memory["chamber_sensor_pressure"]),
		"exterior_status" = program.memory["exterior_status"],
		"interior_status" = program.memory["interior_status"],
		"processing" = program.memory["processing"],
		"internalTemplateName" = "AirlockConsoleSimple",
	)

//Access controller for door control - used in virology and the like
/obj/machinery/embedded_controller/radio/airlock/access_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_control_standby"

	name = "Access Controller"
	tag_secure = 1
	valid_actions = list("cycle_ext_door", "cycle_int_door", "force_ext", "force_int")


/obj/machinery/embedded_controller/radio/airlock/access_controller/update_icon()
	if(on && program)
		if(program.memory["processing"])
			icon_state = "access_control_process"
		else
			icon_state = "access_control_standby"
	else
		icon_state = "access_control_off"

/obj/machinery/embedded_controller/radio/airlock/access_controller/tgui_data(mob/user)
	. = list(
		"exterior_status" = program.memory["exterior_status"],
		"interior_status" = program.memory["interior_status"],
		"processing" = program.memory["processing"],
		"internalTemplateName" = "DoorAccessConsole",
	)
