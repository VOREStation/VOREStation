/*
A new Ability given to all human mobs

This ability intends to retrieve all positive, neutral and negative traits chosen in the character set-up
then retrieve their relevant vars by assuming the character's species has the full list. This should always work. Should

The ability is intended to be developed both as a to_chat() and a tgui window.
The user is given the ability to choose which they would like whenever they press the ability to better suit whatever scenario they find themselves
thirsty for knowledge.
*/





/mob/living/carbon/human/verb/trait_tutorial()
	set name = "Explain Custom Traits"
	set desc = "Click this verb to obtain a detailed tutorial on your selected traits. "
	set category = "Abilities"

	var/list/list_of_traits = species.traits
	if(!list_of_traits)
		to_chat(usr, SPAN_NOTICE("You do not have any custom traits!"))


	var/UI_choice = tgui_alert(src, "Would you like the tutorial text to be printed to chat?", "Choose preferred tutorial interface", list("To Chat", "Cancel"))
	if(UI_choice == "Cancel")
		return

	//Initializing associative lists
	var/trait_names = list() //List of keys
	var/trait_category = list() // name:category
	var/trait_desc = list() // name:desc
	var/trait_tutorial = list() //name:tutorial
	for(var/trait in list_of_traits)
		var/datum/trait/T = all_traits[trait]
		to_world_log("##DEBUG [T.name] is of category [T.category]")
		trait_names += T.name
		trait_desc[T.name] = T.desc
		trait_tutorial[T.name] = T.tutorial
		switch(T.category) //Using magic numbers rather than the #defines because it did not work with defines and idk why
			if(-1) //TRAIT_TYPE_NEGATIVE
				trait_category[T.name] = "Negative Trait"
			if(0) //TRAIT_TYPE_NEUTRAL
				trait_category[T.name] = "Neutral Trait"
			if(1) //TRAIT_TYPE_POSITIVE
				trait_category[T.name] = "Positive Trait"


	if(UI_choice == "To Chat")
		var/to_chat_choice = tgui_input_list(usr, "Please choose the trait to be explained", "Print to Chat", trait_names, null)
		if(to_chat_choice)
			to_chat(usr,SPAN_NOTICE("<b>Name:</b> [to_chat_choice] \n <b>Category:</b> [trait_category[to_chat_choice]] \n <b>Description:</b> [trait_desc[to_chat_choice]] \n \
			<b>Guide:</b> \n [trait_tutorial[to_chat_choice]]"))


//	else if(UI_choice == "TGUI")
		to_chat(usr, SPAN_NOTICE("TGUI functionality is not yet implemented, sorry!"))
