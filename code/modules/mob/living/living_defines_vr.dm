/mob
	var/muffled = FALSE					// Used by muffling belly
	var/forced_psay = FALSE				// If true will prevent the user from speaking with normal say/emotes, and instead redirect these to a private speech mode with their predator.
	var/autowhisper = FALSE				// Automatically whisper
	var/autowhisper_mode = null			// Mode to use with autowhisper
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
	var/can_climb = FALSE //Checked by turfs when using climb_wall(). Defined here for silicons and simple mobs
	var/climbing_delay = 1.5 //By default, mobs climb at quarter speed. To be overriden by specific simple mobs or species speed
