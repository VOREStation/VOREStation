// LEGACY_RECORD_STRUCTURE(all_waypoints, waypoint)
GLOBAL_LIST_EMPTY(all_waypoints)
/datum/computer_file/data/waypoint
	var/list/fields
	filetype = "WPT"

/datum/computer_file/data/waypoint/New()
	..()
	fields = list()
	GLOB.all_waypoints.Add(src)

/datum/computer_file/data/waypoint/Destroy()
	. = ..()
	GLOB.all_waypoints.Remove(src);
// End LEGACY_RECORD_STRUCTURE(all_waypoints, waypoint)

/obj/machinery/computer/ship/helm
	name = "helm control console"
	icon_keyboard = "teleport_key"
	icon_screen = "helm"
	light_color = "#7faaff"
	circuit = /obj/item/circuitboard/helm
	core_skill = /datum/skill/pilot
	var/autopilot = 0
	var/autopilot_disabled = TRUE
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 1/(20 SECONDS) //top speed for autopilot, 5
	var/accellimit = 0.001 //manual limiter for acceleration
	req_one_access = list(access_pilot) //VOREStation Edit
	ai_control = FALSE	//VOREStation Edit - AI/Borgs shouldn't really be flying off in ships without crew help

// fancy sprite
/obj/machinery/computer/ship/helm/adv
	icon_keyboard = null
	icon_state = "adv_helm"
	icon_screen = "adv_helm_screen"
	light_color = "#70ffa0"

/obj/machinery/computer/ship/helm/Initialize()
	. = ..()
	get_known_sectors()

/obj/machinery/computer/ship/helm/proc/get_known_sectors()
	var/area/overmap/map = locate() in world
	for(var/obj/effect/overmap/visitable/sector/S in map)
		if(S.known)
			var/datum/computer_file/data/waypoint/R = new()
			R.fields["name"] = S.name
			R.fields["x"] = S.x
			R.fields["y"] = S.y
			known_sectors[S.name] = R

/obj/machinery/computer/ship/helm/process()
	..()
	if(autopilot && dx && dy && !autopilot_disabled)
		var/turf/T = locate(dx,dy,global.using_map.overmap_z)
		if(linked.loc == T)
			if(linked.is_still())
				autopilot = 0
			else
				linked.decelerate()
		else
			var/brake_path = linked.get_brake_path()
			var/direction = get_dir(linked.loc, T)
			var/acceleration = min(linked.get_acceleration(), accellimit)
			var/speed = linked.get_speed()
			var/heading = linked.get_heading()

			// Destination is current grid or speedlimit is exceeded
			if((get_dist(linked.loc, T) <= brake_path) || speed > speedlimit)
				linked.decelerate()
			// Heading does not match direction
			else if(heading & ~direction)
				linked.accelerate(turn(heading & ~direction, 180), accellimit)
			// All other cases, move toward direction
			else if(speed + acceleration <= speedlimit)
				linked.accelerate(direction, accellimit)
		linked.operator_skill = null//if this is on you can't dodge meteors
		return

/obj/machinery/computer/ship/helm/relaymove(var/mob/user, direction)
	if(viewing_overmap(user) && linked)
		if(prob(user.skill_fail_chance(/datum/skill/pilot, 50, linked.skill_needed, factor = 1)))
			direction = turn(direction,pick(90,-90))
		linked.relaymove(user, direction, accellimit)
		return 1

/obj/machinery/computer/ship/helm/tgui_interact(mob/user, datum/tgui/ui)
	if(!linked)
		display_reconnect_dialog(user, "helm")
