/client
	var/datum/vore_stats/stats_vr

/hook/client_new/proc/add_stats_vr(client/C)
	C.stats_vr = new /datum/vore_stats(C)
	if(C.stats_vr)
		return TRUE

	return FALSE

/datum/vore_stats
	var/client/client
	var/client_ckey
	var/path
	var/slot

	var/stats_times_eaten = 0
	var/stats_eaten_prey = 0
	var/stats_times_digested = 0
	var/stats_digested_prey = 0
	var/stats_times_absorbed = 0
	var/stats_absorbed_prey = 0
	var/stats_times_released = 0
	var/stats_released_prey = 0

/datum/vore_stats/New(client/C)
	if(istype(C))
		client = C
		client_ckey = C.ckey
		load_stats()

// Helpers
/// Usage: mob.client?.stats_vr?.tick_counter("stats_times_eaten", other.read_preference(/datum/preference/toggle/vore_stats))
/datum/vore_stats/proc/tick_counter(name, other_consents = FALSE)
	if(!client.prefs.read_preference(/datum/preference/toggle/vore_stats) || !other_consents)
		return // drop all input when vore stats toggle is off

	switch(name)
		if("stats_times_eaten")
			stats_times_eaten++
		if("stats_eaten_prey")
			stats_eaten_prey++
		if("stats_times_digested")
			stats_times_digested++
		if("stats_digested_prey")
			stats_digested_prey++
		if("stats_times_absorbed")
			stats_times_absorbed++
		if("stats_absorbed_prey")
			stats_absorbed_prey++
		if("stats_times_released")
			stats_times_released++
		if("stats_released_prey")
			stats_released_prey++

	save_stats()

/datum/vore_stats/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["enabled"] = user.read_preference(/datum/preference/toggle/vore_stats)
	data["stats_times_eaten"] = stats_times_eaten
	data["stats_eaten_prey"] = stats_eaten_prey
	data["stats_times_digested"] = stats_times_digested
	data["stats_digested_prey"] = stats_digested_prey
	data["stats_times_absorbed"] = stats_times_absorbed
	data["stats_absorbed_prey"] = stats_absorbed_prey
	data["stats_times_released"] = stats_times_released
	data["stats_released_prey"] = stats_released_prey

	return data

/datum/vore_stats/proc/load_path(ckey, slot, filename = "character_stats", ext = "json")
	if(!ckey || !slot)
		return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/vore/[filename][slot].[ext]"

/datum/vore_stats/proc/load_stats()
	if(!client || !client_ckey)
		return FALSE //No client, how can we save?
	if(!client.prefs || !client.prefs.default_slot)
		return FALSE //Need to know what character to load!

	slot = client.prefs.default_slot
	load_path(client_ckey, slot)

	if(!path)
		return FALSE //Path couldn't be set?

	if(!fexists(path)) //Never saved before
		save_stats() //Make the file first
		return TRUE

	var/list/json_from_file = json_decode(file2text(path))
	if(!json_from_file)
		return FALSE //My concern grows

	var/version = json_from_file["version"]
	json_from_file = patch_version(json_from_file,version)

	// Load stats
	stats_times_eaten = json_from_file["stats_times_eaten"]
	stats_eaten_prey = json_from_file["stats_eaten_prey"]
	stats_times_digested = json_from_file["stats_times_digested"]
	stats_digested_prey = json_from_file["stats_digested_prey"]
	stats_times_absorbed = json_from_file["stats_times_absorbed"]
	stats_absorbed_prey = json_from_file["stats_absorbed_prey"]
	stats_times_released = json_from_file["stats_times_released"]
	stats_released_prey = json_from_file["stats_released_prey"]

	// Sanitize stats
	if(isnull(stats_times_eaten))
		stats_times_eaten = 0
	if(isnull(stats_eaten_prey))
		stats_eaten_prey = 0
	if(isnull(stats_times_digested))
		stats_times_digested = 0
	if(isnull(stats_digested_prey))
		stats_digested_prey = 0
	if(isnull(stats_times_absorbed))
		stats_times_absorbed = 0
	if(isnull(stats_absorbed_prey))
		stats_absorbed_prey = 0
	if(isnull(stats_times_released))
		stats_times_released = 0
	if(isnull(stats_released_prey))
		stats_released_prey = 0


/datum/vore_stats/proc/save_stats()
	if(!path)
		return FALSE

	var/version = VORE_VERSION	//For "good times" use in the future
	var/list/settings_list = list(
		"version" = version,
		"stats_times_eaten" = stats_times_eaten,
		"stats_eaten_prey" = stats_eaten_prey,
		"stats_times_digested" = stats_times_digested,
		"stats_digested_prey" = stats_digested_prey,
		"stats_times_absorbed" = stats_times_absorbed,
		"stats_absorbed_prey" = stats_absorbed_prey,
		"stats_times_released" = stats_times_released,
		"stats_released_prey" = stats_released_prey,
	)

	//List to JSON
	var/json_to_file = json_encode(settings_list)
	if(!json_to_file)
		log_debug("Saving: [path] failed jsonencode")
		return FALSE

	//Write it out
	rustg_file_write(json_to_file, path)

	if(!fexists(path))
		log_debug("Saving: [path] failed file write")
		return FALSE

	return TRUE

/datum/vore_stats/proc/patch_version(json, version)
	// Apply migrations
	return json
