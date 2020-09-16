
//The advanced pea-green monochrome lcd of tomorrow.

var/global/list/obj/item/device/pda/PDAs = list()

/obj/item/device/pda
	name = "\improper PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_ID | SLOT_BELT
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/seromi/id.dmi')

	//Main variables
	var/pdachoice = 1
	var/owner = null
	var/default_cartridge = 0 // Access level defined by cartridge
	var/obj/item/weapon/cartridge/cartridge = null //current cartridge

	//Secondary variables
	// var/scanmode = 0 //1 is medical scanner, 2 is forensics, 3 is reagent scanner.
	var/fon = 0 //Is the flashlight function on?
	var/f_lum = 2 //Luminosity for the flashlight function
	var/message_silent = 0 //To beep or not to beep, that is the question
	var/news_silent = 1 //To beep or not to beep, that is the question.  The answer is No.
	var/toff = 0 //If 1, messenger disabled
	var/tnote[0]  //Current Texts
	var/last_text //No text spamming
	var/last_honk //Also no honk spamming that's bad too
	var/ttone = "beep" //The ringtone!
	var/list/ttone_sound = list("beep" = 'sound/machines/twobeep.ogg',
								"boom" = 'sound/effects/explosionfar.ogg',
								"slip" = 'sound/misc/slip.ogg',
								"honk" = 'sound/items/bikehorn.ogg',
								"SKREE" = 'sound/voice/shriek1.ogg',
								// "holy" = 'sound/items/PDA/ambicha4-short.ogg',
								"xeno" = 'sound/voice/hiss1.ogg')
	var/newstone = "beep, beep" //The news ringtone!
	var/lock_code = "" // Lockcode to unlock uplink
	var/honkamt = 0 //How many honks left when infected with honk.exe
	var/mimeamt = 0 //How many silence left when infected with mime.exe
	var/note = "Congratulations, your station has chosen the Thinktronic 5230 Personal Data Assistant!" //Current note in the notepad function
	var/notehtml = ""
	var/cart = "" //A place to stick cartridge menu information
	var/detonate = 1 // Can the PDA be blown up?
	var/hidden = 0 // Is the PDA hidden from the PDA list?
	var/active_conversation = null // New variable that allows us to only view a single conversation.
	var/list/conversations = list()    // For keeping up with who we have PDA messsages from.
	var/new_message = 0			//To remove hackish overlay check
	var/new_news = 0
	var/touch_silent = 0 //If 1, no beeps on interacting.

	var/active_feed				// The selected feed
	var/list/warrant			// The warrant as we last knew it
	var/list/feeds = list()		// The list of feeds as we last knew them
	var/list/feed_info = list()	// The data and contents of each feed as we last knew them

	var/list/cartmodes = list(40, 42, 43, 433, 44, 441, 45, 451, 46, 48, 47, 49) // If you add more cartridge modes add them to this list as well.
	var/list/no_auto_update = list(1, 40, 43, 44, 441, 45, 451)		     // These modes we turn off autoupdate
	var/list/update_every_five = list(3, 41, 433, 46, 47, 48, 49)			     // These we update every 5 ticks

	var/obj/item/weapon/card/id/id = null //Making it possible to slot an ID card into the PDA so it can function as both.
	var/ownjob = null //related to above - this is assignment (potentially alt title)
	var/ownrank = null // this one is rank, never alt title

	var/obj/item/device/paicard/pai = null	// A slot for a personal AI device

	var/spam_proof = FALSE // If true, it can't be spammed by random events.

	// App-based PDAs
	var/model_name = "Thinktronic 5230 Personal Data Assistant"
	var/datum/data/pda/utility/scanmode/scanmode = null
	var/datum/data/pda/app/current_app = null
	var/datum/data/pda/app/lastapp = null
	var/list/programs = list(
		new/datum/data/pda/app/main_menu,
		new/datum/data/pda/app/notekeeper,
		new/datum/data/pda/app/messenger,
		new/datum/data/pda/app/manifest,
		new/datum/data/pda/app/atmos_scanner,
		new/datum/data/pda/utility/scanmode/notes,
		new/datum/data/pda/utility/flashlight)
	var/list/shortcut_cache = list()
	var/list/shortcut_cat_order = list()
	var/list/notifying_programs = list()
	var/retro_mode = 0

/obj/item/device/pda/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "The time [stationtime2text()] is displayed in the corner of the screen."

