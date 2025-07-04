/datum/preferences
	var/list/all_underwear
	var/list/all_underwear_metadata

/datum/category_item/player_setup_item/loadout/equipment
	name = "Equipment"
	sort_order = 1

/datum/category_item/player_setup_item/loadout/equipment/load_character(list/save_data)
	pref.all_underwear				= check_list_copy(save_data["all_underwear"])
	pref.all_underwear_metadata		= check_list_copy(save_data["all_underwear_metadata"])
	for(var/i in pref.all_underwear_metadata)
		pref.all_underwear_metadata[i] = path2text_list(pref.all_underwear_metadata[i])
	pref.headset					= save_data["headset"]
	pref.backbag					= save_data["backbag"]
	pref.pdachoice					= save_data["pdachoice"]
	pref.communicator_visibility	= save_data["communicator_visibility"]
	pref.ringtone					= save_data["ringtone"]
	pref.shoe_hater					= save_data["shoe_hater"]
	pref.no_jacket					= save_data["no_jacket"]

/datum/category_item/player_setup_item/loadout/equipment/save_character(list/save_data)
	save_data["all_underwear"]				= pref.all_underwear
	var/list/underwear = list()
	for(var/i in pref.all_underwear_metadata)
		underwear[i] = check_list_copy(pref.all_underwear_metadata[i])
	save_data["all_underwear_metadata"] 	= underwear
	save_data["headset"]					= pref.headset
	save_data["backbag"]					= pref.backbag
	save_data["pdachoice"]					= pref.pdachoice
	save_data["communicator_visibility"]	= pref.communicator_visibility
	save_data["ringtone"]					= pref.ringtone
	save_data["shoe_hater"] 				= pref.shoe_hater
	save_data["no_jacket"]					= pref.no_jacket

var/global/list/valid_ringtones = list(
		"beep",
		"boom",
		"slip",
		"honk",
		"SKREE",
		"xeno",
		"spark",
		"rad",
		"servo",
		"buh-boop",
		"trombone",
		"whistle",
		"chirp",
		"slurp",
		"pwing",
		"clack",
		"bzzt",
		"chimes",
		"prbt",
		"bark",
		"bork",
		"roark",
		"chitter",
		"squish"
		)

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/loadout/equipment/copy_to_mob(var/mob/living/carbon/human/character)
	character.all_underwear.Cut()
	character.all_underwear_metadata.Cut()

	for(var/underwear_category_name in pref.all_underwear)
		var/datum/category_group/underwear/underwear_category = global_underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = pref.all_underwear[underwear_category_name]
			character.all_underwear[underwear_category_name] = underwear_category.items_by_name[underwear_item_name]
			if(pref.all_underwear_metadata[underwear_category_name])
				character.all_underwear_metadata[underwear_category_name] = pref.all_underwear_metadata[underwear_category_name]
		else
			pref.all_underwear -= underwear_category_name

	// TODO - Looks like this is duplicating the work of sanitize_character() if so, remove
	if(pref.headset > GLOB.headsetlist.len || pref.headset < 1)
		pref.headset = 1 //Same as above
	character.headset = pref.headset

	if(pref.backbag > backbaglist.len || pref.backbag < 1)
		pref.backbag = 2 //Same as above
	character.backbag = pref.backbag

	if(pref.pdachoice > 8 || pref.pdachoice < 1)
		pref.pdachoice = 1
	character.pdachoice = pref.pdachoice

/datum/category_item/player_setup_item/loadout/equipment/sanitize_character()
	if(!istype(pref.all_underwear))
		pref.all_underwear = list()

		for(var/datum/category_group/underwear/WRC in global_underwear.categories)
			for(var/datum/category_item/underwear/WRI in WRC.items)
				if(WRI.is_default(pref.identifying_gender ? pref.identifying_gender : MALE))
					pref.all_underwear[WRC.name] = WRI.name
					break

	if(!istype(pref.all_underwear_metadata))
		pref.all_underwear_metadata = list()

	for(var/underwear_category in pref.all_underwear)
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[underwear_category]
		if(!UWC)
			pref.all_underwear -= underwear_category
		else
			var/datum/category_item/underwear/UWI = UWC.items_by_name[pref.all_underwear[underwear_category]]
			if(!UWI)
				pref.all_underwear -= underwear_category

	for(var/underwear_metadata in pref.all_underwear_metadata)
		if(!(underwear_metadata in pref.all_underwear))
			pref.all_underwear_metadata -= underwear_metadata
	pref.headset	= sanitize_integer(pref.headset, 1, GLOB.headsetlist.len, initial(pref.headset))
	pref.backbag	= sanitize_integer(pref.backbag, 1, backbaglist.len, initial(pref.backbag))
	pref.pdachoice	= sanitize_integer(pref.pdachoice, 1, pdachoicelist.len, initial(pref.pdachoice))
	pref.ringtone	= sanitize(pref.ringtone, 20)

