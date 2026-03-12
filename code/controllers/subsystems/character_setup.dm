SUBSYSTEM_DEF(character_setup)
	name = "Character Setup"
	priority = FIRE_PRIORITY_CHARSETUP
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 1 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/prefs_awaiting_setup = list()
	var/list/preferences_datums = list()
	var/list/newplayers_requiring_init = list()

	var/list/save_queue = list()
/*
/datum/controller/subsystem/character_setup/Initialize()
	while(length(prefs_awaiting_setup))
		var/datum/preferences/prefs = prefs_awaiting_setup[length(prefs_awaiting_setup)]
		prefs_awaiting_setup.len--
		prefs.setup()
	while(length(newplayers_requiring_init))
		var/mob/new_player/new_player = newplayers_requiring_init[length(newplayers_requiring_init)]
		newplayers_requiring_init.len--
		new_player.deferred_login()
	. = ..()
*/	//Might be useful if we ever switch to Bay prefs.
/datum/controller/subsystem/character_setup/fire(resumed = FALSE)
	while(length(save_queue))
		var/datum/preferences/prefs = save_queue[length(save_queue)]
		save_queue.len--

		// Can't save prefs without client, because the sanitize functions will be
		// unable to validate their whitelist status due to being unable to check
		// 'holder' admin status, etc. Will result in Bad Times.
		if(!QDELETED(prefs) && prefs.client)
			prefs.save_preferences()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/character_setup/proc/queue_preferences_save(var/datum/preferences/prefs)
	if(!prefs)
		return
	save_queue |= prefs
