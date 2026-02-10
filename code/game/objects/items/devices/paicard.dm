/obj/item/paicard
	name = "personal AI device"
	icon = 'icons/obj/pda.dmi'
	icon_state = "pai"
	item_state = "electronic"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	origin_tech = list(TECH_DATA = 2)
	show_messages = 0
	preserve_item = 1

	var/obj/item/radio/borg/pai/radio
	var/mob/living/silicon/pai/pai
	var/image/screen_layer
	var/screen_color = "#00ff0d"
	var/last_notify = 0
	var/screen_msg
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

	///Var for attack_self chain
	var/special_handling = FALSE

/obj/item/paicard/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/paicard/Initialize(mapload)
	. = ..()
	add_overlay("pai-off")

/obj/item/paicard/Destroy()
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	if(!QDELETED(pai)) // Either the pai or card could be deleted first, prevent a loop
		pai.death(0)
	QDEL_NULL(radio)
	return ..()

/obj/item/paicard/attack_ghost(mob/user as mob)
	if(pai) //Have a person in them already?
		return ..()
	if(is_damage_critical())
		to_chat(user, span_warning("That card is too damaged to activate!"))
		return
	var/time_till_respawn = user.time_till_respawn()
	if(time_till_respawn == -1) // Special case, never allowed to respawn
		to_chat(user, span_warning("Respawning is not allowed!"))
	else if(time_till_respawn) // Nonzero time to respawn
		to_chat(user, span_warning("You can't do that yet! You died too recently. You need to wait another [round(time_till_respawn/10/60, 0.1)] minutes."))
		return
	if(jobban_isbanned(user, JOB_PAI))
		to_chat(user,span_warning("You cannot join a pAI card when you are banned from playing as a pAI."))
		return

	if(SSpai.check_is_already_pai(user.ckey))
		to_chat(user, span_warning("You can't just rejoin any old pAI card!!! Your card still exists."))
		return

	var/choice = tgui_alert(user, "Do you want to inhabit this pAI?", "Load", list("Load PAI Data", "Fresh Data", "Cancel"))
	switch(choice)
		if("Fresh Data")
			ghost_inhabit(user, FALSE)

		if("Load PAI Data")
			ghost_inhabit(user, TRUE)

	return ..() // TEMP, REMOVE ME

/obj/item/paicard/proc/ghost_inhabit(mob/user, load_slot)
	RETURN_TYPE(/mob/living/silicon/pai)
	// Setup pai
	var/mob/living/silicon/pai/new_pai = new(src)
	new_pai.key = user.key
	GLOB.paikeys |= new_pai.ckey
	setPersonality(new_pai)
	if(!load_slot || !new_pai.apply_preferences(new_pai.client))
		var/pai_name = sanitize_name(tgui_input_text(new_pai, "Choose your character's name", "Character Name"), ,1)
		if(!isnull(pai_name))
			new_pai.SetName(pai_name)
	return new_pai

/obj/item/paicard/tgui_interact(mob/user, datum/tgui/ui)
	if(is_damage_critical())
		to_chat(user, span_warning("WARNING: CRITICAL HARDWARE FAILURE, SERVICE DEVICE IMMEDIATELY"))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAICard", "Personal AI Device")
		ui.open()

/obj/item/paicard/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/data = list(
		"has_pai" = !isnull(pai),
		"available_pais" = null,
		"waiting_for_response" = in_use,
		"name" = null,
		"color" = null,
		"chassis" = null,
		"health" = null,
		"law_zero" = null,
		"law_extra" = null,
		"master_name" = null,
		"master_dna" = null,
		"radio" = null,
		"radio_transmit" = null,
		"radio_recieve" = null,
		"screen_msg" = null
	)

	if(pai) // Only set pai data if we have one
		data["name"] = pai.name;
		data["color"] = screen_color;
		data["chassis"] = pai.chassis_name;
		data["health"] = pai.health;
		data["law_zero"] = pai.pai_law0;
		data["law_extra"] = pai.pai_laws;
		data["master_name"] = pai.master;
		data["master_dna"] = pai.master_dna;
		data["radio"] = !isnull(radio);
		data["screen_msg"] = screen_msg;
		if(radio)
			data["radio_transmit"] = radio.broadcasting
			data["radio_recieve"] = radio.listening

	else // Only get the invite list if we can browse for them
		data["available_pais"] += SSpai.get_tgui_data()
	return data

