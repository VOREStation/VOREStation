/obj/machinery/computer/area_atmos
	name = "Area Air Control"
	desc = "A computer used to control the stationary scrubbers and pumps in the area."
	icon_keyboard = "atmos_key"
	icon_screen = "area_atmos"
	light_color = "#e6ffff"
	circuit = /obj/item/circuitboard/area_atmos

	var/list/connectedscrubbers = list()
	var/status = ""

	var/range = 25

	//Simple variable to prevent me from doing attack_hand in both this and the child computer
	var/zone = "This computer is working on a wireless range, the range is currently limited to "

/obj/machinery/computer/area_atmos/Initialize()
	. = ..()
	scanscrubbers()

/obj/machinery/computer/area_atmos/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/area_atmos/attack_hand(var/mob/user as mob)
	if(..(user))
		return
	tgui_interact(user)

/obj/machinery/computer/area_atmos/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AreaScrubberControl", name)
		ui.open()

/obj/machinery/computer/area_atmos/tgui_data(mob/user)
	var/list/working = list()
	for(var/id in connectedscrubbers)
		var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber = connectedscrubbers[id]
		if(!validscrubber(scrubber))
			connectedscrubbers -= scrubber
			continue
		working.Add(list(list(
			"id" = id,
			"name" = scrubber.name,
			"on" = scrubber.on,
			"pressure" = scrubber.air_contents.return_pressure(),
			"flow_rate" = scrubber.last_flow_rate,
			"load" = scrubber.last_power_draw,
			"area" = get_area(scrubber),
		)))
	
	return list("scrubbers" = working)

/obj/machinery/computer/area_atmos/tgui_act(action, params)
	if(..())
		return TRUE
	
	switch(action)
		if("toggle")
			var/scrub_id = params["id"]
			var/obj/machinery/portable_atmospherics/powered/scrubber/huge/S = connectedscrubbers["[scrub_id]"]
			if(!validscrubber(S))
				connectedscrubbers -= S
				return TRUE
			S.on = !S.on
			S.update_icon()
			. = TRUE
		if("allon")
			INVOKE_ASYNC(src, .proc/toggle_all, TRUE)
			. = TRUE
		if("alloff")
			INVOKE_ASYNC(src, .proc/toggle_all, FALSE)
			. = TRUE
		if("scan")
			scanscrubbers()
			. = TRUE

	add_fingerprint(usr)

/obj/machinery/computer/area_atmos/proc/toggle_all(on)
	for(var/id in connectedscrubbers)	
		var/obj/machinery/portable_atmospherics/powered/scrubber/huge/S = connectedscrubbers["[id]"]
		if(!validscrubber(S))
			connectedscrubbers -= S
			continue
		S.on = on
		S.update_icon()
		CHECK_TICK

/obj/machinery/computer/area_atmos/proc/validscrubber(obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber as obj)
	if(!isobj(scrubber) || get_dist(scrubber.loc, src.loc) > src.range || scrubber.loc.z != src.loc.z)
		return FALSE
	return TRUE

/obj/machinery/computer/area_atmos/proc/scanscrubbers()
	connectedscrubbers = list()

	var/found = 0
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in range(range, src.loc))
		found = 1
		connectedscrubbers["[scrubber.id]"] = scrubber

	if(!found)
		status = "ERROR: No scrubber found!"

	updateUsrDialog()

// The one that only works in the same map area
/obj/machinery/computer/area_atmos/area
	zone = "This computer is working in a wired network limited to this area."

/obj/machinery/computer/area_atmos/area/scanscrubbers()
	connectedscrubbers.Cut()

	var/found = 0
	var/area/A = get_area(src)
	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in A)
		connectedscrubbers["[scrubber.id]"] = scrubber
		found = 1

	if(!found)
		status = "ERROR: No scrubber found!"

	src.updateUsrDialog()

/obj/machinery/computer/area_atmos/area/validscrubber(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber)
	if(!istype(scrubber))
		return FALSE

	if(get_area(scrubber) == get_area(src))
		return TRUE

	return FALSE
