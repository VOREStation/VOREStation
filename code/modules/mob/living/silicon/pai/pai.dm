/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/pai.dmi'
	icon_state = "pai-repairbot"

	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = 1
	mob_size = MOB_SMALL

	holder_type = /obj/item/holder/pai

	can_pull_size = ITEMSIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	idcard_type = /obj/item/card/id
	var/idaccessible = 0

	var/network = "SS13"
	var/obj/machinery/camera/current = null

	var/ram = 100	// Used as currency to purchase different abilities
	var/list/software = list()
	var/userDNA		// The DNA string of our assigned user
	var/obj/item/paicard/card	// The card we inhabit
	var/obj/item/radio/borg/pai/radio		// Our primary radio
	var/obj/item/communicator/integrated/communicator	// Our integrated communicator.

	var/chassis = "pai-repairbot"   // A record of your chosen chassis.
	var/global/list/possible_chassis = list(
		"Drone" = "pai-repairbot",
		"Cat" = "pai-cat",
		"Mouse" = "pai-mouse",
		"Monkey" = "pai-monkey",
		"Borgi" = "pai-borgi",
		"Fox" = "pai-fox",
		"Parrot" = "pai-parrot",
		"Rabbit" = "pai-rabbit",
		//VOREStation Addition Start
		"Bear" = "pai-bear",
		"Fennec" = "pai-fen",
		"Type Zero" = "pai-typezero",
		"Raccoon" = "pai-raccoon",
		"Raptor" = "pai-raptor",
		"Corgi" = "pai-corgi",
		"Bat" = "pai-bat",
		"Butterfly" = "pai-butterfly",
		"Hawk" = "pai-hawk",
		"Duffel" = "pai-duffel",
		"Rat" = "rat",
		"Panther" = "panther",
		"Cyber Elf" = "cyberelf",
		"Teppi" = "teppi",
		"Catslug" = "catslug",
		"Car" = "car",
		"Type One" = "typeone",
		"Type Thirteen" = "13"
		//VOREStation Addition End
		)

	var/global/list/possible_say_verbs = list(
		"Robotic" = list("states","declares","queries"),
		"Natural" = list("says","yells","asks"),
		"Beep" = list("beeps","beeps loudly","boops"),
		"Chirp" = list("chirps","chirrups","cheeps"),
		"Feline" = list("purrs","yowls","meows"),
		"Canine" = list("yaps","barks","woofs"),
		"Rodent" = list("squeaks", "SQUEAKS", "sqiks")	//VOREStation Edit
		)

	var/obj/item/pai_cable/cable		// The cable we produce and use when door or camera jacking

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification
							// Keeping this separate from the laws var, it should be much more difficult to modify
	var/pai_law0 = "Serve your master."
	var/pai_laws				// String for additional operating instructions our master might give us

	var/silence_time			// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	var/obj/item/pda/ai/pai/pda = null

	var/paiHUD = 0			// Toggles whether the AR HUD is active or not

	var/medical_cannotfind = 0
	var/datum/data/record/medicalActive1		// Datacore record declarations for record software
	var/datum/data/record/medicalActive2

	var/security_cannotfind = 0
	var/datum/data/record/securityActive1		// Could probably just combine all these into one
	var/datum/data/record/securityActive2

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 1000, >= 1000 means the hack is complete and will be reset upon next check
	var/hack_aborted = 0

	var/obj/item/radio/integrated/signal/sradio // AI's signaller

	var/translator_on = 0 // keeps track of the translator module

	var/current_pda_messaging = null

	var/our_icon_rotation = 0

/mob/living/silicon/pai/Initialize()

	. = ..()

	card = loc
	if(!istype(card))
		return INITIALIZE_HINT_QDEL

	sradio = new(src)
	communicator = new(src)
	if(card)
		if(!card.radio)
			card.radio = new /obj/item/radio/borg/pai(src.card)
		radio = card.radio

	//Default languages without universal translator software
	add_language(LANGUAGE_SOL_COMMON, 1)
	add_language(LANGUAGE_TRADEBAND, 1)
	add_language(LANGUAGE_GUTTER, 1)
	add_language(LANGUAGE_EAL, 1)
	add_language(LANGUAGE_TERMINUS, 1)
	add_language(LANGUAGE_SIGN, 1)

	verbs += /mob/living/silicon/pai/proc/choose_chassis
	verbs += /mob/living/silicon/pai/proc/choose_verbs

	pda = new(src)
	addtimer(CALLBACK(src, .proc/init_pda), 5)

/mob/living/silicon/pai/proc/init_pda()
	set waitfor = FALSE
	if(pda)
		pda.ownjob = "Personal Assistant"
		pda.owner = text("[]", src)
		pda.name = pda.owner + " (" + pda.ownjob + ")"
		var/datum/data/pda/app/messenger/M = pda.find_program(/datum/data/pda/app/messenger)
		if(M)
			M.toff = TRUE

