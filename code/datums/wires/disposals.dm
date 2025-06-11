/datum/wires/disposals
	holder_type = /obj/structure/disposalpipe/sortjunction
	proper_name = "Disposals Sorting Pipe"
	wire_count = 6

/datum/wires/disposals/interactable(mob/user)
	var/obj/structure/disposalpipe/sortjunction/A = holder
	if(A.panel_open)
		return TRUE

/datum/wires/disposals/get_status()
	var/obj/structure/disposalpipe/sortjunction/A = holder
	var/list/status = list()
	status += "The sorting light is [A.last_sort ? "green" : "red"]."
	status += "The scan light is [A.sort_scan ? "lit" : "off"]."
	return status

/datum/wires/disposals/New(atom/holder)
	wires = list(
		WIRE_SORT_FORWARD,
		WIRE_SORT_SIDE,
		WIRE_SORT_SCAN
	)
	return ..()

/datum/wires/disposals/on_pulse(wire)
	var/obj/structure/disposalpipe/sortjunction/A = holder
	switch(wire)
		if(WIRE_SORT_SCAN) // freeze sorting for 10 seconds
			if(A.sort_scan)
				A.sort_scan = FALSE
			addtimer(CALLBACK(A, TYPE_PROC_REF(/obj/structure/disposalpipe/sortjunction, reset_scan)), 10 SECONDS, TIMER_DELETE_ME)
		if(WIRE_SORT_FORWARD) // make things go forward if frozen
			A.last_sort = FALSE
		if(WIRE_SORT_SIDE) // make things go sideways if frozen
			A.last_sort = TRUE

/datum/wires/disposals/on_cut(wire, mend)
	var/obj/structure/disposalpipe/sortjunction/A = holder
	switch(wire)
		if(WIRE_SORT_SCAN) // freeze/unfreeze sorting forever
			A.sort_scan = mend
