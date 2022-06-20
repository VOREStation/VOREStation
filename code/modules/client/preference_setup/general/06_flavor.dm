/datum/category_item/player_setup_item/general/flavor
	name = "Flavor"
	sort_order = 6

/datum/category_item/player_setup_item/general/flavor/load_character(var/savefile/S)
	S["flavor_texts_general"]	>> pref.flavor_texts["general"]
	S["flavor_texts_head"]		>> pref.flavor_texts["head"]
	S["flavor_texts_face"]		>> pref.flavor_texts["face"]
	S["flavor_texts_eyes"]		>> pref.flavor_texts["eyes"]
	S["flavor_texts_torso"]		>> pref.flavor_texts["torso"]
	S["flavor_texts_arms"]		>> pref.flavor_texts["arms"]
	S["flavor_texts_hands"]		>> pref.flavor_texts["hands"]
	S["flavor_texts_legs"]		>> pref.flavor_texts["legs"]
	S["flavor_texts_feet"]		>> pref.flavor_texts["feet"]

	//Flavour text for robots.
	S["flavour_texts_robot_Default"] >> pref.flavour_texts_robot["Default"]
	for(var/module in robot_module_types)
		S["flavour_texts_robot_[module]"] >> pref.flavour_texts_robot[module]

/datum/category_item/player_setup_item/general/flavor/save_character(var/savefile/S)
	S["flavor_texts_general"]	<< pref.flavor_texts["general"]
	S["flavor_texts_head"]		<< pref.flavor_texts["head"]
	S["flavor_texts_face"]		<< pref.flavor_texts["face"]
	S["flavor_texts_eyes"]		<< pref.flavor_texts["eyes"]
	S["flavor_texts_torso"]		<< pref.flavor_texts["torso"]
	S["flavor_texts_arms"]		<< pref.flavor_texts["arms"]
	S["flavor_texts_hands"]		<< pref.flavor_texts["hands"]
	S["flavor_texts_legs"]		<< pref.flavor_texts["legs"]
	S["flavor_texts_feet"]		<< pref.flavor_texts["feet"]

	S["flavour_texts_robot_Default"] << pref.flavour_texts_robot["Default"]
	for(var/module in robot_module_types)
		S["flavour_texts_robot_[module]"] << pref.flavour_texts_robot[module]

/datum/category_item/player_setup_item/general/flavor/sanitize_character()
	return

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/flavor/copy_to_mob(var/mob/living/carbon/human/character)
	character.flavor_texts["general"]	= pref.flavor_texts["general"]
	character.flavor_texts["head"]		= pref.flavor_texts["head"]
	character.flavor_texts["face"]		= pref.flavor_texts["face"]
	character.flavor_texts["eyes"]		= pref.flavor_texts["eyes"]
	character.flavor_texts["torso"]		= pref.flavor_texts["torso"]
	character.flavor_texts["arms"]		= pref.flavor_texts["arms"]
	character.flavor_texts["hands"]		= pref.flavor_texts["hands"]
	character.flavor_texts["legs"]		= pref.flavor_texts["legs"]
	character.flavor_texts["feet"]		= pref.flavor_texts["feet"]
	character.ooc_notes 				= pref.metadata //VOREStation Add

/datum/category_item/player_setup_item/general/flavor/content(var/mob/user)
	. += "<b>Flavor:</b><br>"
	. += "<a href='?src=\ref[src];flavor_text=open'>Set Flavor Text</a><br/>"
	. += "<a href='?src=\ref[src];flavour_text_robot=open'>Set Robot Flavor Text</a><br/>"

/datum/category_item/player_setup_item/general/flavor/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["flavor_text"])
		switch(href_list["flavor_text"])
			if("open")
			if("general")
				var/msg = sanitize(tgui_input_text(usr,"Give a general description of your character. This will be shown regardless of clothings.","Flavor Text",html_decode(pref.flavor_texts[href_list["flavor_text"]]), multiline = TRUE, prevent_enter = TRUE), extra = 0)	//VOREStation Edit: separating out OOC notes
				if(CanUseTopic(user))
					pref.flavor_texts[href_list["flavor_text"]] = msg
			else
				var/msg = sanitize(tgui_input_text(usr,"Set the flavor text for your [href_list["flavor_text"]].","Flavor Text",html_decode(pref.flavor_texts[href_list["flavor_text"]]), multiline = TRUE, prevent_enter = TRUE), extra = 0)
				if(CanUseTopic(user))
					pref.flavor_texts[href_list["flavor_text"]] = msg
		SetFlavorText(user)
		return TOPIC_HANDLED

	else if(href_list["flavour_text_robot"])
		switch(href_list["flavour_text_robot"])
			if("open")
			if("Default")
				var/msg = sanitize(tgui_input_text(usr,"Set the default flavour text for your robot. It will be used for any module without individual setting.","Flavour Text",html_decode(pref.flavour_texts_robot["Default"]), multiline = TRUE, prevent_enter = TRUE), extra = 0)
				if(CanUseTopic(user))
					pref.flavour_texts_robot[href_list["flavour_text_robot"]] = msg
			else
				var/msg = sanitize(tgui_input_text(usr,"Set the flavour text for your robot with [href_list["flavour_text_robot"]] module. If you leave this empty, default flavour text will be used for this module.","Flavour Text",html_decode(pref.flavour_texts_robot[href_list["flavour_text_robot"]]), multiline = TRUE, prevent_enter = TRUE), extra = 0)
				if(CanUseTopic(user))
					pref.flavour_texts_robot[href_list["flavour_text_robot"]] = msg
		SetFlavourTextRobot(user)
		return TOPIC_HANDLED

	return ..()

/datum/category_item/player_setup_item/general/flavor/proc/SetFlavorText(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Flavor Text</b> <hr />"
	HTML += "Note: This is not *literal* flavor of your character. This is visual description of what they look like. <hr />"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref[src];flavor_text=general'>General:</a> "
	HTML += TextPreview(pref.flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=head'>Head:</a> "
	HTML += TextPreview(pref.flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=face'>Face:</a> "
	HTML += TextPreview(pref.flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=eyes'>Eyes:</a> "
	HTML += TextPreview(pref.flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=torso'>Body:</a> "
	HTML += TextPreview(pref.flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=arms'>Arms:</a> "
	HTML += TextPreview(pref.flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=hands'>Hands:</a> "
	HTML += TextPreview(pref.flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=legs'>Legs:</a> "
	HTML += TextPreview(pref.flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=feet'>Feet:</a> "
	HTML += TextPreview(pref.flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavor_text;size=430x300")
	return

/datum/category_item/player_setup_item/general/flavor/proc/SetFlavourTextRobot(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Robot Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref[src];flavour_text_robot=Default'>Default:</a> "
	HTML += TextPreview(pref.flavour_texts_robot["Default"])
	HTML += "<hr />"
	for(var/module in robot_module_types)
		HTML += "<a href='?src=\ref[src];flavour_text_robot=[module]'>[module]:</a> "
		HTML += TextPreview(pref.flavour_texts_robot[module])
		HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavour_text_robot;size=430x300")
	return
