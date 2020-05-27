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

	status_flags = CANPUSH
	pass_flags = PASSTABLE
	movement_cooldown = 5

	universal_understand = TRUE
	can_be_antagged = TRUE

	holder_type = /obj/item/weapon/holder/borer
	ai_holder_type = null // This is player-controlled, always.

	var/chemicals = 10							// A resource used for reproduction and powers.
	var/max_chemicals = 250						// Max of said resource.
	var/mob/living/carbon/human/host = null		// The humanoid host for the brain worm.
	var/true_name = null						// String used when speaking among other worms.
	var/mob/living/captive_brain/host_brain		// Used for swapping control of the body back and forth.
	var/controlling = FALSE						// Used in human death ceck.
	var/docile = FALSE							// Sugar can stop borers from acting.
	var/has_reproduced = FALSE
	var/roundstart = FALSE						// If true, spawning won't try to pull a ghost.
	var/used_dominate							// world.time when the dominate power was last used.


/mob/living/simple_mob/animal/borer/roundstart
	roundstart = TRUE

/mob/living/simple_mob/animal/borer/Login()
	..()
	if(mind)
		borers.add_antagonist(mind)

/mob/living/simple_mob/animal/borer/Initialize()
	add_language("Cortical Link")

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	true_name = "[pick("Primary","Secondary","Tertiary","Quaternary")] [rand(1000,9999)]"

	if(!roundstart)
		request_player()

	return ..()

/mob/living/simple_mob/animal/borer/handle_special()
	if(host && !stat && !host.stat)
		// Handle docility.
		if(host.reagents.has_reagent("sugar") && !docile)
			var/message = "You feel the soporific flow of sugar in your host's blood, lulling you into docility."
			var/target = controlling ? host : src
			to_chat(target, span("warning", message))
			docile = TRUE

		else if(docile)
			var/message = "You shake off your lethargy as the sugar leaves your host's blood."
			var/target = controlling ? host : src
			to_chat(target, span("notice", message))
			docile = FALSE

		// Chem regen.
		if(chemicals < max_chemicals)
			chemicals++

		// Control stuff.
		if(controlling)
			if(docile)
				to_chat(host, span("warning", "You are feeling far too docile to continue controlling your host..."))
				host.release_control()
				return

			if(prob(5))
				host.adjustBrainLoss(0.1)

			if(prob(host.brainloss/20))
				host.say("*[pick(list("blink","blink_r","choke","aflap","drool","twitch","twitch_v","gasp"))]")

/mob/living/simple_mob/animal/borer/Stat()
	..()
	if(client.statpanel == "Status")
		statpanel("Status")
		if(emergency_shuttle)
			var/eta_status = emergency_shuttle.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)
		stat("Chemicals", chemicals)

/mob/living/simple_mob/animal/borer/proc/detatch()
	if(!host || !controlling)
		return

	if(istype(host, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = host
		var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
		if(head)
			head.implants -= src

	controlling = FALSE

	host.remove_language("Cortical Link")
	host.verbs -= /mob/living/carbon/proc/release_control
	host.verbs -= /mob/living/carbon/proc/punish_host
	host.verbs -= /mob/living/carbon/proc/spawn_larvae

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


/mob/living/simple_mob/animal/borer/proc/leave_host()
	if(!host)
		return

	if(host.mind)
		borers.remove_antagonist(host.mind)

	forceMove(get_turf(host))

	reset_view(null)
	machine = null

	if(istype(host, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = host
		var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
		if(head)
			head.implants -= src

	host.reset_view(null)
	host.machine = null
	host = null

/mob/living/simple_mob/animal/borer/proc/request_player()
	var/datum/ghost_query/Q = new /datum/ghost_query/borer()
	var/list/winner = Q.query() // This will sleep the proc for awhile.
	if(winner.len)
		var/mob/observer/dead/D = winner[1]
		transfer_personality(D)

/mob/living/simple_mob/animal/borer/proc/transfer_personality(mob/candidate)
	if(!candidate || !candidate.mind)
		return

	src.mind = candidate.mind
	candidate.mind.current = src
	ckey = candidate.ckey

	if(mind)
		mind.assigned_role = "Cortical Borer"
		mind.special_role = "Cortical Borer"

	to_chat(src, span("notice", "You are a cortical borer! You are a brain slug that worms its way \
	into the head of its victim. Use stealth, persuasion and your powers of mind control to keep you, \
	your host and your eventual spawn safe and warm."))
	to_chat(src, "You can speak to your victim with <b>say</b>, to other borers with <b>say :x</b>, and use your Abilities tab to access powers.")

/mob/living/simple_mob/animal/borer/cannot_use_vents()
	return

// This is awful but its literally say code.
/mob/living/simple_mob/animal/borer/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	message = sanitize(message)
	message = capitalize(message)

	if(!message)
		return

	if(stat >= DEAD)
		return say_dead(message)
	else if(stat)
		return

	if(client && client.prefs.muted & MUTE_IC)
		to_chat(src, span("danger", "You cannot speak in IC (muted)."))
		return

	if(copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	var/list/message_pieces = parse_languages(message)
	for(var/datum/multilingual_say_piece/S in message_pieces)
		if(S.speaking && S.speaking.flags & HIVEMIND)
			S.speaking.broadcast(src, trim(copytext(message, 3)), src.true_name)
			return

	if(!host)
		if(chemicals >= 30)
			to_chat(src, span("alien", "..You emit a psionic pulse with an encoded message.."))
			var/list/nearby_mobs = list()
			for(var/mob/living/LM in view(src, 1 + round(6 * (chemicals / max_chemicals))))
				if(LM == src)
					continue
				if(!LM.stat)
					nearby_mobs += LM
			var/mob/living/speaker
			if(nearby_mobs.len)
				speaker = input("Choose a target speaker.") as null|anything in nearby_mobs
			if(speaker)
				log_admin("[src.ckey]/([src]) tried to force [speaker] to say: [message]")
				message_admins("[src.ckey]/([src]) tried to force [speaker] to say: [message]")
				speaker.say("[message]")
				return
			to_chat(src, span("alien", "..But nothing heard it.."))
		else
			to_chat(src, span("warning", "You have no host to speak to."))
		return //No host, no audible speech.

	to_chat(src, "You drop words into [host]'s mind: \"[message]\"")
	to_chat(host, "Your own thoughts speak: \"[message]\"")

	for(var/mob/M in player_list)
		if(istype(M, /mob/new_player))
			continue
		else if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_ears))
			to_chat(M, "[src.true_name] whispers to [host], \"[message]\"")
