//Beam Datum and effect
/datum/beam
	var/atom/origin = null
	var/atom/target = null
	var/list/elements = list()
	var/icon/base_icon = null
	var/icon
	var/icon_state = "" //icon state of the main segments of the beam
	var/beam_color = null // Color of the beam segments
	var/max_distance = 0
	var/endtime = 0
	var/sleep_time = 3
	var/finished = 0
	var/target_oldloc = null
	var/origin_oldloc = null
	var/static_beam = 0
	var/beam_type = /obj/effect/ebeam //must be subtype
	/// If set will be used instead of origin's pixel_x in offset calculations
	var/override_origin_pixel_x = null
	/// If set will be used instead of origin's pixel_y in offset calculations
	var/override_origin_pixel_y = null
	/// If set will be used instead of targets's pixel_x in offset calculations
	var/override_target_pixel_x = null
	/// If set will be used instead of targets's pixel_y in offset calculations
	var/override_target_pixel_y = null

/datum/beam/New(
	beam_origin,
	beam_target,
	beam_icon='icons/effects/beam.dmi',
	beam_icon_state="b_beam",
	time=50,
	maxdistance=10,
	btype = /obj/effect/ebeam,
	beam_sleep_time=3,
	new_beam_color = null,
	override_origin_pixel_x = null,
	override_origin_pixel_y = null,
	override_target_pixel_x = null,
	override_target_pixel_y = null,
	)
	origin = beam_origin
	target = beam_target
	icon = beam_icon
	icon_state = beam_icon_state
	base_icon = new(beam_icon,beam_icon_state)
	endtime = world.time+time
	max_distance = maxdistance
	sleep_time = beam_sleep_time
	if(new_beam_color)
		beam_color = new_beam_color
	src.override_origin_pixel_x = override_origin_pixel_x
	src.override_origin_pixel_y = override_origin_pixel_y
	src.override_target_pixel_x = override_target_pixel_x
	src.override_target_pixel_y = override_target_pixel_y


	origin_oldloc =	get_turf(origin)

	target_oldloc = get_turf(target)

	if(origin_oldloc == origin && target_oldloc == target)
		static_beam = 1





	beam_type = btype

/datum/beam/proc/Start()
	Draw()
	while(!finished && origin && target && world.time < endtime && get_dist(origin,target)<max_distance && origin.z == target.z)
		var/origin_turf = get_turf(origin)
		var/target_turf = get_turf(target)
		if(!static_beam && (origin_turf != origin_oldloc || target_turf != target_oldloc))
			origin_oldloc = origin_turf //so we don't keep checking against their initial positions, leading to endless Reset()+Draw() calls
			target_oldloc = target_turf
			Reset()
			Draw()
		sleep(sleep_time)

	qdel(src)

/datum/beam/proc/End()
	finished = TRUE

/datum/beam/proc/Reset()
	for(var/obj/effect/ebeam/B in elements)
		qdel(B)
	elements.Cut()

/datum/beam/Destroy()
	Reset()
	target = null
	origin = null
	return ..()

/**
 * Triggered by signals set up when the beam is set up. If it's still sane to create a beam, it removes the old beam, creates a new one. Otherwise it kills the beam.
 *
 * Arguments:
 * mover: either the origin of the beam or the target of the beam that moved.
 * oldloc: from where mover moved.
 * direction: in what direction mover moved from.
 */
