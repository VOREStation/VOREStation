var/list/infomorph_emotions = list(
		"Happy" = 1,
		"Cat" = 2,
		"Extremely Happy" = 3,
		"Face" = 4,
		"Laugh" = 5,
		"Off" = 6,
		"Sad" = 7,
		"Angry" = 8,
		"What" = 9,
		"Neutral" = 10,
		"Silly" = 11,
		"Nose" = 12,
		"Smirk" = 13,
		"Exclamation Points" = 14,
		"Question Mark" = 15
	)

/mob/living/silicon/infomorph
	name = "sleevecard" //Has the same name as the card for consistency, but this is the MOB in the card.
	icon = 'icons/mob/pai_vr.dmi' //Changed to the virgo icon, giving more sprite options.
	icon_state = "pai-repairbot"

	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = 1
	mob_size = MOB_SMALL

	can_pull_size = ITEMSIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	idcard_type = /obj/item/weapon/card/id
	var/idaccessible = 0

	var/network = NETWORK_NORTHERN_STAR
	var/obj/machinery/camera/current = null

	var/ram = 30	// Used as currency to purchase different abilities
	var/list/software = list()
	var/obj/item/device/sleevecard/card	// The card we inhabit
	var/obj/item/device/radio/sleevecard/radio		// Our primary radio
	var/obj/item/device/universal_translator/translator
	// This was ripped from PAI code, this is to fix the broken sprites for sleevecards and to give sleevecards the same options as PAIs for chassis
	var/chassis = null   // A record of your chosen chassis.
	var/global/list/possible_chassis = list(
		"Drone" = "pai-repairbot",
		"Cat" = "pai-cat",
		"Mouse" = "pai-mouse",
		"Monkey" = "pai-monkey",
		"Corgi" = "pai-borgi",
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
		"Panther" = "panther"
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

	var/obj/item/weapon/pai_cable/cable		// The cable we produce and use when door or camera jacking
	var/silence_time			// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded
	var/db_key

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	var/arHUD = 0			// Toggles whether a civilian AR HUD is active or not

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 1000, >= 1000 means the hack is complete and will be reset upon next check
	var/hack_aborted = 0

	var/obj/item/radio/integrated/signal/sradio					// AI's signaller
	var/obj/item/device/communicator/integrated/communicator	// Our integrated communicator.
	var/obj/item/device/pda/ai/pai/pda							// Our integrated PDA

	var/medical_cannotfind = 0
	var/datum/data/record/medicalActive1		// Datacore record declarations for record software
	var/datum/data/record/medicalActive2

	var/security_cannotfind = 0
	var/datum/data/record/securityActive1		// Could probably just combine all these into one
	var/datum/data/record/securityActive2

/mob/living/silicon/infomorph/New(var/obj/item/device/sleevecard/SC, var/name = "Unknown", var/db_key)
	ASSERT(SC)
	name = "[initial(name)] ([name])"
	src.forceMove(SC)
	card = SC
	sradio = new(src)
	translator = new(src)
	communicator = new(src)
	if(!card.radio)
		card.radio = new (card)
	radio = card.radio

	src.db_key = db_key

	//Default languages without universal translator software
	add_language(LANGUAGE_EAL, 1)
	add_language(LANGUAGE_SIGN, 0)

	verbs += /mob/living/silicon/infomorph/proc/choose_verbs
	verbs += /mob/living/proc/hide
	verbs += /mob/living/silicon/infomorph/proc/fold_out
	verbs += /mob/living/silicon/infomorph/proc/fold_in

	software = default_infomorph_software.Copy()

	//PDA
	pda = new(src)
	spawn(5)
		pda.ownjob = "Sleevecard"
		pda.owner = text("[]", src)
		pda.name = pda.owner + " (" + pda.ownjob + ")"

		var/datum/data/pda/app/messenger/M = pda.find_program(/datum/data/pda/app/messenger)
		if(M)
			M.toff = TRUE

	..()

/mob/living/silicon/infomorph/Login()
	..()

/////////// STAT PANEL
/mob/living/silicon/infomorph/Stat()
	..()
	statpanel("Status")
	if (src.client.statpanel == "Status")
		show_silenced()

// this function shows the information about being silenced as a pAI in the Status panel
/mob/living/silicon/infomorph/proc/show_silenced()
	if(src.silence_time)
		var/timeleft = round((silence_time - world.timeofday)/10 ,1)
		stat(null, "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")


/////////// CHECKERS
/mob/living/silicon/infomorph/check_eye(var/mob/user as mob)
	if (!src.current)
		return -1
	return 0

/mob/living/silicon/infomorph/restrained()
	if(istype(src.loc,/obj/item/device/sleevecard))
		return 0
	..()

/mob/living/silicon/infomorph/default_can_use_tgui_topic(var/src_object)
	if(src_object in src)
		return shared_tgui_interaction()

/////////// DAMAGES
/mob/living/silicon/infomorph/emp_act(severity)
	// Silence for 2 minutes
	// 20% chance to kill

	src.silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	to_chat(src, "<font color=green><b>Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete.</b></font>")
	if(prob(20))
		var/turf/T = get_turf_or_move(src.loc)
		for (var/mob/M in viewers(T))
			M.show_message("<span class='warning'>A shower of sparks spray from \the [src]'s inner workings.</span>", 3, "<span class='warning'>You hear and smell the ozone hiss of electrical sparks being expelled violently.</span>", 2)
		return src.death(0)

/mob/living/silicon/infomorph/death(gibbed,var/message = "beeps once, then goes offline.")
	if(card)
		card.infomorph = null
		card.turnOff()
		if(gibbed)
			src.loc = get_turf(card)
			qdel(card)
		if(card in src)
			card.forceMove(get_turf(src))

	card = null
	..(gibbed,message)
	ghostize()
	qdel(src)

///////////// CAMERAS AND RECORDS
/mob/living/silicon/infomorph/verb/reset_record_view()
	set category = "Card Commands"
	set name = "Reset Records Software"

	securityActive1 = null
	securityActive2 = null
	security_cannotfind = 0
	medicalActive1 = null
	medicalActive2 = null
	medical_cannotfind = 0
	SStgui.update_uis(src)
	to_chat(usr, "<span class='notice'>You reset your record-viewing software.</span>")

/*
/mob/living/silicon/infomorph/proc/switchCamera(var/obj/machinery/camera/C)
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

/mob/living/silicon/infomorph/cancel_camera()
	set category = "Card Commands"
	set name = "Cancel Camera View"
	src.reset_view(null)
	src.unset_machine()
	src.cameraFollow = null
*/
////////////// MOBILE CODE
/mob/living/silicon/infomorph/proc/fold_out()
	set category = "Card Commands"
	set name = "Chassis Open"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc != card)
		return

	if(world.time <= last_special)
		return

	if(!chassis)
		choose_chassis()
		if(!chassis)
			return

	last_special = world.time + 100

	if(istype(card.loc,/mob))
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
	/*
	if(src.client)
		src.client.perspective = EYE_PERSPECTIVE
		src.client.eye = src
	*/
	src.forceMove(get_turf(card))
	card.forceMove(src)
	card.screen_loc = null

	var/turf/T = get_turf(src)
	if(istype(T)) T.visible_message("<b>[src]</b> folds outwards, expanding into a mobile form.")

