/datum/tgui_module/ship
	var/obj/effect/overmap/visitable/ship/linked
	var/list/viewers
	var/extra_view = 0

/datum/tgui_module/ship/New()
	. = ..()
	sync_linked()
	if(linked)
		name = "[linked.name] [name]"

/datum/tgui_module/ship/Destroy()
	if(LAZYLEN(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()

/datum/tgui_module/ship/tgui_status(mob/user)
	. = ..()
	if(. > STATUS_DISABLED)
		if(viewing_overmap(user))
			look(user)
		return
	unlook(user)

/datum/tgui_module/ship/tgui_close(mob/user)
	. = ..()
	user.unset_machine()
	unlook(user)

/datum/tgui_module/ship/proc/sync_linked()
	var/obj/effect/overmap/visitable/ship/sector = get_overmap_sector(get_z(tgui_host()))
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/datum/tgui_module/ship/proc/attempt_hook_up_recursive(obj/effect/overmap/visitable/ship/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/ship/candidate in sector)
		if((. = .(candidate)))
			return

/datum/tgui_module/ship/proc/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	if(!istype(sector))
		return
	if(sector.check_ownership(tgui_host()))
		linked = sector
		return 1

/datum/tgui_module/ship/proc/look(var/mob/user)
	if(linked)
		user.set_machine(src)
		user.reset_view(linked)
	user.set_viewsize(world.view + extra_view)
	GLOB.moved_event.register(user, src, /datum/tgui_module/ship/proc/unlook)
	LAZYDISTINCTADD(viewers, weakref(user))

/datum/tgui_module/ship/proc/unlook(var/mob/user)
	user.reset_view()
	user.set_viewsize() // reset to default
	GLOB.moved_event.unregister(user, src, /datum/tgui_module/ship/proc/unlook)
	LAZYREMOVE(viewers, weakref(user))

/datum/tgui_module/ship/proc/viewing_overmap(mob/user)
	return (weakref(user) in viewers)

/datum/tgui_module/ship/check_eye(var/mob/user)
	if(!get_dist(user, tgui_host()) > 1 || user.blinded || !linked)
		unlook(user)
		return -1
	else
		return 0

// Navigation
/datum/tgui_module/ship/nav
	name = "Navigation Display"
	tgui_id = "OvermapNavigation"

/datum/tgui_module/ship/nav/tgui_interact(mob/user, datum/tgui/ui)
	if(!linked)
		var/obj/machinery/computer/ship/navigation/host = tgui_host()
		if(istype(host))
			// Real Computer path
			host.display_reconnect_dialog(user, "Navigation")
			return

		// NTOS Path
		if(!sync_linked())
			to_chat(user, "<span class='warning'>You don't appear to be on a spaceship...</span>")
			if(ui)
				ui.close(can_be_suspended = FALSE)
			if(ntos)
				var/obj/item/modular_computer/M = tgui_host()
				if(istype(M))
					M.kill_program()
		return

	. = ..()

/datum/tgui_module/ship/nav/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["speed"] = round(linked.get_speed()*1000, 0.01)
	data["accel"] = round(linked.get_acceleration()*1000, 0.01)
	data["heading"] = linked.get_heading_degrees()
	data["viewing"] = viewing_overmap(user)

	if(linked.get_speed())
		data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
	else
		data["ETAnext"] = "N/A"

	return data

/datum/tgui_module/ship/nav/tgui_act(action, params)
	if(..())
		return TRUE

	if(!linked)
		return FALSE

	if(action == "viewing")
		viewing_overmap(usr) ? unlook(usr) : look(usr)
		return TRUE

/datum/tgui_module/ship/nav/ntos
	ntos = TRUE

// Full monty control computer
/datum/tgui_module/ship/fullmonty
	name = "Full Monty Overmap Control"
	tgui_id = "OvermapFull"
	// HELM
	var/autopilot = 0
	var/autopilot_disabled = TRUE
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 1/(20 SECONDS) //top speed for autopilot, 5
	var/accellimit = 0.001 //manual limiter for acceleration
	// SENSORS
	var/obj/machinery/shipsensors/sensors

/datum/tgui_module/ship/fullmonty/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/tgui_module/ship/fullmonty/New(host, obj/effect/overmap/visitable/ship/new_linked)
	. = ..()
	if(!istype(new_linked))
		CRASH("Warning, [new_linked] is not an overmap ship! Something went horribly wrong for [usr]!")
	linked = new_linked
	name = initial(name) + " ([linked.name])"
	// HELM
	var/area/overmap/map = locate() in world
	for(var/obj/effect/overmap/visitable/sector/S in map)
		if(S.known)
			var/datum/computer_file/data/waypoint/R = new()
			R.fields["name"] = S.name
			R.fields["x"] = S.x
			R.fields["y"] = S.y
			known_sectors[S.name] = R
	// SENSORS
	for(var/obj/machinery/shipsensors/S in global.machines)
		if(linked.check_ownership(S))
			sensors = S
			break

/datum/tgui_module/ship/fullmonty/relaymove(var/mob/user, direction)
	if(viewing_overmap(user) && linked)
		direction = turn(direction,pick(90,-90))
		linked.relaymove(user, direction, accellimit)
		return 1
	return ..()

// Beware ye eyes. This holds all of the data from helm, engine, and sensor control all at once.
/datum/tgui_module/ship/fullmonty/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	// HELM
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

	// ENGINES
	data["global_state"] = linked.engines_state
	data["global_limit"] = round(linked.thrust_limit*100)
	var/total_thrust = 0

	var/list/enginfo = list()
	for(var/datum/ship_engine/E in linked.engines)
		var/list/rdata = list()
		rdata["eng_type"] = E.name
		rdata["eng_on"] = E.is_on()
		rdata["eng_thrust"] = E.get_thrust()
		rdata["eng_thrust_limiter"] = round(E.get_thrust_limit()*100)
		var/list/status = E.get_status()
		if(!islist(status))
			log_runtime(EXCEPTION("Warning, ship [E.name] (\ref[E]) for [linked.name] returned a non-list status!"))
			status = list("Error")
		rdata["eng_status"] = status
		rdata["eng_reference"] = "\ref[E]"
		total_thrust += E.get_thrust()
		enginfo.Add(list(rdata))

	data["engines_info"] = enginfo
	data["total_thrust"] = total_thrust

	// SENSORS
	data["viewing"] = viewing_overmap(user)
	data["on"] = 0
	data["range"] = "N/A"
	data["health"] = 0
	data["max_health"] = 0
	data["heat"] = 0
	data["critical_heat"] = 0
	data["status"] = "MISSING"
	data["contacts"] = list()

	if(sensors)
		data["on"] = sensors.use_power
		data["range"] = sensors.range
		data["health"] = sensors.health
		data["max_health"] = sensors.max_health
		data["heat"] = sensors.heat
		data["critical_heat"] = sensors.critical_heat
		if(sensors.health == 0)
			data["status"] = "DESTROYED"
		else if(!sensors.powered())
			data["status"] = "NO POWER"
		else if(!sensors.in_vacuum())
			data["status"] = "VACUUM SEAL BROKEN"
		else
			data["status"] = "OK"
		var/list/contacts = list()
		for(var/obj/effect/overmap/O in view(7,linked))
			if(linked == O)
				continue
			if(!O.scannable)
				continue
			var/bearing = round(90 - ATAN2(O.x - linked.x, O.y - linked.y),5)
			if(bearing < 0)
				bearing += 360
			contacts.Add(list(list("name"=O.name, "ref"="\ref[O]", "bearing"=bearing)))
		data["contacts"] = contacts


	return data

// Beware ye eyes. This holds all of the ACTIONS from helm, engine, and sensor control all at once.
/datum/tgui_module/ship/fullmonty/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		/* HELM */
		if("add")
			var/datum/computer_file/data/waypoint/R = new()
			var/sec_name = tgui_input_text(usr, "Input navigation entry name", "New navigation entry", "Sector #[known_sectors.len]", MAX_NAME_LEN)
			sec_name = sanitize(sec_name,MAX_NAME_LEN)
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
					var/newx = tgui_input_number(usr, "Input new entry x coordinate", "Coordinate input", linked.x)
					var/newy = tgui_input_number(usr, "Input new entry y coordinate", "Coordinate input", linked.y)
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
				var/newx = tgui_input_number(usr, "Input new destiniation x coordinate", "Coordinate input", dx)
				if(newx)
					dx = CLAMP(newx, 1, world.maxx)

			if(params["sety"])
				var/newy = tgui_input_number(usr, "Input new destiniation y coordinate", "Coordinate input", dy)
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
			var/newlimit = tgui_input_number(usr, "Input new speed limit for autopilot (0 to brake)", "Autopilot speed limit", speedlimit*1000)
			if(newlimit)
				speedlimit = CLAMP(newlimit/1000, 0, 100)
			. = TRUE

		if("accellimit")
			var/newlimit = tgui_input_number(usr, "Input new acceleration limit", "Acceleration limit", accellimit*1000)
			if(newlimit)
				accellimit = max(newlimit/1000, 0)
			. = TRUE

		if("move")
			var/ndir = text2num(params["dir"])
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
		/* END HELM */
		/* ENGINES */
		if("global_toggle")
			linked.engines_state = !linked.engines_state
			for(var/datum/ship_engine/E in linked.engines)
				if(linked.engines_state == !E.is_on())
					E.toggle()
			. = TRUE

		if("set_global_limit")
			var/newlim = tgui_input_number(usr, "Input new thrust limit (0..100%)", "Thrust limit", linked.thrust_limit*100, 100, 0)
			linked.thrust_limit = clamp(newlim/100, 0, 1)
			for(var/datum/ship_engine/E in linked.engines)
				E.set_thrust_limit(linked.thrust_limit)
			. = TRUE

		if("global_limit")
			linked.thrust_limit = clamp(linked.thrust_limit + text2num(params["global_limit"]), 0, 1)
			for(var/datum/ship_engine/E in linked.engines)
				E.set_thrust_limit(linked.thrust_limit)
			. = TRUE

		if("set_limit")
			var/datum/ship_engine/E = locate(params["engine"])
			var/newlim = tgui_input_number(usr, "Input new thrust limit (0..100)", "Thrust limit", E.get_thrust_limit(), 100, 0)
			var/limit = clamp(newlim/100, 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)
			. = TRUE

		if("limit")
			var/datum/ship_engine/E = locate(params["engine"])
			var/limit = clamp(E.get_thrust_limit() + text2num(params["limit"]), 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)
			. = TRUE

		if("toggle_engine")
			var/datum/ship_engine/E = locate(params["engine"])
			if(istype(E))
				E.toggle()
			. = TRUE
		/* END ENGINES */
		/* SENSORS */
		if("range")
			var/nrange = tgui_input_number(usr, "Set new sensors range", "Sensor range", sensors.range)
			if(nrange)
				sensors.set_range(CLAMP(nrange, 1, world.view))
			. = TRUE
		if("toggle_sensor")
			sensors.toggle()
			. = TRUE
		if("viewing")
			if(usr && !isAI(usr))
				viewing_overmap(usr) ? unlook(usr) : look(usr)
			. = TRUE
		/* END SENSORS */

// We don't want these to do anything.
/datum/tgui_module/ship/fullmonty/sync_linked()
	return
/datum/tgui_module/ship/fullmonty/attempt_hook_up_recursive()
	return
/datum/tgui_module/ship/fullmonty/attempt_hook_up()
	return