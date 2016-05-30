/datum/species
	//This is used in character setup preview generation (prefences_setup.dm) and human mob
	//rendering (update_icons.dm)
	var/color_mult = 0

	//This is for overriding tail rendering with a specific icon in icobase, for static
	//tails only, since tails would wag when dead if you used this
	var/icobase_tail = 0


	//This is used for egg TF. It decides what type of egg the person will lay when they TF.
	//Default to the normal and bland "egg" just in case a race isn't defined.
	var/egg_type = "egg"

	appearance_flags = HAS_MARKINGS

	//Body markings from appearance.dm on paradise

/mob/living/carbon/human/proc/change_markings(var/marking_style)
	if(!marking_style)
		return

	if(src.m_style == marking_style)
		return

	if(!(marking_style in marking_styles_list))
		return

	src.m_style = marking_style

	update_markings()
	return 1

/mob/living/carbon/human/proc/reset_markings()
	var/list/valid_markings = generate_valid_markings()
	if(valid_markings.len)
		m_style = pick(valid_markings)
	else
		//this shouldn't happen
		m_style = "None"
	update_markings()

/mob/living/carbon/human/proc/generate_valid_markings()
	var/list/valid_markings = new()
	var/obj/item/organ/external/head/H = get_organ("head")
	for(var/marking in marking_styles_list)
		var/datum/sprite_accessory/S = marking_styles_list[marking]

		if(!(species.name in S.species_allowed)) //If the user's head is not of a species the marking style allows, skip it. Otherwise, add it to the list.
			continue
		if(H.species.flags & ALL_RPARTS) //If the user is a species that can have a robotic head...
			var/datum/robolimb/robohead = all_robolimbs[H.model]
			if(!(S.models_allowed && (robohead.company in S.models_allowed))) //Make sure they don't get markings incompatible with their head.
				continue
		valid_markings += marking

	return valid_markings

