#define POSITIVE_MODE 1
#define NEUTRAL_MODE 2
#define NEGATIVE_MODE 3

#define ORGANICS	1
#define SYNTHETICS	2

/datum/preferences
	var/custom_species	// Custom species name, can't be changed due to it having been used in savefiles already.
	var/custom_base		// What to base the custom species on
	var/blood_color = "#A10808"

	var/custom_say = null
	var/custom_whisper = null
	var/custom_ask = null
	var/custom_exclaim = null

	var/list/pos_traits	= list()	// What traits they've selected for their custom species
	var/list/neu_traits = list()
	var/list/neg_traits = list()

	var/traits_cheating = 0 //Varedit by admins allows saving new maximums on people who apply/etc
	var/starting_trait_points = STARTING_SPECIES_POINTS
	var/max_traits = MAX_SPECIES_TRAITS
	var/dirty_synth = 0		//Are you a synth
	var/gross_meatbag = 0		//Where'd I leave my Voight-Kampff test kit?

// Definition of the stuff for Ears
/datum/category_item/player_setup_item/vore/traits
	name = "Traits"
	sort_order = 7

/datum/category_item/player_setup_item/vore/traits/load_character(var/savefile/S)
	S["custom_species"]	>> pref.custom_species
	S["custom_base"]	>> pref.custom_base
	S["pos_traits"]		>> pref.pos_traits
	S["neu_traits"]		>> pref.neu_traits
	S["neg_traits"]		>> pref.neg_traits
	S["blood_color"]	>> pref.blood_color

	S["traits_cheating"]	>> pref.traits_cheating
	S["max_traits"]		>> pref.max_traits
	S["trait_points"]	>> pref.starting_trait_points

	S["custom_say"]		>> pref.custom_say
	S["custom_whisper"]	>> pref.custom_whisper
	S["custom_ask"]		>> pref.custom_ask
	S["custom_exclaim"]	>> pref.custom_exclaim

/datum/category_item/player_setup_item/vore/traits/save_character(var/savefile/S)
	S["custom_species"]	<< pref.custom_species
	S["custom_base"]	<< pref.custom_base
	S["pos_traits"]		<< pref.pos_traits
	S["neu_traits"]		<< pref.neu_traits
	S["neg_traits"]		<< pref.neg_traits
	S["blood_color"]	<< pref.blood_color

	S["traits_cheating"]	<< pref.traits_cheating
	S["max_traits"]		<< pref.max_traits
	S["trait_points"]	<< pref.starting_trait_points

	S["custom_say"]		<< pref.custom_say
	S["custom_whisper"]	<< pref.custom_whisper
	S["custom_ask"]		<< pref.custom_ask
	S["custom_exclaim"]	<< pref.custom_exclaim

/datum/category_item/player_setup_item/vore/traits/sanitize_character()
	if(!pref.pos_traits) pref.pos_traits = list()
	if(!pref.neu_traits) pref.neu_traits = list()
	if(!pref.neg_traits) pref.neg_traits = list()

	pref.blood_color = sanitize_hexcolor(pref.blood_color, default="#A10808")

	if(!pref.traits_cheating)
		pref.starting_trait_points = STARTING_SPECIES_POINTS
		pref.max_traits = MAX_SPECIES_TRAITS

	if(pref.organ_data[O_BRAIN])	//Checking if we have a synth on our hands, boys.
		pref.dirty_synth = 1
		pref.gross_meatbag = 0
	else
		pref.gross_meatbag = 1
		pref.dirty_synth = 0

	if(pref.species != SPECIES_CUSTOM)
		pref.pos_traits.Cut()
		pref.neg_traits.Cut()
	// Clean up positive traits
	for(var/datum/trait/path as anything in pref.pos_traits)
		if(!(path in positive_traits))
			pref.pos_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			pref.pos_traits -= path
	//Neutral traits
	for(var/datum/trait/path as anything in pref.neu_traits)
		if(!(path in neutral_traits))
			pref.neu_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in everyone_traits))
			pref.neu_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			pref.neu_traits -= path
	//Negative traits
	for(var/datum/trait/path as anything in pref.neg_traits)
		if(!(path in negative_traits))
			pref.neg_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			pref.neg_traits -= path

	var/datum/species/selected_species = GLOB.all_species[pref.species]
	if(selected_species.selects_bodytype)
		// Allowed!
	else if(!pref.custom_base || !(pref.custom_base in GLOB.custom_species_bases))
		pref.custom_base = SPECIES_HUMAN

	pref.custom_say = lowertext(trim(pref.custom_say))
	pref.custom_whisper = lowertext(trim(pref.custom_whisper))
	pref.custom_ask = lowertext(trim(pref.custom_ask))
	pref.custom_exclaim = lowertext(trim(pref.custom_exclaim))

