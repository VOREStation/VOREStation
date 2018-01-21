
/obj/machinery/atmospherics/pipe
	var/datum/pipe_construction/construction_type // The PATH of the construction method to use

//
// Datum that describes and regulates how pipes are constructed!
//
/datum/pipe_construction

/** Normalize the dir of the pipe fitting to ensure its sane for construction. */
/datum/pipe_construction/proc/normalize_dir()
	return

/** Calulate in which directions directions the constructed pipe will be able to connect. */
/datum/pipe_construction/proc/calculate_initialize_directions()
	return

/** Check if we can actually construct in the given location. */
/datum/pipe_construction/proc/can_construct(var/turf/T)
	return

/** Actually construct the pipe! Return TRUE on failure. */
/datum/pipe_construction/proc/construct(var/turf/T, var/obj/item/pipe/fitting, var/construct_type)
	return

// For constructing pipe segments with two nodes
/datum/pipe_construction/pipe/simple/binary/construct(var/mob/user, var/turf/T, var/obj/item/pipe/fitting, var/construct_type)
	var/obj/machinery/atmospherics/pipe/simple/P = new construct_type(T)
	P.pipe_color = fitting.color
	P.set_dir(fitting.dir)
	P.init_dir()
	P.level = !T.is_plating() ? 2 : 1 // Standard to decide if we are making hidden or not
	P.atmos_init()
	if (QDELETED(P)) // Should do this for legacy reasons, but hopefully will never happen
		usr << pipefailtext
		return 1
	P.build_network()
	if (P.node1)
		P.node1.atmos_init()
		P.node1.build_network()
	if (P.node2)
		P.node2.atmos_init()
		P.node2.build_network()
	return

/datum/pipe_construction/pipe/simple/trinary/construct(var/mob/user, var/turf/T, var/obj/item/pipe/fitting, var/construct_type)
	var/obj/machinery/atmospherics/pipe/manifold/M = new( src.loc )
	M.pipe_color = fitting.color
	M.set_dir(fitting.dir)
	M.init_dir()
	M.level = !T.is_plating() ? 2 : 1
	M.atmos_init()
	if (QDELETED(M))
		usr << pipefailtext
		return 1
	M.build_network()
	if (M.node1)
		M.node1.atmos_init()
		M.node1.build_network()
	if (M.node2)
		M.node2.atmos_init()
		M.node2.build_network()
	if (M.node3)
		M.node3.atmos_init()
		M.node3.build_network()
	return



















// For constructing pipe segments with two nodes
/datum/pipe_construction/pipe/simple/binary/he/construct(var/mob/user, var/turf/T, var/obj/item/pipe/fitting, var/construct_type)
	var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/P = new construct_type(T)
	P.set_dir(fitting.dir)
	P.init_dir()
	P.atmos_init()
	if (QDELETED(P)) // Should do this for legacy reasons, but hopefully will never happen
		usr << pipefailtext
		return 1
	P.build_network()
	if (P.node1)
		P.node1.atmos_init()
		P.node1.build_network()
	if (P.node2)
		P.node2.atmos_init()
		P.node2.build_network()
	return


/datum/pipe_construction/pipe/component/unary/construct(var/mob/user, var/turf/T, var/obj/item/pipe/fitting, var/construct_type)
	var/obj/machinery/atmospherics/C = new construct_type(T)
	C.set_dir(fitting.dir)
	C.init_dir()
	if(fitting.pipename)
		C.name = fitting.pipename
	C.level = !T.is_plating() ? 2 : 1 // Standard to decide if we are making hidden or not
	C.atmos_init()
	P.build_network()
	if (P.node)
		P.node.atmos_init()
		P.node.build_network()
	return
