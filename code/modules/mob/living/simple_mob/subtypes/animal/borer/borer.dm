// Borers are probably still going to be buggy as fuck, this is just bringing their mob defines up to the new system.
// IMO they're a relic of several ages we're long past, their code and their design showing this plainly, but removing them would
// make certain people Unhappy so here we are. They need a complete redesign but thats beyond the scope of the rewrite.

/mob/living/simple_mob/animal/borer
	name = "cortical borer"
	desc = "A small, quivering sluglike creature."
	icon_state = "brainslug"
	item_state = "brainslug"
	icon_living = "brainslug"
	icon_dead = "brainslug_dead"

	response_help  = "pokes"
	response_disarm = "prods"
	response_harm   = "stomps on"
	attacktext = list("nipped")
	friendly = list("prods")

	organ_names = /decl/mob_organ_names/borer

	status_flags = CANPUSH
	pass_flags = PASSTABLE
	movement_cooldown = 1.5
	mob_size = MOB_TINY // no landmines for you

	universal_understand = TRUE
	can_be_antagged = TRUE

	holder_type = /obj/item/holder/borer
	ai_holder_type = null // This is player-controlled, always.

	var/mob/living/carbon/human/host = null		// The humanoid host for the brain worm.
	var/mob/living/captive_brain/host_brain		// Used for swapping control of the body back and forth.

	var/roundstart = FALSE						// If true, spawning won't try to pull a ghost.
	var/antag = TRUE							// If false, will avoid setting up objectives and events

	var/chemicals = 10							// A resource used for reproduction and powers.
	var/true_name = null						// String used when speaking among other worms.
	var/controlling = FALSE						// Used in human death ceck.
	var/docile = FALSE							// Sugar can stop borers from acting.
	var/docile_counter = 0						// How long we are docile for

	var/has_reproduced = FALSE
	var/used_dominate							// world.time when the dominate power was last used.

	can_be_drop_prey = FALSE
	vent_crawl_time = 30 						// faster vent crawler

	var/static/borer_chem_list = list(
			// Antag utlity
			"Repair Brain Tissue" 	= list(REAGENT_ID_ALKYSINE, 5),
			"Repair Brute" 			= list(REAGENT_ID_BICARIDINE, 10),
			"Repair Burn" 			= list(REAGENT_ID_KELOTANE, 10),
			"Enhance Speed" 		= list(REAGENT_ID_HYPERZINE, 10),
			// Stablization
			"Stablize Mind" 		= list(REAGENT_ID_CITALOPRAM, 10),
			"Stablize Nerves" 		= list(REAGENT_ID_ADRANOL, 10),
			"Stablize Bleeding" 	= list(REAGENT_ID_INAPROVALINE, 5),
			"Stablize Infection" 	= list(REAGENT_ID_SPACEACILLIN, 15),
			"Stablize Pain"			= list(REAGENT_ID_TRAMADOL, 5),
			// Scene tools
			"Make Drunk" 			= list(REAGENT_ID_ETHANOL, 5),
			"Cure Drunk" 			= list(REAGENT_ID_ETHYLREDOXRAZINE, 10),
			"Euphoric High" 		= list(REAGENT_ID_BLISS, 5),
			"Mood Stimulant" 		= list(REAGENT_ID_APHRODISIAC, 5),
			// Borer last resport
			"Revive Dead Host" 		= null
		)

/mob/living/simple_mob/animal/borer/roundstart
	roundstart = TRUE

/mob/living/simple_mob/animal/borer/non_antag
	antag = FALSE

/mob/living/simple_mob/animal/borer/Login()
	. = ..()
	if(antag && mind)
		borers.add_antagonist(mind)

/mob/living/simple_mob/animal/borer/Initialize(mapload)
	add_language("Cortical Link")
	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)
	motiontracker_subscribe()

	true_name = "[pick("Primary","Secondary","Tertiary","Quaternary")] [rand(1000,9999)]"

	. = ..()

	if(!roundstart && antag)
		return INITIALIZE_HINT_LATELOAD

/mob/living/simple_mob/animal/borer/LateInitialize()
	request_player()

/mob/living/simple_mob/animal/borer/Destroy()
	. = ..()
	motiontracker_unsubscribe()
	QDEL_NULL(ghost_check)
	if(host)
		detatch()
		leave_host()

/mob/living/simple_mob/animal/borer/handle_special()
	handle_chemicals()
	handle_docile()
	handle_braindamage()

/mob/living/simple_mob/animal/borer/get_status_tab_items()
	. = ..()
	. += "Chemicals: [FLOOR(chemicals,1)]"

/mob/living/simple_mob/animal/borer/proc/handle_chemicals()
	if(stat == DEAD || !host || host.stat == DEAD)
		return
	if(chemicals >= BORER_MAX_CHEMS || docile)
		return

	var/chem_before = chemicals
	if(controlling)
		chemicals += 0.25
	else
		chemicals += 0.1
	var/new_chem = FLOOR(chemicals/10,1)
	if(new_chem > FLOOR(chem_before/10,1))
		to_chat(host, span_alien("Your chemicals have increased to [new_chem * 10]"))

