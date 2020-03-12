/datum/wires/smes
	holder_type = /obj/machinery/power/smes/buildable
	wire_count = 5
	var/datum/wire_hint/io_hint
	var/datum/wire_hint/safeties_hint
	var/datum/wire_hint/rcon_hint

/datum/wires/smes/make_wire_hints()
	io_hint = new("The green light is off.", "The green light is on.")
	safeties_hint = new("The red light is off.", "The red light is blinking.")
	rcon_hint = new("The blue light is on.", "The blue light is off.")

/datum/wires/smes/Destroy()
	io_hint = null
	safeties_hint = null
	rcon_hint = null
	return ..()

var/const/SMES_WIRE_RCON = 1		// Remote control (AI and consoles), cut to disable
var/const/SMES_WIRE_INPUT = 2		// Input wire, cut to disable input, pulse to disable for 60s
var/const/SMES_WIRE_OUTPUT = 4		// Output wire, cut to disable output, pulse to disable for 60s
var/const/SMES_WIRE_GROUNDING = 8	// Cut to quickly discharge causing sparks, pulse to only create few sparks
var/const/SMES_WIRE_FAILSAFES = 16	// Cut to disable failsafes, mend to reenable


/datum/wires/smes/CanUse(var/mob/living/L)
	var/obj/machinery/power/smes/buildable/S = holder
	if(S.open_hatch)
		return 1
	return 0


/datum/wires/smes/GetInteractWindow()
	var/obj/machinery/power/smes/buildable/S = holder
	. += ..()
	. += io_hint.show(S.input_cut || S.input_pulsed || S.output_cut || S.output_pulsed)
	. += safeties_hint.show(S.safeties_enabled || S.grounding)
	. += rcon_hint.show(S.RCon)

/datum/wires/smes/UpdateCut(var/index, var/mended)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(index)
		if(SMES_WIRE_RCON)
			S.RCon = mended
		if(SMES_WIRE_INPUT)
			S.input_cut = !mended
		if(SMES_WIRE_OUTPUT)
			S.output_cut = !mended
		if(SMES_WIRE_GROUNDING)
			S.grounding = mended
		if(SMES_WIRE_FAILSAFES)
			S.safeties_enabled = mended


/datum/wires/smes/UpdatePulsed(var/index)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(index)
		if(SMES_WIRE_RCON)
			if(S.RCon)
				S.RCon = 0
				spawn(10)
					S.RCon = 1
		if(SMES_WIRE_INPUT)
			S.toggle_input()
		if(SMES_WIRE_OUTPUT)
			S.toggle_output()
		if(SMES_WIRE_GROUNDING)
			S.grounding = 0
		if(SMES_WIRE_FAILSAFES)
			if(S.safeties_enabled)
				S.safeties_enabled = 0
				spawn(10)
					S.safeties_enabled = 1