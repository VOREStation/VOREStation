var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "midgrey", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

	var/ear_style		// Type of selected ear style
	var/r_ears = 30		// Ear color.
	var/g_ears = 30		// Ear color
	var/b_ears = 30		// Ear color
	var/r_ears2 = 30	// Ear extra color.
	var/g_ears2 = 30	// Ear extra color
	var/b_ears2 = 30	// Ear extra color
	var/r_ears3 = 30	// Ear tertiary color.
	var/g_ears3 = 30	// Ear tertiary color
	var/b_ears3 = 30	// Ear tertiary color
	var/tail_style		// Type of selected tail style
	var/r_tail = 30		// Tail/Taur color
	var/g_tail = 30		// Tail/Taur color
	var/b_tail = 30		// Tail/Taur color
	var/r_tail2 = 30 	// For extra overlay.
	var/g_tail2 = 30	// For extra overlay.
	var/b_tail2 = 30	// For extra overlay.
	var/r_tail3 = 30 	// For tertiary overlay.
	var/g_tail3 = 30	// For tertiary overlay.
	var/b_tail3 = 30	// For tertiary overlay.
	var/wing_style		// Type of selected wing style
	var/r_wing = 30		// Wing color
	var/g_wing = 30		// Wing color
	var/b_wing = 30		// Wing color
	var/r_wing2 = 30	// Wing extra color
	var/g_wing2 = 30	// Wing extra color
	var/b_wing2 = 30	// Wing extra color
	var/r_wing3 = 30	// Wing tertiary color
	var/g_wing3 = 30	// Wing tertiary color
	var/b_wing3 = 30	// Wing tertiary color

// Sanitize ear/wing/tail styles
/datum/preferences/proc/sanitize_body_styles()

	// Grandfather in anyone loading paths from a save.
	if(ispath(ear_style, /datum/sprite_accessory))
		var/datum/sprite_accessory/instance = global.ear_styles_list[ear_style]
		if(istype(instance))
			ear_style = instance.name
	if(ispath(wing_style, /datum/sprite_accessory))
		var/datum/sprite_accessory/instance = global.wing_styles_list[wing_style]
		if(istype(instance))
			wing_style = instance.name
	if(ispath(tail_style, /datum/sprite_accessory))
		var/datum/sprite_accessory/instance = global.tail_styles_list[tail_style]
		if(istype(instance))
			tail_style = instance.name

	// Sanitize for non-existent keys.
	if(ear_style && !(ear_style in get_available_styles(global.ear_styles_list)))
		ear_style = null
	if(wing_style && !(wing_style in get_available_styles(global.wing_styles_list)))
		wing_style = null
	if(tail_style && !(tail_style in get_available_styles(global.tail_styles_list)))
		tail_style = null

/datum/preferences/proc/get_available_styles(var/style_list)
	. = list("Normal" = null)
	for(var/path in style_list)
		var/datum/sprite_accessory/instance = style_list[path]
		if(!istype(instance))
			continue
		if(instance.ckeys_allowed && (!client || !(client.ckey in instance.ckeys_allowed)))
			continue
		if(instance.species_allowed && (!species || !(species in instance.species_allowed)) && (!client || !check_rights(R_ADMIN | R_EVENT | R_FUN, 0, client)) && (!custom_base || !(custom_base in instance.species_allowed))) //VOREStation Edit: Custom Species
			continue
		.[instance.name] = instance

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 3

/datum/category_item/player_setup_item/general/body/load_character(var/savefile/S)
	S["species"]			>> pref.species
	S["hair_red"]			>> pref.r_hair
	S["hair_green"]			>> pref.g_hair
	S["hair_blue"]			>> pref.b_hair
	S["facial_red"]			>> pref.r_facial
	S["grad_red"]			>> pref.r_grad
	S["grad_green"]			>> pref.g_grad
	S["grad_blue"]			>> pref.b_grad
	S["facial_green"]		>> pref.g_facial
	S["facial_blue"]		>> pref.b_facial
	S["skin_tone"]			>> pref.s_tone
	S["skin_red"]			>> pref.r_skin
	S["skin_green"]			>> pref.g_skin
	S["skin_blue"]			>> pref.b_skin
	S["hair_style_name"]	>> pref.h_style
	S["facial_style_name"]	>> pref.f_style
	S["grad_style_name"]	>> pref.grad_style
	S["eyes_red"]			>> pref.r_eyes
	S["eyes_green"]			>> pref.g_eyes
	S["eyes_blue"]			>> pref.b_eyes
	S["b_type"]				>> pref.b_type
	S["disabilities"]		>> pref.disabilities
	S["organ_data"]			>> pref.organ_data
	S["rlimb_data"]			>> pref.rlimb_data
	S["body_markings"]		>> pref.body_markings
	S["synth_color"]		>> pref.synth_color
	S["synth_red"]			>> pref.r_synth
	S["synth_green"]		>> pref.g_synth
	S["synth_blue"]			>> pref.b_synth
	S["synth_markings"]		>> pref.synth_markings
	S["bgstate"]			>> pref.bgstate
	S["body_descriptors"]	>> pref.body_descriptors
	S["ear_style"]		>> pref.ear_style
	S["r_ears"]			>> pref.r_ears
	S["g_ears"]			>> pref.g_ears
	S["b_ears"]			>> pref.b_ears
	S["r_ears2"]		>> pref.r_ears2
	S["g_ears2"]		>> pref.g_ears2
	S["b_ears2"]		>> pref.b_ears2
	S["r_ears3"]		>> pref.r_ears3
	S["g_ears3"]		>> pref.g_ears3
	S["b_ears3"]		>> pref.b_ears3
	S["tail_style"]		>> pref.tail_style
	S["r_tail"]			>> pref.r_tail
	S["g_tail"]			>> pref.g_tail
	S["b_tail"]			>> pref.b_tail
	S["r_tail2"]		>> pref.r_tail2
	S["g_tail2"]		>> pref.g_tail2
	S["b_tail2"]		>> pref.b_tail2
	S["r_tail3"]		>> pref.r_tail3
	S["g_tail3"]		>> pref.g_tail3
	S["b_tail3"]		>> pref.b_tail3
	S["wing_style"]		>> pref.wing_style
	S["r_wing"]			>> pref.r_wing
	S["g_wing"]			>> pref.g_wing
	S["b_wing"]			>> pref.b_wing
	S["r_wing2"]		>> pref.r_wing2
	S["g_wing2"]		>> pref.g_wing2
	S["b_wing2"]		>> pref.b_wing2
	S["r_wing3"]		>> pref.r_wing3
	S["g_wing3"]		>> pref.g_wing3
	S["b_wing3"]		>> pref.b_wing3