<<<<<<< HEAD
=======
	else
		var/turf/T = get_turf(linked)
		var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

		data["sector"] = current_sector ? current_sector.name : "Deep Space"
		data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
		data["landed"] = linked.get_landed_info()
		data["s_x"] = linked.x
		data["s_y"] = linked.y
		data["dest"] = dy && dx
		data["d_x"] = dx
		data["d_y"] = dy
		data["speedlimit"] = speedlimit ? speedlimit*1000 : "Halted"
		data["accel"] = min(round(linked.get_acceleration()*1000, 0.01),accellimit*1000)
		data["heading"] = linked.get_heading_degrees()
		data["autopilot"] = autopilot
		data["manual_control"] = viewing_overmap(user)
		data["canburn"] = linked.can_burn()
		data["accellimit"] = accellimit*1000

		var/speed = round(linked.get_speed()*1000, 0.01)
		if(linked.get_speed() < SHIP_SPEED_SLOW)
			speed = "<span class='good'>[speed]</span>"
		if(linked.get_speed() > SHIP_SPEED_FAST)
			speed = "<span class='average'>[speed]</span>"
		data["speed"] = speed

		if(linked.get_speed())
			data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
		else
			data["ETAnext"] = "N/A"

		var/list/locations[0]
		for (var/key in known_sectors)
			var/datum/computer_file/data/waypoint/R = known_sectors[key]
			var/list/rdata[0]
			rdata["name"] = R.fields["name"]
			rdata["x"] = R.fields["x"]
			rdata["y"] = R.fields["y"]
			rdata["reference"] = "\ref[R]"
			locations.Add(list(rdata))

		data["locations"] = locations

		ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, "helm.tmpl", "[linked.name] Helm Control", 565, 545)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/obj/machinery/computer/ship/helm/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return TOPIC_HANDLED

	if(!linked)
		return TOPIC_HANDLED

	if (href_list["add"])
		var/datum/computer_file/data/waypoint/R = new()
		var/sec_name = input("Input naviation entry name", "New navigation entry", "Sector #[known_sectors.len]") as text
		if(!CanInteract(user,state))
			return TOPIC_NOACTION
		if(!sec_name)
			sec_name = "Sector #[known_sectors.len]"
		R.fields["name"] = sec_name
		if(sec_name in known_sectors)
			to_chat(user, "<span class='warning'>Sector with that name already exists, please input a different name.</span>")
			return TOPIC_REFRESH
		switch(href_list["add"])
			if("current")
				R.fields["x"] = linked.x
				R.fields["y"] = linked.y
			if("new")
				var/newx = input("Input new entry x coordinate", "Coordinate input", linked.x) as num
				if(!CanInteract(user,state))
					return TOPIC_REFRESH
				var/newy = input("Input new entry y coordinate", "Coordinate input", linked.y) as num
				if(!CanInteract(user,state))
					return TOPIC_NOACTION
				R.fields["x"] = clamp(newx, 1, world.maxx)
				R.fields["y"] = clamp(newy, 1, world.maxy)
		known_sectors[sec_name] = R

	if (href_list["remove"])
		var/datum/computer_file/data/waypoint/R = locate(href_list["remove"])
		if(R)
			known_sectors.Remove(R.fields["name"])
			qdel(R)

	if (href_list["setx"])
		var/newx = input("Input new destiniation x coordinate", "Coordinate input", dx) as num|null
		if(!CanInteract(user,state))
			return
		if (newx)
			dx = clamp(newx, 1, world.maxx)

	if (href_list["sety"])
		var/newy = input("Input new destiniation y coordinate", "Coordinate input", dy) as num|null
		if(!CanInteract(user,state))
			return
		if (newy)
			dy = clamp(newy, 1, world.maxy)

	if (href_list["x"] && href_list["y"])
		dx = text2num(href_list["x"])
		dy = text2num(href_list["y"])

	if (href_list["reset"])
		dx = 0
		dy = 0

	if (href_list["speedlimit"])
		var/newlimit = input("Input new speed limit for autopilot (0 to brake)", "Autopilot speed limit", speedlimit*1000) as num|null
		if(newlimit)
			speedlimit = clamp(newlimit/1000, 0, 100)
	if (href_list["accellimit"])
		var/newlimit = input("Input new acceleration limit", "Acceleration limit", accellimit*1000) as num|null
		if(newlimit)
			accellimit = max(newlimit/1000, 0)

	if (href_list["move"])
		var/ndir = text2num(href_list["move"])
		if(prob(user.skill_fail_chance(/datum/skill/pilot, 50, linked.skill_needed, factor = 1)))
			ndir = turn(ndir,pick(90,-90))
		linked.relaymove(user, ndir, accellimit)

	if (href_list["brake"])
		linked.decelerate()

	if (href_list["apilot"])
		autopilot = !autopilot

	if (href_list["manual"])
		viewing_overmap(user) ? unlook(user) : look(user)

	add_fingerprint(user)
	updateUsrDialog()


