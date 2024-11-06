/datum/eventkit/mob_spawner
	// The path of the mob to be spawned
	var/path

	//The ai type path to be assigned to the mob
	var/use_custom_ai = FALSE
	var/ai_type = ""
	var/faction = ""
	var/intent = ""
	var/new_path = TRUE	//Sets default ai vars based on path. Tracked explicitly because tgui_act wouldn't make it work, used in tgui_data thusly

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

	data["loc_lock"] = loc_lock
	if(loc_lock)
		data["loc_x"] = usr.x
		data["loc_y"] = usr.y
		data["loc_z"] = usr.z

	data["use_custom_ai"] = use_custom_ai
	if(new_path)
		data["path"] = path;
		if(path)
			var/mob/M = new path()
			if(M)
				data["path_name"] = M.name
				data["desc"] = M.desc
				data["flavor_text"] = M.flavor_text
				if(istype(M, /mob/living))
					var/mob/living/L = M

					// AI Stuff
					ai_type = (L.ai_holder_type ? L.ai_holder_type : /datum/ai_holder/simple_mob/inert)
					faction = (L.faction ? L.faction : "neutral")
					intent  = (L.a_intent ? L.a_intent : I_HELP)
					new_path = FALSE

					data["max_health"] = L.maxHealth
					data["health"] = L.health
					if(istype(L, /mob/living/simple_mob))
						var/mob/living/simple_mob/S = L
						data["melee_damage_lower"] = S.melee_damage_lower ? S.melee_damage_lower : 0
						data["melee_damage_upper"] = S.melee_damage_upper ? S.melee_damage_upper : 0
						qdel(S)
					qdel(L)
			qdel(M)
	data["ai_type"] = ai_type
	data["faction"] = faction
	data["intent"]	= intent


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
			new_path = TRUE
			return TRUE
		if("toggle_custom_ai")
			use_custom_ai = !use_custom_ai
			return TRUE
		if("set_faction")
			faction = sanitize(tgui_input_text(usr, "Please input your mobs' faction", "Faction", (faction ? faction : "neutral")))
			return TRUE
		if("set_intent")
			intent = tgui_input_list(usr, "Please select preferred intent", "Select Intent", list(I_HELP, I_HURT), (intent ? intent : I_HELP))
			return TRUE
		if("set_ai_path")
			ai_type = tgui_input_list(usr, "Select AI path. Not all subtypes are compatible!", "AI type", \
			typesof(/datum/ai_holder/), (ai_type ? ai_type : /datum/ai_holder/simple_mob/inert))
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
				to_chat(usr, span_warning("Name cannot be empty."))
				return FALSE

			var/turf/T = locate(x, y, z)
			if(!T)
				to_chat(usr, span_warning("Those coordinates are outside the boundaries of the map."))
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
					if(istype(M, /mob/living))
						var/mob/living/L = M
						if(isnum(params["max_health"]))
							L.maxHealth = params["max_health"]
						if(isnum(params["health"]))
							L.health = params["health"]
						if(istype(M, /mob/living/simple_mob))
							var/mob/living/simple_mob/S = L
							if(isnum(params["melee_damage_lower"]))
								S.melee_damage_lower = params["melee_damage_lower"]
							if(isnum(params["melee_damage_upper"]))
								S.melee_damage_upper = params["melee_damage_upper"]
						if(use_custom_ai)
							L.ai_holder_type = ai_type
							L.faction = faction
							L.a_intent = intent
							L.initialize_ai_holder()
							L.AdjustSleeping(-100)
						else
							to_chat(usr, span_notice("You can only set AI for subtypes of mob/living!"))



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
						to_chat(usr, span_warning("Size Multiplier not applied: ([size_mul]) is not a valid input."))

					M.forceMove(T)

			log_and_message_admins("spawned [path] ([name]) at ([x],[y],[z]) [amount] times.")

			return TRUE

/datum/eventkit/mob_spawner/tgui_close(mob/user)
	. = ..()
	qdel(src)

/client/proc/eventkit_open_mob_spawner()
	set category = "Fun.Event Kit"
	set name = "Open Mob Spawner"
	set desc = "Opens an advanced version of the mob spawner."

	if(!check_rights(R_SPAWN))
		return

	var/datum/eventkit/mob_spawner/spawner = new()
	spawner.tgui_interact(usr)
