/mob/living/silicon/pai
	var/people_eaten = 0
	icon = 'icons/mob/pai_vr.dmi'
	var/global/list/wide_chassis = list(
		"rat",
		"panther"
		)

/mob/living/silicon/pai/proc/pai_nom(var/mob/living/T in oview(1))
	set name = "pAI Nom"
	set category = "pAI Commands"
	set desc = "Allows you to eat someone while unfolded. Can't be used while in card form."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/pai/proc/update_fullness_pai() //Determines if they have something in their stomach. Copied and slightly modified.
	var/new_people_eaten = 0
	for(var/obj/belly/B as anything in vore_organs)
		for(var/mob/living/M in B)
			new_people_eaten += M.size_multiplier
	people_eaten = min(1, new_people_eaten)

/mob/living/silicon/pai/update_icon() //Some functions cause this to occur, such as resting
	..()
	update_fullness_pai()

	if(!people_eaten && !resting)
		icon_state = "[chassis]" //Using icon_state here resulted in quite a few bugs. Chassis is much less buggy.
	else if(!people_eaten && resting)
		icon_state = "[chassis]_rest"

	// Unfortunately not all these states exist, ugh.
	else if(people_eaten && !resting)
		if("[chassis]_full" in cached_icon_states(icon))
			icon_state = "[chassis]_full"
		else
			icon_state = "[chassis]"
	else if(people_eaten && resting)
		if("[chassis]_rest_full" in cached_icon_states(icon))
			icon_state = "[chassis]_rest_full"
		else
			icon_state = "[chassis]_rest"

	if(chassis in wide_chassis)
		icon = 'icons/mob/pai_vr64x64.dmi'
		pixel_x = -16
		vis_height = 64
	else
		icon = 'icons/mob/pai_vr.dmi'
		pixel_x = 0
		vis_height = 32

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

	if(chassis in wide_chassis)
		icon = 'icons/mob/pai_vr64x64.dmi'
		pixel_x = -16
	else
		icon = 'icons/mob/pai_vr.dmi'
		pixel_x = 0
//proc override to avoid pAI players being invisible while the chassis selection window is open
/mob/living/silicon/pai/proc/choose_chassis()
	set category = "pAI Commands"
	set name = "Choose Chassis"
	var/choice

	choice = tgui_input_list(usr, "What would you like to use for your mobile chassis icon?", "Chassis Choice", possible_chassis)
	if(!choice) return
	chassis = possible_chassis[choice]
	verbs |= /mob/living/proc/hide
	update_icon()
// Release belly contents before being gc'd!
/mob/living/silicon/pai/Destroy()
	release_vore_contents()
	return ..()