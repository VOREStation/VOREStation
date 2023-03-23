/mob
	var/muffled = FALSE					// Used by muffling belly
	var/forced_psay = FALSE				// If true will prevent the user from speaking with normal say/emotes, and instead redirect these to a private speech mode with their predator.

/mob/living
	var/ooc_notes = null
	appearance_flags = TILE_BOUND|PIXEL_SCALE|KEEP_TOGETHER|LONG_GLIDE
	var/hunger_rate = DEFAULT_HUNGER_FACTOR
//custom say verbs
	var/custom_say = null
	var/custom_ask = null
	var/custom_exclaim = null
	var/custom_whisper = null
//custom temperature discomfort vars
	var/list/custom_heat = list()
	var/list/custom_cold = list()
