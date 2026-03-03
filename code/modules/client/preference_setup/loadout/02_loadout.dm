var/list/loadout_categories = list()
var/list/gear_datums = list()

/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/loadout_category/New(var/cat)
	category = cat
	..()

/hook/startup/proc/populate_gear_list()

	//create a list of gear datums to sort
	for(var/datum/gear/G as anything in subtypesof(/datum/gear))
		if(initial(G.type_category) == G)
			continue
		var/use_name = initial(G.display_name)
		var/use_category = initial(G.sort_category)

		if(!use_name)
			log_world("## ERROR Loadout - Missing display name: [G]")
			continue
		if(isnull(initial(G.cost)))
			log_world("## ERROR Loadout - Missing cost: [G]")
			continue
		if(!initial(G.path))
			log_world("## ERROR Loadout - Missing path definition: [G]")
			continue

		if(!loadout_categories[use_category])
			loadout_categories[use_category] = new /datum/loadout_category(use_category)
		var/datum/loadout_category/LC = loadout_categories[use_category]
		gear_datums[use_name] = new G
		LC.gear[use_name] = gear_datums[use_name]

	loadout_categories = sortAssoc(loadout_categories)
	for(var/loadout_category in loadout_categories)
		var/datum/loadout_category/LC = loadout_categories[loadout_category]
		LC.gear = sortAssoc(LC.gear)
	return 1

/datum/category_item/player_setup_item/loadout/loadout
	name = "Loadout"
	sort_order = 2
	var/current_tab = "General"

/datum/category_item/player_setup_item/loadout/loadout/load_character(list/save_data)
	pref.gear_list = list()
	var/all_gear = check_list_copy(save_data["gear_list"])
	for(var/i in all_gear)
		var/list/entries = check_list_copy(all_gear["[i]"])
		for(var/j in entries)
			entries["[j]"] = path2text_list(entries["[j]"])
		pref.gear_list["[i]"] = entries
	pref.gear_slot = save_data["gear_slot"] || 1

/datum/category_item/player_setup_item/loadout/loadout/save_character(list/save_data)
	var/list/all_gear = list()
	var/worn_gear = check_list_copy(pref.gear_list)
	for(var/i in worn_gear)
		var/list/entries = check_list_copy(worn_gear["[i]"])
		if(!length(entries))
			entries = check_list_copy(worn_gear[i])
		for(var/j in entries)
			entries["[j]"] = check_list_copy(entries["[j]"])
		all_gear["[i]"] = entries
	save_data["gear_list"] = all_gear
	save_data["gear_slot"] = pref.gear_slot

/datum/category_item/player_setup_item/loadout/loadout/proc/is_valid_gear(datum/gear/G, max_cost)
	if(G.whitelisted && CONFIG_GET(flag/loadout_whitelist) != LOADOUT_WHITELIST_OFF && pref.client)
		if(CONFIG_GET(flag/loadout_whitelist) == LOADOUT_WHITELIST_STRICT && (G.whitelisted != pref.species && G.whitelisted != pref.custom_base))
			return FALSE
		if(CONFIG_GET(flag/loadout_whitelist) == LOADOUT_WHITELIST_LAX && !is_alien_whitelisted(pref.client, GLOB.all_species[G.whitelisted]))
			return FALSE

	if(max_cost && G.cost > max_cost)
		return FALSE
	if(pref.client)
		if(G.ckeywhitelist && !(pref.client_ckey in G.ckeywhitelist))
			return FALSE
		if(G.character_name && !(pref.read_preference(/datum/preference/name/real_name) in G.character_name))
			return FALSE
	return TRUE