/obj/item/device/pda/CtrlClick()
	if(issilicon(usr))
		return

	if(can_use(usr))
		remove_pen()
		return
	..()

/obj/item/device/pda/AltClick()
	if(issilicon(usr))
		return

	if ( can_use(usr) )
		if(id)
			remove_id()
		else
			to_chat(usr, "<span class='notice'>This PDA does not have an ID in it.</span>")

//Bloop when using:
/obj/item/device/pda/CouldUseTopic(var/mob/user)
	..()
	if(iscarbon(user) && !touch_silent)
		playsound(src, 'sound/machines/pda_click.ogg', 20)

/obj/item/device/pda/proc/play_ringtone()
	var/S

	if(ttone in ttone_sound)
		S = ttone_sound[ttone]
	else
		S = 'sound/machines/twobeep.ogg'
	playsound(loc, S, 50, 1)
	for(var/mob/O in hearers(3, loc))
		O.show_message(text("[bicon(src)] *[ttone]*"))

/obj/item/device/pda/proc/set_ringtone()
	var/t = input("Please enter new ringtone", name, ttone) as text
	if(in_range(src, usr) && loc == usr)
		if(t)
			if(hidden_uplink && hidden_uplink.check_trigger(usr, lowertext(t), lowertext(lock_code)))
				to_chat(usr, "The PDA softly beeps.")
				close(usr)
			else
				t = sanitize(copytext(t, 1, 20))
				ttone = t
			return 1
	else
		close(usr)
	return 0

/obj/item/device/pda/New(var/mob/living/carbon/human/H)
	..()
	PDAs += src
	PDAs = sortAtom(PDAs)
	update_programs()
	if(default_cartridge)
		cartridge = new default_cartridge(src)
		cartridge.update_programs(src)
	new /obj/item/weapon/pen(src)
	pdachoice = isnull(H) ? 1 : (ishuman(H) ? H.pdachoice : 1)
	switch(pdachoice)
		if(1) icon = 'icons/obj/pda.dmi'
		if(2) icon = 'icons/obj/pda_slim.dmi'
		if(3) icon = 'icons/obj/pda_old.dmi'
		if(4) icon = 'icons/obj/pda_rugged.dmi'
		if(5) icon = 'icons/obj/pda_holo.dmi'
		if(6)
			icon = 'icons/obj/pda_wrist.dmi'
			item_state = icon_state
			item_icons = list(
				slot_belt_str = 'icons/mob/pda_wrist.dmi',
				slot_wear_id_str = 'icons/mob/pda_wrist.dmi',
				slot_gloves_str = 'icons/mob/pda_wrist.dmi'
			)
			desc = "A portable microcomputer by Thinktronic Systems, LTD. This model is a wrist-bound version."
			slot_flags = SLOT_ID | SLOT_BELT | SLOT_GLOVES
			sprite_sheets = list(
				SPECIES_TESHARI = 'icons/mob/species/seromi/pda_wrist.dmi',
				SPECIES_VR_TESHARI = 'icons/mob/species/seromi/pda_wrist.dmi',
			)
		else
			icon = 'icons/obj/pda_old.dmi'
			log_debug("Invalid switch for PDA, defaulting to old PDA icons. [pdachoice] chosen.")
	start_program(find_program(/datum/data/pda/app/main_menu))

/obj/item/device/pda/proc/can_use()
	if(!ismob(loc))
		return FALSE

	var/mob/M = loc
	if(M.incapacitated(INCAPACITATION_ALL))
		return FALSE
	if(src in M.contents)
		return TRUE
	return FALSE

/obj/item/device/pda/GetAccess()
	if(id)
		return id.GetAccess()
	else
		return ..()

/obj/item/device/pda/GetID()
	return id

/obj/item/device/pda/MouseDrop(obj/over_object as obj, src_location, over_location)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && can_use())
		return attack_self(M)
	return

/obj/item/device/pda/proc/close(mob/user)
	SStgui.close_uis(src)

/obj/item/device/pda/attack_self(mob/user as mob)
	user.set_machine(src)

	if(active_uplink_check(user))
		return

	tgui_interact(user)
	return

/obj/item/device/pda/proc/start_program(datum/data/pda/P)
	if(P && ((P in programs) || (cartridge && (P in cartridge.programs))))
		return P.start()
	return 0

/obj/item/device/pda/proc/find_program(type)
	var/datum/data/pda/A = locate(type) in programs
	if(A)
		return A
	if(cartridge)
		A = locate(type) in cartridge.programs
		if(A)
			return A
	return null

