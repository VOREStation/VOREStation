#define PLAYER_NOTES_ENTRIES_PER_PAGE 50

/datum/tgui_module/player_notes
	name = "Player Notes"
	tgui_id = "PlayerNotes"

	var/ckeys = list()

	var/current_filter = ""
	var/current_page = 1

	var/number_pages = 0

/datum/tgui_module/player_notes/proc/filter_ckeys(var/page, var/filter)
	var/savefile/S=new("data/player_notes.sav")
	var/list/note_keys
	S >> note_keys
	if(!note_keys)
		to_chat(usr, "No notes found.")
	else
		note_keys = sortList(note_keys)

		if(filter)
			var/list/results = list()
			var/regex/needle = regex(filter, "i")
			for(var/haystack in note_keys)
				if(needle.Find(haystack))
					results += haystack
			note_keys = results

		// Display the notes on the current page
		number_pages = note_keys.len / PLAYER_NOTES_ENTRIES_PER_PAGE
		// Emulate CEILING(why does BYOND not have ceil, 1)
		if(number_pages != round(number_pages))
			number_pages = round(number_pages) + 1
		var/page_index = page - 1

		if(page_index < 0 || page_index >= number_pages)
			to_chat(usr, "No keys found.")
		else
			var/lower_bound = page_index * PLAYER_NOTES_ENTRIES_PER_PAGE + 1
			var/upper_bound = (page_index + 1) * PLAYER_NOTES_ENTRIES_PER_PAGE
			upper_bound = min(upper_bound, note_keys.len)
			ckeys = list()
			for(var/index = lower_bound, index <= upper_bound, index++)
				ckeys += note_keys[index]

	current_filter = filter

/datum/tgui_module/player_notes/proc/open_legacy()
	var/datum/admins/A = admin_datums[usr.ckey]
	A.PlayerNotesLegacy()

/datum/tgui_module/player_notes/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/tgui_module/player_notes/tgui_fallback(payload)
	if(..())
		return TRUE

	open_legacy()

/datum/tgui_module/player_notes/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("show_player_info")
			var/datum/tgui_module/player_notes_info/A = new(src)
			A.key = params["name"]
			A.tgui_interact(ui.user)

		if("filter_player_notes")
			var/input = tgui_input_text(ui.user, "Filter string (case-insensitive regex)", "Player notes filter")
			current_filter = input

		if("set_page")
			var/page = params["index"]
			current_page = page

		if("clear_player_info_filter")
			current_filter = ""

		if("open_legacy_ui")
			open_legacy()

/datum/tgui_module/player_notes/tgui_data(mob/user)
	var/list/data = list()

	filter_ckeys(current_page, current_filter)
	data["ckeys"] = list()
	data["pages"] = number_pages + 1
	data["filter"] = current_filter

	for(var/ckey in ckeys)
		data["ckeys"] += list(list(
				"name" = ckey
			))

	return data

// PLAYER NOTES INFO
/datum/tgui_module/player_notes_info
	name = "Player Notes Info"
	tgui_id = "PlayerNotesInfo"

	var/key = null

/datum/tgui_module/player_notes_info/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/tgui_module/player_notes_info/tgui_fallback(payload)
	if(..())
		return TRUE

	var/datum/admins/A = admin_datums[usr.ckey]
	A.show_player_info_legacy(key)

/datum/tgui_module/player_notes_info/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("add_player_info")
			var/key = params["ckey"]
			var/add = tgui_input_text(ui.user, "Write your comment below.", "Add Player Info", multiline = TRUE, prevent_enter = TRUE)
			if(!add) return

			notes_add(key,add,ui.user)

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

// ==== LEGACY UI ====

/datum/admins/proc/PlayerNotesLegacy()
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	PlayerNotesPageLegacy(1)

/datum/admins/proc/PlayerNotesFilterLegacy()
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/filter = tgui_input_text(usr, "Filter string (case-insensitive regex)", "Player notes filter")
	PlayerNotesPageLegacy(1, filter)