/datum/category_item/player_setup_item/loadout/loadout/sanitize_character()
	var/mob/preference_mob = preference_mob()

	if(pref.gear_slot > LAZYLEN(pref.gear_list))
		pref.gear_slot = 1

	var/list/active_gear_list = LAZYACCESS(pref.gear_list, "[pref.gear_slot]")
	if(!active_gear_list)
		pref.gear_list["[pref.gear_slot]"] = list()
		active_gear_list = LAZYACCESS(pref.gear_list, "[pref.gear_slot]")

	var/total_cost = 0
	for(var/gear_name in active_gear_list)
		if(!gear_datums[gear_name])
			to_chat(preference_mob, span_warning("You cannot have the \the [gear_name]."))
			active_gear_list -= gear_name
			continue

		var/datum/gear/G = gear_datums[gear_name]
		if(!is_valid_gear(G))
			to_chat(preference_mob, span_warning("You cannot take \the [gear_name] as you are not whitelisted for the species or item."))
			active_gear_list -= gear_name
			continue

		if(total_cost + G.cost > MAX_GEAR_COST)
			active_gear_list -= gear_name
			to_chat(preference_mob, span_warning("You cannot afford to take \the [gear_name]"))
			continue
		total_cost += G.cost

/datum/category_item/player_setup_item/loadout/loadout/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["total_cost"] = get_total()
	data["gear_slot"] = pref.gear_slot
	var/list/active_gear_list = LAZYACCESS(pref.gear_list, "[pref.gear_slot]")
	data["active_gear_list"] = active_gear_list

	var/list/gear_tweaks = list()
	for(var/item in active_gear_list)
		var/datum/gear/G = gear_datums[item]
		var/list/tweaks = list()
		for(var/datum/gear_tweak/tweak in G.gear_tweaks)
			UNTYPED_LIST_ADD(tweaks, list(
				"ref" = REF(tweak),
				"contents" = tweak.get_contents(get_tweak_metadata(G, tweak))
			))
		gear_tweaks[G.display_name] = tweaks
	data["gear_tweaks"] = gear_tweaks

	return data

/datum/category_item/player_setup_item/loadout/loadout/tgui_static_data(mob/user)
	var/list/data = ..()

	var/list/categories = list()
	for(var/category in loadout_categories)
		var/datum/loadout_category/LC = loadout_categories[category]
		var/list/items = list()
		for(var/gear in LC.gear)
			var/datum/gear/G = LC.gear[gear]
			if(!is_valid_gear(G))
				continue

			UNTYPED_LIST_ADD(items, list(
				"name" = G.display_name,
				"desc" = G.description,
				"cost" = G.cost,
				"show_roles" = G.show_roles,
				"allowed_roles" = G.allowed_roles
			))
		categories[category] = items
	data["categories"] = categories

	data["max_gear_cost"] = MAX_GEAR_COST

	return data

/datum/category_item/player_setup_item/loadout/loadout/proc/get_gear_metadata(var/datum/gear/G)
	var/list/active_gear_list = LAZYACCESS(pref.gear_list, "[pref.gear_slot]")

	// {"/datum/gear_tweak/custom_name": "" }
	. = LAZYACCESS(active_gear_list, G.display_name)
	if(!.)
		. = list()

/datum/category_item/player_setup_item/loadout/loadout/proc/get_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak)
	var/list/metadata = get_gear_metadata(G)
	. = metadata["[tweak]"]
	if(isnull(.))
		. = tweak.get_default()
		metadata["[tweak]"] = .

/datum/category_item/player_setup_item/loadout/loadout/proc/set_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak, var/new_metadata)
	var/list/metadata = get_gear_metadata(G)
	metadata["[tweak]"] = new_metadata

/datum/category_item/player_setup_item/loadout/loadout/proc/get_total()
	var/list/active_gear_list = LAZYACCESS(pref.gear_list, "[pref.gear_slot]")
	. = 0
	for(var/gear_name in active_gear_list)
		var/datum/gear/G = gear_datums[gear_name]
		if(G)
			. += G.cost

