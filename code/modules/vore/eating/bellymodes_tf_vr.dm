/obj/belly/proc/process_tf(var/mode,var/list/touchable_mobs) //We pass mode so it's mega-ultra local.
	/* May not be necessary... Transform only shows up in the panel for humans.
	if(!ishuman(owner))
		return //Need DNA and junk for this.
	*/

	//Cast here for reduced duplication
	var/mob/living/carbon/human/O = owner

///////////////////////////// DM_TRANSFORM_HAIR_AND_EYES /////////////////////////////
	if(mode == DM_TRANSFORM_HAIR_AND_EYES)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P) || check_hair(P))
				change_eyes(P)
				change_hair(P,1)

///////////////////////////// DM_TRANSFORM_MALE /////////////////////////////
	else if(mode == DM_TRANSFORM_MALE)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,MALE))
				change_gender(P,MALE,1)

///////////////////////////// DM_TRANSFORM_FEMALE /////////////////////////////
	else if(mode == DM_TRANSFORM_FEMALE)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,FEMALE))
				change_gender(P,FEMALE,1)

///////////////////////////// DM_TRANSFORM_KEEP_GENDER  /////////////////////////////
	else if(mode == DM_TRANSFORM_KEEP_GENDER)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR  /////////////////////////////
	else if(mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_ears(P) || check_tail_nocolor(P) || check_wing_nocolor(P) || check_species(P))
				change_ears(P)
				change_tail_nocolor(P)
				change_wing_nocolor(P)
				change_species(P,1)

///////////////////////////// DM_TRANSFORM_REPLICA /////////////////////////////
	else if(mode == DM_TRANSFORM_REPLICA)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(O.nutrition > 400 && P.nutrition < 400)
				O.nutrition -= 2
				P.nutrition += 1.5

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_ears(P) || check_tail(P) || check_wing(P) || check_species(P))
				change_ears(P)
				change_tail(P)
				change_wing(P)
				change_species(P,1)

///////////////////////////// DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG /////////////////////////////
	else if(mode == DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(check_ears(P) || check_tail_nocolor(P) || check_wing_nocolor(P)|| check_species(P))
				change_ears(P)
				change_tail_nocolor(P)
				change_wing_nocolor(P)
				change_species(P,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_TRANSFORM_KEEP_GENDER_EGG  /////////////////////////////
	else if(mode == DM_TRANSFORM_KEEP_GENDER_EGG)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_TRANSFORM_REPLICA_EGG /////////////////////////////
	else if(mode == DM_TRANSFORM_REPLICA_EGG)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_ears(P) || check_tail(P) || check_wing(P) || check_species(P))
				change_ears(P)
				change_tail(P)
				change_wing(P)
				change_species(P,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_TRANSFORM_MALE_EGG /////////////////////////////
	else if(mode == DM_TRANSFORM_MALE_EGG)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,MALE))
				change_gender(P,MALE,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_TRANSFORM_FEMALE_EGG /////////////////////////////
	else if(mode == DM_TRANSFORM_FEMALE_EGG)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.stat == DEAD)
				continue

			if(check_eyes(P))
				change_eyes(P,1)
				continue

			if(check_hair(P) || check_skin(P))
				change_hair(P)
				change_skin(P,1)
				continue

			if(check_gender(P,MALE))
				change_gender(P,MALE,1)
				continue

			if(!P.absorbed)
				put_in_egg(P,1)

///////////////////////////// DM_EGG /////////////////////////////
	else if(mode == DM_EGG)
		for (var/mob/living/carbon/human/P in touchable_mobs)
			if(P.absorbed || P.stat == DEAD)
				continue

			put_in_egg(P,1)

