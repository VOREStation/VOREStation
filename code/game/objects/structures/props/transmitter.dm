// A fluff structure for certain PoIs involving communications.
// It makes audible sounds, generally in morse code.
/obj/structure/prop/transmitter
	name = "transmitter"
	desc = "A machine that appears to be transmitting a message somewhere else. It sounds like it's on a loop."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "sensors"
	var/datum/looping_sound/sequence/morse/soundloop
	var/message_to_play = "The quick brown fox jumps over the lazy dog."

/obj/structure/prop/transmitter/Initialize()
	soundloop = new(list(src), FALSE)
	set_new_message(message_to_play)
	soundloop.start()
	interaction_message = "On the monitor it displays '[uppertext(message_to_play)]'."
	return ..()

/obj/structure/prop/transmitter/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/structure/prop/transmitter/vv_edit_var(var_name, var_value)
	if(var_name == "message_to_play")
		set_new_message(var_value)
	return ..()

/obj/structure/prop/transmitter/proc/set_new_message(new_message)
	soundloop.set_new_sequence(new_message)
	interaction_message = "On the monitor it displays '[uppertext(new_message)]'."
