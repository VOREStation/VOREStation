#define GROWMODE_SHRINK 1
#define GROWMODE_GROW 2

#define GROW_MULTIPLIER 5
#define SHRINK_MULTIPLIER 0.3

/datum/component/nutrition_size_change
	var/mob/living/owner
	var/grow_mode = 0 // Don't use base component

/datum/component/nutrition_size_change/growing
	grow_mode = GROWMODE_GROW

/datum/component/nutrition_size_change/shrinking
	grow_mode = GROWMODE_SHRINK

/datum/component/nutrition_size_change/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(process_component))

/datum/component/nutrition_size_change/proc/process_component()
	if(QDELETED(parent))
		return
	if(owner.stat == DEAD)
		return
	if(owner.inStasisNow())
		return
	if(owner.nutrition <= 0 && grow_mode == GROWMODE_SHRINK && owner.size_multiplier > RESIZE_TINY)
		owner.nutrition = 0.1
	if(owner.nutrition <= 0)
		return
	// Time to change size!
	var/nutrition_multiplier = get_nutrition_multiplier()
	if(nutrition_multiplier == GROW_MULTIPLIER) //Removing the strict check against normal max/min size to support dorms/VR oversizing
		owner.resize(owner.size_multiplier+0.01, animate = FALSE, uncapped = owner.has_large_resize_bounds()) //Bringing this code in line with micro and macro shrooms
	if(nutrition_multiplier == SHRINK_MULTIPLIER)
		owner.resize(owner.size_multiplier-0.01, animate = FALSE, uncapped = owner.has_large_resize_bounds()) //Bringing this code in line with micro and macro shrooms

/datum/component/nutrition_size_change/proc/get_nutrition_multiplier()
	if(owner.nutrition > 1000 && grow_mode == GROWMODE_GROW) //Removing the strict check against normal max/min size to support dorms/VR oversizing
		return GROW_MULTIPLIER
	else if(owner.nutrition < 50 && grow_mode == GROWMODE_SHRINK)
		return SHRINK_MULTIPLIER

/datum/component/nutrition_size_change/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	owner = null
	. = ..()

#undef GROWMODE_SHRINK
#undef GROWMODE_GROW

#undef GROW_MULTIPLIER
#undef SHRINK_MULTIPLIER