/datum/category_item/player_setup_item/loadout/equipment/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/underwear_data = list()
	for(var/datum/category_group/underwear/UWC in global_underwear.categories)
		var/item_name = LAZYACCESS(pref.all_underwear, UWC.name) || "None"

		var/list/tweaks = list()
		var/datum/category_item/underwear/UWI = UWC.items_by_name[item_name]
		if(UWI)
			for(var/datum/gear_tweak/gt in UWI.tweaks)
				UNTYPED_LIST_ADD(tweaks, list(
					"ref" = REF(gt),
					"contents" = gt.get_contents(get_metadata(UWC.name, gt))
				))

		UNTYPED_LIST_ADD(underwear_data, list(
			"category" = UWC.name,
			"name" = item_name,
			"tweaks" = tweaks
		))
	data["underwear"] = underwear_data

	data["headset_type"] = GLOB.headsetlist[pref.headset]
	data["backpack_type"] = backbaglist[pref.backbag]
	data["pda_type"] = pdachoicelist[pref.pdachoice]
	data["communicator_visibility"] = pref.communicator_visibility // boolean
	data["ringtone"] = pref.ringtone
	data["shoes"] = !pref.shoe_hater
	data["jacket"] = !pref.no_jacket

	return data

/datum/category_item/player_setup_item/loadout/equipment/tgui_static_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	return data

/datum/category_item/player_setup_item/loadout/equipment/tgui_constant_data()
	var/list/data = ..()

	data["headsetlist"] = GLOB.headsetlist
	data["backbaglist"] = backbaglist
	data["pdachoicelist"] = pdachoicelist

	return data

/datum/category_item/player_setup_item/loadout/equipment/proc/get_metadata(var/underwear_category, var/datum/gear_tweak/gt)
	var/metadata = pref.all_underwear_metadata[underwear_category]
	if(!metadata)
		metadata = list()
		pref.all_underwear_metadata[underwear_category] = metadata

	var/tweak_data = metadata["[gt]"]
	if(!tweak_data)
		tweak_data = gt.get_default()
		metadata["[gt]"] = tweak_data
	return tweak_data

/datum/category_item/player_setup_item/loadout/equipment/proc/set_metadata(var/underwear_category, var/datum/gear_tweak/gt, var/new_metadata)
	var/list/metadata = pref.all_underwear_metadata[underwear_category]
	metadata["[gt]"] = new_metadata

/datum/category_item/player_setup_item/loadout/equipment/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("change_headset")
			// Takes the JS index
			var/new_headset = text2num(params["headset"]) + 1
			if(LAZYACCESS(GLOB.headsetlist, new_headset))
				pref.headset = new_headset
				return TOPIC_REFRESH_UPDATE_PREVIEW

		if("change_backpack")
			// Takes the JS index
			var/new_backbag = text2num(params["backbag"]) + 1
			if(LAZYACCESS(backbaglist, new_backbag))
				pref.backbag = new_backbag
				return TOPIC_REFRESH_UPDATE_PREVIEW

		if("change_pda")
			// Takes the JS index
			var/new_pdachoice = text2num(params["pda"]) + 1
			if(LAZYACCESS(backbaglist, new_pdachoice))
				pref.pdachoice = new_pdachoice
				return TOPIC_REFRESH_UPDATE_PREVIEW

		if("change_underwear")
			var/datum/category_group/underwear/UWC = LAZYACCESS(global_underwear.categories_by_name, params["underwear"])
			if(!UWC)
				return
			var/datum/category_item/underwear/selected_underwear = tgui_input_list(user, "Choose underwear:", "Character Preference", UWC.items, pref.all_underwear[UWC.name])
			if(selected_underwear)
				pref.all_underwear[UWC.name] = selected_underwear.name
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("underwear_tweak")
			var/underwear = params["underwear"]
			if(!(underwear in pref.all_underwear))
				return TOPIC_NOACTION
			var/datum/gear_tweak/gt = locate(params["tweak"])
			if(!gt)
				return TOPIC_NOACTION
			var/new_metadata = gt.get_metadata(user, get_metadata(underwear, gt))
			if(new_metadata)
				set_metadata(underwear, gt, new_metadata)
				return TOPIC_REFRESH_UPDATE_PREVIEW

		if("toggle_comm_visibility")
			pref.communicator_visibility = !pref.communicator_visibility
			return TOPIC_REFRESH

		if("set_ringtone")
			var/choice = tgui_input_list(user, "Please select a ringtone. All of these choices come with an associated preset sound. Alternately, select \"Other\" to specify manually.", "Character Preference", valid_ringtones + "Other", pref.ringtone)
			if(!choice)
				return TOPIC_NOACTION
			if(choice == "Other")
				var/raw_choice = sanitize(tgui_input_text(user, "Please enter a custom ringtone. If this doesn't match any of the other listed choices, your PDA will use the default (\"beep\") sound.", "Character Preference", null, 20), 20)
				if(raw_choice)
					pref.ringtone = raw_choice
			else
				pref.ringtone = choice
			return TOPIC_REFRESH

		if("toggle_shoes")
			pref.shoe_hater = !pref.shoe_hater
			return TOPIC_REFRESH

		if("toggle_jacket")
			pref.no_jacket = !pref.no_jacket
			return TOPIC_REFRESH
