#define POSITIVE_MODE 1
#define NEUTRAL_MODE 2
#define NEGATIVE_MODE 3

/datum/preferences
	var/custom_species	// Custom species name, can't be changed due to it having been used in savefiles already.
	var/custom_base		// What to base the custom species on
	var/blood_color = "#A10808"

	var/list/pos_traits	= list()	// What traits they've selected for their custom species
	var/list/neu_traits = list()
	var/list/neg_traits = list()

	var/traits_cheating = 0 //Varedit by admins allows saving new maximums on people who apply/etc
	var/starting_trait_points = STARTING_SPECIES_POINTS
	var/max_traits = MAX_SPECIES_TRAITS

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

	S["traits_cheating"]>> pref.traits_cheating
	S["max_traits"]		>> pref.max_traits
	S["trait_points"]	>> pref.starting_trait_points

/datum/category_item/player_setup_item/vore/traits/save_character(var/savefile/S)
	S["custom_species"]	<< pref.custom_species
	S["custom_base"]	<< pref.custom_base
	S["pos_traits"]		<< pref.pos_traits
	S["neu_traits"]		<< pref.neu_traits
	S["neg_traits"]		<< pref.neg_traits
	S["blood_color"]	<< pref.blood_color

	S["traits_cheating"]<< pref.traits_cheating
	S["max_traits"]		<< pref.max_traits
	S["trait_points"]	<< pref.starting_trait_points

/datum/category_item/player_setup_item/vore/traits/sanitize_character()
	if(!pref.pos_traits) pref.pos_traits = list()
	if(!pref.neu_traits) pref.neu_traits = list()
	if(!pref.neg_traits) pref.neg_traits = list()

	pref.blood_color = sanitize_hexcolor(pref.blood_color, default="#A10808")

	if(!pref.traits_cheating)
		pref.starting_trait_points = STARTING_SPECIES_POINTS
		pref.max_traits = MAX_SPECIES_TRAITS

	if(pref.species != SPECIES_CUSTOM)
		pref.pos_traits.Cut()
		pref.neu_traits.Cut()
		pref.neg_traits.Cut()
	else
		// Clean up positive traits
		for(var/path in pref.pos_traits)
			if(!(path in positive_traits))
				pref.pos_traits -= path
		//Neutral traits
		for(var/path in pref.neu_traits)
			if(!(path in neutral_traits))
				pref.neu_traits -= path
		//Negative traits
		for(var/path in pref.neg_traits)
			if(!(path in negative_traits))
				pref.neg_traits -= path

	var/datum/species/selected_species = all_species[pref.species]
	if(selected_species.selects_bodytype)
		// Allowed!
	else if(!pref.custom_base || !(pref.custom_base in custom_species_bases))
		pref.custom_base = SPECIES_HUMAN

/datum/category_item/player_setup_item/vore/traits/copy_to_mob(var/mob/living/carbon/human/character)
	character.custom_species	= pref.custom_species
	var/datum/species/selected_species = all_species[pref.species]
	if(selected_species.selects_bodytype)
		var/datum/species/custom/CS = character.species
		var/S = pref.custom_base ? pref.custom_base : "Human"
		var/datum/species/custom/new_CS = CS.produceCopy(S, pref.pos_traits + pref.neu_traits + pref.neg_traits, character)

		//Statistics for this would be nice
		var/english_traits = english_list(new_CS.traits, and_text = ";", comma_text = ";")
		log_game("TRAITS [pref.client_ckey]/([character]) with: [english_traits]") //Terrible 'fake' key_name()... but they aren't in the same entity yet
		
		//Any additional non-trait settings can be applied here
		new_CS.blood_color = pref.blood_color

/datum/category_item/player_setup_item/vore/traits/content(var/mob/user)
	. += "<b>Custom Species</b> "
	. += "<a href='?src=\ref[src];custom_species=1'>[pref.custom_species ? pref.custom_species : "-Input Name-"]</a><br>"

	var/datum/species/selected_species = all_species[pref.species]
	if(selected_species.selects_bodytype)
		. += "<b>Icon Base: </b> "
		. += "<a href='?src=\ref[src];custom_base=1'>[pref.custom_base ? pref.custom_base : "Human"]</a><br>"

	if(pref.species == SPECIES_CUSTOM)
		var/points_left = pref.starting_trait_points
		var/traits_left = pref.max_traits
		for(var/T in pref.pos_traits + pref.neg_traits)
			points_left -= traits_costs[T]
			traits_left--

		. += "<b>Points Left:</b> [points_left]<br>"
		. += "<b>Traits Left:</b> [traits_left]<br>"
		if(points_left < 0 || traits_left < 0 || !pref.custom_species)
			. += "<span style='color:red;'><b>^ Fix things! ^</b></span><br>"

		. += "<a href='?src=\ref[src];add_trait=[POSITIVE_MODE]'>Positive Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.pos_traits)
			var/datum/trait/trait = positive_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_pos_trait=[T]'>[trait.name] ([trait.cost])</a></li>"
		. += "</ul>"

		. += "<a href='?src=\ref[src];add_trait=[NEUTRAL_MODE]'>Neutral Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.neu_traits)
			var/datum/trait/trait = neutral_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_neu_trait=[T]'>[trait.name] ([trait.cost])</a></li>"
		. += "</ul>"

		. += "<a href='?src=\ref[src];add_trait=[NEGATIVE_MODE]'>Negative Trait +</a><br>"
		. += "<ul>"
		for(var/T in pref.neg_traits)
			var/datum/trait/trait = negative_traits[T]
			. += "<li>- <a href='?src=\ref[src];clicked_neg_trait=[T]'>[trait.name] ([trait.cost])</a></li>"
		. += "</ul>"
	. += "<b>Blood Color: </b>" //People that want to use a certain species to have that species traits (xenochimera/promethean/spider) should be able to set their own blood color.
	. += "<a href='?src=\ref[src];blood_color=1'>Set Color</a>"
	. += "<a href='?src=\ref[src];blood_reset=1'>R</a><br>"

