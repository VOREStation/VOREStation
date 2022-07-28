#define DECLARE_TLV_VALUES var/red_min; var/yel_min; var/yel_max; var/red_max; var/tlv_comparitor;
#define LOAD_TLV_VALUES(x, y) red_min = x[1]; yel_min = x[2]; yel_max = x[3]; red_max = x[4]; tlv_comparitor = y;
#define TEST_TLV_VALUES (((tlv_comparitor >= red_max && red_max > 0) || tlv_comparitor <= red_min) ? 2 : ((tlv_comparitor >= yel_max && yel_max > 0) || tlv_comparitor <= yel_min) ? 1 : 0)

#define AALARM_MODE_SCRUBBING	1
#define AALARM_MODE_REPLACEMENT	2 //like scrubbing, but faster.
#define AALARM_MODE_PANIC		3 //constantly sucks all air
#define AALARM_MODE_CYCLE		4 //sucks off all air, then refill and switches to scrubbing
#define AALARM_MODE_FILL		5 //emergency fill
#define AALARM_MODE_OFF			6 //Shuts it all down.

#define AALARM_SCREEN_MAIN		1
#define AALARM_SCREEN_VENT		2
#define AALARM_SCREEN_SCRUB		3
#define AALARM_SCREEN_MODE		4
#define AALARM_SCREEN_SENSORS	5

#define AALARM_REPORT_TIMEOUT 100

#define MAX_TEMPERATURE 90
#define MIN_TEMPERATURE -40

//all air alarms in area are connected via magic
/area
	var/obj/machinery/alarm/master_air_alarm
	var/list/air_vent_names = list()
	var/list/air_scrub_names = list()
	var/list/air_vent_info = list()
	var/list/air_scrub_info = list()

/obj/machinery/alarm
	name = "alarm"
	desc = "Used to control various station atmospheric systems. The light indicates the current air status of the area."
	icon = 'icons/obj/monitors_vr.dmi' //VOREStation Edit - Other icons
	icon_state = "alarm_0"
	layer = ABOVE_WINDOW_LAYER
	vis_flags = VIS_HIDE // They have an emissive that looks bad in openspace due to their wall-mounted nature
	anchored = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 80
	active_power_usage = 1000 //For heating/cooling rooms. 1000 joules equates to about 1 degree every 2 seconds for a single tile of air.
	power_channel = ENVIRON
	req_one_access = list(access_atmospherics, access_engine_equip)
	clicksound = "button"
	clickvol = 30
	blocks_emissive = NONE
	light_power = 0.25
	var/alarm_id = null
	var/breach_detection = 1 // Whether to use automatic breach detection or not
	var/frequency = 1439
	//var/skipprocess = 0 //Experimenting
	var/alarm_frequency = 1437
	var/remote_control = 0
	var/rcon_setting = 2
	var/rcon_time = 0
	var/locked = 1
	panel_open = FALSE // If it's been screwdrivered open.
	var/aidisabled = 0
	var/shorted = 0
	circuit = /obj/item/weapon/circuitboard/airalarm

	var/datum/wires/alarm/wires

	var/mode = AALARM_MODE_SCRUBBING
	var/screen = AALARM_SCREEN_MAIN
	var/area_uid
	var/area/alarm_area

	var/target_temperature = T0C+20
	var/regulating_temperature = 0

	var/datum/radio_frequency/radio_connection

	/// Keys are things like temperature and certain gasses. Values are lists, which contain, in order:
	/// red warning minimum value, yellow warning minimum value, yellow warning maximum value, red warning maximum value
	var/list/TLV = list()
	var/list/trace_gas = list("nitrous_oxide", "volatile_fuel") //list of other gases that this air alarm is able to detect

	var/danger_level = 0
	var/pressure_dangerlevel = 0

	var/report_danger_level = 1

	var/alarms_hidden = FALSE //If the alarms from this machine are visible on consoles

/obj/machinery/alarm/nobreach
	breach_detection = 0

/obj/machinery/alarm/monitor
	report_danger_level = 0
	breach_detection = 0

/obj/machinery/alarm/alarms_hidden
	alarms_hidden = TRUE

