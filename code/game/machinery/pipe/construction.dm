/*CONTENTS
Buildable pipes
Buildable meters
*/

/obj/item/pipe
	name = "pipe"
	desc = "A pipe."
	var/pipe_type
	var/pipename
	force = 7
	throwforce = 7
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "simple"
	item_state = "buildpipe"
	w_class = ITEMSIZE_NORMAL
	level = 2
	var/piping_layer = PIPING_LAYER_DEFAULT
	var/dispenser_class // Tells the dispenser what orientations we support, so RPD can show previews.

// One subtype for each way components connect to neighbors
/obj/item/pipe/directional
	dispenser_class = PIPE_DIRECTIONAL
/obj/item/pipe/binary
	dispenser_class = PIPE_STRAIGHT
/obj/item/pipe/binary/bendable
	dispenser_class = PIPE_BENDABLE
/obj/item/pipe/trinary
	dispenser_class = PIPE_TRINARY
/obj/item/pipe/trinary/flippable
	dispenser_class = PIPE_TRIN_M
	var/mirrored = FALSE
/obj/item/pipe/quaternary
	dispenser_class = PIPE_ONEDIR

/**
 * Call constructor with:
 * @param loc Location
 * @pipe_type
 */
/obj/item/pipe/Initialize(var/mapload, var/_pipe_type, var/_dir, var/obj/machinery/atmospherics/make_from)
	if(make_from)
		make_from_existing(make_from)
	else
		pipe_type = _pipe_type
		set_dir(_dir)

	update()
	pixel_x += rand(-5, 5)
	pixel_y += rand(-5, 5)
	return ..()

/obj/item/pipe/proc/make_from_existing(obj/machinery/atmospherics/make_from)
	set_dir(make_from.dir)
	pipename = make_from.name
	if(make_from.req_access)
		src.req_access = make_from.req_access
	if(make_from.req_one_access)
		src.req_one_access = make_from.req_one_access
	color = make_from.pipe_color
	pipe_type = make_from.type

/obj/item/pipe/trinary/flippable/make_from_existing(obj/machinery/atmospherics/trinary/make_from)
	..()
	if(make_from.mirrored)
		do_a_flip()

/obj/item/pipe/dropped()
	if(loc)
		setPipingLayer(piping_layer)
	return ..()

/obj/item/pipe/proc/setPipingLayer(new_layer = PIPING_LAYER_DEFAULT)
	var/obj/machinery/atmospherics/fakeA = pipe_type
	if(initial(fakeA.pipe_flags) & (PIPING_ALL_LAYER|PIPING_DEFAULT_LAYER_ONLY))
		new_layer = PIPING_LAYER_DEFAULT
	piping_layer = new_layer
	// Do it the Polaris way
	switch(piping_layer)
		if(PIPING_LAYER_SCRUBBER)
			color = PIPE_COLOR_RED
			name = "[initial(fakeA.name)] scrubber fitting"
		if(PIPING_LAYER_SUPPLY)
			color = PIPE_COLOR_BLUE
			name = "[initial(fakeA.name)] supply fitting"
		if(PIPING_LAYER_FUEL)
			color = PIPE_COLOR_YELLOW
			name = "[initial(fakeA.name)] fuel fitting"
		if(PIPING_LAYER_AUX)
			color = PIPE_COLOR_CYAN
			name = "[initial(fakeA.name)] aux fitting"
	// Or if we were to do it the TG way...
	// pixel_x = PIPE_PIXEL_OFFSET_X(piping_layer)
	// pixel_y = PIPE_PIXEL_OFFSET_Y(piping_layer)
	// layer = initial(layer) + PIPE_LAYER_OFFSET(piping_layer)

/obj/item/pipe/proc/update()
	var/obj/machinery/atmospherics/fakeA = pipe_type
	name = "[initial(fakeA.name)] fitting"
	icon_state = initial(fakeA.pipe_state)

/obj/item/pipe/verb/flip()
	set category = "Object"
	set name = "Flip Pipe"
	set src in view(1)

	if ( usr.stat || usr.restrained() || !usr.canmove )
		return

	do_a_flip()

/obj/item/pipe/proc/do_a_flip()
	set_dir(turn(dir, -180))
	fixdir()

/obj/item/pipe/trinary/flippable/do_a_flip()
	// set_dir(turn(dir, flipped ? 45 : -45))
	// TG has a magic icon set with the flipped versions in the diagonals.
	// We may switch to this later, but for now gotta do some magic.
	mirrored = !mirrored
	var/obj/machinery/atmospherics/fakeA = pipe_type
	icon_state = "[initial(fakeA.pipe_state)][mirrored ? "m" : ""]"

/obj/item/pipe/verb/rotate_clockwise()
	set category = "Object"
	set name = "Rotate Pipe Clockwise"
	set src in view(1)

	if ( usr.stat || usr.restrained() || !usr.canmove )
		return

	src.set_dir(turn(src.dir, 270))
	fixdir()

//VOREstation edit: counter-clockwise rotation
/obj/item/pipe/verb/rotate_counterclockwise()
	set category = "Object"
	set name = "Rotate Pipe Counter-Clockwise"
	set src in view(1)

	if ( usr.stat || usr.restrained() || !usr.canmove )
		return

	src.set_dir(turn(src.dir, 90))
	fixdir()
//VOREstation edit end

