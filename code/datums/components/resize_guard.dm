/datum/component/resize_guard

/datum/component/resize_guard/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/resize_guard/RegisterWithParent()
	// When our parent mob enters any atom, we check resize
	RegisterSignal(parent, COMSIG_ATOM_ENTERING, PROC_REF(check_resize))

/datum/component/resize_guard/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_ENTERING)

/datum/component/resize_guard/proc/check_resize()
	SIGNAL_HANDLER
	var/area/A = get_area(parent)
	if(A?.flag_check(AREA_ALLOW_LARGE_SIZE))
		return
	var/mob/living/L = parent
	L.resize(L.size_multiplier, ignore_prefs = TRUE)
	qdel(src)
