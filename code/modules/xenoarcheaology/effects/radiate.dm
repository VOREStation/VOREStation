/// Modified to work with the Artifact Harvester
/datum/artifact_effect/radiate
	name = "Radiation"
	var/radiation_amount

	effect_color = "#007006"

/datum/artifact_effect/radiate/New()
	..()
	radiation_amount = rand(1, 10)
	effect_type = EFFECT_RADIATE

/datum/artifact_effect/radiate/DoEffectTouch(var/mob/living/user)
	if(user)
		user.apply_effect(radiation_amount * 5,IRRADIATE,0)
		user.updatehealth()
		return 1

/datum/artifact_effect/radiate/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(holder)
		radiation_pulse(
			holder,
			max_range = effectrange,
			threshold = RAD_LIGHT_INSULATION,
			chance = chargelevelmax * 0.5,
			minimum_exposure_time = URANIUM_RADIATION_MINIMUM_EXPOSURE_TIME,
			strength = chargelevelmax * 0.5
		)
		return 1

/datum/artifact_effect/radiate/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(holder)
		radiation_pulse(
			holder,
			max_range = effectrange,
			threshold = RAD_LIGHT_INSULATION,
			chance = chargelevelmax,
			strength = chargelevelmax * 2,
		)
		return 1