/datum/category_item/player_setup_item/general/body/save_character(var/savefile/S)
	S["species"]			<< pref.species
	S["hair_red"]			<< pref.r_hair
	S["hair_green"]			<< pref.g_hair
	S["hair_blue"]			<< pref.b_hair
	S["grad_red"]			<< pref.r_grad
	S["grad_green"]			<< pref.g_grad
	S["grad_blue"]			<< pref.b_grad
	S["facial_red"]			<< pref.r_facial
	S["facial_green"]		<< pref.g_facial
	S["facial_blue"]		<< pref.b_facial
	S["skin_tone"]			<< pref.s_tone
	S["skin_red"]			<< pref.r_skin
	S["skin_green"]			<< pref.g_skin
	S["skin_blue"]			<< pref.b_skin
	S["hair_style_name"]	<< pref.h_style
	S["facial_style_name"]	<< pref.f_style
	S["grad_style_name"]	<< pref.grad_style
	S["eyes_red"]			<< pref.r_eyes
	S["eyes_green"]			<< pref.g_eyes
	S["eyes_blue"]			<< pref.b_eyes
	S["b_type"]				<< pref.b_type
	S["disabilities"]		<< pref.disabilities
	S["organ_data"]			<< pref.organ_data
	S["rlimb_data"]			<< pref.rlimb_data
	S["body_markings"]		<< pref.body_markings
	S["synth_color"]		<< pref.synth_color
	S["synth_red"]			<< pref.r_synth
	S["synth_green"]		<< pref.g_synth
	S["synth_blue"]			<< pref.b_synth
	S["synth_markings"]		<< pref.synth_markings
	S["bgstate"]			<< pref.bgstate
	S["body_descriptors"]	<< pref.body_descriptors
	S["ear_style"]		<< pref.ear_style
	S["r_ears"]			<< pref.r_ears
	S["g_ears"]			<< pref.g_ears
	S["b_ears"]			<< pref.b_ears
	S["r_ears2"]		<< pref.r_ears2
	S["g_ears2"]		<< pref.g_ears2
	S["b_ears2"]		<< pref.b_ears2
	S["r_ears3"]		<< pref.r_ears3
	S["g_ears3"]		<< pref.g_ears3
	S["b_ears3"]		<< pref.b_ears3
	S["tail_style"]		<< pref.tail_style
	S["r_tail"]			<< pref.r_tail
	S["g_tail"]			<< pref.g_tail
	S["b_tail"]			<< pref.b_tail
	S["r_tail2"]		<< pref.r_tail2
	S["g_tail2"]		<< pref.g_tail2
	S["b_tail2"]		<< pref.b_tail2
	S["r_tail3"]		<< pref.r_tail3
	S["g_tail3"]		<< pref.g_tail3
	S["b_tail3"]		<< pref.b_tail3
	S["wing_style"]		<< pref.wing_style
	S["r_wing"]			<< pref.r_wing
	S["g_wing"]			<< pref.g_wing
	S["b_wing"]			<< pref.b_wing
	S["r_wing2"]		<< pref.r_wing2
	S["g_wing2"]		<< pref.g_wing2
	S["b_wing2"]		<< pref.b_wing2
	S["r_wing3"]		<< pref.r_wing3
	S["g_wing3"]		<< pref.g_wing3
	S["b_wing3"]		<< pref.b_wing3

