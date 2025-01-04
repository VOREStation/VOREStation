/datum/preferences
	var/biological_gender = MALE
	var/identifying_gender = MALE

/datum/preferences/proc/set_biological_gender(var/gender)
	biological_gender = gender
	identifying_gender = gender

/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/load_character(list/save_data)
	pref.real_name						= save_data["real_name"]
	pref.nickname						= save_data["nickname"]
	pref.biological_gender				= save_data["gender"]
	pref.identifying_gender				= save_data["id_gender"]

/datum/category_item/player_setup_item/general/basic/save_character(list/save_data)
	save_data["real_name"]				= pref.real_name
	save_data["nickname"]				= pref.nickname
	save_data["gender"]					= pref.biological_gender
	save_data["id_gender"]				= pref.identifying_gender

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	pref.biological_gender  = sanitize_inlist(pref.biological_gender, get_genders(), pick(get_genders()))
	pref.identifying_gender = (pref.identifying_gender in all_genders_define_list) ? pref.identifying_gender : pref.biological_gender
	pref.real_name		= sanitize_name(pref.real_name, pref.species, is_FBP())
	if(!pref.real_name)
		pref.real_name      = random_name(pref.identifying_gender, pref.species)
	pref.nickname		= sanitize_name(pref.nickname)

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/basic/copy_to_mob(var/mob/living/carbon/human/character)
	if(CONFIG_GET(flag/humans_need_surnames))
		var/firstspace = findtext(pref.real_name, " ")
		var/name_length = length(pref.real_name)
		if(!firstspace)	//we need a surname
			pref.real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			pref.real_name += "[pick(last_names)]"

	character.real_name = pref.real_name
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name

	character.nickname = pref.nickname

	character.gender = pref.biological_gender
	character.identifying_gender = pref.identifying_gender

