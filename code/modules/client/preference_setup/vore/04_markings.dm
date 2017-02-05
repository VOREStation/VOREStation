/datum/preferences
	var/r_hair_sec = 0					//Secondary hair color
	var/g_hair_sec = 0					//Secondary hair color
	var/b_hair_sec = 0					//Secondary hair color
	var/r_facial_sec = 0				//Secondary facial hair color
	var/g_facial_sec = 0				//Secondary facial hair color
	var/b_facial_sec = 0				//Secondary facial hair color
	var/r_headacc = 0					//Head accessory colour
	var/g_headacc = 0					//Head accessory colour
	var/b_headacc = 0					//Head accessory colour
	var/list/m_styles = list(
		"head" = "None",
		"body" = "None",
		"tail" = "None"
		)			//Marking styles.
	var/list/m_colours = list(
		"head" = "#000000",
		"body" = "#000000",
		"tail" = "#000000"
		)		//Marking colours.
	var/body_accessory = null
	var/speciesprefs = 0
	var/dress_mob = TRUE

/datum/category_item/player_setup_item/vore/markings
	name = "Markings"
	sort_order = 4

/datum/category_item/player_setup_item/vore/markings/load_character(var/savefile/S)
	S["secondary_hair_red"]			>> pref.secondary_hair_red
	S["secondary_hair_green"]		>> pref.secondary_hair_green
	S["secondary_hair_blue"]		>> pref.secondary_hair_blue
	S["secondary_facial_red"]		>> pref.secondary_facial_red
	S["secondary_facial_green"]		>> pref.secondary_facial_green
	S["secondary_facial_blue"]		>> pref.secondary_facial_blue
	S["marking_colours"]			>> pref.marking_colours
	S["head_accessory_red"]			>> pref.head_accessory_red
	S["head_accessory_green"]		>> pref.head_accessory_green
	S["head_accessory_blue"]		>> pref.head_accessory_blue
	S["marking_styles"]				>> pref.marking_styles
	S["head_accessory_style_name"]	>> pref.head_accessory_style_name
	S["body_accessory"]				>> pref.body_accessory

/datum/category_item/player_setup_item/vore/markings/save_character(var/savefile/S)
	S["secondary_hair_red"]			<< pref.secondary_hair_red
	S["secondary_hair_green"]		<< pref.secondary_hair_green
	S["secondary_hair_blue"]		<< pref.secondary_hair_blue
	S["secondary_facial_red"]		<< pref.secondary_facial_red
	S["secondary_facial_green"]		<< pref.secondary_facial_green
	S["secondary_facial_blue"]		<< pref.secondary_facial_blue
	S["marking_colours"]			<< pref.marking_colours
	S["head_accessory_red"]			<< pref.head_accessory_red
	S["head_accessory_green"]		<< pref.head_accessory_green
	S["head_accessory_blue"]		<< pref.head_accessory_blue
	S["marking_styles"]				<< pref.marking_styles
	S["head_accessory_style_name"]	<< pref.head_accessory_style_name
	S["body_accessory"]				<< pref.body_accessory

/datum/category_item/player_setup_item/vore/markings/sanitize_character()
	r_hair_sec		= sanitize_integer(r_hair_sec, 0, 255, initial(r_hair_sec))
	g_hair_sec		= sanitize_integer(g_hair_sec, 0, 255, initial(g_hair_sec))
	b_hair_sec		= sanitize_integer(b_hair_sec, 0, 255, initial(b_hair_sec))
	r_facial_sec	= sanitize_integer(r_facial_sec, 0, 255, initial(r_facial_sec))
	g_facial_sec	= sanitize_integer(g_facial_sec, 0, 255, initial(g_facial_sec))
	b_facial_sec	= sanitize_integer(b_facial_sec, 0, 255, initial(b_facial_sec))
	for(var/marking_location in m_colours)
		m_colours[marking_location] = sanitize_hexcolor(m_colours[marking_location], DEFAULT_MARKING_COLOURS[marking_location])
	r_headacc		= sanitize_integer(r_headacc, 0, 255, initial(r_headacc))
	g_headacc		= sanitize_integer(g_headacc, 0, 255, initial(g_headacc))
	b_headacc		= sanitize_integer(b_headacc, 0, 255, initial(b_headacc))
	h_style			= sanitize_inlist(h_style, hair_styles_list, initial(h_style))
	f_style			= sanitize_inlist(f_style, facial_hair_styles_list, initial(f_style))
	for(var/marking_location in m_styles)
		m_styles[marking_location] = sanitize_inlist(m_styles[marking_location], marking_styles_list, DEFAULT_MARKING_STYLES[marking_location])
	body_accessory	= sanitize_text(body_accessory, initial(body_accessory))

