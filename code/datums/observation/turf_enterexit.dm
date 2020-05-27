//	Observer Pattern Implementation: Turf Entered/Exited
//		Registration type: /turf
//
//		Raised when: A /turf has a new item in contents, or an item has left it's contents
//
//		Arguments that the called proc should expect:
//			/turf: The turf that was entered/exited
//			/atom/movable/moving_instance: The instance that entered/exited
// 			/atom/old_loc / /atom/new_loc: The previous/new loc of the mover


GLOBAL_DATUM_INIT(turf_entered_event, /decl/observ/turf_entered, new)
GLOBAL_DATUM_INIT(turf_exited_event, /decl/observ/turf_exited, new)

/decl/observ/turf_entered
	name = "Turf Entered"
	expected_type = /turf

/decl/observ/turf_exited
	name = "Turf Exited"
	expected_type = /turf

/********************
* Movement Handling *
********************/

/turf/Entered(var/atom/movable/am, var/atom/old_loc)
	. = ..()
	GLOB.turf_entered_event.raise_event(src, am, old_loc)

/turf/Exited(var/atom/movable/am, var/atom/new_loc)
	. = ..()
	GLOB.turf_exited_event.raise_event(src, am, new_loc)