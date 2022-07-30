//Amazing disperser from Bxil(tm). Some icons, sounds, and some code shamelessly stolen from ParadiseSS13.

/obj/machinery/computer/ship/disperser
	name = "obstruction removal ballista control"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	circuit = /obj/item/circuitboard/disperser

	core_skill = /datum/skill/pilot
	var/skill_offset = SKILL_ADEPT - 1 //After which skill level it starts to matter. -1, because we have to index from zero

	icon_keyboard = "rd_key"
	icon_screen = "teleport"

	var/obj/machinery/disperser/front/front
	var/obj/machinery/disperser/middle/middle
	var/obj/machinery/disperser/back/back
	var/const/link_range = 16 //How far can the above stuff be maximum before we start complaining

	var/overmapdir = 0

	var/caldigit = 4 //number of digits that needs calibration
	var/list/calibration //what it is
	var/list/calexpected //what is should be

	var/range = 1 //range of the explosion
	var/strength = 1 //strength of the explosion
	var/next_shot = 0 //round time where the next shot can start from
	var/const/coolinterval = 2 MINUTES //time to wait between safe shots in deciseconds

/obj/machinery/computer/ship/disperser/Initialize()
	. = ..()
	link_parts()
	reset_calibration()

/obj/machinery/computer/ship/disperser/Destroy()
	release_links()
	. = ..()

/obj/machinery/computer/ship/disperser/proc/link_parts()
	if(is_valid_setup())
		return TRUE

	for(var/obj/machinery/disperser/front/F in global.machines)
		if(get_dist(src, F) >= link_range)
			continue
		var/backwards = turn(F.dir, 180)
		var/obj/machinery/disperser/middle/M = locate() in get_step(F, backwards)
		if(!M || get_dist(src, M) >= link_range)
			continue
		var/obj/machinery/disperser/back/B = locate() in get_step(M, backwards)
		if(!B || get_dist(src, B) >= link_range)
			continue
		front = F
		middle = M
		back = B
		if(is_valid_setup())
			GLOB.destroyed_event.register(F, src, .proc/release_links)
			GLOB.destroyed_event.register(M, src, .proc/release_links)
			GLOB.destroyed_event.register(B, src, .proc/release_links)
			return TRUE
	return FALSE

/obj/machinery/computer/ship/disperser/proc/is_valid_setup()
	if(front && middle && back)
		var/everything_in_range = (get_dist(src, front) < link_range) && (get_dist(src, middle) < link_range) && (get_dist(src, back) < link_range)
		var/everything_in_order = (middle.Adjacent(front) && middle.Adjacent(back)) && (front.dir == middle.dir && middle.dir == back.dir)
		return everything_in_order && everything_in_range
	return FALSE

/obj/machinery/computer/ship/disperser/proc/release_links()
	GLOB.destroyed_event.unregister(front, src, .proc/release_links)
	GLOB.destroyed_event.unregister(middle, src, .proc/release_links)
	GLOB.destroyed_event.unregister(back, src, .proc/release_links)
	front = null
	middle = null
	back = null

/obj/machinery/computer/ship/disperser/proc/get_calibration()
	var/list/calresult[caldigit]
	for(var/i = 1 to caldigit)
		if(calibration[i] == calexpected[i])
			calresult[i] = 2
		else if(calibration[i] in calexpected)
			calresult[i] = 1
		else
			calresult[i] = 0
	return calresult

/obj/machinery/computer/ship/disperser/proc/reset_calibration()
	calexpected = new /list(caldigit)
	calibration = new /list(caldigit)
	for(var/i = 1 to caldigit)
		calexpected[i] = rand(0,9)
		calibration[i] = 0

/obj/machinery/computer/ship/disperser/proc/cal_accuracy()
	var/top = 0
	var/divisor = caldigit * 2 //maximum possible value, aka 100% accuracy
	for(var/i in get_calibration())
		top += i
	return round(top * 100 / divisor)