/datum/category_item/player_setup_item/general/basic/content()
	. = list()
	. += span_bold("Name:") + " "
	. += "<a href='byond://?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "<a href='byond://?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	. += "<a href='byond://?src=\ref[src];always_random_name=1'>Always Random Name: [pref.read_preference(/datum/preference/toggle/human/name_is_always_random) ? "Yes" : "No"]</a><br>"
	. += span_bold("Nickname:") + " "
	. += "<a href='byond://?src=\ref[src];nickname=1'><b>[pref.nickname]</b></a>"
	. += "(<a href='byond://?src=\ref[src];reset_nickname=1'>Clear</A>)"
	. += "<br>"
	. += span_bold("Biological Sex:") + " <a href='byond://?src=\ref[src];bio_gender=1'><b>[gender2text(pref.biological_gender)]</b></a><br>"
	. += span_bold("Pronouns:") + " <a href='byond://?src=\ref[src];id_gender=1'><b>[gender2text(pref.identifying_gender)]</b></a><br>"
	. += span_bold("Age:") + " <a href='byond://?src=\ref[src];age=1'>[pref.read_preference(/datum/preference/numeric/human/age)]</a> <b>Birthday:</b> <a href='byond://?src=\ref[src];bday_month=1'>[pref.read_preference(/datum/preference/numeric/human/bday_month)]</a><b>/</b><a href='byond://?src=\ref[src];bday_day=1'>[pref.read_preference(/datum/preference/numeric/human/bday_day)]</a> - <b>Announce?:</b> <a href='byond://?src=\ref[src];bday_announce=1'>[pref.read_preference(/datum/preference/toggle/human/bday_announce) ? "Yes" : "No"]</a><br>"
	. += span_bold("Spawn Point:") + " <a href='byond://?src=\ref[src];spawnpoint=1'>[pref.read_preference(/datum/preference/choiced/human/spawnpoint)]</a><br>"
	if(CONFIG_GET(flag/allow_metadata))
		. += span_bold("OOC Notes: <a href='byond://?src=\ref[src];edit_ooc_notes=1'>Edit</a><a href='byond://?src=\ref[src];edit_ooc_note_likes=1'>Likes</a><a href='byond://?src=\ref[src];edit_ooc_note_dislikes=1'>Dislikes</a>") + "<br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/general/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["rename"])
		var/raw_name = tgui_input_text(user, "Choose your character's name:", "Character Name")
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species, is_FBP())
			if(new_name)
				pref.real_name = new_name
				return TOPIC_REFRESH
			else
				to_chat(user, span_warning("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
				return TOPIC_NOACTION

	else if(href_list["random_name"])
		pref.real_name = random_name(pref.identifying_gender, pref.species)
		return TOPIC_REFRESH

	else if(href_list["always_random_name"])
		pref.update_preference_by_type(/datum/preference/toggle/human/name_is_always_random, !pref.read_preference(/datum/preference/toggle/human/name_is_always_random))
		return TOPIC_REFRESH

	else if(href_list["nickname"])
		var/raw_nickname = tgui_input_text(user, "Choose your character's nickname:", "Character Nickname", pref.nickname)
		if (!isnull(raw_nickname) && CanUseTopic(user))
			var/new_nickname = sanitize_name(raw_nickname, pref.species, is_FBP())
			if(new_nickname)
				pref.nickname = new_nickname
				return TOPIC_REFRESH
			else
				to_chat(user, span_warning("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
				return TOPIC_NOACTION

	else if(href_list["reset_nickname"])
		var/nick_choice = tgui_alert(usr, "Wipe your Nickname? This will completely remove any chosen nickname(s).","Wipe Nickname",list("Yes","No"))
		if(nick_choice == "Yes")
			pref.nickname = null
		return TOPIC_REFRESH

	else if(href_list["bio_gender"])
		var/new_gender = tgui_input_list(user, "Choose your character's biological sex:", "Character Preference", get_genders(), pref.biological_gender)
		if(new_gender && CanUseTopic(user))
			pref.set_biological_gender(new_gender)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["id_gender"])
		var/new_gender = tgui_input_list(user, "Choose your character's pronouns:", "Character Preference", all_genders_define_list, pref.identifying_gender)
		if(new_gender && CanUseTopic(user))
			pref.identifying_gender = new_gender
		return TOPIC_REFRESH

	else if(href_list["age"])
		var/min_age = get_min_age()
		var/max_age = get_max_age()
		var/new_age = tgui_input_number(user, "Choose your character's age:\n([min_age]-[max_age])", "Character Preference", pref.read_preference(/datum/preference/numeric/human/age), max_age, min_age)
		if(new_age && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/numeric/human/age, max(min(round(text2num(new_age)), max_age), min_age))
			return TOPIC_REFRESH

	else if(href_list["bday_month"])
		var/new_month = tgui_input_number(user, "Choose your character's birth month (number)", "Birthday Month", pref.read_preference(/datum/preference/numeric/human/bday_month), 12, 0)
		if(new_month && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/numeric/human/bday_month, new_month)
		else if((tgui_alert(user, "Would you like to clear the birthday entry?","Clear?",list("No","Yes")) == "Yes") && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/numeric/human/bday_month, 0)
			pref.update_preference_by_type(/datum/preference/numeric/human/bday_day, 0)
		return TOPIC_REFRESH

	else if(href_list["bday_day"])
		if(!pref.read_preference(/datum/preference/numeric/human/bday_month))
			tgui_alert(user,"You must set a birth month before you can set a day.", "Error", list("Okay"))
			return
		var/max_days
		switch(pref.read_preference(/datum/preference/numeric/human/bday_month))
			if(1)
				max_days = 31
			if(2)
				max_days = 29
			if(3)
				max_days = 31
			if(4)
				max_days = 30
			if(5)
				max_days = 31
			if(6)
				max_days = 30
			if(7)
				max_days = 31
			if(8)
				max_days = 31
			if(9)
				max_days = 30
			if(10)
				max_days = 31
			if(11)
				max_days = 30
			if(12)
				max_days = 31

		var/new_day = tgui_input_number(user, "Choose your character's birth day (number, 1-[max_days])", "Birthday Day", pref.read_preference(/datum/preference/numeric/human/bday_day), max_days, 0)
		if(new_day && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/numeric/human/bday_day, new_day)
		else if((tgui_alert(user, "Would you like to clear the birthday entry?","Clear?",list("No","Yes")) == "Yes") && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/numeric/human/bday_month, 0)
			pref.update_preference_by_type(/datum/preference/numeric/human/bday_day, 0)
		return TOPIC_REFRESH

	else if(href_list["bday_announce"])
		pref.update_preference_by_type(/datum/preference/toggle/human/bday_announce, !pref.read_preference(/datum/preference/toggle/human/bday_announce))
		return TOPIC_REFRESH

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/spawntype in spawntypes)
			spawnkeys += spawntype
		var/choice = tgui_input_list(user, "Where would you like to spawn when late-joining?", "Late-Join Choice", spawnkeys)
		if(!choice || !spawntypes[choice] || !CanUseTopic(user))	return TOPIC_NOACTION
		pref.update_preference_by_type(/datum/preference/choiced/human/spawnpoint, choice)
		return TOPIC_REFRESH

	else if(href_list["edit_ooc_notes"])
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Enter any information you'd like others to see, such as Roleplay-preferences. This will not be saved permanently unless you click save in the Character Setup panel!", "Game Preference" , html_decode(pref.read_preference(/datum/preference/text/living/ooc_notes)), multiline = TRUE,  prevent_enter = TRUE))
		if(new_metadata && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/text/living/ooc_notes, new_metadata)
	else if(href_list["edit_ooc_note_likes"])
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Enter any information you'd like others to see relating to your LIKED roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.read_preference(/datum/preference/text/living/ooc_notes_likes)), multiline = TRUE,  prevent_enter = TRUE))
		if(new_metadata && CanUseTopic(user))
			if(new_metadata == "!clear")
				new_metadata = ""
			pref.update_preference_by_type(/datum/preference/text/living/ooc_notes_likes, new_metadata)
	else if(href_list["edit_ooc_note_dislikes"])
		var/new_metadata = strip_html_simple(tgui_input_text(usr, "Enter any information you'd like others to see relating to your DISLIKED roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.read_preference(/datum/preference/text/living/ooc_notes_dislikes)), multiline = TRUE,  prevent_enter = TRUE))
		if(new_metadata && CanUseTopic(user))
			if(new_metadata == "!clear")
				new_metadata = ""
			pref.update_preference_by_type(/datum/preference/text/living/ooc_notes_dislikes, new_metadata)
	return ..()

/datum/category_item/player_setup_item/general/basic/proc/get_genders()
	var/datum/species/S
	if(pref.species)
		S = GLOB.all_species[pref.species]
	else
		S = GLOB.all_species[SPECIES_HUMAN]
	var/list/possible_genders = S.genders
	if(!pref.organ_data || pref.organ_data[BP_TORSO] != "cyborg")
		return possible_genders
	possible_genders = possible_genders.Copy()
	possible_genders |= NEUTER
	return possible_genders
