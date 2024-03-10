/datum/wires/jukebox
	randomize = TRUE
	holder_type = /obj/machinery/media/jukebox
	wire_count = 11
	proper_name = "Jukebox"

/datum/wires/jukebox/New(atom/_holder)
	wires = list(
		WIRE_MAIN_POWER1, WIRE_JUKEBOX_HACK,
		WIRE_SPEEDUP, WIRE_SPEEDDOWN, WIRE_REVERSE,
		WIRE_START, WIRE_STOP, WIRE_PREV, WIRE_NEXT
	)
	return ..()

/datum/wires/jukebox/interactable(mob/user)
	var/obj/machinery/media/jukebox/A = holder
	if(A.panel_open)
		return TRUE
	return FALSE

// Show the status of lights as a hint to the current state
/datum/wires/jukebox/get_status()
	var/obj/machinery/media/jukebox/A = holder
	. = ..()
	. += "The power light is [A.stat & (BROKEN|NOPOWER) ? "off." : "on."]"
	. += "The parental guidance light is [A.hacked ? "off." : "on."]"
	. += "The data light is [is_cut(WIRE_REVERSE) ? "hauntingly dark." : "glowing softly."]"

// Give a hint as to what each wire does
/datum/wires/jukebox/on_pulse(wire)
	var/obj/machinery/media/jukebox/A = holder
	switch(wire)
		if(WIRE_MAIN_POWER1)
			holder.visible_message("<span class='notice'>\icon[holder][bicon(holder)] The power light flickers.</span>")
			A.shock(usr, 90)
		if(WIRE_JUKEBOX_HACK)
			holder.visible_message("<span class='notice'>\icon[holder][bicon(holder)] The parental guidance light flickers.</span>")
		if(WIRE_REVERSE)
			holder.visible_message("<span class='notice'>\icon[holder][bicon(holder)] The data light blinks ominously.</span>")
		if(WIRE_SPEEDUP)
			holder.visible_message("<span class='notice'>\icon[holder][bicon(holder)] The speakers squeaks.</span>")
		if(WIRE_SPEEDDOWN)
			holder.visible_message("<span class='notice'>\icon[holder][bicon(holder)] The speakers rumble.</span>")
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

/datum/wires/jukebox/on_cut(wire, mend)
	var/obj/machinery/media/jukebox/A = holder

	switch(wire)
		if(WIRE_MAIN_POWER1)
			// TODO - Actually make machine electrified or something.
			A.shock(usr, 90)

		if(WIRE_JUKEBOX_HACK)
			A.set_hacked(!mend)

		if(WIRE_SPEEDUP, WIRE_SPEEDDOWN, WIRE_REVERSE)
			var/newfreq = is_cut(WIRE_REVERSE) ? -1 : 1;
			if(is_cut(WIRE_SPEEDUP))
				newfreq *= 2
			if(is_cut(WIRE_SPEEDDOWN))
				newfreq *= 0.5
			A.freq = newfreq
