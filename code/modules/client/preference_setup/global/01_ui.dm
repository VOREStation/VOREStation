/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(datum/json_savefile/savefile)
	pref.ooccolor			= savefile.get_entry("ooccolor")
	pref.chat_timestamp		= savefile.get_entry("chat_timestamp")

/datum/category_item/player_setup_item/player_global/ui/save_preferences(datum/json_savefile/savefile)
	savefile.set_entry("ooccolor",			pref.ooccolor)
	savefile.set_entry("chat_timestamp",	pref.chat_timestamp)

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.ooccolor			= sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))
	pref.chat_timestamp		= sanitize_integer(pref.chat_timestamp, 0, 1, initial(pref.chat_timestamp))

/datum/category_item/player_setup_item/player_global/ui/content(var/mob/user)
	. += span_bold("Chat Timestamps:") + " <a href='?src=\ref[src];chat_timestamps=1'><b>[(pref.chat_timestamp) ? "Enabled" : "Disabled (default)"]</b></a><br>"
	if(can_select_ooc_color(user))
		. += span_bold("OOC Color:")
		if(pref.ooccolor == initial(pref.ooccolor))
			. += "<a href='byond://?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			. += "<a href='byond://?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> [color_square(hex = pref.ooccolor)]<a href='byond://?src=\ref[src];reset=ooc'>reset</a><br>"

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if(href_list["chat_timestamps"])
		pref.chat_timestamp = !pref.chat_timestamp
		return TOPIC_REFRESH

	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ooc")
				pref.ooccolor = initial(pref.ooccolor)
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/ui/proc/can_select_ooc_color(var/mob/user)
	return CONFIG_GET(flag/allow_admin_ooccolor) && check_rights(R_ADMIN|R_EVENT|R_FUN, 0, user)
