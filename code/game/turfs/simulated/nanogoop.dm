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
	for(var/obj/machinery/power/smes/tolink in GLOB.smeses)
		if(!tolink)
			continue
		if(!get_area(tolink))
			continue
		if(get_area(tolink) == get_area(src))
			linkedsmes = WEAKREF(tolink)

/turf/simulated/floor/water/digestive_enzymes/nanites/attack_hand(mob/user)
	var/mob/living/nutrienttarget = moblink?.resolve()
	var/obj/machinery/power/smes/smes = linkedsmes?.resolve()
	if(check_target() && (user != nutrienttarget))//prioritize this here, so mobs can turn the turf off
		return ..()
	if(ishuman(user))
		if(smes || isAI(nutrienttarget))
			return ..()
		var/mob/living/carbon/human/checker = user
		if(checker.nif)//Proteans have NIFS
			var/choice1 = tgui_input_list(user, "Do you wish interface with \the [src]", "Desired state", list("On", "Off"))
			switch(choice1)
				if("On")
					var/choice2 = tgui_input_list(user, "Which entities do you wish for \the [src] to recycle?", "Desired targets", list("None", "All", "Organics and Cyborgs", "Organics and Synthetics", "Only Organics"))
					if(checker.isSynthetic())
						to_chat(checker, span_warning("With you in control, \the [src] will not attempt to recycle your body, no matter the setting you pick"))
					else
						to_chat(checker, span_warning("You realize there is no way for the simplistic [src] to ignore your form, if you set it to recycle."))
					user.visible_message(span_warning("\The [user] inspects \the [src]"), span_warning("You begin to interface with \the [src]."))
					if(do_after(user, 30, src))
						moblink = WEAKREF(user)
						switch(choice2)
							if("None")
								moblink = WEAKREF(user)
								toggle_all(TRUE)
							if("All")
								moblink = WEAKREF(user)
								toggle_all(TRUE, TRUE, TRUE, TRUE)
							if("Organics and Cyborgs")
								moblink = WEAKREF(user)
								toggle_all(TRUE, TRUE, TRUE)
							if("Organics and Synthetics")
								moblink = WEAKREF(user)
								toggle_all(TRUE, TRUE, FALSE, TRUE)
							if("Only Organics")
								moblink = WEAKREF(user)
								toggle_all(TRUE, TRUE)

				if("Off")
					if(active)
						user.visible_message(span_warning("\The [user] inspects \the [src]"), span_warning("You begin to interface with \the [src]."))
						if(do_after(user, 30, src))
							toggle_all(FALSE)
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
					moblink = WEAKREF(user)
					toggle_all(TRUE)
				if("All")
					moblink = WEAKREF(user)
					toggle_all(TRUE, TRUE, TRUE, TRUE)
				if("Organics and Cyborgs")
					moblink = WEAKREF(user)
					toggle_all(TRUE, TRUE, TRUE)
				if("Organics and Synthetics")
					moblink = WEAKREF(user)
					toggle_all(TRUE, TRUE, FALSE, TRUE)
				if("Only Organics")
					moblink = WEAKREF(user)
					toggle_all(TRUE, TRUE)

		if("Off")
			if(active)
				toggle_all(FALSE)

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
		var/obj/item/targetitem = AM
		if(targetitem.unacidable || targetitem.throwing || targetitem.is_incorporeal() || !targetitem)
			return FALSE
		var/food = FALSE
		if(istype(targetitem,/obj/item/reagent_containers/food))
			food = TRUE
		if(prob(95))	//Give people a chance to pick them up
			return TRUE
		targetitem.visible_message(span_warning("\The [targetitem] sizzles..."))
		var/yum = targetitem.digest_act()	//Glorp
		if(istype(targetitem , /obj/item/card))
			yum = 0		//No, IDs do not have infinite nutrition, thank you
		if(yum)
			if(food)
				yum += 50
			give_nutrients(yum)
		return TRUE
	if(isliving(AM))
		var/mob/living/targetmob = AM
		if(targetmob.unacidable || !targetmob.digestable || targetmob.buckled || targetmob.hovering || targetmob.throwing || targetmob.is_incorporeal())
			return FALSE
		if(isrobot(targetmob))
			if(!digest_robot)
				return FALSE
			if(targetmob == nutrienttarget)
				return FALSE
		if(ishuman(targetmob))
			var/mob/living/carbon/human/targethuman = targetmob
			if(targethuman.isSynthetic())
				if(!digest_synth)
					return FALSE
				if(targetmob == nutrienttarget)
					return FALSE
			if(!targethuman.pl_suit_protected())
				return TRUE
			if(targethuman.resting && !targethuman.pl_head_protected())
				return TRUE
		return TRUE

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
		var/mob/living/carbon/targetcarbon = thing
		if(!targetcarbon)
			return
		if(targetcarbon.stat == DEAD)
			targetcarbon.unacidable = TRUE	//Don't touch this one again, we're gonna delete it in a second
			targetcarbon.release_vore_contents()
			for(var/obj/item/targetitem in targetcarbon)
				if(istype(targetitem, /obj/item/organ/internal/mmi_holder/posibrain))
					var/obj/item/organ/internal/mmi_holder/MMI = targetitem
					MMI.removed()
				if(istype(targetitem, /obj/item/organ))
					targetitem.unacidable = TRUE
					continue
				if(istype(targetitem, /obj/item/implant/backup) || istype(targetitem, /obj/item/nif))
					continue
				targetcarbon.drop_from_inventory(targetitem)
			var/how_much = targetcarbon.mob_size + targetcarbon.nutrition
			if(!targetcarbon.ckey)
				how_much = how_much / 10	//Braindead mobs are worth less
			nutrients += how_much
			targetcarbon.mind?.vore_death = TRUE
			GLOB.prey_digested_roundstat++
			targetcarbon.ghostize() //prevent runtimes
			qdel(targetcarbon)	//glorp
			return
		targetcarbon.adjustFireLoss(damage)
		var/how_much = (damage * targetcarbon.size_multiplier) * targetcarbon.get_digestion_nutrition_modifier()
		if(!targetcarbon.ckey)
			how_much = how_much / 10	//Braindead mobs are worth less
		nutrients += how_much
		if(targetcarbon.bloodstr.get_reagent_amount(REAGENT_ID_NUMBENZYME) < 2) //best play it safe with digestion pain
			targetcarbon.bloodstr.add_reagent(REAGENT_ID_NUMBENZYME,4)
		nutrients += how_much
	else if (isliving(thing))
		var/mob/living/targetmob = thing
		if(!targetmob)
			return
		if(targetmob.stat == DEAD)
			targetmob.unacidable = TRUE	//Don't touch this one again, we're gonna delete it in a second
			targetmob.release_vore_contents()
			var/how_much = targetmob.mob_size + targetmob.nutrition
			if(!targetmob.ckey)
				how_much = how_much / 10	//Braindead mobs are worth less
			nutrients += how_much
			qdel(targetmob) //gloop
			return
		targetmob.adjustFireLoss(damage)
		var/how_much = (damage * targetmob.size_multiplier) * targetmob.get_digestion_nutrition_modifier()
		if(!targetmob.ckey)
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
			var/mob/living/carbon/human/targetcarbon = nutrienttarget
			if(targetcarbon.isSynthetic())
				targetcarbon.nutrition = targetcarbon.nutrition+(10 * amt * (1-min(targetcarbon.species.synthetic_food_coeff, 0.9)))
				return
	if(isrobot(nutrienttarget))
		var/mob/living/silicon/robot/targetrobot = nutrienttarget
		if(targetrobot.cell)
			targetrobot.cell.give(amt * 20)
			return


/turf/simulated/floor/water/digestive_enzymes/nanites/return_air_for_internal_lifeform(var/mob/living/targetmob)
	if(!can_digest(targetmob))
		return return_air() //Nanites should always be nonlethal until the AI turns on digestion
	return ..()

/turf/simulated/floor/water/digestive_enzymes/nanites/proc/toggle_all(var/on = TRUE, var/digest = FALSE, var/robot = FALSE, var/synth = FALSE)
	var/mob/living/nutrienttarget = moblink?.resolve()
	for(var/turf/simulated/floor/water/digestive_enzymes/nanites/nanites in GLOB.nanite_turfs)
		if(nanites.id == id)
			nanites.moblink = null
			if(on)
				nanites.moblink = WEAKREF(nutrienttarget)
			nanites.select_state(on, digest, robot, synth)

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
		update_icon()
		return
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
