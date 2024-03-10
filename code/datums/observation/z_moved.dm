//	Observer Pattern Implementation: Z_Moved
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has changed z-levels by any means.
//
//		Arguments that the called proc should expect:
//			/atom/movable/moving_instance: The instance that moved
//			old_z: The z number before the move.
//			new_z: The z number after the move.


GLOBAL_DATUM_INIT(z_moved_event, /decl/observ/z_moved, new)

/decl/observ/z_moved
	name = "Z_Moved"
	expected_type = /atom/movable
