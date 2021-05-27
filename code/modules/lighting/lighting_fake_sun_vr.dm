/obj/effect/fake_sun
	name = "fake sun"
	desc = "Deletes itself, but first updates all the lighting on outdoor turfs."
	icon = 'icons/effects/effects_vr.dmi'
	icon_state = "fakesun"

	var/list/possible_light_setups = list(
		list(
			"brightness" = 1.0,
			"color" = "#f3932d"
		),
		list(
			"brightness" = 6.0,
			"color" = "#abfff7"
		)
	)

/obj/effect/fake_sun/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/fake_sun/LateInitialize()
	. = ..()

	var/list/our_choice = pick(possible_light_setups)
	
	// Calculate new values to apply
	var/new_brightness = our_choice["brightness"]
	var/new_color = our_choice["color"]
	var/lum_r = new_brightness * GetRedPart  (new_color) / 255
	var/lum_g = new_brightness * GetGreenPart(new_color) / 255
	var/lum_b = new_brightness * GetBluePart (new_color) / 255
	var/static/update_gen = -1 // Used to prevent double-processing corners. Otherwise would happen when looping over adjacent turfs.
	
	var/list/turfs = block(locate(1,1,z),locate(world.maxx,world.maxy,z))
	
	var/count = 0
	for(var/turf/simulated/T as anything in turfs)
		if(!T.lighting_overlay)
			T.lighting_build_overlay()
		if(!T.outdoors)
			continue
		for(var/C in T.get_corners())
			var/datum/lighting_corner/LC = C
			if(LC.update_gen != update_gen && LC.active)
				LC.update_gen = update_gen
				LC.update_lumcount(lum_r, lum_g, lum_b)
		count++
	update_gen--
	qdel(src)