/datum/category_item/player_setup_item/general/candidacy
	name = "Candidacy"
	sort_order = 8

/datum/category_item/player_setup_item/general/candidacy/load_character(list/save_data)
	pref.be_special = save_data["be_special"]

/datum/category_item/player_setup_item/general/candidacy/save_character(list/save_data)
	save_data["be_special"] = pref.be_special

/datum/category_item/player_setup_item/general/candidacy/sanitize_character()
	pref.be_special	= sanitize_integer(pref.be_special, 0, 16777215, initial(pref.be_special)) //VOREStation Edit - 24 bits of support

/datum/category_item/player_setup_item/general/candidacy/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("be_special")
			var/num = text2num(params["be_special"])
			pref.be_special ^= (1<<num)
			return TOPIC_REFRESH

/datum/category_item/player_setup_item/general/candidacy/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["syndicate_ban"] = FALSE

	if(jobban_isbanned(user, JOB_SYNDICATE))
		data["syndicate_ban"] = TRUE
		return

	var/list/special_data = list()
	var/n = 0
	for(var/i in GLOB.special_roles)
		if(GLOB.special_roles[i])
			var/banned = FALSE
			if(jobban_isbanned(user, i) || (i == "positronic brain" && jobban_isbanned(user, JOB_AI) && jobban_isbanned(user, JOB_CYBORG)) || (i == "pAI candidate" && jobban_isbanned(user, JOB_PAI)))
				banned = TRUE

			UNTYPED_LIST_ADD(special_data, list(
				"idx" = n,
				"name" = "Be [i]",
				"selected" = pref.be_special & (1<<n),
				"banned" = banned
			))
		n++
	data["special_roles"] = special_data

	return data
