/datum/antagonist/proc/print_player_summary()

	if(!current_antagonists.len)
		return FALSE

	var/text = "<br><br><font size = 2><b>The [current_antagonists.len == 1 ? "[role_text] was" : "[role_text_plural] were"]:</b></font>"
	for(var/datum/mind/P in current_antagonists)
		text += print_player_full(P)
		text += get_special_objective_text(P)
		if(P.ambitions)
			text += "<br>Their goals for today were..."
			text += "<br><span class='notice'>[P.ambitions]</span>"
		if(!global_objectives.len && P.objectives && P.objectives.len)
			var/failed
			var/num = 1
			for(var/datum/objective/O in P.objectives)
				text += print_objective(O, num)
				if(O.check_completion())
					text += span_green("<B>Success!</B>")
					feedback_add_details(feedback_tag,"[O.type]|SUCCESS")
				else
					text += span_red("Fail.")
					feedback_add_details(feedback_tag,"[O.type]|FAIL")
					failed = TRUE
				num++
			if(failed)
				text += "<br>" + span_red("<B>The [role_text] has failed.</B>")
			else
				text += "<br>" + span_green("<B>The [role_text] was successful!</B>")

	if(global_objectives && global_objectives.len)
		text += "<BR><FONT size = 2>Their objectives were:</FONT>"
		var/num = 1
		for(var/datum/objective/O in global_objectives)
			text += print_objective(O, num, TRUE)
			num++

	// Display the results.
	to_world(text)

/datum/antagonist/proc/print_objective(var/datum/objective/O, var/num, var/append_success)
	var/text = "<br><b>Objective [num]:</b> [O.explanation_text] "
	if(append_success)
		if(O.check_completion())
			text += span_green("<B>Success!</B>")
		else
			text += span_red("Fail.")
	return text

/datum/antagonist/proc/print_player_lite(var/datum/mind/ply)
	var/role = ply.assigned_role ? "\improper[ply.assigned_role]" : "\improper[ply.special_role]"
	var/text = "<br><b>[ply.name]</b> (<b>[ply.key]</b>) as \a <b>[role]</b> ("
	if(ply.current)
		if(ply.current.stat == DEAD)
			text += "died"
		else if(isNotStationLevel(ply.current.z))
			text += "fled the station"
		else
			text += "survived"
		if(ply.current.real_name != ply.name)
			text += " as <b>[ply.current.real_name]</b>"
	else
		text += "body destroyed"
	text += ")"

	return text

/datum/antagonist/proc/print_player_full(var/datum/mind/ply)
	var/text = print_player_lite(ply)

	var/TC_uses = FALSE
	var/uplink_true = FALSE
	var/purchases = ""
	for(var/mob/M in player_list)
		if(M.mind && M.mind.used_TC)
			TC_uses += M.mind.used_TC
			uplink_true = TRUE
			purchases += get_uplink_purchases(M.mind)
	if(uplink_true)
		text += " (used [TC_uses] TC)"
		if(purchases)
			text += "<br>[purchases]"

	return text

/proc/get_uplink_purchases(var/datum/mind/M)
	var/list/refined_log = new()
	for(var/datum/uplink_item/UI in M.purchase_log)
		refined_log.Add("[M.purchase_log[UI]]x[UI.log_icon()][UI.name]")
	. = english_list(refined_log, nothing_text = "")