/mob/living/simple_mob/animal/borer/proc/handle_docile()
	if(stat == DEAD)
		docile_counter = 0
		return

	// Start docile
	if(host && (host.reagents.has_reagent(REAGENT_ID_SUGAR) || host.ingested.has_reagent(REAGENT_ID_SUGAR)))
		docile_counter = 5 SECONDS
		if(!docile)
			var/message = "You feel the soporific flow of sugar in your host's blood, lulling you into docility."
			var/target = controlling ? host : src
			to_chat(target, span_danger( message))
			docile = TRUE

	// Drop control if docile
	if(controlling && docile)
		to_chat(host, span_vdanger("You are feeling far too docile to continue controlling your host..."))
		host.release_control()
		return

	// wear it off
	docile_counter--
	if(docile_counter > 0)
		return

	// End docile
	if(docile)
		to_chat(controlling ? host : src, span_notice("You shake off your lethargy as the sugar leaves your host's blood."))
		docile = FALSE
		docile_counter = 0

/mob/living/simple_mob/animal/borer/proc/handle_braindamage()
	if(QDELETED(src) || !host || QDELETED(host) || !controlling)
		return
	if(prob(2))
		host.adjustBrainLoss(0.1)
	if(prob(host.brainloss/20))
		host.say("*[pick(list("blink","blink_r","choke","aflap","drool","twitch","twitch_v","gasp"))]")

/mob/living/simple_mob/animal/borer/proc/can_use_power_in_host()
	if(QDELETED(src))
		return FALSE
	if(!host || QDELETED(host))
		to_chat(src, span_warning("You are not inside a host body."))
		return FALSE
	if(stat)
		to_chat(controlling ? host : src, span_warning("You cannot that that in your current state."))
		return FALSE
	return TRUE

/mob/living/simple_mob/animal/borer/proc/can_use_power_controlling_host()
	if(!can_use_power_in_host())
		return FALSE
	if(!controlling)
		to_chat(controlling ? host : src, span_warning("You need to be in complete control to do this."))
		return FALSE
	if(host.stat)
		to_chat(controlling ? host : src, span_warning("Your host is in no condition to do that."))
		return FALSE
	return TRUE

/mob/living/simple_mob/animal/borer/proc/can_use_power_docile()
	if(docile)
		to_chat(controlling ? host : src, span_info("You are feeling far too docile to do that."))
	return !docile

/mob/living/simple_mob/animal/borer/proc/use_chems(amount)
	if(chemicals < amount)
		to_chat(controlling ? host : src, span_warning("You don't have enough chemicals, requires [amount]! Currently you have [FLOOR(chemicals,1)]."))
		return FALSE
	chemicals -= amount
	to_chat(controlling ? host : src, span_info("You use [amount] chemicals, [FLOOR(chemicals,1)] remain."))
	return TRUE

/mob/living/simple_mob/animal/borer/handle_regular_hud_updates()
	. = ..()
	if(!.)
		return
	if(borer_chem_display)
		borer_chem_display.invisibility = INVISIBILITY_NONE
		switch(chemicals)
			if(0 to 9)
				borer_chem_display.icon_state = "ling_chems0e"
			if(10 to 19)
				borer_chem_display.icon_state = "ling_chems10e"
			if(20 to 29)
				borer_chem_display.icon_state = "ling_chems20e"
			if(30 to 39)
				borer_chem_display.icon_state = "ling_chems30e"
			if(40 to 49)
				borer_chem_display.icon_state = "ling_chems40e"
			if(50 to 59)
				borer_chem_display.icon_state = "ling_chems50e"
			if(60 to 69)
				borer_chem_display.icon_state = "ling_chems60e"
			if(70 to 79)
				borer_chem_display.icon_state = "ling_chems70e"
			if(80 to INFINITY)
				borer_chem_display.icon_state = "ling_chems80e"

/mob/living/simple_mob/animal/borer/proc/detatch()
	if(!host || !controlling)
		return

	var/obj/item/organ/external/head = host.get_organ(BP_HEAD)
	if(head)
		head.implants -= src
	controlling = FALSE

	host.remove_language("Cortical Link")
	remove_verb(host, /mob/living/carbon/proc/release_control)
	remove_verb(host, /mob/living/carbon/proc/punish_host)
	remove_verb(host, /mob/living/carbon/proc/spawn_larvae)

	// This entire section is awful and a relic of ancient times. It needs to be replaced
	if(host_brain)
		// these are here so bans and multikey warnings are not triggered on the wrong people when ckey is changed.
		// computer_id and IP are not updated magically on their own in offline mobs -walter0o

		// This shit need to die in a phoron fire.

		// host -> self
		var/h2s_id = host.computer_id
		var/h2s_ip= host.lastKnownIP
		host.computer_id = null
		host.lastKnownIP = null

		src.ckey = host.ckey

		if(!src.computer_id)
			src.computer_id = h2s_id

		if(!host_brain.lastKnownIP)
			src.lastKnownIP = h2s_ip

		// brain -> host
		var/b2h_id = host_brain.computer_id
		var/b2h_ip= host_brain.lastKnownIP
		host_brain.computer_id = null
		host_brain.lastKnownIP = null

		host.ckey = host_brain.ckey

		if(!host.computer_id)
			host.computer_id = b2h_id

		if(!host.lastKnownIP)
			host.lastKnownIP = b2h_ip

	qdel(host_brain)
	// End horrible ip swapping code for bans