/obj/machinery/alarm/angled
	icon = 'icons/obj/wall_machines_angled.dmi'

/obj/machinery/alarm/angled/hidden
	alarms_hidden = TRUE

/obj/machinery/alarm/angled/offset_airalarm()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? -21 : 21)
	pixel_y = (dir & 3) ? (dir == 1 ? -18 : 20) : 0

/obj/machinery/alarm/server/Initialize(mapload)
	. = ..()
	req_access = list(access_rd, access_atmospherics, access_engine_equip)
	TLV["oxygen"] =			list(-1.0, -1.0,-1.0,-1.0) // Partial pressure, kpa
	TLV["carbon dioxide"] = list(-1.0, -1.0,   5,  10) // Partial pressure, kpa
	TLV["phoron"] =			list(-1.0, -1.0, 0, 0.5) // Partial pressure, kpa
	TLV["other"] =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] =		list(0,ONE_ATMOSPHERE*0.10,ONE_ATMOSPHERE*1.40,ONE_ATMOSPHERE*1.60) /* kpa */
	TLV["temperature"] =	list(20, 40, 140, 160) // K
	target_temperature = 90

/obj/machinery/alarm/Initialize(mapload)
	. = ..()
	if(!pixel_x && !pixel_y)
		offset_airalarm()
	first_run()

/obj/machinery/alarm/Destroy()
	unregister_radio(src, frequency)
	qdel(wires)
	wires = null
	if(alarm_area && alarm_area.master_air_alarm == src)
		alarm_area.master_air_alarm = null
		elect_master(exclude_self = TRUE)
	return ..()

/obj/machinery/alarm/proc/offset_airalarm()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? -26 : 26)
	pixel_y = (dir & 3) ? (dir == 1 ? -26 : 26) : 0

/obj/machinery/alarm/proc/first_run()
	alarm_area = get_area(src)
	area_uid = "\ref[alarm_area]"
	if(name == "alarm")
		name = "[alarm_area.name] Air Alarm"

	if(!wires)
		wires = new(src)

	// breathable air according to human/Life()
	TLV["oxygen"] =			list(16, 19, 135, 140) // Partial pressure, kpa
	TLV["nitrogen"] =		list(0, 0, 135, 140) // Partial pressure, kpa
	TLV["carbon dioxide"] = list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
	TLV["phoron"] =			list(-1.0, -1.0, 0, 0.5) // Partial pressure, kpa
	TLV["other"] =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] =		list(ONE_ATMOSPHERE * 0.80, ONE_ATMOSPHERE * 0.90, ONE_ATMOSPHERE * 1.10, ONE_ATMOSPHERE * 1.20) /* kpa */
	TLV["temperature"] =	list(T0C - 26, T0C, T0C + 40, T0C + 66) // K

	update_icon()

/obj/machinery/alarm/Initialize()
	. = ..()
	set_frequency(frequency)
	if(!master_is_operating())
		elect_master()

/obj/machinery/alarm/process()
	if((stat & (NOPOWER|BROKEN)) || shorted)
		return

	var/turf/simulated/location = src.loc
	if(!istype(location))	return//returns if loc is not simulated

	var/datum/gas_mixture/environment = location.return_air()

	//Handle temperature adjustment here.
	handle_heating_cooling(environment)

	var/old_level = danger_level
	var/old_pressurelevel = pressure_dangerlevel
	danger_level = overall_danger_level(environment)

	if(old_level != danger_level)
		apply_danger_level(danger_level)

	if(old_pressurelevel != pressure_dangerlevel)
		if(breach_detected())
			mode = AALARM_MODE_OFF
			apply_mode()

	if(mode == AALARM_MODE_CYCLE && environment.return_pressure() < ONE_ATMOSPHERE * 0.05)
		mode = AALARM_MODE_FILL
		apply_mode()

	//atmos computer remote controll stuff
	switch(rcon_setting)
		if(RCON_NO)
			remote_control = 0
		if(RCON_AUTO)
			if(danger_level == 2)
				remote_control = 1
			else
				remote_control = 0
		if(RCON_YES)
			remote_control = 1

	return

