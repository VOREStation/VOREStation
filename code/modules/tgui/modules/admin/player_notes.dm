//#define PLAYER_NOTES_ENTRIES_PER_PAGE 50

/datum/tgui_module/player_notes
	name = "Player Notes"
	tgui_id = "PlayerNotes"

	var/ckeys = list()

/datum/tgui_module/player_notes/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/tgui_module/player_notes/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("show_player_info")
			var/datum/tgui_module/player_notes_info/A = new(src)
			A.key = params["name"]
			A.tgui_interact(usr)

		if("filter_player_notes")
			var/filter = tgui_input_text(usr, "Filter string (case-insensitive regex)", "Player notes filter")
			var/savefile/S=new("data/player_notes.sav")
			var/list/note_keys
			var/page = 1

			S >> note_keys

			if(note_keys)
				note_keys = sortList(note_keys)

				if(filter)
					var/list/results = list()
					var/regex/needle = regex(filter, "i")
					for(var/haystack in note_keys)
						if(needle.Find(haystack))
							results += haystack
					note_keys = results

				// Display the notes on the current page
				//var/number_pages = note_keys.len / PLAYER_NOTES_ENTRIES_PER_PAGE
				// Emulate CEILING(why does BYOND not have ceil, 1)
				//if(number_pages != round(number_pages))
				//	number_pages = round(number_pages) + 1
				//var/page_index = page - 1

				//if(page_index < 0 || page_index >= number_pages)
				//	//dat += "<tr><td>No keys found.</td></tr>"
				//else
					//var/lower_bound = page_index * PLAYER_NOTES_ENTRIES_PER_PAGE + 1
					//var/upper_bound = (page_index + 1) * PLAYER_NOTES_ENTRIES_PER_PAGE
					//upper_bound = min(upper_bound, note_keys.len)
					//for(var/index = lower_bound, index <= upper_bound, index++)
						//var/t = note_keys[index]

				// Display a footer to select different pages
				//for(var/index = 1, index <= number_pages, index++)
				//	if(index == page)
				//		dat += "<b>"
				//	dat += "<a href='?src=\ref[src];notes=list;index=[index];filter=[filter ? url_encode(filter) : 0]'>[index]</a> "
				//	if(index == page)
				//		dat += "</b>"
			
				ckeys = note_keys

/datum/tgui_module/player_notes/tgui_data(mob/user)
	var/list/data = list()

	data["ckeys"] = list()

	for(var/ckey in ckeys)
		data["ckeys"] += list(list(
				"name" = ckey
			))

	return data

/datum/tgui_module/player_notes_info
	name = "Player Notes Info"
	tgui_id = "PlayerNotesInfo"

	var/key = null

/datum/tgui_module/player_notes_info/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/tgui_module/player_notes_info/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("add_player_info")
			var/key = params["ckey"]
			var/add = tgui_input_message(usr, "Write your comment below.", "Add Player Info")
			if(!add) return

			notes_add(key,add,usr)

		if("remove_player_info")
			var/key = params["ckey"]
			var/index = params["index"]

			notes_del(key, index)

/datum/tgui_module/player_notes_info/tgui_data(mob/user)
	var/list/data = list()

	if(!key)
		return

	var/p_age = "unknown"
	for(var/client/C in GLOB.clients)
		if(C.ckey == key)
			p_age = C.player_age
			break

	data["entries"] = list()

	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(infos)
		var/update_file = 0
		var/i = 0
		for(var/datum/player_info/I in infos)
			i += 1
			if(!I.timestamp)
				I.timestamp = "Pre-4/3/2012"
				update_file = 1
			if(!I.rank)
				I.rank = "N/A"
				update_file = 1

			data["entries"] += list(list(
					"comment" = I.content,
					"author" = "[I.author] ([I.rank])",
					"date" = "[I.timestamp]"
				))
		if(update_file) info << infos

	data["ckey"] = key
	data["age"] = p_age

	return data
