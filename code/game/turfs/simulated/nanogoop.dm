GLOBAL_LIST_BOILERPLATE(nanite_turfs, /turf/simulated/floor/water/digestive_enzymes/nanites)

//half of this code is ripped from digestive enzymes themselves, with runtimes and such trimmed
/turf/simulated/floor/water/digestive_enzymes/nanites //i just wanted to map, why has it come to making such terrible crimes against humanity
	name = "nanite-infested tiles."
	desc = "This section of reinforced plating appears to host a colony of nanites between the tiles"
	icon = 'icons/turf/nanitegoo.dmi'
	icon_state = "composite"
	water_icon = 'icons/turf/nanitegoo.dmi'
	water_state = "goo_inactive"
	under_state = "reinforced"
	depth = 0
	movement_cost = 0
	mobstuff = FALSE
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	watercolor = "black"
	reagent_type = REAGENT_ID_LIQUIDPROTEAN
	oxygen		= MOLES_O2STANDARD
	nitrogen	= MOLES_N2STANDARD
	temperature = T20C
	var/digesting = FALSE
	var/digest_synth = FALSE
	var/digest_robot = FALSE
	var/active = FALSE
	var/usesmes = TRUE
	var/datum/weakref/moblink
	var/datum/weakref/linkedsmes //when the nanites digest something, it becomes power in an SMES
	var/id = null


/turf/simulated/floor/water/digestive_enzymes/nanites/Initialize(mapload)
	. = ..()
	for(var/obj/machinery/power/smes/M in GLOB.smeses)
		if(!M)
			continue
		if(!get_area(M))
			continue
		if(get_area(M) == get_area(src))
			linkedsmes = WEAKREF(M)

/turf/simulated/floor/water/digestive_enzymes/nanites/attack_hand(mob/user)
	var/mob/living/nutrienttarget = moblink?.resolve()
	var/obj/machinery/power/smes/smes = linkedsmes?.resolve()
	if(check_target() && (user != nutrienttarget))//prioritize this here, so mobs can turn the turf off
		return ..()
	if(ishuman(user))
		if(smes || isAI(nutrienttarget))
			return ..()
		var/mob/living/carbon/human/H = user
		if(H.nif)//Proteans have NIFS
			var/choice1 = tgui_input_list(user, "Do you wish interface with \the [src]", "Desired state", list("On", "Off"))
			switch(choice1)
				if("On")
					var/choice2 = tgui_input_list(user, "Which entities do you wish for \the [src] to recycle?", "Desired targets", list("None", "All", "Organics and Cyborgs", "Organics and Synthetics", "Only Organics"))
					if(H.isSynthetic())
						to_chat(H, span_warning("With you in control, \the [src] will not attempt to recycle your body, no matter the setting you pick"))
					else
						to_chat(H, span_warning("You realize there is no way for the simplistic [src] to ignore your form, if you set it to recycle."))
					user.visible_message(span_warning("\The [user] inspects \the [src]"), span_warning("You begin to interface with \the [src]."))
					if(do_after(user, 30, src))
						nutrienttarget = user
						switch(choice2)
							if("None")
								nutrienttarget = user
								toggle_all(TRUE)
							if("All")
								nutrienttarget = user
								toggle_all(TRUE, TRUE, TRUE, TRUE)
							if("Organics and Cyborgs")
								nutrienttarget = user
								toggle_all(TRUE, TRUE, TRUE)
							if("Organics and Synthetics")
								nutrienttarget = user
								toggle_all(TRUE, TRUE, FALSE, TRUE)
							if("Only Organics")
								nutrienttarget = user
								toggle_all(TRUE, TRUE)

				if("Off")
					if(active)
						user.visible_message(span_warning("\The [user] inspects \the [src]"), span_warning("You begin to interface with \the [src]."))
						if(do_after(user, 30, src))
							toggle_all(FALSE)
							nutrienttarget = null
	return ..()

/turf/simulated/floor/water/digestive_enzymes/nanites/attack_ai(mob/user)
	var/mob/living/nutrienttarget = moblink?.resolve()
	var/obj/machinery/power/smes/smes = linkedsmes?.resolve()
	if(isrobot(user) && !isshell(user))
		if(smes || isAI(nutrienttarget))
			return ..()
		if(check_target() && user != nutrienttarget)
			return ..()
	if(isAI(user) || isshell(user))// AI have priority
		if(check_target())
			if(isAI(nutrienttarget) && user != nutrienttarget)//first come first serve, for AI
				if(isshell(user))
					return ..()
				if(!locate(user) in range(1, src))// AI can always control adjacent nanite tiles
					return ..()
	var/choice1 = tgui_input_list(user, "Do you wish interface with \the [src]", "Desired state", list("On", "Off"))
	switch(choice1)
		if("On")
			var/choice2 = tgui_input_list(user, "Which entities do you wish for [src] to recycle?", "Desired targets", list("None", "All", "Organics and Cyborgs", "Organics and Synthetics", "Only Organics"))
			to_chat(user, span_warning("With you in control, \the [src] will not attempt to recycle your body, no matter the setting you pick"))
			switch(choice2)
				if("None")
					nutrienttarget = user
					toggle_all(TRUE)
				if("All")
					nutrienttarget = user
					toggle_all(TRUE, TRUE, TRUE, TRUE)
				if("Organics and Cyborgs")
					nutrienttarget = user
					toggle_all(TRUE, TRUE, TRUE)
				if("Organics and Synthetics")
					nutrienttarget = user
					toggle_all(TRUE, TRUE, FALSE, TRUE)
				if("Only Organics")
					nutrienttarget = user
					toggle_all(TRUE, TRUE)

		if("Off")
			if(active)
				toggle_all(FALSE)
				nutrienttarget = null
				if(isAI(user) && (locate(user) in range(1, src)))
					nutrienttarget = user

