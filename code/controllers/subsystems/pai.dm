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
	msg = "C:[pai_ghosts.len]"
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
		if(!ghost.client)
			continue
		if(!ghost.MayRespawn())
			continue
		if(jobban_isbanned(ghost, "pAI"))
			continue
		if(!(ghost.client.prefs.be_special & BE_PAI))
			continue
		if(check_is_delayed(ghost.ckey))
			continue
		if(check_is_already_pai(ghost.ckey))
			continue
		// Create candidate
		pai_ghosts.Add(WEAKREF(ghost))

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

/datum/controller/subsystem/pai/proc/get_pai_candidates()
	RETURN_TYPE(/list)
	var/list/return_data = list()
	for(var/datum/weakref/WF in pai_ghosts)
		var/mob/observer/ghost = WF?.resolve()

		if(!istype(ghost) || !ghost.client)
			continue

		// TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO
		// THIS CANNOT CONTINUE THIS CANNOT CONTINUE THIS CANNOT CONTINUE THIS CANNOT CONTINUE THIS CANNOT CONTINUE THIS CANNOT CONTINUE
		// REPLACE ME WITH TG PREFS. TEMP UNTIL REFACTOR. IF YOU MERGE THIS INTO MASTER I WILL DIE
		var/datum/paiCandidate/candidate = new()
		if(candidate.savefile_load(ghost))
			candidate.key = ghost.ckey
			return_data += candidate
		else
			qdel(candidate)
		// TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO

	return return_data

/datum/controller/subsystem/pai/proc/get_tgui_data()
	RETURN_TYPE(/list)
	var/list/candidate_datums = get_pai_candidates()

	var/list/data = list()
	for(var/datum/paiCandidate/candidate in candidate_datums)
		data += list(
			list(
				"key" = candidate.key,
				"name" = candidate.name,
				"description" = candidate.description,
				"ad" = candidate.advertisement,
				"eyecolor" = candidate.eye_color,
				"chassis" = candidate.chassis,
				"emotion" = candidate.ouremotion,
				"gender" = candidate.gender
			)
		)

	// TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO
	QDEL_LIST(candidate_datums) // TEMP, Remove when these are read from player prefs DO NOT MERGE ME INTO MASTER OR DEATH WILL COME TO YOU SWIFTLY
	// TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO  TODO
	return data

/datum/controller/subsystem/pai/proc/invite_ghost(mob/inquirer, find_ckey, obj/item/paicard/card)
	// Is our card legal to inhabit?
	if(QDELETED(card) || card.pai || card.is_damage_critical())
		to_chat(inquirer, span_warning("This [card] can no longer be used to house a new pAI."))
		return

	// Check if the ghost stopped existing
	var/mob/observer/ghost = get_mob_by_key(find_ckey)
	if(!find_ckey || !isobserver(ghost) || !ghost.client)
		to_chat(inquirer, span_warning("This pAI is has gone offline."))
		return

	// Time delay if the ghost cancels your invite.
	if(check_is_delayed(ghost.ckey))
		to_chat(inquirer, span_notice("This pAI has denied a previous request and will become available again shortly..."))
		return
	asked.Add(ghost.ckey)
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
		return
	if(QDELETED(card) || card.pai)
		return

	switch(response)
		if("Yes")
			card.ghost_inhabit(target.mob, TRUE)

		if("Never for this round") // Can this even be done in tg prefs??? - TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
			target.prefs.be_special ^= BE_PAI

#undef PAI_DELAY_TIME
