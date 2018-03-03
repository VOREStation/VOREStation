/obj/item/integrated_circuit/input/microphone
	name = "microphone"
	desc = "Useful for spying on people or for voice activated machines."
	extended_desc = "This will automatically translate most languages it hears to Galactic Common.  \
	is only triggered if it hears someone speaking a language other than Galactic Common."
	icon_state = "recorder"
	complexity = 8
	inputs = list()
	outputs = list(
	"speaker" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	activators = list("on message received" = IC_PINTYPE_PULSE_OUT, "on translation" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 15

/obj/item/integrated_circuit/input/microphone/New()
	..()
	listening_objects |= src

/obj/item/integrated_circuit/input/microphone/Destroy()
	listening_objects -= src
	return ..()

/obj/item/integrated_circuit/input/microphone/hear_talk(mob/living/M, msg, var/verb="says", datum/language/speaking=null)
	var/translated = FALSE
	if(M && msg)
		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			if(!istype(speaking, /datum/language/common))
				translated = TRUE
		set_pin_data(IC_OUTPUT, 1, M.GetVoice())
		set_pin_data(IC_OUTPUT, 2, msg)

	push_data()
	activate_pin(1)
	if(translated)
		activate_pin(2)




/obj/item/integrated_circuit/input/integrated_radio
	name = "integrated radio"
	desc = "Useful for interacting with radio channels"
	extended_desc = "This will automatically translate most languages it hears to Galactic Common.  \
	The first activation pin is always pulsed when the circuit hears someone talk, while the second one \
	is only triggered if it hears someone speaking a language other than Galactic Common."
	icon_state = "recorder"
	complexity = 18
	inputs = list(
	"channel" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	outputs = list(
	"channel" = IC_PINTYPE_STRING,
	"speaker" = IC_PINTYPE_STRING,
	"message" = IC_PINTYPE_STRING
	)
	activators = list("send message" = IC_PINTYPE_PULSE_IN, "on message received" = IC_PINTYPE_PULSE_OUT, "on translation" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

	var/allowed_channels = list(
	"Common",
	"Entertainment"
	)

/obj/item/integrated_circuit/input/integrated_radio/New()
	..()
	listening_objects |= src

/obj/item/integrated_circuit/input/integrated_radio/Destroy()
	listening_objects -= src
	return ..()

/obj/item/integrated_circuit/input/integrated_radio/do_work()
	var/target_channel = get_pin_data(IC_INPUT, 1)
	var/message = get_pin_data(IC_INPUT, 2)

	//if(target_channel in allowed_channels)
		//global_announcer.autosay


/obj/item/integrated_circuit/input/integrated_radio/hear_talk(mob/living/M, msg, var/verb="says", datum/language/speaking=null)
	var/translated = FALSE
	if(M && msg)
		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			if(!istype(speaking, /datum/language/common))
				translated = TRUE
		set_pin_data(IC_OUTPUT, 2, M.GetVoice())
		set_pin_data(IC_OUTPUT, 3, msg)

	push_data()
	activate_pin(1)
	if(translated)
		activate_pin(2)