/obj/machinery/doppler_array
	anchored = TRUE
	name = "tachyon-doppler array"
	density = TRUE
	desc = "A highly precise directional sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array."
	dir = NORTH

	icon_state = "doppler"
	circuit = /obj/item/circuitboard/doppler_array

	var/list/detected_explosions = list()

/obj/machinery/doppler_array/Initialize(mapload)
	//Explosive analysis
	var/static/list/explosive_signals = list(
		COMSIG_MACHINERY_EXPLOSION_DETECTED = TYPE_PROC_REF(/datum/component/experiment_handler, try_run_ordinance_experiment),
	)
	AddComponent(/datum/component/experiment_handler, \
		config_mode = EXPERIMENT_CONFIG_ALTCLICK, \
		allowed_experiments = list(/datum/experiment/ordnance),\
		config_flags = EXPERIMENT_CONFIG_ALWAYS_ACTIVE|EXPERIMENT_CONFIG_SILENT_FAIL,\
		experiment_signals = explosive_signals, \
	)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_EXPLOSION, PROC_REF(sense_explosion))
	ADD_TRAIT(src, TRAIT_ALT_CLICK_BLOCKER, ROUNDSTART_TRAIT)

/obj/machinery/doppler_array/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_EXPLOSION)
	. = ..()

/obj/machinery/doppler_array/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DopplerArray", name)
		ui.open()

/obj/machinery/doppler_array/tgui_static_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()
	data["explosions"] = length(detected_explosions) ? detected_explosions : null;
	return data

/obj/machinery/doppler_array/proc/sense_explosion(datum/source, turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, seconds_taken)
	SIGNAL_HANDLER

	if(stat & NOPOWER)
		return

	var/x0 = epicenter.x
	var/y0 = epicenter.y
	var/z0 = epicenter.z
	if(!(z0 in GetConnectedZlevels(z)))
		return
	var/turf/our_turf = get_turf(src)
	if(our_turf.Distance(epicenter) > 100)
		return
	atom_say("Explosive disturbance detected - Epicenter at: grid ([x0],[y0],[z0]). Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range]. Temporal displacement of tachyons: [seconds_taken] seconds.")
	SEND_SIGNAL(src, COMSIG_MACHINERY_EXPLOSION_DETECTED, epicenter, devastation_range, heavy_impact_range, light_impact_range, seconds_taken)
	detected_explosions += list(
		list(
			"index" = length(detected_explosions),
			"time" = ROUND_TIME(),
			"x" = x0,
			"y" = y0,
			"z" = z0,
			"devastation_range" = devastation_range,
			"heavy_impact_range" = heavy_impact_range,
			"light_impact_range" = light_impact_range,
			"seconds_taken" = seconds_taken,
		)
	)
	update_static_data_for_all_viewers()

/obj/machinery/doppler_array/power_change()
	..()
	if(!(stat & NOPOWER))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/machinery/doppler_array/attackby(obj/item/W, mob/user, attack_modifier, click_parameters)
	add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

/obj/machinery/doppler_array/attack_hand(mob/user)
	. = ..()
	tgui_interact(user)
