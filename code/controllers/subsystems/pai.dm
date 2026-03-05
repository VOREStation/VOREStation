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
	VAR_PRIVATE/list/datum/pai_sprite/pai_chassis_sprites = list()
	VAR_PRIVATE/list/current_run = list()
	VAR_PRIVATE/list/pai_ghosts = list()
	VAR_PRIVATE/list/asked = list()

/datum/controller/subsystem/pai/Initialize()
	// Get all software setup
	for(var/type in subtypesof(/datum/pai_software))
		var/datum/pai_software/P = new type()
		GLOB.pai_software_by_key[P.id] = P
		if(P.default)
			GLOB.default_pai_software[P.id] = P

	// Get all valid chassis types
	for(var/datum/pai_sprite/sprite as anything in subtypesof(/datum/pai_sprite))
		if(!initial(sprite.sprite_icon) || initial(sprite.hidden))
			continue
		pai_chassis_sprites[initial(sprite.name)] = new sprite()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/pai/stat_entry(msg)
	msg = "C:[length(pai_ghosts)]"
	return ..()

/datum/controller/subsystem/pai/fire(resumed)
	if(!resumed)
		pai_ghosts.Cut()
		current_run = GLOB.observer_mob_list.Copy()

	while(length(current_run))
		if(MC_TICK_CHECK)
			return

		var/mob/observer/ghost = current_run[length(current_run)]
		current_run.len--
		if(!invite_valid(ghost))
			continue

		// Create candidate
		pai_ghosts[REF(ghost)] = WEAKREF(ghost)

/datum/controller/subsystem/pai/proc/get_chassis_list()
	RETURN_TYPE(/list/datum/pai_sprite)
	SHOULD_NOT_OVERRIDE(TRUE)
	return pai_chassis_sprites

/datum/controller/subsystem/pai/proc/chassis_data(id_name)
	RETURN_TYPE(/datum/pai_sprite)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!(id_name in pai_chassis_sprites))
		return pai_chassis_sprites[PAI_DEFAULT_CHASSIS]
	return pai_chassis_sprites[id_name]

/datum/controller/subsystem/pai/proc/invite_valid(mob/user)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!user.client?.prefs || !user.ckey)
		return FALSE
	if(!user.MayRespawn())
		return FALSE
	if(jobban_isbanned(user, "pAI"))
		return FALSE
	if(!(user.client.prefs.be_special & BE_PAI))
		return FALSE
	if(check_is_delayed(REF(user)))
		return FALSE
	if(check_is_already_pai(user.ckey))
		return FALSE
	if(user.client.prefs.read_preference(/datum/preference/text/pai_name) == PAI_UNSET) // Forbid unset name
		return FALSE
	return TRUE

/datum/controller/subsystem/pai/proc/check_is_delayed(ghost_ref)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(ghost_ref in asked)
		if(world.time < asked[ghost_ref] + PAI_DELAY_TIME)
			return TRUE
	return FALSE

/datum/controller/subsystem/pai/proc/check_is_already_pai(check_ckey)
	SHOULD_NOT_OVERRIDE(TRUE)
	return (check_ckey in GLOB.paikeys)

/datum/controller/subsystem/pai/proc/get_ghost_from_ref(ghost_ref)
	RETURN_TYPE(/mob/observer)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	if(!ghost_ref)
		return null
	var/datum/weakref/WF = pai_ghosts[ghost_ref]
	return WF?.resolve()