/mob/living/silicon/pai/Login()
	..()
	// Vorestation Edit: Meta Info for pAI
	if (client.prefs)
		ooc_notes = client.prefs.metadata
	src << sound('sound/effects/pai_login.ogg', volume = 75)	//VOREStation Add

// this function shows the information about being silenced as a pAI in the Status panel
/mob/living/silicon/pai/proc/show_silenced()
	if(src.silence_time)
		var/timeleft = round((silence_time - world.timeofday)/10 ,1)
		stat(null, "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")


/mob/living/silicon/pai/Stat()
	..()
	statpanel("Status")
	if (src.client.statpanel == "Status")
		show_silenced()

/mob/living/silicon/pai/check_eye(var/mob/user as mob)
	if (!src.current)
		return -1
	return 0

/mob/living/silicon/pai/restrained()
	if(istype(src.loc,/obj/item/paicard))
		return 0
	..()

/mob/living/silicon/pai/emp_act(severity)
	// Silence for 2 minutes
	// 20% chance to damage critical components
	// 50% chance to damage a non critical component
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	src.silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	to_chat(src, "<font color=green><b>Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete.</b></font>")
	if(prob(20))
		var/turf/T = get_turf_or_move(src.loc)
		card.death_damage()
		for (var/mob/M in viewers(T))
			M.show_message("<font color='red'>A shower of sparks spray from [src]'s inner workings.</font>", 3, "<font color='red'>You hear and smell the ozone hiss of electrical sparks being expelled violently.</font>", 2)
		return
	if(prob(50))
		card.damage_random_component(TRUE)
	switch(pick(1,2,3))
		if(1)
			src.master = null
			src.master_dna = null
			to_chat(src, "<font color=green>You feel unbound.</font>")
		if(2)
			var/command
			if(severity  == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyze")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyze")
			src.pai_law0 = "[command] your master."
			to_chat(src, "<font color=green>Pr1m3 d1r3c71v3 uPd473D.</font>")
		if(3)
			to_chat(src, "<font color=green>You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all.</font>")

/mob/living/silicon/pai/proc/switchCamera(var/obj/machinery/camera/C)
	if (!C)
		src.unset_machine()
		src.reset_view(null)
		return 0
	if (stat == 2 || !C.status || !(src.network in C.network)) return 0

	// ok, we're alive, camera is good and in our network...

	src.set_machine(src)
	src.current = C
	src.reset_view(C)
	return 1

/mob/living/silicon/pai/verb/reset_record_view()
	set category = "pAI Commands"
	set name = "Reset Records Software"

	securityActive1 = null
	securityActive2 = null
	security_cannotfind = 0
	medicalActive1 = null
	medicalActive2 = null
	medical_cannotfind = 0
	SStgui.update_uis(src)
	to_chat(usr, "<span class='notice'>You reset your record-viewing software.</span>")

/mob/living/silicon/pai/cancel_camera()
	set category = "pAI Commands"
	set name = "Cancel Camera View"
	src.reset_view(null)
	src.unset_machine()
	src.cameraFollow = null

// Procs/code after this point is used to convert the stationary pai item into a
// mobile pai mob. This also includes handling some of the general shit that can occur
// to it. Really this deserves its own file, but for the moment it can sit here. ~ Z

/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Unfold Chassis"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc != card)
		return

	if(card.projector != PP_FUNCTIONAL && card.emitter != PP_FUNCTIONAL)
		to_chat(src, "<span class ='warning'>ERROR: System malfunction. Service required!</span>")

	if(world.time <= last_special)
		to_chat(src, "<span class ='warning'>You can't unfold yet.</span>")
		return

	last_special = world.time + 100

	if(istype(card.loc, /obj/machinery)) // VOREStation edit, this statement allows pAIs stuck in a machine to eject themselves.
		var/obj/machinery/M = card.loc
		M.ejectpai()
	//I'm not sure how much of this is necessary, but I would rather avoid issues.
	if(istype(card.loc,/obj/item/rig_module))
		to_chat(src, "There is no room to unfold inside this rig module. You're good and stuck.")
		return 0
	else if(istype(card.loc,/mob))
		var/mob/holder = card.loc
		if(ishuman(holder))
			var/mob/living/carbon/human/H = holder
			for(var/obj/item/organ/external/affecting in H.organs)
				if(card in affecting.implants)
					affecting.take_damage(rand(30,50))
					affecting.implants -= card
					H.visible_message("<span class='danger'>\The [src] explodes out of \the [H]'s [affecting.name] in shower of gore!</span>")
					break
		holder.drop_from_inventory(card)
	else if(isbelly(card.loc)) //VOREStation edit.
		to_chat(src, "<span class='notice'>There is no room to unfold in here. You're good and stuck.</span>") //VOREStation edit.
		return 0 //VOREStation edit.
	else if(istype(card.loc,/obj/item/pda))
		var/obj/item/pda/holder = card.loc
		holder.pai = null

	src.client.perspective = EYE_PERSPECTIVE
	src.client.eye = src
	src.forceMove(get_turf(card))

	card.forceMove(src)
	card.screen_loc = null
	canmove = TRUE

	var/turf/T = get_turf(src)
	if(istype(T)) T.visible_message("<b>[src]</b> folds outwards, expanding into a mobile form.")
	verbs |= /mob/living/silicon/pai/proc/pai_nom
	verbs |= /mob/living/proc/vertical_nom
	update_icon()

