var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/equip_preview_mob = EQUIP_PREVIEW_ALL
	var/animations_toggle = FALSE

	var/icon/bgstate = "steel"
	var/list/bgstate_options = list("steel", "000", "midgrey", "FFF", "white", "techmaint", "desert", "grass", "snow")

	var/ear_style		// Type of selected ear style

	/// The typepath of the character's selected secondary ears.
	var/ear_secondary_style
	/// The color channels for the character's selected secondary ears
	///
	/// * This is a lazy list. Its length, when populated, should but cannot be assumed
	///   to be the number of color channels supported by the secondary ear style.
	var/list/ear_secondary_colors = list()

	var/tail_style		// Type of selected tail style

	var/wing_style		// Type of selected wing style

	var/datum/browser/markings_subwindow = null

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
	if(ear_secondary_style && !(ear_secondary_style in get_available_styles(global.ear_styles_list)))
		ear_secondary_style = null
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
		if(instance.name == DEVELOPER_WARNING_NAME)
			continue
		if(instance.ckeys_allowed && (!client || !(client.ckey in instance.ckeys_allowed)))
			continue
		if(instance.species_allowed && (!species || !(species in instance.species_allowed)) && (!client || !check_rights(R_ADMIN | R_EVENT | R_FUN, 0, client)) && (!custom_base || !(custom_base in instance.species_allowed)))
			continue
		.[instance.name] = instance

/datum/preferences/proc/mass_edit_marking_list(var/marking, var/change_on = TRUE, var/change_color = TRUE, var/marking_value = null, var/on = TRUE, var/color = "#000000")
	var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[marking]
	var/list/new_marking = marking_value||mark_datum.body_parts
	for (var/NM in new_marking)
		if (marking_value && !islist(new_marking[NM])) continue
		new_marking[NM] = list("on" = (!change_on && marking_value) ? marking_value[NM]["on"] : on, "color" = (!change_color && marking_value) ? marking_value[NM]["color"] : color)
	if (change_color)
		new_marking["color"] = color
	return new_marking

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 3

/datum/category_item/player_setup_item/general/body/load_character(list/save_data)
	pref.species			= save_data["species"]
	pref.s_tone				= save_data["skin_tone"]
	pref.h_style			= save_data["hair_style_name"]
	pref.f_style			= save_data["facial_style_name"]
	pref.grad_style			= save_data["grad_style_name"]
	pref.b_type				= save_data["b_type"]
	pref.organ_data			= check_list_copy(save_data["organ_data"])
	pref.rlimb_data			= check_list_copy(save_data["rlimb_data"])
	pref.body_markings		= check_list_copy(save_data["body_markings"])
	for(var/i in pref.body_markings)
		pref.body_markings[i] = check_list_copy(pref.body_markings[i])
		for(var/j in pref.body_markings[i])
			pref.body_markings[i][j] = check_list_copy(pref.body_markings[i][j])
	pref.synth_color		= save_data["synth_color"]
	pref.synth_markings		= save_data["synth_markings"]
	pref.bgstate			= save_data["bgstate"]
	pref.body_descriptors	= check_list_copy(save_data["body_descriptors"])
	pref.ear_style			= save_data["ear_style"]
	pref.ear_secondary_style = save_data["ear_secondary_style"]
	pref.ear_secondary_colors = save_data["ear_secondary_colors"]
	pref.tail_style			= save_data["tail_style"]
	pref.wing_style			= save_data["wing_style"]
	pref.digitigrade 		= save_data["digitigrade"]

/datum/category_item/player_setup_item/general/body/save_character(list/save_data)
	save_data["species"]			= pref.species
	save_data["skin_tone"]			= pref.s_tone
	save_data["hair_style_name"]	= pref.h_style
	save_data["facial_style_name"]	= pref.f_style
	save_data["grad_style_name"]	= pref.grad_style
	save_data["b_type"]				= pref.b_type
	save_data["organ_data"]			= check_list_copy(pref.organ_data)
	save_data["rlimb_data"]			= check_list_copy(pref.rlimb_data)
	var/list/body_markings 			= check_list_copy(pref.body_markings)
	for(var/i in pref.body_markings)
		body_markings[i] = check_list_copy(body_markings[i])
		for(var/j in body_markings[i])
			body_markings[i][j] = check_list_copy(body_markings[i][j])
	save_data["body_markings"]		= body_markings
	save_data["synth_color"]		= pref.synth_color
	save_data["synth_markings"]		= pref.synth_markings
	save_data["bgstate"]			= pref.bgstate
	save_data["body_descriptors"]	= check_list_copy(pref.body_descriptors)
	save_data["ear_style"]			= pref.ear_style
	save_data["ear_secondary_style"] = pref.ear_secondary_style
	save_data["ear_secondary_colors"] = pref.ear_secondary_colors
	save_data["tail_style"]			= pref.tail_style
	save_data["wing_style"]			= pref.wing_style
	save_data["digitigrade"]		= pref.digitigrade

