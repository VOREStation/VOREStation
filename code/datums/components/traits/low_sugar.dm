///Component that gives negative effects when at low nutrition.
/datum/component/diabetic
	var/drip_chance = 5
	var/blood_color = "#A10808"

/datum/component/diabetic/Initialize()

	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/diabetic/proc/process_component()
	SIGNAL_HANDLER
	var/mob/living/living_guy = parent

/datum/component/diabetic/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(process_component))

/datum/component/diabetic/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_LIFE))
