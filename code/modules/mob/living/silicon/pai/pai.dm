/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/pai.dmi'
	icon_state = "pai-repairbot"

	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = 1
	mob_size = MOB_SMALL
	softfall = TRUE

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

	var/atom/movable/screen/pai/pai_fold_display = null

	var/chassis_name = PAI_DEFAULT_CHASSIS	// A record of your chosen chassis.

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
	var/paiDA = 0			// Death alarm

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

	var/eye_glow = TRUE
	var/hide_glow = FALSE
	var/image/eye_layer = null		// Holds the eye overlay.
	var/eye_color = "#00ff0d"
	var/icon/holo_icon_south
	var/icon/holo_icon_north
	var/icon/holo_icon_east
	var/icon/holo_icon_west
	var/holo_icon_dimension_X = 32
	var/holo_icon_dimension_Y = 32

	//These vars keep track of whether you have the related software, used for easily updating the UI
	var/soft_ut = FALSE	//universal translator
	var/soft_mr = FALSE	//medical records
	var/soft_sr = FALSE	//security records
	var/soft_dj = FALSE	//door jack
	var/soft_as = FALSE	//atmosphere sensor
	var/soft_si = FALSE	//signaler
	var/soft_ar = FALSE	//ar hud
	var/soft_da = FALSE //death alarm

	vore_capacity = 1
	vore_capacity_ex = list("stomach" = 1)


//////////////////////////////////////////////////////////////////////////////////////////////////
// Init and destroy
//////////////////////////////////////////////////////////////////////////////////////////////////
/mob/living/silicon/pai/Initialize(mapload)
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

	add_verb(src, /mob/living/silicon/pai/proc/choose_chassis)
	add_verb(src, /mob/living/silicon/pai/proc/choose_verbs)
	add_verb(src, /mob/proc/dominate_predator)
	add_verb(src, /mob/living/proc/dominate_prey)
	add_verb(src, /mob/living/proc/set_size)
	add_verb(src, /mob/living/proc/shred_limb)

	//PDA
	pda = new(src)
	pda.ownjob = "Personal Assistant"
	pda.owner = text("[]", src)
	pda.name = pda.owner + " (" + pda.ownjob + ")"

	var/datum/data/pda/app/messenger/M = pda.find_program(/datum/data/pda/app/messenger)
	if(M)
		M.toff = FALSE

/mob/living/silicon/pai/Login()
	. = ..()
	if(!holo_icon_south)
		last_special = world.time + 100		//Let's give get_character_icon time to work
		get_character_icon()

	// Vorestation Edit: Meta Info for pAI
	if (client.prefs)
		ooc_notes = client.prefs.read_preference(/datum/preference/text/living/ooc_notes)
		ooc_notes_likes = client.prefs.read_preference(/datum/preference/text/living/ooc_notes_likes)
		ooc_notes_dislikes = client.prefs.read_preference(/datum/preference/text/living/ooc_notes_dislikes)
		ooc_notes_favs = read_preference(/datum/preference/text/living/ooc_notes_favs)
		ooc_notes_maybes = read_preference(/datum/preference/text/living/ooc_notes_maybes)
		ooc_notes_style = read_preference(/datum/preference/toggle/living/ooc_notes_style)
		private_notes = client.prefs.read_preference(/datum/preference/text/living/private_notes)

	src << sound('sound/effects/pai_login.ogg', volume = 75)	//VOREStation Add

/mob/living/silicon/pai/proc/apply_preferences(client/cli, var/silent = 1)
	if(!cli?.prefs)
		return FALSE
	var/datum/preferences/pref = cli.prefs

	SetName(pref.read_preference(/datum/preference/text/pai_name))
	flavor_text = pref.read_preference(/datum/preference/text/pai_description)
	change_chassis(pref.read_preference(/datum/preference/text/pai_chassis))
	gender = pref.identifying_gender
	eye_color = pref.read_preference(/datum/preference/color/pai_eye_color)
	card.screen_color = eye_color
	card.setEmotion(GLOB.pai_emotions[pref.read_preference(/datum/preference/text/pai_emotion)])

	update_icon()
	return TRUE

/mob/living/silicon/pai/Destroy()
	release_vore_contents()
	if(ckey)
		GLOB.paikeys -= ckey
	return ..()

/mob/living/silicon/pai/clear_client()
	if(ckey)
		GLOB.paikeys -= ckey
	return ..()

// No binary for pAIs.
/mob/living/silicon/pai/binarycheck()
	return 0