/datum/category_item/player_setup_item/general/body/sanitize_character(var/savefile/S)
	if(!pref.species || !(pref.species in GLOB.playable_species))
		pref.species = SPECIES_HUMAN
	pref.r_hair			= sanitize_integer(pref.r_hair, 0, 255, initial(pref.r_hair))
	pref.g_hair			= sanitize_integer(pref.g_hair, 0, 255, initial(pref.g_hair))
	pref.b_hair			= sanitize_integer(pref.b_hair, 0, 255, initial(pref.b_hair))
	pref.r_grad			= sanitize_integer(pref.r_grad, 0, 255, initial(pref.r_grad))
	pref.g_grad			= sanitize_integer(pref.g_grad, 0, 255, initial(pref.g_grad))
	pref.b_grad			= sanitize_integer(pref.b_grad, 0, 255, initial(pref.b_grad))
	pref.r_facial		= sanitize_integer(pref.r_facial, 0, 255, initial(pref.r_facial))
	pref.g_facial		= sanitize_integer(pref.g_facial, 0, 255, initial(pref.g_facial))
	pref.b_facial		= sanitize_integer(pref.b_facial, 0, 255, initial(pref.b_facial))
	pref.s_tone			= sanitize_integer(pref.s_tone, -185, 34, initial(pref.s_tone))
	pref.r_skin			= sanitize_integer(pref.r_skin, 0, 255, initial(pref.r_skin))
	pref.g_skin			= sanitize_integer(pref.g_skin, 0, 255, initial(pref.g_skin))
	pref.b_skin			= sanitize_integer(pref.b_skin, 0, 255, initial(pref.b_skin))
	pref.h_style		= sanitize_inlist(pref.h_style, hair_styles_list, initial(pref.h_style))
	pref.f_style		= sanitize_inlist(pref.f_style, facial_hair_styles_list, initial(pref.f_style))
	pref.grad_style		= sanitize_inlist(pref.grad_style, GLOB.hair_gradients, initial(pref.grad_style))
	pref.r_eyes			= sanitize_integer(pref.r_eyes, 0, 255, initial(pref.r_eyes))
	pref.g_eyes			= sanitize_integer(pref.g_eyes, 0, 255, initial(pref.g_eyes))
	pref.b_eyes			= sanitize_integer(pref.b_eyes, 0, 255, initial(pref.b_eyes))
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))

	pref.disabilities	= sanitize_integer(pref.disabilities, 0, 65535, initial(pref.disabilities))
	if(!pref.organ_data) pref.organ_data = list()
	if(!pref.rlimb_data) pref.rlimb_data = list()
	if(!pref.body_markings) pref.body_markings = list()
	else pref.body_markings &= body_marking_styles_list
	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

	pref.r_ears		= sanitize_integer(pref.r_ears, 0, 255, initial(pref.r_ears))
	pref.g_ears		= sanitize_integer(pref.g_ears, 0, 255, initial(pref.g_ears))
	pref.b_ears		= sanitize_integer(pref.b_ears, 0, 255, initial(pref.b_ears))
	pref.r_ears2	= sanitize_integer(pref.r_ears2, 0, 255, initial(pref.r_ears2))
	pref.g_ears2	= sanitize_integer(pref.g_ears2, 0, 255, initial(pref.g_ears2))
	pref.b_ears2	= sanitize_integer(pref.b_ears2, 0, 255, initial(pref.b_ears2))
	pref.r_ears3	= sanitize_integer(pref.r_ears3, 0, 255, initial(pref.r_ears3))
	pref.g_ears3	= sanitize_integer(pref.g_ears3, 0, 255, initial(pref.g_ears3))
	pref.b_ears3	= sanitize_integer(pref.b_ears3, 0, 255, initial(pref.b_ears3))
	pref.r_tail		= sanitize_integer(pref.r_tail, 0, 255, initial(pref.r_tail))
	pref.g_tail		= sanitize_integer(pref.g_tail, 0, 255, initial(pref.g_tail))
	pref.b_tail		= sanitize_integer(pref.b_tail, 0, 255, initial(pref.b_tail))
	pref.r_tail2	= sanitize_integer(pref.r_tail2, 0, 255, initial(pref.r_tail2))
	pref.g_tail2	= sanitize_integer(pref.g_tail2, 0, 255, initial(pref.g_tail2))
	pref.b_tail2	= sanitize_integer(pref.b_tail2, 0, 255, initial(pref.b_tail2))
	pref.r_tail3	= sanitize_integer(pref.r_tail3, 0, 255, initial(pref.r_tail3))
	pref.g_tail3	= sanitize_integer(pref.g_tail3, 0, 255, initial(pref.g_tail3))
	pref.b_tail3	= sanitize_integer(pref.b_tail3, 0, 255, initial(pref.b_tail3))
	pref.r_wing		= sanitize_integer(pref.r_wing, 0, 255, initial(pref.r_wing))
	pref.g_wing		= sanitize_integer(pref.g_wing, 0, 255, initial(pref.g_wing))
	pref.b_wing		= sanitize_integer(pref.b_wing, 0, 255, initial(pref.b_wing))
	pref.r_wing2	= sanitize_integer(pref.r_wing2, 0, 255, initial(pref.r_wing2))
	pref.g_wing2	= sanitize_integer(pref.g_wing2, 0, 255, initial(pref.g_wing2))
	pref.b_wing2	= sanitize_integer(pref.b_wing2, 0, 255, initial(pref.b_wing2))
	pref.r_wing3	= sanitize_integer(pref.r_wing3, 0, 255, initial(pref.r_wing3))
	pref.g_wing3	= sanitize_integer(pref.g_wing3, 0, 255, initial(pref.g_wing3))
	pref.b_wing3	= sanitize_integer(pref.b_wing3, 0, 255, initial(pref.b_wing3))

	pref.sanitize_body_styles()

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/body/copy_to_mob(var/mob/living/carbon/human/character)
	// Copy basic values
	character.r_eyes	= pref.r_eyes
	character.g_eyes	= pref.g_eyes
	character.b_eyes	= pref.b_eyes
	character.h_style	= pref.h_style
	character.r_hair	= pref.r_hair
	character.g_hair	= pref.g_hair
	character.b_hair	= pref.b_hair
	character.r_grad	= pref.r_grad
	character.g_grad	= pref.g_grad
	character.b_grad	= pref.b_grad
	character.f_style	= pref.f_style
	character.r_facial	= pref.r_facial
	character.g_facial	= pref.g_facial
	character.b_facial	= pref.b_facial
	character.r_skin	= pref.r_skin
	character.g_skin	= pref.g_skin
	character.b_skin	= pref.b_skin
	character.s_tone	= pref.s_tone
	character.h_style	= pref.h_style
	character.f_style	= pref.f_style
	character.grad_style= pref.grad_style
	character.b_type	= pref.b_type
	character.synth_color = pref.synth_color
	character.r_synth	= pref.r_synth
	character.g_synth	= pref.g_synth
	character.b_synth	= pref.b_synth
	character.synth_markings = pref.synth_markings

	var/list/ear_styles = pref.get_available_styles(global.ear_styles_list)
	character.ear_style =  ear_styles[pref.ear_style]
	character.r_ears =     pref.r_ears
	character.b_ears =     pref.b_ears
	character.g_ears =     pref.g_ears
	character.r_ears2 =    pref.r_ears2
	character.b_ears2 =    pref.b_ears2
	character.g_ears2 =    pref.g_ears2
	character.r_ears3 =    pref.r_ears3
	character.b_ears3 =    pref.b_ears3
	character.g_ears3 =    pref.g_ears3

	var/list/tail_styles = pref.get_available_styles(global.tail_styles_list)
	character.tail_style = tail_styles[pref.tail_style]
	character.r_tail =     pref.r_tail
	character.b_tail =     pref.b_tail
	character.g_tail =     pref.g_tail
	character.r_tail2 =    pref.r_tail2
	character.b_tail2 =    pref.b_tail2
	character.g_tail2 =    pref.g_tail2
	character.r_tail3 =    pref.r_tail3
	character.b_tail3 =    pref.b_tail3
	character.g_tail3 =    pref.g_tail3

	var/list/wing_styles = pref.get_available_styles(global.wing_styles_list)
	character.wing_style = wing_styles[pref.wing_style]
	character.r_wing =     pref.r_wing
	character.b_wing =     pref.b_wing
	character.g_wing =     pref.g_wing
	character.r_wing2 =    pref.r_wing2
	character.b_wing2 =    pref.b_wing2
	character.g_wing2 =    pref.g_wing2
	character.r_wing3 =    pref.r_wing3
	character.b_wing3 =    pref.b_wing3
	character.g_wing3 =    pref.g_wing3

	character.set_gender(pref.biological_gender)

	// Destroy/cyborgize organs and limbs.
	character.synthetic = null //Clear the existing var.
	for(var/name in list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO))
		var/status = pref.organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(O)
			if(status == "amputated")
				O.remove_rejuv()
			else if(status == "cyborg")
				if(pref.rlimb_data[name])
					O.robotize(pref.rlimb_data[name])
				else
					O.robotize()

	for(var/name in list(O_HEART,O_EYES,O_VOICE,O_LUNGS,O_LIVER,O_KIDNEYS,O_SPLEEN,O_STOMACH,O_INTESTINE,O_BRAIN))
		var/status = pref.organ_data[name]
		if(!status)
			continue
		var/obj/item/organ/I = character.internal_organs_by_name[name]
		if(istype(I, /obj/item/organ/internal/brain))
			var/obj/item/organ/external/E = character.get_organ(I.parent_organ)
			if(E.robotic < ORGAN_ASSISTED)
				continue
		if(I)
			if(status == "assisted")
				I.mechassist()
			else if(status == "mechanical")
				I.robotize()
			else if(status == "digital")
				I.digitize()

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	var/priority = 0
	for(var/M in pref.body_markings)
		priority += 1
		var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[M]
		var/mark_color = "[pref.body_markings[M]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = mark_color, "datum" = mark_datum, "priority" = priority)
	character.markings_len = priority

	var/list/last_descriptors = list()
	if(islist(pref.body_descriptors))
		last_descriptors = pref.body_descriptors.Copy()
	pref.body_descriptors = list()

	var/datum/species/mob_species = GLOB.all_species[pref.species]
	if(LAZYLEN(mob_species.descriptors))
		for(var/entry in mob_species.descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if(istype(descriptor))
				if(isnull(last_descriptors[entry]))
					pref.body_descriptors[entry] = descriptor.default_value // Species datums have initial default value.
				else
					pref.body_descriptors[entry] = CLAMP(last_descriptors[entry], 1, LAZYLEN(descriptor.standalone_value_descriptors))

/datum/category_item/player_setup_item/general/body/content(var/mob/user)
	. = list()

	var/datum/species/mob_species = GLOB.all_species[pref.species]
	. += "<table><tr style='vertical-align:top'><td><b>Body</b> "
	. += "(<a href='?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"
	. += "Species: <a href='?src=\ref[src];show_species=1'>[pref.species]</a><br>"
	. += "Blood Type: <a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"
	if(has_flag(mob_species, HAS_SKIN_TONE))
		. += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a><br>"
	. += "Needs Glasses: <a href='?src=\ref[src];disabilities=[NEARSIGHTED]'><b>[pref.disabilities & NEARSIGHTED ? "Yes" : "No"]</b></a><br>"
	. += "Limbs: <a href='?src=\ref[src];limbs=1'>Adjust</a> <a href='?src=\ref[src];reset_limbs=1'>Reset</a><br>"
	. += "Internal Organs: <a href='?src=\ref[src];organs=1'>Adjust</a><br>"

	//display limbs below
	var/ind = 0
	for(var/name in pref.organ_data)
		var/status = pref.organ_data[name]
		var/organ_name = null

		switch(name)
			if(BP_TORSO)
				organ_name = "torso"
			if(BP_GROIN)
				organ_name = "groin"
			if(BP_HEAD)
				organ_name = "head"
			if(BP_L_ARM)
				organ_name = "left arm"
			if(BP_R_ARM)
				organ_name = "right arm"
			if(BP_L_LEG)
				organ_name = "left leg"
			if(BP_R_LEG)
				organ_name = "right leg"
			if(BP_L_FOOT)
				organ_name = "left foot"
			if(BP_R_FOOT)
				organ_name = "right foot"
			if(BP_L_HAND)
				organ_name = "left hand"
			if(BP_R_HAND)
				organ_name = "right hand"
			if(O_HEART)
				organ_name = "heart"
			if(O_EYES)
				organ_name = "eyes"
			if(O_VOICE)
				organ_name = "larynx"
			if(O_BRAIN)
				organ_name = "brain"
			if(O_LUNGS)
				organ_name = "lungs"
			if(O_LIVER)
				organ_name = "liver"
			if(O_KIDNEYS)
				organ_name = "kidneys"
			if(O_SPLEEN)
				organ_name = "spleen"
			if(O_STOMACH)
				organ_name = "stomach"
			if(O_INTESTINE)
				organ_name = "intestines"

		if(status == "cyborg")
			++ind
			if(ind > 1)
				. += ", "
			var/datum/robolimb/R
			if(pref.rlimb_data[name] && all_robolimbs[pref.rlimb_data[name]])
				R = all_robolimbs[pref.rlimb_data[name]]
			else
				R = basic_robolimb
			. += "\t[R.company] [organ_name] prosthesis"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				. += ", "
			. += "\tAmputated [organ_name]"
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				. += ", "
			switch(organ_name)
				if ("brain")
					. += "\tPositronic [organ_name]"
				else
					. += "\tSynthetic [organ_name]"
		else if(status == "digital")
			++ind
			if(ind > 1)
				. += ", "
			. += "\tDigital [organ_name]"
		else if(status == "assisted")
			++ind
			if(ind > 1)
				. += ", "
			switch(organ_name)
				if("heart")
					. += "\tPacemaker-assisted [organ_name]"
				if("lungs")
					. += "\tAssisted [organ_name]"
				if("voicebox") //on adding voiceboxes for speaking skrell/similar replacements
					. += "\tSurgically altered [organ_name]"
				if("eyes")
					. += "\tRetinal overlayed [organ_name]"
				if("brain")
					. += "\tAssisted-interface [organ_name]"
				else
					. += "\tMechanically assisted [organ_name]"
	if(!ind)
		. += "\[...\]<br><br>"
	else
		. += "<br><br>"

	if(LAZYLEN(pref.body_descriptors))
		. += "<table>"
		for(var/entry in pref.body_descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]:</b></td><td>[descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])]</td><td><a href='?src=\ref[src];change_descriptor=[entry]'>Change</a><br/></td></tr>"
		. += "</table><br>"

	. += "</td><td><b>Preview</b><br>"
	. += "<br><a href='?src=\ref[src];cycle_bg=1'>Cycle background</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"
	. += "</td></tr></table>"

	. += "<b>Hair</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];hair_color=1'>Change Color</a> [color_square(pref.r_hair, pref.g_hair, pref.b_hair)] "
	. += " Style: <a href='?src=\ref[src];hair_style_left=[pref.h_style]'><</a> <a href='?src=\ref[src];hair_style_right=[pref.h_style]''>></a> <a href='?src=\ref[src];hair_style=1'>[pref.h_style]</a><br>" //The <</a> & ></a> in this line is correct-- those extra characters are the arrows you click to switch between styles.

	. += "<b>Gradient</b><br>"
	. += "<a href='?src=\ref[src];grad_color=1'>Change Color</a> [color_square(pref.r_grad, pref.g_grad, pref.b_grad)] "
	. += " Style: <a href='?src=\ref[src];grad_style_left=[pref.grad_style]'><</a> <a href='?src=\ref[src];grad_style_right=[pref.grad_style]''>></a> <a href='?src=\ref[src];grad_style=1'>[pref.grad_style]</a><br>"

	. += "<br><b>Facial</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];facial_color=1'>Change Color</a> [color_square(pref.r_facial, pref.g_facial, pref.b_facial)] "
	. += " Style: <a href='?src=\ref[src];facial_style_left=[pref.f_style]'><</a> <a href='?src=\ref[src];facial_style_right=[pref.f_style]''>></a> <a href='?src=\ref[src];facial_style=1'>[pref.f_style]</a><br>" //Same as above with the extra > & < characters

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Eyes</b><br>"
		. += "<a href='?src=\ref[src];eye_color=1'>Change Color</a> [color_square(pref.r_eyes, pref.g_eyes, pref.b_eyes)]<br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Body Color</b><br>"
		. += "<a href='?src=\ref[src];skin_color=1'>Change Color</a> [color_square(pref.r_skin, pref.g_skin, pref.b_skin)]<br>"

	. += "<h2>Genetics Settings</h2>"

	var/list/ear_styles = pref.get_available_styles(global.ear_styles_list)
	var/datum/sprite_accessory/ears/ear = ear_styles[pref.ear_style]
	. += "<b>Ears</b><br>"
	if(istype(ear))
		. += " Style: <a href='?src=\ref[src];ear_style=1'>[ear.name]</a><br>"
		if(ear.do_colouration)
			. += "<a href='?src=\ref[src];ear_color=1'>Change Color</a> [color_square(pref.r_ears, pref.g_ears, pref.b_ears)]<br>"
		if(ear.extra_overlay)
			. += "<a href='?src=\ref[src];ear_color2=1'>Change Secondary Color</a> [color_square(pref.r_ears2, pref.g_ears2, pref.b_ears2)]<br>"
		if(ear.extra_overlay2)
			. += "<a href='?src=\ref[src];ear_color3=1'>Change Tertiary Color</a> [color_square(pref.r_ears3, pref.g_ears3, pref.b_ears3)]<br>"
	else
		. += " Style: <a href='?src=\ref[src];ear_style=1'>Select</a><br>"

	var/list/tail_styles = pref.get_available_styles(global.tail_styles_list)
	var/datum/sprite_accessory/tail/tail = tail_styles[pref.tail_style]
	. += "<b>Tail</b><br>"
	if(istype(tail))
		. += " Style: <a href='?src=\ref[src];tail_style=1'>[tail.name]</a><br>"
		if(tail.do_colouration)
			. += "<a href='?src=\ref[src];tail_color=1'>Change Color</a> [color_square(pref.r_tail, pref.g_tail, pref.b_tail)]<br>"
		if(tail.extra_overlay)
			. += "<a href='?src=\ref[src];tail_color2=1'>Change Secondary Color</a> [color_square(pref.r_tail2, pref.g_tail2, pref.b_tail2)]<br>"
		if(tail.extra_overlay2)
			. += "<a href='?src=\ref[src];tail_color3=1'>Change Tertiary Color</a> [color_square(pref.r_tail3, pref.g_tail3, pref.b_tail3)]<br>"
	else
		. += " Style: <a href='?src=\ref[src];tail_style=1'>Select</a><br>"

	var/list/wing_styles = pref.get_available_styles(global.wing_styles_list)
	var/datum/sprite_accessory/wing/wings = wing_styles[pref.wing_style]
	. += "<b>Wing</b><br>"
	if(istype(wings))
		. += " Style: <a href='?src=\ref[src];wing_style=1'>[wings.name]</a><br>"
		if(wings.do_colouration)
			. += "<a href='?src=\ref[src];wing_color=1'>Change Color</a> [color_square(pref.r_wing, pref.g_wing, pref.b_wing)]<br>"
		if(wings.extra_overlay)
			. += "<a href='?src=\ref[src];wing_color2=1'>Change Secondary Color</a> [color_square(pref.r_wing2, pref.g_wing2, pref.b_wing2)]<br>"
		if(wings.extra_overlay2)
			. += "<a href='?src=\ref[src];wing_color3=1'>Change Secondary Color</a> [color_square(pref.r_wing3, pref.g_wing3, pref.b_wing3)]<br>"
	else
		. += " Style: <a href='?src=\ref[src];wing_style=1'>Select</a><br>"

	. += "<br><a href='?src=\ref[src];marking_style=1'>Body Markings +</a><br>"
	. += "<table>"
	for(var/M in pref.body_markings)
		. += "<tr><td>[M]</td><td>[pref.body_markings.len > 1 ? "<a href='?src=\ref[src];marking_up=[M]'>&#708;</a> <a href='?src=\ref[src];marking_down=[M]'>&#709;</a> <a href='?src=\ref[src];marking_move=[M]'>mv</a> " : ""]<a href='?src=\ref[src];marking_remove=[M]'>-</a> <a href='?src=\ref[src];marking_color=[M]'>Color</a>[color_square(hex = pref.body_markings[M])]</td></tr>"

	. += "</table>"
	. += "<br>"
	. += "<b>Allow Synth markings:</b> <a href='?src=\ref[src];synth_markings=1'><b>[pref.synth_markings ? "Yes" : "No"]</b></a><br>"
	. += "<b>Allow Synth color:</b> <a href='?src=\ref[src];synth_color=1'><b>[pref.synth_color ? "Yes" : "No"]</b></a><br>"
	if(pref.synth_color)
		. += "<a href='?src=\ref[src];synth2_color=1'>Change Color</a> [color_square(pref.r_synth, pref.g_synth, pref.b_synth)]"

	. = jointext(.,null)

