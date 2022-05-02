/mob/living/human/dummy
	real_name = "Test Dummy"
	status_flags = CANPUSH
	has_huds = FALSE

/mob/living/human/dummy/mannequin/Initialize()
	. = ..()
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	delete_inventory()

/mob/living/human/skrell/Initialize(var/new_loc)
	h_style = "Skrell Short Tentacles"
	return ..(new_loc, SPECIES_SKRELL)

/mob/living/human/tajaran/Initialize(var/new_loc)
	h_style = "Tajaran Ears"
	return ..(new_loc, SPECIES_TAJ)

/mob/living/human/unathi/Initialize(var/new_loc)
	h_style = "Unathi Horns"
	return ..(new_loc, SPECIES_UNATHI)

/mob/living/human/vox/Initialize(var/new_loc)
	h_style = "Short Vox Quills"
	return ..(new_loc, SPECIES_VOX)

/mob/living/human/diona/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_DIONA)

/mob/living/human/teshari/Initialize(var/new_loc)
	h_style = "Teshari Default"
	return ..(new_loc, SPECIES_TESHARI)

/mob/living/human/promethean/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_PROMETHEAN)

/mob/living/human/zaddat/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_ZADDAT)

/mob/living/human/monkey/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY)

/mob/living/human/farwa/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY_TAJ)

/mob/living/human/neaera/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY_SKRELL)

/mob/living/human/stok/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_MONKEY_UNATHI)

/mob/living/human/event1/Initialize(var/new_loc)
	return ..(new_loc, SPECIES_EVENT1)