/obj/machinery/computer/ship/disperser/proc/get_next_shot_seconds()
	return max(0, (next_shot - world.time) / 10)

/obj/machinery/computer/ship/disperser/proc/cool_failchance()
	return get_next_shot_seconds() * 1000 / coolinterval

/obj/machinery/computer/ship/disperser/proc/get_charge_type()
	var/obj/structure/ship_munition/disperser_charge/B = locate() in get_turf(back)
	if(B)
		return B.chargetype
	return OVERMAP_WEAKNESS_NONE

/obj/machinery/computer/ship/disperser/proc/get_charge()
	var/obj/structure/ship_munition/disperser_charge/B = locate() in get_turf(back)
	if(B)
		return B

/obj/machinery/computer/ship/disperser/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!linked)
		display_reconnect_dialog(user, "disperser synchronization")
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OvermapDisperser", "[linked.name] ORB control") // 400, 550
		ui.open()

/obj/machinery/computer/ship/disperser/tgui_data(mob/user)
	var/list/data = list()
	data["faillink"] = FALSE
	data["calibration"] = null
	data["overmapdir"] = null
	data["cal_accuracy"] = 0
	data["strength"] = 0
	data["range"] = 0
	data["next_shot"] = -1
	data["nopower"] = TRUE
	data["skill"] = FALSE
	data["chargeload"] = null

	if(!link_parts())
		data["faillink"] = TRUE
	else
		data["calibration"] = calibration
		data["overmapdir"] = overmapdir
		data["cal_accuracy"] = cal_accuracy()
		data["strength"] = strength
		data["range"] = range
		data["next_shot"] = round(get_next_shot_seconds())
		data["nopower"] = !data["faillink"] && (!front.powered() || !middle.powered() || !back.powered())
		data["skill"] = user.get_skill_value(core_skill) > skill_offset

		var/charge = "UNKNOWN ERROR"
		if(get_charge_type() == OVERMAP_WEAKNESS_NONE)
			charge = "ERROR: No valid charge detected."
		else
			var/obj/structure/ship_munition/disperser_charge/B = get_charge()
			charge = B.chargedesc
		data["chargeload"] = charge

	return data

/obj/machinery/computer/ship/disperser/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	if(!linked)
		return FALSE

	switch(action)
		if("choose")
			overmapdir = sanitize_integer(text2num(params["dir"]), 0, 9, 0)
			reset_calibration()
			. = TRUE

		if("calibration")
			var/input = tgui_input_number(usr, "0-9", "disperser calibration", 0, 9, 0)
			if(!isnull(input)) //can be zero so we explicitly check for null
				var/calnum = sanitize_integer(text2num(params["calibration"]), 0, caldigit)//sanitiiiiize
				calibration[calnum + 1] = sanitize_integer(input, 0, 9, 0)//must add 1 because js indexes from 0
			. = TRUE

		if("skill_calibration")
			for(var/i = 1 to min(caldigit, usr.get_skill_value(core_skill) - skill_offset))
				calibration[i] = calexpected[i]
			. = TRUE

		if("strength")
			var/input = tgui_input_number(usr, "1-5", "disperser strength", 1, 5, 1)
			if(input && tgui_status(usr, state) == STATUS_INTERACTIVE)
				strength = sanitize_integer(input, 1, 5, 1)
				middle.update_idle_power_usage(strength * range * 100)
			. = TRUE

		if("range")
			var/input = tgui_input_number(usr, "1-5", "disperser radius", 1, 5, 1)
			if(input && tgui_status(usr, state) == STATUS_INTERACTIVE)
				range = sanitize_integer(input, 1, 5, 1)
				middle.update_idle_power_usage(strength * range * 100)
			. = TRUE

		if("fire")
			fire(usr)
			. = TRUE

	if(. && !issilicon(usr))
		playsound(src, "terminal_type", 50, 1)
