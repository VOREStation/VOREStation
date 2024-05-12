//	Observer Pattern Implementation: Destroyed
//		Registration type: /datum
//
//		Raised when: A /datum instance is destroyed.
//
//		Arguments that the called proc should expect:
//			/datum/destroyed_instance: The instance that was destroyed.
/*
/decl/observ/destroyed
	name = "Destroyed"
*/
//Deprecated in favor of Comsigs

/datum/Destroy()
	SEND_SIGNAL(src,COMSIG_OBSERVER_DESTROYED)
	. = ..()
