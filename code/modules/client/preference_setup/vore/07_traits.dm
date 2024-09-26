#define POSITIVE_MODE 1
#define NEUTRAL_MODE 2
#define NEGATIVE_MODE 3

var/global/list/valid_bloodreagents = list("default","iron","copper","phoron","silver","gold","slimejelly")	//allowlist-based so people don't make their blood restored by alcohol or something really silly. use reagent IDs!

/datum/preferences
	var/custom_species	// Custom species name, can't be changed due to it having been used in savefiles already.
	var/custom_base		// What to base the custom species on
	var/blood_color = "#A10808"

	var/custom_say = null
	var/custom_whisper = null
	var/custom_ask = null
	var/custom_exclaim = null

	var/list/custom_heat = list()
	var/list/custom_cold = list()

	var/list/pos_traits	= list()	// What traits they've selected for their custom species
	var/list/neu_traits = list()
	var/list/neg_traits = list()

	var/traits_cheating = 0 //Varedit by admins allows saving new maximums on people who apply/etc
	var/starting_trait_points = 0
	var/max_traits = MAX_SPECIES_TRAITS
	var/dirty_synth = 0		//Are you a synth
	var/gross_meatbag = 0		//Where'd I leave my Voight-Kampff test kit?

/datum/preferences/proc/get_custom_bases_for_species(var/new_species)
	if (!new_species)
		new_species = species
	var/list/choices
	var/datum/species/spec = GLOB.all_species[new_species]
	if (spec.selects_bodytype == SELECTS_BODYTYPE_SHAPESHIFTER)
		choices = spec.get_valid_shapeshifter_forms()
		choices = choices.Copy()
	else if (spec.selects_bodytype == SELECTS_BODYTYPE_CUSTOM)
		choices = GLOB.custom_species_bases.Copy()
		if(new_species != SPECIES_CUSTOM)
			choices = (choices | new_species)
	return choices

/datum/category_item/player_setup_item/vore/traits/proc/get_html_for_trait(var/datum/trait/trait, var/list/trait_prefs = null)
	. = ""
	if (!LAZYLEN(trait.has_preferences))
		return
	. = "<br><ul>"
	var/altered = FALSE
	if (!LAZYLEN(trait_prefs))
		trait_prefs = trait.get_default_prefs()
		altered = TRUE
	for (var/identifier in trait.has_preferences)
		var/pref_list = trait.has_preferences[identifier] //faster
		if (LAZYLEN(pref_list) >= 2)
			if (!(identifier in trait_prefs))
				trait_prefs[identifier] = trait.default_value_for_pref(identifier) //won't be called at all often
				altered = TRUE
			. += "<li>- [pref_list[2]]:"
			var/link = " <a href='?src=\ref[src];clicked_trait_pref=[trait.type];pref=[identifier]'>"
			switch (pref_list[1])
				if (1) //TRAIT_PREF_TYPE_BOOLEAN
					. += link + (trait_prefs[identifier] ? "Enabled" : "Disabled")
				if (2) //TRAIT_PREF_TYPE_COLOR
					. += " " + color_square(hex = trait_prefs[identifier]) + link + "Change"
			. += "</a></li>"
	. += "</ul>"
	if (altered)
		switch(trait.category)
			if (1) //TRAIT_TYPE_POSITIVE
				pref.pos_traits[trait.type] = trait_prefs
			if (0) //TRAIT_TYPE_NEUTRAL
				pref.neu_traits[trait.type] = trait_prefs
			if (-1)//TRAIT_TYPE_NEGATIVE
				pref.neg_traits[trait.type] = trait_prefs

/datum/category_item/player_setup_item/vore/traits/proc/get_pref_choice_from_trait(var/mob/user, var/datum/trait/trait, var/preference)
	if (!trait || !preference)
		return
	var/list/trait_prefs
	var/datum/trait/instance = all_traits[trait]
	var/list/traitlist
	switch(instance.category)
		if (1)
			traitlist = pref.pos_traits
		if (0)
			traitlist = pref.neu_traits
		if (-1)
			traitlist = pref.neg_traits
	if (!LAZYLEN(instance.has_preferences) || !(preference in instance.has_preferences) || !traitlist)
		return
	if (!LAZYLEN(traitlist[trait]))
		traitlist[trait] = instance.get_default_prefs()
	trait_prefs = traitlist[trait]
	if (!(preference in trait_prefs))
		trait_prefs[preference] = instance.default_value_for_pref(preference) //won't be called at all often
	switch(instance.has_preferences[preference][1])
		if (1) //TRAIT_PREF_TYPE_BOOLEAN
			trait_prefs[preference] = !trait_prefs[preference]
		if (2) //TRAIT_PREF_TYPE_COLOR
			var/new_color = input(user, "Choose the color for this trait preference:", "Trait Preference", trait_prefs[preference]) as color|null
			if (new_color)
				trait_prefs[preference] = new_color

