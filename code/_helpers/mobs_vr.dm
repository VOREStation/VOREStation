proc/GetOppositeDir(var/dir)
	switch(dir)
		if(NORTH)     return SOUTH
		if(SOUTH)     return NORTH
		if(EAST)      return WEST
		if(WEST)      return EAST
		if(SOUTHWEST) return NORTHEAST
		if(NORTHWEST) return SOUTHEAST
		if(NORTHEAST) return SOUTHWEST
		if(SOUTHEAST) return NORTHWEST
	return 0


proc/random_head_accessory(species = "Human")
	var/ha_style = "None"
	var/list/valid_head_accessories = list()
	for(var/head_accessory in head_accessory_styles_list)
		var/datum/sprite_accessory/S = head_accessory_styles_list[head_accessory]

		if(!(species in S.species_allowed))
			continue
		valid_head_accessories += head_accessory

	if(valid_head_accessories.len)
		ha_style = pick(valid_head_accessories)

	return ha_style

proc/random_marking_style(var/location = "body", species = "Human", var/datum/robolimb/robohead, var/body_accessory, var/alt_head)
	var/m_style = "None"
	var/list/valid_markings = list()
	for(var/marking in marking_styles_list)
		var/datum/sprite_accessory/body_markings/S = marking_styles_list[marking]
		if(S.name == "None")
			valid_markings += marking
			continue
		if(S.marking_location != location) //If the marking isn't for the location we desire, skip.
			continue
		if(!(species in S.species_allowed)) //If the user's head is not of a species the marking style allows, skip it. Otherwise, add it to the list.
			continue
		if(location == "tail")
			if(!body_accessory)
				if(S.tails_allowed)
					continue
			else
				if(!S.tails_allowed || !(body_accessory in S.tails_allowed))
					continue
		if(location == "head")
			var/datum/sprite_accessory/body_markings/head/M = marking_styles_list[S.name]
			if(species == "Machine")//If the user is a species that can have a robotic head...
				if(!robohead)
					robohead = all_robolimbs["Morpheus Cyberkinetics"]
				if(!(S.models_allowed && (robohead.company in S.models_allowed))) //Make sure they don't get markings incompatible with their head.
					continue
			else if(alt_head && alt_head != "None") //If the user's got an alt head, validate markings for that head.
				if(!("All" in M.heads_allowed) && !(alt_head in M.heads_allowed))
					continue
			else
				if(M.heads_allowed && !("All" in M.heads_allowed))
					continue
		valid_markings += marking

	if(valid_markings.len)
		m_style = pick(valid_markings)

	return m_style

proc/random_body_accessory(species = "Vulpkanin")
	var/body_accessory = null
	var/list/valid_body_accessories = list()
	for(var/B in body_accessory_by_name)
		var/datum/body_accessory/A = body_accessory_by_name[B]
		if(!istype(A))
			valid_body_accessories += "None" //The only null entry should be the "None" option.
			continue
		if(species in A.allowed_species) //If the user is not of a species the body accessory style allows, skip it. Otherwise, add it to the list.
			valid_body_accessories += B

	if(valid_body_accessories.len)
		body_accessory = pick(valid_body_accessories)

	return body_accessory

