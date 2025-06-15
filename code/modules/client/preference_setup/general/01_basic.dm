#define AUTOHISS_OFF 0
#define AUTOHISS_BASIC 1
#define AUTOHISS_FULL 2

/datum/preferences
	var/biological_gender = MALE
	var/identifying_gender = MALE

	var/vore_egg_type = "Egg" //The egg type they have.
	var/autohiss = "Full"			// VOREStation Add: Whether we have Autohiss on. I'm hijacking the egg panel bc this one has a shitton of unused space.

/datum/preferences/proc/set_biological_gender(var/gender)
	biological_gender = gender
	identifying_gender = gender

/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/load_character(list/save_data)
	pref.real_name			= save_data["real_name"]
	pref.nickname			= save_data["nickname"]
	pref.biological_gender	= save_data["gender"]
	pref.identifying_gender	= save_data["id_gender"]
	pref.vore_egg_type		= save_data["vore_egg_type"]
	pref.autohiss			= save_data["autohiss"]

/datum/category_item/player_setup_item/general/basic/save_character(list/save_data)
	save_data["real_name"]				= pref.real_name
	save_data["nickname"]				= pref.nickname
	save_data["gender"]					= pref.biological_gender
	save_data["id_gender"]				= pref.identifying_gender
	save_data["vore_egg_type"]			= pref.vore_egg_type
	save_data["autohiss"]				= pref.autohiss

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	pref.biological_gender  = sanitize_inlist(pref.biological_gender, get_genders(), pick(get_genders()))
	pref.identifying_gender = (pref.identifying_gender in all_genders_define_list) ? pref.identifying_gender : pref.biological_gender
	pref.real_name		= sanitize_name(pref.real_name, pref.species, is_FBP())
	if(!pref.real_name)
		pref.real_name      = random_name(pref.identifying_gender, pref.species)
	pref.nickname		= sanitize_name(pref.nickname)
	pref.vore_egg_type	 = sanitize_inlist(pref.vore_egg_type, GLOB.global_vore_egg_types, initial(pref.vore_egg_type))
	pref.autohiss = sanitize_inlist(pref.autohiss, list("Off", "Basic", "Full"), initial(pref.autohiss))

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

	character.vore_egg_type	= pref.vore_egg_type
	// VOREStation Add
	if(pref.client) // Safety, just in case so we don't runtime.
		if(!pref.autohiss)
			pref.client.autohiss_mode = AUTOHISS_FULL
		else
			switch(pref.autohiss)
				if("Full")
					pref.client.autohiss_mode = AUTOHISS_FULL
				if("Basic")
					pref.client.autohiss_mode = AUTOHISS_BASIC
				if("Off")
					pref.client.autohiss_mode = AUTOHISS_OFF

/datum/category_item/player_setup_item/general/basic/tgui_data(mob/user)
	var/list/data = ..()

	data["real_name"] = pref.real_name
	data["be_random_name"] = pref.read_preference(/datum/preference/toggle/human/name_is_always_random)
	data["nickname"] = pref.nickname
	data["biological_sex"] = gender2text(pref.biological_gender)
	data["identifying_gender"] = gender2text(pref.identifying_gender)
	data["age"] = pref.read_preference(/datum/preference/numeric/human/age)
	data["bday_month"] = pref.read_preference(/datum/preference/numeric/human/bday_month)
	data["bday_day"] = pref.read_preference(/datum/preference/numeric/human/bday_day)
	data["bday_announce"] = pref.read_preference(/datum/preference/toggle/human/bday_announce)
	data["spawnpoint"] = pref.read_preference(/datum/preference/choiced/living/spawnpoint)
	data["ooc_notes_length"] = LAZYLEN(pref.read_preference(/datum/preference/text/living/ooc_notes))
	data["vore_egg_type"] = pref.vore_egg_type
	data["autohiss"] = pref.autohiss
	data["emote_sound_mode"] = pref.read_preference(/datum/preference/choiced/living/emote_sound_mode)

	return data

