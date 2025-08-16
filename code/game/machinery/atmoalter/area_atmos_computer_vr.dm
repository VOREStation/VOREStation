// The one that only works in the same map area
/obj/machinery/portable_atmospherics/powered/scrubber/huge/var/scrub_id = "generic"

/obj/machinery/computer/area_atmos/tag
	name = "Heavy Scrubber Control"
	zone = "This computer is operating industrial scrubbers nearby."
	var/scrub_id = "generic"
	var/last_scan = 0

/obj/machinery/computer/area_atmos/tag/scanscrubbers()
	if(last_scan && world.time - last_scan < 20 SECONDS)
		return 0
	else
		last_scan = world.time

	connectedscrubbers.Cut()

	for(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber in world)
		if(scrubber.scrub_id == src.scrub_id)
			connectedscrubbers["[scrubber.id]"] = scrubber

	SStgui.update_uis(src)

/obj/machinery/computer/area_atmos/tag/validscrubber(var/obj/machinery/portable_atmospherics/powered/scrubber/huge/scrubber)
	if(!istype(scrubber))
		return FALSE

	if(scrubber.scrub_id == src.scrub_id)
		return TRUE

	return FALSE
