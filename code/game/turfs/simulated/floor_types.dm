/turf/simulated/floor/diona
	name = "biomass flooring"
	icon_state = "diona"

/turf/simulated/floor/diona/attackby()
	return

//Shuttle Floors
/obj/landed_holder
	name = "landed turf holder"
	desc = "holds all the info about the turf this turf 'landed on'"
	var/turf/turf_type
	var/turf/simulated/shuttle/my_turf
	var/image/turf_image
	var/list/decals

/obj/landed_holder/New(var/location = null, var/turf/simulated/shuttle/turf)
	..(null)
	my_turf = turf

/obj/landed_holder/proc/land_on(var/turf/T)
	//Gather destination information
	var/obj/landed_holder/new_holder = new(null)
	new_holder.turf_type = T.type
	new_holder.dir = T.dir
	new_holder.icon = T.icon
	new_holder.icon_state =  T.icon_state
	new_holder.copy_overlays(T, TRUE)
	new_holder.underlays = T.underlays.Copy()
	new_holder.decals = T.decals ? T.decals.Copy() : null

	//Set the destination to be like us
	var/turf/simulated/shuttle/new_dest = T.ChangeTurf(my_turf.type,,1)
	new_dest.set_dir(my_turf.dir)
	new_dest.icon_state = my_turf.icon_state
	new_dest.icon = my_turf.icon
	new_dest.copy_overlays(my_turf, TRUE)
	new_dest.underlays = my_turf.underlays
	new_dest.decals = my_turf.decals
	//Shuttle specific stuff
	new_dest.interior_corner = my_turf.interior_corner
	new_dest.takes_underlays = my_turf.takes_underlays
	new_dest.under_turf = my_turf.under_turf
	new_dest.join_flags = my_turf.join_flags
	new_dest.join_group = my_turf.join_group

	// Associate the holder with the new turf.
	new_holder.my_turf = new_dest
	new_dest.landed_holder = new_holder

	//Update underlays if necessary (interior corners won't have changed).
	if(new_dest.takes_underlays && !new_dest.interior_corner)
		new_dest.underlay_update()

	return new_dest

/obj/landed_holder/proc/leave_turf(var/turf/base_turf = null)
	var/turf/new_source
	//Change our source to whatever it was before
	if(turf_type)
		new_source = my_turf.ChangeTurf(turf_type,,1)
		new_source.set_dir(dir)
		new_source.icon_state = icon_state
		new_source.icon = icon
		new_source.copy_overlays(src, TRUE)
		new_source.underlays = underlays
		new_source.decals = decals
	else
		new_source = my_turf.ChangeTurf(base_turf ? base_turf : get_base_turf_by_area(my_turf),,1)

	return new_source

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle_white.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	flags = TURF_ACID_IMMUNE

	var/obj/landed_holder/landed_holder
	var/interior_corner = 0
	var/takes_underlays = 0
	var/turf/under_turf //Underlay override turf path.
	var/join_flags = 0 //Bitstring to represent adjacency of joining walls
	var/join_group = "shuttle" //A tag for what other walls to join with. Null if you don't want them to.
	var/static/list/antilight_cache

/turf/simulated/shuttle/Initialize(mapload)
	. = ..()
	if(!antilight_cache)
		antilight_cache = list()
		for(var/diag in cornerdirs)
			var/image/I = image(LIGHTING_ICON, null, icon_state = "diagonals", layer = 10, dir = diag)
			I.plane = PLANE_LIGHTING
			antilight_cache["[diag]"] = I

/turf/simulated/shuttle/Destroy()
	landed_holder = null
	return ..()

// For joined corners touching static lighting turfs, add an overlay to cancel out that part of our lighting overlay.
/turf/simulated/shuttle/proc/update_breaklights()
	if(join_flags in cornerdirs) //We're joined at an angle
		//Dynamic lighting dissolver
		var/turf/T = get_step(src, turn(join_flags,180))
		if(!T || !T.dynamic_lighting || !get_area(T).dynamic_lighting)
			add_overlay(antilight_cache["[join_flags]"], TRUE)
			return
	cut_overlay(antilight_cache["[join_flags]"], TRUE)