/obj/item/paicard/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(is_damage_critical())
		return FALSE
	if(..())
		return TRUE
	add_fingerprint(ui.user)

	switch(action)
		if("setdna")
			if(!pai)
				return FALSE
			if(pai.master_dna)
				return

			var/mob/M = ui.user
			var/has_dna = FALSE
			if(istype(M, /mob/living/carbon))
				var/mob/living/carbon/carby = M
				var/datum/species/spec = carby.species
				has_dna = TRUE
				if(spec.flags & NO_DNA)
					has_dna = FALSE

			if(has_dna)
				var/datum/dna/dna = M.dna
				pai.master = M.real_name
				pai.master_dna = dna.unique_enzymes
				to_chat(pai, span_red("<h3>You have been bound to a new master.</h3>"))
				return TRUE
			to_chat(ui.user, span_blue("You don't have any DNA, or your DNA is incompatible with this device."))
			return FALSE

		/*
		if("wipe")
			if(!pai)
				return FALSE
			if(in_use)
				return FALSE
			in_use = TRUE
			var/confirm = tgui_alert(usr, "Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe", list("Yes", "No"))
			in_use = FALSE
			if(!confirm)
				return FALSE
			if(confirm == "Yes")
				for(var/mob/M in src)
					to_chat(M, span_red("<h2>You feel yourself slipping away from reality.</h2>"))
					to_chat(M, "<font color = #ff4d4d><h3>Byte by byte you lose your sense of self.</h3></font>")
					to_chat(M, "<font color = #ff8787><h4>Your mental faculties leave you.</h4></font>")
					to_chat(M, "<font color = #ffc4c4><h5>oblivion... </h5></font>")
					M.death(0)
				removePersonality()
			return TRUE
		*/

		if("wires")
			if(!pai)
				return FALSE
			// WIRE_SIGNAL = 1
			// WIRE_RECEIVE = 2
			// WIRE_TRANSMIT = 4
			switch(text2num(params["wires"]))
				if(4)
					radio.ToggleBroadcast()
					return TRUE
				if(2)
					radio.ToggleReception()
					return TRUE
			return FALSE

		if("setlaws")
			if(!pai)
				return FALSE
			if(in_use)
				return FALSE
			in_use = TRUE
			var/newlaws = sanitize(tgui_input_text(usr, "Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.pai_laws, MAX_MESSAGE_LEN, encode = FALSE, multiline = TRUE, prevent_enter = TRUE), MAX_MESSAGE_LEN, FALSE, FALSE, TRUE)
			in_use = FALSE

			if(newlaws)
				pai.pai_laws = newlaws
				to_chat(pai, "Your supplemental directives have been updated. Your new directives are:")
				to_chat(pai, "Prime Directive: <br>[pai.pai_law0]")
				to_chat(pai, "Supplemental Directives: <br>[pai.pai_laws]")
			return TRUE

		if("select_pai")
			if(pai)
				return FALSE
			if(in_use)
				return FALSE
			in_use = TRUE
			SSpai.invite_ghost(ui.user, params["key"], src)
			in_use = FALSE
			return TRUE


/obj/item/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	src.pai = personality
	setEmotion(1)

/obj/item/paicard/proc/removePersonality()
	src.pai = null
	cut_overlays()
	setEmotion(16)

/obj/item/paicard
	var/current_emotion = 1
/obj/item/paicard/proc/setEmotion(var/emotion)
	if(pai)
		cut_overlays()
		qdel(screen_layer)
		screen_layer = null
		switch(emotion)
			if(1) screen_layer = image(icon, "pai-neutral")
			if(2) screen_layer = image(icon, "pai-what")
			if(3) screen_layer = image(icon, "pai-happy")
			if(4) screen_layer = image(icon, "pai-cat")
			if(5) screen_layer = image(icon, "pai-extremely-happy")
			if(6) screen_layer = image(icon, "pai-face")
			if(7) screen_layer = image(icon, "pai-laugh")
			if(8) screen_layer = image(icon, "pai-sad")
			if(9) screen_layer = image(icon, "pai-angry")
			if(10) screen_layer = image(icon, "pai-silly")
			if(11) screen_layer = image(icon, "pai-nose")
			if(12) screen_layer = image(icon, "pai-smirk")
			if(13) screen_layer = image(icon, "pai-exclamation")
			if(14) screen_layer = image(icon, "pai-question")
			if(15) screen_layer = image(icon, "pai-blank")
			if(16) screen_layer = image(icon, "pai-off")

		screen_layer.color = pai.eye_color
		add_overlay(screen_layer)
		current_emotion = emotion

/obj/item/paicard/proc/alertUpdate()
	if(pai)
		return
	if(last_notify == 0 || (5 MINUTES <= world.time - last_notify))
		audible_message(span_notice("\The [src] flashes a message across its screen, \"Additional personalities available for download.\""), hearing_distance = world.view, runemessage = "bleeps!")
		last_notify = world.time

/obj/item/paicard/emp_act(severity, recursive)
	for(var/mob/M in src)
		M.emp_act(severity, recursive)

/obj/item/paicard/ex_act(severity)
	if(pai)
		pai.ex_act(severity)
	else
		qdel(src)

/obj/item/paicard/see_emote(mob/living/M, text)
	if(pai && pai.client && !pai.canmove)
		var/rendered = span_message("[text]")
		pai.show_message(rendered, 2)
	..()

/obj/item/paicard/show_message(msg, type, alt, alt_type)
	if(pai && pai.client)
		var/rendered = span_message("[msg]")
		pai.show_message(rendered, type)
	..()

/obj/item/paicard/proc/clear_invite_overlay()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(pai) // DOn't wipe emotion if a pai was invited
		return
	cut_overlay()

// VoreEdit: Living Machine Stuff after this.
// This adds a var and proc for all machines to take a pAI. (The pAI can't control anything, it's just for RP.)
// You need to add usage of the proc to each machine to actually add support. For an example of this, see code\modules\food\kitchen\microwave.dm
/obj/machinery
	var/obj/item/paicard/paicard = null

/obj/machinery/proc/insertpai(mob/user, obj/item/paicard/card)
	//var/obj/item/paicard/card = I
	var/mob/living/silicon/pai/AI = card.pai
	if(paicard)
		to_chat(user, span_notice("This bot is already under PAI Control!"))
		return
	if(!istype(card)) // TODO: Add sleevecard support.
		return
	if(!card.pai)
		to_chat(user, span_notice("This card does not currently have a personality!"))
		return
	paicard = card
	user.unEquip(card)
	card.forceMove(src)
	AI.reset_perspective(src) // focus this machine
	to_chat(AI, span_notice("Your location is [card.loc].")) // DEBUG. TODO: Make unfolding the chassis trigger an eject.
	name = AI.name
	to_chat(AI, span_notice("You feel a tingle in your circuits as your systems interface with \the [initial(src.name)]."))

/obj/machinery/proc/ejectpai(mob/user)
	if(paicard)
		paicard.forceMove(get_turf(src))
		var/mob/living/silicon/pai/AI = paicard.pai
		AI.reset_perspective() // return to the card
		paicard = null
		name = initial(src.name)
		to_chat(AI, span_notice("You feel a tad claustrophobic as your mind closes back into your card, ejecting from \the [initial(src.name)]."))
		if(user)
			to_chat(user, span_notice("You eject the card from \the [initial(src.name)]."))

///////////////////////////////
//////////pAI Radios//////////
///////////////////////////////
//Thanks heroman!

/obj/item/radio/borg/pai
	name = "integrated radio"
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	loudspeaker = FALSE

/obj/item/radio/borg/pai/attackby(obj/item/W as obj, mob/user as mob)
	return

/obj/item/radio/borg/pai/recalculateChannels()
	if(!istype(loc,/obj/item/paicard))
		return
	var/obj/item/paicard/card = loc
	secure_radio_connections = list()
	channels = list()

	for(var/internal_chan in internal_channels)
		var/ch_name = GLOB.radio_channels_by_freq[internal_chan]
		if(has_channel_access(card.pai, internal_chan))
			channels += ch_name
			channels[ch_name] = 1
			secure_radio_connections[ch_name] = SSradio.add_object(src, GLOB.radiochannels[ch_name],  RADIO_CHAT)

/obj/item/paicard/typeb
	name = "personal AI device"
	icon = 'icons/obj/paicard.dmi'

/obj/random/paicard
	name = "personal AI device spawner"
	icon = 'icons/obj/paicard.dmi'
	icon_state = "pai"

/obj/random/paicard/item_to_spawn()
	return pick(/obj/item/paicard ,/obj/item/paicard/typeb)

/obj/item/paicard/digest_act(var/atom/movable/item_storage = null)
	if(pai.digestable)
		return ..()
