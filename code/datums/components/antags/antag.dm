///Component that holds the antag trait. This is the base version.
/datum/component/antag
	var/mob/living/owner

/datum/component/antag/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent

/datum/component/antag/Destroy(force = FALSE)
	owner = null
	. = ..()