/turf/simulated/floor/water/digestive_enzymes/nanites/can_digest(atom/movable/AM) //copypasting the entire proc because we use an SMES instead of a linked mob
	. = FALSE
	var/mob/living/nutrienttarget = moblink?.resolve()
	if(!active)
		return FALSE
	if(!check_target())
		return FALSE
	if(!digesting)
		return FALSE
	if(AM.loc != src)
		return FALSE
	if(isitem(AM))
		var/obj/item/I = AM
		if(I.unacidable || I.throwing || I.is_incorporeal() || !I)
			return FALSE
		var/food = FALSE
		if(istype(I,/obj/item/reagent_containers/food))
			food = TRUE
		if(prob(95))	//Give people a chance to pick them up
			return TRUE
		I.visible_message(span_warning("\The [I] sizzles..."))
		var/yum = I.digest_act()	//Glorp
		if(istype(I , /obj/item/card))
			yum = 0		//No, IDs do not have infinite nutrition, thank you
		if(istype(I, /obj/item/cell))
			var/obj/item/cell/C = I
			yum = (C.charge/20)
		if(yum)
			if(food)
				yum += 50
			give_nutrients(yum)
		return TRUE
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.unacidable || !L.digestable || L.buckled || L.hovering || L.throwing || L.is_incorporeal())
			return FALSE
		if(isrobot(L))
			if(!digest_robot)
				return FALSE
			if(L == nutrienttarget)
				return FALSE
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.isSynthetic())
				if(!digest_synth)
					return FALSE
				if(L == nutrienttarget)
					return FALSE
			if(!H.pl_suit_protected())
				return TRUE
			if(H.resting && !H.pl_head_protected())
				return TRUE
		else return TRUE

/turf/simulated/floor/water/digestive_enzymes/nanites/proc/check_target()//check if the target is in the area, or if this is a
	var/mob/living/nutrienttarget = moblink?.resolve()
	var/obj/machinery/power/smes/smes = linkedsmes?.resolve()
	if(nutrienttarget)
		if(nutrienttarget.client && !nutrienttarget.stat)
			if(smes && isAI(nutrienttarget))
				return nutrienttarget
			if(get_area(nutrienttarget))
				if(get_area(nutrienttarget) == get_area(src))
					return nutrienttarget
	nutrienttarget = null
	toggle_all(FALSE)
	return FALSE

/turf/simulated/floor/water/digestive_enzymes/nanites/digest_stuff(atom/movable/AM)	//copypasting the entire proc because we use an SMES instead of a linked mob
	. = FALSE

	var/damage = 2
	var/list/stuff = list()
	var/nutrients = 0
	for(var/thing in src)
		if(can_digest(thing))
			stuff |= thing
	if(!stuff.len)
		return FALSE
	var/thing = pick(stuff)	//We only think about one thing at a time, otherwise things get wacky
	. = TRUE
	if(iscarbon(thing))
		var/mob/living/carbon/H = thing
		if(!H)
			return
		if(H.stat == DEAD)
			H.unacidable = TRUE	//Don't touch this one again, we're gonna delete it in a second
			H.release_vore_contents()
			for(var/obj/item/W in H)
				if(istype(W, /obj/item/organ/internal/mmi_holder/posibrain))
					var/obj/item/organ/internal/mmi_holder/MMI = W
					MMI.removed()
				if(istype(W, /obj/item/organ))
					W.unacidable = TRUE
					continue
				if(istype(W, /obj/item/implant/backup) || istype(W, /obj/item/nif))
					continue
				H.drop_from_inventory(W)
			var/how_much = H.mob_size + H.nutrition
			if(!H.ckey)
				how_much = how_much / 10	//Braindead mobs are worth less
			nutrients += how_much
			H.mind?.vore_death = TRUE
			GLOB.prey_digested_roundstat++
			qdel(H)	//glorp
			return
		H.adjustFireLoss(damage)
		var/how_much = (damage * H.size_multiplier) * H.get_digestion_nutrition_modifier()
		if(!H.ckey)
			how_much = how_much / 10	//Braindead mobs are worth less
		nutrients += how_much
		if(H.bloodstr.get_reagent_amount(REAGENT_ID_NUMBENZYME) < 2) //best play it safe with digestion pain
			H.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,4)
		nutrients += how_much
	else if (isliving(thing))
		var/mob/living/L = thing
		if(!L)
			return
		if(L.stat == DEAD)
			L.unacidable = TRUE	//Don't touch this one again, we're gonna delete it in a second
			L.release_vore_contents()
			var/how_much = L.mob_size + L.nutrition
			if(!L.ckey)
				how_much = how_much / 10	//Braindead mobs are worth less
			nutrients += how_much
			qdel(L) //gloop
			return
		L.adjustFireLoss(damage)
		var/how_much = (damage * L.size_multiplier) * L.get_digestion_nutrition_modifier()
		if(!L.ckey)
			how_much = how_much / 10	//Braindead mobs are worth less
		nutrients += how_much
	give_nutrients(nutrients)

