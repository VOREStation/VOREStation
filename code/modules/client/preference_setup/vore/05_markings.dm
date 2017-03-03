
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

/datum/preferences/
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

/datum/category_item/player_setup_item/vore/markings
	name = "Markings"
	sort_order = 5

/datum/category_item/player_setup_item/vore/markings/load_character(var/savefile/S)
	S["marking_colours"]			>> pref.marking_colours
	S["head_accessory_red"]			>> pref.head_accessory_red
	S["head_accessory_green"]		>> pref.head_accessory_green
	S["head_accessory_blue"]		>> pref.head_accessory_blue
	S["marking_styles"]				>> pref.marking_styles
	S["head_accessory_style_name"]	>> pref.head_accessory_style_name
	S["body_accessory"]				>> pref.body_accessory

/datum/category_item/player_setup_item/vore/markings/save_character(var/savefile/S)
	S["marking_colours"]			<< pref.marking_colours
	S["head_accessory_red"]			<< pref.head_accessory_red
	S["head_accessory_green"]		<< pref.head_accessory_green
	S["head_accessory_blue"]		<< pref.head_accessory_blue
	S["marking_styles"]				<< pref.marking_styles
	S["head_accessory_style_name"]	<< pref.head_accessory_style_name
	S["body_accessory"]				<< pref.body_accessory

/datum/category_item/player_setup_item/vore/markings/sanitize_character()
	for(var/marking_location in pref.m_colours)
		pref.m_colours[marking_location] = sanitize_hexcolor(pref.m_colours[marking_location], DEFAULT_MARKING_COLOURS[pref.marking_location])
	pref.r_headacc		= sanitize_integer(pref.r_headacc, 0, 255, initial(pref.r_headacc))
	pref.g_headacc		= sanitize_integer(pref.g_headacc, 0, 255, initial(pref.g_headacc))
	pref.b_headacc		= sanitize_integer(pref.b_headacc, 0, 255, initial(pref.b_headacc))
	pref.h_style			= sanitize_inlist(pref.h_style, hair_styles_list, initial(pref.h_style))
	pref.f_style			= sanitize_inlist(pref.f_style, facial_hair_styles_list, initial(pref.f_style))
	for(var/marking_location in m_styles)
		pref.m_styles[marking_location] = sanitize_inlist(pref.m_styles[marking_location], marking_styles_list, DEFAULT_MARKING_STYLES[pref.marking_location])
	pref.body_accessory	= sanitize_text(body_accessory, initial(pref.body_accessory))

/datum/category_item/player_setup_item/vore/markings/copy_to_mob(var/mob/living/carbon/human/character)
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

 	var/mob_species = all_species[pref.species]

 	. += "<h2>Hair & Accessories</h2>"

		if(mob_species.appearance_flags && HAS_HEAD_ACCESSORY) //Species that have head accessories.
			. += "<b>Head Accessories:</b> "
			. += "<a href='?_src_=prefs;preference=ha_style;task=input'>[pref.ha_style]</a> "
			. += "<a href='?_src_=prefs;preference=headaccessory;task=input'>Color</a> [color_square(pref.r_headacc, pref.g_headacc, pref.b_headacc)]<br>"

		if(mob_species.appearance_flags && HAS_HEAD_MARKINGS) //Species with head markings.
			. += "<b>Head Markings:</b> "
			. += "<a href='?_src_=prefs;preference=m_style_head;task=input'>[pref.m_styles["head"]]</a>"
			. += "<a href='?_src_=prefs;preference=m_head_colour;task=input'>Color</a> [color_square(color2R(m_colours["head"]), color2G(m_colours["head"]), color2B(m_colours["head"]))]<br>"
		if(mob_species.appearance_flags && HAS_BODY_MARKINGS) //Species with body markings/tattoos.
			. += "<b>Body Markings:</b> "
			. += "<a href='?_src_=prefs;preference=m_style_body;task=input'>[pref.m_styles["body"]]</a>"
			. += "<a href='?_src_=prefs;preference=m_body_colour;task=input'>Color</a> [color_square(color2R(m_colours["body"]), color2G(m_colours["body"]), color2B(m_colours["body"]))]<br>"
		if(mob_species.appearance_flags && HAS_TAIL_MARKINGS) //Species with tail markings.
			. += "<b>Tail Markings:</b> "
			. += "<a href='?_src_=prefs;preference=m_style_tail;task=input'>[pref.m_styles["tail"]]</a>"
			. += "<a href='?_src_=prefs;preference=m_tail_colour;task=input'>Color</a> [color_square(color2R(m_colours["tail"]), color2G(m_colours["tail"]), color2B(m_colours["tail"]))]<br>"

		if((mob_species.appearance_flags && HAS_BODY_ACCESSORY) || body_accessory_by_species[pref.species] || check_rights(R_ADMIN, 0, user)) //admins can always fuck with this, because they are admins
			. += "<b>Body Color:</b> "
			. += "<a href='?_src_=prefs;preference=skin;task=input'>Color</a> [color_square(r_skin, g_skin, b_skin)]<br>"

/*		if(body_accessory_by_species[species] || check_rights(R_ADMIN, 0, user))
			. += "<b>Body Accessory:</b> "
			. += "<a href='?_src_=prefs;preference=body_accessory;task=input'>[body_accessory ? "[body_accessory]" : "None"]</a><br>"
*/
/datum/category_item/player_setup_item/vore/markings/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(!CanUseTopic(user))
		return TOPIC_NOACTION

		if("headaccessory")
			if(mob_species.appearance_flags && HAS_HEAD_ACCESSORY) //Species that have head accessories.
				pref.r_headacc = rand(0,255)
				pref.g_headacc = rand(0,255)
				pref.b_headacc = rand(0,255)
		if("ha_style")
			if(mob_species.appearance_flags && HAS_HEAD_ACCESSORY) //Species that have head accessories.
				pref.ha_style = random_head_accessory(species)
		if("m_style_head")
			if(mob_species.appearance_flags && HAS_HEAD_MARKINGS) //Species with head markings.
				pref.m_styles["head"] = random_marking_style("head", species, null)
		if("m_head_colour")
			if(mob_species.appearance_flags && HAS_HEAD_MARKINGS) //Species with head markings.
				pref.m_colours["head"] = rgb(rand(0,255), rand(0,255), rand(0,255))
		if("m_style_body")
			if(mob_species.appearance_flags && HAS_BODY_MARKINGS) //Species with body markings.
				pref.m_styles["body"] = random_marking_style("body", species)
		if("m_body_colour")
			if(mob_species.appearance_flags && HAS_BODY_MARKINGS) //Species with body markings.
				pref.m_colours["body"] = rgb(rand(0,255), rand(0,255), rand(0,255))
		if("m_style_tail")
			if(mob_species.appearance_flags && HAS_TAIL_MARKINGS) //Species with tail markings.
				pref.m_styles["tail"] = random_marking_style("tail", species, null, body_accessory)
		if("m_tail_colour")
			if(mob_species.appearance_flags && HAS_TAIL_MARKINGS) //Species with tail markings.
				pref.m_colours["tail"] = rgb(rand(0,255), rand(0,255), rand(0,255))
