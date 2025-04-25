#define POSITIVE_MODE 1
#define NEUTRAL_MODE 2
#define NEGATIVE_MODE 3

var/global/list/valid_bloodreagents = list("default",REAGENT_ID_IRON,REAGENT_ID_COPPER,REAGENT_ID_PHORON,REAGENT_ID_SILVER,REAGENT_ID_GOLD,REAGENT_ID_SLIMEJELLY)	//allowlist-based so people don't make their blood restored by alcohol or something really silly. use reagent IDs!

/datum/preferences
	var/custom_base		// What to base the custom species on
	var/blood_color = "#A10808"

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

/datum/category_item/player_setup_item/general/traits/proc/get_pref_choice_from_trait(var/mob/user, var/datum/trait/trait, var/preference)
	if (!trait || !preference)
		return
	var/list/trait_prefs
	var/datum/trait/instance = GLOB.all_traits[trait]
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
			var/new_color = tgui_color_picker(user, "Choose the color for this trait preference:", "Trait Preference", trait_prefs[preference])
			if (new_color)
				trait_prefs[preference] = new_color
		if (3) //TRAIT_PREF_TYPE_STRING
			var/new_string = instance.apply_sanitization_to_string(preference, tgui_input_text(user, "What should the new value be?", instance.has_preferences[preference][2], trait_prefs[preference], MAX_NAME_LEN))
			trait_prefs[preference] = new_string

// Definition of the stuff for Ears
/datum/category_item/player_setup_item/general/traits
	name = "Traits"
	sort_order = 7

/datum/category_item/player_setup_item/general/traits/load_character(list/save_data)
	pref.custom_base			= save_data["custom_base"]
	pref.pos_traits				= text2path_list(save_data["pos_traits"])
	pref.neu_traits				= text2path_list(save_data["neu_traits"])
	pref.neg_traits				= text2path_list(save_data["neg_traits"])
	pref.blood_color			= save_data["blood_color"]
	pref.blood_reagents			= save_data["blood_reagents"]

	pref.traits_cheating		= save_data["traits_cheating"]
	pref.max_traits				= save_data["max_traits"]
	pref.starting_trait_points	= save_data["trait_points"]


/datum/category_item/player_setup_item/general/traits/save_character(list/save_data)
	save_data["custom_base"]		= pref.custom_base
	save_data["pos_traits"]			= check_list_copy(pref.pos_traits)
	save_data["neu_traits"]			= check_list_copy(pref.neu_traits)
	save_data["neg_traits"]			= check_list_copy(pref.neg_traits)
	save_data["blood_color"]		= pref.blood_color
	save_data["blood_reagents"]		= pref.blood_reagents

	save_data["traits_cheating"]	= pref.traits_cheating
	save_data["max_traits"]			= pref.max_traits
	save_data["trait_points"]		= pref.starting_trait_points

/datum/category_item/player_setup_item/general/traits/sanitize_character()
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
		if(!(path in GLOB.positive_traits))
			pref.pos_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in GLOB.everyone_traits_positive))
			pref.pos_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			pref.pos_traits -= path
	//Neutral traits
	for(var/datum/trait/path as anything in pref.neu_traits)
		if(!(path in GLOB.neutral_traits))
			to_world_log("removing [path] for not being in neutral_traits")
			pref.neu_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in GLOB.everyone_traits_neutral))
			to_world_log("removing [path] for not being a custom species")
			pref.neu_traits -= path
			continue
		var/take_flags = initial(path.can_take)
		if((pref.dirty_synth && !(take_flags & SYNTHETICS)) || (pref.gross_meatbag && !(take_flags & ORGANICS)))
			to_world_log("removing [path] for being a dirty synth")
			pref.neu_traits -= path
	//Negative traits
	for(var/datum/trait/path as anything in pref.neg_traits)
		if(!(path in GLOB.negative_traits))
			pref.neg_traits -= path
			continue
		if(!(pref.species == SPECIES_CUSTOM) && !(path in GLOB.everyone_traits_negative))
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


