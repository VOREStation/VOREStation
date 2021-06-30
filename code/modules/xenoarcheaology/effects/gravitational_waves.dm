
/datum/artifact_effect/gravity_wave
	name = "gravity wave"
	effect_type = EFFECT_ENERGY

	var/last_wave_pull = 0

/datum/artifact_effect/gravity_wave/DoEffectTouch(var/mob/user)
	gravwave(user, effectrange, STAGE_TWO)

/datum/artifact_effect/gravity_wave/DoEffectAura()
	var/seconds_since_last_pull = max(0, round((last_wave_pull - world.time) / 10))

	if(prob(10 + seconds_since_last_pull))
		holder.visible_message("<span class='alien'>\The [holder] distorts as local gravity intensifies, and shifts toward it.</span>")
		last_wave_pull = world.time
		gravwave(get_turf(holder), effectrange, STAGE_TWO)

/datum/artifact_effect/gravity_wave/DoEffectPulse()
	holder.visible_message("<span class='alien'>\The [holder] distorts as local gravity intensifies, and shifts toward it.</span>")
	gravwave(get_turf(holder), effectrange, STAGE_TWO)

/proc/gravwave(var/atom/target, var/pull_range = 7, var/pull_power = STAGE_TWO)
	for(var/atom/A in oview(pull_range, target))
		A.singularity_pull(target, pull_power)
