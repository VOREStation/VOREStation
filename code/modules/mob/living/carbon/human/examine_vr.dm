/mob/living/carbon/human/examine/proc/examine_weight(mob/user)
	var/message = null

	if(weight < 75)
		message = "\red [T.He] [T.is] terribly lithe and frail!\n"
	else if(weight >= 75 && weight < 100)
		message = "[T.He] has a very slender frame.\n"
	else if(weight >= 100 && weight < 125)
		message = "[T.He] has a lightweight, athletic build.\n"
	else if(weight >= 125 && weight < 175)
		message = "[T.He] has a healthy, average body.\n"
	else if(weight >= 175 && weight < 225)
		message = "[T.He] has a thick, heavy physique.\n"
	else if(weight >= 225 && weight < 275)
		message = "[T.He] has a plush, chubby figure.\n"
	else if(weight >= 275 && weight < 325)
		message = "[T.He] has an especially plump body with a round potbelly and large hips.\n"
	else if(weight >= 325 && weight < 375)
		message = "[T.He] has a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs.\n"
	else if(weight >= 375 && weight < 475)
		message = "\red [T.He] [T.is] incredibly obese. [T.his] massive potbelly sags over [T.his] waistline while [T.his] fat ass would probably require two chairs to sit down comfortably!\n"
	else if(weight >= 475)
		message = "\red [T.He] [T.is] so morbidly obese, you wonder how they can even stand, let alone waddle around the station. [T.He] can't get any fatter without being immobilized.\n"
	return message