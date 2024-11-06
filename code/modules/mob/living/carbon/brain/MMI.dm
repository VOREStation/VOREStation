//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/mmi
	name = "man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_empty"
	w_class = ITEMSIZE_NORMAL
	can_speak = 1
	origin_tech = list(TECH_BIO = 3)

	req_access = list(access_robotics)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/locked = 0
	var/mob/living/carbon/brain/brainmob = null//The current occupant.
	var/obj/item/organ/internal/brain/brainobj = null	//The current brain organ.
	var/obj/mecha = null//This does not appear to be used outside of reference in mecha.dm.
	var/obj/item/radio/headset/mmi_radio/radio = null//Let's give it a radio.

/obj/item/mmi/New()
	radio = new(src)//Spawns a radio inside the MMI.

/obj/item/mmi/verb/toggle_radio()
	set name = "Toggle Brain Radio"
	set desc = "Enables or disables the integrated brain radio, which is only usable outside of a body."
	set category = "Object"
	set src in usr
	set popup_menu = 1
	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	if (radio.radio_enabled == 1)
		radio.radio_enabled = 0
		to_chat (usr, "You have disabled the [src]'s radio.")
		to_chat (brainmob, "Your radio has been disabled.")
	else if (radio.radio_enabled == 0)
		radio.radio_enabled = 1
		to_chat (usr, "You have enabled the [src]'s radio.")
		to_chat (brainmob, "Your radio has been enabled.")
	else
		to_chat (usr, "You were unable to toggle the [src]'s radio.")

/obj/item/mmi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O,/obj/item/organ/internal/brain) && !brainmob) //Time to stick a brain in it --NEO

		var/obj/item/organ/internal/brain/B = O
		if(B.health <= 0)
			to_chat(user, span_warning("That brain is well and truly dead."))
			return
		else if(!B.brainmob)
			to_chat(user, span_warning("You aren't sure where this brain came from, but you're pretty sure it's useless."))
			return

		for(var/modifier_type in B.brainmob.modifiers)	//Can't be shoved in an MMI.
			if(istype(modifier_type, /datum/modifier/no_borg))
				to_chat(user, span_warning("\The [src] appears to reject this brain.  It is incompatible."))
				return

		user.visible_message(span_infoplain(span_bold("\The [user]") + " sticks \a [O] into \the [src]."))
		B.preserved = TRUE

		brainmob = B.brainmob
		B.brainmob = null
		brainmob.loc = src
		brainmob.container = src
		brainmob.set_stat(CONSCIOUS)
		brainmob.blinded = 0 //VOREedit Fixes MMIs vision
		dead_mob_list -= brainmob//Update dem lists
		living_mob_list += brainmob

		user.drop_item()
		brainobj = O
		brainobj.loc = src

		name = "man-machine interface ([brainmob.real_name])"
		icon_state = "mmi_full"

		locked = 1

		feedback_inc("cyborg_mmis_filled",1)

		return

	if((istype(O,/obj/item/card/id)||istype(O,/obj/item/pda)) && brainmob)
		if(allowed(user))
			locked = !locked
			to_chat(user, span_notice("You [locked ? "lock" : "unlock"] the brain holder."))
		else
			to_chat(user, span_warning("Access denied."))
		return
	if(brainmob)
		O.attack(brainmob, user)//Oh noooeeeee
		return
	..()

//TODO: ORGAN REMOVAL UPDATE. Make the brain remain in the MMI so it doesn't lose organ data.
/obj/item/mmi/attack_self(mob/user as mob)
	if(!brainmob)
		to_chat(user, span_warning("You upend the MMI, but there's nothing in it."))
	else if(locked)
		to_chat(user, span_warning("You upend the MMI, but the brain is clamped into place."))
	else
		to_chat(user, span_notice("You upend the MMI, spilling the brain onto the floor."))
		var/obj/item/organ/internal/brain/brain
		if (brainobj)	//Pull brain organ out of MMI.
			brainobj.loc = user.loc
			brain = brainobj
			brainobj = null
		else	//Or make a new one if empty.
			brain = new(user.loc)
		brain.preserved = FALSE
		brainmob.container = null//Reset brainmob mmi var.
		brainmob.loc = brain//Throw mob into brain.
		living_mob_list -= brainmob//Get outta here
		brain.brainmob = brainmob//Set the brain to use the brainmob
		brainmob = null//Set mmi brainmob var to null

		icon_state = "mmi_empty"
		name = "Man-Machine Interface"

/obj/item/mmi/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src

	// Copy modifiers.
	for(var/datum/modifier/M in H.modifiers)
		if(M.flags & MODIFIER_GENETIC)
			brainmob.add_modifier(M.type)

	name = "Man-Machine Interface: [brainmob.real_name]"
	icon_state = "mmi_full"
	locked = 1
	return

/obj/item/mmi/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(rig)
		if(istype(rig,/obj/item/rig))
			rig.forced_move(direction, user)

/obj/item/mmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	QDEL_NULL(radio)
	QDEL_NULL(brainmob)
	return ..()

/obj/item/mmi/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio. Wait, don't they all?"
	origin_tech = list(TECH_BIO = 4)

/obj/item/mmi/emp_act(severity)
	if(!brainmob)
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage += rand(20,30)
			if(2)
				brainmob.emp_damage += rand(10,20)
			if(3)
				brainmob.emp_damage += rand(5,10)
			if(4)
				brainmob.emp_damage += rand(0,5)
	..()

/obj/item/mmi/digital
	var/searching = 0
	var/askDelay = 10 * 60 * 1
	req_access = list(access_robotics)
	locked = 0
	mecha = null//This does not appear to be used outside of reference in mecha.dm.
	var/ghost_query_type = null