// force the cache to rebuild on update_ui
/obj/item/device/pda/proc/update_shortcuts()
	shortcut_cache.Cut()

/obj/item/device/pda/proc/update_programs()
	for(var/A in programs)
		var/datum/data/pda/P = A
		P.pda = src

/obj/item/device/pda/update_icon()
	..()

	overlays.Cut()
	if(new_message || new_news)
		overlays += image(icon, "pda-r")

/obj/item/device/pda/proc/detonate_act(var/obj/item/device/pda/P)
	//TODO: sometimes these attacks show up on the message server
	var/i = rand(1,100)
	var/j = rand(0,1) //Possibility of losing the PDA after the detonation
	var/message = ""
	var/mob/living/M = null
	if(ismob(P.loc))
		M = P.loc

	//switch(i) //Yes, the overlapping cases are intended.
	if(i<=10) //The traditional explosion
		P.explode()
		j=1
		message += "Your [P] suddenly explodes!"
	if(i>=10 && i<= 20) //The PDA burns a hole in the holder.
		j=1
		if(M && isliving(M))
			M.apply_damage( rand(30,60) , BURN)
		message += "You feel a searing heat! Your [P] is burning!"
	if(i>=20 && i<=25) //EMP
		empulse(P.loc, 1, 2, 4, 6, 1)
		message += "Your [P] emits a wave of electromagnetic energy!"
	if(i>=25 && i<=40) //Smoke
		var/datum/effect/effect/system/smoke_spread/chem/S = new /datum/effect/effect/system/smoke_spread/chem
		S.attach(P.loc)
		S.set_up(P, 10, 0, P.loc)
		playsound(P, 'sound/effects/smoke.ogg', 50, 1, -3)
		S.start()
		message += "Large clouds of smoke billow forth from your [P]!"
	if(i>=40 && i<=45) //Bad smoke
		var/datum/effect/effect/system/smoke_spread/bad/B = new /datum/effect/effect/system/smoke_spread/bad
		B.attach(P.loc)
		B.set_up(P, 10, 0, P.loc)
		playsound(P, 'sound/effects/smoke.ogg', 50, 1, -3)
		B.start()
		message += "Large clouds of noxious smoke billow forth from your [P]!"
	if(i>=65 && i<=75) //Weaken
		if(M && isliving(M))
			M.apply_effects(0,1)
		message += "Your [P] flashes with a blinding white light! You feel weaker."
	if(i>=75 && i<=85) //Stun and stutter
		if(M && isliving(M))
			M.apply_effects(1,0,0,0,1)
		message += "Your [P] flashes with a blinding white light! You feel weaker."
	if(i>=85) //Sparks
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, P.loc)
		s.start()
		message += "Your [P] begins to spark violently!"
	if(i>45 && i<65 && prob(50)) //Nothing happens
		message += "Your [P] bleeps loudly."
		j = prob(10)

	if(j && detonate) //This kills the PDA
		qdel(P)
		if(message)
			message += "It melts in a puddle of plastic."
		else
			message += "Your [P] shatters in a thousand pieces!"

	if(M && isliving(M))
		message = "<span class='warning'>[message]</span>"
		M.show_message(message, 1)

/obj/item/device/pda/proc/remove_id()
	if (id)
		if (ismob(loc))
			var/mob/M = loc
			M.put_in_hands(id)
			to_chat(usr, "<span class='notice'>You remove the ID from the [name].</span>")
			playsound(src, 'sound/machines/id_swipe.ogg', 100, 1)
		else
			id.loc = get_turf(src)
		id = null

/obj/item/device/pda/proc/remove_pen()
	var/obj/item/weapon/pen/O = locate() in src
	if(O)
		if(istype(loc, /mob))
			var/mob/M = loc
			if(M.get_active_hand() == null)
				M.put_in_hands(O)
				to_chat(usr, "<span class='notice'>You remove \the [O] from \the [src].</span>")
				return
		O.loc = get_turf(src)
	else
		to_chat(usr, "<span class='notice'>This PDA does not have a pen in it.</span>")