/mob/living/silicon/infomorph/proc/fold_in()
	set category = "Card Commands"
	set name = "Chassis Close"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc == card)
		return

	if(world.time <= last_special)
		return

	close_up()

/mob/living/silicon/infomorph/proc/close_up()
	last_special = world.time + 100

	if(src.loc == card)
		return

	var/turf/T = get_turf(src)
	if(istype(T)) T.visible_message("<b>[src]</b> neatly folds inwards, compacting down to a rectangular card.")

	src.stop_pulling()
	/*
	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = card
	*/
	//stop resting
	resting = 0

	// If we are being held, handle removing our holder from their inv.
	var/obj/item/weapon/holder/H = loc
	if(istype(H))
		var/mob/living/M = H.loc
		if(istype(M))
			M.drop_from_inventory(H)
		H.loc = get_turf(src)
		src.loc = get_turf(H)

	// Move us into the card and move the card to the ground.
	src.loc = card
	card.loc = get_turf(card)
	src.forceMove(card)
	card.forceMove(card.loc)
	canmove = 1
	resting = 0
	icon_state = "[chassis]"

/mob/living/silicon/infomorph/proc/choose_chassis()
	set category = "Card Commands"
	set name = "Choose Chassis"

	var/choice = tgui_input_list(usr,"What would you like to use for your mobile chassis icon? This decision can only be made once.", "Chassis Choice", possible_chassis)
	if(!choice) return

	icon_state = possible_chassis[choice]
	chassis = possible_chassis[choice]