/obj/machinery/alarm/proc/handle_heating_cooling(var/datum/gas_mixture/environment)
	DECLARE_TLV_VALUES
	LOAD_TLV_VALUES(TLV["temperature"], target_temperature)
	if(!regulating_temperature)
		//check for when we should start adjusting temperature
		if(!TEST_TLV_VALUES && abs(environment.temperature - target_temperature) > 2.0 && environment.return_pressure() >= 1)
			update_use_power(USE_POWER_ACTIVE)
			regulating_temperature = 1
			audible_message("\The [src] clicks as it starts [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click and a faint electronic hum.", runemessage = "* click *")
			playsound(src, 'sound/machines/click.ogg', 50, 1)
	else
		//check for when we should stop adjusting temperature
		if(TEST_TLV_VALUES || abs(environment.temperature - target_temperature) <= 0.5 || environment.return_pressure() < 1)
			update_use_power(USE_POWER_IDLE)
			regulating_temperature = 0
			audible_message("\The [src] clicks quietly as it stops [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",\
			"You hear a click as a faint electronic humming stops.", runemessage = "* click *")
			playsound(src, 'sound/machines/click.ogg', 50, 1)

	if(regulating_temperature)
		if(target_temperature > T0C + MAX_TEMPERATURE)
			target_temperature = T0C + MAX_TEMPERATURE

		if(target_temperature < T0C + MIN_TEMPERATURE)
			target_temperature = T0C + MIN_TEMPERATURE

		var/datum/gas_mixture/gas
		gas = environment.remove(0.25 * environment.total_moles)
		if(gas)

			if(gas.temperature <= target_temperature)	//gas heating
				var/energy_used = min(gas.get_thermal_energy_change(target_temperature) , active_power_usage)

				gas.add_thermal_energy(energy_used)
				//use_power(energy_used, ENVIRON) //handle by update_use_power instead
			else	//gas cooling
				var/heat_transfer = min(abs(gas.get_thermal_energy_change(target_temperature)), active_power_usage)

				//Assume the heat is being pumped into the hull which is fixed at 20 C
				//none of this is really proper thermodynamics but whatever

				var/cop = gas.temperature / T20C	//coefficient of performance -> power used = heat_transfer/cop

				heat_transfer = min(heat_transfer, cop * active_power_usage)	//this ensures that we don't use more than active_power_usage amount of power

				heat_transfer = -gas.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

				//use_power(heat_transfer / cop, ENVIRON)	//handle by update_use_power instead

			environment.merge(gas)

/obj/machinery/alarm/proc/overall_danger_level(var/datum/gas_mixture/environment)
	var/partial_pressure = R_IDEAL_GAS_EQUATION * environment.temperature/environment.volume
	var/environment_pressure = environment.return_pressure()

	var/other_moles = 0
	for(var/g in trace_gas)
		other_moles += environment.gas[g] //this is only going to be used in a partial pressure calc, so we don't need to worry about group_multiplier here.

	DECLARE_TLV_VALUES
	LOAD_TLV_VALUES(TLV["pressure"], environment_pressure)
	pressure_dangerlevel = TEST_TLV_VALUES // not local because it's used in process()
	LOAD_TLV_VALUES(TLV["oxygen"], environment.gas["oxygen"]*partial_pressure)
	var/oxygen_dangerlevel = TEST_TLV_VALUES
	LOAD_TLV_VALUES(TLV["carbon dioxide"], environment.gas["carbon_dioxide"]*partial_pressure)
	var/co2_dangerlevel = TEST_TLV_VALUES
	LOAD_TLV_VALUES(TLV["phoron"], environment.gas["phoron"]*partial_pressure)
	var/phoron_dangerlevel = TEST_TLV_VALUES
	LOAD_TLV_VALUES(TLV["temperature"], environment.temperature)
	var/temperature_dangerlevel = TEST_TLV_VALUES
	LOAD_TLV_VALUES(TLV["other"], other_moles*partial_pressure)
	var/other_dangerlevel = TEST_TLV_VALUES

	return max(
		pressure_dangerlevel,
		oxygen_dangerlevel,
		co2_dangerlevel,
		phoron_dangerlevel,
		other_dangerlevel,
		temperature_dangerlevel
		)