/datum/category_item/player_setup_item/general/body/sanitize_character()
	if(!pref.species || !(pref.species in GLOB.playable_species))
		pref.species = SPECIES_HUMAN
	pref.s_tone			= sanitize_integer(pref.s_tone, -185, 34, initial(pref.s_tone))
	pref.h_style		= sanitize_inlist(pref.h_style, hair_styles_list, initial(pref.h_style))
	pref.f_style		= sanitize_inlist(pref.f_style, facial_hair_styles_list, initial(pref.f_style))
	pref.grad_style		= sanitize_inlist(pref.grad_style, GLOB.hair_gradients, initial(pref.grad_style))
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))

	if(!pref.organ_data) pref.organ_data = list()
	if(!pref.rlimb_data) pref.rlimb_data = list()
	if(!pref.body_markings) pref.body_markings = list()
	else pref.body_markings &= body_marking_styles_list
	for (var/M in pref.body_markings)
		if (!islist(pref.body_markings[M]))
			var/col = istext(pref.body_markings[M]) ? pref.body_markings[M] : "#000000"
			pref.body_markings[M] = pref.mass_edit_marking_list(M,color=col)
	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

	// sanitize secondary ears
	pref.ear_secondary_colors = SANITIZE_LIST(pref.ear_secondary_colors)
	if(length(pref.ear_secondary_colors) > length(GLOB.fancy_sprite_accessory_color_channel_names))
		pref.ear_secondary_colors.len = length(GLOB.fancy_sprite_accessory_color_channel_names)
	for(var/i in 1 to length(pref.ear_secondary_colors))
		pref.ear_secondary_colors[i] = sanitize_hexcolor(pref.ear_secondary_colors[i], "#ffffff")

	pref.digitigrade	= sanitize_integer(pref.digitigrade, 0, 1, initial(pref.digitigrade))

	pref.sanitize_body_styles()

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/body/copy_to_mob(var/mob/living/carbon/human/character)
	// Copy basic values
	character.h_style	= pref.h_style
	character.f_style	= pref.f_style
	character.s_tone	= pref.s_tone
	character.h_style	= pref.h_style
	character.f_style	= pref.f_style
	character.grad_style= pref.grad_style
	character.b_type	= pref.b_type
	character.synth_color = pref.synth_color
	character.synth_markings = pref.synth_markings
	if(character.species.digi_allowed)
		character.digitigrade = pref.digitigrade
	else
		character.digitigrade = 0

	//sanity check
	if(character.digitigrade == null)
		character.digitigrade = 0
		pref.digitigrade = 0

	var/list/ear_styles = pref.get_available_styles(global.ear_styles_list)
	character.ear_style =  ear_styles[pref.ear_style]

	// apply secondary ears; sanitize again to prevent runtimes in rendering
	character.ear_secondary_style = ear_styles[pref.ear_secondary_style]
	character.ear_secondary_colors = SANITIZE_LIST(pref.ear_secondary_colors)

	var/list/tail_styles = pref.get_available_styles(global.tail_styles_list)
	character.tail_style = tail_styles[pref.tail_style]

	var/list/wing_styles = pref.get_available_styles(global.wing_styles_list)
	character.wing_style = wing_styles[pref.wing_style]

	character.set_gender(pref.biological_gender)

	character.synthetic = pref.species == "Protean" ? all_robolimbs["protean"] : null //Clear the existing var. (unless protean, then switch it to the normal protean limb)
	var/list/organs_to_edit = list()
	for (var/name in list(BP_TORSO, BP_HEAD, BP_GROIN, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if (O)
			var/x = organs_to_edit.Find(O.parent_organ)
			if (x == 0)
				organs_to_edit += name
			else
				organs_to_edit.Insert(x+(O.robotic == ORGAN_NANOFORM ? 1 : 0), name)
	for(var/name in organs_to_edit)
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

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O && islist(O.markings) && islist(pref.body_markings[M]) && islist(pref.body_markings[M][BP]))
				O.markings[M] = list("color" = pref.body_markings[M][BP]["color"], "datum" = mark_datum, "priority" = priority, "on" = pref.body_markings[M][BP]["on"])
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
	. += "(<a title='Randomize' href='byond://?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"
	. += "Species: <a href='byond://?src=\ref[src];show_species=1'>[pref.species]</a><br>"
	. += "Blood Type: <a href='byond://?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"
	if(has_flag(mob_species, HAS_SKIN_TONE))
		. += "Skin Tone: <a href='byond://?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a><br>"
	. += "Limbs: <a href='byond://?src=\ref[src];limbs=1'>Adjust</a> <a href='byond://?src=\ref[src];reset_limbs=1'>Reset</a><br>"
	. += "Internal Organs: <a href='byond://?src=\ref[src];organs=1'>Adjust</a><br>"
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

			var/datum/robolimb/R = basic_robolimb
			var/key = pref.rlimb_data[name]
			if(!istext(key))
				log_debug("Bad rlimb_data for [key_name(pref.client)], [name] was set to [key]")
				to_chat(user, span_warning("Error loading robot limb data for `[name]`, clearing pref."))
				pref.rlimb_data -= name
			else
				R = LAZYACCESS(all_robolimbs, key)
				if(!istype(R))
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
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]:</b></td><td>[descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])]</td><td><a href='byond://?src=\ref[src];change_descriptor=[entry]'>Change</a><br/></td></tr>"
		. += "</table><br>"

	. += "</td><td><b>Preview</b><br>"
	. += "<br><a href='byond://?src=\ref[src];cycle_bg=1'>Cycle background</a>"
	. += "<br><a href='byond://?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a>"
	. += "<br><a href='byond://?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"
	. += "<br><a href='byond://?src=\ref[src];toggle_animations=1'>[pref.animations_toggle ? "Stop animations" : "Show animations"]</a>"
	. += "</td></tr></table>"

	. += span_bold("Hair") + "<br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='byond://?src=\ref[src];hair_color=1'>Change Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/hair_color))] "
	. += " Style: <a href='byond://?src=\ref[src];hair_style_left=[pref.h_style]'><</a> <a href='byond://?src=\ref[src];hair_style_right=[pref.h_style]''>></a> <a href='byond://?src=\ref[src];hair_style=1'>[pref.h_style]</a><br>" //The <</a> & ></a> in this line is correct-- those extra characters are the arrows you click to switch between styles.

	. += span_bold("Gradient") + "<br>"
	. += "<a href='byond://?src=\ref[src];grad_color=1'>Change Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/grad_color))] "
	. += " Style: <a href='byond://?src=\ref[src];grad_style_left=[pref.grad_style]'><</a> <a href='byond://?src=\ref[src];grad_style_right=[pref.grad_style]''>></a> <a href='byond://?src=\ref[src];grad_style=1'>[pref.grad_style]</a><br>"

	. += "<br><b>Facial</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='byond://?src=\ref[src];facial_color=1'>Change Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/facial_color))] "
	. += " Style: <a href='byond://?src=\ref[src];facial_style_left=[pref.f_style]'><</a> <a href='byond://?src=\ref[src];facial_style_right=[pref.f_style]''>></a> <a href='byond://?src=\ref[src];facial_style=1'>[pref.f_style]</a><br>" //Same as above with the extra > & < characters

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Eyes</b><br>"
		. += "<a href='byond://?src=\ref[src];eye_color=1'>Change Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/eyes_color))]<br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Body Color</b><br>"
		. += "<a href='byond://?src=\ref[src];skin_color=1'>Change Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/skin_color))]<br>"

	if(mob_species.digi_allowed)
		. += "<br><b>Digitigrade?:</b> <a href='byond://?src=\ref[src];digitigrade=1'><b>[pref.digitigrade ? "Yes" : "No"]</b></a><br>"

	. += "<h2>Genetics Settings</h2>"

	var/list/ear_styles = pref.get_available_styles(global.ear_styles_list)
	var/datum/sprite_accessory/ears/ear = ear_styles[pref.ear_style]
	. += span_bold("Ears") + "<br>"
	if(istype(ear))
		. += " Style: <a href='byond://?src=\ref[src];ear_style=1'>[ear.name]</a><br>"
		if(ear.do_colouration)
			. += "<a href='byond://?src=\ref[src];ear_color=1'>Change Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/ears_color1))]<br>"
		if(ear.extra_overlay)
			. += "<a href='byond://?src=\ref[src];ear_color2=1'>Change Secondary Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/ears_color2))]<br>"
		if(ear.extra_overlay2)
			. += "<a href='byond://?src=\ref[src];ear_color3=1'>Change Tertiary Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/ears_color3))]<br>"
	else
		. += " Style: <a href='byond://?src=\ref[src];ear_style=1'>Select</a><br>"

	var/datum/sprite_accessory/ears/ears_secondary = ear_styles[pref.ear_secondary_style]
	. += span_bold("Horns") + "<br>"
	if(istype(ears_secondary))
		. += " Style: <a href='byond://?src=\ref[src];ear_secondary_style=1'>[ears_secondary.name]</a><br>"
		for(var/channel in 1 to min(ears_secondary.get_color_channel_count(), length(GLOB.fancy_sprite_accessory_color_channel_names)))
			. += "<a href='byond://?src=\ref[src];ear_secondary_color=[channel]'>Change [GLOB.fancy_sprite_accessory_color_channel_names[channel]] Color</a> [color_square(hex = LAZYACCESS(pref.ear_secondary_colors, channel) || "#ffffff")]<br>"
	else
		. += " Style: <a href='byond://?src=\ref[src];ear_secondary_style=1'>Select</a><br>"

	var/list/tail_styles = pref.get_available_styles(global.tail_styles_list)
	var/datum/sprite_accessory/tail/tail = tail_styles[pref.tail_style]
	. += span_bold("Tail") + "<br>"
	if(istype(tail))
		. += " Style: <a href='byond://?src=\ref[src];tail_style=1'>[tail.name]</a><br>"
		if(tail.do_colouration)
			. += "<a href='byond://?src=\ref[src];tail_color=1'>Change Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/tail_color1))]<br>"
		if(tail.extra_overlay)
			. += "<a href='byond://?src=\ref[src];tail_color2=1'>Change Secondary Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/tail_color2))]<br>"
		if(tail.extra_overlay2)
			. += "<a href='byond://?src=\ref[src];tail_color3=1'>Change Tertiary Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/tail_color3))]<br>"
	else
		. += " Style: <a href='byond://?src=\ref[src];tail_style=1'>Select</a><br>"

	var/list/wing_styles = pref.get_available_styles(global.wing_styles_list)
	var/datum/sprite_accessory/wing/wings = wing_styles[pref.wing_style]
	. += span_bold("Wing") + "<br>"
	if(istype(wings))
		. += " Style: <a href='byond://?src=\ref[src];wing_style=1'>[wings.name]</a><br>"
		if(wings.do_colouration)
			. += "<a href='byond://?src=\ref[src];wing_color=1'>Change Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/wing_color1))]<br>"
		if(wings.extra_overlay)
			. += "<a href='byond://?src=\ref[src];wing_color2=1'>Change Secondary Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/wing_color2))]<br>"
		if(wings.extra_overlay2)
			. += "<a href='byond://?src=\ref[src];wing_color3=1'>Change Secondary Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/wing_color3))]<br>"
	else
		. += " Style: <a href='byond://?src=\ref[src];wing_style=1'>Select</a><br>"

	. += "<br><a href='byond://?src=\ref[src];marking_style=1'>Body Markings +</a><br>"
	. += "<table>"
	for(var/M in pref.body_markings)
		. += "<tr><td>[M]</td><td>[pref.body_markings.len > 1 ? "<a href='byond://?src=\ref[src];marking_up=[M]'>&#708;</a> <a href='byond://?src=\ref[src];marking_down=[M]'>&#709;</a> <a href='byond://?src=\ref[src];marking_move=[M]'>mv</a> " : ""]<a href='byond://?src=\ref[src];marking_remove=[M]'>-</a> <a href='byond://?src=\ref[src];marking_color=[M]'>Color</a>[color_square(hex = pref.body_markings[M]["color"] ? pref.body_markings[M]["color"] : "#000000")] - <a href='byond://?src=\ref[src];marking_submenu=[M]'>Customize</a></td></tr>"

	. += "</table>"
	. += "<br>"
	. += span_bold("Allow Synth markings:") + " <a href='byond://?src=\ref[src];synth_markings=1'><b>[pref.synth_markings ? "Yes" : "No"]</b></a><br>"
	. += span_bold("Allow Synth color:") + " <a href='byond://?src=\ref[src];synth_color=1'><b>[pref.synth_color ? "Yes" : "No"]</b></a><br>"
	if(pref.synth_color)
		. += "<a href='byond://?src=\ref[src];synth2_color=1'>Change Color</a> [color_square(hex = pref.read_preference(/datum/preference/color/human/synth_color))]"

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
				var/choice = tgui_input_list(user, "Please select a descriptor.", "Descriptor", descriptor.chargen_value_descriptors)
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
		var/choice = tgui_input_list(user, "Which species would you like to look at?", "Species Choice", GLOB.playable_species)
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

		if(((!(setting_species.spawn_flags & SPECIES_CAN_JOIN)) || (!is_alien_whitelisted(preference_mob(),setting_species))) && !check_rights(R_ADMIN|R_EVENT, 0) && !(setting_species.spawn_flags & SPECIES_WHITELIST_SELECTABLE))
			return TOPIC_NOACTION

		var/prev_species = pref.species
		pref.species = href_list["set_species"]
		if(prev_species != pref.species)
			if(!(pref.biological_gender in mob_species.genders))
				pref.set_biological_gender(mob_species.genders[1])
			pref.custom_species = null
			//grab one of the valid hair styles for the newly chosen species
			var/list/valid_hairstyles = pref.get_valid_hairstyles(user)

			if(valid_hairstyles.len)
				if(!(pref.h_style in valid_hairstyles))
					pref.h_style = pick(valid_hairstyles)
			else
				//this shouldn't happen
				pref.h_style = hair_styles_list["Bald"]

			//grab one of the valid facial hair styles for the newly chosen species
			var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()

			if(valid_facialhairstyles.len)
				if(!(pref.f_style in valid_facialhairstyles))
					pref.f_style = pick(valid_facialhairstyles)
			else
				//this shouldn't happen
				pref.f_style = facial_hair_styles_list["Shaved"]

			//reset hair colour and skin colour
			pref.update_preference_by_type(/datum/preference/color/human/hair_color, "#000000")
			pref.s_tone = -75

			reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.
			pref.body_markings.Cut() // Basically same as above.

			pref.sanitize_body_styles()

			var/min_age = get_min_age()
			var/max_age = get_max_age()
			pref.update_preference_by_type(/datum/preference/numeric/human/age, max(min(pref.read_preference(/datum/preference/numeric/human/age), max_age), min_age))
			pref.blood_color = setting_species.blood_color

			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = tgui_color_picker(user, "Choose your character's hair colour:", "Character Preference", pref.read_preference(/datum/preference/color/human/hair_color))
		if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/color/human/hair_color, new_hair)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_grad = tgui_color_picker(user, "Choose your character's secondary hair color:", "Character Preference", pref.read_preference(/datum/preference/color/human/grad_color))
		if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/color/human/grad_color, new_grad)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = pref.get_valid_hairstyles(user)

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
		var/list/valid_hairstyles = pref.get_valid_hairstyles(user)
		var/start = valid_hairstyles.Find(H)

		if(start != 1) //If we're not the beginning of the list, become the previous element.
			pref.h_style = valid_hairstyles[start-1]
		else //But if we ARE, become the final element.
			pref.h_style = valid_hairstyles[valid_hairstyles.len]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style_right"])
		var/H = href_list["hair_style_right"]
		var/list/valid_hairstyles = pref.get_valid_hairstyles(user)
		var/start = valid_hairstyles.Find(H)

		if(start != valid_hairstyles.len) //If we're not the end of the list, become the next element.
			pref.h_style = valid_hairstyles[start+1]
		else //But if we ARE, become the first element.
			pref.h_style = valid_hairstyles[1]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = tgui_color_picker(user, "Choose your character's facial-hair colour:", "Character Preference", pref.read_preference(/datum/preference/color/human/facial_color))
		if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/color/human/facial_color, new_facial)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["digitigrade"])
		pref.digitigrade = !pref.digitigrade

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = tgui_color_picker(user, "Choose your character's eye colour:", "Character Preference", pref.read_preference(/datum/preference/color/human/eyes_color))
		if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/color/human/eyes_color, new_eyes)
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
		var/new_skin = tgui_color_picker(user, "Choose your character's skin colour: ", "Character Preference", pref.read_preference(/datum/preference/color/human/skin_color))
		if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/color/human/skin_color, new_skin)
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
		var/new_marking = tgui_input_list(user, "Choose a body marking:", "Character Preference", usable_markings)
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = pref.mass_edit_marking_list(new_marking) //New markings start black
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
		winshow(user, "prefs_markings_subwindow", FALSE)
		pref.body_markings -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		if (isnull(pref.body_markings[M]["color"]))
			if (tgui_alert(user, "You currently have customized marking colors. This will reset each bodypart's color. Are you sure you want to continue?","Reset Bodypart Colors",list("Yes","No")) != "Yes")
				return TOPIC_NOACTION
		var/current = pref.body_markings[M] ? pref.body_markings[M]["color"] : "#000000"
		var/mark_color = tgui_color_picker(user, "Choose the [M] color: ", "Character Preference", current)
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = pref.mass_edit_marking_list(M,FALSE,TRUE,pref.body_markings[M],color="[mark_color]")
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if (href_list["marking_submenu"])
		var/M = href_list["marking_submenu"]
		markings_subwindow(user, M)
		return TOPIC_NOACTION

	else if (href_list["toggle_all_marking_selection"])
		var/toggle = text2num(href_list["toggle"])
		var/marking = href_list["toggle_all_marking_selection"]
		if (pref.body_markings.Find(marking) == 0)
			winshow(user, "prefs_markings_subwindow", FALSE)
			return TOPIC_NOACTION
		pref.body_markings[marking] = pref.mass_edit_marking_list(marking,TRUE,FALSE,pref.body_markings[marking],on=toggle)
		markings_subwindow(user, marking)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if (href_list["color_all_marking_selection"])
		var/marking = href_list["color_all_marking_selection"]
		if (pref.body_markings.Find(marking) == 0)
			winshow(user, "prefs_markings_subwindow", FALSE)
			return TOPIC_NOACTION
		var/mark_color = tgui_color_picker(user, "Choose the [marking] color: ", "Character Preference", pref.body_markings[marking]["color"])
		if(mark_color && CanUseTopic(user))
			pref.body_markings[marking] = pref.mass_edit_marking_list(marking,FALSE,TRUE,pref.body_markings[marking],color="[mark_color]")
			markings_subwindow(user, marking)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if (href_list["zone_marking_color"])
		var/marking = href_list["zone_marking_color"]
		if (pref.body_markings.Find(marking) == 0)
			winshow(user, "prefs_markings_subwindow", FALSE)
			return TOPIC_NOACTION
		var/zone = href_list["zone"]
		pref.body_markings[marking]["color"] = null //turn off the color button outside the submenu
		var/mark_color = tgui_color_picker(user, "Choose the [marking] color: ", "Character Preference", pref.body_markings[marking][zone]["color"])
		if(mark_color && CanUseTopic(user))
			pref.body_markings[marking][zone]["color"] = "[mark_color]"
			markings_subwindow(user, marking)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if (href_list["zone_marking_toggle"])
		var/marking = href_list["zone_marking_toggle"]
		if (pref.body_markings.Find(marking) == 0)
			winshow(user, "prefs_markings_subwindow", FALSE)
			return TOPIC_NOACTION
		var/zone = href_list["zone"]
		pref.body_markings[marking][zone]["on"] = text2num(href_list["toggle"])
		markings_subwindow(user, marking)
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
					if(M.whitelisted_to && !(user.ckey in M.whitelisted_to))
						continue
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
					to_chat(user, span_warning("You may only select a cybernetic or synthetic brain if you have a full prosthetic body."))
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

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_animations"])
		pref.animations_toggle = !pref.animations_toggle
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_color"])
		pref.synth_color = !pref.synth_color
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth2_color"])
		var/new_color = tgui_color_picker(user, "Choose your character's synth colour: ", "Character Preference", pref.read_preference(/datum/preference/color/human/synth_color))
		if(new_color && CanUseTopic(user))
			pref.update_preference_by_type(/datum/preference/color/human/synth_color, new_color)
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
		var/new_earc = tgui_color_picker(user, "Choose your character's ear colour:", "Character Preference",
			pref.read_preference(/datum/preference/color/human/ears_color1))
		if(new_earc)
			pref.update_preference_by_type(/datum/preference/color/human/ears_color1, new_earc)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color2"])
		var/new_earc2 = tgui_color_picker(user, "Choose your character's ear colour:", "Character Preference",
			pref.read_preference(/datum/preference/color/human/ears_color2))
		if(new_earc2)
			pref.update_preference_by_type(/datum/preference/color/human/ears_color2, new_earc2)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color3"])
		var/new_earc3 = tgui_color_picker(user, "Choose your character's tertiary ear colour:", "Character Preference",
			pref.read_preference(/datum/preference/color/human/ears_color3))
		if(new_earc3)
			pref.update_preference_by_type(/datum/preference/color/human/ears_color3, new_earc3)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_secondary_style"])
		var/new_style = tgui_input_list(user, "Select an ear style for this character:", "Character Preference", pref.get_available_styles(global.ear_styles_list), pref.ear_secondary_style)
		if(!new_style)
			return TOPIC_NOACTION
		pref.ear_secondary_style = new_style
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["ear_secondary_color"])
		var/channel = text2num(href_list["ear_secondary_color"])
		// very important sanity check; this makes sure someone can't crash the server by setting channel to some insanely high value
		if(channel > GLOB.fancy_sprite_accessory_color_channel_names.len)
			return TOPIC_NOACTION
		// this would say 'secondary ears' but you'd get 'choose your character's primary secondary ear colour' which sounds silly
		var/new_color = tgui_color_picker(
			user,
			"Choose your character's [lowertext(GLOB.fancy_sprite_accessory_color_channel_names[channel])] ear colour:",
			"Secondary Ear Coloration",
			LAZYACCESS(pref.ear_secondary_colors, channel) || "#ffffff",
		)
		if(!new_color)
			return TOPIC_NOACTION
		// ensures color channel list is at least that long
		// the upper bound is to have a secondary safety check because list index set is a dangerous call
		pref.ear_secondary_colors.len = clamp(length(pref.ear_secondary_colors), channel, length(GLOB.fancy_sprite_accessory_color_channel_names))
		pref.ear_secondary_colors[channel] = new_color
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_style"])
		var/new_tail_style = tgui_input_list(user, "Select a tail style for this character:", "Character Preference", pref.get_available_styles(global.tail_styles_list), pref.tail_style)
		if(new_tail_style)
			pref.tail_style = new_tail_style
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color"])
		var/new_tailc = tgui_color_picker(user, "Choose your character's tail/taur colour:", "Character Preference",
			pref.read_preference(/datum/preference/color/human/tail_color1))
		if(new_tailc)
			pref.update_preference_by_type(/datum/preference/color/human/tail_color1, new_tailc)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color2"])
		var/new_tailc2 = tgui_color_picker(user, "Choose your character's secondary tail/taur colour:", "Character Preference",
			pref.read_preference(/datum/preference/color/human/tail_color2))
		if(new_tailc2)
			pref.update_preference_by_type(/datum/preference/color/human/tail_color2, new_tailc2)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color3"])
		var/new_tailc3 = tgui_color_picker(user, "Choose your character's tertiary tail/taur colour:", "Character Preference",
			pref.read_preference(/datum/preference/color/human/tail_color3))
		if(new_tailc3)
			pref.update_preference_by_type(/datum/preference/color/human/tail_color3, new_tailc3)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_style"])
		var/new_wing_style = tgui_input_list(user, "Select a wing style for this character:", "Character Preference", pref.get_available_styles(global.wing_styles_list), pref.wing_style)
		if(new_wing_style)
			pref.wing_style = new_wing_style

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color"])
		var/new_wingc = tgui_color_picker(user, "Choose your character's wing colour:", "Character Preference",
			pref.read_preference(/datum/preference/color/human/wing_color1))
		if(new_wingc)
			pref.update_preference_by_type(/datum/preference/color/human/wing_color1, new_wingc)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color2"])
		var/new_wingc = tgui_color_picker(user, "Choose your character's secondary wing colour:", "Character Preference",
			pref.read_preference(/datum/preference/color/human/wing_color2))
		if(new_wingc)
			pref.update_preference_by_type(/datum/preference/color/human/wing_color2, new_wingc)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color3"])
		var/new_wingc = tgui_color_picker(user, "Choose your character's tertiary wing colour:", "Character Preference",
			pref.read_preference(/datum/preference/color/human/wing_color3))
		if(new_wingc)
			pref.update_preference_by_type(/datum/preference/color/human/wing_color3, new_wingc)
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
	var/dat = "<html><body>"
	dat += "<center><h2>[current_species.name] \[<a href='byond://?src=\ref[src];show_species=1'>change</a>\]</h2></center><hr/>"
	dat += "<table padding='8px'>"
	dat += "<tr>"
	if(current_species.wikilink)
		dat += "<td width = 400>[current_species.blurb]<br><br>See <a href=[current_species.wikilink]>the wiki</a> for more details.</td>"
	else
		dat += "<td width = 400>[current_species.blurb]</td>"
	dat += "<td width = 200 align='center'>"
	if("preview" in cached_icon_states(current_species.icobase))
		user << browse_rsc(icon(current_species.icobase,"preview"), "species_preview_[current_species.name].png")
		dat += "<img src='species_preview_[current_species.name].png' width='64px' height='64px'><br/><br/>"
	dat += span_bold("Language:") + " [current_species.species_language]<br/>"
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
			dat += "<font color='red'><b>You cannot play as this species.</br><small>If you wish to be whitelisted, you can make an application post on <a href='byond://?src=\ref[user];preference=open_whitelist_forum'>the forums</a>.</small></b></font></br>"
		else if(restricted == 2)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>This species is not available for play as a station race..</small></b></font></br>"
	if(!restricted || check_rights(R_ADMIN|R_EVENT, 0) || current_species.spawn_flags & SPECIES_WHITELIST_SELECTABLE)
		dat += "\[<a href='byond://?src=\ref[src];set_species=[pref.species_preview]'>select</a>\]"
	dat += "</center></body></html>"

	user << browse(dat, "window=species;size=700x400")