/mob/living/silicon/infomorph/proc/choose_verbs()
	set category = "Card Commands"
	set name = "Choose Speech Verbs"

	var/choice = tgui_input_list(usr,"What theme would you like to use for your speech verbs? This decision can only be made once.", "Verb Choice", possible_say_verbs)
	if(!choice) return

	var/list/sayverbs = possible_say_verbs[choice]
	speak_statement = sayverbs[1]
	speak_exclamation = sayverbs[(sayverbs.len>1 ? 2 : sayverbs.len)]
	speak_query = sayverbs[(sayverbs.len>2 ? 3 : sayverbs.len)]

	verbs -= /mob/living/silicon/infomorph/proc/choose_verbs

/mob/living/silicon/infomorph/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	icon_state = resting ? "[chassis]_rest" : "[chassis]"
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")

	canmove = !resting

////////////////// ATTACKBY, HAND, SELF etc
/mob/living/silicon/infomorph/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.force)
		visible_message("<span class='danger'>[user.name] attacks [src] with [W]!</span>")
		src.adjustBruteLoss(W.force)
		src.updatehealth()
	else
		visible_message("<span class='warning'>[user.name] bonks [src] harmlessly with [W].</span>")
	spawn(1)
		if(stat != 2) close_up()
	return

/mob/living/silicon/infomorph/attack_hand(mob/user as mob)
	visible_message("<span class='danger'>[user.name] boops [src] on the head.</span>")
	close_up()

/mob/living/silicon/infomorph/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/obj/item/weapon/card/id/ID = W.GetID()
	if(ID)
		if (idaccessible == 1)
			switch(tgui_alert(user, "Do you wish to add access to [src] or remove access from [src]?","Modify Access",list("Add Access","Remove Access","Cancel")))
				if("Add Access")
					idcard.access |= ID.access
					to_chat(user, "<span class='notice'>You add the access from the [W] to [src].</span>")
					return
				if("Remove Access")
					idcard.access = null
					to_chat(user, "<span class='notice'>You remove the access from [src].</span>")
					return
				if("Cancel")
					return
		else if (istype(W, /obj/item/weapon/card/id) && idaccessible == 0)
			to_chat(user, "<span class='notice'>[src] is not accepting access modifcations at this time.</span>")
			return

//////////////////// MISC VERBS
/mob/living/silicon/infomorph/verb/allowmodification()
	set name = "Allow ID Updates"
	set category = "Card Commands"
	desc = "Allows people to modify your access or block people from modifying your access."

	if(idaccessible == 0)
		idaccessible = 1
		to_chat(src, "<span class='notice'>You allow access modifications.</span>")

	else
		idaccessible = 0
		to_chat(src, "<span class='notice'>You block access modfications.</span>")

/mob/living/silicon/infomorph/verb/wipe_software()
	set name = "Suspend Self"
	set category = "OOC"
	set desc = "Wipe yourself from your hardware. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	// Make sure people don't kill themselves accidentally
	if(tgui_alert(usr, "WARNING: This will immediately remove you from the round, and remove your mind backups from storage, similar to cryo. Are you entirely sure you want to do this?", "Suspend Self", list("No", "Yes")) != "Yes")
		return

	close_up()

	//Resleeving 'cryo'
	SStranscore.leave_round(src)

	card.removePersonality()
	clear_client()

//////////// COMMUNICATIONS
/mob/living/silicon/infomorph/verb/radiosettings()
	set name = "Radio Settings"
	set category = "Card Commands"
	desc = "Modify the settings on your integrated radio."

	if(radio)
		radio.tgui_interact(src)
	else
		to_chat(src, "<span class='warning'>You don't have a radio!</span>")

/mob/living/silicon/infomorph/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	if(silence_time)
		to_chat(src, "<font color=green>Communication circuits remain uninitialized.</font>")
	else
		..(message)

/mob/living/silicon/infomorph/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	switch(message_mode)
		if("headset")
			if(radio && istype(radio,/obj/item/device/radio))
				var/obj/item/device/radio/R = radio
				R.talk_into(src,message,null,verb,speaking)
				used_radios += radio

// No binary for pAIs.
/mob/living/silicon/infomorph/binarycheck()
	return 0

