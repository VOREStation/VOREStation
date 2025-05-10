/datum/component/gibbing_disability
	var/mob/living/owner
	var/gutdeathpressure = 0
	var/death_time = FALSE
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/gibbing_disability/Initialize()
	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	RegisterSignal(owner, COMSIG_HANDLE_DISABILITIES, PROC_REF(process_component))

/datum/component/gibbing_disability/proc/process_component()
	if(QDELETED(parent))
		return
	if(isbelly(owner.loc))
		return
	if(owner.transforming)
		return
	if(death_time)
		if(death_time < 4)
			owner.emote(pick("whimper","belch","shiver"))
			death_time++
			return
		else
			owner.emote(pick("belch"))
			owner.gib()
			return
	gutdeathpressure += 0.01
	if(gutdeathpressure > 0 && prob(gutdeathpressure))
		owner.emote(pick("whimper","belch","belch","belch","choke","shiver"))
		owner.Weaken(gutdeathpressure / 3)
	if((gutdeathpressure/3) >= 1 && prob(gutdeathpressure/3))
		death_time = TRUE

/datum/component/gibbing_disability/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_HANDLE_DISABILITIES)
	owner = null
	. = ..()
