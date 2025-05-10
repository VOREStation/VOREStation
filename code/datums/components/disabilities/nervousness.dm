/datum/component/nervousness_disability
	var/mob/owner
	var/gutdeathpressure = 0

/datum/component/nervousness_disability/Initialize()
	if (!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	RegisterSignal(owner, COMSIG_HANDLE_DISABILITIES, PROC_REF(process_component))

/datum/component/nervousness_disability/proc/process_component()
	if(QDELETED(parent))
		return
	if(isbelly(owner.loc))
		return
	if(owner.stat != CONSCIOUS)
		return
	if(owner.transforming)
		return
	if(prob(5) && prob(7))
		owner.stuttering = max(15, owner.stuttering)
		if(owner.jitteriness < 50)
			owner.make_jittery(65)

/datum/component/nervousness_disability/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_HANDLE_DISABILITIES)
	owner = null
	. = ..()
