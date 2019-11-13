/mob
	var/muffled = 0 					// Used by muffling belly

/mob/living
	var/ooc_notes = null
	var/obj/structure/mob_spawner/source_spawner = null

	var/lastLifeProc = 0    // Wallclock time of the last time this mob had life() called on them (at finish), used for tying variables to wallclock rather than tickcount

//custom say verbs
	var/custom_say = null
	var/custom_ask = null
	var/custom_exclaim = null
	var/custom_whisper = null