/turf/simulated/floor/water/digestive_enzymes/nanites/proc/give_nutrients(var/amt)
	var/mob/living/nutrienttarget = moblink?.resolve()
	var/obj/machinery/power/smes/smes = linkedsmes?.resolve()
	if(smes)
		smes.charge += (amt * 20)
		return
	if(nutrienttarget)
		if(ishuman(nutrienttarget))
			var/mob/living/carbon/human/H = nutrienttarget
			if(H.isSynthetic())
				H.nutrition = H.nutrition+(10 * amt * (1-min(H.species.synthetic_food_coeff, 0.9)))
				return
		if(isrobot(nutrienttarget))
			var/mob/living/silicon/robot/R = nutrienttarget
			if(R.cell)
				R.cell.give(amt * 20)
				return


/turf/simulated/floor/water/digestive_enzymes/nanites/return_air_for_internal_lifeform(var/mob/living/L)
	if(!can_digest(L))
		return return_air() //Nanites should always be nonlethal until the AI turns on digestion
	else
		return ..()

/turf/simulated/floor/water/digestive_enzymes/nanites/proc/toggle_all(var/on = TRUE, var/digest = FALSE, var/robot = FALSE, var/synth = FALSE)
	var/mob/living/nutrienttarget = moblink?.resolve()
	for(var/turf/simulated/floor/water/digestive_enzymes/nanites/M in GLOB.nanite_turfs)
		if(M.id == id)
			if(on)
				M.moblink = WEAKREF(nutrienttarget)
			M.select_state(on, digest, robot, synth)

/turf/simulated/floor/water/digestive_enzymes/nanites/proc/select_state(var/on = TRUE, var/digest = FALSE, var/robot = FALSE, var/synth = FALSE)
	if(!on)
		name = "nanite-infested tiles."
		desc = "This section of reinforced plating appears to host a colony of nanites between the tiles"
		depth = 0
		movement_cost = 0
		footstep = FOOTSTEP_PLATING
		barefootstep = FOOTSTEP_HARD_BAREFOOT
		clawfootstep = FOOTSTEP_HARD_CLAW
		water_state = "goo_inactive"
		digesting = FALSE
		digest_synth = FALSE
		digest_robot = FALSE
		active = FALSE
		for(var/obj/structure/railing/overhang/hazard/nanite/R in src)
			R.icon_modifier = "inactive_"
			R.icon_state = "inactive_railing0"
		for(var/obj/structure/railing/overhang/hazard/nanite/R in range(src, 1))
			R.update_icon()
		for(var/obj/structure/dummystairs/hazardledge/stairs in src)
			stairs.icon_state = "stair_hazard"
			stairs.update_icon()
	else
		name = "nanite goop."
		desc = "A deep pool of pulsating, possibly deadly nanite goop."
		depth = 2
		movement_cost = 16 //twice as difficult as deep water to navigate
		footstep = FOOTSTEP_WATER
		barefootstep = FOOTSTEP_WATER
		clawfootstep = FOOTSTEP_WATER
		water_state = "goo_active"
		digesting = digest
		digest_synth = synth
		digest_robot = robot
		active = TRUE
		for(var/obj/structure/railing/overhang/hazard/nanite/R in src)
			R.icon_modifier = "active_"
			R.icon_state = "active_railing0"
		for(var/obj/structure/railing/overhang/hazard/nanite/R in range(src, 1))
			R.update_icon()
		for(var/obj/structure/dummystairs/hazardledge/stairs in src)
			depth = 1
			movement_cost = 8
			stairs.icon_state = "stair_hazard_nanite"
			stairs.update_icon()
	for(var/atom/AM in src)
		Entered(AM)
	update_icon()

/turf/simulated/floor/water/digestive_enzymes/nanites/Destroy()
	moblink = null
	linkedsmes = null
	return ..()