/obj/item/device/pda/proc/create_message(var/mob/living/U = usr, var/obj/item/device/pda/P, var/tap = 1)
	if(tap)
		U.visible_message("<span class='notice'>\The [U] taps on their PDA's screen.</span>")
	var/t = input(U, "Please enter message", P.name, null) as text
	t = sanitize(t)
	//t = readd_quotes(t)
	t = replace_characters(t, list("&#34;" = "\""))
	if (!t || !istype(P))
		return
	if (!in_range(src, U) && loc != U)
		return

	if (isnull(P)||P.toff || toff)
		return

	if (last_text && world.time < last_text + 5)
		return

	if (!can_use())
		return

	if (is_jammed(src))
		return

	last_text = world.time
	var/datum/reception/reception = get_reception(src, P, t)
	t = reception.message

	if(reception.message_server && (reception.telecomms_reception & TELECOMMS_RECEPTION_SENDER)) // only send the message if it's stable
		if(reception.telecomms_reception & TELECOMMS_RECEPTION_RECEIVER == 0) // Does our recipient have a broadcaster on their level?
			to_chat(U, "ERROR: Cannot reach recipient.")
			return
		var/send_result = reception.message_server.send_pda_message("[P.owner]","[owner]","[t]")
		if (send_result)
			to_chat(U, "ERROR: Messaging server rejected your message. Reason: contains '[send_result]'.")
			return

		tnote.Add(list(list("sent" = 1, "owner" = "[P.owner]", "job" = "[P.ownjob]", "message" = "[t]", "target" = "\ref[P]")))
		P.tnote.Add(list(list("sent" = 0, "owner" = "[owner]", "job" = "[ownjob]", "message" = "[t]", "target" = "\ref[src]")))
		for(var/mob/M in player_list)
			if(M.stat == DEAD && M.client && (M.is_preference_enabled(/datum/client_preference/ghost_ears))) // src.client is so that ghosts don't have to listen to mice
				if(istype(M, /mob/new_player))
					continue
				if(M.forbid_seeing_deadchat)
					continue
				M.show_message("<span class='game say'>PDA Message - <span class='name'>[owner]</span> -> <span class='name'>[P.owner]</span>: <span class='message'>[t]</span></span>")

		if(!conversations.Find("\ref[P]"))
			conversations.Add("\ref[P]")
		if(!P.conversations.Find("\ref[src]"))
			P.conversations.Add("\ref[src]")
		to_chat(U, "[bicon(src)] <b>Sent message to [P.owner] ([P.ownjob]), </b>\"[t]\"")

		if (prob(5) && security_level >= SEC_LEVEL_BLUE) //Give the AI a chance of intercepting the message		//VOREStation Edit: no spam interception on lower codes + lower interception chance
			var/who = src.owner
			if(prob(50))
				who = P.owner
			for(var/mob/living/silicon/ai/ai in mob_list)
				// Allows other AIs to intercept the message but the AI won't intercept their own message.
				if(ai.aiPDA != P && ai.aiPDA != src)
					ai.show_message("<i>Intercepted message from <b>[who]</b>: [t]</i>")

		P.new_message_from_pda(src, t)
		SStgui.update_user_uis(U, src) // Update the sending user's PDA UI so that they can see the new message
	else
		to_chat(U, "<span class='notice'>ERROR: Messaging server is not responding.</span>")

/obj/item/device/pda/proc/new_info(var/beep_silent, var/message_tone, var/reception_message)
	if (!beep_silent)
		playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
		for (var/mob/O in hearers(2, loc))
			O.show_message(text("[bicon(src)] *[message_tone]*"))
	//Search for holder of the PDA.
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc
	//Maybe they are a pAI!
	else
		L = get(src, /mob/living/silicon)

	if(L)
		if(reception_message)
			to_chat(L,reception_message)
		SStgui.update_user_uis(L, src) // Update the receiving user's PDA UI so that they can see the new message

/obj/item/device/pda/proc/new_news(var/message)
	new_info(news_silent, newstone, news_silent ? "" : "[bicon(src)] <b>[message]</b>")

	if(!news_silent)
		new_news = 1
		update_icon()

/obj/item/device/pda/proc/new_message_from_pda(var/obj/item/device/pda/sending_device, var/message)
	if (is_jammed(src))
		return
	new_message(sending_device, sending_device.owner, sending_device.ownjob, message)

/obj/item/device/pda/proc/new_message(var/sending_unit, var/sender, var/sender_job, var/message, var/reply = 1)
	var/reception_message = "[bicon(src)] <b>Message from [sender] ([sender_job]), </b>\"[message]\" ([reply ? "<a href='byond://?src=\ref[src];choice=Message;notap=[istype(loc, /mob/living/silicon)];skiprefresh=1;target=\ref[sending_unit]'>Reply</a>" : "Unable to Reply"])"
	new_info(message_silent, ttone, reception_message)

	log_pda("(PDA: [sending_unit]) sent \"[message]\" to [name]", usr)
	new_message = 1
	update_icon()