// Returns whether this air alarm thinks there is a breach, given the sensors that are available to it.
/obj/machinery/alarm/proc/breach_detected()
	var/turf/simulated/location = src.loc

	if(!istype(location))
		return 0

	if(breach_detection	== 0)
		return 0

	var/datum/gas_mixture/environment = location.return_air()
	var/environment_pressure = environment.return_pressure()
	var/pressure_levels = TLV["pressure"]

	if(environment_pressure <= pressure_levels[1])		//low pressures
		if(!(mode == AALARM_MODE_PANIC || mode == AALARM_MODE_CYCLE))
			return 1

	return 0

/obj/machinery/alarm/proc/master_is_operating()
	return alarm_area && alarm_area.master_air_alarm && !(alarm_area.master_air_alarm.stat & (NOPOWER | BROKEN))

/obj/machinery/alarm/proc/elect_master(exclude_self = FALSE)
	for(var/obj/machinery/alarm/AA in alarm_area)
		if(exclude_self && AA == src)
			continue
		if(!(AA.stat & (NOPOWER|BROKEN)))
			alarm_area.master_air_alarm = AA
			return 1
	return 0

/obj/machinery/alarm/update_icon()
	cut_overlays()

	if(panel_open)
		icon_state = "alarmx"
		set_light(0)
		set_light_on(FALSE)
		return
	if((stat & (NOPOWER|BROKEN)) || shorted)
		icon_state = "alarmp"
		set_light(0)
		set_light_on(FALSE)
		return

	var/icon_level = danger_level
	if(alarm_area?.atmosalm)
		icon_level = max(icon_level, 1)	//if there's an atmos alarm but everything is okay locally, no need to go past yellow

	var/new_color = null
	switch(icon_level)
		if(0)
			icon_state = "alarm_0"
			add_overlay(mutable_appearance(icon, "alarm_ov0"))
			add_overlay(emissive_appearance(icon, "alarm_ov0"))
			new_color = "#03A728"
		if(1)
			icon_state = "alarm_2" //yes, alarm2 is yellow alarm
			add_overlay(mutable_appearance(icon, "alarm_ov2"))
			add_overlay(emissive_appearance(icon, "alarm_ov2"))
			new_color = "#EC8B2F"
		if(2)
			icon_state = "alarm_1"
			add_overlay(mutable_appearance(icon, "alarm_ov1"))
			add_overlay(emissive_appearance(icon, "alarm_ov1"))
			new_color = "#DA0205"

	set_light(l_range = 2, l_power = 0.25, l_color = new_color)
	set_light_on(TRUE)

/obj/machinery/alarm/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return
	if(alarm_area.master_air_alarm != src)
		if(master_is_operating())
			return
		elect_master()
		if(alarm_area.master_air_alarm != src)
			return
	if(!signal || signal.encryption)
		return
	var/id_tag = signal.data["tag"]
	if(!id_tag)
		return
	if(signal.data["area"] != area_uid)
		return
	if(signal.data["sigtype"] != "status")
		return

	var/dev_type = signal.data["device"]
	if(!(id_tag in alarm_area.air_scrub_names) && !(id_tag in alarm_area.air_vent_names))
		register_env_machine(id_tag, dev_type)
	if(dev_type == "AScr")
		alarm_area.air_scrub_info[id_tag] = signal.data
	else if(dev_type == "AVP")
		alarm_area.air_vent_info[id_tag] = signal.data

/obj/machinery/alarm/proc/register_env_machine(var/m_id, var/device_type)
	var/new_name
	if(device_type == "AVP")
		new_name = "[alarm_area.name] Vent Pump #[alarm_area.air_vent_names.len+1]"
		alarm_area.air_vent_names[m_id] = new_name
	else if(device_type == "AScr")
		new_name = "[alarm_area.name] Air Scrubber #[alarm_area.air_scrub_names.len+1]"
		alarm_area.air_scrub_names[m_id] = new_name
	else
		return
	spawn(10)
		send_signal(m_id, list("init" = new_name))

