#define PAI_DELAY_TIME 1 MINUTE

////////////////////////////////
//// Pai join and management subsystem
////////////////////////////////
SUBSYSTEM_DEF(pai)
	name = "Pai"
	wait = 4 SECONDS
	dependencies = list(
		/datum/controller/subsystem/atoms
	)
	VAR_PRIVATE/list/current_run = list()
	VAR_PRIVATE/list/pai_ghosts = list()
	VAR_PRIVATE/list/asked = list()

/datum/controller/subsystem/pai/Initialize()
	for(var/type in subtypesof(/datum/pai_software))
		var/datum/pai_software/P = new type()
		GLOB.pai_software_by_key[P.id] = P
		if(P.default)
			GLOB.default_pai_software[P.id] = P

	return SS_INIT_SUCCESS

/datum/controller/subsystem/pai/stat_entry(msg)
	msg = "C:[length(pai_ghosts)]"
	return ..()

/datum/controller/subsystem/pai/fire(resumed)
	if(!resumed)
		pai_ghosts.Cut()
		current_run = GLOB.observer_mob_list.Copy()

	while(current_run.len)
		if(MC_TICK_CHECK)
			return

		var/mob/observer/ghost = current_run[current_run.len]
		current_run.len--
		if(!invite_valid(ghost))
			continue

		// Create candidate
		pai_ghosts.Add(WEAKREF(ghost))

/datum/controller/subsystem/pai/proc/invite_valid(mob/user)
	if(!user.client?.prefs)
		return FALSE
	if(!user.MayRespawn())
		return FALSE
	if(jobban_isbanned(user, "pAI"))
		return FALSE
	if(!(user.client.prefs.be_special & BE_PAI))
		return FALSE
	if(check_is_delayed(user.ckey))
		return FALSE
	if(check_is_already_pai(user.ckey))
		return FALSE
	if(user.client.prefs.read_preference(/datum/preference/text/pai_name) == PAI_UNSET) // Forbid unset name
		return FALSE
	return TRUE

/datum/controller/subsystem/pai/proc/check_is_delayed(var/key)
	if(key in asked)
		if(world.time < asked[key] + PAI_DELAY_TIME)
			return TRUE
	return FALSE

/datum/controller/subsystem/pai/proc/check_is_already_pai(var/key)
	for(var/ourkey in GLOB.paikeys)
		if(ourkey == key)
			return TRUE
	return FALSE

/datum/controller/subsystem/pai/proc/get_tgui_data()
	RETURN_TYPE(/list)

	var/list/data = list()
	for(var/datum/weakref/WF in pai_ghosts)
		var/mob/observer/ghost = WF?.resolve()
		if(!istype(ghost) || !ghost.client?.prefs)
			continue

		var/datum/preferences/pref = ghost.client.prefs
		data += list(
			list(
				"key" = ghost.ckey,
				"name" = pref.read_preference(/datum/preference/text/pai_name),
				"gender" = pref.identifying_gender,
				// Description
				"description" = pref.read_preference(/datum/preference/text/pai_description),
				"role" = pref.read_preference(/datum/preference/text/pai_role),
				"ad" = pref.read_preference(/datum/preference/text/pai_ad),
				// Appearance
				"eyecolor" = pref.read_preference(/datum/preference/color/pai_eye_color),
				"chassis" = pref.read_preference(/datum/preference/text/pai_chassis),
				"emotion" = pref.read_preference(/datum/preference/text/pai_emotion),
			)
		)

	return data

/datum/controller/subsystem/pai/proc/invite_ghost(mob/inquirer, find_ckey, obj/item/paicard/card)
	// Is our card legal to inhabit?
	if(QDELETED(card) || card.pai || card.is_damage_critical())
		to_chat(inquirer, span_warning("This [card] can no longer be used to house a pAI."))
		return

	// Check if the ghost stopped existing
	var/mob/observer/ghost = get_mob_by_key(find_ckey)
	if(!find_ckey || !isobserver(ghost) || !ghost.client)
		to_chat(inquirer, span_warning("This pAI is has gone offline."))
		return

	// Time delay if the ghost cancels your invite.
	if(check_is_delayed(ghost.ckey))
		to_chat(inquirer, span_notice("This pAI is responding to a request, but may become available again shortly..."))
		return
	asked[ghost.ckey] = world.time

	// Can't play, still respawning
	var/time_till_respawn = ghost.time_till_respawn()
	if(time_till_respawn == -1 || time_till_respawn)
		to_chat(inquirer, span_warning("This pAI is still downloading..."))
		return

	// Send it!
	to_chat(inquirer, span_info("A request has been sent!"))
	var/client/target = ghost.client
	var/response = tgui_alert(target, "[inquirer] is requesting a pAI personality. Would you like to play as a personal AI?", "pAI Request", list("Yes", "No", "Never for this round"))
	if(!response || !target || !isobserver(target.mob) || ghost != target.mob)
		return // Nice try smartass
	if(check_is_already_pai(target.ckey))
		to_chat(inquirer, span_warning("This pAI has already been downloaded."))
		return
	if(QDELETED(card) || card.pai)
		to_chat(inquirer, span_warning("This [card] can no longer be used to house a pAI."))
		return

	switch(response)
		if("Yes")
			var/new_pai = card.ghost_inhabit(target.mob, TRUE)
			to_chat(inquirer, span_info("[new_pai] has accepted your pAI request!"))
			return

		if("Never for this round") // Can this even be done in tg prefs??? - TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
			target.prefs.be_special ^= BE_PAI

	to_chat(inquirer, span_warning("The pAI denied the request."))

#undef PAI_DELAY_TIME