// Definition of the stuff for Ears
/datum/category_item/player_setup_item/vore/traits
	name = "Traits"
	sort_order = 7

/datum/category_item/player_setup_item/vore/traits/load_character(list/save_data)
	pref.custom_species			= save_data["custom_species"]
	pref.custom_base			= save_data["custom_base"]
	pref.pos_traits				= text2path_list(save_data["pos_traits"])
	pref.neu_traits				= text2path_list(save_data["neu_traits"])
	pref.neg_traits				= text2path_list(save_data["neg_traits"])
	pref.blood_color			= save_data["blood_color"]
	pref.blood_reagents			= save_data["blood_reagents"]

	pref.traits_cheating		= save_data["traits_cheating"]
	pref.max_traits				= save_data["max_traits"]
	pref.starting_trait_points	= save_data["trait_points"]

	pref.custom_say				= save_data["custom_say"]
	pref.custom_whisper			= save_data["custom_whisper"]
	pref.custom_ask				= save_data["custom_ask"]
	pref.custom_exclaim			= save_data["custom_exclaim"]

	pref.custom_heat			= check_list_copy(save_data["custom_heat"])
	pref.custom_cold			= check_list_copy(save_data["custom_cold"])

/datum/category_item/player_setup_item/vore/traits/save_character(list/save_data)
	save_data["custom_species"]		= pref.custom_species
	save_data["custom_base"]		= pref.custom_base
	save_data["pos_traits"]			= check_list_copy(pref.pos_traits)
	save_data["neu_traits"]			= check_list_copy(pref.neu_traits)
	save_data["neg_traits"]			= check_list_copy(pref.neg_traits)
	save_data["blood_color"]		= pref.blood_color
	save_data["blood_reagents"]		= pref.blood_reagents

	save_data["traits_cheating"]	= pref.traits_cheating
	save_data["max_traits"]			= pref.max_traits
	save_data["trait_points"]		= pref.starting_trait_points

	save_data["custom_say"]			= pref.custom_say
	save_data["custom_whisper"]		= pref.custom_whisper
	save_data["custom_ask"]			= pref.custom_ask
	save_data["custom_exclaim"]		= pref.custom_exclaim

	save_data["custom_heat"]		= check_list_copy(pref.custom_heat)
	save_data["custom_cold"]		= check_list_copy(pref.custom_cold)

/datum/category_item/player_setup_item/vore/traits/sanitize_character()
	if(!pref.pos_traits) pref.pos_traits = list()
	if(!pref.neu_traits) pref.neu_traits = list()
	if(!pref.neg_traits) pref.neg_traits = list()

	pref.blood_color = sanitize_hexcolor(pref.blood_color, default="#A10808")
	pref.blood_reagents	= sanitize_text(pref.blood_reagents, initial(pref.blood_reagents))

	if(!pref.traits_cheating)
		var/datum/species/S = GLOB.all_species[pref.species]
		if(S)
			pref.starting_trait_points = S.trait_points
		else
			pref.starting_trait_points = 0
		pref.max_traits = MAX_SPECIES_TRAITS

	if(pref.organ_data[O_BRAIN])	//Checking if we have a synth on our hands, boys.
		pref.dirty_synth = 1
		pref.gross_meatbag = 0
	else
		pref.gross_meatbag = 1
		pref.dirty_synth = 0

	// Clean up positive traits
	for(var/datum/trait/path as anything in pref.pos_traits)
		if(!(path in positive_traits))
			pref.pos_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in everyone_traits_positive))
			pref.pos_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			pref.pos_traits -= path
	//Neutral traits
	for(var/datum/trait/path as anything in pref.neu_traits)
		if(!(path in neutral_traits))
			to_world_log("removing [path] for not being in neutral_traits")
			pref.neu_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in everyone_traits_neutral))
			to_world_log("removing [path] for not being a custom species")
			pref.neu_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			to_world_log("removing [path] for being a dirty synth")
			pref.neu_traits -= path
	//Negative traits
	for(var/datum/trait/path as anything in pref.neg_traits)
		if(!(path in negative_traits))
			pref.neg_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in everyone_traits_negative))
			pref.neg_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			pref.neg_traits -= path

	var/datum/species/selected_species = GLOB.all_species[pref.species]
	if(selected_species.selects_bodytype)
		if (!(pref.custom_base in pref.get_custom_bases_for_species()))
			pref.custom_base = SPECIES_HUMAN
		//otherwise, allowed!
	else if(!pref.custom_base || !(pref.custom_base in GLOB.custom_species_bases))
		pref.custom_base = SPECIES_HUMAN

	pref.custom_say = lowertext(trim(pref.custom_say))
	pref.custom_whisper = lowertext(trim(pref.custom_whisper))
	pref.custom_ask = lowertext(trim(pref.custom_ask))
	pref.custom_exclaim = lowertext(trim(pref.custom_exclaim))

	if (islist(pref.custom_heat)) //don't bother checking these for actual singular message length, they should already have been checked and it'd take too long every time it's sanitized
		if (length(pref.custom_heat) > 10)
			pref.custom_heat.Cut(11)
	else
		pref.custom_heat = list()
	if (islist(pref.custom_cold))
		if (length(pref.custom_cold) > 10)
			pref.custom_cold.Cut(11)
	else
		pref.custom_cold = list()

