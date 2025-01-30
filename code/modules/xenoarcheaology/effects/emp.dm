/// Verified to work with the Artifact Harvester
/datum/artifact_effect/emp
	name = "Electromagnetic Pulse"
	effect_type = EFFECT_EMP

	effect_state = "empdisable"

/datum/artifact_effect/emp/New()
	..()
	effect = EFFECT_PULSE

/datum/artifact_effect/emp/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		empulse(T, effectrange/4, effectrange/3, effectrange/2, effectrange)
		if(istype(holder, /obj/item/anobattery))
			var/obj/item/anobattery/battery = holder
			battery.stored_charge = max(0, battery.stored_charge-250) //You only get TWO uses of this. This is VERY strong.
		return 1