/obj/machinery/alarm/proc/refresh_all()
	for(var/id_tag in alarm_area.air_vent_names)
		var/list/I = alarm_area.air_vent_info[id_tag]
		if(I && I["timestamp"] + AALARM_REPORT_TIMEOUT / 2 > world.time)
			continue
		send_signal(id_tag, list("status"))
	for(var/id_tag in alarm_area.air_scrub_names)
		var/list/I = alarm_area.air_scrub_info[id_tag]
		if(I && I["timestamp"] + AALARM_REPORT_TIMEOUT / 2 > world.time)
			continue
		send_signal(id_tag, list("status"))

/obj/machinery/alarm/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_TO_AIRALARM)

/obj/machinery/alarm/proc/send_signal(var/target, var/list/command)//sends signal 'command' to 'target'. Returns 0 if no radio connection, 1 otherwise
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO //radio signal
	signal.source = src

	signal.data = command
	signal.data["tag"] = target
	signal.data["sigtype"] = "command"

	radio_connection.post_signal(src, signal, RADIO_FROM_AIRALARM)
//			to_world("Signal [command] Broadcasted to [target]")

	return 1

/obj/machinery/alarm/proc/apply_mode()
	//propagate mode to other air alarms in the area
	//TODO: make it so that players can choose between applying the new mode to the room they are in (related area) vs the entire alarm area
	for(var/obj/machinery/alarm/AA in alarm_area)
		AA.mode = mode

	switch(mode)
		if(AALARM_MODE_SCRUBBING)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "co2_scrub"= 1, "scrubbing"= 1, "panic_siphon"= 0))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default"))

		if(AALARM_MODE_PANIC, AALARM_MODE_CYCLE)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "panic_siphon"= 1))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 0))

		if(AALARM_MODE_REPLACEMENT)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 1, "panic_siphon"= 1))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default"))

		if(AALARM_MODE_FILL)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 0))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default"))

		if(AALARM_MODE_OFF)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power"= 0))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power"= 0))

/obj/machinery/alarm/proc/apply_danger_level(var/new_danger_level)
	if(report_danger_level && alarm_area.atmosalert(new_danger_level, src))
		post_alert(new_danger_level)

	update_icon()

/obj/machinery/alarm/proc/post_alert(alert_level)
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(alarm_frequency)
	if(!frequency)
		return

	var/datum/signal/alert_signal = new
	alert_signal.source = src
	alert_signal.transmission_method = TRANSMISSION_RADIO
	alert_signal.data["zone"] = alarm_area.name
	alert_signal.data["type"] = "Atmospheric"

	if(alert_level==2)
		alert_signal.data["alert"] = "severe"
	else if(alert_level==1)
		alert_signal.data["alert"] = "minor"
	else if(alert_level==0)
		alert_signal.data["alert"] = "clear"

	frequency.post_signal(src, alert_signal)

/obj/machinery/alarm/attack_ai(mob/user)
	tgui_interact(user)

/obj/machinery/alarm/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	return interact(user)

/obj/machinery/alarm/interact(mob/user)
	tgui_interact(user)
	wires.Interact(user)

/obj/machinery/alarm/tgui_status(mob/user)
	if(isAI(user) && aidisabled)
		to_chat(user, "AI control has been disabled.")
	else if(!shorted)
		return ..()
	return STATUS_CLOSE

/obj/machinery/alarm/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, datum/tgui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirAlarm", name, parent_ui)
		if(state)
			ui.set_state(state)
		ui.open()

