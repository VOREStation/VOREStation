/datum/component/coughing_disability
	var/mob/living/owner
	var/cough_chance = 5

/datum/component/coughing_disability/Initialize()
	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	RegisterSignal(owner, COMSIG_HANDLE_DISABILITIES, PROC_REF(process_component))

/datum/component/coughing_disability/proc/process_component()
	if (QDELETED(parent))
		return
	if(isbelly(owner.loc))
		return
	if(owner.stat != CONSCIOUS)
		return
	if(owner.transforming)
		return
	if((prob(cough_chance) && owner.paralysis <= 1))
		owner.drop_item()
		owner.emote("cough")

/datum/component/coughing_disability/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_HANDLE_DISABILITIES)
	owner = null
	. = ..()
