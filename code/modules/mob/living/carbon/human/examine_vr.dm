/mob/living/carbon/human/proc/examine_weight()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/weight_examine = round(weight)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_he	= "it"
	var/t_his 	= "its"
	var/t_His 	= "Its"
	var/t_is 	= "is"
	var/t_has 	= "has"
	var/t_heavy = "heavy"
	switch(identifying_gender) //Gender is their "real" gender. Identifying_gender is their "chosen" gender.
		if(MALE)
			t_He 	= "He"
			t_he 	= "he"
			t_His 	= "His"
			t_his 	= "his"
			t_heavy = "bulky"
		if(FEMALE)
			t_He 	= "She"
			t_he	= "she"
			t_His 	= "Her"
			t_his 	= "her"
			t_heavy = "curvy"
		if(PLURAL)
			t_He	= "They"
			t_he	= "they"
			t_His 	= "Their"
			t_his 	= "their"
			t_is 	= "are"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_he	= "it"
			t_His 	= "Its"
			t_his 	= "its"
		if(HERM)
			t_He 	= "Shi"
			t_he	= "shi"
			t_His 	= "Hir"
			t_his 	= "hir"
			t_heavy = "curvy"

	switch(weight_examine)
		if(0 to 74)
			message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n"
		if(75 to 99)
			message = "[t_He] [t_has] a very slender frame.\n"
		if(100 to 124)
			message = "[t_He] [t_has] a lightweight, athletic build.\n"
		if(125 to 174)
			message = "[t_He] [t_has] a healthy, average body.\n"
		if(175 to 224)
			message = "[t_He] [t_has] a thick, [t_heavy] physique.\n"
		if(225 to 274)
			message = "[t_He] [t_has] a plush, chubby figure.\n"
		if(275 to 325)
			message = "[t_He] [t_has] an especially plump body with a round potbelly and large hips.\n"
		if(325 to 374)
			message = "[t_He] [t_has] a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs.\n"
		if(375 to 474)
			message = "<span class='warning'>[t_He] [t_is] incredibly obese. [t_His] massive potbelly sags over [t_his] waistline while [t_his] fat ass would probably require two chairs to sit down comfortably!</span>\n"
		else
			message += "<span class='warning'>[t_He] [t_is] so morbidly obese, you wonder how [t_he] can even stand, let alone waddle around the station. [t_He] can't get any fatter without being immobilized.</span>\n"
	return message //Credit to Aronai for helping me actually get this working!

/mob/living/carbon/human/proc/examine_nutrition()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/nutrition_examine = round(nutrition)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_His 	= "Its"
	var/t_his 	= "its"
	var/t_is 	= "is"
	var/t_has 	= "has"
	switch(identifying_gender)
		if(MALE)
			t_He 	= "He"
			t_his 	= "his"
			t_His 	= "His"
		if(FEMALE)
			t_He 	= "She"
			t_his 	= "her"
			t_His 	= "Her"
		if(PLURAL)
			t_He  	= "They"
			t_his 	= "their"
			t_His 	= "Their"
			t_is	= "are"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_his 	= "its"
			t_His	= "Its"
		if(HERM)
			t_He 	= "Shi"
			t_his 	= "hir"
			t_His 	= "Hir"
	switch(nutrition_examine)
		if(0 to 49)
			message = "<span class='warning'>[t_He] [t_is] starving! You can hear [t_his] stomach snarling from across the room!</span>\n"
		if(50 to 99)
			message = "<span class='warning'>[t_He] [t_is] extremely hungry. A deep growl occasionally rumbles from [t_his] empty stomach.</span>\n"
		if(100 to 499)
			return message //Well that's pretty normal, really.
		if(500 to 999) // Fat.
			message = "[t_He] [t_has] a stuffed belly, bloated fat and round from eating too much.\n"
		if(1000 to 1399)
			message = "[t_He] [t_has] a rotund, thick gut. It bulges from their body obscenely, close to sagging under its own weight.\n"
		if(1400 to 1934) // One person fully digested.
			message = "<span class='warning'>[t_He] [t_is] sporting a large, round, sagging stomach. It's contains at least their body weight worth of glorping slush.</span>\n"
		if(1935 to 3004) // Two people.
			message = "<span class='warning'>[t_He] [t_is] engorged with a huge stomach that sags and wobbles as they move. [t_He] must have consumed at least twice their body weight. It looks incredibly soft.</span>\n"
		if(3005 to 4074) // Three people.
			message = "<span class='warning'>[t_His] stomach is firmly packed with digesting slop. [t_He] must have eaten at least a few times worth their body weight! It looks hard for them to stand, and [t_his] gut jiggles when they move.</span>\n"
		if(4075 to INFINITY) // Four or more people.
			message = "<span class='warning'>[t_He] [t_is] so absolutely stuffed that you aren't sure how it's possible to move. [t_He] can't seem to swell any bigger. The surface of [t_his] belly looks sorely strained!</span>\n"
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

	return FALSE

/mob/living/carbon/human/proc/examine_pickup_size(mob/living/H)
	var/message = ""
	if(istype(H) && (H.get_effective_size() - src.get_effective_size()) >= 0.50)
		message = "<font color='blue'>They are small enough that you could easily pick them up!</font>\n"
	return message

/mob/living/carbon/human/proc/examine_step_size(mob/living/H)
	var/message = ""
	if(istype(H) && (H.get_effective_size() - src.get_effective_size()) >= 0.75)
		message = "<font color='red'>They are small enough that you could easily trample them!</font>\n"
	return message

/mob/living/carbon/human/proc/examine_nif(mob/living/carbon/human/H)
	if(nif && nif.examine_msg) //If you have one set, anyway.
		return "<span class='notice'>[nif.examine_msg]</span>\n"

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
			return "<span class='warning'>[t_His] body is twitching subtly.</span>\n"
		else
			return "<span class='notice'>[t_He] [t_appear] to be in some sort of torpor.</span>\n"
	if(feral)
		return "<span class='warning'>[t_He] [t_has] a crazed, wild look in [t_his] eyes!</span>\n"