/obj/machinery/alarm/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list(
		"locked" = locked,
		"siliconUser" = issilicon(user),
		"remoteUser" = !!ui.parent_ui,
		"danger_level" = danger_level,
		"target_temperature" = "[target_temperature - T0C]C",
		"rcon" = rcon_setting,
	)

	var/area/A = get_area(src)
	data["atmos_alarm"] = A?.atmosalm
	data["fire_alarm"] = A?.fire

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T.return_air()

	var/list/list/environment_data = list()
	data["environment_data"] = environment_data
	
	DECLARE_TLV_VALUES
	
	var/pressure = environment.return_pressure()
	LOAD_TLV_VALUES(TLV["pressure"], pressure)
	environment_data.Add(list(list(
		"name" = "Pressure",
		"value" = pressure,
		"unit" = "kPa",
		"danger_level" = TEST_TLV_VALUES
	)))
	
	var/temperature = environment.temperature
	LOAD_TLV_VALUES(TLV["temperature"], temperature)
	environment_data.Add(list(list(
		"name" = "Temperature",
		"value" = temperature,
		"unit" = "K ([round(temperature - T0C, 0.1)]C)",
		"danger_level" = TEST_TLV_VALUES
	)))

	var/total_moles = environment.total_moles
	var/partial_pressure = R_IDEAL_GAS_EQUATION * environment.temperature / environment.volume
	for(var/gas_id in environment.gas)
		if(!(gas_id in TLV))
			continue
		LOAD_TLV_VALUES(TLV[gas_id], environment.gas[gas_id] * partial_pressure)
		environment_data.Add(list(list(
			"name" = gas_id,
			"value" = environment.gas[gas_id] / total_moles * 100,
			"unit" = "%",
			"danger_level" = TEST_TLV_VALUES
		)))
	
	if(!locked || issilicon(user) || data["remoteUser"])
		var/list/list/vents = list()
		data["vents"] = vents
		for(var/id_tag in A.air_vent_names)
			var/long_name = A.air_vent_names[id_tag]
			var/list/info = A.air_vent_info[id_tag]
			if(!info)
				continue
			vents.Add(list(list(
				"id_tag"	= id_tag,
				"long_name" = sanitize(long_name),
				"power"		= info["power"],
				"checks"	= info["checks"],
				"excheck"	= info["checks"]&1,
				"incheck"	= info["checks"]&2,
				"direction"	= info["direction"],
				"external"	= info["external"],
				"internal"	= info["internal"],
				"extdefault"= (info["external"] == ONE_ATMOSPHERE),
				"intdefault"= (info["internal"] == 0),
			)))
		

		var/list/list/scrubbers = list()
		data["scrubbers"] = scrubbers
		for(var/id_tag in alarm_area.air_scrub_names)
			var/long_name = alarm_area.air_scrub_names[id_tag]
			var/list/info = alarm_area.air_scrub_info[id_tag]
			if(!info)
				continue
			scrubbers += list(list(
				"id_tag"	= id_tag,
				"long_name" = sanitize(long_name),
				"power"		= info["power"],
				"scrubbing"	= info["scrubbing"],
				"panic"		= info["panic"],
				"filters"   = list(
					list("name" = "Oxygen",			"command" = "o2_scrub",	"val" = info["filter_o2"]),
					list("name" = "Nitrogen",		"command" = "n2_scrub",	"val" = info["filter_n2"]),
					list("name" = "Carbon Dioxide", "command" = "co2_scrub","val" = info["filter_co2"]),
					list("name" = "Toxin"	, 		"command" = "tox_scrub","val" = info["filter_phoron"]),
					list("name" = "Nitrous Oxide",	"command" = "n2o_scrub","val" = info["filter_n2o"]),
					list("name" = "Fuel",			"command" = "fuel_scrub","val" = info["filter_fuel"])
				)
			))
		data["scrubbers"] = scrubbers

		data["mode"] = mode
		
		var/list/list/modes = list()
		data["modes"] = modes
		modes[++modes.len] = list("name" = "Filtering - Scrubs out contaminants", 			"mode" = AALARM_MODE_SCRUBBING,		"selected" = mode == AALARM_MODE_SCRUBBING, 	"danger" = 0)
		modes[++modes.len] = list("name" = "Replace Air - Siphons out air while replacing", "mode" = AALARM_MODE_REPLACEMENT,	"selected" = mode == AALARM_MODE_REPLACEMENT,	"danger" = 0)
		modes[++modes.len] = list("name" = "Panic - Siphons air out of the room", 			"mode" = AALARM_MODE_PANIC,			"selected" = mode == AALARM_MODE_PANIC, 		"danger" = 1)
		modes[++modes.len] = list("name" = "Cycle - Siphons air before replacing", 			"mode" = AALARM_MODE_CYCLE,			"selected" = mode == AALARM_MODE_CYCLE, 		"danger" = 1)
		modes[++modes.len] = list("name" = "Fill - Shuts off scrubbers and opens vents", 	"mode" = AALARM_MODE_FILL,			"selected" = mode == AALARM_MODE_FILL, 			"danger" = 0)
		modes[++modes.len] = list("name" = "Off - Shuts off vents and scrubbers", 			"mode" = AALARM_MODE_OFF,			"selected" = mode == AALARM_MODE_OFF, 			"danger" = 0)

		var/list/selected
		var/list/thresholds = list()

		var/list/gas_names = list("oxygen", "carbon dioxide", "phoron", "other")
		for(var/g in gas_names)
			thresholds[++thresholds.len] = list("name" = g, "settings" = list())
			selected = TLV[g]
			for(var/i = 1, i <= 4, i++)
				thresholds[thresholds.len]["settings"] += list(list("env" = g, "val" = i, "selected" = selected[i]))

		selected = TLV["pressure"]
		thresholds[++thresholds.len] = list("name" = "Pressure", "settings" = list())
		for(var/i = 1, i <= 4, i++)
			thresholds[thresholds.len]["settings"] += list(list("env" = "pressure", "val" = i, "selected" = selected[i]))

		selected = TLV["temperature"]
		thresholds[++thresholds.len] = list("name" = "Temperature", "settings" = list())
		for(var/i = 1, i <= 4, i++)
			thresholds[thresholds.len]["settings"] += list(list("env" = "temperature", "val" = i, "selected" = selected[i]))

		data["thresholds"] = thresholds
	return data

