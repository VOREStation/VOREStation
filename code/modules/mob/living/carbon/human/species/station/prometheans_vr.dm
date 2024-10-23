/datum/species/shapeshifter/promethean
	min_age = 18 //Required for server rules
	max_age = 80
	push_flags = ~HEAVY
	swap_flags = ~HEAVY
	gluttonous = 0
	water_damage_mod = 0		//No water damage
	valid_transform_species = list(
		"Human", "Unathi", "Tajara", "Skrell",
		"Diona", "Teshari", "Monkey","Sergal",
		"Akula","Nevrean","Zorren",
		"Fennec", "Vulpkanin", "Vasilissan",
		"Rapala", "Neaera", "Stok", "Farwa", "Sobaka",
		"Wolpin", "Saru", "Sparra")

	spawn_flags = SPECIES_CAN_JOIN
	wikilink="https://wiki.vore-station.net/Promethean"
	genders = list(MALE, FEMALE, PLURAL, NEUTER)
	color_mult = 1
	mob_size = MOB_MEDIUM //As of writing, original was MOB_SMALL - Allows normal swapping
	//var/mob/living/simple_mob/slime/promethean/stored_blob = null
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_HAIR_COLOR | RADIATION_GLOWS | HAS_UNDERWEAR

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/regenerate,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/prommie_blobform,
		/mob/living/proc/set_size,
		/mob/living/carbon/human/proc/promethean_select_opaqueness,
		)

/mob/living/carbon/human/proc/prommie_blobform()
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities"
	set hidden = FALSE

	var/atom/movable/to_locate = temporary_form || src
	if(!isturf(to_locate.loc))
		to_chat(to_locate,span_warning("You need more space to perform this action!"))
		return
	/*
	//Blob form
	if(temporary_form)
		if(temporary_form.stat)
			to_chat(temporary_form,span_warning("You can only do this while not stunned."))
		else
			prommie_outofblob(temporary_form)
	*/
	//Human form
	else if(stat || paralysis || stunned || weakened || restrained())
		to_chat(src,span_warning("You can only do this while not stunned."))
		return
	else
		prommie_intoblob()

/datum/species/shapeshifter/promethean/handle_death(var/mob/living/carbon/human/H)
	if(!H)
		return // Iono!

	if(H.temporary_form)
		H.forceMove(H.temporary_form.drop_location())
		H.ckey = H.temporary_form.ckey
		QDEL_NULL(H.temporary_form)
	//else if(H.stored_blob) // Should prevent phantom blobs in the aether. I don't anticipate this being an issue, but if it is just uncomment.
	//	qdel(stored_blob)
	//	stored_blob = null

	spawn(1)
		if(H)
			H.gib()