//proc override to avoid pAI players being invisible while the chassis selection window is open
/mob/living/silicon/pai/proc/choose_chassis()
	set category = "Abilities.pAI Commands"
	set name = "Choose Chassis"
	var/choice

	choice = tgui_input_list(src, "What would you like to use for your mobile chassis' appearance?", "Chassis Choice", SSpai.get_chassis_list())
	if(!choice) return
	var/oursize = size_multiplier
	resize(1, FALSE, TRUE, TRUE, FALSE)		//We resize ourselves to normal here for a moment to let the vis_height get reset
	change_chassis(choice)

	update_icon()
	resize(oursize, FALSE, TRUE, TRUE, FALSE)	//And then back again now that we're sure the vis_height is correct.

/mob/living/silicon/pai/proc/change_chassis(new_chassis)
	if(!(new_chassis in SSpai.get_chassis_list()))
		new_chassis = PAI_DEFAULT_CHASSIS
	chassis_name = new_chassis

	// Get icon data setup
	var/datum/pai_sprite/chassis_data = SSpai.chassis_data(chassis_name)
	if(chassis_data.holo_projector)
		// Rebuild holosprite from character
		if(!holo_icon_south)
			get_character_icon()
	else
		// Get data from our sprite datum
		icon = chassis_data.sprite_icon
		pixel_x = chassis_data.pixel_x
		default_pixel_x = pixel_x
		pixel_y = chassis_data.pixel_y
		default_pixel_y = pixel_y
		vis_height = chassis_data.vis_height

	// Drops you if you change to a non-flying chassis
	if(chassis_data.flying)
		hovering = TRUE
	else
		hovering = FALSE
		if(isopenspace(loc))
			fall()

	// Set vore size.
	vore_capacity = max(1, chassis_data.belly_states) // Minimum of 1
	vore_capacity_ex = list("stomach" = vore_capacity)

	// Emergency eject if you change to a smaller belly
	if(vore_fullness > vore_capacity && vore_selected)
		vore_selected.release_all_contents(TRUE)

	update_icon()


//////////////////////////////////////////////////////////////////////////////////////////////////
// Click interactions
//////////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/silicon/pai/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/card/id/ID = W.GetID()
	if(ID)
		if (idaccessible == 1)
			switch(tgui_alert(user, "Do you wish to add access to [src] or remove access from [src]?","Access Modify",list("Add Access","Remove Access", "Cancel")))
				if("Add Access")
					idcard.access |= ID.GetAccess()
					to_chat(user, span_notice("You add the access from the [W] to [src]."))
					to_chat(src, span_notice("\The [user] swipes the [W] over you. You copy the access codes."))
					if(radio)
						radio.recalculateChannels()
					return
				if("Remove Access")
					idcard.access = list()
					to_chat(user, span_notice("You remove the access from [src]."))
					to_chat(src, span_warning("\The [user] swipes the [W] over you, removing access codes from you."))
					if(radio)
						radio.recalculateChannels()
					return
				if("Cancel", null)
					return
		else if (istype(W, /obj/item/card/id) && idaccessible == 0)
			to_chat(user, span_notice("[src] is not accepting access modifcations at this time."))
			return

//Overriding this will stop a number of headaches down the track.
/mob/living/silicon/pai/attackby(obj/item/W as obj, mob/user as mob)
	if(W.force)
		visible_message(span_danger("[user.name] attacks [src] with [W]!"))
		src.adjustBruteLoss(W.force)
		src.updatehealth()
	else
		visible_message(span_warning("[user.name] bonks [src] harmlessly with [W]."))
	spawn(1)
		if(stat != DEAD) close_up()
	return

/mob/living/silicon/pai/attack_hand(mob/user as mob)
	if(user.a_intent == I_HELP)
		visible_message(span_notice("[user.name] pats [src]."))
	else
		visible_message(span_danger("[user.name] boops [src] on the head."))
		close_up()

/mob/living/silicon/pai/UnarmedAttack(atom/A, proximity_flag)
	. = ..()

	// Some restricted objects to interact with
	var/obj/O = A
	if(istype(O) && O.allow_pai_interaction(proximity_flag))
		O.attack_hand(src)
		return

	// Zmovement already allows these to be used with the verbs anyway
	if(istype(A,/obj/structure/ladder))
		var/obj/structure/ladder/L = A
		L.attack_hand(src)
		return

	// We don't want to pick these up, just toggle them
	if(istype(A,/obj/item/flashlight/lamp))
		var/obj/item/flashlight/lamp/L = A
		L.toggle_light()
		return

	// All other computers explain why it's not accessible by showing a firewall warning
	if(istype(A,/obj/machinery/computer))
		to_chat(src,span_warning("A firewall prevents you from interfacing with this device!"))
		return

	if(!ismob(A) || A == src)
		return

	switch(a_intent)
		if(I_HELP)
			if(isliving(A))
				hug(src, A)
		if(I_GRAB)
			pai_nom(A)

