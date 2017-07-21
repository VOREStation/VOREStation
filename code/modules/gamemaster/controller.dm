/client/proc/show_gm_status()
	set category = "Debug"
	set name = "Show GM Status"
	set desc = "Shows you what the GM is thinking.  If only that existed in real life..."

	game_master.interact(usr)

/datum/game_master/proc/interact(var/client/user)
	if(!user)
		return

	var/HTML = "<html><head><title>Game Master AI</title></head><body>"

	HTML += "<a href='?src=\ref[src];toggle_time_restrictions=1'>\[Toggle Time Restrictions\]</a> | \
	<a href='?src=\ref[src];suspend=1'>\[Toggle GM\]</a> | \
	<a href='?src=\ref[src];force_choose_event=1'>\[Force Event Decision\]</a><br>"

	HTML += "Status: [pre_action_checks() ? "Ready" : "Suppressed"]<br><br>"

	HTML += "Staleness: [staleness] <a href='?src=\ref[src];adjust_staleness=1'>\[Adjust\]</a><br>"
	HTML += "Danger: [danger] <a href='?src=\ref[src];adjust_danger=1'>\[Adjust\]</a><br><br>"

	HTML += "Actions available;<br>"
	for(var/datum/gm_action/action in available_actions)
		if(action.enabled == FALSE)
			continue
		HTML += "[action.name] ([english_list(action.departments)]) (weight: [action.get_weight()]) <a href='?src=\ref[action];force=1'>\[Force\]</a> <br>"

	HTML += "<br>"
	HTML += "All living mobs activity: [metric.assess_all_living_mobs()]%<br>"
	HTML += "All ghost activity: [metric.assess_all_dead_mobs()]%<br>"

	HTML += "<br>"
	HTML += "Departmental activity;<br>"
	for(var/department in metric.departments)
		HTML += "    [department] : [metric.assess_department(department)]%<br>"

	HTML += "<br>"
	HTML += "Activity of players;<br>"
	for(var/mob/player in player_list)
		HTML += "    [player] ([player.key]) : [metric.assess_player_activity(player)]%<br>"



	HTML +="</body></html>"
	user << browse(HTML, "window=log;size=400x450;border=1;can_resize=1;can_close=1;can_minimize=1")

/datum/game_master/Topic(href, href_list)
	if(..())
		return

	if(!is_admin(usr))
		message_admins("[usr] has attempted to modify the Game Master values without being an admin.")
		return

	if(href_list["toggle_time_restrictions"])
		ignore_time_restrictions = !ignore_time_restrictions
		message_admins("GM event time restrictions was [ignore_time_restrictions ? "dis" : "en"]abled by [usr.key].")

	if(href_list["force_choose_event"])
		start_action()
		message_admins("[usr.key] forced the Game Master to choose an event immediately.")

	if(href_list["suspend"])
		suspended = !suspended
		message_admins("GM was [suspended ? "dis" : "en"]abled by [usr.key].")

	if(href_list["adjust_staleness"])
		var/amount = input(usr, "How much staleness should be added or subtracted?", "Game Master") as null|num
		if(amount)
			adjust_staleness(amount)
			message_admins("GM staleness was adjusted by [amount] by [usr.key].")

	if(href_list["adjust_danger"])
		var/amount = input(usr, "How much danger should be added or subtracted?", "Game Master") as null|num
		if(amount)
			adjust_danger(amount)
			message_admins("GM danger was adjusted by [amount] by [usr.key].")

	interact(usr) // To refresh the UI.

/datum/gm_action/Topic(href, href_list)
	if(..())
		return

	if(!is_admin(usr))
		message_admins("[usr] has attempted to force an event without being an admin.")
		return

	if(href_list["force"])
		gm.run_action(src)
		message_admins("GM event [name] was forced by [usr.key].")