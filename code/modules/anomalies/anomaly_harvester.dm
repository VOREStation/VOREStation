/obj/machinery/anomaly_harvester
	name = "anomaly harvester"
	desc = "A strange device that condenses anomalous energy into tangible material."
	icon = 'icons/obj/machines/anomaly_harvester.dmi'
	icon_state = "harvester"
	density = TRUE
	circuit = /obj/item/circuitboard/anomaly_harvester
	active_power_usage = 40000
	idle_power_usage = 500

	var/points = 0
	var/points_to_create = 100

	var/datum/weakref/harvested
	var/list/obj/item/research_sample/samples

/obj/machinery/anomaly_harvester/process()
	..()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(USE_POWER_OFF)
	else
		update_use_power(USE_POWER_IDLE)
		harvest_anomaly()
		if(points && points >= points_to_create)
			points -= points_to_create
			generate_sample()
	update_icon()

/obj/machinery/anomaly_harvester/proc/harvest_anomaly()
	if(!harvested)
		return

	var/obj/effect/anomaly/anom = harvested.resolve()
	if(!istype(anom))
		return

	var/datum/anomaly_stats/stats = anom.stats

	if(stats.stability == ANOMALY_DECAYING)
		playsound(src, 'sound/machines/2beephigh.ogg', 75)
	else if (stats.stability == ANOMALY_GROWING)
		playsound(src, 'sound/machines/buzzbeep.ogg', 75)

/obj/machinery/anomaly_harvester/attackby(obj/item/W, mob/user, attack_modifier, click_parameters)
	add_fingerprint(user)

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(default_unfasten_wrench(user, W, 2 SECONDS))
		return
	if(istype(W, /obj/item/anomaly_scanner))
		var/obj/item/anomaly_scanner/scanner = W
		if(scanner.buffered_anomaly && do_after(user, 2 SECONDS, src))
			attach_anomaly(scanner.buffered_anomaly)
		return

	return ..()

/obj/machinery/anomaly_harvester/proc/attach_anomaly(datum/weakref/anomaly)
	harvested = anomaly

	var/obj/effect/anomaly/anom = anomaly.resolve()
	if(!istype(anom))
		return

	var/datum/anomaly_stats/stats = anom.stats
	stats.attached_harvester = WEAKREF(src)
	playsound(src, 'sound/machines/boobeebeep.ogg', 75, TRUE)
	return TRUE

/obj/machinery/anomaly_harvester/proc/generate_sample()
	update_use_power(USE_POWER_ACTIVE)
	playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
	switch(rand(1, 100))
		if(1 to 60)
			new /obj/item/research_sample/common(src)
		if(61 to 85)
			new /obj/item/research_sample/uncommon(src)
		if(86 to 95)
			new /obj/item/research_sample/rare(src)
		if(96 to 100)
			new /obj/item/research_sample/bluespace(src)
		else
			new /obj/item/research_sample/common(src)

/obj/machinery/anomaly_harvester/update_icon()
	cut_overlays()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		add_overlay("harvester_off")
	else
		add_overlay("harvester_on")

	if(harvested)
		var/obj/effect/anomaly/anom = harvested.resolve()
		if(!istype(anom))
			return

		var/datum/anomaly_stats/stats = anom.stats

		switch(stats.stability)
			if(ANOMALY_STABLE)
				add_overlay("harvester_stable")
			if(ANOMALY_DECAYING)
				add_overlay("harvester_decay")
			else
				add_overlay("harvester_grow")

/obj/machinery/anomaly_harvester/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/anomaly_harvester/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/machinery/anomaly_harvester/attack_ghost(mob/user)
	tgui_interact(user)

/obj/machinery/anomaly_harvester/tgui_state(mob/user)
	return GLOB.tgui_default_state

/obj/machinery/anomaly_harvester/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AnomalyHarvester", name)
		ui.open()

/obj/machinery/anomaly_harvester/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()

	data["points"] = points
	data["pointsToGenerate"] = points_to_create
	data["samples"] = list()
	for(var/obj/item/research_sample/sample in src)
		data["samples"] += list(list(
			"name" = sample.name,
			"icon" = sample.icon,
			"icon_state" = sample.icon_state,
			"width" = "32px",
			"height" = "32px"
		))

	return data
