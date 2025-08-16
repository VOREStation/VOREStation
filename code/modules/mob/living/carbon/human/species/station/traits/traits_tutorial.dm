/*
A new Ability given to those human mobs that have a non-zero number of traits.
Verb is added by /datum/trait/proc/apply() in code\modules\mob\living\carbon\human\species\station\traits_vr\trait.dm file.
This proc gets called whenever the user is spawned, resleeved, autoresleeved and so forth.
If there are special cases that do NOT call this var that result in a completely new body -
I will fix it once I am informed of their existence.
Been tested - does NOT lead to multiples of the verb thanks to the |=.
Given the apply() proc is only called if they have verbs - this should avoid it erronously popping up for traitless people.

This ability intends to retrieve all positive, neutral and negative traits chosen in the character set-up
then retrieve their relevant vars by assuming the character's species has the full list. This should always work. Should

The ability is intended to be developed both as a message to chat and a tgui window.
The user is given the ability to choose which they would like whenever they press the ability to better suit whatever scenario they find themselves
thirsty for knowledge.

When adding new tutorials for trait subtypes, use <br> rather than \n newlines

TGUI backend path: code\modules\tgui\modules\trait_tutorial_tgui.dm
TGUI frontend path: tgui\packages\tgui\interfaces\TraitTutorial.tsx
*/





/mob/living/carbon/human/proc/trait_tutorial()
	set name = "Explain Custom Traits"
	set desc = "Click this verb to obtain a detailed tutorial on your selected traits. "
	set category = "Abilities.General"
	var/datum/tgui_module/trait_tutorial_tgui/fancy_UI
	if(!fancy_UI)
		fancy_UI = new /datum/tgui_module/trait_tutorial_tgui/ //Preventing a bunch of instances being spawned all over the place. Hopefully



	var/list/list_of_traits = species.traits
	if(!LAZYLEN(list_of_traits)) //Although we shouldn't show up if no traits, leaving this in case someone loses theirs after (re)spawning.
		to_chat(src, span_notice("You do not have any custom traits!"))
		return //Dont want an empty TGUI panel and list by accident after all.


	var/UI_choice = tgui_alert(src, "Would you like the tutorial text to be printed to chat?", "Choose preferred tutorial interface", list("TGUI","To Chat", "Cancel"))
	if(!UI_choice || UI_choice == "Cancel")
		return

	//Initializing associative lists
	var/trait_names = list() //List of keys
	var/trait_category = list() // name:category
	var/trait_desc = list() // name:desc
	var/trait_tutorial = list() //name:tutorial
	for(var/trait in list_of_traits)
		var/datum/trait/T = GLOB.all_traits[trait]
		trait_names += T.name
		trait_desc[T.name] = T.desc
		trait_tutorial[T.name] = T.tutorial
		switch(T.category)
			if(TRAIT_TYPE_NEGATIVE)
				trait_category[T.name] = "Negative Trait"
			if(TRAIT_TYPE_NEUTRAL)
				trait_category[T.name] = "Neutral Trait"
			if(TRAIT_TYPE_POSITIVE)
				trait_category[T.name] = "Positive Trait"


	if(UI_choice == "To Chat")
		var/to_chat_choice = tgui_input_list(src, "Please choose the trait to be explained", "Print to Chat", trait_names, null)
		if(to_chat_choice)
			to_chat(src,span_notice(span_bold("Name:") + " [to_chat_choice] \n " + span_bold("Category:")  + " [trait_category[to_chat_choice]] \n " + span_bold("Description:")  + " [trait_desc[to_chat_choice]] \n \
			" + span_bold("Guide:")  + " \n [trait_tutorial[to_chat_choice]]"))


	else if(UI_choice == "TGUI")

		fancy_UI.set_vars(trait_names, trait_category, trait_desc, trait_tutorial)
		fancy_UI.tgui_interact(src)