/////////////// SOFTWARE DOWNLOADS
var/global/list/infomorph_software_by_key = list()
var/global/list/default_infomorph_software = list()
/hook/startup/proc/populate_infomorph_software_list()
	var/r = 1 // I would use ., but it'd sacrifice runtime detection
	for(var/type in subtypesof(/datum/infomorph_software))
		var/datum/infomorph_software/P = new type()
		if(infomorph_software_by_key[P.id])
			var/datum/infomorph_software/O = infomorph_software_by_key[P.id]
			to_world("<span class='warning'>Infomorph software module [P.name] has the same key as [O.name]!</span>")
			r = 0
			continue
		infomorph_software_by_key[P.id] = P
		if(P.default)
			default_infomorph_software[P.id] = P
	return r

/mob/living/silicon/infomorph/verb/paiInterface()
	set category = "Card Commands"
	set name = "Software Interface"

	tgui_interact(src)

/mob/living/silicon/infomorph/tgui_state(mob/user)
	return GLOB.tgui_self_state

/mob/living/silicon/infomorph/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAIInterface", "Card Software Interface")
		ui.open()

/mob/living/silicon/infomorph/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	// Software we have bought
	var/list/bought_software = list()
	// Software we have not bought
	var/list/not_bought_software = list()

	for(var/key in infomorph_software_by_key)
		var/datum/infomorph_software/S = infomorph_software_by_key[key]
		var/list/software_data = list()
		software_data["name"] = S.name
		software_data["id"] = S.id
		if(key in software)
			software_data["on"] = S.is_active(src)
			bought_software.Add(list(software_data))
		else
			software_data["ram"] = S.ram_cost
			not_bought_software.Add(list(software_data))

	data["bought"] = bought_software
	data["not_bought"] = not_bought_software
	data["available_ram"] = ram

	// Emotions
	var/list/emotions = list()
	for(var/name in infomorph_emotions)
		var/list/emote = list()
		emote["name"] = name
		emote["id"] = infomorph_emotions[name]
		emotions.Add(list(emote))

	data["emotions"] = emotions
	data["current_emotion"] = card.current_emotion

	return data

/mob/living/silicon/infomorph/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("software")
			var/soft = params["software"]
			var/datum/infomorph_software/S = software[soft]
			if(S.toggle)
				S.toggle(src)
			else
				S.tgui_interact(src, parent_ui = ui)
			return TRUE

		if("purchase")
			var/soft = params["purchase"]
			var/datum/infomorph_software/S = infomorph_software_by_key[soft]
			if(S && (ram >= S.ram_cost))
				ram -= S.ram_cost
				software[S.id] = S
			return TRUE

		if("image")
			var/img = text2num(params["image"])
			if(img)
				card.setEmotion(img)
			return TRUE

/mob/living/silicon/infomorph/examine(mob/user)
	. = ..(user, infix = ", personal AI")

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	. += "It appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)		. += "<span class='warning'>It doesn't seem to be responding.</span>"
		if(DEAD)			. += "<span class='deadsay'>It looks completely unsalvageable.</span>"
	. += "*---------*"

	if(print_flavor_text())
		. += "[print_flavor_text()]"

	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "It is [pose]"

/mob/living/silicon/infomorph/Life()
	//We're dead or EMP'd or something.
	if (src.stat == 2)
		return

	//Person was sleeved or otherwise moved away from us, become inert card.
	if(!ckey || !key)
		death(0)
		return

	//Clean up the cable if it leaves.
	if(src.cable)
		if(get_dist(src, src.cable) > 1)
			var/turf/T = get_turf(src)
			T.visible_message("<span class='warning'>\The [src]'s data cable rapidly retracts back into its spool.</span>")
			qdel(src.cable)
			cable = null

	//Wipe all the huds, then readd them (of course...)
	handle_regular_hud_updates()

	//In response to EMPs, we can be silenced
	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time = null
			to_chat(src, "<font color=green>Communication circuit reinitialized. Speech and messaging functionality restored.</font>")

	handle_statuses()

	//Only every so often
	if(air_master.current_cycle%30 == 1)
		SStranscore.m_backup(mind, database_key = db_key)

	if(health <= 0)
		death(null,"gives one shrill beep before falling lifeless.")

/mob/living/silicon/infomorph/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else
		health = 100 - getBruteLoss() - getFireLoss()