/datum/beam/proc/redrawing(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER
	if(QDELING(src))
		return
	if(!QDELETED(origin) && !QDELETED(target) && get_dist(origin,target)<max_distance && origin.z == target.z)
		QDEL_LIST(elements)
		INVOKE_ASYNC(src, PROC_REF(Draw))
	else
		qdel(src)

/datum/beam/proc/Draw()
	if(QDELETED(target) || QDELETED(origin))
		qdel(src)
		return
	var/origin_px = (isnull(override_origin_pixel_x) ? origin.pixel_x : override_origin_pixel_x) + origin.pixel_w
	var/origin_py = (isnull(override_origin_pixel_y) ? origin.pixel_y : override_origin_pixel_y) + origin.pixel_z
	var/target_px = (isnull(override_target_pixel_x) ? target.pixel_x : override_target_pixel_x) + target.pixel_w
	var/target_py = (isnull(override_target_pixel_y) ? target.pixel_y : override_target_pixel_y) + target.pixel_z
	var/Angle = get_angle_raw(origin.x, origin.y, origin_px, origin_py, target.x , target.y, target_px, target_py)

	var/matrix/rot_matrix = matrix()
	rot_matrix.Turn(Angle)
	//Translation vector for origin and target
	var/DX = (32*target.x+target_px)-(32*origin.x+origin_px)
	var/DY = (32*target.y+target_py)-(32*origin.y+origin_py)
	var/N = 0
	var/length = round(sqrt((DX)**2+(DY)**2)) //hypotenuse of the triangle formed by target and origin's displacement

	for(N in 0 to length-1 step 32)//-1 as we want < not <=, but we want the speed of X in Y to Z and step X
		if(QDELETED(src) || finished)
			break
		var/obj/effect/ebeam/X = new beam_type(origin_oldloc)

		if(beam_color)
			X.color = beam_color

		X.owner = src
		elements |= X

		//Assign icon, for main segments it's base_icon, for the end, it's icon+icon_state
		//cropped by a transparent box of length-N pixel size
		if(N+32>length)
			var/icon/II = new(icon, icon_state)
			II.DrawBox(null,1,(length-N),32,32)
			X.icon = II
		else
			X.icon = base_icon
		X.transform = rot_matrix

		//Calculate pixel offsets (If necessary)
		var/Pixel_x
		var/Pixel_y
		if(DX == 0)
			Pixel_x = 0
		else
			Pixel_x = round(sin(Angle)+32*sin(Angle)*(N+16)/32)
		if(DY == 0)
			Pixel_y = 0
		else
			Pixel_y = round(cos(Angle)+32*cos(Angle)*(N+16)/32)

		//Position the effect so the beam is one continous line
		var/a
		if(abs(Pixel_x)>32)
			a = Pixel_x > 0 ? round(Pixel_x/32) : CEILING(Pixel_x/32, 1)
			X.x += a
			Pixel_x %= 32
		if(abs(Pixel_y)>32)
			a = Pixel_y > 0 ? round(Pixel_y/32) : CEILING(Pixel_y/32, 1)
			X.y += a
			Pixel_y %= 32

		X.pixel_x = Pixel_x
		X.pixel_y = Pixel_y

		X.on_drawn()

/obj/effect/ebeam
	mouse_opacity = 0
	anchored = TRUE
	var/datum/beam/owner

/obj/effect/ebeam/Destroy()
	owner = null
	return ..()

/obj/effect/ebeam/singularity_pull()
	return
/obj/effect/ebeam/singularity_act()
	return

// Called when the beam datum finishes drawing and the ebeam object is placed correctly.
/obj/effect/ebeam/proc/on_drawn()
	return

/obj/effect/ebeam/deadly/Crossed(atom/A)
	if(A.is_incorporeal())
		return
	..()
	A.ex_act(1)

// 'Reactive' beam parts do something when touched or stood in.
/obj/effect/ebeam/reactive

/obj/effect/ebeam/reactive/Initialize(mapload)
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/ebeam/reactive/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/ebeam/reactive/on_drawn()
	for(var/A in loc)
		on_contact(A)

/obj/effect/ebeam/reactive/Crossed(atom/A)
	if(A.is_incorporeal())
		return
	..()
	on_contact(A)

/obj/effect/ebeam/reactive/process()
	for(var/A in loc)
		on_contact(A)

// Override for things to do when someone touches the beam.
/obj/effect/ebeam/reactive/proc/on_contact(atom/movable/AM)
	return


// Shocks things that touch it.
/obj/effect/ebeam/reactive/electric
	var/shock_amount = 25 // Be aware that high numbers may stun and result in dying due to not being able to get out of the beam.

/obj/effect/ebeam/reactive/electric/on_contact(atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		L.inflict_shock_damage(shock_amount)



/atom/proc/Beam(atom/BeamTarget, icon_state="b_beam", icon='icons/effects/beam.dmi', time=50, maxdistance=10, beam_type=/obj/effect/ebeam, beam_sleep_time=3, beam_color = null)
	var/datum/beam/newbeam = new(src,BeamTarget,icon,icon_state,time,maxdistance,beam_type,beam_sleep_time,beam_color)
	spawn(0)
		newbeam.Start()
	return newbeam
