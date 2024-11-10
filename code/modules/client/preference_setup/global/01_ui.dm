/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(datum/json_savefile/savefile)
	pref.ooccolor			= savefile.get_entry("ooccolor")
	pref.tooltipstyle		= savefile.get_entry("tooltipstyle")
	pref.ambience_freq		= savefile.get_entry("ambience_freq")
	pref.ambience_chance	= savefile.get_entry("ambience_chance")
	pref.chat_timestamp		= savefile.get_entry("chat_timestamp")

/datum/category_item/player_setup_item/player_global/ui/save_preferences(datum/json_savefile/savefile)
	savefile.set_entry("ooccolor",			pref.ooccolor)
	savefile.set_entry("tooltipstyle",		pref.tooltipstyle)
	savefile.set_entry("ambience_freq",		pref.ambience_freq)
	savefile.set_entry("ambience_chance",	pref.ambience_chance)
	savefile.set_entry("chat_timestamp",	pref.chat_timestamp)

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.ooccolor			= sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))
	pref.tooltipstyle		= sanitize_inlist(pref.tooltipstyle, all_tooltip_styles, initial(pref.tooltipstyle))
	pref.ambience_freq		= sanitize_integer(pref.ambience_freq, 0, 60, initial(pref.ambience_freq)) // No more than once per hour.
	pref.ambience_chance 	= sanitize_integer(pref.ambience_chance, 0, 100, initial(pref.ambience_chance)) // 0-100 range.)
	pref.chat_timestamp		= sanitize_integer(pref.chat_timestamp, 0, 1, initial(pref.chat_timestamp))

/datum/category_item/player_setup_item/player_global/ui/content(var/mob/user)
	. += span_bold("Tooltip Style:") + " <a href='?src=\ref[src];select_tooltip_style=1'><b>[pref.tooltipstyle]</b></a><br>"
	. += span_bold("Random Ambience Frequency:") + " <a href='?src=\ref[src];select_ambience_freq=1'><b>[pref.ambience_freq]</b></a><br>"
	. += span_bold("Ambience Chance:") + " <a href='?src=\ref[src];select_ambience_chance=1'><b>[pref.ambience_chance]</b></a><br>"
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

	else if(href_list["select_tooltip_style"])
		var/tooltip_style_new = tgui_input_list(user, "Choose tooltip style.", "Global Preference", all_tooltip_styles, pref.tooltipstyle)
		if(!tooltip_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.tooltipstyle = tooltip_style_new
		return TOPIC_REFRESH

	else if(href_list["select_ambience_freq"])
		var/ambience_new = tgui_input_number(user, "Input how often you wish to hear ambience repeated! (1-60 MINUTES, 0 for disabled)", "Global Preference", pref.ambience_freq, 60, 0)
		if(isnull(ambience_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		if(ambience_new < 0 || ambience_new > 60) return TOPIC_NOACTION
		pref.ambience_freq = ambience_new
		return TOPIC_REFRESH

	else if(href_list["select_ambience_chance"])
		var/ambience_chance_new = tgui_input_number(user, "Input the chance you'd like to hear ambience played to you (On area change, or by random ambience). 35 means a 35% chance to play ambience. This is a range from 0-100. 0 disables ambience playing entirely. This is also affected by Ambience Frequency.", "Global Preference", pref.ambience_freq, 100, 0)
		if(isnull(ambience_chance_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		if(ambience_chance_new < 0 || ambience_chance_new > 100) return TOPIC_NOACTION
		pref.ambience_chance = ambience_chance_new
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
