/obj/item/integrated_circuit/built_in
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/integrated_electronics/electronic_setups.dmi'
	icon_state = "template"
	size = -1
	w_class = ITEMSIZE_TINY
	removable = FALSE 			// Determines if a circuit is removable from the assembly.

/obj/item/integrated_circuit/built_in/device_input
	name = "assembly input"
	desc = "A built in chip for handling pulses from attached assembly items."
	complexity = 0 				//This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	activators = list("on pulsed" = IC_PINTYPE_PULSE_OUT)

/obj/item/integrated_circuit/built_in/device_input/do_work()
	activate_pin(1)

/obj/item/integrated_circuit/built_in/device_output
	name = "assembly out"
	desc = "A built in chip for pulsing attached assembly items."
	complexity = 0 				//This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	activators = list("pulse attached" = IC_PINTYPE_PULSE_IN)

/obj/item/integrated_circuit/built_in/device_output/do_work()
	if(istype(assembly, /obj/item/electronic_assembly/device))
		var/obj/item/electronic_assembly/device/device = assembly
		device.holder.pulse()

// Triggered when clothing assembly's hud button is clicked (or used inhand).
/obj/item/integrated_circuit/built_in/action_button
	name = "external trigger circuit"
	desc = "A built in chip that outputs a pulse when an external control event occurs."
	extended_desc = "This outputs a pulse if the assembly's HUD button is clicked while the assembly is closed."
	complexity = 0
	activators = list("on activation" = IC_PINTYPE_PULSE_OUT)

/obj/item/integrated_circuit/built_in/action_button/do_work()
	activate_pin(1)

/obj/item/integrated_circuit/built_in/earpiece_speaker
	name = "earpiece speaker"
	desc = "This small speaker can be used to output sound to a person wearing an earpiece."
	extended_desc = "This speaker can only be heard by the one wearing the earpiece."
	inputs = list("displayed data" = IC_PINTYPE_STRING)
	activators = list("load data" = IC_PINTYPE_PULSE_IN)
	var/speaker_output = null

/obj/item/integrated_circuit/built_in/earpiece_speaker/disconnect_all()
	..()
	speaker_output = null

/obj/item/integrated_circuit/built_in/earpiece_speaker/do_work()
	var/datum/integrated_io/I = inputs[1]
	speaker_output = I.data

	var/obj/item/clothing/ears/circuitry/ep = assembly.loc
	var/mob/wearer = ep.wearer?.resolve()
	if(wearer && ismob(wearer)) // Only allow the wearer to hear the earpiece exclusive speaker
		to_chat(wearer, span_notice("[icon2html(ep, wearer.client)] [speaker_output]"))