/obj/machinery/computer/ship/navigation
	name = "navigation console"
	icon_keyboard = "generic_key"
	icon_screen = "helm"
	circuit = /obj/item/circuitboard/nav

/obj/machinery/computer/ship/navigation/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "Navigation")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OvermapHelm", "[linked.name] Helm Control") // 565, 545
		ui.open()

/obj/machinery/computer/ship/helm/tgui_data(mob/user)
	var/list/data = ..()

	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["landed"] = linked.get_landed_info()
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["dest"] = dy && dx
	data["d_x"] = dx
	data["d_y"] = dy
	data["speedlimit"] = speedlimit ? speedlimit*1000 : "Halted"
	data["accel"] = min(round(linked.get_acceleration()*1000, 0.01),accellimit*1000)
	data["heading"] = linked.get_heading_degrees()
	data["autopilot_disabled"] = autopilot_disabled
	data["autopilot"] = autopilot
	data["manual_control"] = viewing_overmap(user)
	data["canburn"] = linked.can_burn()
	data["accellimit"] = accellimit*1000

	var/speed = round(linked.get_speed()*1000, 0.01)
	var/speed_color = null
	if(linked.get_speed() < SHIP_SPEED_SLOW)
		speed_color = "good"
	if(linked.get_speed() > SHIP_SPEED_FAST)
		speed_color = "average"
	data["speed"] = speed
	data["speed_color"] = speed_color

	if(linked.get_speed())
		data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
	else
		data["ETAnext"] = "N/A"

	var/list/locations[0]
	for (var/key in known_sectors)
		var/datum/computer_file/data/waypoint/R = known_sectors[key]
		var/list/rdata[0]
		rdata["name"] = R.fields["name"]
		rdata["x"] = R.fields["x"]
		rdata["y"] = R.fields["y"]
		rdata["reference"] = "\ref[R]"
		locations.Add(list(rdata))

	data["locations"] = locations
	return data