/datum/category_item/player_setup_item/vore/markings/copy_to_mob(var/mob/living/carbon/human/character)
	character.secondary_hair_red			= pref.secondary_hair_red
	character.secondary_hair_green			= pref.secondary_hair_green
	character.secondary_hair_blue			= pref.secondary_hair_blue
	character.secondary_facial_red			= pref.secondary_facial_red
	character.secondary_facial_green		= pref.secondary_facial_green
	character.secondary_facial_blue			= pref.secondary_facial_blue
	character.marking_colours				= pref.marking_colours
	character.head_accessory_red			= pref.head_accessory_red
	character.head_accessory_green			= pref.head_accessory_green
	character.head_accessory_blue			= pref.head_accessory_blue
	character.marking_styles				= pref.marking_styles
	character.head_accessory_style_name		= pref.head_accessory_style_name
	character.body_accessory				= pref.body_accessory

/datum/category_item/player_setup_item/vore/markings/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/vore/markings/content(var/mob/user)
	. = list()
	if(!pref.preview_icon)
		pref.update_preview_icon()
 	user << browse_rsc(pref.preview_icon, "previewicon.png")

 	var/mob_species = all_species[pref.species]

 	. += "<h2>Hair & Accessories</h2>"

		if(species in list("Unathi", "Vulpkanin", "Tajaran")) //Species that have head accessories.
			var/headaccessoryname = "Head Accessory: "
			if(species == "Unathi")
				headaccessoryname = "Horns: "
			. += "<b>[headaccessoryname]</b>"
			. += "<a href='?_src_=prefs;preference=ha_style;task=input'>[ha_style]</a> "
			. += "<a href='?_src_=prefs;preference=headaccessory;task=input'>Color</a> [color_square(r_headacc, g_headacc, b_headacc)]<br>"

		if(species in list("Tajaran", "Unathi", "Vulpkanin")) //Species with head markings.
			. += "<b>Head Markings:</b> "
			. += "<a href='?_src_=prefs;preference=m_style_head;task=input'>[m_styles["head"]]</a>"
			. += "<a href='?_src_=prefs;preference=m_head_colour;task=input'>Color</a> [color_square(color2R(m_colours["head"]), color2G(m_colours["head"]), color2B(m_colours["head"]))]<br>"
		if(species in list("Human", "Unathi", "Vulpkanin", "Tajaran", "Skrell")) //Species with body markings/tattoos.
			. += "<b>Body Markings:</b> "
			. += "<a href='?_src_=prefs;preference=m_style_body;task=input'>[m_styles["body"]]</a>"
			. += "<a href='?_src_=prefs;preference=m_body_colour;task=input'>Color</a> [color_square(color2R(m_colours["body"]), color2G(m_colours["body"]), color2B(m_colours["body"]))]<br>"
		if(species in list("Vulpkanin")) //Species with tail markings.
			. += "<b>Tail Markings:</b> "
			. += "<a href='?_src_=prefs;preference=m_style_tail;task=input'>[m_styles["tail"]]</a>"
			. += "<a href='?_src_=prefs;preference=m_tail_colour;task=input'>Color</a> [color_square(color2R(m_colours["tail"]), color2G(m_colours["tail"]), color2B(m_colours["tail"]))]<br>"

		. += "<b>Hair:</b> "
		. += "<a href='?_src_=prefs;preference=h_style;task=input'>[h_style]</a>"
		. += "<a href='?_src_=prefs;preference=hair;task=input'>Color</a> [color_square(r_hair, g_hair, b_hair)]"
		var/datum/sprite_accessory/temp_hair_style = hair_styles_list[h_style]
		if(temp_hair_style && temp_hair_style.secondary_theme && !temp_hair_style.no_sec_colour)
			. += " <a href='?_src_=prefs;preference=secondary_hair;task=input'>Color #2</a> [color_square(r_hair_sec, g_hair_sec, b_hair_sec)]"
		. += "<br>"

		. += "<b>Facial Hair:</b> "
		. += "<a href='?_src_=prefs;preference=f_style;task=input'>[f_style ? "[f_style]" : "Shaved"]</a>"
		. += "<a href='?_src_=prefs;preference=facial;task=input'>Color</a> [color_square(r_facial, g_facial, b_facial)]"
		var/datum/sprite_accessory/temp_facial_hair_style = facial_hair_styles_list[f_style]
		if(temp_facial_hair_style && temp_facial_hair_style.secondary_theme && !temp_facial_hair_style.no_sec_colour)
			. += " <a href='?_src_=prefs;preference=secondary_facial;task=input'>Color #2</a> [color_square(r_facial_sec, g_facial_sec, b_facial_sec)]"
		. += "<br>"

		. += "<b>Eyes:</b> "
		. += "<a href='?_src_=prefs;preference=eyes;task=input'>Color</a> [color_square(r_eyes, g_eyes, b_eyes)]<br>"

		if((species in list("Unathi", "Tajaran", "Skrell", "Vulpkanin")) || body_accessory_by_species[species] || check_rights(R_ADMIN, 0, user)) //admins can always fuck with this, because they are admins
			. += "<b>Body Color:</b> "
			. += "<a href='?_src_=prefs;preference=skin;task=input'>Color</a> [color_square(r_skin, g_skin, b_skin)]<br>"

		if(body_accessory_by_species[species] || check_rights(R_ADMIN, 0, user))
			. += "<b>Body Accessory:</b> "
			. += "<a href='?_src_=prefs;preference=body_accessory;task=input'>[body_accessory ? "[body_accessory]" : "None"]</a><br>"

