/datum/component/epilepsy_disability
	var/mob/living/owner

/datum/component/epilepsy_disability/Initialize()
	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	RegisterSignal(owner, COMSIG_HANDLE_DISABILITIES, PROC_REF(process_component))

/datum/component/epilepsy_disability/proc/process_component()
	if (QDELETED(parent))
		return
	if(isbelly(owner.loc))
		return
	if(owner.stat != CONSCIOUS)
		return
	if(owner.transforming)
		return
	if((prob(1) && prob(1) && owner.paralysis < 1))
		to_chat(owner, span_red("You have a seizure!"))
		for(var/mob/O in viewers(owner, null))
			if(O == owner)
				continue
			O.show_message(span_danger("[owner] starts having a seizure!"), 1)
		owner.Paralyse(10)
		owner.make_jittery(1000)

/datum/component/epilepsy_disability/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_HANDLE_DISABILITIES)
	owner = null
	. = ..()
