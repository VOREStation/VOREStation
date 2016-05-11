/obj/machinery/bodyscanner/proc/get_occupant_data_vr(list/incoming,mob/living/carbon/human/H)
	var/humanprey = 0
	var/livingprey = 0
	var/objectprey = 0

	for(var/I in H.vore_organs)
		var/datum/belly/B = H.vore_organs[I]
		for(var/C in B.internal_contents)
			if(ishuman(C))
				humanprey++
			else if(isliving(C))
				livingprey++
			else
				objectprey++

	incoming["livingprey"] = livingprey
	incoming["humanprey"] = humanprey
	incoming["objectprey"] = objectprey
	incoming["weight"] = H.weight

	return incoming

/obj/machinery/body_scanconsole/proc/format_occupant_data_vr(list/incoming)
	var/message = ""

	message += text("Body Weight (to scale): [incoming["weight"]]lbs / [incoming["weight"] / 2.20463]kg<br><HR>")

	if(incoming["livingprey"] || incoming["humanprey"] || incoming["objectprey"])
		message += text("<font color='red'>Foreign bodies detected:<br>[incoming["humanprey"] ? "- [incoming["humanprey"]] humanoid(s)<br>" : ""][incoming["livingprey"] ? "- [incoming["humanprey"]] non-humanoid(s)<br>" : ""][incoming["objectprey"] ? "- [incoming["humanprey"]] object(s)<br>" : ""]</font><hr>")

	return message