/datum/category_item/player_setup_item/general/body/proc/markings_subwindow(mob/user, marking)
	var/static/list/part_to_string = list(BP_HEAD = "Head", BP_TORSO = "Upper Body", BP_GROIN = "Lower Body", BP_R_ARM = "Right Arm", BP_L_ARM = "Left Arm", BP_R_HAND = "Right Hand", BP_L_HAND = "Left Hand", BP_R_LEG = "Right Leg", BP_L_LEG = "Left Leg", BP_R_FOOT = "Right Foot", BP_L_FOOT = "Left Foot")
	var/dat = "<html><body><center><h2>Editing '[marking]'</h2><br>"
	dat += "<a href='byond://?src=\ref[src];toggle_all_marking_selection=[marking];toggle=1'>Enable All</a> "
	dat += "<a href='byond://?src=\ref[src];toggle_all_marking_selection=[marking];toggle=0'>Disable All</a> "
	dat += "<a href='byond://?src=\ref[src];color_all_marking_selection=[marking]'>Change Color of All</a><br></center>"
	dat += "<br>"
	for (var/bodypart in pref.body_markings[marking])
		if (!islist(pref.body_markings[marking][bodypart])) continue
		dat += "[part_to_string[bodypart]]: [color_square(hex = pref.body_markings[marking][bodypart]["color"])] "
		dat += "<a href='byond://?src=\ref[src];zone_marking_color=[marking];zone=[bodypart]'>Change</a> "
		dat += "<a href='byond://?src=\ref[src];zone_marking_toggle=[marking];zone=[bodypart];toggle=[!pref.body_markings[marking][bodypart]["on"]]'>[pref.body_markings[marking][bodypart]["on"] ? "Toggle Off" : "Toggle On"]</a><br>"

	dat += "</body></html>"
	winshow(user, "prefs_markings_subwindow", TRUE)
	pref.markings_subwindow = new(user, "prefs_markings_browser", "Marking Editor", 400, 400)
	pref.markings_subwindow.set_content(dat)
	pref.markings_subwindow.open(FALSE)
	onclose(user, "prefs_markings_subwindow", src)
