/datum/component/burninlight
	var/mob/living/owner
	// This is a merge of the old shadow species light burning life code, and Zaddat's handle_environment_special() proc.
	// It handles both cases, but shadows behave more like Zaddat do now. By default this code follows Zaddat damage with no healing.
	var/threshold = 0.2 // percent from 0 to 1
	// Damage or healing per life tick
	var/damage_rate = 1.25
	var/heal_rate = 0

/datum/component/burninlight/shadow
	threshold = 0.15
	damage_rate = 1
	heal_rate = 1

/datum/component/burninlight/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(process_component))

/datum/component/burninlight/proc/process_component()
	if(QDELETED(parent))
		return
	if(owner.stat == DEAD)
		return
	if(!isturf(owner.loc))
		return
	if(owner.inStasisNow())
		return

	var/light_amount = 0 //how much light there is in the place, affects damage
	if(isturf(owner.loc)) //else, there's considered to be no light
		var/turf/T = owner.loc
		light_amount = T.get_lumcount(0,1)

	// Apply damage if beyond the minimum light threshold, actually makes zaddat SLIGHTLY more forgiving!
	if(light_amount > 0 && light_amount > threshold) // Checks light_amount, as threshold of 0 can pass 0s to the damage procs otherwise.
		if(damage_rate > 0)
			if(ishuman(owner))
				var/mob/living/carbon/human/H = owner
				var/damageable = H.get_damageable_organs()
				var/covered = H.get_coverage()
				for(var/K in damageable)
					if(!(K in covered))
						H.apply_damage(light_amount * damage_rate, BURN, K, 0, 0)
			else
				owner.take_overall_damage(light_amount * damage_rate,light_amount * damage_rate)

	// heal in the dark, if possible
	else if(heal_rate > 0)
		owner.heal_overall_damage(heal_rate,heal_rate)

/datum/component/burninlight/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	owner = null
	. = ..()
