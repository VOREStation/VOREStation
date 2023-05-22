/*
A new Ability given to all human mobs

This ability intends to retrieve all positive, neutral and negative traits chosen in the character set-up
then retrieve their relevant vars by assuming the character's species has the full list. This should always work. Should

The ability is intended to be developed both as a to_chat() and a tgui window.
The user is given the ability to choose which they would like whenever they press the ability to better suit whatever scenario they find themselves
thirsty for knowledge.

When adding new tutorials for trait subtypes, use <br> rather than \n newlines

TGUI backend path: code\modules\tgui\modules\trait_tutorial_tgui.dm
TGUI frontend path: tgui\packages\tgui\interfaces\TraitTutorial.tsx
*/





/mob/living/carbon/human/verb/trait_tutorial()
	set name = "Explain Custom Traits"
	set desc = "Click this verb to obtain a detailed tutorial on your selected traits. "
	set category = "Abilities"
	var/datum/tgui_module/trait_tutorial_tgui/fancy_UI
	if(!fancy_UI)
		fancy_UI = new /datum/tgui_module/trait_tutorial_tgui/ //Preventing a bunch of instances being spawned all over the place. Hopefully



	var/list/list_of_traits = species.traits
	if(!LAZYLEN(list_of_traits))
		to_chat(usr, SPAN_NOTICE("You do not have any custom traits!"))
		return


	var/UI_choice = tgui_alert(src, "Would you like the tutorial text to be printed to chat?", "Choose preferred tutorial interface", list("TGUI","To Chat", "Cancel"))
	if(UI_choice == "Cancel")
		return

	//Initializing associative lists
	var/trait_names = list() //List of keys
	var/trait_category = list() // name:category
	var/trait_desc = list() // name:desc
	var/trait_tutorial = list() //name:tutorial
	for(var/trait in list_of_traits)
		var/datum/trait/T = all_traits[trait]
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


	else if(UI_choice == "TGUI")

		fancy_UI.set_vars(trait_names, trait_category, trait_desc, trait_tutorial)
		fancy_UI.tgui_interact(usr)