/datum/category_item/player_setup_item/general/traits/copy_to_mob(var/mob/living/carbon/human/character)
	if(character.isSynthetic())	//Checking if we have a synth on our hands, boys.
		pref.dirty_synth = 1
		pref.gross_meatbag = 0
	else
		pref.gross_meatbag = 1
		pref.dirty_synth = 0

	var/datum/species/S = character.species
	var/datum/species/new_S = S.produceCopy(pref.pos_traits + pref.neu_traits + pref.neg_traits, character, pref.custom_base, TRUE)

	for(var/datum/trait/T in new_S.traits)
		T.apply_pref(src)

	//Any additional non-trait settings can be applied here
	new_S.blood_color = pref.blood_color
	if(!(pref.blood_reagents == "default"))
		new_S.blood_reagents = pref.blood_reagents

	var/species_sounds_to_copy = pref.species_sound // What sounds are we using?
	if(species_sounds_to_copy == "Unset") // Are we unset?
		species_sounds_to_copy = select_default_species_sound(pref) // This will also grab gendered versions of the sounds, if they exist.

	new_S.species_sounds = species_sounds_to_copy // Now we send our sounds over to the mob

	if(pref.species == SPECIES_CUSTOM)
		//Statistics for this would be nice
		var/english_traits = english_list(new_S.traits, and_text = ";", comma_text = ";")
		log_game("TRAITS [pref.client_ckey]/([character]) with: [english_traits]") //Terrible 'fake' key_name()... but they aren't in the same entity yet

/datum/category_item/player_setup_item/general/traits/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/datum/species/selected_species = GLOB.all_species[pref.species]
	data["selects_bodytype"] = selected_species.selects_bodytype
	data["custom_base"] = pref.custom_base
	data["blood_color"] = pref.blood_color
	data["blood_reagents"] = pref.blood_reagents

	data["pos_traits"] = pref.pos_traits
	data["neu_traits"] = pref.neu_traits
	data["neg_traits"] = pref.neg_traits
	data["traits_cheating"] = pref.traits_cheating
	data["max_traits"] = pref.max_traits
	data["trait_points"] = pref.starting_trait_points

	return data

/datum/category_item/player_setup_item/general/traits/tgui_constant_data()
	var/list/data = ..()

	var/list/all_traits = list()
	for(var/path in GLOB.all_traits)
		var/datum/trait/T = GLOB.all_traits[path]
		all_traits[path] = list(
			"cost" = T.cost,
			"name" = T.name,
			"category" = T.category,
			"has_preferences" = T.has_preferences,
		)

	data["all_traits"] = all_traits

	return data