/datum/category_item/player_setup_item/general/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/general/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = GLOB.all_species[pref.species]

	if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_descriptor"])
		if(mob_species.descriptors)
			var/desc_id = href_list["change_descriptor"]
			if(pref.body_descriptors[desc_id])
				var/datum/mob_descriptor/descriptor = mob_species.descriptors[desc_id]
				var/choice = tgui_input_list(usr, "Please select a descriptor.", "Descriptor", descriptor.chargen_value_descriptors)
				if(choice && mob_species.descriptors[desc_id]) // Check in case they sneakily changed species.
					pref.body_descriptors[desc_id] = descriptor.chargen_value_descriptors[choice]
					return TOPIC_REFRESH

	else if(href_list["blood_type"])
		var/new_b_type = tgui_input_list(user, "Choose your character's blood-type:", "Character Preference", valid_bloodtypes)
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	else if(href_list["show_species"])
		// Actual whitelist checks are handled elsewhere, this is just for accessing the preview window.
		var/choice = tgui_input_list(usr, "Which species would you like to look at?", "Species Choice", GLOB.playable_species)
		if(!choice) return
		pref.species_preview = choice
		SetSpecies(preference_mob())
		pref.alternate_languages.Cut() // Reset their alternate languages. Todo: attempt to just fix it instead?
		return TOPIC_HANDLED

	else if(href_list["set_species"])
		user << browse(null, "window=species")
		if(!pref.species_preview || !(pref.species_preview in GLOB.all_species))
			return TOPIC_NOACTION

		var/datum/species/setting_species

		if(GLOB.all_species[href_list["set_species"]])
			setting_species = GLOB.all_species[href_list["set_species"]]
		else
			return TOPIC_NOACTION

		if(((!(setting_species.spawn_flags & SPECIES_CAN_JOIN)) || (!is_alien_whitelisted(preference_mob(),setting_species))) && !check_rights(R_ADMIN|R_EVENT, 0) && !(setting_species.spawn_flags & SPECIES_WHITELIST_SELECTABLE))	//VOREStation Edit: selectability
			return TOPIC_NOACTION

		var/prev_species = pref.species
		pref.species = href_list["set_species"]
		if(prev_species != pref.species)
			if(!(pref.biological_gender in mob_species.genders))
				pref.set_biological_gender(mob_species.genders[1])
			pref.custom_species = null //VOREStation Edit - This is cleared on species changes
			//grab one of the valid hair styles for the newly chosen species
			var/list/valid_hairstyles = pref.get_valid_hairstyles()

			if(valid_hairstyles.len)
				pref.h_style = pick(valid_hairstyles)
			else
				//this shouldn't happen
				pref.h_style = hair_styles_list["Bald"]

			//grab one of the valid facial hair styles for the newly chosen species
			var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()

			if(valid_facialhairstyles.len)
				pref.f_style = pick(valid_facialhairstyles)
			else
				//this shouldn't happen
				pref.f_style = facial_hair_styles_list["Shaved"]

			//reset hair colour and skin colour
			pref.r_hair = 0//hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = 0//hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = 0//hex2num(copytext(new_hair, 6, 8))
			pref.s_tone = -75

			reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.
			pref.body_markings.Cut() // Basically same as above.

			pref.sanitize_body_styles()

			var/min_age = get_min_age()
			var/max_age = get_max_age()
			pref.age = max(min(pref.age, max_age), min_age)

			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_hair = hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = hex2num(copytext(new_hair, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_grad = input(user, "Choose your character's secondary hair color:", "Character Preference", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null
		if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_grad = hex2num(copytext(new_grad, 2, 4))
			pref.g_grad = hex2num(copytext(new_grad, 4, 6))
			pref.b_grad = hex2num(copytext(new_grad, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = pref.get_valid_hairstyles()

		var/new_h_style = tgui_input_list(user, "Choose your character's hair style:", "Character Preference", valid_hairstyles, pref.h_style)
		if(new_h_style && CanUseTopic(user))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style"])
		var/list/valid_gradients = GLOB.hair_gradients

		var/new_grad_style = tgui_input_list(user, "Choose a color pattern for your hair:", "Character Preference", valid_gradients, pref.grad_style)
		if(new_grad_style && CanUseTopic(user))
			pref.grad_style = new_grad_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style_left"])
		var/H = href_list["hair_style_left"]
		var/list/valid_hairstyles = pref.get_valid_hairstyles()
		var/start = valid_hairstyles.Find(H)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.h_style = valid_hairstyles[start-1]
		else //But if we ARE, become the final element.
			pref.h_style = valid_hairstyles[valid_hairstyles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style_right"])
		var/H = href_list["hair_style_right"]
		var/list/valid_hairstyles = pref.get_valid_hairstyles()
		var/start = valid_hairstyles.Find(H)

		if(start != valid_hairstyles.len) //If we're not the end of the list, become the next element.
			pref.h_style = valid_hairstyles[start+1]
		else //But if we ARE, become the first element.
			pref.h_style = valid_hairstyles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_facial = hex2num(copytext(new_facial, 2, 4))
			pref.g_facial = hex2num(copytext(new_facial, 4, 6))
			pref.b_facial = hex2num(copytext(new_facial, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.r_eyes = hex2num(copytext(new_eyes, 2, 4))
			pref.g_eyes = hex2num(copytext(new_eyes, 4, 6))
			pref.b_eyes = hex2num(copytext(new_eyes, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = tgui_input_number(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference", (-pref.s_tone) + 35, 220, 1)
		if(new_s_tone && has_flag(mob_species, HAS_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - max(min( round(new_s_tone), 220),1)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
		if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.r_skin = hex2num(copytext(new_skin, 2, 4))
			pref.g_skin = hex2num(copytext(new_skin, 4, 6))
			pref.b_skin = hex2num(copytext(new_skin, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()

		var/new_f_style = tgui_input_list(user, "Choose your character's facial-hair style:", "Character Preference", valid_facialhairstyles, pref.f_style)
		if(new_f_style && CanUseTopic(user))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style_left"])
		var/F = href_list["facial_style_left"]
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()
		var/start = valid_facialhairstyles.Find(F)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.f_style = valid_facialhairstyles[start-1]
		else //But if we ARE, become the final element.
			pref.f_style = valid_facialhairstyles[valid_facialhairstyles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style_right"])
		var/F = href_list["facial_style_right"]
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()
		var/start = valid_facialhairstyles.Find(F)

		if(start != valid_facialhairstyles.len) //If we're not the end of the list, become the next element.
			pref.f_style = valid_facialhairstyles[start+1]
		else //But if we ARE, become the first element.
			pref.f_style = valid_facialhairstyles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/usable_markings = pref.body_markings.Copy() ^ body_marking_styles_list.Copy()
		/* VOREStation Removal - No markings whitelist, let people mix/match
		for(var/M in usable_markings)
			var/datum/sprite_accessory/S = usable_markings[M]
			if(!S.species_allowed.len)
				continue
			else if(!(pref.species in S.species_allowed))
				usable_markings -= M
		*/ //VOREStation Removal End
		var/new_marking = tgui_input_list(user, "Choose a body marking:", "Character Preference", usable_markings)
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = "#000000" //New markings start black
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_up"])
		var/M = href_list["marking_up"]
		var/start = pref.body_markings.Find(M)
		if(start != 1) //If we're not the beginning of the list, swap with the previous element.
			moveElement(pref.body_markings, start, start-1)
		else //But if we ARE, become the final element -ahead- of everything else.
			moveElement(pref.body_markings, start, pref.body_markings.len+1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_down"])
		var/M = href_list["marking_down"]
		var/start = pref.body_markings.Find(M)
		if(start != pref.body_markings.len) //If we're not the end of the list, swap with the next element.
			moveElement(pref.body_markings, start, start+2)
		else //But if we ARE, become the first element -behind- everything else.
			moveElement(pref.body_markings, start, 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_move"])
		var/M = href_list["marking_move"]
		var/start = pref.body_markings.Find(M)
		var/list/move_locs = pref.body_markings - M
		if(start != 1)
			move_locs -= pref.body_markings[start-1]

		var/inject_after = tgui_input_list(user, "Move [M] ahead of...", "Character Preference", move_locs) //Move ahead of any marking that isn't the current or previous one.
		var/newpos = pref.body_markings.Find(inject_after)
		if(newpos)
			moveElement(pref.body_markings, start, newpos+1)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		pref.body_markings -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		var/mark_color = input(user, "Choose the [M] color: ", "Character Preference", pref.body_markings[M]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = "[mark_color]"
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["reset_limbs"])
		reset_limbs()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["limbs"])

		var/list/limb_selection_list = list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand","Full Body")

		// Full prosthetic bodies without a brain are borderline unkillable so make sure they have a brain to remove/destroy.
		var/datum/species/current_species = GLOB.all_species[pref.species]
		if(!current_species.has_organ["brain"])
			limb_selection_list -= "Full Body"
		else if(pref.organ_data[BP_TORSO] == "cyborg")
			limb_selection_list |= "Head"

		var/organ_tag = tgui_input_list(user, "Which limb do you want to change?", "Limb Choice", limb_selection_list)

		if(!organ_tag || !CanUseTopic(user)) return TOPIC_NOACTION

		var/limb = null
		var/second_limb = null // if you try to change the arm, the hand should also change
		var/third_limb = null  // if you try to unchange the hand, the arm should also change

		// Do not let them amputate their entire body, ty.
		var/list/choice_options = list("Normal","Amputated","Prosthesis")
		switch(organ_tag)
			if("Left Leg")
				limb =        BP_L_LEG
				second_limb = BP_L_FOOT
			if("Right Leg")
				limb =        BP_R_LEG
				second_limb = BP_R_FOOT
			if("Left Arm")
				limb =        BP_L_ARM
				second_limb = BP_L_HAND
			if("Right Arm")
				limb =        BP_R_ARM
				second_limb = BP_R_HAND
			if("Left Foot")
				limb =        BP_L_FOOT
				third_limb =  BP_L_LEG
			if("Right Foot")
				limb =        BP_R_FOOT
				third_limb =  BP_R_LEG
			if("Left Hand")
				limb =        BP_L_HAND
				third_limb =  BP_L_ARM
			if("Right Hand")
				limb =        BP_R_HAND
				third_limb =  BP_R_ARM
			if("Head")
				limb =        BP_HEAD
				choice_options = list("Prosthesis")
			if("Full Body")
				limb =        BP_TORSO
				second_limb = BP_HEAD
				third_limb =  BP_GROIN
				choice_options = list("Normal","Prosthesis")

		var/new_state = tgui_input_list(user, "What state do you wish the limb to be in?", "State Choice", choice_options)
		if(!new_state || !CanUseTopic(user)) return TOPIC_NOACTION

		switch(new_state)
			if("Normal")
				pref.organ_data[limb] = null
				pref.rlimb_data[limb] = null
				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						pref.organ_data[other_limb] = null
						pref.rlimb_data[other_limb] = null
						for(var/internal in O_STANDARD)
							pref.organ_data[internal] = null
							pref.rlimb_data[internal] = null
				if(third_limb)
					pref.organ_data[third_limb] = null
					pref.rlimb_data[third_limb] = null

			if("Amputated")
				if(limb == BP_TORSO)
					return
				pref.organ_data[limb] = "amputated"
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = "amputated"
					pref.rlimb_data[second_limb] = null

			if("Prosthesis")
				var/tmp_species = pref.species ? pref.species : SPECIES_HUMAN
				var/list/usable_manufacturers = list()
				for(var/company in chargen_robolimbs)
					var/datum/robolimb/M = chargen_robolimbs[company]
					if(!(limb in M.parts))
						continue
					if(tmp_species in M.species_cannot_use)
						continue
					//VOREStation Add - Cyberlimb whitelisting.
					if(M.whitelisted_to && !(user.ckey in M.whitelisted_to))
						continue
					//VOREStation Add End
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = tgui_input_list(user, "Which manufacturer do you wish to use for this limb?", "Manufacturer Choice", usable_manufacturers)
				if(!choice)
					return

				pref.rlimb_data[limb] = choice
				pref.organ_data[limb] = "cyborg"

				if(second_limb)
					pref.rlimb_data[second_limb] = choice
					pref.organ_data[second_limb] = "cyborg"
				if(third_limb && pref.organ_data[third_limb] == "amputated")
					pref.organ_data[third_limb] = null

				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						if(pref.organ_data[other_limb])
							continue
						pref.organ_data[other_limb] = "cyborg"
						pref.rlimb_data[other_limb] = choice
					if(!pref.organ_data[O_BRAIN])
						pref.organ_data[O_BRAIN] = "assisted"
					for(var/internal_organ in list(O_HEART,O_EYES))
						pref.organ_data[internal_organ] = "mechanical"

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["organs"])

		var/organ_name = tgui_input_list(user, "Which internal function do you want to change?", "Internal Organ", list("Heart", "Eyes", "Larynx", "Lungs", "Liver", "Kidneys", "Spleen", "Intestines", "Stomach", "Brain"))
		if(!organ_name) return

		var/organ = null
		switch(organ_name)
			if("Heart")
				organ = O_HEART
			if("Eyes")
				organ = O_EYES
			if("Larynx")
				organ = O_VOICE
			if("Lungs")
				organ = O_LUNGS
			if("Liver")
				organ = O_LIVER
			if("Kidneys")
				organ = O_KIDNEYS
			if("Spleen")
				organ = O_SPLEEN
			if("Intestines")
				organ = O_INTESTINE
			if("Stomach")
				organ = O_STOMACH
			if("Brain")
				if(pref.organ_data[BP_HEAD] != "cyborg")
					to_chat(user, "<span class='warning'>You may only select a cybernetic or synthetic brain if you have a full prosthetic body.</span>")
					return
				organ = "brain"

		var/datum/species/current_species = GLOB.all_species[pref.species]
		var/list/organ_choices = list("Normal")
		if(pref.organ_data[BP_TORSO] == "cyborg")
			organ_choices -= "Normal"
			if(organ_name == "Brain")
				organ_choices += "Cybernetic"
				if(!(current_species.spawn_flags & SPECIES_NO_POSIBRAIN))
					organ_choices += "Positronic"
				if(!(current_species.spawn_flags & SPECIES_NO_DRONEBRAIN))
					organ_choices += "Drone"
			else
				organ_choices += "Assisted"
				organ_choices += "Mechanical"
		else
			organ_choices += "Assisted"
			organ_choices += "Mechanical"

		var/new_state = tgui_input_list(user, "What state do you wish the organ to be in?", "State Choice", organ_choices)
		if(!new_state) return

		switch(new_state)
			if("Normal")
				pref.organ_data[organ] = null
			if("Assisted")
				pref.organ_data[organ] = "assisted"
			if("Cybernetic")
				pref.organ_data[organ] = "assisted"
			if("Mechanical")
				pref.organ_data[organ] = "mechanical"
			if("Drone")
				pref.organ_data[organ] = "digital"
			if("Positronic")
				pref.organ_data[organ] = "mechanical"

		return TOPIC_REFRESH

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		pref.disabilities ^= disability_flag
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_color"])
		pref.synth_color = !pref.synth_color
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth2_color"])
		var/new_color = input(user, "Choose your character's synth colour: ", "Character Preference", rgb(pref.r_synth, pref.g_synth, pref.b_synth)) as color|null
		if(new_color && CanUseTopic(user))
			pref.r_synth = hex2num(copytext(new_color, 2, 4))
			pref.g_synth = hex2num(copytext(new_color, 4, 6))
			pref.b_synth = hex2num(copytext(new_color, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_markings"])
		pref.synth_markings = !pref.synth_markings
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_bg"])
		pref.bgstate = next_in_list(pref.bgstate, pref.bgstate_options)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_style"])
		var/new_ear_style = tgui_input_list(user, "Select an ear style for this character:", "Character Preference", pref.get_available_styles(global.ear_styles_list), pref.ear_style)
		if(new_ear_style)
			pref.ear_style = new_ear_style

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color"])
		var/new_earc = input(user, "Choose your character's ear colour:", "Character Preference",
			rgb(pref.r_ears, pref.g_ears, pref.b_ears)) as color|null
		if(new_earc)
			pref.r_ears = hex2num(copytext(new_earc, 2, 4))
			pref.g_ears = hex2num(copytext(new_earc, 4, 6))
			pref.b_ears = hex2num(copytext(new_earc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color2"])
		var/new_earc2 = input(user, "Choose your character's ear colour:", "Character Preference",
			rgb(pref.r_ears2, pref.g_ears2, pref.b_ears2)) as color|null
		if(new_earc2)
			pref.r_ears2 = hex2num(copytext(new_earc2, 2, 4))
			pref.g_ears2 = hex2num(copytext(new_earc2, 4, 6))
			pref.b_ears2 = hex2num(copytext(new_earc2, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color3"])
		var/new_earc3 = input(user, "Choose your character's tertiary ear colour:", "Character Preference",
			rgb(pref.r_ears3, pref.g_ears3, pref.b_ears3)) as color|null
		if(new_earc3)
			pref.r_ears3 = hex2num(copytext(new_earc3, 2, 4))
			pref.g_ears3 = hex2num(copytext(new_earc3, 4, 6))
			pref.b_ears3 = hex2num(copytext(new_earc3, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_style"])
		var/new_tail_style = tgui_input_list(user, "Select a tail style for this character:", "Character Preference", pref.get_available_styles(global.tail_styles_list), pref.tail_style)
		if(new_tail_style)
			pref.tail_style = new_tail_style
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color"])
		var/new_tailc = input(user, "Choose your character's tail/taur colour:", "Character Preference",
			rgb(pref.r_tail, pref.g_tail, pref.b_tail)) as color|null
		if(new_tailc)
			pref.r_tail = hex2num(copytext(new_tailc, 2, 4))
			pref.g_tail = hex2num(copytext(new_tailc, 4, 6))
			pref.b_tail = hex2num(copytext(new_tailc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color2"])
		var/new_tailc2 = input(user, "Choose your character's secondary tail/taur colour:", "Character Preference",
			rgb(pref.r_tail2, pref.g_tail2, pref.b_tail2)) as color|null
		if(new_tailc2)
			pref.r_tail2 = hex2num(copytext(new_tailc2, 2, 4))
			pref.g_tail2 = hex2num(copytext(new_tailc2, 4, 6))
			pref.b_tail2 = hex2num(copytext(new_tailc2, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color3"])
		var/new_tailc3 = input(user, "Choose your character's tertiary tail/taur colour:", "Character Preference",
			rgb(pref.r_tail3, pref.g_tail3, pref.b_tail3)) as color|null
		if(new_tailc3)
			pref.r_tail3 = hex2num(copytext(new_tailc3, 2, 4))
			pref.g_tail3 = hex2num(copytext(new_tailc3, 4, 6))
			pref.b_tail3 = hex2num(copytext(new_tailc3, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_style"])
		var/new_wing_style = tgui_input_list(user, "Select a wing style for this character:", "Character Preference", pref.get_available_styles(global.wing_styles_list), pref.wing_style)
		if(new_wing_style)
			pref.wing_style = new_wing_style

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color"])
		var/new_wingc = input(user, "Choose your character's wing colour:", "Character Preference",
			rgb(pref.r_wing, pref.g_wing, pref.b_wing)) as color|null
		if(new_wingc)
			pref.r_wing = hex2num(copytext(new_wingc, 2, 4))
			pref.g_wing = hex2num(copytext(new_wingc, 4, 6))
			pref.b_wing = hex2num(copytext(new_wingc, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color2"])
		var/new_wingc2 = input(user, "Choose your character's secondary wing colour:", "Character Preference",
			rgb(pref.r_wing2, pref.g_wing2, pref.b_wing2)) as color|null
		if(new_wingc2)
			pref.r_wing2 = hex2num(copytext(new_wingc2, 2, 4))
			pref.g_wing2 = hex2num(copytext(new_wingc2, 4, 6))
			pref.b_wing2 = hex2num(copytext(new_wingc2, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color3"])
		var/new_wingc3 = input(user, "Choose your character's tertiary wing colour:", "Character Preference",
			rgb(pref.r_wing3, pref.g_wing3, pref.b_wing3)) as color|null
		if(new_wingc3)
			pref.r_wing3 = hex2num(copytext(new_wingc3, 2, 4))
			pref.g_wing3 = hex2num(copytext(new_wingc3, 4, 6))
			pref.b_wing3 = hex2num(copytext(new_wingc3, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/general/body/proc/reset_limbs()

	for(var/organ in pref.organ_data)
		pref.organ_data[organ] = null
	while(null in pref.organ_data)
		pref.organ_data -= null

	for(var/organ in pref.rlimb_data)
		pref.rlimb_data[organ] = null
	while(null in pref.rlimb_data)
		pref.rlimb_data -= null

	// Sanitize the name so that there aren't any numbers sticking around.
	pref.real_name          = sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		pref.real_name      = random_name(pref.identifying_gender, pref.species)

/datum/category_item/player_setup_item/general/body/proc/SetSpecies(mob/user)
	if(!pref.species_preview || !(pref.species_preview in GLOB.all_species))
		pref.species_preview = SPECIES_HUMAN
	var/datum/species/current_species = GLOB.all_species[pref.species_preview]
	var/dat = "<body>"
	dat += "<center><h2>[current_species.name] \[<a href='?src=\ref[src];show_species=1'>change</a>\]</h2></center><hr/>"
	dat += "<table padding='8px'>"
	dat += "<tr>"
	//vorestation edit begin
	if(current_species.wikilink)
		dat += "<td width = 400>[current_species.blurb]<br><br>See <a href=[current_species.wikilink]>the wiki</a> for more details.</td>"
	else
		dat += "<td width = 400>[current_species.blurb]</td>"
	//vorestation edit end
	dat += "<td width = 200 align='center'>"
	if("preview" in cached_icon_states(current_species.icobase))
		usr << browse_rsc(icon(current_species.icobase,"preview"), "species_preview_[current_species.name].png")
		dat += "<img src='species_preview_[current_species.name].png' width='64px' height='64px'><br/><br/>"
	dat += "<b>Language:</b> [current_species.species_language]<br/>"
	dat += "<small>"
	if(current_species.spawn_flags & SPECIES_CAN_JOIN)
		switch(current_species.rarity_value)
			if(1 to 2)
				dat += "</br><b>Often present on human stations.</b>"
			if(3 to 4)
				dat += "</br><b>Rarely present on human stations.</b>"
			if(5)
				dat += "</br><b>Unheard of on human stations.</b>"
			else
				dat += "</br><b>May be present on human stations.</b>"
	if(current_species.spawn_flags & SPECIES_IS_WHITELISTED)
		dat += "</br><b>Whitelist restricted.</b>"
	if(!current_species.has_organ[O_HEART])
		dat += "</br><b>Does not have a circulatory system.</b>"
	if(!current_species.has_organ[O_LUNGS])
		dat += "</br><b>Does not have a respiratory system.</b>"
	if(current_species.flags & NO_SCAN)
		dat += "</br><b>Does not have DNA.</b>"
	if(current_species.flags & NO_DEFIB)
		dat += "</br><b>Cannot be defibrillated.</b>"
	if(current_species.flags & NO_PAIN)
		dat += "</br><b>Does not feel pain.</b>"
	if(current_species.flags & NO_SLIP)
		dat += "</br><b>Has excellent traction.</b>"
	if(current_species.flags & NO_POISON)
		dat += "</br><b>Immune to most poisons.</b>"
	if(current_species.appearance_flags & HAS_SKIN_TONE)
		dat += "</br><b>Has a variety of skin tones.</b>"
	if(current_species.appearance_flags & HAS_SKIN_COLOR)
		dat += "</br><b>Has a variety of skin colours.</b>"
	if(current_species.appearance_flags & HAS_EYE_COLOR)
		dat += "</br><b>Has a variety of eye colours.</b>"
	if(current_species.flags & IS_PLANT)
		dat += "</br><b>Has a plantlike physiology.</b>"
	dat += "</small></td>"
	dat += "</tr>"
	dat += "</table><center><hr/>"

	var/restricted = 0

	if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
		restricted = 2
	else if(!is_alien_whitelisted(preference_mob(),current_species))
		restricted = 1

	if(restricted)
		if(restricted == 1)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>If you wish to be whitelisted, you can make an application post on <a href='?src=\ref[user];preference=open_whitelist_forum'>the forums</a>.</small></b></font></br>"
		else if(restricted == 2)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>This species is not available for play as a station race..</small></b></font></br>"
	if(!restricted || check_rights(R_ADMIN|R_EVENT, 0) || current_species.spawn_flags & SPECIES_WHITELIST_SELECTABLE)	//VOREStation Edit: selectability
		dat += "\[<a href='?src=\ref[src];set_species=[pref.species_preview]'>select</a>\]"
	dat += "</center></body>"

	user << browse(dat, "window=species;size=700x400")
