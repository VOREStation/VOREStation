/mob/living/carbon/human/proc/examine_weight()
	var/message = ""
	var/weight_examine = round(weight)
	switch(weight_examine)
		if(0 to 74)
			message = "<span class='warning'>They are terribly lithe and frail!</span>\n"
		if(75 to 99)
			message = "They have a very slender frame.\n"
		if(100 to 124)
			message = "They have a lightweight, athletic build.\n"
		if(125 to 174)
			message = "They have a healthy, average body.\n"
		if(175 to 224)
			message = "They have a thick, heavy physique.\n"
		if(225 to 274)
			message = "They have a plush, chubby figure.\n"
		if(275 to 325)
			message = "They have an especially plump body with a round potbelly and large hips.\n"
		if(325 to 374)
			message = "They have a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs.\n"
		if(375 to 474)
			message = "<span class='warning'>They are incredibly obese. Their massive potbelly sags over their waistline while their fat ass would probably require two chairs to sit down comfortably!</span>\n"
		else
			message += "<span class='warning'>They are so morbidly obese, you wonder how they can even stand, let alone waddle around the station. They can't get any fatter without being immobilized.</span>\n"
	return message //Credit to Aronai for helping me actually get this working!

/mob/living/carbon/human/proc/examine_nutrition()
	var/message = ""
	var/nutrition_examine = round(nutrition)
	switch(nutrition_examine)
		if(0 to 49)
			message = "<span class='warning'>They are starving! You can hear their stomach snarling from across the room!</span>\n"
		if(50 to 99)
			message = "<span class='warning'>They are extremely hungry. A deep growl occasionally rumbles from their empty stomach.</span>\n"
		if(100 to 499)
			return message //Well that's pretty normal, really.
		if(500 to 864) // Fat.
			message = "They have a stuffed belly, bloated fat and round from eating too much.\n"
		if(1200 to 1934) // One person fully digested.
			message = "<span class='warning'>They are sporting a large, round, sagging stomach. It's contains at least their body weight worth of glorping slush.</span>\n"
		if(1935 to 3004) // Two people.
			message = "<span class='warning'>They are engorged with a huge stomach that sags and wobbles as they move. They must have consumed at least twice their body weight. It looks incredibly soft.</span>\n"
		if(3005 to 4074) // Three people.
			message = "<span class='warning'>Their stomach is firmly packed with digesting slop. They must have eaten at least a few times worth their body weight! It looks hard for them to stand, and their gut jiggles when they move.</span>\n"
		if(4075 to 10000) // Four or more people.
			message = "<span class='warning'>They are so absolutely stuffed that you aren't sure how it's possible to move. They can't seem to swell any bigger. The surface of their belly looks sorely strained!</span>\n"
	return message

/mob/living/carbon/human/proc/examine_bellies()
	var/message = ""

	for (var/I in src.vore_organs)
		var/datum/belly/B = vore_organs[I]
		message += B.get_examine_msg()

	return message