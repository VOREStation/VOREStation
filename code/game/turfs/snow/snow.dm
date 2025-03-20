/turf/snow
	name = "snow"

	dynamic_lighting = 0
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "snow"

	oxygen = MOLES_O2STANDARD * 1.15
	nitrogen = MOLES_N2STANDARD * 1.15

	temperature = TN60C
	var/list/crossed_dirs = list()

/turf/snow/Entered(atom/A)
	if(ismob(A))
		var/mdir = "[A.dir]"
		if(crossed_dirs[mdir])
			crossed_dirs[mdir] = min(crossed_dirs[mdir] + 1, FOOTSTEP_SPRITE_AMT)
		else
			crossed_dirs[mdir] = 1

		update_icon()

	. = ..()

/turf/snow/update_icon()
	cut_overlays()
	for(var/d in crossed_dirs)
		var/amt = crossed_dirs[d]

		for(var/i in 1 to amt)
			add_overlay(image(icon, "footprint[i]", text2num(d)))

/turf/snow/snow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/snow/gravsnow
	name = "snow"
	icon_state = "gravsnow"

/turf/snow/plating
	name = "snowy playing"
	icon_state = "snowyplating"

/turf/snow/drift
	name = "snowy plating"
	icon_state = "snowyplayingdrift"
