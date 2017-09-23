/mob/living/silicon/pai
	var/people_eaten = 0
	icon = 'icons/mob/pai_vr.dmi'

/mob/living/silicon/pai/proc/pai_nom(var/mob/living/T in oview(1))
	set name = "pAI Nom"
	set category = "pAI Commands"
	set desc = "Allows you to eat someone while unfolded. Can't be used while in card form."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/pai/proc/update_fullness_pai() //Determines if they have something in their stomach. Copied and slightly modified.
	var/new_people_eaten = 0
	for(var/I in vore_organs)
		var/datum/belly/B = vore_organs[I]
		for(var/mob/living/M in B.internal_contents)
			new_people_eaten += M.size_multiplier
	people_eaten = min(1, new_people_eaten)


/mob/living/silicon/pai/update_icon() //Some functions cause this to occur, such as resting
	..()
	update_fullness_pai()
	if(!people_eaten && !resting)
		icon_state = "[chassis]" //Using icon_state here resulted in quite a few bugs. Chassis is much less buggy.
	else if(!people_eaten && resting)
		icon_state = "[chassis]_rest"
	else if(people_eaten && !resting)
		icon_state = "[chassis]_full"
	else if(people_eaten && resting)
		icon_state = "[chassis]_rest_full"

/mob/living/silicon/pai/update_icons() //And other functions cause this to occur, such as digesting someone.
	..()
	update_fullness_pai()
	if(!people_eaten && !resting)
		icon_state = "[chassis]"
	else if(!people_eaten && resting)
		icon_state = "[chassis]_rest"
	else if(people_eaten && !resting)
		icon_state = "[chassis]_full"
	else if(people_eaten && resting)
		icon_state = "[chassis]_rest_full"

/mob/living/silicon/pai/proc/examine_bellies_pai()

	var/message = ""
	for (var/I in src.vore_organs)
		var/datum/belly/B = vore_organs[I]
		message += B.get_examine_msg()

	return message