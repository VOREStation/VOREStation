///Component that holds the antag trait. This is the base version.
/datum/component/antag
	var/mob/living/owner
	dupe_mode = COMPONENT_DUPE_UNIQUE //Only one type.

/datum/component/antag/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent

///Should never be destroyed as these are applied to the mind.
/datum/component/antag/Destroy(force = FALSE)
	if(!force)
		return QDEL_HINT_LETMELIVE
	owner = null
	. = ..()

///Antag datum that is held on /datum/mind. Holds all the antag data.
/datum/antag_holder
	var/datum/component/antag/changeling/changeling
	var/is_antag = FALSE

/datum/antag_holder/proc/apply_antags(mob/M)
	if(!M)
		return
	if(changeling)
		M.make_changeling()
		is_antag = TRUE

/datum/antag_holder/proc/is_antag()
	return is_antag
