/mob/living/carbon/human/proc/examine_weight()
	if(!show_pudge() || !weight_message_visible) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/weight_examine = round(weight)
	switch(weight_examine)
		if(0 to 74)
			message = weight_messages[1]
		if(75 to 99)
			message = weight_messages[2]
		if(100 to 124)
			message = weight_messages[3]
		if(125 to 174)
			message = weight_messages[4]
		if(175 to 224)
			message = weight_messages[5]
		if(225 to 274)
			message = weight_messages[6]
		if(275 to 325)
			message = weight_messages[7]
		if(325 to 374)
			message = weight_messages[8]
		if(375 to 474)
			message = weight_messages[9]
		else
			message = weight_messages[10]
	if(message)
		message = "<span class='notice'>[message]</span>"
	return message //Credit to Aronai for helping me actually get this working!

/mob/living/carbon/human/proc/examine_nutrition()
	if(!show_pudge() || !nutrition_message_visible) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/nutrition_examine = round(nutrition)
	switch(nutrition_examine)
		if(0 to 49)
			message = nutrition_messages[1]
		if(50 to 99)
			message = nutrition_messages[2]
		if(100 to 499)
			message = nutrition_messages[3]
		if(500 to 999) // Fat.
			message = nutrition_messages[4]
		if(1000 to 1399)
			message = nutrition_messages[5]
		if(1400 to 1934) // One person fully digested.
			message = nutrition_messages[6]
		if(1935 to 3004) // Two people.
			message = nutrition_messages[7]
		if(3005 to 4074) // Three people.
			message = nutrition_messages[8]
		if(4075 to 5124) // Four people.
			message = nutrition_messages[9]
		if(5125 to INFINITY) // More.
			message = nutrition_messages[10]
	if(message)
		message = "<span class='notice'>[message]</span>"
	return message

//For OmniHUD records access for appropriate models
/proc/hasHUD_vr(mob/living/carbon/human/H, hudtype)
	if(H.nif)
		switch(hudtype)
			if("security")
				if(H.nif.flag_check(NIF_V_AR_SECURITY,NIF_FLAGS_VISION))
					return TRUE
			if("medical")
				if(H.nif.flag_check(NIF_V_AR_MEDICAL,NIF_FLAGS_VISION))
					return TRUE

	if(istype(H.glasses, /obj/item/clothing/glasses/omnihud))
		var/obj/item/clothing/glasses/omnihud/omni = H.glasses
		switch(hudtype)
			if("security")
				if(omni.mode == "sec" || omni.mode == "best")
					return TRUE
			if("medical")
				if(omni.mode == "med" || omni.mode == "best")
					return TRUE
			if("best")
				if(omni.mode == "best")
					return TRUE

	return FALSE

/mob/living/carbon/human/proc/examine_pickup_size(mob/living/H)
	var/message = ""
	if(istype(H) && (H.get_effective_size(FALSE) - src.get_effective_size(TRUE)) >= 0.50)
		message = "<font color='blue'>They are small enough that you could easily pick them up!</font>"
	return message

/mob/living/carbon/human/proc/examine_step_size(mob/living/H)
	var/message = ""
	if(istype(H) && (H.get_effective_size(FALSE) - src.get_effective_size(TRUE)) >= 0.75)
		message = "<font color='red'>They are small enough that you could easily trample them!</font>"
	return message

/mob/living/carbon/human/proc/examine_nif(mob/living/carbon/human/H)
	if(nif && nif.examine_msg) //If you have one set, anyway.
		return "<span class='notice'>[nif.examine_msg]</span>"

/mob/living/carbon/human/proc/examine_chimera(mob/living/carbon/human/H)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_his 	= "its"
	var/t_His 	= "Its"
	var/t_appear 	= "appears"
	var/t_has 	= "has"
	switch(identifying_gender) //Gender is their "real" gender. Identifying_gender is their "chosen" gender.
		if(MALE)
			t_He 	= "He"
			t_His 	= "His"
			t_his 	= "his"
		if(FEMALE)
			t_He 	= "She"
			t_His 	= "Her"
			t_his 	= "her"
		if(PLURAL)
			t_He	= "They"
			t_His 	= "Their"
			t_his 	= "their"
			t_appear 	= "appear"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_His 	= "Its"
			t_his 	= "its"
		if(HERM)
			t_He 	= "Shi"
			t_His 	= "Hir"
			t_his 	= "hir"
	if(revive_ready == REVIVING_NOW || revive_ready == REVIVING_DONE)
		if(stat == DEAD)
			return "<span class='warning'>[t_His] body is twitching subtly.</span>"
		else
			return "<span class='notice'>[t_He] [t_appear] to be in some sort of torpor.</span>"
	if(feral)
		return "<span class='warning'>[t_He] [t_has] a crazed, wild look in [t_his] eyes!</span>"
