
//The advanced pea-green monochrome lcd of tomorrow.

var/global/list/obj/item/device/pda/PDAs = list()

/obj/item/device/pda
	name = "\improper PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda_vr.dmi'			//VOREStation edit
	icon_state = "pda"
	item_state = "electronic"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_ID | SLOT_BELT
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/id.dmi')

	//Main variables
	var/pdachoice = 1
	var/owner = null
	var/default_cartridge = 0 // Access level defined by cartridge
	var/obj/item/weapon/cartridge/cartridge = null //current cartridge

	//Secondary variables
	var/model_name = "Thinktronic 5230 Personal Data Assistant"
	var/datum/data/pda/utility/scanmode/scanmode = null

	var/lock_code = "" // Lockcode to unlock uplink
	var/honkamt = 0 //How many honks left when infected with honk.exe
	var/mimeamt = 0 //How many silence left when infected with mime.exe
	var/detonate = 1 // Can the PDA be blown up?
	var/ttone = "beep" //The ringtone!
	var/list/ttone_sound = list("beep" = 'sound/machines/twobeep.ogg',
								"boom" = 'sound/effects/explosionfar.ogg',
								"slip" = 'sound/misc/slip.ogg',
								"honk" = 'sound/items/bikehorn.ogg',
								"SKREE" = 'sound/voice/shriek1.ogg',
								"xeno" = 'sound/voice/hiss1.ogg',
								"spark" = 'sound/effects/sparks4.ogg',
								"rad" = 'sound/items/geiger/high1.ogg',
								"servo" = 'sound/machines/rig/rigservo.ogg',
								"buh-boop" = 'sound/misc/buh-boop.ogg',
								"trombone" = 'sound/misc/sadtrombone.ogg',
								"whistle" = 'sound/misc/boatswain.ogg',
								"chirp" = 'sound/misc/nymphchirp.ogg',
								"slurp" = 'sound/items/drink.ogg',
								"pwing" = 'sound/items/nif_tone_good.ogg',
								"clack" = 'sound/items/storage/toolbox.ogg',
								"bzzt" = 'sound/misc/null.ogg',	//vibrate mode
								"chimes" = 'sound/misc/notice3.ogg',
								"prbt" = 'sound/voice/prbt.ogg',
								"bark" = 'sound/voice/bark2.ogg',
								"bork" = 'sound/voice/bork.ogg',
								"roark" = 'sound/voice/roarbark.ogg',
								"chitter" = 'sound/voice/moth/moth_chitter.ogg',
								"squish" = 'sound/effects/slime_squish.ogg')
	var/hidden = 0 // Is the PDA hidden from the PDA list?
	var/touch_silent = 0 //If 1, no beeps on interacting.

	var/obj/item/weapon/card/id/id = null //Making it possible to slot an ID card into the PDA so it can function as both.
	var/ownjob = null //related to above - this is assignment (potentially alt title)
	var/ownrank = null // this one is rank, never alt title

	var/obj/item/device/paicard/pai = null	// A slot for a personal AI device

	var/spam_proof = FALSE // If true, it can't be spammed by random events.

	var/datum/data/pda/app/current_app = null
	var/datum/data/pda/app/lastapp = null
	var/list/programs = list(
		new/datum/data/pda/app/main_menu,
		new/datum/data/pda/app/notekeeper,
		new/datum/data/pda/app/news,
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

/obj/item/device/pda/proc/play_ringtone()
	var/S

	if(ttone in ttone_sound)
		S = ttone_sound[ttone]
	else
		S = 'sound/machines/twobeep.ogg'
	playsound(loc, S, 50, 1)
	for(var/mob/O in hearers(3, loc))
		O.show_message(text("\icon[src][bicon(src)] *[ttone]*"))

/obj/item/device/pda/proc/set_ringtone()
	var/t = tgui_input_text(usr, "Please enter new ringtone", name, ttone)
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
		if(1) icon = 'icons/obj/pda_vr.dmi'			//VOREStation edit
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
				SPECIES_TESHARI = 'icons/mob/species/teshari/pda_wrist.dmi',
				SPECIES_VR_TESHARI = 'icons/mob/species/teshari/pda_wrist.dmi',
			)
		if(7) icon = 'icons/obj/pda_slider.dmi'			//VOREStation edit
		if(8)
			icon = 'icons/obj/pda_vintage.dmi'
			desc = "A vintage communication device. This device has been refitted for compatibility with modern messaging systems, ROM cartridges and ID cards. Despite its heavy modifications it does not feature voice communication."

		else
			icon = 'icons/obj/pda_old.dmi'
			log_debug("Invalid switch for PDA, defaulting to old PDA icons. [pdachoice] chosen.")
	add_overlay("pda-pen")
	start_program(find_program(/datum/data/pda/app/main_menu))

/obj/item/device/pda/proc/can_use(mob/user)
	return (tgui_status(user, GLOB.tgui_inventory_state) == STATUS_INTERACTIVE)

/obj/item/device/pda/GetAccess()
	if(id)
		return id.GetAccess()
	else
		return ..()

/obj/item/device/pda/GetID()
	return id

/obj/item/device/pda/MouseDrop(obj/over_object as obj, src_location, over_location)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && can_use(usr))
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
	for(var/datum/data/pda/P as anything in programs)
		P.pda = src

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
		cut_overlay("pda-id")
		id = null

/obj/item/device/pda/proc/remove_pen()
	var/obj/item/weapon/pen/O = locate() in src
	if(O)
		if(istype(loc, /mob))
			var/mob/M = loc
			if(M.get_active_hand() == null)
				M.put_in_hands(O)
				to_chat(usr, "<span class='notice'>You remove \the [O] from \the [src].</span>")
				cut_overlay("pda-pen")
				return
		O.loc = get_turf(src)
	else
		to_chat(usr, "<span class='notice'>This PDA does not have a pen in it.</span>")

/obj/item/device/pda/verb/verb_reset_pda()
	set category = "Object"
	set name = "Reset PDA"
	set src in usr

	if(issilicon(usr))
		return

	if(can_use(usr))
		start_program(find_program(/datum/data/pda/app/main_menu))
		notifying_programs.Cut()
		cut_overlay("pda-r")
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
	update_programs()
	update_shortcuts()
	start_program(find_program(/datum/data/pda/app/main_menu))


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
					add_overlay("pda-id")
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
			add_overlay("pda-pen")
	return

/obj/item/device/pda/attack(mob/living/C as mob, mob/living/user as mob)
	if (istype(C, /mob/living/carbon) && scanmode)
		scanmode.scan_mob(C, user)

/obj/item/device/pda/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(proximity && scanmode)
		scanmode.scan_atom(A, user)

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

//Some spare PDAs in a box
/obj/item/weapon/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/pda_vr.dmi'			//VOREStation edit
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