/obj/machinery/alarm/tgui_act(action, params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	if(action == "rcon")
		var/attempted_rcon_setting = text2num(params["rcon"])

		switch(attempted_rcon_setting)
			if(RCON_NO)
				rcon_setting = RCON_NO
			if(RCON_AUTO)
				rcon_setting = RCON_AUTO
			if(RCON_YES)
				rcon_setting = RCON_YES
		return TRUE

	if(action == "temperature")
		var/list/selected = TLV["temperature"]
		var/max_temperature = min(selected[3] - T0C, MAX_TEMPERATURE)
		var/min_temperature = max(selected[2] - T0C, MIN_TEMPERATURE)
		var/input_temperature = tgui_input_number(usr, "What temperature would you like the system to mantain? (Capped between [min_temperature] and [max_temperature]C)", "Thermostat Controls", target_temperature - T0C, max_temperature, min_temperature)
		if(isnum(input_temperature))
			if(input_temperature > max_temperature || input_temperature < min_temperature)
				to_chat(usr, "Temperature must be between [min_temperature]C and [max_temperature]C")
			else
				target_temperature = input_temperature + T0C
		return TRUE
	
	// Account for remote users here.
	// Yes, this is kinda snowflaky; however, I would argue it would be far more snowflakey
	// to include "custom hrefs" and all the other bullshit that nano states have just for the
	// like, two UIs, that want remote access to other UIs.
	if((locked && !issilicon(usr) && !istype(state, /datum/tgui_state/air_alarm_remote)) || (issilicon(usr) && aidisabled))
		return

	var/device_id = params["id_tag"]
	switch(action)
		if("lock")
			if(issilicon(usr) && !wires.is_cut(WIRE_IDSCAN))
				locked = !locked
				. = TRUE
		if( "power",
			"o2_scrub",
			"n2_scrub",
			"co2_scrub",
			"tox_scrub",
			"n2o_scrub",
			"fuel_scrub",
			"panic_siphon",
			"scrubbing",
			"direction")
			send_signal(device_id, list("[action]" = text2num(params["val"])), usr)
			. = TRUE
		if("excheck")
			send_signal(device_id, list("checks" = text2num(params["val"])^1), usr)
			. = TRUE
		if("incheck")
			send_signal(device_id, list("checks" = text2num(params["val"])^2), usr)
			. = TRUE
		if("set_external_pressure", "set_internal_pressure")
			var/target = params["value"]
			if(!isnull(target))
				send_signal(device_id, list("[action]" = target), usr)
				. = TRUE
		if("reset_external_pressure")
			send_signal(device_id, list("reset_external_pressure"), usr)
			. = TRUE
		if("reset_internal_pressure")
			send_signal(device_id, list("reset_internal_pressure"), usr)
			. = TRUE
		if("threshold")
			var/env = params["env"]

			var/name = params["var"]
			var/value = tgui_input_number(usr, "New [name] for [env]:", name, TLV[env][name])
			if(!isnull(value) && !..())
				if(value < 0)
					TLV[env][name] = -1
				else
					TLV[env][name] = round(value, 0.01)
				clamp_tlv_values(env, name)
				// investigate_log(" treshold value for [env]:[name] was set to [value] by [key_name(usr)]",INVESTIGATE_ATMOS)
				. = TRUE
		if("mode")
			mode = text2num(params["mode"])
			// investigate_log("was turned to [get_mode_name(mode)] mode by [key_name(usr)]",INVESTIGATE_ATMOS)
			apply_mode(usr)
			. = TRUE
		if("alarm")
			if(alarm_area.atmosalert(2, src))
				apply_danger_level(2)
			. = TRUE
		if("reset")
			atmos_reset()
			. = TRUE
	update_icon()

// This big ol' mess just ensures that TLV always makes sense. If you set the max value below the min value,
// it'll automatically update all the other values to keep it sane.
/obj/machinery/alarm/proc/clamp_tlv_values(env, changed_threshold)
	var/list/selected = TLV[env]
	switch(changed_threshold)
		if(1)
			if(selected[1] > selected[2])
				selected[2] = selected[1]
			if(selected[1] > selected[3])
				selected[3] = selected[1]
			if(selected[1] > selected[4])
				selected[4] = selected[1]
		if(2)
			if(selected[1] > selected[2])
				selected[1] = selected[2]
			if(selected[2] > selected[3])
				selected[3] = selected[2]
			if(selected[2] > selected[4])
				selected[4] = selected[2]
		if(3)
			if(selected[1] > selected[3])
				selected[1] = selected[3]
			if(selected[2] > selected[3])
				selected[2] = selected[3]
			if(selected[3] > selected[4])
				selected[4] = selected[3]
		if(4)
			if(selected[1] > selected[4])
				selected[1] = selected[4]
			if(selected[2] > selected[4])
				selected[2] = selected[4]
			if(selected[3] > selected[4])
				selected[3] = selected[4]




/obj/machinery/alarm/proc/atmos_reset()
	if(alarm_area.atmosalert(0, src))
		apply_danger_level(0)
	update_icon()

/obj/machinery/alarm/attackby(obj/item/W as obj, mob/user as mob)
	add_fingerprint(user)
	if(alarm_deconstruction_screwdriver(user, W))
		return
	if(alarm_deconstruction_wirecutters(user, W))
		return

	if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))// trying to unlock the interface with an ID card
		togglelock()
	return ..()

/obj/machinery/alarm/verb/togglelock(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "It does nothing.")
		return
	else
		if(allowed(usr) && !wires.is_cut(WIRE_IDSCAN))
			locked = !locked
			to_chat(user, "<span class='notice'>You [locked ? "lock" : "unlock"] the Air Alarm interface.</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return

/obj/machinery/alarm/AltClick()
	..()
	togglelock()

/obj/machinery/alarm/power_change()
	..()
	spawn(rand(0,15))
		update_icon()

// VOREStation Edit Start
/obj/machinery/alarm/freezer
	target_temperature = T0C - 13.15 // Chilly freezer room

/obj/machinery/alarm/freezer/first_run()
	. = ..()

	TLV["temperature"] =	list(T0C - 40, T0C - 20, T0C + 40, T0C + 66) // K, Lower Temperature for Freezer Air Alarms (This is because TLV is hardcoded to be generated on first_run, and therefore the only way to modify this without changing TLV generation)

// VOREStation Edit End
#undef LOAD_TLV_VALUES
#undef TEST_TLV_VALUES
#undef DECLARE_TLV_VALUES