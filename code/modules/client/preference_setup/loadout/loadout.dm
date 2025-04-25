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
			error("Loadout - Missing display name: [G]")
			continue
		if(isnull(initial(G.cost)))
			error("Loadout - Missing cost: [G]")
			continue
		if(!initial(G.path))
			error("Loadout - Missing path definition: [G]")
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

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	var/current_tab = "General"

/datum/category_item/player_setup_item/loadout/load_character(list/save_data)
	pref.gear_list = list()
	var/all_gear = check_list_copy(save_data["gear_list"])
	for(var/i in all_gear)
		var/list/entries = check_list_copy(all_gear["[i]"])
		for(var/j in entries)
			entries["[j]"] = path2text_list(entries["[j]"])
		pref.gear_list["[i]"] = entries
	pref.gear_slot = save_data["gear_slot"]
	if(pref.gear_list!=null && pref.gear_slot!=null)
		pref.gear = pref.gear_list["[pref.gear_slot]"]
	else
		pref.gear = check_list_copy(save_data["gear"])
		pref.gear_slot = 1

/datum/category_item/player_setup_item/loadout/save_character(list/save_data)
	pref.gear_list["[pref.gear_slot]"] = pref.gear
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

/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	. = list()
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]

		if(G.whitelisted && CONFIG_GET(flag/loadout_whitelist) != LOADOUT_WHITELIST_OFF && pref.client) //VOREStation Edit.
			if(CONFIG_GET(flag/loadout_whitelist) == LOADOUT_WHITELIST_STRICT && G.whitelisted != pref.species)
				continue
			if(CONFIG_GET(flag/loadout_whitelist) == LOADOUT_WHITELIST_LAX && !is_alien_whitelisted(pref.client, GLOB.all_species[G.whitelisted]))
				continue

		if(max_cost && G.cost > max_cost)
			continue
		if(pref.client)
			if(G.ckeywhitelist && !(pref.client_ckey in G.ckeywhitelist))
				continue
			if(G.character_name && !(pref.client.prefs.real_name in G.character_name))
				continue
		. += gear_name

/datum/category_item/player_setup_item/loadout/sanitize_character()
	var/mob/preference_mob = preference_mob()
	if(!islist(pref.gear))
		pref.gear = list()
	if(!islist(pref.gear_list))
		pref.gear_list = list()

	for(var/gear_name in pref.gear)
		if(!(gear_name in gear_datums))
			pref.gear -= gear_name
	var/total_cost = 0
	for(var/gear_name in pref.gear)
		if(!gear_datums[gear_name])
			to_chat(preference_mob, span_warning("You cannot have more than one of the \the [gear_name]"))
			pref.gear -= gear_name
		else if(!(gear_name in valid_gear_choices()))
			to_chat(preference_mob, span_warning("You cannot take \the [gear_name] as you are not whitelisted for the species or item."))		//Vorestation Edit
			pref.gear -= gear_name
		else
			var/datum/gear/G = gear_datums[gear_name]
			if(total_cost + G.cost > MAX_GEAR_COST)
				pref.gear -= gear_name
				to_chat(preference_mob, span_warning("You cannot afford to take \the [gear_name]"))
			else
				total_cost += G.cost

