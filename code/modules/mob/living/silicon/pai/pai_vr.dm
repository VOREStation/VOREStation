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



//PAI Remove Limb code
/mob/living/silicon/pai/proc/shred_limb()
	set name = "Damage/Remove Prey's Organ"
	set desc = "Severely damages prey's organ. If the limb is already severely damaged, it will be torn off."
	set category = "Abilities"
	if(!ispAI(src))
		return //If you're not a pai you don't have permission to do this.
	var/mob/living/silicon/pai/C = src

	if(last_special > world.time)
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/carbon/human/T = input(src,"Who do you wish to target?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time) return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot target in your current state."
		return

	var/list/choices2 = list()
	for(var/obj/item/organ/O in T.organs) //External organs
		choices2 += O

	var/obj/item/organ/external/D = input(C,"What do you wish to severely damage?") as null|anything in choices2 //D for destroy.
	if(D.vital)
		if(alert("Are you sure you wish to severely damage their [D]? It most likely will kill the prey...",,"Yes", "No") != "Yes")
			return //If they reconsider, don't continue.

	var/list/choices3 = list()
	for(var/obj/item/organ/internal/I in D.internal_organs) //Look for the internal organ in the organ being shreded.
		choices3 += I

	var/obj/item/organ/internal/P = input(C,"Do you wish to severely damage an internal organ, as well? If not, click 'cancel'") as null|anything in choices3

	var/eat_limb = input(C,"Do you wish to swallow the organ if you tear if out? If so, select which stomach.") as null|anything in C.vore_organs  //EXTREMELY EFFICIENT

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(C, "You cannot shred in your current state.")
		return

	last_special = world.time + 450 //45 seconds.
	C.visible_message("<font color='red'><b>[C] appears to be preparing to do something to [T]!</b></font>") //Let everyone know that bad times are head

	if(do_after(C, 450, T)) //Fourty-Five seconds. You don't need a neckgrab for this, so it's going  to take a long while.
		if(!Adjacent(T)) return
		if(P && P.damage >= 25) //Internal organ and it's been severely damage
			T.apply_damage(15, BRUTE, D) //Damage the external organ they're going through.
			P.removed()
			P.forceMove(T.loc) //Move to where prey is.
			log_and_message_admins("tore out [P] of [T].", C)
			if(eat_limb)
				var/datum/belly/S = C.vore_organs[eat_limb]
				P.forceMove(C) //Move to pred's gut
				S.internal_contents |= P //Add to pred's gut.
				C.visible_message("<font color='red'><b>[C] severely damages [D] of [T]!</b></font>") // Same as below, but (pred) damages the (right hand) of (person)
				to_chat(C, "[P] of [T] moves into your [S]!") //Quietly eat their internal organ! Comes out "The (right hand) of (person) moves into your (stomach)
				playsound(C, S.vore_sound, 70, 1)
				log_and_message_admins("tore out and ate [P] of [T].", C)
			else
				log_and_message_admins("tore out [P] of [T].", C)
				C.visible_message("<font color='red'><b>[C] severely damages [D] of [T], resulting in their [P] coming out!</b></font>")
		else if(!P && (D.damage >= 25 || D.brute_dam >= 25)) //Not targeting an internal organ & external organ has been severely damaged already.
			D.droplimb(1,DROPLIMB_EDGE) //Clean cut so it doesn't kill the prey completely.
			if(D.cannot_amputate) //Is it groin/chest? You can't remove those.
				T.apply_damage(25, BRUTE, D)
				C.visible_message("<font color='red'><b>[C] severely damage [T]'s [D]!</b></font>") //Keep it vague. Let the /me's do the talking.
				log_and_message_admins("shreded [T]'s [D].", C)
				return
			if(eat_limb)
				var/datum/belly/S = C.vore_organs[eat_limb]
				D.forceMove(C) //Move to pred's gut
				S.internal_contents |= D //Add to pred's gut.
				C.visible_message("<span class='warning'>[C] swallows [D] of [T] into their [S]!</span>","You swallow [D] of [T]!")
				playsound(C, S.vore_sound, 70, 1)
				to_chat(C, "Their [D] moves into your [S]!")
				log_and_message_admins("tore off and ate [D] of [T].", C)
			else
				C.visible_message("<span class='warning'>[C] tears off [D] of [T]!</span>","You tear out [D] of [T]!") //Will come out "You tear out (the right foot) of (person)
				log_and_message_admins("tore off [T]'s [D].", C)
		else //Not targeting an internal organ w/ > 25 damage , and the limb doesn't have < 25 damage.
			if(P)
				P.damage = 25 //Internal organs can only take damage, not brute damage.
			T.apply_damage(25, BRUTE, D)
			C.visible_message("<font color='red'><b>[C] severely damages [D] of [T]!</b></font>") //Keep it vague. Let the /me's do the talking.
			log_and_message_admins("shreded [D] of [T].", C)