// Allow card inhabited machines to be interacted with
// This has to override ClickOn because of storage depth nonsense with how pAIs are in cards in GLOB.machines
/mob/living/silicon/pai/ClickOn(var/atom/A, var/params)
	if(istype(A, /obj/machinery))
		var/obj/machinery/M = A
		if(M.paicard == card)
			M.attack_ai(src)
			return
	return ..()

// Handle being picked up.
/mob/living/silicon/pai/get_scooped(var/mob/living/carbon/grabber, var/self_drop)
	var/obj/item/holder/H = ..(grabber, self_drop)
	if(!istype(H))
		return

	H.icon_state = SSpai.chassis_data(chassis_name).sprite_icon_state
	grabber.update_inv_l_hand()
	grabber.update_inv_r_hand()
	return H


//////////////////////////////////////////////////////////////////////////////////////////////////
// Status and damage
//////////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/silicon/pai/get_status_tab_items()
	. = ..()
	. += ""
	. += show_silenced()

/mob/living/silicon/pai/adjustBruteLoss(amount, include_robo)
	. = ..()
	if(amount > 0 && health <= 90)	//Something's probably attacking us!
		if(prob(amount))	//The more damage it is doing, the more likely it is to damage something important!
			card.damage_random_component()

/mob/living/silicon/pai/adjustFireLoss(amount, include_robo)
	. = ..()
	if(amount > 0 && health <= 90)
		if(prob(amount))
			card.damage_random_component()

/mob/living/silicon/pai/restrained()
	if(istype(src.loc,/obj/item/paicard))
		return 0
	..()

/mob/living/silicon/pai/emp_act(severity, recursive)
	// Silence for 2 minutes
	// 20% chance to damage critical components
	// 50% chance to damage a non critical component
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	src.silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	to_chat(src, span_infoplain(span_green(span_bold("Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete."))))
	if(prob(20))
		var/turf/T = get_turf_or_move(src.loc)
		card.death_damage()
		for (var/mob/M in viewers(T))
			M.show_message(span_infoplain(span_red("A shower of sparks spray from [src]'s inner workings.")), 3, span_infoplain(span_red("You hear and smell the ozone hiss of electrical sparks being expelled violently.")), 2)
		return
	if(prob(50))
		card.damage_random_component(TRUE)
	switch(pick(1,2,3))
		if(1)
			src.master = null
			src.master_dna = null
			to_chat(src, span_infoplain(span_green("You feel unbound.")))
		if(2)
			var/command
			if(severity  == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyze")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyze")
			src.pai_law0 = "[command] your master."
			to_chat(src, span_infoplain(span_green("Pr1m3 d1r3c71v3 uPd473D.")))
		if(3)
			to_chat(src, span_infoplain(span_green("You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all.")))

// this function shows the information about being silenced as a pAI in the Status panel
/mob/living/silicon/pai/proc/show_silenced()
	. = ""
	if(src.silence_time)
		var/timeleft = round((silence_time - world.timeofday)/10 ,1)
		. += "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]"

/mob/living/silicon/pai/proc/full_restore() //This is using do_after all kinds of weird...
	adjustBruteLoss(- bruteloss)
	adjustFireLoss(- fireloss)
	do_after(src, 1 SECONDS, target = src)
	card.setEmotion(16)
	stat = CONSCIOUS
	do_after(src, 5 SECONDS, target = src)
	var/mob/observer/dead/ghost = src.get_ghost()
	if(ghost)
		ghost.notify_revive("Someone is trying to revive you. Re-enter your body if you want to be revived!", 'sound/effects/pai-restore.ogg', source = card)
	canmove = TRUE
	card.setEmotion(15)
	playsound(card, 'sound/effects/pai-restore.ogg', 50, FALSE)
	card.visible_message(span_filter_notice("\The [card] chimes."), runemessage = "chime")

//////////////////////////////////////////////////////////////////////////////////////////////////
// Update icons
//////////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/silicon/pai/update_icon()
	. = ..()

	var/datum/pai_sprite/chassis_data = SSpai.chassis_data(chassis_name)
	if(chassis_data.holo_projector)
		icon_state = null
		icon = holo_icon_south
		add_eyes()
		return

	update_fullness()

	// Don't get a vore belly size if we have no belly size set!
	var/belly_size = CLAMP(vore_fullness, 0, chassis_data.belly_states)
	if(resting && !chassis_data.resting_belly) // check if we have a belly while resting
		belly_size = 0
	var/fullness_extension = ""
	if(belly_size > 1) // Multibelly support
		fullness_extension = "_[belly_size]"
	icon_state = "[chassis_data.sprite_icon_state][resting && chassis_data.can_rest ? "_rest" : ""][belly_size ? "_full[fullness_extension]" : ""]"

	add_eyes()

