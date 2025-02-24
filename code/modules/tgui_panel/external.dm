/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/client/var/datum/tgui_panel/tgui_panel

/**
 * tgui panel / chat troubleshooting verb
 */
/client/verb/fix_tgui_panel()
	set name = "Fix chat"
	set category = "OOC.Debug"
	var/action
	log_tgui(src, "Started fixing.", context = "verb/fix_tgui_panel")

	nuke_chat()

	// Failed to fix, using tgalert as fallback
	action = tgalert(src, "Did that work?", "", "Yes", "No, switch to old ui")
	if (action == "No, switch to old ui")
		winset(src, "legacy_output_selector", "left=output_legacy")
		log_tgui(src, "Failed to fix.", context = "verb/fix_tgui_panel")

/client/proc/nuke_chat()
	// Catch all solution (kick the whole thing in the pants)
	winset(src, "legacy_output_selector", "left=output_legacy")
	if(!tgui_panel || !istype(tgui_panel))
		log_tgui(src, "tgui_panel datum is missing",
			context = "verb/fix_tgui_panel")
		tgui_panel = new(src)
	tgui_panel.initialize(force = TRUE)
	// Force show the panel to see if there are any errors
	winset(src, "legacy_output_selector", "left=output_browser")

	if(prefs?.read_preference(/datum/preference/toggle/browser_dev_tools))
		winset(src, null, "browser-options=[DEFAULT_CLIENT_BROWSER_OPTIONS],devtools")

/client/verb/refresh_tgui()
	set name = "Refresh TGUI"
	set category = "OOC.Debug"

	for(var/window_id in tgui_windows)
		var/datum/tgui_window/window = tgui_windows[window_id]
		window.reinitialize()

/* TODO: Relay to the chat/panel?
/client/verb/export_chatlogs_round()
	set name = "Export Chatlogs - Round (NEW)"
	set category = "OOC"

	var/round_id = tgui_input_number(src, "Which round do you want exported?", "RoundID", GLOB.round_id, INFINITY, -1)
	if(round_id)
		vchatlog_read_round(src.key, round_id, TRUE)
		src << ftp("data/chatlogs/[src.key]-[round_id].html")

/client/verb/export_chatlogs_length()
	set name = "Export Chatlogs - Last X (NEW)"
	set category = "OOC"

	var/length = tgui_input_number(src, "How many lines back do you want to be exported?", "Linecount", 1000, INFINITY, 1)
	if(length)
		vchatlog_read(src.key, length, TRUE, FALSE)
		src << ftp("data/chatlogs/[src.key].html")
*/
