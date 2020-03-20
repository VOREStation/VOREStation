/obj/belly/proc/process_tf(mode, list/touchable_mobs) //We pass mode so it's mega-ultra local.
	/* May not be necessary... Transform only shows up in the panel for humans.
	if(!ishuman(owner))
		return //Need DNA and junk for this.
	*/

	//Cast here for reduced duplication
	var/mob/living/carbon/human/O = owner

	var/stabilize_nutrition = FALSE
	var/changes_eyes = FALSE
	var/changes_hair_solo = FALSE
	var/changes_hairandskin = FALSE
	var/changes_gender = FALSE
	var/changes_gender_to = null
	var/changes_species = FALSE
	var/changes_ears_tail_wing_nocolor = FALSE
	var/changes_ears_tail_wing_color = FALSE
	var/eggs = FALSE

	switch(mode)
		if(DM_TRANSFORM_HAIR_AND_EYES)
			stabilize_nutrition = TRUE
			changes_eyes = TRUE
			changes_hair_solo = TRUE
		if(DM_TRANSFORM_MALE, DM_TRANSFORM_FEMALE, DM_TRANSFORM_MALE_EGG, DM_TRANSFORM_FEMALE_EGG)
			changes_eyes = TRUE
			changes_hairandskin = TRUE
			changes_gender = TRUE
			changes_gender_to = (mode == DM_TRANSFORM_MALE || mode == DM_TRANSFORM_MALE_EGG) ? MALE : FEMALE
			stabilize_nutrition = TRUE
			eggs = (mode == DM_TRANSFORM_MALE_EGG || mode == DM_TRANSFORM_FEMALE_EGG)
		if(DM_TRANSFORM_KEEP_GENDER, DM_TRANSFORM_KEEP_GENDER_EGG)
			changes_eyes = TRUE
			changes_hairandskin = TRUE
			stabilize_nutrition = TRUE
			eggs = (mode == DM_TRANSFORM_KEEP_GENDER_EGG)
		if(DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR, DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG)
			changes_species = TRUE
			changes_ears_tail_wing_nocolor = TRUE
			stabilize_nutrition = TRUE
			eggs = (mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG)
		if(DM_TRANSFORM_REPLICA, DM_TRANSFORM_REPLICA_EGG)
			changes_eyes = TRUE
			changes_hairandskin = TRUE
			changes_species = TRUE
			changes_ears_tail_wing_color = TRUE
			eggs = (mode == DM_TRANSFORM_REPLICA_EGG)
		if(DM_EGG)
			eggs = TRUE

	/* This is designed to do *gradual* transformations.
	 * For each human in the TF belly per cycle, they can only have one "stage" of transformation applied to them.
     * Some transformation modes have different amounts of stages than others and that's okay.
     * All stages in order: Eyes, Hair & Skin, Ears & Tail & Wings & Species, Gender, Egg
     */
	for(var/mob/living/carbon/human/H in touchable_mobs)
		if(H.stat == DEAD)
			continue
		if(stabilize_nutrition)
			if(O.nutrition > 400 && H.nutrition < 400)
				O.nutrition -= 2
				H.nutrition += 1.5
		if(changes_eyes && check_eyes(H))
			change_eyes(H, 1)
			continue
		if(changes_hair_solo && check_hair(H))
			change_hair(H)
			continue
		if(changes_hairandskin && (check_hair(H) || check_skin(H)))
			change_hair(H)
			change_skin(H, 1)
			continue
		if(changes_species)
			if(changes_ears_tail_wing_nocolor && (check_ears(H) || check_tail_nocolor(H) || check_wing_nocolor(H) || check_species(H)))
				change_ears(H)
				change_tail_nocolor(H)
				change_wing_nocolor(H)
				change_species(H, 1, 1) // ,1) preserves coloring
				continue
			if(changes_ears_tail_wing_color && (check_ears(H) || check_tail(H) || check_wing(H) || check_species(H)))
				change_ears(H)
				change_tail(H)
				change_wing(H)
				change_species(H, 1, 2) // ,2) does not preserve coloring.
				continue
		if(changes_gender && check_gender(H, changes_gender_to))
			change_gender(H, changes_gender_to, 1)
			continue
		if(eggs && (!H.absorbed))
			put_in_egg(H, 1)
			continue