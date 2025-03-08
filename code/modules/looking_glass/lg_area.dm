/area/looking_glass
	name = "make a subtype"

	var/obj/effect/landmark/looking_glass/our_landmark
	var/list/our_turfs = list()
	var/list/our_optional_turfs = list()

	var/lg_id

	var/active = FALSE

/area/looking_glass/Initialize(mapload)
	. = ..()
	our_landmark = locate() in src
	if(!our_landmark)
		testing("Looking glass area [name] couldn't find a landmark")
	for(var/turf/simulated/floor/looking_glass/lgt in src)
		our_turfs += lgt
		if(lgt.optional)
			our_optional_turfs += lgt

/area/looking_glass/Destroy()
	our_landmark = null
	our_turfs.Cut()
	return ..()

/area/looking_glass/Entered(var/atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.client)
			our_landmark?.gain_viewer(L.client)

/area/looking_glass/Exited(var/atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.client)
			our_landmark?.lose_viewer(L.client)

/area/looking_glass/proc/begin_program(var/image/newimage)
	if(!active)
		for(var/turf/simulated/floor/looking_glass/lgt as anything in our_turfs)
			lgt.activate()

	our_landmark.take_image(newimage)
	active = TRUE

/area/looking_glass/proc/end_program()
	if(active)
		for(var/turf/simulated/floor/looking_glass/lgt as anything in our_turfs)
			lgt.deactivate()

	active = FALSE

	spawn(2 SECONDS)
		our_landmark.drop_image()

/area/looking_glass/proc/toggle_optional(var/transparent)
	for(var/turf/simulated/floor/looking_glass/lgt as anything in our_optional_turfs)
		lgt.center = !transparent
		if(active)
			lgt.deactivate()
			spawn(3 SECONDS)
				lgt.activate()

/area/looking_glass/lg_1
	name = "looking glass one"
	lg_id = "one"

/area/looking_glass/lg_2
	name = "looking glass two"
	lg_id = "two"

/area/looking_glass/lg_3
	name = "looking glass three"
	lg_id = "three"