/datum/category_item/player_setup_item/vore/traits/copy_to_mob(var/mob/living/carbon/human/character)
	character.custom_species	= pref.custom_species
	character.custom_say		= lowertext(trim(pref.custom_say))
	character.custom_ask		= lowertext(trim(pref.custom_ask))
	character.custom_whisper	= lowertext(trim(pref.custom_whisper))
	character.custom_exclaim	= lowertext(trim(pref.custom_exclaim))

	if(character.isSynthetic())	//Checking if we have a synth on our hands, boys.
		pref.dirty_synth = 1
		pref.gross_meatbag = 0
	else
		pref.gross_meatbag = 1
		pref.dirty_synth = 0

	var/datum/species/S = character.species
	var/datum/species/new_S = S.produceCopy(pref.pos_traits + pref.neu_traits + pref.neg_traits, character, pref.custom_base)

	//Any additional non-trait settings can be applied here
	new_S.blood_color = pref.blood_color

	if(pref.species == SPECIES_CUSTOM)
		//Statistics for this would be nice
		var/english_traits = english_list(new_S.traits, and_text = ";", comma_text = ";")
		log_game("TRAITS [pref.client_ckey]/([character]) with: [english_traits]") //Terrible 'fake' key_name()... but they aren't in the same entity yet
	else


/datum/category_item/player_setup_item/vore/traits/content(var/mob/user)
	. += "<b>Custom Species Name:</b> "
	. += "<a href='?src=\ref[src];custom_species=1'>[pref.custom_species ? pref.custom_species : "-Input Name-"]</a><br>"

	var/datum/species/selected_species = GLOB.all_species[pref.species]
	if(selected_species.selects_bodytype)
		. += "<b>Icon Base: </b> "
		. += "<a href='?src=\ref[src];custom_base=1'>[pref.custom_base ? pref.custom_base : "Human"]</a><br>"

	var/traits_left = pref.max_traits

	if(pref.species == SPECIES_CUSTOM)
		var/points_left = pref.starting_trait_points

		for(var/T in pref.pos_traits + pref.neg_traits)
			points_left -= traits_costs[T]
			traits_left--
		. += "<b>Traits Left:</b> [traits_left]<br>"
		. += "<b>Points Left:</b> [points_left]<br>"
		if(points_left < 0 || traits_left < 0 || !pref.custom_species)
			. += "<span style='color:red;'><b>^ Fix things! ^</b></span><br>"

		. += "<a href='?src=\ref[src];add_trait=[POSITIVE_MODE]'>Positive Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.pos_traits)
			var/datum/trait/trait = positive_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_pos_trait=[T]'>[trait.name] ([trait.cost])</a></li>"
		. += "</ul>"

		. += "<a href='?src=\ref[src];add_trait=[NEGATIVE_MODE]'>Negative Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.neg_traits)
			var/datum/trait/trait = negative_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_neg_trait=[T]'>[trait.name] ([trait.cost])</a></li>"
		. += "</ul>"
	. += "<a href='?src=\ref[src];add_trait=[NEUTRAL_MODE]'>Neutral Trait +</a><br>"
	. += "<ul>"
	for(var/T in pref.neu_traits)
		var/datum/trait/trait = neutral_traits[T]
		. += "<li>- <a href='?src=\ref[src];clicked_neu_trait=[T]'>[trait.name] ([trait.cost])</a></li>"
	. += "</ul>"
	. += "<b>Blood Color: </b>" //People that want to use a certain species to have that species traits (xenochimera/promethean/spider) should be able to set their own blood color.
	. += "<a href='?src=\ref[src];blood_color=1'>Set Color</a>"
	. += "<a href='?src=\ref[src];blood_reset=1'>R</a><br>"
	. += "<br>"

	. += "<b>Custom Say: </b>"
	. += "<a href='?src=\ref[src];custom_say=1'>Set Say Verb</a>"
	. += "(<a href='?src=\ref[src];reset_say=1'>Reset</A>)"
	. += "<br>"
	. += "<b>Custom Whisper: </b>"
	. += "<a href='?src=\ref[src];custom_whisper=1'>Set Whisper Verb</a>"
	. += "(<a href='?src=\ref[src];reset_whisper=1'>Reset</A>)"
	. += "<br>"
	. += "<b>Custom Ask: </b>"
	. += "<a href='?src=\ref[src];custom_ask=1'>Set Ask Verb</a>"
	. += "(<a href='?src=\ref[src];reset_ask=1'>Reset</A>)"
	. += "<br>"
	. += "<b>Custom Exclaim: </b>"
	. += "<a href='?src=\ref[src];custom_exclaim=1'>Set Exclaim Verb</a>"
	. += "(<a href='?src=\ref[src];reset_exclaim=1'>Reset</A>)"
	. += "<br>"

