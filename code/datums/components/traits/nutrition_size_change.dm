#define GROWMODE_SHRINK 1
#define GROWMODE_GROW 2

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
	// Species controls hunger rate for humans, otherwise use defaults
	var/nutrition_reduction = DEFAULT_HUNGER_FACTOR
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		nutrition_reduction = H.species.hunger_factor
	// Modifiers can increase or decrease nutrition cost
	for(var/datum/modifier/mod in owner.modifiers)
		if(!isnull(mod.metabolism_percent))
			nutrition_reduction *= mod.metabolism_percent
	// Time to change size!
	if(owner.nutrition > 1000 && grow_mode == GROWMODE_GROW) //Removing the strict check against normal max/min size to support dorms/VR oversizing
		nutrition_reduction *= 5
		owner.resize(owner.size_multiplier+0.01, animate = FALSE, uncapped = owner.has_large_resize_bounds()) //Bringing this code in line with micro and macro shrooms
	if(owner.nutrition < 50 && grow_mode == GROWMODE_SHRINK)
		nutrition_reduction *= 0.3
		owner.resize(owner.size_multiplier-0.01, animate = FALSE, uncapped = owner.has_large_resize_bounds()) //Bringing this code in line with micro and macro shrooms
	// Apply hunger costs
	owner.adjust_nutrition(-nutrition_reduction)

/datum/component/nutrition_size_change/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	owner = null
	. = ..()

#undef GROWMODE_SHRINK
#undef GROWMODE_GROW