/datum/category_item/player_setup_item/vore/traits/copy_to_mob(var/mob/living/carbon/human/character)
	character.custom_species	= pref.custom_species
	character.custom_say		= lowertext(trim(pref.custom_say))
	character.custom_ask		= lowertext(trim(pref.custom_ask))
	character.custom_whisper	= lowertext(trim(pref.custom_whisper))
	character.custom_exclaim	= lowertext(trim(pref.custom_exclaim))
	character.custom_heat = pref.custom_heat
	character.custom_cold = pref.custom_cold


	if(character.isSynthetic())	//Checking if we have a synth on our hands, boys.
		pref.dirty_synth = 1
		pref.gross_meatbag = 0
	else
		pref.gross_meatbag = 1
		pref.dirty_synth = 0

	var/datum/species/S = character.species
	var/datum/species/new_S = S.produceCopy(pref.pos_traits + pref.neu_traits + pref.neg_traits, character, pref.custom_base)

	for(var/datum/trait/T in new_S.traits)
		T.apply_pref(src)

	//Any additional non-trait settings can be applied here
	new_S.blood_color = pref.blood_color
	if(!(pref.blood_reagents == "default"))
		new_S.blood_reagents = pref.blood_reagents

	if(pref.species == SPECIES_CUSTOM)
		//Statistics for this would be nice
		var/english_traits = english_list(new_S.traits, and_text = ";", comma_text = ";")
		log_game("TRAITS [pref.client_ckey]/([character]) with: [english_traits]") //Terrible 'fake' key_name()... but they aren't in the same entity yet

