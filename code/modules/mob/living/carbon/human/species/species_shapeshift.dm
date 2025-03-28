// This is something of an intermediary species used for species that
// need to emulate the appearance of another race. Currently it is only
// used for slimes but it may be useful for changelings later.
var/list/wrapped_species_by_ref = list()

/datum/species/shapeshifter

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_gender
		)

	var/list/valid_transform_species = list()
	//var/default_form = SPECIES_HUMAN //VOREStation edit

	base_species = SPECIES_HUMAN
	selects_bodytype = SELECTS_BODYTYPE_SHAPESHIFTER

/datum/species/shapeshifter/get_valid_shapeshifter_forms(var/mob/living/carbon/human/H)
	return list(vanity_base_fit)|valid_transform_species

/datum/species/shapeshifter/get_icobase(var/mob/living/carbon/human/H, var/get_deform)
	if(!H) return ..(null, get_deform)
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_icobase(H, get_deform)

/datum/species/shapeshifter/get_race_key(var/mob/living/carbon/human/H)
	return "[..()]-[wrapped_species_by_ref["\ref[H]"]]"

/datum/species/shapeshifter/get_bodytype(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_bodytype(H)

/datum/species/shapeshifter/get_blood_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_blood_mask(H)

/datum/species/shapeshifter/get_damage_mask(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_damage_mask(H)

/datum/species/shapeshifter/get_damage_overlays(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_damage_overlays(H)

/datum/species/shapeshifter/get_tail(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_tail(H)

/datum/species/shapeshifter/get_tail_animation(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_tail_animation(H)

/datum/species/shapeshifter/get_tail_hair(var/mob/living/carbon/human/H)
	if(!H) return ..()
	var/datum/species/S = GLOB.all_species[wrapped_species_by_ref["\ref[H]"]]
	return S.get_tail_hair(H)

/datum/species/shapeshifter/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	wrapped_species_by_ref["\ref[H]"] = base_species //VOREStation edit

	for(var/obj/item/organ/external/E in H.organs)
		E.sync_colour_to_human(H)

// Verbs follow.
/mob/living/carbon/human/proc/shapeshifter_select_hair()

	set name = "Select Hair"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10

	var/list/valid_hairstyles = list()
	var/list/valid_facialhairstyles = list()
	var/list/valid_gradstyles = GLOB.hair_gradients
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species.get_bodytype(src) in S.species_allowed))
			continue
		valid_hairstyles += hairstyle
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species.get_bodytype(src) in S.species_allowed))
			continue
		valid_facialhairstyles += facialhairstyle


	visible_message(span_notice("\The [src]'s form contorts subtly."))
	if(valid_hairstyles.len)
		var/new_hair = tgui_input_list(src, "Select a hairstyle.", "Shapeshifter Hair", valid_hairstyles)
		change_hair(new_hair ? new_hair : "Bald")
	if(valid_gradstyles.len)
		var/new_hair = tgui_input_list(src, "Select a hair gradient style.", "Shapeshifter Hair", valid_gradstyles)
		change_hair_gradient(new_hair ? new_hair : "None")
	if(valid_facialhairstyles.len)
		var/new_hair = tgui_input_list(src, "Select a facial hair style.", "Shapeshifter Hair", valid_facialhairstyles)
		change_facial_hair(new_hair ? new_hair : "Shaved")

/mob/living/carbon/human/proc/shapeshifter_select_gender()

	set name = "Select Gender"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_gender = tgui_input_list(src, "Please select a gender.", "Shapeshifter Gender", list(FEMALE, MALE, NEUTER, PLURAL))
	if(!new_gender)
		return

	var/new_gender_identity = tgui_input_list(src, "Please select a gender Identity.", "Shapeshifter Gender Identity", list(FEMALE, MALE, NEUTER, PLURAL, HERM)) //VOREStation Edit
	if(!new_gender_identity)
		return

	visible_message(span_notice("\The [src]'s form contorts subtly."))
	change_gender(new_gender)
	change_gender_identity(new_gender_identity)

/mob/living/carbon/human/proc/shapeshifter_select_shape()

	set name = "Select Body Shape"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_species = null
	new_species = tgui_input_list(src, "Please select a species to emulate.", "Shapeshifter Body", species.get_valid_shapeshifter_forms(src))

	if(!new_species || !GLOB.all_species[new_species] || wrapped_species_by_ref["\ref[src]"] == new_species)
		return
	shapeshifter_change_shape(new_species)

/* VOREStation edit - moved to species_shapeshift_vr.dm
/mob/living/carbon/human/proc/shapeshifter_change_shape(var/new_species = null)
	if(!new_species)
		return

	wrapped_species_by_ref["\ref[src]"] = new_species
	visible_message(span_infoplain(span_bold("\The [src]") + " shifts and contorts, taking the form of \a [new_species]!"))
	regenerate_icons()
*/

/mob/living/carbon/human/proc/shapeshifter_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_skin = tgui_color_picker(src, "Please select a new body color.", "Shapeshifter Colour", rgb(r_skin, g_skin, b_skin))
	if(!new_skin)
		return
	shapeshifter_set_colour(new_skin)

/mob/living/carbon/human/proc/shapeshifter_set_colour(var/new_skin)

	r_skin =   hex2num(copytext(new_skin, 2, 4))
	g_skin =   hex2num(copytext(new_skin, 4, 6))
	b_skin =   hex2num(copytext(new_skin, 6, 8))
	r_synth = r_skin
	g_synth = g_skin
	b_synth = b_skin


	for(var/obj/item/organ/external/E in organs)
		E.sync_colour_to_human(src)

	regenerate_icons()

/mob/living/carbon/human/proc/shapeshifter_select_hair_colors()

	set name = "Select Hair Colors"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_hair = tgui_color_picker(src, "Please select a new hair color.", "Hair Colour")
	if(!new_hair)
		return
	shapeshifter_set_hair_color(new_hair)
	var/new_grad = tgui_color_picker(src, "Please select a new hair gradient color.", "Hair Gradient Colour")
	if(!new_grad)
		return
	shapeshifter_set_grad_color(new_grad)
	var/new_fhair = tgui_color_picker(src, "Please select a new facial hair color.", "Facial Hair Color")
	if(!new_fhair)
		return
	shapeshifter_set_facial_color(new_fhair)

/mob/living/carbon/human/proc/shapeshifter_set_hair_color(var/new_hair)

	change_hair_color(hex2num(copytext(new_hair, 2, 4)), hex2num(copytext(new_hair, 4, 6)), hex2num(copytext(new_hair, 6, 8)))

/mob/living/carbon/human/proc/shapeshifter_set_grad_color(var/new_grad)

	change_grad_color(hex2num(copytext(new_grad, 2, 4)), hex2num(copytext(new_grad, 4, 6)), hex2num(copytext(new_grad, 6, 8)))

/mob/living/carbon/human/proc/shapeshifter_set_facial_color(var/new_fhair)

	change_facial_hair_color(hex2num(copytext(new_fhair, 2, 4)), hex2num(copytext(new_fhair, 4, 6)), hex2num(copytext(new_fhair, 6, 8)))

// Replaces limbs and copies wounds
/mob/living/carbon/human/proc/shapeshifter_change_species(var/new_species)
	if(!species)
		return

	dna.species = new_species

	var/list/limb_exists = list(
		BP_TORSO =  0,
		BP_GROIN =  0,
		BP_HEAD =   0,
		BP_L_ARM =  0,
		BP_R_ARM =  0,
		BP_L_LEG =  0,
		BP_R_LEG =  0,
		BP_L_HAND = 0,
		BP_R_HAND = 0,
		BP_L_FOOT = 0,
		BP_R_FOOT = 0
		)
	var/list/wounds_by_limb = list(
		BP_TORSO =  new/list(),
		BP_GROIN =  new/list(),
		BP_HEAD =   new/list(),
		BP_L_ARM =  new/list(),
		BP_R_ARM =  new/list(),
		BP_L_LEG =  new/list(),
		BP_R_LEG =  new/list(),
		BP_L_HAND = new/list(),
		BP_R_HAND = new/list(),
		BP_L_FOOT = new/list(),
		BP_R_FOOT = new/list()
		)

	// Copy damage values
	for(var/limb in organs_by_name)
		var/obj/item/organ/external/O = organs_by_name[limb]
		limb_exists[O.organ_tag] = 1
		wounds_by_limb[O.organ_tag] = O.wounds

	species = GLOB.all_species[new_species]
	species.create_organs(src)
//	species.handle_post_spawn(src)

	for(var/limb in organs_by_name)
		var/obj/item/organ/external/O = organs_by_name[limb]
		if(limb_exists[O.organ_tag])
			O.species = GLOB.all_species[new_species]
			O.wounds = wounds_by_limb[O.organ_tag]
			// sync the organ's damage with its wounds
			O.update_damages()
			O.owner.updatehealth() //droplimb will call updatehealth() again if it does end up being called
		else
			organs.Remove(O)
			organs_by_name.Remove(O)

	spawn(0)
		regenerate_icons()
/* VOREStation Edit - Our own trait system, sorry.
	if(species && mind)
		apply_traits()
*/
	return

/mob/living/carbon/human/proc/shapeshifter_select_eye_colour()

	set name = "Select Eye Color"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/current_color = rgb(r_eyes,g_eyes,b_eyes)
	var/new_eyes = tgui_color_picker(src, "Pick a new color for your eyes.","Eye Color", current_color)
	if(!new_eyes)
		return

	shapeshifter_set_eye_color(new_eyes)

/mob/living/carbon/human/proc/shapeshifter_set_eye_color(var/new_eyes)

	var/list/new_color_rgb_list = hex2rgb(new_eyes)
	// First, update mob vars.
	r_eyes = new_color_rgb_list[1]
	g_eyes = new_color_rgb_list[2]
	b_eyes = new_color_rgb_list[3]
	// Now sync the organ's eye_colour list, if possible
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(istype(eyes))
		eyes.update_colour()

	update_icons_body()
	update_eyes()

/mob/living/carbon/human/proc/shapeshifter_select_ears()
	set name = "Select Ears"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_ear_styles = list("Normal" = null)
	for(var/path in ear_styles_list)
		var/datum/sprite_accessory/ears/instance = ear_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_ear_styles[instance.name] = path

	// Present choice to user
	var/new_ear_style = tgui_input_list(src, "Pick some ears!", "Character Preference", pretty_ear_styles)
	if(!new_ear_style)
		return

	//Set new style
	ear_style = ear_styles_list[pretty_ear_styles[new_ear_style]]

	//Allow color picks
	var/current_pri_color = rgb(r_ears,g_ears,b_ears)

	var/new_pri_color = tgui_color_picker(src, "Pick primary ear color:","Ear Color (Pri)", current_pri_color)
	if(new_pri_color)
		var/list/new_color_rgb_list = hex2rgb(new_pri_color)
		r_ears = new_color_rgb_list[1]
		g_ears = new_color_rgb_list[2]
		b_ears = new_color_rgb_list[3]

		//Indented inside positive primary color choice, don't bother if they clicked cancel
		var/current_sec_color = rgb(r_ears2,g_ears2,b_ears2)

		var/new_sec_color = tgui_color_picker(src, "Pick secondary ear color (only applies to some ears):","Ear Color (sec)", current_sec_color)
		if(new_sec_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_ears2 = new_color_rgb_list[1]
			g_ears2 = new_color_rgb_list[2]
			b_ears2 = new_color_rgb_list[3]

		var/current_ter_color = rgb(r_ears3,g_ears3,b_ears3)

		var/new_ter_color = tgui_color_picker(src, "Pick tertiary ear color (only applies to some ears):","Ear Color (sec)", current_ter_color)
		if(new_ter_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_ears3 = new_color_rgb_list[1]
			g_ears3 = new_color_rgb_list[2]
			b_ears3 = new_color_rgb_list[3]

	var/new_ear_alpha = tgui_input_number(src, "Set ear alpha (0-255):","Ear Alpha", a_ears,255,0)
	if(new_ear_alpha)
		a_ears = new_ear_alpha

	update_hair() //Includes Virgo ears

/mob/living/carbon/human/proc/shapeshifter_select_secondary_ears()
	set name = "Select Secondary Ears"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return
	last_special = world.time + 1 SECONDS

	// Construct the list of names allowed for this user.
	var/list/pretty_ear_styles = list("Normal" = null)
	for(var/path in ear_styles_list)
		var/datum/sprite_accessory/ears/instance = ear_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_ear_styles[instance.name] = path

	// Handle style pick
	var/new_ear_style = tgui_input_list(src, "Pick some ears!", "Character Preference", pretty_ear_styles)
	if(!new_ear_style)
		return
	ear_secondary_style = ear_styles_list[pretty_ear_styles[new_ear_style]]

	// Handle color picks
	if(ear_secondary_style)
		var/list/new_colors = list()
		for(var/channel in 1 to ear_secondary_style.get_color_channel_count())
			var/channel_name = GLOB.fancy_sprite_accessory_color_channel_names[channel]
			var/default = LAZYACCESS(ear_secondary_colors, channel) || "#ffffff"
			var/new_color = tgui_color_picker(src, "Pick [channel_name]", "Ear Color ([channel_name])", default)
			new_colors += new_color || default

	var/new_ear_alpha = tgui_input_number(src, "Set ear alpha (0-255):","Ear Alpha", a_ears2,255,0)
	if(new_ear_alpha)
		a_ears2 = new_ear_alpha

	update_hair()

/mob/living/carbon/human/proc/shapeshifter_select_tail()
	set name = "Select Tail"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_tail_styles = list("Normal" = null)
	for(var/path in tail_styles_list)
		var/datum/sprite_accessory/tail/instance = tail_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_tail_styles[instance.name] = path

	// Present choice to user
	var/new_tail_style = tgui_input_list(src, "Pick a tail!", "Character Preference", pretty_tail_styles)
	if(!new_tail_style)
		return

	//Set new style
	tail_style = tail_styles_list[pretty_tail_styles[new_tail_style]]

	//Allow color picks
	var/current_pri_color = rgb(r_tail,g_tail,b_tail)

	var/new_pri_color = tgui_color_picker(src, "Pick primary tail color:","Tail Color (Pri)", current_pri_color)
	if(new_pri_color)
		var/list/new_color_rgb_list = hex2rgb(new_pri_color)
		r_tail = new_color_rgb_list[1]
		g_tail = new_color_rgb_list[2]
		b_tail = new_color_rgb_list[3]

		//Indented inside positive primary color choice, don't bother if they clicked cancel
		var/current_sec_color = rgb(r_tail2,g_tail2,b_tail2)

		var/new_sec_color = tgui_color_picker(src, "Pick secondary tail color (only applies to some tails):","Tail Color (sec)", current_sec_color)
		if(new_sec_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_tail2 = new_color_rgb_list[1]
			g_tail2 = new_color_rgb_list[2]
			b_tail2 = new_color_rgb_list[3]

		var/current_ter_color = rgb(r_tail3,g_tail3,b_tail3)

		var/new_ter_color = tgui_color_picker(src, "Pick tertiary tail color (only applies to some tails):","Tail Color (sec)", current_ter_color)
		if(new_ter_color)
			new_color_rgb_list = hex2rgb(new_ter_color)
			r_tail3 = new_color_rgb_list[1]
			g_tail3 = new_color_rgb_list[2]
			b_tail3 = new_color_rgb_list[3]

	var/new_tail_alpha = tgui_input_number(src, "Set tail alpha (0-255):","Tail Alpha", a_tail,255,0)
	if(new_tail_alpha)
		a_tail = new_tail_alpha

	update_tail_showing()

/mob/living/carbon/human/proc/shapeshifter_select_wings()
	set name = "Select Wings"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 10
	// Construct the list of names allowed for this user.
	var/list/pretty_wing_styles = list("None" = null)
	for(var/path in wing_styles_list)
		var/datum/sprite_accessory/wing/instance = wing_styles_list[path]
		if((!instance.ckeys_allowed) || (ckey in instance.ckeys_allowed))
			pretty_wing_styles[instance.name] = path

	// Present choice to user
	var/new_wing_style = tgui_input_list(src, "Pick some wings!", "Character Preference", pretty_wing_styles)
	if(!new_wing_style)
		return

	//Set new style
	wing_style = wing_styles_list[pretty_wing_styles[new_wing_style]]

	//Allow color picks
	var/current_color = rgb(r_wing,g_wing,b_wing)

	var/new_color = tgui_color_picker(src, "Pick wing color:","Wing Color", current_color)
	if(new_color)
		var/list/new_color_rgb_list = hex2rgb(new_color)
		r_wing = new_color_rgb_list[1]
		g_wing = new_color_rgb_list[2]
		b_wing = new_color_rgb_list[3]

		//Indented inside positive primary color choice, don't bother if they clicked cancel
		var/current_sec_color = rgb(r_wing2,g_wing2,b_wing2)

		var/new_sec_color = tgui_color_picker(src, "Pick secondary wing color (only applies to some wings):","Wing Color (sec)", current_sec_color)
		if(new_sec_color)
			new_color_rgb_list = hex2rgb(new_sec_color)
			r_wing2 = new_color_rgb_list[1]
			g_wing2 = new_color_rgb_list[2]
			b_wing2 = new_color_rgb_list[3]

		var/current_ter_color = rgb(r_wing3,g_wing3,b_wing3)

		var/new_ter_color = tgui_color_picker(src, "Pick tertiary wing color (only applies to some wings):","Wing Color (sec)", current_ter_color)
		if(new_ter_color)
			new_color_rgb_list = hex2rgb(new_ter_color)
			r_wing3 = new_color_rgb_list[1]
			g_wing3 = new_color_rgb_list[2]
			b_wing3 = new_color_rgb_list[3]

	var/new_alpha = tgui_input_number(src, "Set wing alpha (0-255):","Wing Alpha", a_wing,255,0)
	if(new_alpha)
		a_wing = new_alpha

	update_wing_showing()

/mob/living/carbon/human/proc/promethean_select_opaqueness()

	set name = "Toggle Transparency"
	set category = "Abilities.Shapeshift"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	for(var/obj/item/organ/external/L as anything in src.organs)
		L.transparent = !L.transparent
	visible_message(span_notice("\The [src]'s internal composition seems to change."))
	update_icons_body()
	update_hair()

/mob/living/carbon/human/proc/shapeshifter_change_shape(var/new_species = null, var/visible = TRUE) //not sure if this needs to be moved to a separate file but
	if(!new_species)
		return

	dna.base_species = new_species
	species.base_species = new_species
	wrapped_species_by_ref["\ref[src]"] = new_species
	if (visible)
		visible_message(span_filter_notice(span_bold("\The [src]") + " shifts and contorts, taking the form of \a [new_species]!"))
		regenerate_icons()


//////////////////// Shapeshifter copy-body powers
/// Copied from the protean version, but with some tweaks to match non-protean shapeshifters such as lleill, hanner and replicants

/mob/living/carbon/human/proc/shapeshifter_regenerate()
	set name = "Fully Reform"
	set desc = "Reload your appearance from whatever character slot you have loaded."
	set category = "Abilities.Shapeshift"
	var/mob/living/character = src
	if(temporary_form)
		character = temporary_form
	var/input = tgui_alert(character,{"Do you want to copy the appearance data of your currently loaded save slot?"},"Reformation",list("Reform","Cancel"))
	if(input == "Cancel" || !input)
		return
	else
		input = tgui_alert(character,{"Include Flavourtext?"},"Reformation",list("Yes","No","Cancel"))
		if(input == "Cancel" || !input)
			return
		var/flavour = 0
		if(input == "Yes")
			flavour = 1
		input = tgui_alert(character,{"Include OOC notes?"},"Reformation",list("Yes","No","Cancel"))
		if(input == "Cancel" || !input)
			return
		var/oocnotes = 0
		if(input == "Yes")
			oocnotes = 1
		to_chat(character, span_notify("You begin to reform. You will need to remain still."))
		character.visible_message(span_notify("[character] rapidly contorts and shifts!"), span_danger("You begin to reform."))
		if(do_after(character, 40,exclusive = TASK_ALL_EXCLUSIVE))
			if(character.client.prefs)	//Make sure we didn't d/c
				character.client.prefs.vanity_copy_to(src, FALSE, flavour, oocnotes, FALSE)
				character.visible_message(span_notify("[character] adopts a new form!"), span_danger("You have reformed."))

/mob/living/carbon/human/proc/shapeshifter_copy_body()
	set name = "Copy Form"
	set desc = "If you are aggressively grabbing someone, with their consent, you can turn into a copy of them. (Without their name)."
	set category = "Abilities.Shapeshift"
	var/mob/living/character = src
	if(temporary_form)
		character = temporary_form

	var/grabbing_but_not_enough
	var/mob/living/carbon/human/victim = null
	for(var/obj/item/grab/G in character)
		if(G.state < GRAB_AGGRESSIVE)
			grabbing_but_not_enough = TRUE
			return
		else
			victim = G.affecting
	if (!victim)
		if (grabbing_but_not_enough)
			to_chat(character, span_warning("You need a better grip to do that!"))
		else
			to_chat(character, span_notice("You need to be aggressively grabbing someone before you can copy their form."))
		return
	if (!ishuman(victim))
		to_chat(character, span_warning("You can only perform this on human mobs!"))
		return
	if (!victim.client)
		to_chat(character, span_notice("The person you try this on must have a client!"))
		return


	to_chat(character, span_notice("Waiting for other person's consent."))
	var/consent = tgui_alert(victim, "Allow [src] to copy what you look like?", "Consent", list("Yes", "No"))
	if (consent != "Yes")
		to_chat(character, span_notice("They declined your request."))
		return

	var/input = tgui_alert(character,{"Copy [victim]'s flavourtext?"},"Copy Form",list("Yes","No","Cancel"))
	if(input == "Cancel" || !input)
		return
	var/flavour = 0
	if(input == "Yes")
		flavour = 1

	var/checking = FALSE
	for(var/obj/item/grab/G in character)
		if(G.affecting == victim && G.state >= GRAB_AGGRESSIVE)
			checking = TRUE
	if (!checking)
		to_chat(character, span_warning("You lost your grip on [victim]!"))
		return

	to_chat(character, span_notify("You begin to reassemble into [victim]. You will need to remain still."))
	character.visible_message(span_notify("[character] rapidly contorts and shifts!"), span_danger("You begin to reassemble into [victim]."))
	if(do_after(character, 40,exclusive = TASK_ALL_EXCLUSIVE))
		checking = FALSE
		for(var/obj/item/grab/G in character)
			if(G.affecting == victim && G.state >= GRAB_AGGRESSIVE)
				checking = TRUE
		if (!checking)
			to_chat(character, span_warning("You lost your grip on [victim]!"))
			return
		if(character.client)	//Make sure we didn't d/c
			transform_into_other_human(victim, FALSE, flavour, FALSE)
			character.visible_message(span_notify("[character] adopts the form of [victim]!"), span_danger("You have reassembled into [victim]."))