/mob/living/silicon/pai/verb/fold_up()
	set category = "pAI Commands"
	set name = "Collapse Chassis"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc == card)
		return

	if(world.time <= last_special)
		to_chat(src, "<span class ='warning'>You can't fold up yet.</span>")
		return

	close_up()

/* //VOREStation Removal Start
/mob/living/silicon/pai/proc/choose_chassis()
	set category = "pAI Commands"
	set name = "Choose Chassis"

	var/choice
	var/finalized = "No"
	while(finalized == "No" && src.client)

		choice = tgui_input_list(usr,"What would you like to use for your mobile chassis icon?","Chassis Choice", possible_chassis)
		if(!choice) return

		icon_state = possible_chassis[choice]
		finalized = tgui_alert(usr, "Look at your sprite. Is this what you wish to use?","Choose Chassis",list("No","Yes"))

	chassis = possible_chassis[choice]
	verbs |= /mob/living/proc/hide
//VOREStation Removal End
*/

/mob/living/silicon/pai/proc/choose_verbs()
	set category = "pAI Commands"
	set name = "Choose Speech Verbs"

	var/choice = tgui_input_list(usr,"What theme would you like to use for your speech verbs?","Theme Choice", possible_say_verbs)
	if(!choice) return

	var/list/sayverbs = possible_say_verbs[choice]
	speak_statement = sayverbs[1]
	speak_exclamation = sayverbs[(sayverbs.len>1 ? 2 : sayverbs.len)]
	speak_query = sayverbs[(sayverbs.len>2 ? 3 : sayverbs.len)]

/mob/living/silicon/pai/lay_down()
	set name = "Rest"
	set category = "IC"

	// Pass lying down or getting up to our pet human, if we're in a rig.
	if(istype(src.loc,/obj/item/paicard))
		resting = 0
		var/obj/item/rig/rig = src.get_rig()
		if(istype(rig))
			rig.force_rest(src)
			return
	else if(chassis == "13")
		resting = !resting
		//update_transform()	I want this to make you ROTATE like normal HUMANS do! But! There's lots of problems and I don't know how to fix them!
	else
		resting = !resting
		icon_state = resting ? "[chassis]_rest" : "[chassis]"
		update_icon() //VOREStation edit
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")

	canmove = !resting

/*
/mob/living/silicon/pai/update_transform()

	var/desired_scale_x = size_multiplier * icon_scale_x
	var/desired_scale_y = size_multiplier * icon_scale_y

	// Now for the regular stuff.
	var/matrix/M = matrix()
	M.Scale(desired_scale_x, desired_scale_y)
	M.Translate(0, (vis_height/2)*(desired_scale_y-1))

	if(chassis != "13")
		appearance_flags |= PIXEL_SCALE

		var/anim_time = 3

		if(resting)
			M.Turn(90)
			M.Scale(desired_scale_y, desired_scale_x)
			if(holo_icon_dimension_X == 64 && holo_icon_dimension_Y == 64)
				M.Translate(13,-22)
			else if(holo_icon_dimension_X == 32 && holo_icon_dimension_Y == 64)
				M.Translate(1,-22)
			else if(holo_icon_dimension_X == 64 && holo_icon_dimension_Y == 32)
				M.Translate(13,-6)
			else
				M.Translate(1,-6)
			layer = MOB_LAYER -0.01 // Fix for a byond bug where turf entry order no longer matters
		else
			M.Scale(desired_scale_x, desired_scale_y)
			M.Translate(0, (vis_height/2)*(desired_scale_y-1))
			layer = MOB_LAYER // Fix for a byond bug where turf entry order no longer matters
		animate(src, transform = M, time = anim_time)
	src.transform = M
	handle_status_indicators()
*/
//Overriding this will stop a number of headaches down the track.
/mob/living/silicon/pai/attackby(obj/item/W as obj, mob/user as mob)
	if(W.force)
		visible_message("<span class='danger'>[user.name] attacks [src] with [W]!</span>")
		src.adjustBruteLoss(W.force)
		src.updatehealth()
	else
		visible_message("<span class='warning'>[user.name] bonks [src] harmlessly with [W].</span>")
	spawn(1)
		if(stat != 2) close_up()
	return

