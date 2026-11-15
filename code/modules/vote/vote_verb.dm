/client/verb/vote()
	set category = "OOC.Game"
	set name = "Vote"

	if(SSvote.active_vote)
		SSvote.active_vote.tgui_interact(usr)
	else
		to_chat(src, span_warning("There is no active vote"))

ADMIN_VERB(start_vote, R_HOLDER, "Start Vote", "Start a vote on the server.", ADMIN_CATEGORY_GAME)
	if(SSvote.active_vote)
		to_chat(user, span_warning("A vote is already in progress"))
		return

	var/vote_types = subtypesof(/datum/vote)
	vote_types |= "\[CUSTOM]"

	var/list/votemap = list()
	for(var/vtype in vote_types)
		votemap["[vtype]"] = vtype

	var/choice = tgui_input_list(user, "Select a vote type", "Vote", vote_types)

	if(isnull(choice))
		return

	if(choice != "\[CUSTOM]")
		var/datum/votetype = votemap["[choice]"]
		SSvote.start_vote(new votetype(user.ckey))
		return

	var/question = tgui_input_text(user, "What is the vote for?", "Create Vote", "", MAX_MESSAGE_LEN)
	if(isnull(question))
		return

	var/list/choices = list()
	for(var/i in 1 to 10)
		var/option = tgui_input_text(user, "Please enter an option or hit cancel to finish", "Create Vote", "", MAX_MESSAGE_LEN)
		if(isnull(option) || !user)
			break
		choices |= option

	var/c2 = tgui_alert(user, "Show counts while vote is happening?", "Counts", list("Yes", "No"))
	var/c3 = tgui_input_list(user, "Select a result calculation type", "Vote", list(VOTE_RESULT_TYPE_MAJORITY))

	var/datum/vote/V = new /datum/vote(user.ckey, question, choices, TRUE)
	V.show_counts = (c2 == "Yes")
	V.vote_result_type = c3
	SSvote.start_vote(V)
