/datum/wires/jukebox
	random = 1
	holder_type = /obj/machinery/media/jukebox
	wire_count = 11
	var/datum/wire_hint/power_hint
	var/datum/wire_hint/parental_hint
	var/datum/wire_hint/reverse_hint

/datum/wires/jukebox/make_wire_hints()
	power_hint = new("The power light is off.", "The power light is on.")
	parental_hint = new("The parental guidance light is off.", "The parental guidance light is on.")
	reverse_hint = new("The data light is hauntingly dark.", "The data light is glowing softly.")

/datum/wires/jukebox/Destroy()
	power_hint = null
	parental_hint = null
	reverse_hint = null
	return ..()


var/const/WIRE_POWER = 1
var/const/WIRE_HACK = 2
var/const/WIRE_SPEEDUP = 4
var/const/WIRE_SPEEDDOWN = 8
var/const/WIRE_REVERSE = 16
var/const/WIRE_NOTHING1 = 32
var/const/WIRE_NOTHING2 = 64
var/const/WIRE_START = 128
var/const/WIRE_STOP = 256
var/const/WIRE_PREV = 512
var/const/WIRE_NEXT = 1024

/datum/wires/jukebox/CanUse(var/mob/living/L)
	var/obj/machinery/media/jukebox/A = holder
	if(A.panel_open)
		return 1
	return 0

// Show the status of lights as a hint to the current state
/datum/wires/jukebox/GetInteractWindow()
	var/obj/machinery/media/jukebox/A = holder
	. += ..()
	. += power_hint.show(A.stat & (BROKEN|NOPOWER))
	. += parental_hint.show(A.hacked)
	. += reverse_hint.show(IsIndexCut(WIRE_REVERSE))

// Give a hint as to what each wire does
/datum/wires/jukebox/UpdatePulsed(var/index)
	var/obj/machinery/media/jukebox/A = holder
	switch(index)
		if(WIRE_POWER)
			holder.visible_message("<span class='notice'>[bicon(holder)] The power light flickers.</span>")
			A.shock(usr, 90)
		if(WIRE_HACK)
			holder.visible_message("<span class='notice'>[bicon(holder)] The parental guidance light flickers.</span>")
		if(WIRE_REVERSE)
			holder.visible_message("<span class='notice'>[bicon(holder)] The data light blinks ominously.</span>")
		if(WIRE_SPEEDUP)
			holder.visible_message("<span class='notice'>[bicon(holder)] The speakers squeaks.</span>")
		if(WIRE_SPEEDDOWN)
			holder.visible_message("<span class='notice'>[bicon(holder)] The speakers rumble.</span>")
		if(WIRE_START)
			A.StartPlaying()
		if(WIRE_STOP)
			A.StopPlaying()
		if(WIRE_PREV)
			A.PrevTrack()
		if(WIRE_NEXT)
			A.NextTrack()
		else
			A.shock(usr, 10) // The nothing wires give a chance to shock just for fun

/datum/wires/jukebox/UpdateCut(var/index, var/mended)
	var/obj/machinery/media/jukebox/A = holder

	switch(index)
		if(WIRE_POWER)
			// TODO - Actually make machine electrified or something.
			A.shock(usr, 90)

		if(WIRE_HACK)
			if(mended)
				A.set_hacked(0)
			else
				A.set_hacked(1)

		if(WIRE_SPEEDUP, WIRE_SPEEDDOWN, WIRE_REVERSE)
			var/newfreq = IsIndexCut(WIRE_REVERSE) ? -1 : 1;
			if (IsIndexCut(WIRE_SPEEDUP))
				newfreq *= 2
			if (IsIndexCut(WIRE_SPEEDDOWN))
				newfreq *= 0.5
			A.freq = newfreq