/datum/category_item/player_setup_item/general/traits/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("custom_base")
			var/list/choices = pref.get_custom_bases_for_species()
			var/text_choice = tgui_input_list(user, "Pick an icon set for your species:","Icon Base", choices)
			if(text_choice in choices)
				pref.custom_base = text_choice
			return TOPIC_REFRESH_UPDATE_PREVIEW
		if("blood_color")
			var/color_choice = tgui_color_picker(user, "Pick a blood color (does not apply to synths)","Blood Color",pref.blood_color)
			if(color_choice)
				pref.blood_color = sanitize_hexcolor(color_choice, default="#A10808")
			return TOPIC_REFRESH
		if("blood_reset")
			var/datum/species/spec = GLOB.all_species[pref.species]
			var/new_blood = spec.blood_color ? spec.blood_color : "#A10808"
			var/choice = tgui_alert(user, "Reset blood color to species default ([new_blood])?","Reset Blood Color",list("Reset","Cancel"))
			if(choice == "Reset")
				pref.blood_color = new_blood
			return TOPIC_REFRESH
		if("blood_reagents")
			var/new_blood_reagents = tgui_input_list(user, "Choose your character's blood restoration reagent:", "Character Preference", valid_bloodreagents)
			if(new_blood_reagents && CanUseTopic(user))
				pref.blood_reagents = new_blood_reagents
				return TOPIC_REFRESH
		if("clicked_pos_trait")
			var/datum/trait/trait = text2path(params["trait"])
			var/choice = tgui_alert(user, "Remove [initial(trait.name)] and regain [initial(trait.cost)] points?","Remove Trait",list("Remove","Cancel"))
			if(choice == "Remove")
				pref.pos_traits -= trait
				var/datum/trait/instance = GLOB.all_traits[trait]
				instance.remove_pref(pref)
			return TOPIC_REFRESH
		if("clicked_neu_trait")
			var/datum/trait/trait = text2path(params["trait"])
			var/choice = tgui_alert(user, "Remove [initial(trait.name)]?","Remove Trait",list("Remove","Cancel"))
			if(choice == "Remove")
				pref.neu_traits -= trait
				var/datum/trait/instance = GLOB.all_traits[trait]
				instance.remove_pref(pref)
			return TOPIC_REFRESH
		if("clicked_neg_trait")
			var/datum/trait/trait = text2path(params["trait"])
			var/choice = tgui_alert(user, "Remove [initial(trait.name)] and lose [initial(trait.cost)] points?","Remove Trait",list("Remove","Cancel"))
			if(choice == "Remove")
				pref.neg_traits -= trait
				var/datum/trait/instance = GLOB.all_traits[trait]
				instance.remove_pref(pref)
			return TOPIC_REFRESH
		if("clicked_trait_pref")
			var/datum/trait/trait = text2path(params["clicked_trait_pref"])
			get_pref_choice_from_trait(user, trait, params["pref"])
			return TOPIC_REFRESH
		if("add_trait")
			var/mode = text2num(params["add_trait"])
			var/list/picklist
			var/list/mylist
			switch(mode)
				if(POSITIVE_MODE)
					if(pref.species == SPECIES_CUSTOM)
						picklist = GLOB.positive_traits.Copy() - pref.pos_traits
						mylist = pref.pos_traits
					else
						picklist = GLOB.everyone_traits_positive.Copy() - pref.pos_traits
						mylist = pref.pos_traits
				if(NEUTRAL_MODE)
					if(pref.species == SPECIES_CUSTOM)
						picklist = GLOB.neutral_traits.Copy() - pref.neu_traits
						mylist = pref.neu_traits
					else
						picklist = GLOB.everyone_traits_neutral.Copy() - pref.neu_traits
						mylist = pref.neu_traits
				if(NEGATIVE_MODE)
					if(pref.species == SPECIES_CUSTOM)
						picklist = GLOB.negative_traits.Copy() - pref.neg_traits
						mylist = pref.neg_traits
					else
						picklist = GLOB.everyone_traits_negative.Copy() - pref.neg_traits
						mylist = pref.neg_traits

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
				points_left -= GLOB.traits_costs[T]

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
				trait_choice = tgui_input_list(user, message, title, nicelist)
				if(!trait_choice)
					done = TRUE
				if(trait_choice in nicelist)
					var/datum/trait/path = nicelist[trait_choice]
					var/choice = tgui_alert(user, "\[Cost:[initial(path.cost)]\] [initial(path.desc)]",initial(path.name), list("Take Trait","Go Back"))
					if(choice == "Take Trait")
						done = TRUE

			if(!trait_choice)
				return TOPIC_REFRESH
			else if(trait_choice in nicelist)
				var/datum/trait/path = nicelist[trait_choice]
				var/datum/trait/instance = GLOB.all_traits[path]

				var/conflict = FALSE

				if(pref.dirty_synth && !(instance.can_take & SYNTHETICS))
					tgui_alert_async(user, "The trait you've selected can only be taken by organic characters!", "Error")
					return TOPIC_REFRESH

				if(pref.gross_meatbag && !(instance.can_take & ORGANICS))
					tgui_alert_async(user, "The trait you've selected can only be taken by synthetic characters!", "Error")
					return TOPIC_REFRESH

				if(pref.species in instance.banned_species)
					tgui_alert_async(user, "The trait you've selected cannot be taken by the species you've chosen!", "Error")
					return TOPIC_REFRESH

				if( LAZYLEN(instance.allowed_species) && !(pref.species in instance.allowed_species))
					tgui_alert_async(user, "The trait you've selected cannot be taken by the species you've chosen!", "Error")
					return TOPIC_REFRESH

				if(trait_choice in (pref.pos_traits + pref.neu_traits + pref.neg_traits))
					conflict = instance.name

				varconflict:
					for(var/P in (pref.pos_traits + pref.neu_traits + pref.neg_traits))
						var/datum/trait/instance_test = GLOB.all_traits[P]
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
					tgui_alert_async(user, "You cannot take this trait and [conflict] at the same time. Please remove that trait, or pick another trait to add.", "Error")
					return TOPIC_REFRESH

				instance.apply_pref(pref)
				mylist[path] = instance.get_default_prefs()
				return TOPIC_REFRESH

#undef POSITIVE_MODE
#undef NEUTRAL_MODE
#undef NEGATIVE_MODE
