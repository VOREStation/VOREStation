/proc/createRandomZlevel()
	#ifdef UNIT_TEST
	return
	#endif
	if(GLOB.awaydestinations.len)	//crude, but it saves another var! //VOREStation Edit - No loading away missions during CI testing
		return

	var/list/potentialRandomZlevels = list()
	admin_notice(span_red(span_bold(" Searching for away missions...")), R_DEBUG)
	var/list/Lines = file2list("maps/RandomZLevels/fileList.txt")
	if(!Lines.len)	return
	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
	//	var/value = null

		if (pos)
			// No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		//	value = copytext(t, pos + 1)
		else
			// No, don't do lowertext here, that breaks paths on linux
			name = t

		if (!name)
			continue

		potentialRandomZlevels.Add(name)


	if(potentialRandomZlevels.len)
		admin_notice(span_red(span_bold("Loading away mission...")), R_DEBUG)

		var/map = pick(potentialRandomZlevels)
		to_world_log("Away mission picked: [map]") //VOREStation Add for debugging
		var/file = file(map)
		if(isfile(file))
			var/datum/map_template/template = new(file, "away mission")
			template.load_new_z()
			to_world_log("away mission loaded: [map]")
		/* VOREStation Removal - We do this in the special landmark init instead.
		for(var/obj/effect/landmark/L in landmarks_list)
			if (L.name != "awaystart")
				continue
			awaydestinations.Add(L)
		*/ //VOREStation Removal End
		admin_notice(span_red(span_bold("Away mission loaded.")), R_DEBUG)

	else
		admin_notice(span_red(span_bold("No away missions found.")), R_DEBUG)
		return

//VOREStation Add - This landmark type so it's not so ghetto.
/obj/effect/landmark/gateway_scatter
	name = "uncalibrated gateway destination"
/obj/effect/landmark/gateway_scatter/Initialize(mapload)
	. = ..()
	GLOB.awaydestinations += src

/obj/effect/landmark/gateway_scatter/abduct
	name = "uncalibrated gateway abductor"
	abductor = 1

/obj/effect/landmark/event_scatter
	name = "uncalibrated event destination"
/obj/effect/landmark/event_scatter/Initialize(mapload)
	. = ..()
	GLOB.eventdestinations += src

/obj/effect/landmark/event_scatter/abduct
	name = "uncalibrated event abductor"
	abductor = 1

/obj/effect/landmark/gateway_abduct_dest
	name = "abductor gateway destination"
/obj/effect/landmark/gateway_abduct_dest/Initialize(mapload)
	. = ..()
	GLOB.awayabductors += src

/obj/effect/landmark/event_abduct_dest
	name = "abductor event destination"
/obj/effect/landmark/event_abduct_dest/Initialize(mapload)
	. = ..()
	GLOB.eventabductors += src
//VOREStation Add End