/datum/admins/proc/PlayerNotesPageLegacy(page, filter)
	var/dat = span_bold("Player notes") + " - <a href='byond://?src=\ref[src];[HrefToken()];notes_legacy=filter'>Apply Filter</a><HR>"
	var/savefile/S=new("data/player_notes.sav")
	var/list/note_keys
	S >> note_keys
	if(!note_keys)
		dat += "No notes found."
	else
		dat += "<table>"
		note_keys = sortList(note_keys)

		if(filter)
			var/list/results = list()
			var/regex/needle = regex(filter, "i")
			for(var/haystack in note_keys)
				if(needle.Find(haystack))
					results += haystack
			note_keys = results

		// Display the notes on the current page
		var/number_pages = note_keys.len / PLAYER_NOTES_ENTRIES_PER_PAGE
		// Emulate CEILING(why does BYOND not have ceil, 1)
		if(number_pages != round(number_pages))
			number_pages = round(number_pages) + 1
		var/page_index = page - 1

		if(page_index < 0 || page_index >= number_pages)
			dat += "<tr><td>No keys found.</td></tr>"
		else
			var/lower_bound = page_index * PLAYER_NOTES_ENTRIES_PER_PAGE + 1
			var/upper_bound = (page_index + 1) * PLAYER_NOTES_ENTRIES_PER_PAGE
			upper_bound = min(upper_bound, note_keys.len)
			for(var/index = lower_bound, index <= upper_bound, index++)
				var/t = note_keys[index]
				dat += "<tr><td><a href='byond://?src=\ref[src];[HrefToken()];notes_legacy=show;ckey=[t]'>[t]</a></td></tr>"

		dat += "</table><hr>"

		// Display a footer to select different pages
		for(var/index = 1, index <= number_pages, index++)
			dat += "<a href='byond://?src=\ref[src];[HrefToken()];notes_legacy=list;index=[index];filter=[filter ? url_encode(filter) : 0]'>[index]</a> "
			if(index == page)
				dat = span_bold(dat)

	usr << browse("<html>[dat]</html>", "window=player_notes;size=400x400")

/datum/admins/proc/player_has_info_legacy(var/key as text)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos || !infos.len) return 0
	else return 1

/datum/admins/proc/show_player_info_legacy(var/key as text)
	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/dat = "<html><head><title>Info on [key]</title></head>"
	dat += "<body>"

	var/p_age = "unknown"
	for(var/client/C in GLOB.clients)
		if(C.ckey == key)
			p_age = C.player_age
			break
	dat += span_black(span_bold("Player age: [p_age]")) + "<br>"

	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		dat += "No information found on the given key.<br>"
	else
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
			dat += "<font color=#008800>[I.content]</font> <i>by [I.author] ([I.rank])</i> on <i><font color=blue>[I.timestamp]</i></font> "
			if(I.author == usr.key || I.author == "Adminbot" || ishost(usr))
				dat += "<A href='byond://?src=\ref[src];[HrefToken()];remove_player_info_legacy=[key];remove_index=[i]'>Remove</A>"
			dat += "<br><br>"
		if(update_file) info << infos

	dat += "<br>"
	dat += "<A href='byond://?src=\ref[src];[HrefToken()];add_player_info_legacy=[key]'>Add Comment</A><br>"

	dat += "</body></html>"
	usr << browse(dat, "window=adminplayerinfo;size=480x480")

/datum/admins/Topic(href, href_list)
	..()

	if(href_list["add_player_info_legacy"])
		var/key = href_list["add_player_info_legacy"]
		var/add = sanitize(tgui_input_text(usr, "Add Player Info (Legacy)", multiline=TRUE))
		if(!add) return

		notes_add(key,add,usr)
		show_player_info_legacy(key)

	if(href_list["remove_player_info_legacy"])
		var/key = href_list["remove_player_info_legacy"]
		var/index = text2num(href_list["remove_index"])

		notes_del(key, index)
		show_player_info_legacy(key)

	if(href_list["notes_legacy"])
		var/ckey = href_list["ckey"]
		if(!ckey)
			var/mob/M = locate(href_list["mob"])
			if(ismob(M))
				ckey = M.ckey

		switch(href_list["notes_legacy"])
			if("show")
				show_player_info_legacy(ckey)
			if("list")
				var/filter
				if(href_list["filter"] && href_list["filter"] != "0")
					filter = url_decode(href_list["filter"])
				PlayerNotesPageLegacy(text2num(href_list["index"]), filter)
			if("filter")
				PlayerNotesFilterLegacy()
		return

#undef PLAYER_NOTES_ENTRIES_PER_PAGE