// Don't let pulling a pipe straighten it out.
/obj/item/pipe/binary/bendable/Move()
	var/old_bent = !IS_CARDINAL(dir)
	. = ..()
	if(old_bent && IS_CARDINAL(dir))
		set_dir(turn(src.dir, -45))

//Helper to clean up dir
/obj/item/pipe/proc/fixdir()
	return

/obj/item/pipe/binary/fixdir()
	if(dir == SOUTH)
		set_dir(NORTH)
	else if(dir == WEST)
		set_dir(EAST)

/obj/item/pipe/trinary/flippable/fixdir()
	if(dir in cornerdirs)
		set_dir(turn(dir, 45))

/obj/item/pipe/attack_self(mob/user)
	set_dir(turn(dir,-90))
	fixdir()

//called when a turf is attacked with a pipe item
/obj/item/pipe/afterattack(turf/simulated/floor/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target) && user.canUnEquip(src))
		user.drop_from_inventory(src, target)
	else
		return ..()

/obj/item/pipe/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		return wrench_act(user, W)
	return ..()

/obj/item/pipe/proc/wrench_act(var/mob/living/user, var/obj/item/tool/wrench/W)
	if(!isturf(loc))
		return TRUE

	add_fingerprint(user)
	fixdir()

	var/obj/machinery/atmospherics/fakeA = pipe_type
	var/flags = initial(fakeA.pipe_flags)
	for(var/obj/machinery/atmospherics/M in loc)
		if((M.pipe_flags & flags & PIPING_ONE_PER_TURF))	//Only one dense/requires density object per tile, eg connectors/cryo/heater/coolers.
			to_chat(user, "<span class='warning'>Something is hogging the tile!</span>")
			return TRUE
		if((M.piping_layer != piping_layer) && !((M.pipe_flags | flags) & PIPING_ALL_LAYER)) // Pipes on different layers can't block each other unless they are ALL_LAYER
			continue
		if(M.get_init_dirs() & SSmachines.get_init_dirs(pipe_type, dir))	// matches at least one direction on either type of pipe
			to_chat(user, "<span class='warning'>There is already a pipe at that location!</span>")
			return TRUE
	// no conflicts found

	var/obj/machinery/atmospherics/A = new pipe_type(loc)
	build_pipe(A)
	// TODO - Evaluate and remove the "need at least one thing to connect to" thing ~Leshana
	// With how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment.
	if (QDELETED(A))
		to_chat(user, "<span class='warning'>There's nothing to connect this pipe section to!</span>")
		return TRUE
	transfer_fingerprints_to(A)

	playsound(src, W.usesound, 50, 1)
	user.visible_message( \
		"[user] fastens \the [src].", \
		"<span class='notice'>You fasten \the [src].</span>", \
		"<span class='italics'>You hear ratcheting.</span>")

	qdel(src)

/obj/item/pipe/proc/build_pipe(obj/machinery/atmospherics/A)
	A.set_dir(dir)
	A.init_dir()
	if(pipename)
		A.name = pipename
	if(req_access)
		A.req_access = req_access
	if(req_one_access)
		A.req_one_access = req_one_access
	A.on_construction(color, piping_layer)

/obj/item/pipe/trinary/flippable/build_pipe(obj/machinery/atmospherics/trinary/T)
	T.mirrored = mirrored
	. = ..()

// Lookup the initialize_directions for a given atmos machinery instance facing dir.
// TODO - Right now this determines the answer by instantiating an instance and checking!
// There has to be a better way... ~Leshana
/datum/controller/subsystem/machines/proc/get_init_dirs(type, dir)
	var/static/list/pipe_init_dirs_cache = list()
	if(!pipe_init_dirs_cache[type])
		pipe_init_dirs_cache[type] = list()

	if(!pipe_init_dirs_cache[type]["[dir]"])
		var/obj/machinery/atmospherics/temp = new type(null, dir)
		pipe_init_dirs_cache[type]["[dir]"] = temp.get_init_dirs()
		qdel(temp)

	return pipe_init_dirs_cache[type]["[dir]"]





//
// Meters are special - not like any other pipes or components
//

/obj/item/pipe_meter
	name = "meter"
	desc = "A meter that can be laid on pipes."
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "meter"
	item_state = "buildpipe"
	w_class = ITEMSIZE_LARGE
	var/piping_layer = PIPING_LAYER_DEFAULT

/obj/item/pipe_meter/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		return wrench_act(user, W)
	return ..()

/obj/item/pipe_meter/proc/wrench_act(var/mob/living/user, var/obj/item/tool/wrench/W)
	var/obj/machinery/atmospherics/pipe/pipe
	for(var/obj/machinery/atmospherics/pipe/P in loc)
		if(P.piping_layer == piping_layer)
			pipe = P
			break
	if(!pipe)
		to_chat(user, "<span class='warning'>You need to fasten it to a pipe!</span>")
		return TRUE
	new /obj/machinery/meter(loc, piping_layer)
	playsound(src, W.usesound, 50, 1)
	to_chat(user, "<span class='notice'>You fasten the meter to the pipe.</span>")
	qdel(src)

/obj/item/pipe_meter/dropped()
	. = ..()
	if(loc)
		setAttachLayer(piping_layer)

/obj/item/pipe_meter/proc/setAttachLayer(new_layer = PIPING_LAYER_DEFAULT)
	piping_layer = new_layer
