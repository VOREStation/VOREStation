/mob/living/carbon/human/proc/examine_weight()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/weight_examine = round(weight)
	var/datum/gender/G = gender_datums[get_visible_gender()]
	var/t_heavy = "heavy"
	switch(get_gender()) // NOT get_visible_gender
		if(MALE)
			t_heavy = "bulky"
		if(FEMALE)
			t_heavy = "curvy"
		if(HERM)
			t_heavy = "curvy"

	switch(weight_examine)
		if(0 to 74)
			message = "<span class='warning'>[G.He] [G.is] terribly lithe and frail!</span>"
		if(75 to 99)
			message = "[G.He] [G.has] a very slender frame."
		if(100 to 124)
			message = "[G.He] [G.has] a lightweight, athletic build."
		if(125 to 174)
			message = "[G.He] [G.has] a healthy, average body."
		if(175 to 224)
			message = "[G.He] [G.has] a thick, [t_heavy] physique."
		if(225 to 274)
			message = "[G.He] [G.has] a plush, chubby figure."
		if(275 to 325)
			message = "[G.He] [G.has] an especially plump body with a round potbelly and large hips."
		if(325 to 374)
			message = "[G.He] [G.has] a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs."
		if(375 to 474)
			message = "<span class='warning'>[G.He] [G.is] incredibly obese. [G.His] massive potbelly sags over [G.his] waistline while [G.his] fat ass would probably require two chairs to sit down comfortably!</span>"
		else
			message += "<span class='warning'>[G.He] [G.is] so morbidly obese, you wonder how [G.he] can even stand, let alone waddle around the station. [G.He] can't get any fatter without being immobilized.</span>"
	return message //Credit to Aronai for helping me actually get this working!

/mob/living/carbon/human/proc/examine_nutrition()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/nutrition_examine = round(nutrition)
	var/datum/gender/G = gender_datums[get_visible_gender()]
	switch(nutrition_examine)
		if(0 to 49)
			message = "<span class='warning'>[G.He] [G.is] starving! You can hear [G.his] stomach snarling from across the room!</span>"
		if(50 to 99)
			message = "<span class='warning'>[G.He] [G.is] extremely hungry. A deep growl occasionally rumbles from [G.his] empty stomach.</span>"
		if(100 to 499)
			return message //Well that's pretty normal, really.
		if(500 to 999) // Fat.
			message = "[G.He] [G.has] a stuffed belly, bloated fat and round from eating too much."
		if(1000 to 1399)
			message = "[G.He] [G.has] a rotund, thick gut. It bulges from their body obscenely, close to sagging under its own weight."
		if(1400 to 1934) // One person fully digested.
			message = "<span class='warning'>[G.He] [G.is] sporting a large, round, sagging stomach. It's contains at least their body weight worth of glorping slush.</span>"
		if(1935 to 3004) // Two people.
			message = "<span class='warning'>[G.He] [G.is] engorged with a huge stomach that sags and wobbles as they move. [G.He] must have consumed at least twice their body weight. It looks incredibly soft.</span>"
		if(3005 to 4074) // Three people.
			message = "<span class='warning'>[G.His] stomach is firmly packed with digesting slop. [G.He] must have eaten at least a few times worth their body weight! It looks hard for them to stand, and [G.his] gut jiggles when they move.</span>"
		if(4075 to INFINITY) // Four or more people.
			message = "<span class='warning'>[G.He] [G.is] so absolutely stuffed that you aren't sure how it's possible to move. [G.He] can't seem to swell any bigger. The surface of [G.his] belly looks sorely strained!</span>"
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
		message = "<font color='blue'>They are small enough that you could easily pick them up!</font>"
	return message

/mob/living/carbon/human/proc/examine_step_size(mob/living/H)
	var/message = ""
	if(istype(H) && (H.get_effective_size() - src.get_effective_size()) >= 0.75)
		message = "<font color='red'>They are small enough that you could easily trample them!</font>"
	return message

/mob/living/carbon/human/proc/examine_nif(mob/living/carbon/human/H)
	if(nif && nif.examine_msg) //If you have one set, anyway.
		return "<span class='notice'>[nif.examine_msg]</span>"

/mob/living/carbon/human/proc/examine_chimera(mob/living/carbon/human/H)
	var/datum/gender/G = gender_datums[get_visible_gender()]
	if(revive_ready == REVIVING_NOW || revive_ready == REVIVING_DONE)
		if(stat == DEAD)
			return "<span class='warning'>[G.His] body is twitching subtly.</span>"
		else
			return "<span class='notice'>[G.He] appear[G.s] to be in some sort of torpor.</span>"
	if(feral)
		return "<span class='warning'>[G.He] [G.has] a crazed, wild look in [G.his] eyes!</span>"