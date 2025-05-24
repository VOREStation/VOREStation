var/global/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
// Change these to 0 if the equivalent mode is disabled for whatever reason!
	"traitor" = 0,										// 0
	"operative" = 0,									// 1
	"changeling" = 0,									// 2
	"wizard" = 0,										// 3
	"malf AI" = 0,										// 4
	"revolutionary" = 0,								// 5
	"alien candidate" = 0,								// 6
	"positronic brain" = 1,								// 7
	"cultist" = 0,										// 8
	"renegade" = 0,										// 9
	"ninja" = 0,										// 10
	"raider" = 0,										// 11
	"diona" = 0,										// 12
	"mutineer" = 0,										// 13
	"loyalist" = 0,										// 14
	"pAI candidate" = 1,								// 15
	//VOREStation Add
	"lost drone" = 1,									// 16
	"maint pred" = 1,									// 17
	"maint lurker" = 1,									// 18
	"morph" = 1,										// 19
	"corgi" = 1,										// 20
	"cursed sword" = 1,									// 21
	"Ship Survivor" = 1,								// 22
	//VOREStation Add End
)

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
	for(var/i in special_roles)
		if(special_roles[i])
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
