// If a mob has this component, every life tick it will gain nutrition if it's standing in light up to nutrition_max.
// Extremely good tutorial component if you need an example with no special bells and whistles, and no "gotcha" behaviors.
/datum/component/photosynth
	var/mob/living/owner
	var/nutrition_max = 1000

/datum/component/photosynth/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(process_component))

/datum/component/photosynth/proc/process_component()
	if(QDELETED(parent))
		return
	if(owner.stat == DEAD)
		return
	if(owner.inStasisNow())
		return
	if(!isturf(owner.loc))
		return
	if(owner.nutrition >= nutrition_max)
		return
	var/turf/T = owner.loc
	owner.adjust_nutrition(T.get_lumcount() / 10)

/datum/component/photosynth/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	owner = null
	. = ..()