/datum/category_item/player_setup_item/vore/traits/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	else if(href_list["custom_species"])
		var/raw_choice = sanitize(tgui_input_text(user, "Input your custom species name:",
			"Character Preference", pref.custom_species, MAX_NAME_LEN), MAX_NAME_LEN)
		if (CanUseTopic(user))
			pref.custom_species = raw_choice
		return TOPIC_REFRESH

	else if(href_list["custom_base"])
		var/list/choices = GLOB.custom_species_bases
		if(pref.species != SPECIES_CUSTOM)
			choices = (choices | pref.species)
		var/text_choice = tgui_input_list(usr, "Pick an icon set for your species:","Icon Base", choices)
		if(text_choice in choices)
			pref.custom_base = text_choice
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_color"])
		var/color_choice = input(usr, "Pick a blood color (does not apply to synths)","Blood Color",pref.blood_color) as color
		if(color_choice)
			pref.blood_color = sanitize_hexcolor(color_choice, default="#A10808")
		return TOPIC_REFRESH

	else if(href_list["blood_reset"])
		var/choice = tgui_alert(usr, "Reset blood color to human default (#A10808)?","Reset Blood Color",list("Reset","Cancel"))
		if(choice == "Reset")
			pref.blood_color = "#A10808"
		return TOPIC_REFRESH

	else if(href_list["clicked_pos_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_pos_trait"])
		var/choice = tgui_alert(usr, "Remove [initial(trait.name)] and regain [initial(trait.cost)] points?","Remove Trait",list("Remove","Cancel"))
		if(choice == "Remove")
			pref.pos_traits -= trait
		return TOPIC_REFRESH

	else if(href_list["clicked_neu_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neu_trait"])
		var/choice = tgui_alert(usr, "Remove [initial(trait.name)]?","Remove Trait",list("Remove","Cancel"))
		if(choice == "Remove")
			pref.neu_traits -= trait
		return TOPIC_REFRESH

	else if(href_list["clicked_neg_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neg_trait"])
		var/choice = tgui_alert(usr, "Remove [initial(trait.name)] and lose [initial(trait.cost)] points?","Remove Trait",list("Remove","Cancel"))
		if(choice == "Remove")
			pref.neg_traits -= trait
		return TOPIC_REFRESH

	else if(href_list["custom_say"])
		var/say_choice = sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'says': [pref.real_name] says, \"Hi.\"", "Custom Say", pref.custom_say, 12), 12)
		if(say_choice)
			pref.custom_say = say_choice
		return TOPIC_REFRESH

	else if(href_list["custom_whisper"])
		var/whisper_choice = sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'whispers': [pref.real_name] whispers, \"Hi...\"", "Custom Whisper", pref.custom_whisper, 12), 12)
		if(whisper_choice)
			pref.custom_whisper = whisper_choice
		return TOPIC_REFRESH

	else if(href_list["custom_ask"])
		var/ask_choice = sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'asks': [pref.real_name] asks, \"Hi?\"", "Custom Ask", pref.custom_ask, 12), 12)
		if(ask_choice)
			pref.custom_ask = ask_choice
		return TOPIC_REFRESH

	else if(href_list["custom_exclaim"])
		var/exclaim_choice = sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'exclaims', 'shouts' or 'yells': [pref.real_name] exclaims, \"Hi!\"", "Custom Exclaim", pref.custom_exclaim, 12), 12)
		if(exclaim_choice)
			pref.custom_exclaim = exclaim_choice
		return TOPIC_REFRESH

	else if(href_list["reset_say"])
		var/say_choice = tgui_alert(usr, "Reset your Custom Say Verb?","Reset Verb",list("Yes","No"))
		if(say_choice == "Yes")
			pref.custom_say = null
		return TOPIC_REFRESH

	else if(href_list["reset_whisper"])
		var/whisper_choice = tgui_alert(usr, "Reset your Custom Whisper Verb?","Reset Verb",list("Yes","No"))
		if(whisper_choice == "Yes")
			pref.custom_whisper = null
		return TOPIC_REFRESH

	else if(href_list["reset_ask"])
		var/ask_choice = tgui_alert(usr, "Reset your Custom Ask Verb?","Reset Verb",list("Yes","No"))
		if(ask_choice == "Yes")
			pref.custom_ask = null
		return TOPIC_REFRESH

	else if(href_list["reset_exclaim"])
		var/exclaim_choice = tgui_alert(usr, "Reset your Custom Exclaim Verb?","Reset Verb",list("Yes","No"))
		if(exclaim_choice == "Yes")
			pref.custom_exclaim = null
		return TOPIC_REFRESH

	else if(href_list["add_trait"])
		var/mode = text2num(href_list["add_trait"])
		var/list/picklist
		var/list/mylist
		switch(mode)
			if(POSITIVE_MODE)
				picklist = positive_traits.Copy() - pref.pos_traits
				mylist = pref.pos_traits
			if(NEUTRAL_MODE)
				if(pref.species == SPECIES_CUSTOM)
					picklist = neutral_traits.Copy() - pref.neu_traits
					mylist = pref.neu_traits
				else
					picklist = everyone_traits.Copy() - pref.neu_traits
					mylist = pref.neu_traits
			if(NEGATIVE_MODE)
				picklist = negative_traits.Copy() - pref.neg_traits
				mylist = pref.neg_traits
			else

		if(isnull(picklist))
			return TOPIC_REFRESH

		if(isnull(mylist))
			return TOPIC_REFRESH

		var/list/nicelist = list()
		for(var/P in picklist)
			var/datum/trait/T = picklist[P]
			nicelist[T.name] = P

		var/points_left = pref.starting_trait_points
		for(var/T in pref.pos_traits + pref.neu_traits + pref.neg_traits)
			points_left -= traits_costs[T]

		var/traits_left = pref.max_traits - (pref.pos_traits.len + pref.neg_traits.len)

		var/message = "Select a trait to learn more."
		if(mode != NEUTRAL_MODE)
			message = "\[Remaining: [points_left] points, [traits_left] traits\]\n" + message
		var/title = "Traits"
		switch(mode)
			if(POSITIVE_MODE)
				title = "Positive Traits"
			if(NEUTRAL_MODE)
				title = "Neutral Traits"
			if(NEGATIVE_MODE)
				title = "Negative Traits"

		var/trait_choice
		var/done = FALSE
		while(!done)
			trait_choice = tgui_input_list(usr, message, title, nicelist)
			if(!trait_choice)
				done = TRUE
			if(trait_choice in nicelist)
				var/datum/trait/path = nicelist[trait_choice]
				var/choice = tgui_alert(usr, "\[Cost:[initial(path.cost)]\] [initial(path.desc)]",initial(path.name), list("Take Trait","Go Back"))
				if(choice != "Go Back")
					done = TRUE

		if(!trait_choice)
			return TOPIC_REFRESH
		else if(trait_choice in nicelist)
			var/datum/trait/path = nicelist[trait_choice]
			var/datum/trait/instance = all_traits[path]

			var/conflict = FALSE

			if(pref.dirty_synth && !(instance.can_take & SYNTHETICS))
				tgui_alert_async(usr, "The trait you've selected can only be taken by organic characters!", "Error")
				pref.dirty_synth = 0	//Just to be sure
				return TOPIC_REFRESH

			if(pref.gross_meatbag && !(instance.can_take & ORGANICS))
				tgui_alert_async(usr, "The trait you've selected can only be taken by synthetic characters!", "Error")
				pref.gross_meatbag = 0	//Just to be sure
				return TOPIC_REFRESH

			if(pref.species in instance.banned_species)
				tgui_alert_async(usr, "The trait you've selected cannot be taken by the species you've chosen!", "Error")
				return TOPIC_REFRESH

			if( LAZYLEN(instance.allowed_species) && !(pref.species in instance.allowed_species))
				tgui_alert_async(usr, "The trait you've selected cannot be taken by the species you've chosen!", "Error")
				return TOPIC_REFRESH

			if(trait_choice in pref.pos_traits + pref.neu_traits + pref.neg_traits)
				conflict = instance.name

			varconflict:
				for(var/P in pref.pos_traits + pref.neu_traits + pref.neg_traits)
					var/datum/trait/instance_test = all_traits[P]
					if(path in instance_test.excludes)
						conflict = instance_test.name
						break varconflict

					for(var/V in instance.var_changes)
						if(V in instance_test.var_changes)
							conflict = instance_test.name
							break varconflict

			if(conflict)
				tgui_alert_async(usr, "You cannot take this trait and [conflict] at the same time. Please remove that trait, or pick another trait to add.", "Error")
				return TOPIC_REFRESH

			mylist += path
			return TOPIC_REFRESH

	return ..()

#undef POSITIVE_MODE
#undef NEUTRAL_MODE
#undef NEGATIVE_MODE
