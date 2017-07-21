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

	New(var/location = null, var/turf/simulated/shuttle/turf)
		my_turf = turf

/obj/landed_holder/proc/land_on(var/turf/T)
	//Gather destination information
	var/old_dest_type = T.type
	var/old_dest_dir = T.dir
	var/old_dest_icon_state = T.icon_state
	var/old_dest_icon = T.icon
	var/list/old_dest_overlays = T.overlays.Copy()
	var/list/old_dest_underlays = T.underlays.Copy()

	//Set the destination to be like us
	T.Destroy()
	var/turf/simulated/shuttle/new_dest = T.ChangeTurf(my_turf.type,,1)
	new_dest.set_dir(my_turf.dir)
	new_dest.icon_state = my_turf.icon_state
	new_dest.icon = my_turf.icon
	new_dest.overlays = my_turf.overlays
	new_dest.underlays = my_turf.underlays
		//Shuttle specific stuff
	new_dest.interior_corner = my_turf.interior_corner
	new_dest.takes_underlays = my_turf.takes_underlays
	new_dest.under_turf = my_turf.under_turf
	new_dest.join_flags = my_turf.join_flags
	new_dest.join_group = my_turf.join_group

	//Tell the new turf about what was there before
	new_dest.landed_holder = new(turf = new_dest)
	new_dest.landed_holder.turf_type = old_dest_type
	new_dest.landed_holder.dir = old_dest_dir
	new_dest.landed_holder.icon = old_dest_icon
	new_dest.landed_holder.icon_state = old_dest_icon_state
	new_dest.landed_holder.overlays = old_dest_overlays
	new_dest.landed_holder.underlays = old_dest_underlays

	//Update underlays if necessary (interior corners won't have changed).
	if(new_dest.takes_underlays && !new_dest.interior_corner)
		new_dest.underlay_update()

	return new_dest

/obj/landed_holder/proc/leave_turf()
	var/turf/new_source
	//Change our source to whatever it was before
	if(turf_type)
		new_source = my_turf.ChangeTurf(turf_type,,1)
		new_source.set_dir(dir)
		new_source.icon_state = icon_state
		new_source.icon = icon
		new_source.overlays = overlays
		new_source.underlays = underlays
	else
		new_source = my_turf.ChangeTurf(get_base_turf_by_area(my_turf),,1)

	return new_source

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle_white.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0

	var/obj/landed_holder/landed_holder
	var/interior_corner = 0
	var/takes_underlays = 0
	var/turf/under_turf //Underlay override turf path.
	var/join_flags = 0 //Bitstring to represent adjacency of joining walls
	var/join_group = "shuttle" //A tag for what other walls to join with. Null if you don't want them to.

/turf/simulated/shuttle/Destroy()
	landed_holder = null
	..()

/turf/simulated/shuttle/proc/underlay_update()
	if(!takes_underlays)
		//Basically, if it's not forced, and we don't care, don't do it.
		return 0

	var/turf/under //May be a path or a turf

	//Mapper wanted something specific
	if(under_turf)
		under = under_turf

	//Well if this isn't our first rodeo, we know EXACTLY what we landed on, and it looks like this.
	if(landed_holder && !interior_corner)
		underlays.Cut()
		underlays += image(landed_holder,layer=FLOAT_LAYER)
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

	var/use_icon = ispath(under) ? initial(under.icon) : under.icon
	var/use_icon_state

	if(istype(under,/turf/simulated/shuttle))
		interior_corner = 1 //Prevents us from 'landing on grass' and having interior corners update.

	if(ispath(under,/turf/space))
		use_icon_state = "[rand(1,25)]" //Space turfs should be random.
	else
		use_icon_state = ispath(under) ? initial(under.icon_state) : under.icon_state

	var/image/under_image = new(use_icon,icon_state = use_icon_state)
	underlays.Cut()
	underlays |= under_image

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

	initialize()
		icon_state = "carry_ingame"

/turf/simulated/shuttle/plating/airless/carry
	name = "airless carry turf"
	icon = 'icons/turf/shuttle_parts.dmi'
	icon_state = "carry"
	takes_underlays = 1
	blocks_air = 1

	initialize()
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

