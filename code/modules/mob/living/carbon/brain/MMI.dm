//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/device/mmi
	name = "man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_empty"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_BIO = 3)

	req_access = list(access_robotics)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/locked = 0
	var/mob/living/carbon/brain/brainmob = null//The current occupant.
	var/obj/item/organ/internal/brain/brainobj = null	//The current brain organ.
	var/obj/mecha = null//This does not appear to be used outside of reference in mecha.dm.

/obj/item/device/mmi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O,/obj/item/organ/internal/brain) && !brainmob) //Time to stick a brain in it --NEO

		var/obj/item/organ/internal/brain/B = O
		if(B.health <= 0)
			user << "<span class='warning'>That brain is well and truly dead.</span>"
			return
		else if(!B.brainmob)
			user << "<span class='warning'>You aren't sure where this brain came from, but you're pretty sure it's useless.</span>"
			return

		user.visible_message("<span class='notice'>\The [user] sticks \a [O] into \the [src].</span>")

		brainmob = B.brainmob
		B.brainmob = null
		brainmob.loc = src
		brainmob.container = src
		brainmob.stat = 0
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

	if((istype(O,/obj/item/weapon/card/id)||istype(O,/obj/item/device/pda)) && brainmob)
		if(allowed(user))
			locked = !locked
			user << "<span class='notice'>You [locked ? "lock" : "unlock"] the brain holder.</span>"
		else
			user << "<span class='warning'>Access denied.</span>"
		return
	if(brainmob)
		O.attack(brainmob, user)//Oh noooeeeee
		return
	..()

//TODO: ORGAN REMOVAL UPDATE. Make the brain remain in the MMI so it doesn't lose organ data.
/obj/item/device/mmi/attack_self(mob/user as mob)
	if(!brainmob)
		user << "<span class='warning'>You upend the MMI, but there's nothing in it.</span>"
	else if(locked)
		user << "<span class='warning'>You upend the MMI, but the brain is clamped into place.</span>"
	else
		user << "<span class='notice'>You upend the MMI, spilling the brain onto the floor.</span>"
		var/obj/item/organ/internal/brain/brain
		if (brainobj)	//Pull brain organ out of MMI.
			brainobj.loc = user.loc
			brain = brainobj
			brainobj = null
		else	//Or make a new one if empty.
			brain = new(user.loc)
		brainmob.container = null//Reset brainmob mmi var.
		brainmob.loc = brain//Throw mob into brain.
		living_mob_list -= brainmob//Get outta here
		brain.brainmob = brainmob//Set the brain to use the brainmob
		brainmob = null//Set mmi brainmob var to null

		icon_state = "mmi_empty"
		name = "Man-Machine Interface"

/obj/item/device/mmi/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src

	name = "Man-Machine Interface: [brainmob.real_name]"
	icon_state = "mmi_full"
	locked = 1
	return

/obj/item/device/mmi/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/weapon/rig/rig = src.get_rig()
	if(rig)
		rig.forced_move(direction, user)

/obj/item/device/mmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	..()

/obj/item/device/mmi/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	origin_tech = list(TECH_BIO = 4)

	var/obj/item/device/radio/radio = null//Let's give it a radio.

	New()
		..()
		radio = new(src)//Spawns a radio inside the MMI.
		radio.broadcasting = 1//So it's broadcasting from the start.

	verb//Allows the brain to toggle the radio functions.
		Toggle_Broadcasting()
			set name = "Toggle Broadcasting"
			set desc = "Toggle broadcasting channel on or off."
			set category = "MMI"
			set src = usr.loc//In user location, or in MMI in this case.
			set popup_menu = 0//Will not appear when right clicking.

			if(brainmob.stat)//Only the brainmob will trigger these so no further check is necessary.
				brainmob << "Can't do that while incapacitated or dead."

			radio.broadcasting = radio.broadcasting==1 ? 0 : 1
			brainmob << "<span class='notice'>Radio is [radio.broadcasting==1 ? "now" : "no longer"] broadcasting.</span>"

		Toggle_Listening()
			set name = "Toggle Listening"
			set desc = "Toggle listening channel on or off."
			set category = "MMI"
			set src = usr.loc
			set popup_menu = 0

			if(brainmob.stat)
				brainmob << "Can't do that while incapacitated or dead."

			radio.listening = radio.listening==1 ? 0 : 1
			brainmob << "<span class='notice'>Radio is [radio.listening==1 ? "now" : "no longer"] receiving broadcast.</span>"

/obj/item/device/mmi/emp_act(severity)
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

/obj/item/device/mmi/digital
	var/searching = 0
	var/askDelay = 10 * 60 * 1
	req_access = list(access_robotics)
	locked = 0
	mecha = null//This does not appear to be used outside of reference in mecha.dm.