/turf/simulated/shuttle/proc/underlay_update()
	if(!takes_underlays)
		//Basically, if it's not forced, and we don't care, don't do it.
		return 0

	var/turf/under //May be a path or a turf
	var/mutable_appearance/us = new(src) //We'll use this for changes later
	us.underlays.Cut()

	//Mapper wanted something specific
	if(under_turf)
		under = under_turf

	//Well if this isn't our first rodeo, we know EXACTLY what we landed on, and it looks like this.
	if(landed_holder && !interior_corner)
		//Space gets special treatment
		if(ispath(landed_holder.turf_type, /turf/space))
			var/image/spaceimage = image(landed_holder.icon, landed_holder.icon_state)
			spaceimage.plane = SPACE_PLANE
			underlays = list(spaceimage)
		else
			var/mutable_appearance/landed_on = new(landed_holder)
			landed_on.layer = FLOAT_LAYER //Not turf
			landed_on.plane = FLOAT_PLANE //Not turf
			us.underlays = list(landed_on)
			appearance = us

		spawn update_breaklights() //So that we update the breaklight overlays only after turfs are connected
		return

	if(!under)
		var/turf/T1
		var/turf/T2
		var/turf/T3

		T1 = get_step(src, turn(join_flags,135)) // 45 degrees before opposite
		T2 = get_step(src, turn(join_flags,225)) // 45 degrees beyond opposite
		T3 = get_step(src, turn(join_flags,180)) // Opposite from the diagonal

		if(isfloor(T1) && ((T1.type == T2.type) || (T1.type == T3.type)))
			under = T1
		else if(isfloor(T2) && T2.type == T3.type)
			under = T2
		else if(isfloor(T3) || istype(T3,/turf/space/transit))
			under = T3
		else
			under = get_base_turf_by_area(src)

	if(istype(under,/turf/simulated/shuttle))
		interior_corner = 1 //Prevents us from 'landing on grass' and having interior corners update.

	var/mutable_appearance/under_ma

	if(ispath(under)) //It's just a mapper-specified path
		under_ma = new()
		under_ma.icon = initial(under.icon)
		under_ma.icon_state = initial(under.icon_state)
		under_ma.color = initial(under.color)

	else //It's a real turf
		under_ma = new(under)

	if(under_ma)
		if(ispath(under,/turf/space) || istype(under,/turf/space)) //Space gets weird treatment
			under_ma.icon_state = "white"
			under_ma.plane = SPACE_PLANE
		us.underlays = list(under_ma)

	appearance = us

	spawn update_breaklights() //So that we update the breaklight overlays only after turfs are connected

	return under

/turf/simulated/shuttle/floor
	name = "floor"
	icon = 'icons/turf/flooring/shuttle.dmi'
	icon_state = "floor_blue"

/turf/simulated/shuttle/floor/red
	icon_state = "floor_red"

/turf/simulated/shuttle/floor/yellow
	icon_state = "floor_yellow"

/turf/simulated/shuttle/floor/darkred
	icon_state = "floor_dred"

/turf/simulated/shuttle/floor/purple
	icon_state = "floor_purple"

/turf/simulated/shuttle/floor/white
	icon_state = "floor_white"

/turf/simulated/shuttle/floor/black
	icon_state = "floor_black"

/turf/simulated/shuttle/floor/glass
	icon_state = "floor_glass"
	takes_underlays = 1

/turf/simulated/shuttle/floor/alien
	icon_state = "alienpod1"
	light_range = 3
	light_power = 0.6
	light_color = "#66ffff" // Bright cyan.
	light_on = TRUE
	block_tele = TRUE

/turf/simulated/shuttle/floor/alien/Initialize()
	. = ..()
	icon_state = "alienpod[rand(1, 9)]"
	update_light()

/turf/simulated/shuttle/floor/alienplating
	icon_state = "alienplating"
	block_tele = TRUE

/turf/simulated/shuttle/floor/alienplating/external // For the outer rim of the UFO, to avoid active edges.
// The actual temperature adjustment is defined if the SC or other future map is compiled.

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/simulated/shuttle/plating/airless
	oxygen = 0
	nitrogen = 0

//For 'carrying' otherwise empty turfs or stuff in space turfs with you or having holes in the floor or whatever.
/turf/simulated/shuttle/plating/carry
	name = "carry turf"
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "carry"
	takes_underlays = 1
	blocks_air = 1 //I'd make these unsimulated but it just fucks with so much stuff so many other places.

/turf/simulated/shuttle/plating/carry/Initialize()
	. = ..()
	icon_state = "carry_ingame"

/turf/simulated/shuttle/plating/airless/carry
	name = "airless carry turf"
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "carry"
	takes_underlays = 1
	blocks_air = 1

/turf/simulated/shuttle/plating/airless/carry/Initialize()
	. = ..()
	icon_state = "carry_ingame"

/turf/simulated/shuttle/plating/skipjack //Skipjack plating
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/floor/skipjack //Skipjack floors
	name = "skipjack floor"
	icon_state = "floor_dred"
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/floor/voidcraft
	name = "voidcraft tiles"
	icon_state = "void"

/turf/simulated/shuttle/floor/voidcraft/dark
	name = "voidcraft tiles"
	icon_state = "void_dark"

/turf/simulated/shuttle/floor/voidcraft/light
	name = "voidcraft tiles"
	icon_state = "void_light"

/turf/simulated/shuttle/floor/voidcraft/external // For avoiding active edges.
// The actual temperature adjustment is defined if the SC or other future map is compiled.

/turf/simulated/shuttle/floor/voidcraft/external/dark

/turf/simulated/shuttle/floor/voidcraft/external/light