/datum/category_item/player_setup_item/vore/markings/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = all_species[pref.species]
		if("hair")
			if(species in list("Human", "Unathi", "Tajaran", "Skrell", "Vulpkanin"))
				r_hair = rand(0,255)
				g_hair = rand(0,255)
				b_hair = rand(0,255)
		if("secondary_hair")
			if(species in list("Human", "Unathi", "Tajaran", "Skrell", "Vulpkanin"))
				r_hair_sec = rand(0,255)
				g_hair_sec = rand(0,255)
				b_hair_sec = rand(0,255)
		if("h_style")
			h_style = random_hair_style(gender, species, robohead)
		if("facial")
			if(species in list("Human", "Unathi", "Tajaran", "Skrell", "Vulpkanin"))
				r_facial = rand(0,255)
				g_facial = rand(0,255)
				b_facial = rand(0,255)
		if("secondary_facial")
			if(species in list("Human", "Unathi", "Tajaran", "Skrell", "Vulpkanin"))
				r_facial_sec = rand(0,255)
				g_facial_sec = rand(0,255)
				b_facial_sec = rand(0,255)
		if("f_style")
			f_style = random_facial_hair_style(gender, species, robohead)
		if("headaccessory")
			if(species in list("Unathi", "Vulpkanin", "Tajaran")) //Species that have head accessories.
				r_headacc = rand(0,255)
				g_headacc = rand(0,255)
				b_headacc = rand(0,255)
		if("ha_style")
			if(species in list("Unathi", "Vulpkanin", "Tajaran")) //Species that have head accessories.
				ha_style = random_head_accessory(species)
		if("m_style_head")
			if(species in list("Tajaran", "Unathi", "Vulpkanin")) //Species with head markings.
				m_styles["head"] = random_marking_style("head", species, robohead, null, alt_head)
		if("m_head_colour")
			if(species in list("Tajaran", "Unathi", "Vulpkanin")) //Species with head markings.
				m_colours["head"] = rgb(rand(0,255), rand(0,255), rand(0,255))
		if("m_style_body")
			if(species in list("Human", "Unathi", "Vulpkanin", "Tajaran", "Skrell")) //Species with body markings.
				m_styles["body"] = random_marking_style("body", species)
		if("m_body_colour")
			if(species in list("Human", "Unathi", "Vulpkanin", "Tajaran", "Skrell")) //Species with body markings.
				m_colours["body"] = rgb(rand(0,255), rand(0,255), rand(0,255))
		if("m_style_tail")
			if(species in list("Vulpkanin")) //Species with tail markings.
				m_styles["tail"] = random_marking_style("tail", species, null, body_accessory)
		if("m_tail_colour")
			if(species in list("Vulpkanin")) //Species with tail markings.
				m_colours["tail"] = rgb(rand(0,255), rand(0,255), rand(0,255))

/datum/category_item/player_setup_item/vore/markings/content(var/mob/user)
	. += "<h2>VORE Station Settings</h2>"
	if(!user || !user.client)
		return
	update_preview_icon()
	user << browse_rsc(preview_icon_front, "previewicon.png")
	user << browse_rsc(preview_icon_side, "previewicon2.png")

	var/. = ""
	. += "<center>"
	. += "<a href='?_src_=prefs;preference=tab;tab=[TAB_CHAR]' [current_tab == TAB_CHAR ? "class='linkOn'" : ""]>Character Settings</a>"