/datum/category_item/player_setup_item/general/basic/tgui_static_data(mob/user)
	var/list/data = ..()

	data["allow_metadata"] = CONFIG_GET(flag/allow_metadata)

	return data

/datum/category_item/player_setup_item/general/basic/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	switch(action)
		if("rename")
			var/raw_name = tgui_input_text(user, "Choose your character's name:", "Character Name", pref.real_name)
			if(!isnull(raw_name))
				var/new_name = sanitize_name(raw_name, pref.species, is_FBP())
				if(new_name)
					pref.real_name = new_name
					return TOPIC_REFRESH
				else
					to_chat(user, span_warning("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
					return TOPIC_NOACTION

		if("random_name")
			pref.real_name = random_name(pref.identifying_gender, pref.species)
			return TOPIC_REFRESH

		if("always_random_name")
			pref.update_preference_by_type(/datum/preference/toggle/human/name_is_always_random, !pref.read_preference(/datum/preference/toggle/human/name_is_always_random))
			return TOPIC_REFRESH

		if("nickname")
			var/raw_nickname = tgui_input_text(user, "Choose your character's nickname:", "Character Nickname", pref.nickname)
			if(!isnull(raw_nickname))
				var/new_nickname = sanitize_name(raw_nickname, pref.species, is_FBP())
				if(new_nickname)
					pref.nickname = new_nickname
					return TOPIC_REFRESH
				else
					to_chat(user, span_warning("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
					return TOPIC_NOACTION

		if("reset_nickname")
			var/nick_choice = tgui_alert(user, "Wipe your Nickname? This will completely remove any chosen nickname(s).","Wipe Nickname",list("Yes","No"))
			if(nick_choice == "Yes")
				pref.nickname = null
			return TOPIC_REFRESH

		if("bio_gender")
			var/new_gender = lowertext(params["gender"])
			if(new_gender in get_genders())
				pref.set_biological_gender(new_gender)
			return TOPIC_REFRESH_UPDATE_PREVIEW

		if("id_gender")
			var/new_gender = lowertext(params["gender"])
			if(new_gender in all_genders_define_list)
				pref.identifying_gender = new_gender
			return TOPIC_REFRESH

		if("age")
			var/min_age = get_min_age()
			var/max_age = get_max_age()
			var/new_age = tgui_input_number(user, "Choose your character's age:\n([min_age]-[max_age])", "Character Preference", pref.read_preference(/datum/preference/numeric/human/age), max_age, min_age)
			if(new_age)
				pref.update_preference_by_type(/datum/preference/numeric/human/age, max(min(round(text2num(new_age)), max_age), min_age))
				return TOPIC_REFRESH

		if("bday_month")
			var/new_month = tgui_input_number(user, "Choose your character's birth month (number)", "Birthday Month", pref.read_preference(/datum/preference/numeric/human/bday_month), 12, 0)
			if(new_month)
				pref.update_preference_by_type(/datum/preference/numeric/human/bday_month, new_month)
			else if((tgui_alert(user, "Would you like to clear the birthday entry?","Clear?",list("No","Yes")) == "Yes"))
				pref.update_preference_by_type(/datum/preference/numeric/human/bday_month, 0)
				pref.update_preference_by_type(/datum/preference/numeric/human/bday_day, 0)

		if("bday_day")
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
			if(new_day)
				pref.update_preference_by_type(/datum/preference/numeric/human/bday_day, new_day)
			else if((tgui_alert(user, "Would you like to clear the birthday entry?","Clear?",list("No","Yes")) == "Yes"))
				pref.update_preference_by_type(/datum/preference/numeric/human/bday_month, 0)
				pref.update_preference_by_type(/datum/preference/numeric/human/bday_day, 0)
			return TOPIC_REFRESH

		if("bday_announce")
			pref.update_preference_by_type(/datum/preference/toggle/human/bday_announce, !pref.read_preference(/datum/preference/toggle/human/bday_announce))
			return TOPIC_REFRESH

		if("spawnpoint")
			var/list/spawnkeys = list()
			for(var/spawntype in spawntypes)
				spawnkeys += spawntype
			var/choice = tgui_input_list(user, "Where would you like to spawn when late-joining?", "Late-Join Choice", spawnkeys)
			if(!choice || !spawntypes[choice])
				return TOPIC_NOACTION
			pref.update_preference_by_type(/datum/preference/choiced/living/spawnpoint, choice)
			return TOPIC_REFRESH

		if("edit_ooc_notes")
			var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see, such as Roleplay-preferences. This will not be saved permanently unless you click save in the Character Setup panel!", "Game Preference" , html_decode(pref.read_preference(/datum/preference/text/living/ooc_notes)), multiline = TRUE,  prevent_enter = TRUE))
			if(new_metadata)
				pref.update_preference_by_type(/datum/preference/text/living/ooc_notes, new_metadata)

		if("edit_ooc_note_favs")
			var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see relating to your FAVOURITE roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.read_preference(/datum/preference/text/living/ooc_notes_favs)), multiline = TRUE,  prevent_enter = TRUE))
			if(new_metadata)
				if(new_metadata == "!clear")
					new_metadata = ""
				pref.update_preference_by_type(/datum/preference/text/living/ooc_notes_favs, new_metadata)

		if("edit_ooc_note_likes")
			var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see relating to your LIKED roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.read_preference(/datum/preference/text/living/ooc_notes_likes)), multiline = TRUE,  prevent_enter = TRUE))
			if(new_metadata)
				if(new_metadata == "!clear")
					new_metadata = ""
				pref.update_preference_by_type(/datum/preference/text/living/ooc_notes_likes, new_metadata)

		if("edit_ooc_note_maybes")
			var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see relating to your MAYBE roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.read_preference(/datum/preference/text/living/ooc_notes_maybes)), multiline = TRUE,  prevent_enter = TRUE))
			if(new_metadata && CanUseTopic(user))
				if(new_metadata == "!clear")
					new_metadata = ""
				pref.update_preference_by_type(/datum/preference/text/living/ooc_notes_maybes, new_metadata)

		if("edit_ooc_note_dislikes")
			var/new_metadata = strip_html_simple(tgui_input_text(user, "Enter any information you'd like others to see relating to your DISLIKED roleplay preferences. This will not be saved permanently unless you click save in the Character Setup panel! Type \"!clear\" to empty.", "Game Preference" , html_decode(pref.read_preference(/datum/preference/text/living/ooc_notes_dislikes)), multiline = TRUE,  prevent_enter = TRUE))
			if(new_metadata)
				if(new_metadata == "!clear")
					new_metadata = ""
				pref.update_preference_by_type(/datum/preference/text/living/ooc_notes_dislikes, new_metadata)

		if("edit_ooc_note_style")
			pref.update_preference_by_type(/datum/preference/toggle/living/ooc_notes_style, !pref.read_preference(/datum/preference/toggle/living/ooc_notes_style))
			return TOPIC_REFRESH

		if("vore_egg_type")
			var/list/vore_egg_types = GLOB.global_vore_egg_types
			var/selection = tgui_input_list(user, "Choose your character's egg type:", "Character Preference", vore_egg_types, pref.vore_egg_type)
			if(selection)
				pref.vore_egg_type = selection
				return TOPIC_REFRESH

		if("autohiss")
			var/list/autohiss_selection = list("Full", "Basic", "Off")
			var/selection = tgui_input_list(user, "Choose your default autohiss setting:", "Character Preference", autohiss_selection, pref.autohiss)
			if(selection)
				pref.autohiss = selection
			else if(!selection)
				pref.autohiss = "Full"
			return TOPIC_REFRESH

		if("emote_sound_mode")
			var/datum/preference/choiced/living/emote_sound_mode = GLOB.preference_entries_by_key["emote_sound_mode"]
			var/selection = tgui_input_list(user, "Choose your emote sound mode", "Emote Sound Mode", emote_sound_mode.get_choices())
			if(selection)
				pref.update_preference(emote_sound_mode, selection)
			return TOPIC_REFRESH

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

#undef AUTOHISS_OFF
#undef AUTOHISS_BASIC
#undef AUTOHISS_FULL
