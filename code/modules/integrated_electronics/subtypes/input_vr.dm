/obj/item/integrated_circuit/input/microphone
	name = "microphone"
	desc = "Useful for spying on people or for voice activated machines."
	extended_desc = "This will automatically translate most languages it hears to Galactic Common.  \
	The first activation pin is always pulsed when the circuit hears someone talk, while the second one \
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




obj/item/device/radio/integrated/
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "signal"
	canhear_range = 0
	listening = 0
	var/obj/item/integrated_circuit/input/integrated_radio/circuit = null



/obj/item/integrated_circuit/input/integrated_radio
	name = "integrated radio"
	desc = "Useful for interacting with radio channels"
	extended_desc = "This will automatically translate most languages it hears to Galactic Common.  \
	The first activation pin is always pulsed when the circuit hears someone talk, while the second one \
	is only triggered if it hears someone speaking a language other than Galactic Common."
	icon_state = "signal"
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
	"Common" = 0,
	"Entertainment" = 0,
	"Science" = 0,
	"Explorer" = 0,
	"Medical" = 0,
	"Engineering" = 0,
	"Security" = 0,
	"Supply" = 0,
	"Service" = 0,
	"Command" = 0
	)
	var/obj/item/device/radio/integrated/radio = null

/obj/item/integrated_circuit/input/integrated_radio/New()
	..()
	listening_objects |= src
	radio = new(src)
	radio.circuit = src
	radio.config(allowed_channels)

/obj/item/integrated_circuit/input/integrated_radio/Destroy()
	listening_objects -= src
	return ..()

/obj/item/integrated_circuit/input/integrated_radio/do_work()
	var/target_channel = get_pin_data(IC_INPUT, 1)
	var/message = get_pin_data(IC_INPUT, 2)
	if(!isnull(message))
		var/obj/O = assembly ? loc : assembly
		radio.autosay(message, O.name, target_channel)

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