/datum/category_item/player_setup_item/vore/traits/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

	else if(href_list["custom_species"])
		/*if(pref.species != "Custom Species")
			alert("You cannot set a custom species name unless you set your character to use the 'Custom Species' \
			species on the 'General' tab. If you have this set to something, it's because you had it set before the \
			Trait system was implemented. If you wish to change it, set your species to 'Custom Species' and configure \
			the species completely.")
			return TOPIC_REFRESH*/ //There was no reason to have this.
		var/raw_choice = sanitize(input(user, "Input your custom species name:",
			"Character Preference", pref.custom_species) as null|text, MAX_NAME_LEN)
		if (CanUseTopic(user))
			pref.custom_species = raw_choice
		return TOPIC_REFRESH

	else if(href_list["custom_base"])
		var/list/choices = custom_species_bases
		if(pref.species != SPECIES_CUSTOM)
			choices = (choices | pref.species)
		var/text_choice = input("Pick an icon set for your species:","Icon Base") in choices
		if(text_choice in choices)
			pref.custom_base = text_choice
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_color"])
		var/color_choice = input("Pick a blood color (does not apply to synths)","Blood Color",pref.blood_color) as color
		if(color_choice)
			pref.blood_color = sanitize_hexcolor(color_choice, default="#A10808")
		return TOPIC_REFRESH

	else if(href_list["blood_reset"])
		var/choice = alert("Reset blood color to human default (#A10808)?","Reset Blood Color","Reset","Cancel")
		if(choice == "Reset")
			pref.blood_color = "#A10808"
		return TOPIC_REFRESH

	else if(href_list["clicked_pos_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_pos_trait"])
		var/choice = alert("Remove [initial(trait.name)] and regain [initial(trait.cost)] points?","Remove Trait","Remove","Cancel")
		if(choice == "Remove")
			pref.pos_traits -= trait
		return TOPIC_REFRESH

	else if(href_list["clicked_neu_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neu_trait"])
		var/choice = alert("Remove [initial(trait.name)]?","Remove Trait","Remove","Cancel")
		if(choice == "Remove")
			pref.neu_traits -= trait
		return TOPIC_REFRESH

	else if(href_list["clicked_neg_trait"])
		var/datum/trait/trait = text2path(href_list["clicked_neg_trait"])
		var/choice = alert("Remove [initial(trait.name)] and lose [initial(trait.cost)] points?","Remove Trait","Remove","Cancel")
		if(choice == "Remove")
			pref.neg_traits -= trait
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
				picklist = neutral_traits.Copy() - pref.neu_traits
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

		var/trait_choice
		var/done = FALSE
		while(!done)
			var/message = "\[Remaining: [points_left] points, [traits_left] traits\] Select a trait to read the description and see the cost."
			trait_choice = input(message,"Trait List") as null|anything in nicelist
			if(!trait_choice)
				done = TRUE
			if(trait_choice in nicelist)
				var/datum/trait/path = nicelist[trait_choice]
				var/choice = alert("\[Cost:[initial(path.cost)]\] [initial(path.desc)]",initial(path.name),"Take Trait","Cancel","Go Back")
				if(choice == "Cancel")
					trait_choice = null
				if(choice != "Go Back")
					done = TRUE

		if(!trait_choice)
			return TOPIC_REFRESH
		else if(trait_choice in nicelist)
			var/datum/trait/path = nicelist[trait_choice]
			var/datum/trait/instance = all_traits[path]

			var/conflict = FALSE

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
				alert("You cannot take this trait and [conflict] at the same time. \
				Please remove that trait, or pick another trait to add.","Error")
				return TOPIC_REFRESH

			mylist += path
			return TOPIC_REFRESH

	return ..()

#undef POSITIVE_MODE
#undef NEUTRAL_MODE
#undef NEGATIVE_MODE
