/datum/preferences
	var/list/all_underwear
	var/list/all_underwear_metadata

/datum/category_item/player_setup_item/general/equipment
	name = "Clothing"
	sort_order = 4

/datum/category_item/player_setup_item/general/equipment/load_character(list/save_data)
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

/datum/category_item/player_setup_item/general/equipment/save_character(list/save_data)
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
/datum/category_item/player_setup_item/general/equipment/copy_to_mob(var/mob/living/carbon/human/character)
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

/datum/category_item/player_setup_item/general/equipment/sanitize_character()
	if(!islist(pref.gear)) pref.gear = list()

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

/datum/category_item/player_setup_item/general/equipment/content()
	. = list()
	. += span_bold("Equipment:") + "<br>"
	for(var/datum/category_group/underwear/UWC in global_underwear.categories)
		var/item_name = pref.all_underwear[UWC.name] ? pref.all_underwear[UWC.name] : "None"
		. += "[UWC.name]: <a href='?src=\ref[src];change_underwear=[UWC.name]'><b>[item_name]</b></a>"
		var/datum/category_item/underwear/UWI = UWC.items_by_name[item_name]
		if(UWI)
			for(var/datum/gear_tweak/gt in UWI.tweaks)
				. += " <a href='?src=\ref[src];underwear=[UWC.name];tweak=\ref[gt]'>[gt.get_contents(get_metadata(UWC.name, gt))]</a>"

		. += "<br>"
	. += "Headset Type: <a href='?src=\ref[src];change_headset=1'><b>[headsetlist[pref.headset]]</b></a><br>"
	. += "Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[backbaglist[pref.backbag]]</b></a><br>"
	. += "PDA Type: <a href='?src=\ref[src];change_pda=1'><b>[pdachoicelist[pref.pdachoice]]</b></a><br>"
	. += "Communicator Visibility: <a href='?src=\ref[src];toggle_comm_visibility=1'><b>[(pref.communicator_visibility) ? "Yes" : "No"]</b></a><br>"
	. += "Ringtone (leave blank for job default): <a href='?src=\ref[src];set_ringtone=1'><b>[pref.ringtone]</b></a><br>"
	. += "Spawn With Shoes:<a href='?src=\ref[src];toggle_shoes=1'><b>[(pref.shoe_hater) ? "No" : "Yes"]</b></a><br>" //RS Addition

	return jointext(.,null)

/datum/category_item/player_setup_item/general/equipment/proc/get_metadata(var/underwear_category, var/datum/gear_tweak/gt)
	var/metadata = pref.all_underwear_metadata[underwear_category]
	if(!metadata)
		metadata = list()
		pref.all_underwear_metadata[underwear_category] = metadata

	var/tweak_data = metadata["[gt]"]
	if(!tweak_data)
		tweak_data = gt.get_default()
		metadata["[gt]"] = tweak_data
	return tweak_data

/datum/category_item/player_setup_item/general/equipment/proc/set_metadata(var/underwear_category, var/datum/gear_tweak/gt, var/new_metadata)
	var/list/metadata = pref.all_underwear_metadata[underwear_category]
	metadata["[gt]"] = new_metadata


/datum/category_item/player_setup_item/general/equipment/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["change_headset"])
		var/new_headset = tgui_input_list(user, "Choose your character's style of headset:", "Character Preference", headsetlist, headsetlist[pref.headset])
		if(!isnull(new_headset) && CanUseTopic(user))
			pref.headset = GLOB.headsetlist.Find(new_headset)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["change_backpack"])
		var/new_backbag = tgui_input_list(user, "Choose your character's style of bag:", "Character Preference", backbaglist, backbaglist[pref.backbag])
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag = backbaglist.Find(new_backbag)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_pda"])
		var/new_pdachoice = tgui_input_list(user, "Choose your character's style of PDA:", "Character Preference", pdachoicelist, pdachoicelist[pref.pdachoice])
		if(!isnull(new_pdachoice) && CanUseTopic(user))
			pref.pdachoice = pdachoicelist.Find(new_pdachoice)
			return TOPIC_REFRESH

	else if(href_list["change_underwear"])
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[href_list["change_underwear"]]
		if(!UWC)
			return
		var/datum/category_item/underwear/selected_underwear = tgui_input_list(user, "Choose underwear:", "Character Preference", UWC.items, pref.all_underwear[UWC.name])
		if(selected_underwear && CanUseTopic(user))
			pref.all_underwear[UWC.name] = selected_underwear.name
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["underwear"] && href_list["tweak"])
		var/underwear = href_list["underwear"]
		if(!(underwear in pref.all_underwear))
			return TOPIC_NOACTION
		var/datum/gear_tweak/gt = locate(href_list["tweak"])
		if(!gt)
			return TOPIC_NOACTION
		var/new_metadata = gt.get_metadata(usr, get_metadata(underwear, gt))
		if(new_metadata)
			set_metadata(underwear, gt, new_metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["toggle_comm_visibility"])
		if(CanUseTopic(user))
			pref.communicator_visibility = !pref.communicator_visibility
			return TOPIC_REFRESH
	else if(href_list["set_ringtone"])
		var/choice = tgui_input_list(user, "Please select a ringtone. All of these choices come with an associated preset sound. Alternately, select \"Other\" to specify manually.", "Character Preference", valid_ringtones + "Other", pref.ringtone)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(tgui_input_text(user, "Please enter a custom ringtone. If this doesn't match any of the other listed choices, your PDA will use the default (\"beep\") sound.", "Character Preference", null, 20), 20)
			if(raw_choice && CanUseTopic(user))
				pref.ringtone = raw_choice
		else
			pref.ringtone = choice
		return TOPIC_REFRESH
	else if(href_list["toggle_shoes"])	//RS ADD START
		if(CanUseTopic(user))
			pref.shoe_hater = !pref.shoe_hater
			return TOPIC_REFRESH
			//RS ADD END

	return ..()