/obj/item/device/pda/proc/spam_message(sender, message)
	var/reception_message = "\icon[src] <b>Message from [sender] (Unknown / spam?), </b>\"[message]\" (Unable to Reply)"
	new_info(message_silent, ttone, reception_message)

	if(prob(50)) // Give the AI an increased chance to intercept the message
		for(var/mob/living/silicon/ai/ai in mob_list)
			if(ai.aiPDA != src)
				ai.show_message("<i>Intercepted message from <b>[sender]</b></i> (Unknown / spam?) <i>to <b>[owner]</b>: [message]</i>")

/obj/item/device/pda/verb/verb_reset_pda()
	set category = "Object"
	set name = "Reset PDA"
	set src in usr

	if(issilicon(usr))
		return

	if(can_use(usr))
		start_program(find_program(/datum/data/pda/app/main_menu))
		notifying_programs.Cut()
		overlays -= image('icons/obj/pda.dmi', "pda-r")
		to_chat(usr, "<span class='notice'>You press the reset button on \the [src].</span>")
	else
		to_chat(usr, "<span class='notice'>You cannot do this while restrained.</span>")

/obj/item/device/pda/verb/verb_remove_id()
	set category = "Object"
	set name = "Remove id"
	set src in usr

	if(issilicon(usr))
		return

	if ( can_use(usr) )
		if(id)
			remove_id()
		else
			to_chat(usr, "<span class='notice'>This PDA does not have an ID in it.</span>")
	else
		to_chat(usr, "<span class='notice'>You cannot do this while restrained.</span>")


/obj/item/device/pda/verb/verb_remove_pen()
	set category = "Object"
	set name = "Remove pen"
	set src in usr

	if(issilicon(usr))
		return

	if ( can_use(usr) )
		remove_pen()
	else
		to_chat(usr, "<span class='notice'>You cannot do this while restrained.</span>")

/obj/item/device/pda/verb/verb_remove_cartridge()
	set category = "Object"
	set name = "Remove cartridge"
	set src in usr

	if(issilicon(usr))
		return

	if(!can_use(usr))
		to_chat(usr, "<span class='notice'>You cannot do this while restrained.</span>")
		return

	if(isnull(cartridge))
		to_chat(usr, "<span class='notice'>There's no cartridge to eject.</span>")
		return

	cartridge.forceMove(get_turf(src))
	if(ismob(loc))
		var/mob/M = loc
		M.put_in_hands(cartridge)
	// mode = 0
	// scanmode = 0
	if (cartridge.radio)
		cartridge.radio.hostpda = null
	to_chat(usr, "<span class='notice'>You remove \the [cartridge] from the [name].</span>")
	playsound(src, 'sound/machines/id_swipe.ogg', 100, 1)
	cartridge = null

/obj/item/device/pda/proc/id_check(mob/user as mob, choice as num)//To check for IDs; 1 for in-pda use, 2 for out of pda use.
	if(choice == 1)
		if (id)
			remove_id()
			return 1
		else
			var/obj/item/I = user.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id) && user.unEquip(I))
				I.loc = src
				id = I
			return 1
	else
		var/obj/item/weapon/card/I = user.get_active_hand()
		if (istype(I, /obj/item/weapon/card/id) && I:registered_name && user.unEquip(I))
			var/obj/old_id = id
			I.loc = src
			id = I
			user.put_in_hands(old_id)
			return 1
	return 0

