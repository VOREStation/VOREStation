/*
 *	The purpose of this file is to house mob injury loops - such as being on fire.
*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/mob
	// volume_chan = VOLUME_CHANNEL_INJ_DEATH // Commented out until pain/etc PR is in

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/mob/deafened
	start_sound = 'modular_chomp/sound/effects/ear_ring/ear_deaf_in.ogg'
	start_length = 4 SECONDS // 2 seconds shorter than the actual file ending, bc we want it to overlap
	mid_sounds = list('modular_chomp/sound/effects/ear_ring/ear_deaf_loop.ogg'=1)
	mid_length = 3 SECONDS
	end_sound = 'modular_chomp/sound/effects/ear_ring/ear_deaf_out.ogg'
	volume = 40
	direct = TRUE 		// We send this sound directly to the mob, bc they only hear it when they're deaf.
	exclusive = TRUE	// This should only occur once, because we can only be deafened once.
	// volume_chan = VOLUME_CHANNEL_INJ_DEATH // Commented out until pain/etc PR is in

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