/datum/category_item/player_setup_item/loadout/loadout/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/list/active_gear_list = LAZYACCESS(pref.gear_list, "[pref.gear_slot]")
	var/mob/user = ui.user

	switch(action)
		if("next_slot")
			pref.gear_slot = pref.gear_slot + 1
			if(pref.gear_slot > CONFIG_GET(number/loadout_slots))
				pref.gear_slot = 1
			if(!("[pref.gear_slot]" in pref.gear_list))
				pref.gear_list["[pref.gear_slot]"] = list()
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("prev_slot")
			pref.gear_slot = pref.gear_slot - 1
			if(pref.gear_slot <= 0)
				pref.gear_slot = CONFIG_GET(number/loadout_slots)
			if(!("[pref.gear_slot]" in pref.gear_list))
				pref.gear_list["[pref.gear_slot]"] = list()
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("clear_loadout")
			active_gear_list?.Cut()
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("copy_loadout")
			var/copy_to = tgui_input_number(user, "What slot would you like to copy slot [pref.gear_slot] to?", "Copy Slot", 1, CONFIG_GET(number/loadout_slots), 1)
			if(!copy_to)
				return TOPIC_HANDLED

			if("[copy_to]" in pref.gear_list)
				var/confirm = tgui_alert(user, "This will overwrite slot [copy_to], are you sure?", "Are you sure?", list("No", "Yes"))
				if(confirm != "Yes")
					return TOPIC_HANDLED

			pref.gear_list["[copy_to]"] = check_list_copy(active_gear_list)
			return TOPIC_REFRESH

		if("toggle_gear")
			var/datum/gear/TG = gear_datums[params["gear"]]
			if(TG)
				if(TG.display_name in active_gear_list)
					active_gear_list -= TG.display_name
				else if(get_total() + TG.cost <= MAX_GEAR_COST)
					LAZYSET(active_gear_list, TG.display_name, list())
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("gear_tweak")
			var/datum/gear/gear = gear_datums[params["gear"]]
			var/datum/gear_tweak/tweak = locate(params["tweak"])
			if(!tweak || !gear || !(tweak in gear.gear_tweaks))
				return TOPIC_HANDLED
			var/metadata
			if(istype(tweak, /datum/gear_tweak/matrix_recolor))
				metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak), gear)
			else
				metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
			if(isnull(metadata))
				return TOPIC_HANDLED
			set_tweak_metadata(gear, tweak, metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW

/datum/gear
	var/display_name       //Name/index. Must be unique.
	var/description        //Description of this gear. If left blank will default to the description of the pathed item.
	var/path               //Path to item.
	var/cost = 1           //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/show_roles = TRUE	//Show the role restrictions on this item?
	var/whitelisted        //Term to check the whitelist for..
	var/sort_category = "General"
	var/list/gear_tweaks = list() //List of datums which will alter the item after it has been spawned.
	var/exploitable = 0		//Does it go on the exploitable information list?
	var/type_category = null
	var/list/ckeywhitelist	//restricted based on these ckeys?
	var/list/character_name	//restricted to these character names?

/datum/gear/New()
	..()
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	gear_tweaks = list(GLOB.gear_tweak_free_name, GLOB.gear_tweak_free_desc, GLOB.gear_tweak_item_tf_spawn, GLOB.gear_tweak_free_matrix_recolor, GLOB.gear_tweak_free_digestable)

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(var/path, var/location)
	src.path = path
	src.location = location

/datum/gear/proc/spawn_item(var/location, var/metadata)
	var/datum/gear_data/gd = new(path, location)
	if(length(gear_tweaks) && metadata)
		for(var/datum/gear_tweak/gt in gear_tweaks)
			gt.tweak_gear_data(metadata["[gt]"], gd)
	var/item = new gd.path(gd.location)
	if(length(gear_tweaks) && metadata)
		for(var/datum/gear_tweak/gt in gear_tweaks)
			gt.tweak_item(item, metadata["[gt]"])
	var/mob/M = location
	if(istype(M) && exploitable) //Update exploitable info records for the mob without creating a duplicate object at their feet.
		M.amend_exploitable(item)
	return item
