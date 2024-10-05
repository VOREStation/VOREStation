/client/verb/vote()
	set category = "OOC"
	set name = "Vote"

	if(SSvote.active_vote)
		SSvote.active_vote.tgui_interact(usr)
	else
		to_chat(usr, span_warning("There is no active vote"))

/client/proc/start_vote()
	set category = "Admin"
	set name = "Start Vote"
	set desc = "Start a vote on the server"

	if(!is_admin(usr))
		return

	if(SSvote.active_vote)
		to_chat(usr, span_warning("A vote is already in progress"))
		return

	var/vote_types = subtypesof(/datum/vote)
	vote_types |= "\[CUSTOM]"

	var/list/votemap = list()
	for(var/vtype in vote_types)
		votemap["[vtype]"] = vtype

	var/choice = tgui_input_list(usr, "Select a vote type", "Vote", vote_types)

	if(choice == null)
		return

	if(choice != "\[CUSTOM]")
		var/datum/votetype = votemap["[choice]"]
		SSvote.start_vote(new votetype(usr.ckey))
		return

	var/question = tgui_input_text(usr, "What is the vote for?", "Create Vote", encode = FALSE)
	if(isnull(question))
		return

	var/list/choices = list()
	for(var/i in 1 to 10)
		var/option = tgui_input_text(usr, "Please enter an option or hit cancel to finish", "Create Vote", encode = FALSE)
		if(isnull(option) || !usr.client)
			break
		choices |= option

	var/c2 = tgui_alert(usr, "Show counts while vote is happening?", "Counts", list("Yes", "No"))
	var/c3 = input(usr, "Select a result calculation type", "Vote", VOTE_RESULT_TYPE_MAJORITY) as anything in list(VOTE_RESULT_TYPE_MAJORITY)

	var/datum/vote/V = new /datum/vote(usr.ckey, question, choices, TRUE)
	V.show_counts = (c2 == "Yes")
	V.vote_result_type = c3
	SSvote.start_vote(V)
