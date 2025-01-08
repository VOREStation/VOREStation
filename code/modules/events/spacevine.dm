GLOBAL_VAR_INIT(spacevines_spawned, 0)

/datum/event/spacevine
	announceWhen	= 60

/datum/event/spacevine/start()
	spacevine_infestation()
	GLOB.spacevines_spawned = 1

/datum/event/spacevine/announce()
	level_seven_announcement()