/datum/category_item/player_setup_item/loadout/content()
	. = list()
	var/mob/preference_mob = preference_mob()	//Vorestation Edit
	var/total_cost = 0
	if(pref.gear && pref.gear.len)
		for(var/i = 1; i <= pref.gear.len; i++)
			var/datum/gear/G = gear_datums[pref.gear[i]]
			if(G)
				total_cost += G.cost

	var/fcolor =  "#3366CC"
	if(total_cost < MAX_GEAR_COST)
		fcolor = "#E67300"

	. += "<table align = 'center' width = 100%>"
	. += "<tr><td colspan=3><center><a href='byond://?src=\ref[src];prev_slot=1'>\<\<</a>" + span_bold("<font color = '[fcolor]'>\[[pref.gear_slot]\]</font> ") + "<a href='byond://?src=\ref[src];next_slot=1'>\>\></a>" + span_bold("<font color = '[fcolor]'>[total_cost]/[MAX_GEAR_COST]</font> loadout points spent.") + " \[<a href='byond://?src=\ref[src];clear_loadout=1'>Clear Loadout</a>\]</center></td></tr>"

	. += "<tr><td colspan=3><center><b>"
	var/firstcat = 1
	for(var/category in loadout_categories)

		if(firstcat)
			firstcat = 0
		else
			. += " |"

		var/datum/loadout_category/LC = loadout_categories[category]
		var/category_cost = 0
		for(var/gear in LC.gear)
			if(gear in pref.gear)
				var/datum/gear/G = LC.gear[gear]
				category_cost += G.cost

		if(category == current_tab)
			. += " " + span_linkOn("[category] - [category_cost]") + " "
		else
			if(category_cost)
				. += " <a href='byond://?src=\ref[src];select_category=[category]'><font color = '#E67300'>[category] - [category_cost]</font></a> "
			else
				. += " <a href='byond://?src=\ref[src];select_category=[category]'>[category] - 0</a> "
	. += "</b></center></td></tr>"

	var/datum/loadout_category/LC = loadout_categories[current_tab]
	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3>" + span_bold("<center>[LC.category]</center>") + "</td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	for(var/gear_name in LC.gear)
		var/datum/gear/G = LC.gear[gear_name]
		if(preference_mob && preference_mob.client)
			if(G.ckeywhitelist && !(preference_mob.ckey in G.ckeywhitelist))
				continue
			if(G.character_name && !(preference_mob.client.prefs.real_name in G.character_name))
				continue
		var/ticked = (G.display_name in pref.gear)
		. += "<tr style='vertical-align:top;'><td width=25%><a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='byond://?src=\ref[src];toggle_gear=[html_encode(G.display_name)]'>[G.display_name]</a></td>"
		. += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		. += "<td>" + span_normal(span_italics("[G.description]")) + "</td></tr>"
		if(G.show_roles && G.allowed_roles)
			. += "<td colspan=3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Restricted to: [list2text(G.allowed_roles,", ")]</td>"
		if(ticked)
			. += "<tr><td colspan=3>"
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				. += " <a href='byond://?src=\ref[src];gear=[url_encode(G.display_name)];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
			. += "</td></tr>"
	. += "</table>"
	. = jointext(., null)

/datum/category_item/player_setup_item/loadout/proc/get_gear_metadata(var/datum/gear/G)
	. = pref.gear[G.display_name]
	if(!.)
		. = list()
		pref.gear[G.display_name] = .

/datum/category_item/player_setup_item/loadout/proc/get_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak)
	var/list/metadata = get_gear_metadata(G)
	. = metadata["[tweak]"]
	if(!.)
		. = tweak.get_default()
		metadata["[tweak]"] = .

/datum/category_item/player_setup_item/loadout/proc/set_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak, var/new_metadata)
	var/list/metadata = get_gear_metadata(G)
	metadata["[tweak]"] = new_metadata

/datum/category_item/player_setup_item/loadout/OnTopic(href, href_list, user)
	if(href_list["toggle_gear"])
		var/datum/gear/TG = gear_datums[href_list["toggle_gear"]]
		if(TG.display_name in pref.gear)
			pref.gear -= TG.display_name
		else
			var/total_cost = 0
			for(var/gear_name in pref.gear)
				var/datum/gear/G = gear_datums[gear_name]
				if(istype(G)) total_cost += G.cost
			if((total_cost+TG.cost) <= MAX_GEAR_COST)
				pref.gear += TG.display_name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["gear"] && href_list["tweak"])
		var/datum/gear/gear = gear_datums[url_decode(href_list["gear"])]
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks))
			return TOPIC_NOACTION
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION
		set_tweak_metadata(gear, tweak, metadata)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["next_slot"] || href_list["prev_slot"])
		//Set the current slot in the gear list to the currently selected gear
		pref.gear_list["[pref.gear_slot]"] = pref.gear
		//If we're moving up a slot..
		if(href_list["next_slot"])
			//change the current slot number
			pref.gear_slot = pref.gear_slot+1
			if(pref.gear_slot > CONFIG_GET(number/loadout_slots))
				pref.gear_slot = 1
		//If we're moving down a slot..
		else if(href_list["prev_slot"])
			//change current slot one down
			pref.gear_slot = pref.gear_slot-1
			if(pref.gear_slot<1)
				pref.gear_slot = CONFIG_GET(number/loadout_slots)
		// Set the currently selected gear to whatever's in the new slot
		if(pref.gear_list["[pref.gear_slot]"])
			pref.gear = pref.gear_list["[pref.gear_slot]"]
		else
			pref.gear = list()
			pref.gear_list["[pref.gear_slot]"] = list()
		// Refresh?
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["select_category"])
		current_tab = href_list["select_category"]
		return TOPIC_REFRESH
	else if(href_list["clear_loadout"])
		pref.gear.Cut()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	return ..()

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
	gear_tweaks = list(gear_tweak_free_name, gear_tweak_free_desc)

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