/mob/living/silicon/pai/proc/add_eyes()
	remove_eyes()

	var/datum/pai_sprite/chassis_data = SSpai.chassis_data(chassis_name)
	if(chassis_data.holo_projector)
		// Special eyes that are based on holoprojection of your character's icon size
		if(holo_icon_south.Width() > 32)
			holo_icon_dimension_X = 64
			pixel_x = -16
			default_pixel_x = -16
		// Get height too
		if(holo_icon_south.Height() > 32)
			holo_icon_dimension_Y = 64
			vis_height = 64
		// Set eyes
		if(holo_icon_dimension_X == 32 && holo_icon_dimension_Y == 32)
			eye_layer = image('icons/mob/pai.dmi', chassis_data.holo_eyes_icon_state)
		else if(holo_icon_dimension_X == 32 && holo_icon_dimension_Y == 64)
			eye_layer = image('icons/mob/pai32x64.dmi', chassis_data.holo_eyes_icon_state)
		else if(holo_icon_dimension_X == 64 && holo_icon_dimension_Y == 32)
			eye_layer = image('icons/mob/pai64x32.dmi', chassis_data.holo_eyes_icon_state)
		else if(holo_icon_dimension_X == 64 && holo_icon_dimension_Y == 64)
			eye_layer = image('icons/mob/pai64x64.dmi', chassis_data.holo_eyes_icon_state)
	else if(chassis_data.has_eye_color)
		// Default eye handling
		eye_layer = image(icon, "[icon_state]-eyes")
	else
		// No eyes, so don't bother setting icon stuff
		return
	eye_layer.appearance_flags = appearance_flags
	eye_layer.color = eye_color
	if(eye_glow && !hide_glow)
		eye_layer.plane = PLANE_LIGHTING_ABOVE
	add_overlay(eye_layer)

/mob/living/silicon/pai/proc/remove_eyes()
	if(!eye_layer)
		return
	cut_overlay(eye_layer)
	qdel(eye_layer)
	eye_layer = null

/mob/living/silicon/pai/proc/get_character_icon()
	if(!client || !client.prefs) return FALSE
	var/mob/living/carbon/human/dummy/dummy = new ()
	//This doesn't include custom_items because that's ... hard.
	client.prefs.dress_preview_mob(dummy)
	sleep(1 SECOND) //Strange bug in preview code? Without this, certain things won't show up. Yay race conditions?
	dummy.regenerate_icons()

	var/icon/new_holo = getCompoundIcon(dummy)

	dummy.tail_layering = TRUE
	dummy.set_dir(NORTH)
	var/icon/new_holo_north = getCompoundIcon(dummy)
	dummy.set_dir(EAST)
	var/icon/new_holo_east = getCompoundIcon(dummy)
	dummy.set_dir(WEST)
	var/icon/new_holo_west = getCompoundIcon(dummy)

	qdel(holo_icon_south)
	qdel(holo_icon_north)
	qdel(holo_icon_east)
	qdel(holo_icon_west)
	qdel(dummy)
	holo_icon_south = new_holo
	holo_icon_north = new_holo_north
	holo_icon_east = new_holo_east
	holo_icon_west = new_holo_west
	return TRUE

/mob/living/silicon/pai/set_dir(var/new_dir)
	. = ..()
	if(. && SSpai.chassis_data(chassis_name).holo_projector)
		switch(dir)
			if(SOUTH)
				icon = holo_icon_south
			if(NORTH)
				icon = holo_icon_north
			if(EAST)
				icon = holo_icon_east
			if(WEST)
				icon = holo_icon_west
			else
				icon = holo_icon_north

/mob/living/silicon/pai/a_intent_change(input as text)
	. = ..()

	switch(a_intent)
		if(I_HELP)
			hud_used.help_intent.icon_state = "intent_help-s"
			hud_used.disarm_intent.icon_state = "intent_disarm-n"
			hud_used.grab_intent.icon_state = "intent_grab-n"
			hud_used.hurt_intent.icon_state = "intent_harm-n"

		if(I_DISARM)
			hud_used.help_intent.icon_state = "intent_help-n"
			hud_used.disarm_intent.icon_state = "intent_disarm-s"
			hud_used.grab_intent.icon_state = "intent_grab-n"
			hud_used.hurt_intent.icon_state = "intent_harm-n"

		if(I_GRAB)
			hud_used.help_intent.icon_state = "intent_help-n"
			hud_used.disarm_intent.icon_state = "intent_disarm-n"
			hud_used.grab_intent.icon_state = "intent_grab-s"
			hud_used.hurt_intent.icon_state = "intent_harm-n"

		if(I_HURT)
			hud_used.help_intent.icon_state = "intent_help-n"
			hud_used.disarm_intent.icon_state = "intent_disarm-n"
			hud_used.grab_intent.icon_state = "intent_grab-n"
			hud_used.hurt_intent.icon_state = "intent_harm-s"
