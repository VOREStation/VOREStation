SUBSYSTEM_DEF(character_setup)
	name = "Character Setup"
	init_order = INIT_ORDER_DEFAULT
	priority = FIRE_PRIORITY_CHARSETUP
	flags = SS_BACKGROUND
	wait = 1 SECOND
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/prefs_awaiting_setup = list()
	var/list/preferences_datums = list()
	var/list/newplayers_requiring_init = list()

	var/list/save_queue = list()
<<<<<<< HEAD
/*
/datum/controller/subsystem/character_setup/Initialize()
	while(prefs_awaiting_setup.len)
		var/datum/preferences/prefs = prefs_awaiting_setup[prefs_awaiting_setup.len]
		prefs_awaiting_setup.len--
		prefs.setup()
	while(newplayers_requiring_init.len)
		var/mob/new_player/new_player = newplayers_requiring_init[newplayers_requiring_init.len]
		newplayers_requiring_init.len--
		new_player.deferred_login()
	. = ..()
*/	//Might be useful if we ever switch to Bay prefs.
/datum/controller/subsystem/character_setup/fire(resumed = FALSE)
=======

/datum/controller/subsystem/character_setup/fire(resumed, no_mc_tick)
>>>>>>> b8f4f620d2f... Merge pull request #8518 from Spookerton/spkrtn/sys/ssalarm
	while(save_queue.len)
		var/datum/preferences/prefs = save_queue[save_queue.len]
		save_queue.len--

		// Can't save prefs without client, because the sanitize functions will be
		// unable to validate their whitelist status due to being unable to check
		// 'holder' admin status, etc. Will result in Bad Times.
		if(!QDELETED(prefs) && prefs.client)
			prefs.save_preferences()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/character_setup/proc/queue_preferences_save(var/datum/preferences/prefs)
	save_queue |= prefs
