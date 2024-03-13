//	Observer Pattern Implementation: Area Power Change
//		Registration type: /area
//
//		Raised when: An /area has a power change (the APC powers up/down or some channels are enabled/disabled)
//
//		Arguments that the called proc should expect:
//			/area: The area experiencing the power change
/*
GLOBAL_DATUM_INIT(apc_event, /decl/observ/area_power_change, new)

/decl/observ/area_power_change
	name = "Area Power Change"
	expected_type = /area

/********************
* Movement Handling *
********************/
*/
//Deprecated in favor of comsigs

/area/power_change()
	. = ..()
	SEND_SIGNAL(src,COMSIG_OBSERVER_APC)
