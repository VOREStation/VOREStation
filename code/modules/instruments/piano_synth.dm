/obj/item/instrument/piano_synth
	name = "synthesizer"
	desc = "An advanced electronic synthesizer that can be used as various instruments."
	icon_state = "synth"
	allowed_instrument_ids = "piano"

/obj/item/instrument/piano_synth/Initialize(mapload)
	. = ..()
	song.allowed_instrument_ids = SSinstruments.synthesizer_instrument_ids

/obj/item/instrument/piano_synth/headphones
	name = "headphones"
	desc = "Unce unce unce unce. Boop!"
	icon_state = "headphones"
	slot_flags = SLOT_EARS | SLOT_HEAD
	force = 0
	w_class = ITEMSIZE_SMALL
	instrument_range = 1

/obj/item/instrument/piano_synth/headphones/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_SONG_START, PROC_REF(start_playing))
	RegisterSignal(src, COMSIG_SONG_END, PROC_REF(stop_playing))

/**
 * Called by a component signal when our song starts playing.
 */
/obj/item/instrument/piano_synth/headphones/proc/start_playing()
	SIGNAL_HANDLER

	icon_state = "[initial(icon_state)]_on"
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.l_ear == src || H.r_ear == src)
			H.update_inv_ears()
		else if(H.head == src)
			H.update_inv_head()

/**
 * Called by a component signal when our song stops playing.
 */
/obj/item/instrument/piano_synth/headphones/proc/stop_playing()
	SIGNAL_HANDLER

	icon_state = "[initial(icon_state)]"
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.l_ear == src || H.r_ear == src)
			H.update_inv_ears()
		else if(H.head == src)
			H.update_inv_head()


/obj/item/instrument/piano_synth/headphones/spacepods
	name = "\improper Nanotrasen space pods"
	desc = "Flex your money, AND ignore what everyone else says, all at once!"
	icon_state = "spacepods"
	slot_flags = SLOT_EARS
	//strip_delay = 100 //air pods don't fall out
	instrument_range = 0 //you're paying for quality here