// access to status display signals
/obj/item/device/pda/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(istype(C, /obj/item/weapon/cartridge) && !cartridge)
		cartridge = C
		user.drop_item()
		cartridge.loc = src
		cartridge.update_programs(src)
		update_shortcuts()
		to_chat(usr, "<span class='notice'>You insert [cartridge] into [src].</span>")
		if(cartridge.radio)
			cartridge.radio.hostpda = src

	else if(istype(C, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/idcard = C
		if(!idcard.registered_name)
			to_chat(user, "<span class='notice'>\The [src] rejects the ID.</span>")
			return
		if(!owner)
			owner = idcard.registered_name
			ownjob = idcard.assignment
			ownrank = idcard.rank
			name = "PDA-[owner] ([ownjob])"
			to_chat(user, "<span class='notice'>Card scanned.</span>")
		else
			//Basic safety check. If either both objects are held by user or PDA is on ground and card is in hand.
			if(((src in user.contents) && (C in user.contents)) || (istype(loc, /turf) && in_range(src, user) && (C in user.contents)) )
				if(id_check(user, 2))
					to_chat(user, "<span class='notice'>You put the ID into \the [src]'s slot.</span>")
					updateSelfDialog()//Update self dialog on success.
			return	//Return in case of failed check or when successful.
		updateSelfDialog()//For the non-input related code.
	else if(istype(C, /obj/item/device/paicard) && !src.pai)
		user.drop_item()
		C.loc = src
		pai = C
		to_chat(user, "<span class='notice'>You slot \the [C] into \the [src].</span>")
		SStgui.update_uis(src) // update all UIs attached to src
	else if(istype(C, /obj/item/weapon/pen))
		var/obj/item/weapon/pen/O = locate() in src
		if(O)
			to_chat(user, "<span class='notice'>There is already a pen in \the [src].</span>")
		else
			user.drop_item()
			C.loc = src
			to_chat(user, "<span class='notice'>You slot \the [C] into \the [src].</span>")
	return

/obj/item/device/pda/attack(mob/living/C as mob, mob/living/user as mob)
	if (istype(C, /mob/living/carbon) && scanmode)
		scanmode.scan_mob(C, user)

		// switch(scanmode)
		// 	if(1)

		// 		for (var/mob/O in viewers(C, null))
		// 			O.show_message("<span class='warning'>\The [user] has analyzed [C]'s vitals!</span>", 1)

		// 		user.show_message("<span class='notice'>Analyzing Results for [C]:</span>")
		// 		user.show_message("<span class='notice'>    Overall Status: [C.stat > 1 ? "dead" : "[C.health - C.halloss]% healthy"]</span>", 1)
		// 		user.show_message(text("<span class='notice'>    Damage Specifics:</span> <span class='[]'>[]</span>-<span class='[]'>[]</span>-<span class='[]'>[]</span>-<span class='[]'>[]</span>",
		// 				(C.getOxyLoss() > 50) ? "warning" : "", C.getOxyLoss(),
		// 				(C.getToxLoss() > 50) ? "warning" : "", C.getToxLoss(),
		// 				(C.getFireLoss() > 50) ? "warning" : "", C.getFireLoss(),
		// 				(C.getBruteLoss() > 50) ? "warning" : "", C.getBruteLoss()
		// 				), 1)
		// 		user.show_message("<span class='notice'>    Key: Suffocation/Toxin/Burns/Brute</span>", 1)
		// 		user.show_message("<span class='notice'>    Body Temperature: [C.bodytemperature-T0C]&deg;C ([C.bodytemperature*1.8-459.67]&deg;F)</span>", 1)
		// 		if(C.tod && (C.stat == DEAD || (C.status_flags & FAKEDEATH)))
		// 			user.show_message("<span class='notice'>    Time of Death: [C.tod]</span>")
		// 		if(istype(C, /mob/living/carbon/human))
		// 			var/mob/living/carbon/human/H = C
		// 			var/list/damaged = H.get_damaged_organs(1,1)
		// 			user.show_message("<span class='notice'>Localized Damage, Brute/Burn:</span>",1)
		// 			if(length(damaged)>0)
		// 				for(var/obj/item/organ/external/org in damaged)
		// 					user.show_message(text("<span class='notice'>     []: <span class='[]'>[]</span>-<span class='[]'>[]</span></span>",
		// 							capitalize(org.name), (org.brute_dam > 0) ? "warning" : "notice", org.brute_dam, (org.burn_dam > 0) ? "warning" : "notice", org.burn_dam),1)
		// 			else
		// 				user.show_message("<span class='notice'>    Limbs are OK.</span>",1)

		// 	if(2)
		// 		if (!istype(C:dna, /datum/dna))
		// 			to_chat(user, "<span class='notice'>No fingerprints found on [C]</span>")
		// 		else
		// 			to_chat(user, text("<span class='notice'>\The [C]'s Fingerprints: [md5(C:dna.uni_identity)]</span>"))
		// 		if ( !(C:blood_DNA) )
		// 			to_chat(user, "<span class='notice'>No blood found on [C]</span>")
		// 			if(C:blood_DNA)
		// 				qdel(C:blood_DNA)
		// 		else
		// 			to_chat(user, "<span class='notice'>Blood found on [C]. Analysing...</span>")
		// 			spawn(15)
		// 				for(var/blood in C:blood_DNA)
		// 					to_chat(user, "<span class='notice'>Blood type: [C:blood_DNA[blood]]\nDNA: [blood]</span>")

		// 	if(4)
		// 		user.visible_message("<span class='warning'>\The [user] has analyzed [C]'s radiation levels!</span>", "<span class='notice'>You have analyzed [C]'s radiation levels!</span>")
		// 		to_chat(user, "<span class='notice'>Analyzing Results for [C]:</span>")
		// 		if(C.radiation)
		// 			to_chat(user, "<span class='notice'>Radiation Level: [C.radiation]</span>")
		// 		else
		// 			to_chat(user, "<span class='notice'>No radiation detected.</span>")

/obj/item/device/pda/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(proximity && scanmode)
		scanmode.scan_atom(A, user)
	// if(!proximity) return
	// switch(scanmode)

	// 	if(3)
	// 		if(!isobj(A))
	// 			return
	// 		if(!isnull(A.reagents))
	// 			if(A.reagents.reagent_list.len > 0)
	// 				var/reagents_length = A.reagents.reagent_list.len
	// 				to_chat(user, "<span class='notice'>[reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found.</span>")
	// 				for (var/re in A.reagents.reagent_list)
	// 					to_chat(user, "<span class='notice'>    [re]</span>")
	// 			else
	// 				to_chat(user, "<span class='notice'>No active chemical agents found in [A].</span>")
	// 		else
	// 			to_chat(user, "<span class='notice'>No significantchemical agents found in [A].</span>")

	// 	if(5)
	// 		analyze_gases(A, user)

	// if (!scanmode && istype(A, /obj/item/weapon/paper) && owner)
	// 	// JMO 20140705: Makes scanned document show up properly in the notes. Not pretty for formatted documents,
	// 	// as this will clobber the HTML, but at least it lets you scan a document. You can restore the original
	// 	// notes by editing the note again. (Was going to allow you to edit, but scanned documents are too long.)
	// 	var/raw_scan = (A:info)
	// 	var/formatted_scan = ""
	// 	// Scrub out the tags (replacing a few formatting ones along the way)

	// 	// Find the beginning and end of the first tag.
	// 	var/tag_start = findtext(raw_scan,"<")
	// 	var/tag_stop = findtext(raw_scan,">")

	// 	// Until we run out of complete tags...
	// 	while(tag_start&&tag_stop)
	// 		var/pre = copytext(raw_scan,1,tag_start) // Get the stuff that comes before the tag
	// 		var/tag = lowertext(copytext(raw_scan,tag_start+1,tag_stop)) // Get the tag so we can do intellegent replacement
	// 		var/tagend = findtext(tag," ") // Find the first space in the tag if there is one.

	// 		// Anything that's before the tag can just be added as is.
	// 		formatted_scan = formatted_scan+pre

	// 		// If we have a space after the tag (and presumably attributes) just crop that off.
	// 		if (tagend)
	// 			tag=copytext(tag,1,tagend)

	// 		if (tag=="p"||tag=="/p"||tag=="br") // Check if it's I vertical space tag.
	// 			formatted_scan=formatted_scan+"<br>" // If so, add some padding in.

	// 		raw_scan = copytext(raw_scan,tag_stop+1) // continue on with the stuff after the tag

	// 		// Look for the next tag in what's left
	// 		tag_start = findtext(raw_scan,"<")
	// 		tag_stop = findtext(raw_scan,">")

	// 	// Anything that is left in the page. just tack it on to the end as is
	// 	formatted_scan=formatted_scan+raw_scan

    // 	// If there is something in there already, pad it out.
	// 	if (length(note)>0)
	// 		note = note + "<br><br>"

    // 	// Store the scanned document to the notes
	// 	note = "Scanned Document. Edit to restore previous notes/delete scan.<br>----------<br>" + formatted_scan + "<br>"
	// 	// notehtml ISN'T set to allow user to get their old notes back. A better implementation would add a "scanned documents"
	// 	// feature to the PDA, which would better convey the availability of the feature, but this will work for now.

	// 	// Inform the user
	// 	to_chat(user, "<span class='notice'>Paper scanned and OCRed to notekeeper.</span>") //concept of scanning paper copyright brainoblivion 2009


/obj/item/device/pda/proc/explode() //This needs tuning. //Sure did.
	if(!src.detonate) return
	var/turf/T = get_turf(src.loc)
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, 0, 0, 1, rand(1,2))
	return

/obj/item/device/pda/Destroy()
	PDAs -= src
	if (src.id && prob(100) && !delete_id) //IDs are kept in 90% of the cases //VOREStation Edit - 100% of the cases, excpet when specified otherwise
		src.id.forceMove(get_turf(src.loc))
	else
		QDEL_NULL(src.id)

	current_app = null
	scanmode = null
	QDEL_NULL(pai)
	QDEL_LIST(programs)
	QDEL_NULL(cartridge)
	return ..()

/obj/item/device/pda/proc/available_pdas()
	var/list/names = list()
	var/list/plist = list()
	var/list/namecounts = list()

	if (toff)
		to_chat(usr, "Turn on your receiver in order to send messages.")
		return

	for (var/obj/item/device/pda/P in PDAs)
		if (!P.owner)
			continue
		else if(P.hidden)
			continue
		else if (P == src)
			continue
		else if (P.toff)
			continue

		var/name = P.owner
		if (name in names)
			namecounts[name]++
			name = text("[name] ([namecounts[name]])")
		else
			names.Add(name)
			namecounts[name] = 1

		plist[text("[name]")] = P
	return plist


//Some spare PDAs in a box
/obj/item/weapon/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdabox"

/obj/item/weapon/storage/box/PDAs/New()
	..()
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/device/pda(src)
	new /obj/item/weapon/cartridge/head(src)

	var/newcart = pick(	/obj/item/weapon/cartridge/engineering,
						/obj/item/weapon/cartridge/security,
						/obj/item/weapon/cartridge/medical,
						/obj/item/weapon/cartridge/signal/science,
						/obj/item/weapon/cartridge/quartermaster)
	new newcart(src)

// Pass along the pulse to atoms in contents, largely added so pAIs are vulnerable to EMP
/obj/item/device/pda/emp_act(severity)
	for(var/atom/A in src)
		A.emp_act(severity)

/obj/item/device/pda/proc/analyze_air()
	var/list/results = list()
	var/turf/T = get_turf(src.loc)
	if(!isnull(T))
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles
		if (total_moles)
			var/o2_level = environment.gas["oxygen"]/total_moles
			var/n2_level = environment.gas["nitrogen"]/total_moles
			var/co2_level = environment.gas["carbon_dioxide"]/total_moles
			var/phoron_level = environment.gas["phoron"]/total_moles
			var/unknown_level =  1-(o2_level+n2_level+co2_level+phoron_level)

			// entry is what the element is describing
			// Type identifies which unit or other special characters to use
			// Val is the information reported
			// Bad_high/_low are the values outside of which the entry reports as dangerous
			// Poor_high/_low are the values outside of which the entry reports as unideal
			// Values were extracted from the template itself
			results = list(
						list("entry" = "Pressure", "units" = "kPa", "val" = "[round(pressure,0.1)]", "bad_high" = 120, "poor_high" = 110, "poor_low" = 95, "bad_low" = 80),
						list("entry" = "Temperature", "units" = "&degC", "val" = "[round(environment.temperature-T0C,0.1)]", "bad_high" = 35, "poor_high" = 25, "poor_low" = 15, "bad_low" = 5),
						list("entry" = "Oxygen", "units" = "kPa", "val" = "[round(o2_level*100,0.1)]", "bad_high" = 140, "poor_high" = 135, "poor_low" = 19, "bad_low" = 17),
						list("entry" = "Nitrogen", "units" = "kPa", "val" = "[round(n2_level*100,0.1)]", "bad_high" = 105, "poor_high" = 85, "poor_low" = 50, "bad_low" = 40),
						list("entry" = "Carbon Dioxide", "units" = "kPa", "val" = "[round(co2_level*100,0.1)]", "bad_high" = 10, "poor_high" = 5, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Phoron", "units" = "kPa", "val" = "[round(phoron_level*100,0.01)]", "bad_high" = 0.5, "poor_high" = 0, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Other", "units" = "kPa", "val" = "[round(unknown_level, 0.01)]", "bad_high" = 1, "poor_high" = 0.5, "poor_low" = 0, "bad_low" = 0)
						)

	if(isnull(results))
		results = list(list("entry" = "pressure", "units" = "kPa", "val" = "0", "bad_high" = 120, "poor_high" = 110, "poor_low" = 95, "bad_low" = 80))
	return results
