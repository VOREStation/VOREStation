/proc/create_new_xenomorph(var/alien_caste,var/target)

	target = get_turf(target)
	if(!target || !alien_caste) return

	var/mob/living/carbon/human/new_alien = new(target)
	new_alien.set_species("Xenomorph [alien_caste]")
	return new_alien

/mob/living/carbon/human/xdrone/New(var/new_loc)
	h_style = "Bald"
	faction = "xeno"
	..(new_loc, SPECIES_XENO_DRONE)

/mob/living/carbon/human/xsentinel/New(var/new_loc)
	h_style = "Bald"
	faction = "xeno"
	..(new_loc, SPECIES_XENO_SENTINEL)

/mob/living/carbon/human/xhunter/New(var/new_loc)
	h_style = "Bald"
	faction = "xeno"
	..(new_loc, SPECIES_XENO_HUNTER)

/mob/living/carbon/human/xqueen/New(var/new_loc)
	h_style = "Bald"
	faction = "xeno"
	..(new_loc, SPECIES_XENO_QUEEN)

//Removed AddInfectionImages, no longer required.