/mob/living/simple_mob/animal/borer/proc/leave_host()
	if(!host)
		return

	if(host.mind)
		borers.remove_antagonist(host.mind)

	if(!QDELETED(src))
		forceMove(get_turf(host.loc))
	unset_machine()

	var/obj/item/organ/external/head = host.get_organ(BP_HEAD)
	if(head)
		head.implants -= src
	host.unset_machine()
	host = null

/mob/living/simple_mob/animal/borer/proc/transfer_personality(mob/candidate)
	if(!candidate)
		return
	ckey = candidate.ckey

	if(candidate.mind)
		src.mind = candidate.mind
		candidate.mind.current = src
		mind.assigned_role = JOB_CORTICAL_BORER
		mind.special_role = JOB_CORTICAL_BORER

	// TODO - This needs to be made into something more pref friendly if it's ever going to be used on virgo.
	to_chat(src, span_notice("You are a cortical borer! You are a brain slug that worms its way \
	into the head of its victim. Use stealth, persuasion and your powers of mind control to keep you, \
	your host and your eventual spawn safe and warm."))
	to_chat(src, "You can speak to your victim with <b>say</b>, to other borers with <b>say :x</b>, and use your Abilities tab to access powers.")

/mob/living/simple_mob/animal/borer/cannot_use_vents()
	return host || stat

/mob/living/simple_mob/animal/borer/extra_huds(var/datum/hud/hud,var/icon/ui_style,var/list/hud_elements)
	// Chem hud
	borer_chem_display = new /atom/movable/screen/borer/chems()
	borer_chem_display.screen_loc = ui_ling_chemical_display
	borer_chem_display.icon_state = "ling_chems"
	hud_elements |= borer_chem_display

/mob/living/simple_mob/animal/borer/UnarmedAttack(var/atom/A, var/proximity)
	if(ismob(loc))
		to_chat(src, span_notice("You cannot interact with that from inside a host!"))
		return
	. = ..()

// This is awful but its literally say code.
/mob/living/simple_mob/animal/borer/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	message = sanitize(message)
	message = capitalize(message)

	if(!message)
		return

	if(stat >= DEAD)
		return say_dead(message)
	if(stat)
		return

	if(client && client.prefs.muted & MUTE_IC)
		to_chat(src, span_danger("You cannot speak in IC (muted)."))
		return

	if(copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	var/list/message_pieces = parse_languages(message)
	for(var/datum/multilingual_say_piece/S in message_pieces)
		if(S.speaking && S.speaking.flags & HIVEMIND)
			S.speaking.broadcast(src, trim(copytext(message, 3)), src.true_name)
			return

	if(!host)
		if(chemicals >= BORER_PSYCHIC_SAY_MINIMUM_CHEMS)
			to_chat(src, span_alien("..You emit a psionic pulse with an encoded message.."))
			var/list/nearby_mobs = list()
			for(var/mob/living/LM in view(src, 1 + round(6 * (chemicals / BORER_MAX_CHEMS))))
				if(LM == src)
					continue
				if(!LM.stat)
					nearby_mobs += LM
			var/mob/living/speaker
			if(nearby_mobs.len)
				speaker = tgui_input_list(src, "Choose a target speaker:", "Target Choice", nearby_mobs)
			if(speaker)
				log_admin("[src.ckey]/([src]) tried to force [speaker] to say: [message]")
				message_admins("[src.ckey]/([src]) tried to force [speaker] to say: [message]")
				speaker.say("[message]")
				return
			to_chat(src, span_alien("..But nothing heard it.."))
		else
			to_chat(src, span_warning("You have no host to speak to."))
		return //No host, no audible speech.

	to_chat(src, "You drop words into [host]'s mind: \"[message]\"")
	to_chat(host, "Your own thoughts speak: \"[message]\"")

	for(var/mob/M in GLOB.player_list)
		if(isnewplayer(M))
			continue
		else if(M.stat == DEAD && M.client?.prefs?.read_preference(/datum/preference/toggle/ghost_ears))
			to_chat(M, "[src.true_name] whispers to [host], \"[message]\"")


/decl/mob_organ_names/borer
	hit_zones = list("head", "central segment", "tail segment")
