/datum/power/lleill

// Simple ability to become invisible. Does not phase you out of the world, you can still interact with things and can not pass through walls.
// Essentially the same as traitor cloaking, using the same proc for it.

/datum/power/lleill/invisibility
	name = "Invisibility"
	desc = "Change your appearance to match your surroundings, becoming completely invisible to the naked eye."
	verbpath = /mob/living/carbon/human/proc/lleill_invisibility

/mob/living/carbon/human/proc/lleill_invisibility()
	set name = "Invisibility"
	set desc = "Change your appearance to match your surroundings, becoming completely invisible to the naked eye."
	set category = "Abilities"

	if(stat)
		to_chat(src, "<span class='warning'>You can't go invisible when weakened like this.</span>")
		return

	if(!cloaked)
		cloak()
		to_chat(src, "<span class='warning'>Your fur shimmers and shifts around you, hiding you from the naked eye.</span>")
	else
		uncloak()
		to_chat(src, "<span class='warning'>The brustling of your fur settles down and you become visible once again.</span>")

/mob/living/carbon/human/proc/lleill_select_shape()

	set name = "Select Body Shape"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_species = null
	new_species = tgui_input_list(usr, "Please select a species to emulate.", "Shapeshifter Body", species.get_valid_shapeshifter_forms(src))

	if(!new_species || !GLOB.all_species[new_species] || wrapped_species_by_ref["\ref[src]"] == new_species)
		return
	lleill_change_shape(new_species)

/mob/living/carbon/human/proc/lleill_change_shape(var/new_species = null)
	if(!new_species)
		return

	wrapped_species_by_ref["\ref[src]"] = new_species
	dna.base_species = new_species
	species.base_species = new_species
	visible_message("<b>\The [src]</b> shifts and contorts, taking the form of \a [new_species]!")
	regenerate_icons()

/mob/living/carbon/human/proc/lleill_select_colour()

	set name = "Select Body Colour"
	set category = "Abilities"

	if(stat || world.time < last_special)
		return

	last_special = world.time + 50

	var/new_skin = input(usr, "Please select a new body color.", "Shapeshifter Colour", rgb(r_skin, g_skin, b_skin)) as null|color
	if(!new_skin)
		return
	lleill_set_colour(new_skin)

/mob/living/carbon/human/proc/lleill_set_colour(var/new_skin)

	r_skin =   hex2num(copytext(new_skin, 2, 4))
	g_skin =   hex2num(copytext(new_skin, 4, 6))
	b_skin =   hex2num(copytext(new_skin, 6, 8))
	r_synth = r_skin
	g_synth = g_skin
	b_synth = b_skin

	for(var/obj/item/organ/external/E in organs)
		E.sync_colour_to_human(src)

	regenerate_icons()