/obj/machinery/computer/ship/helm/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	if(!linked)
		return FALSE

	switch(action)
		if("add")
			var/datum/computer_file/data/waypoint/R = new()
			var/sec_name = input(usr, "Input navigation entry name", "New navigation entry", "Sector #[known_sectors.len]") as text
			if(tgui_status(usr, state) != STATUS_INTERACTIVE)
				return FALSE
			if(!sec_name)
				sec_name = "Sector #[known_sectors.len]"
			R.fields["name"] = sec_name
			if(sec_name in known_sectors)
				to_chat(usr, "<span class='warning'>Sector with that name already exists, please input a different name.</span>")
				return TRUE
			switch(params["add"])
				if("current")
					R.fields["x"] = linked.x
					R.fields["y"] = linked.y
				if("new")
					var/newx = input(usr, "Input new entry x coordinate", "Coordinate input", linked.x) as num
					if(tgui_status(usr, state) != STATUS_INTERACTIVE)
						return TRUE
					var/newy = input(usr, "Input new entry y coordinate", "Coordinate input", linked.y) as num
					if(tgui_status(usr, state) != STATUS_INTERACTIVE)
						return FALSE
					R.fields["x"] = CLAMP(newx, 1, world.maxx)
					R.fields["y"] = CLAMP(newy, 1, world.maxy)
			known_sectors[sec_name] = R
			. = TRUE

		if("remove")
			var/datum/computer_file/data/waypoint/R = locate(params["remove"])
			if(R)
				known_sectors.Remove(R.fields["name"])
				qdel(R)
			. = TRUE

		if("setcoord")
			if(params["setx"])
				var/newx = input(usr, "Input new destiniation x coordinate", "Coordinate input", dx) as num|null
				if(tgui_status(usr, state) != STATUS_INTERACTIVE)
					return
				if(newx)
					dx = CLAMP(newx, 1, world.maxx)

			if(params["sety"])
				var/newy = input(usr, "Input new destiniation y coordinate", "Coordinate input", dy) as num|null
				if(tgui_status(usr, state) != STATUS_INTERACTIVE)
					return
				if(newy)
					dy = CLAMP(newy, 1, world.maxy)
			. = TRUE

		if("setds")
			dx = text2num(params["x"])
			dy = text2num(params["y"])
			. = TRUE

		if("reset")
			dx = 0
			dy = 0
			. = TRUE

		if("speedlimit")
			var/newlimit = input(usr, "Input new speed limit for autopilot (0 to brake)", "Autopilot speed limit", speedlimit*1000) as num|null
			if(newlimit)
				speedlimit = CLAMP(newlimit/1000, 0, 100)
			. = TRUE

		if("accellimit")
			var/newlimit = input(usr, "Input new acceleration limit", "Acceleration limit", accellimit*1000) as num|null
			if(newlimit)
				accellimit = max(newlimit/1000, 0)
			. = TRUE

		if("move")
			var/ndir = text2num(params["dir"])
			if(prob(usr.skill_fail_chance(/datum/skill/pilot, 50, linked.skill_needed, factor = 1)))
				ndir = turn(ndir,pick(90,-90))
			linked.relaymove(usr, ndir, accellimit)
			. = TRUE

		if("brake")
			linked.decelerate()
			. = TRUE

		if("apilot")
			if(autopilot_disabled)
				autopilot = FALSE
			else
				autopilot = !autopilot
			. = TRUE
		
		if("apilot_lock")
			autopilot_disabled = !autopilot_disabled
			autopilot = FALSE
			. = TRUE

		if("manual")
			viewing_overmap(usr) ? unlook(usr) : look(usr)
			. = TRUE

	add_fingerprint(usr)
	if(. && !issilicon(usr))
		playsound(src, "terminal_type", 50, 1)


/obj/machinery/computer/ship/navigation
	name = "navigation console"
	icon_keyboard = "generic_key"
	icon_screen = "helm"
	circuit = /obj/item/weapon/circuitboard/nav
	var/datum/tgui_module/ship/nav/nav_tgui

/obj/machinery/computer/ship/navigation/Initialize()
	. = ..()
	nav_tgui = new(src)

/obj/machinery/computer/ship/navigation/Destroy()
	QDEL_NULL(nav_tgui)
	. = ..()

/obj/machinery/computer/ship/navigation/sync_linked(user)
	return nav_tgui?.sync_linked()

/obj/machinery/computer/ship/navigation/tgui_interact(mob/user, datum/tgui/ui)
	return nav_tgui?.tgui_interact(user, ui)

/obj/machinery/computer/ship/navigation/telescreen	//little hacky but it's only used on one ship so it should be okay
	icon_state = "tele_nav"
	layer = ABOVE_WINDOW_LAYER
	icon_keyboard = null
	icon_screen = null
<<<<<<< HEAD
	circuit = /obj/item/weapon/circuitboard/nav/tele
	density = FALSE
=======
	circuit = /obj/item/circuitboard/nav/tele
	density = 0
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/machinery/computer/ship/navigation/telescreen/update_icon()
	if(stat & NOPOWER || stat & BROKEN)
		icon_state = "tele_off"
		set_light(0)
	else
		icon_state = "tele_nav"
		set_light(light_range_on, light_power_on)
	..()
