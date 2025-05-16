// If a mob has this component, every life tick it will gain nutrition if it's standing in light up to nutrition_max.
// Extremely good tutorial component if you need an example with no special bells and whistles, and no "gotcha" behaviors.
/datum/component/burninlight
	var/mob/living/owner
	var/threshold = 0.2 // percent from 0 to 1
	// Damage or healing per life fick
	var/damage_rate = 1
	var/heal_rate = 1

/datum/component/burninlight/zaddat
	threshold = 0.1
	damage_rate = 1.25
	heal_rate = 0

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

	// This is a merge of the old shadow species light burning life code, and Zaddat's handle_environment_special() proc. It handles both cases, but shadows behave more like Zaddat do now.
	var/light_amount = 0 //how much light there is in the place, affects damage
	if(isturf(owner.loc)) //else, there's considered to be no light
		var/turf/T = owner.loc
		light_amount = T.get_lumcount(0,1)

	// Apply damage if beyond the minimum light threshold, actually makes zaddat SLIGHTLY more forgiving!
	if(light_amount > threshold)
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