/datum/category_item/player_setup_item/vore/traits/content(var/mob/user)
	. += "<b>Custom Species Name:</b> "
	. += "<a href='?src=\ref[src];custom_species=1'>[pref.custom_species ? pref.custom_species : "-Input Name-"]</a><br>"

	var/datum/species/selected_species = GLOB.all_species[pref.species]
	if(selected_species.selects_bodytype)
		. += "<b>Icon Base: </b> "
		. += "<a href='?src=\ref[src];custom_base=1'>[pref.custom_base ? pref.custom_base : "Human"]</a><br>"

	var/traits_left = pref.max_traits


	var/points_left = pref.starting_trait_points

	for(var/T in pref.pos_traits + pref.neg_traits)
		points_left -= traits_costs[T]
		if(T in pref.pos_traits)
			traits_left--
	. += "<b>Traits Left:</b> [traits_left]<br>"
	. += "<b>Points Left:</b> [points_left]<br>"
	if(points_left < 0 || traits_left < 0 || (!pref.custom_species && pref.species == SPECIES_CUSTOM))
		. += "<span style='color:red;'><b>^ Fix things! ^</b></span><br>"

	. += "<a href='?src=\ref[src];add_trait=[POSITIVE_MODE]'>Positive Trait +</a><br>"
	. += "<ul>"
	for(var/T in pref.pos_traits)
		var/datum/trait/trait = positive_traits[T]
		. += "<li>- <a href='?src=\ref[src];clicked_pos_trait=[T]'>[trait.name] ([trait.cost])</a> [get_html_for_trait(trait, pref.pos_traits[T])]</li>"
	. += "</ul>"

	. += "<a href='?src=\ref[src];add_trait=[NEUTRAL_MODE]'>Neutral Trait +</a><br>"
	. += "<ul>"
	for(var/T in pref.neu_traits)
		var/datum/trait/trait = neutral_traits[T]
		. += "<li>- <a href='?src=\ref[src];clicked_neu_trait=[T]'>[trait.name] ([trait.cost])</a> [get_html_for_trait(trait, pref.neu_traits[T])]</li>"
	. += "</ul>"

	. += "<a href='?src=\ref[src];add_trait=[NEGATIVE_MODE]'>Negative Trait +</a><br>"
	. += "<ul>"
	for(var/T in pref.neg_traits)
		var/datum/trait/trait = negative_traits[T]
		. += "<li>- <a href='?src=\ref[src];clicked_neg_trait=[T]'>[trait.name] ([trait.cost])</a> [get_html_for_trait(trait, pref.neg_traits[T])]</li>"
	. += "</ul>"

	. += "<b>Blood Color: </b>" //People that want to use a certain species to have that species traits (xenochimera/promethean/spider) should be able to set their own blood color.
	. += "<a href='?src=\ref[src];blood_color=1'>Set Color <font color='[pref.blood_color]'>&#9899;</font></a>"
	. += "<a href='?src=\ref[src];blood_reset=1'>R</a><br>"
	. += "<b>Blood Reagent: </b>"	//Wanna be copper-based? Go ahead.
	. += "<a href='?src=\ref[src];blood_reagents=1'>[pref.blood_reagents]</a><br>"
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
	. += "<b>Custom Heat Discomfort: </b>"
	. += "<a href='?src=\ref[src];custom_heat=1'>Set Heat Messages</a>"
	. += "(<a href='?src=\ref[src];reset_heat=1'>Reset</A>)"
	. += "<br>"
	. += "<b>Custom Cold Discomfort: </b>"
	. += "<a href='?src=\ref[src];custom_cold=1'>Set Cold Messages</a>"
	. += "(<a href='?src=\ref[src];reset_cold=1'>Reset</A>)"
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
		var/list/choices = pref.get_custom_bases_for_species()
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
		var/datum/species/spec = GLOB.all_species[pref.species]
		var/new_blood = spec.blood_color ? spec.blood_color : "#A10808"
		var/choice = tgui_alert(usr, "Reset blood color to species default ([new_blood])?","Reset Blood Color",list("Reset","Cancel"))
		if(choice == "Reset")
			pref.blood_color = new_blood
		return TOPIC_REFRESH

	else if(href_list["blood_reagents"])
		var/new_blood_reagents = tgui_input_list(user, "Choose your character's blood restoration reagent:", "Character Preference", valid_bloodreagents)
		if(new_blood_reagents && CanUseTopic(user))
			pref.blood_reagents = new_blood_reagents
			return TOPIC_REFRESH

	else if(href_list["clicked_pos_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_pos_trait"])
		var/choice = tgui_alert(usr, "Remove [initial(trait.name)] and regain [initial(trait.cost)] points?","Remove Trait",list("Remove","Cancel"))
		if(choice == "Remove")
			pref.pos_traits -= trait
			var/datum/trait/instance = all_traits[trait]
			instance.remove_pref(pref)
		return TOPIC_REFRESH

	else if(href_list["clicked_neu_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neu_trait"])
		var/choice = tgui_alert(usr, "Remove [initial(trait.name)]?","Remove Trait",list("Remove","Cancel"))
		if(choice == "Remove")
			pref.neu_traits -= trait
			var/datum/trait/instance = all_traits[trait]
			instance.remove_pref(pref)
		return TOPIC_REFRESH

	else if(href_list["clicked_neg_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neg_trait"])
		var/choice = tgui_alert(usr, "Remove [initial(trait.name)] and lose [initial(trait.cost)] points?","Remove Trait",list("Remove","Cancel"))
		if(choice == "Remove")
			pref.neg_traits -= trait
			var/datum/trait/instance = all_traits[trait]
			instance.remove_pref(pref)
		return TOPIC_REFRESH

	else if(href_list["clicked_trait_pref"])
		var/datum/trait/trait = text2path(href_list["clicked_trait_pref"])
		get_pref_choice_from_trait(user, trait, href_list["pref"])
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

	else if(href_list["custom_heat"])
		tgui_alert(user, "You are setting custom heat messages. These will overwrite your species' defaults. To return to defaults, click reset.")
		var/old_message = pref.custom_heat.Join("\n\n")
		var/new_message = sanitize(tgui_input_text(usr,"Use double enter between messages to enter a new one. Must be at least 3 characters long, 160 characters max and up to 10 messages are allowed.","Heat Discomfort messages",old_message, multiline= TRUE, prevent_enter = TRUE), MAX_MESSAGE_LEN,0,0,0)
		if(length(new_message) > 0)
			var/list/raw_list = splittext(new_message,"\n\n")
			if(raw_list.len > 10)
				raw_list.Cut(11)
			for(var/i = 1, i <= raw_list.len, i++)
				if(length(raw_list[i]) < 3 || length(raw_list[i]) > 160)
					raw_list.Cut(i,i)
				else
					raw_list[i] = readd_quotes(raw_list[i])
			ASSERT(raw_list.len <= 10)
			pref.custom_heat = raw_list
		return TOPIC_REFRESH

	else if(href_list["custom_cold"])
		tgui_alert(user, "You are setting custom cold messages. These will overwrite your species' defaults. To return to defaults, click reset.")
		var/old_message = pref.custom_heat.Join("\n\n")
		var/new_message = sanitize(tgui_input_text(usr,"Use double enter between messages to enter a new one. Must be at least 3 characters long, 160 characters max and up to 10 messages are allowed.","Cold Discomfort messages",old_message, multiline= TRUE, prevent_enter = TRUE), MAX_MESSAGE_LEN,0,0,0)
		if(length(new_message) > 0)
			var/list/raw_list = splittext(new_message,"\n\n")
			if(raw_list.len > 10)
				raw_list.Cut(11)
			for(var/i = 1, i <= raw_list.len, i++)
				if(length(raw_list[i]) < 3 || length(raw_list[i]) > 160)
					raw_list.Cut(i,i)
				else
					raw_list[i] = readd_quotes(raw_list[i])
			ASSERT(raw_list.len <= 10)
			pref.custom_cold = raw_list
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

	else if(href_list["reset_cold"])
		var/cold_choice = tgui_alert(usr, "Reset your Custom Cold Discomfort messages?", "Reset Discomfort",list("Yes","No"))
		if(cold_choice == "Yes")
			pref.custom_cold = list()
		return TOPIC_REFRESH

	else if(href_list["reset_heat"])
		var/heat_choice = tgui_alert(usr, "Reset your Custom Heat Discomfort messages?", "Reset Discomfort",list("Yes","No"))
		if(heat_choice == "Yes")
			pref.custom_heat = list()
		return TOPIC_REFRESH

	else if(href_list["add_trait"])
		var/mode = text2num(href_list["add_trait"])
		var/list/picklist
		var/list/mylist
		switch(mode)
			if(POSITIVE_MODE)
				if(pref.species == SPECIES_CUSTOM)
					picklist = positive_traits.Copy() - pref.pos_traits
					mylist = pref.pos_traits
				else
					picklist = everyone_traits_positive.Copy() - pref.pos_traits
					mylist = pref.pos_traits
			if(NEUTRAL_MODE)
				if(pref.species == SPECIES_CUSTOM)
					picklist = neutral_traits.Copy() - pref.neu_traits
					mylist = pref.neu_traits
				else
					picklist = everyone_traits_neutral.Copy() - pref.neu_traits
					mylist = pref.neu_traits
			if(NEGATIVE_MODE)
				if(pref.species == SPECIES_CUSTOM)
					picklist = negative_traits.Copy() - pref.neg_traits
					mylist = pref.neg_traits
				else
					picklist = everyone_traits_negative.Copy() - pref.neg_traits
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
				if(choice == "Take Trait")
					done = TRUE

		if(!trait_choice)
			return TOPIC_REFRESH
		else if(trait_choice in nicelist)
			var/datum/trait/path = nicelist[trait_choice]
			var/datum/trait/instance = all_traits[path]

			var/conflict = FALSE

			if(pref.dirty_synth && !(instance.can_take & SYNTHETICS))
				tgui_alert_async(usr, "The trait you've selected can only be taken by organic characters!", "Error")
				return TOPIC_REFRESH

			if(pref.gross_meatbag && !(instance.can_take & ORGANICS))
				tgui_alert_async(usr, "The trait you've selected can only be taken by synthetic characters!", "Error")
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
						if(V == "flags")
							continue
						if(V in instance_test.var_changes)
							conflict = instance_test.name
							break varconflict

					for(var/V in instance.var_changes_pref)
						if(V in instance_test.var_changes_pref)
							conflict = instance_test.name
							break varconflict

			if(conflict)
				tgui_alert_async(usr, "You cannot take this trait and [conflict] at the same time. Please remove that trait, or pick another trait to add.", "Error")
				return TOPIC_REFRESH

			instance.apply_pref(pref)
			mylist[path] = instance.get_default_prefs()
			return TOPIC_REFRESH

	return ..()

#undef POSITIVE_MODE
#undef NEUTRAL_MODE
#undef NEGATIVE_MODE