/datum/controller/subsystem/pai/proc/get_invite_list_data()
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/list/data = list()
	for(var/ghost_ref in pai_ghosts)
		var/mob/observer/ghost = get_ghost_from_ref(ghost_ref)
		if(!istype(ghost) || !ghost.client?.prefs)
			continue

		var/datum/preferences/pref = ghost.client.prefs
		var/datum/asset/spritesheet_batched/pai_icons/spritesheet = get_asset_datum(/datum/asset/spritesheet_batched/pai_icons)
		var/chassis = pref.read_preference(/datum/preference/text/pai_chassis)
		var/datum/pai_sprite/sprite_datum = SSpai.chassis_data(chassis)
		var/css_class = sanitize_css_class_name("[sprite_datum.type]")
		UNTYPED_LIST_ADD(data, list(
				"ref" = REF(ghost),
				"name" = pref.read_preference(/datum/preference/text/pai_name),
				"gender" = pref.read_preference(/datum/preference/choiced/gender/biological), // Cannot use identifying yet due to byond limits
				"role" = TextPreview(pref.read_preference(/datum/preference/text/pai_role), 152),
				"ad" = TextPreview(pref.read_preference(/datum/preference/text/pai_ad), 244),
				"eyecolor" = pref.read_preference(/datum/preference/color/pai_eye_color),
				"chassis" = chassis,
				"emotion" = pref.read_preference(/datum/preference/text/pai_emotion),
				"sprite_datum_class" = css_class,
				"sprite_datum_size" = spritesheet.icon_size_id(css_class + "S"), // just get the south icon's size, the rest will be the same
			))
	return data

/datum/controller/subsystem/pai/proc/get_detailed_invite_data(var/ghost_ref)
	RETURN_TYPE(/list)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!(ghost_ref in pai_ghosts))
		return null

	var/datum/weakref/WF = pai_ghosts[ghost_ref]
	var/mob/observer/ghost = WF?.resolve()
	if(!istype(ghost) || !ghost.client?.prefs)
		return null

	var/datum/preferences/pref = ghost.client.prefs
	var/datum/asset/spritesheet_batched/pai_icons/spritesheet = get_asset_datum(/datum/asset/spritesheet_batched/pai_icons)
	var/chassis = pref.read_preference(/datum/preference/text/pai_chassis)
	var/datum/pai_sprite/sprite_datum = SSpai.chassis_data(chassis)
	var/css_class = sanitize_css_class_name("[sprite_datum.type]")
	return list(
			"ref" = ghost_ref,
			"name" = pref.read_preference(/datum/preference/text/pai_name),
			"gender" = pref.read_preference(/datum/preference/choiced/gender/biological), // Cannot use identifying yet due to byond limits
			// Description
			"role" = pref.read_preference(/datum/preference/text/pai_role),
			"description" = pref.read_preference(/datum/preference/text/pai_description),
			"ad" = pref.read_preference(/datum/preference/text/pai_ad),
			"comments" = pref.read_preference(/datum/preference/text/pai_comments),
			// Appearance
			"eyecolor" = pref.read_preference(/datum/preference/color/pai_eye_color),
			"chassis" = chassis,
			"emotion" = pref.read_preference(/datum/preference/text/pai_emotion),
			// Sprites
			"sprite_datum_class" = css_class,
			"sprite_datum_size" = spritesheet.icon_size_id(css_class + "S"), // just get the south icon's size, the rest will be the same
		)

/datum/controller/subsystem/pai/proc/invite_ghost(mob/inquirer, ghost_ref, obj/item/paicard/card)
	SHOULD_NOT_OVERRIDE(TRUE)
	// Is our card legal to inhabit?
	if(QDELETED(card) || card.pai || card.is_damage_critical())
		to_chat(inquirer, span_warning("This [card] can no longer be used to house a pAI."))
		return

	// Check if the ghost stopped existing
	var/mob/observer/ghost = get_ghost_from_ref(ghost_ref)
	if(!isobserver(ghost) || !ghost.client)
		to_chat(inquirer, span_warning("This pAI has gone offline."))
		return

	// Time delay if the ghost cancels your invite.
	if(check_is_delayed(REF(ghost)))
		to_chat(inquirer, span_notice("This pAI is responding to a request, but may become available again shortly..."))
		return
	asked[REF(ghost)] = world.time

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
		if("Never for this round")
			SSpai.block_pai_invites(REF(ghost))

	to_chat(inquirer, span_warning("The pAI denied the request."))

/datum/controller/subsystem/pai/proc/block_pai_invites(ghost_ref)
	SHOULD_NOT_OVERRIDE(TRUE)
	asked[ghost_ref] = world.time + 99 HOURS // We never want to be asked again

/datum/controller/subsystem/pai/proc/clear_pai_block_delay(ghost_ref)
	SHOULD_NOT_OVERRIDE(TRUE)
	asked -= ghost_ref

#undef PAI_DELAY_TIME