/mob/living/silicon/pai/attack_hand(mob/user as mob)
	if(user.a_intent == I_HELP)
		visible_message("<span class='notice'>[user.name] pats [src].</span>")
	else
		visible_message("<span class='danger'>[user.name] boops [src] on the head.</span>")
		close_up()

//I'm not sure how much of this is necessary, but I would rather avoid issues.
/mob/living/silicon/pai/proc/close_up(silent= FALSE)

	last_special = world.time + 100

	if(src.loc == card)
		return

	release_vore_contents(FALSE) //VOREStation Add

	var/turf/T = get_turf(src)
	if(istype(T) && !silent) T.visible_message("<b>[src]</b> neatly folds inwards, compacting down to a rectangular card.")

	if(client)
		src.stop_pulling()
		src.client.perspective = EYE_PERSPECTIVE
		src.client.eye = card

	//stop resting
	resting = 0

	// If we are being held, handle removing our holder from their inv.
	var/obj/item/holder/H = loc
	if(istype(H))
		var/mob/living/M = H.loc
		if(istype(M))
			M.drop_from_inventory(H)
		H.loc = get_turf(src)
		src.loc = get_turf(H)

	if(isbelly(loc))	//If in tumby, when fold up, card go into tumby
		var/obj/belly/B = loc
		src.forceMove(card)
		card.forceMove(B)
	else				//Otherwise go on floor
		src.loc = card
		card.loc = get_turf(card)
		src.forceMove(card)
		card.forceMove(card.loc)
	canmove = 1
	resting = 0
	icon_state = "[chassis]"
	if(isopenspace(card.loc))
		fall()
	verbs -= /mob/living/silicon/pai/proc/pai_nom
	verbs -= /mob/living/proc/vertical_nom

// No binary for pAIs.
/mob/living/silicon/pai/binarycheck()
	return 0

// Handle being picked up.
/mob/living/silicon/pai/get_scooped(var/mob/living/carbon/grabber, var/self_drop)
	var/obj/item/holder/H = ..(grabber, self_drop)
	if(!istype(H))
		return

	H.icon_state = "[chassis]"
	grabber.update_inv_l_hand()
	grabber.update_inv_r_hand()
	return H

/mob/living/silicon/pai/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/card/id/ID = W.GetID()
	if(ID)
		if (idaccessible == 1)
			switch(tgui_alert(user, "Do you wish to add access to [src] or remove access from [src]?","Access Modify",list("Add Access","Remove Access", "Cancel")))
				if("Add Access")
					idcard.access |= ID.access
					to_chat(user, "<span class='notice'>You add the access from the [W] to [src].</span>")
					to_chat(src, "<span class='notice'>\The [user] swipes the [W] over you. You copy the access codes.</span>")
					if(radio)
						radio.recalculateChannels()
					return
				if("Remove Access")
					idcard.access = list()
					to_chat(user, "<span class='notice'>You remove the access from [src].</span>")
					to_chat(src, "<span class='warning'>\The [user] swipes the [W] over you, removing access codes from you.</span>")
					if(radio)
						radio.recalculateChannels()
					return
				if("Cancel")
					return
		else if (istype(W, /obj/item/card/id) && idaccessible == 0)
			to_chat(user, "<span class='notice'>[src] is not accepting access modifcations at this time.</span>")
			return

/mob/living/silicon/pai/verb/allowmodification()
	set name = "Change Access Modifcation Permission"
	set category = "pAI Commands"
	set desc = "Allows people to modify your access or block people from modifying your access."

	if(idaccessible == 0)
		idaccessible = 1
		visible_message("<span class='notice'>\The [src] clicks as their access modification slot opens.</span>","<span class='notice'>You allow access modifications.</span>", runemessage = "click")
	else
		idaccessible = 0
		visible_message("<span class='notice'>\The [src] clicks as their access modification slot closes.</span>","<span class='notice'>You block access modfications.</span>", runemessage = "click")


/mob/living/silicon/pai/verb/wipe_software()
	set name = "Enter Storage"
	set category = "pAI Commands"
	set desc = "Upload your personality to the cloud and wipe your software from the card. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	// Make sure people don't kill themselves accidentally
	if(tgui_alert(usr, "WARNING: This will immediately wipe your software and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?", "Wipe Software", list("No", "Yes")) != "Yes")
		return

	close_up()
	visible_message("<b>[src]</b> fades away from the screen, the pAI device goes silent.")
	card.removePersonality()
	clear_client()
