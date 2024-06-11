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
	var/area/A = get_area(parent)
	if(A?.limit_mob_size)
		var/mob/living/L = parent
		L.resize(L.size_multiplier, ignore_prefs = TRUE)
		qdel(src)
