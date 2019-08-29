//	Observer Pattern Implementation: Destroyed
//		Registration type: /datum
//
//		Raised when: A /datum instance is destroyed.
//
//		Arguments that the called proc should expect:
//			/datum/destroyed_instance: The instance that was destroyed.

/decl/observ/destroyed
	name = "Destroyed"

/datum/Destroy()
	if(GLOB.destroyed_event)
		GLOB.destroyed_event.raise_event(src)
	. = ..()