/obj/item/device/mmi/digital/New()
	src.brainmob = new(src)
	src.brainmob.add_language("Robot Talk")
	src.brainmob.add_language(LANGUAGE_EAL)
	src.brainmob.loc = src
	src.brainmob.container = src
	src.brainmob.stat = 0
	src.brainmob.silent = 0
	dead_mob_list -= src.brainmob

/obj/item/device/mmi/digital/attackby(var/obj/item/O as obj, var/mob/user as mob)
	return	//Doesn't do anything right now because none of the things that can be done to a regular MMI make any sense for these

/obj/item/device/mmi/digital/examine(mob/user)
	if(!..(user))
		return

	var/msg = "<span class='info'>*---------*</span>\nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"
	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	msg += "</span><span class='info'>*---------*</span>"
	user << msg
	return

/obj/item/device/mmi/digital/emp_act(severity)
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

/obj/item/device/mmi/digital/transfer_identity(var/mob/living/carbon/H)
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	brainmob.stat = 0
	if(H.mind)
		H.mind.transfer_to(brainmob)
	return

/obj/item/device/mmi/digital/attack_self(mob/user as mob)
	if(brainmob && !brainmob.key && searching == 0)
		//Start the process of searching for a new user.
		user << "\blue You carefully locate the manual activation switch and start the [src]'s boot process."
		src.searching = 1
		src.request_player()
		spawn(600) reset_search()

/obj/item/device/mmi/digital/proc/request_player()
	for(var/mob/observer/dead/O in player_list)
		if(!O.MayRespawn())
			continue
		if(jobban_isbanned(O, "AI") && jobban_isbanned(O, "Cyborg"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_AI)
				question(O.client)

/obj/item/device/mmi/digital/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.

	if(src.brainmob && src.brainmob.key) return
	world.log << "Resetting [src.name]: [brainmob][brainmob ? ", [brainmob.key]" : ""]"

	src.searching = 0

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue The [src] buzzes quietly, and the golden lights fade away. Perhaps you could try again?")

/obj/item/device/mmi/digital/proc/question(var/client/C)
	spawn(0)
		if(!C)	return
		var/response = alert(C, "Someone is requesting a personality for a [src]. Would you like to play as one?", "[src] request", "Yes", "No", "Never for this round")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as a [src]?", "[src] request", "Yes", "No")
		if(!C || brainmob.key || 0 == searching)	return		//handle logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
		if(response == "Yes")
			transfer_personality(C.mob)
		else if (response == "Never for this round")
			C.prefs.be_special ^= BE_AI

/obj/item/device/mmi/digital/proc/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are occupying a synthetic brain now.")
	src.searching = 0
	src.brainmob.mind = candidate.mind
	src.brainmob.ckey = candidate.ckey
	src.brainmob.mind.reset()
	src.name = "positronic brain ([src.brainmob.name])"
	src.brainmob << "<b>You are a [src], brought into existence on [station_name()].</b>"
	src.brainmob << "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>"
	src.brainmob << "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>"
	src.brainmob << "<b>Use say #b to speak to other artificial intelligences.</b>"
	src.brainmob.mind.assigned_role = "Positronic Brain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue The [src] chimes quietly.")

/obj/item/device/mmi/digital/robot
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_DATA = 4)

/obj/item/device/mmi/digital/robot/New()
	..()
	src.brainmob.name = "[pick(list("ADA","DOS","GNU","MAC","WIN"))]-[rand(1000, 9999)]"
	src.brainmob.real_name = src.brainmob.name
	src.name = "robotic intelligence circuit ([src.brainmob.name])"

/obj/item/device/mmi/digital/robot/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Robotic Intelligence"
	brainmob << "<span class='notify'>You feel slightly disoriented. That's normal when you're little more than a complex circuit.</span>"
	return

/obj/item/device/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)

/obj/item/device/mmi/digital/posibrain/attack_self(mob/user as mob)
	..()
	icon_state = "posibrain-searching"


/obj/item/device/mmi/digital/posibrain/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Positronic Brain"
	brainmob << "<span class='notify'>You feel slightly disoriented. That's normal when you're just a metal cube.</span>"
	icon_state = "posibrain-occupied"
	return

/obj/item/device/mmi/digital/posibrain/transfer_personality(var/mob/candidate)
	..()
	icon_state = "posibrain-occupied"

/obj/item/device/mmi/digital/posibrain/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	..()
	icon_state = "posibrain"

/obj/item/device/mmi/digital/posibrain/New()
	..()
	src.brainmob.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	src.brainmob.real_name = src.brainmob.name
