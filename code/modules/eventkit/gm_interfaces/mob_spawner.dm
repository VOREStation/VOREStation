/datum/eventkit/mob_spawner
	// The path of the mob to be spawned
	var/path

	// Defines if the location of the spawned mob should be bound of the users position
	var/loc_lock = FALSE

/datum/eventkit/mob_spawner/New()
	. = ..()

/datum/eventkit/mob_spawner/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobSpawner", "EventKit - Mob Spawner")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/eventkit/mob_spawner/Destroy()
	. = ..()

/datum/eventkit/mob_spawner/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/eventkit/mob_spawner/tgui_static_data(mob/user)
	var/list/data = list()

	data["initial_x"] = usr.x;
	data["initial_y"] = usr.y;
	data["initial_z"] = usr.z;

	return data

/datum/eventkit/mob_spawner/tgui_data(mob/user)
	var/list/data = list()

	data["loc_lock"] = loc_lock;
	if(loc_lock)
		data["loc_x"] = usr.x;
		data["loc_y"] = usr.y;
		data["loc_z"] = usr.z;

	data["path"] = path;

	if(path)
		var/mob/M = new path();
		if(M)
			data["default_path_name"] = M.name;
			data["default_desc"] = M.desc;
			data["default_flavor_text"] = M.flavor_text;
			qdel(M);

	return data

/datum/eventkit/mob_spawner/tgui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!check_rights_for(usr.client, R_SPAWN))
		return
	switch(action)
		if("select_path")
			var/list/choices = typesof(/mob)
			var/newPath = tgui_input_list(usr, "Please select the new path of the mob you want to spawn.", items = choices)

			path = newPath

			return TRUE
		if("loc_lock")
			loc_lock = !loc_lock
			return TRUE
		if("start_spawn")
			var/confirm = tgui_alert(usr, "Are you sure that you want to start spawning your custom mobs?", "Confirmation", list("Yes", "Cancel"))

			if(confirm != "Yes")
				return FALSE

			var/amount = params["amount"]
			var/name = params["name"]
			var/x = params["x"]
			var/y = params["y"]
			var/z = params["z"]

			if(!name)
				to_chat(usr, "<span class='warning'>Name cannot be empty.</span>")
				return FALSE

			var/turf/T = locate(x, y, z)
			if(!T)
				to_chat(usr, "<span class='warning'>Those coordinates are outside the boundaries of the map.</span>")
				return FALSE

			for(var/i = 0, i < amount, i++)
				if(ispath(path,/turf))
					var/turf/TU = get_turf(locate(x, y, z))
					TU.ChangeTurf(path)
				else
					var/mob/M = new path(usr.loc)

					M.name = sanitize(name)
					M.desc = sanitize(params["desc"])
					M.flavor_text = sanitize(params["flavor_text"])

					/*
					WIP: Radius around selected coords

					var/list/turf/destTurfs
					for(var/turf/RT in orange(T, params["r"]))
						destTurfs += RT

					var/turf/targetTurf = rand(0,length(destTurfs))
					*/

					var/size_mul = params["size_multiplier"]
					if(isnum(size_mul))
						M.size_multiplier = size_mul
						M.update_icon()
					else
						to_chat(usr, "<span class='warning'>Size Multiplier not applied: ([size_mul]) is not a valid input.</span>")

					M.forceMove(T)

			log_and_message_admins("spawned [path] ([name]) at ([x],[y],[z]) [amount] times.")

			return TRUE

/datum/eventkit/mob_spawner/tgui_close(mob/user)
	. = ..()
	qdel(src)

/client/proc/eventkit_open_mob_spawner()
	set category = "EventKit"
	set name = "Open Mob Spawner"
	set desc = "Opens an advanced version of the mob spawner."

	if(!check_rights(R_SPAWN))
		return

	var/datum/eventkit/mob_spawner/spawner = new()
	spawner.tgui_interact(usr)
