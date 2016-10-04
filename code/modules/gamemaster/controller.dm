/client/proc/show_gm_status()
	set category = "Debug"
	set name = "Show GM Status"
	set desc = "Shows you what the GM is thinking.  If only that existed in real life..."

	game_master.interact(usr)

/datum/game_master/proc/interact(var/client/user)
	if(!user)
		return

	var/HTML = "<html><head><title>Game Master AI</title></head><body>"

	HTML += "Staleness: [staleness]<br>"
	HTML += "Danger: [danger]<br><br>"

	HTML += "Actions available;<br>"
	for(var/datum/gm_action/action in available_actions)
		if(action.enabled == FALSE)
			continue
		HTML += "[action.name] ([english_list(action.departments)])<br>"

	HTML += "<br>"
	HTML += "All living mobs activity: [assess_all_living_mobs()]<br>"

	HTML += "<br>"
	HTML += "Departmental activity;<br>"
	for(var/department in departments)
		var/number_of_people = count_people_in_department(department)
		HTML += "    [department] : [assess_department(department)] / [number_of_people * 100]<br>"

	HTML += "<br>"
	HTML += "Activity of players;<br>"
	for(var/mob/player in player_list)
		HTML += "    [player] : [assess_player_activity(player)]<br>"



	HTML +="</body></html>"
	user << browse(HTML, "window=log;size=400x450;border=1;can_resize=1;can_close=1;can_minimize=1")