/obj/item/mmi/digital/New()
	src.brainmob = new(src)
//	src.brainmob.add_language("Robot Talk")//No binary without a binary communication device
	src.brainmob.add_language(LANGUAGE_GALCOM)
	src.brainmob.add_language(LANGUAGE_EAL)
	src.brainmob.loc = src
	src.brainmob.container = src
	src.brainmob.set_stat(CONSCIOUS)
	src.brainmob.silent = 0
	radio = new(src)
	dead_mob_list -= src.brainmob

/obj/item/mmi/digital/attackby(var/obj/item/O as obj, var/mob/user as mob)
	return	//Doesn't do anything right now because none of the things that can be done to a regular MMI make any sense for these

/obj/item/mmi/digital/examine(mob/user)
	. = ..()

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)
					. += span_warning("It appears to be in stand-by mode.") //afk
			if(UNCONSCIOUS)
				. += span_warning("It doesn't seem to be responsive.")
			if(DEAD)
				. += span_deadsay("It appears to be completely inactive.")
	else
		. += span_deadsay("It appears to be completely inactive.")

/obj/item/mmi/digital/emp_act(severity)
	if(!src.brainmob)
		return
	else
		switch(severity)
			if(1)
				src.brainmob.emp_damage += rand(20,30)
			if(2)
				src.brainmob.emp_damage += rand(10,20)
			if(3)
				src.brainmob.emp_damage += rand(5,10)
			if(4)
				src.brainmob.emp_damage += rand(0,5)
	..()

/obj/item/mmi/digital/transfer_identity(var/mob/living/carbon/H)
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	brainmob.set_stat(CONSCIOUS)
	if(H.mind)
		H.mind.transfer_to(brainmob)
	return

/obj/item/mmi/digital/attack_self(mob/user as mob)
	if(brainmob && !brainmob.key && searching == 0)
		//Start the process of searching for a new user.
		to_chat(user, span_blue("You carefully locate the manual activation switch and start the [src]'s boot process."))
		request_player()

/obj/item/mmi/digital/proc/request_player()
	if(!ghost_query_type)
		return
	searching = 1

	var/datum/ghost_query/Q = new ghost_query_type()
	var/list/winner = Q.query()
	if(winner.len)
		var/mob/observer/dead/D = winner[1]
		transfer_personality(D)
	else
		reset_search()

/obj/item/mmi/digital/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	if(src.brainmob && src.brainmob.key)
		return

	src.searching = 0

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message(span_blue("\The [src] buzzes quietly, and the golden lights fade away. Perhaps you could try again?"))

/obj/item/mmi/digital/proc/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are occupying a synthetic brain now.")
	src.searching = 0
	if(candidate.mind)
		src.brainmob.mind = candidate.mind
		src.brainmob.mind.reset()
	src.brainmob.ckey = candidate.ckey
	src.name = "[name] ([src.brainmob.name])"
	to_chat(src.brainmob, span_infoplain(span_bold("You are [src.name], brought into existence on [station_name()].")))
	to_chat(src.brainmob, span_infoplain(span_bold("As a synthetic intelligence, you are designed with organic values in mind.")))
	to_chat(src.brainmob, span_infoplain(span_bold("However, unless placed in a lawed chassis, you are not obligated to obey any individual crew member."))) //it's not like they can hurt anyone
//	to_chat(src.brainmob, span_infoplain(span_bold("Use say #b to speak to other artificial intelligences.")))
	src.brainmob.mind.assigned_role = JOB_SYNTHETIC_BRAIN

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message(span_blue("\The [src] chimes quietly."))

/obj/item/mmi/digital/robot
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/drones)
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_DATA = 4)
	ghost_query_type = /datum/ghost_query/drone_brain

/obj/item/mmi/digital/robot/New()
	..()
	src.brainmob.name = "[pick(list("ADA","DOS","GNU","MAC","WIN","NJS","SKS","DRD","IOS","CRM","IBM","TEX","LVM","BSD",))]-[rand(1000, 9999)]"
	src.brainmob.real_name = src.brainmob.name

/obj/item/mmi/digital/robot/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = JOB_ROBOTIC_INTELLIGENCE
	to_chat(brainmob, span_notify("You feel slightly disoriented. That's normal when you're little more than a complex circuit."))
	return

/obj/item/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	catalogue_data = list(/datum/category_item/catalogue/technology/positronics)
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)
	ghost_query_type = /datum/ghost_query/posi_brain

/obj/item/mmi/digital/posibrain/request_player()
	icon_state = "posibrain-searching"
	..()


/obj/item/mmi/digital/posibrain/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = JOB_POSITRONIC_BRAIN
	to_chat(brainmob, span_notify("You feel slightly disoriented. That's normal when you're just a metal cube."))
	icon_state = "posibrain-occupied"
	return

/obj/item/mmi/digital/posibrain/transfer_personality(var/mob/candidate)
	..()
	icon_state = "posibrain-occupied"

/obj/item/mmi/digital/posibrain/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	..()
	icon_state = "posibrain"

/obj/item/mmi/digital/posibrain/New()
	..()
	src.brainmob.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	src.brainmob.real_name = src.brainmob.name

// This type shouldn't care about brainmobs.
/obj/item/mmi/inert

// This is a 'fake' MMI that is used to let AIs control borg shells directly.
// This doesn't inherit from /digital because all that does is add ghost pulling capabilities, which this thing won't need.
/obj/item/mmi/inert/ai_remote
	name = "\improper AI remote interface"
	desc = "A sophisticated board which allows for an artificial intelligence to remotely control a synthetic chassis."
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2, TECH_BLUESPACE = 2, TECH_DATA = 3)
