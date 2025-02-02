/datum/species/shapeshifter
	base_species = SPECIES_HUMAN
	selects_bodytype = SELECTS_BODYTYPE_SHAPESHIFTER

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
	if (!istype(victim))
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
