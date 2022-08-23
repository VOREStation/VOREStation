<<<<<<< HEAD

/datum/artifact_effect/gravity_wave
=======
/datum/artifact_effect/extreme/gravity_wave
>>>>>>> d7f2f2b100a... Merge pull request #8626 from Atermonera/singunomaly
	name = "gravity wave"
	effect_type = EFFECT_ENERGY

	var/last_wave_pull = 0
	var/pull_power

	effect_state = "gravisphere"
	effect_color = "#d8c3ff"

<<<<<<< HEAD
/datum/artifact_effect/gravity_wave/DoEffectTouch(var/mob/user)
	gravwave(user, effectrange, STAGE_TWO)

/datum/artifact_effect/gravity_wave/DoEffectAura()
=======
/datum/artifact_effect/extreme/gravity_wave/New()
	..()
	effect_type = pick(EFFECT_ENERGY, EFFECT_BLUESPACE, EFFECT_PSIONIC)
	switch(pick(100;1, 50;2, 25;3))
		if(1) //short range
			effectrange = rand(2, 4)
		if(2) //medium range
			effectrange = rand(5, 9)
		if(3) //large range
			effectrange = rand(9, 14)
	pull_power = rand(STAGE_ONE, STAGE_FOUR)

/datum/artifact_effect/extreme/gravity_wave/DoEffectTouch(var/mob/user)
	gravwave(user, effectrange, pull_power)

/datum/artifact_effect/extreme/gravity_wave/DoEffectAura()
>>>>>>> d7f2f2b100a... Merge pull request #8626 from Atermonera/singunomaly
	var/atom/holder = get_master_holder()
	var/seconds_since_last_pull = max(0, round((last_wave_pull - world.time) / 10))

	if(prob(10 + seconds_since_last_pull))
		holder.visible_message("<span class='alien'>\The [holder] distorts as local gravity intensifies, and shifts toward it.</span>")
		last_wave_pull = world.time
		gravwave(get_turf(holder), effectrange, pull_power)

<<<<<<< HEAD
/datum/artifact_effect/gravity_wave/DoEffectPulse()
=======
/datum/artifact_effect/extreme/gravity_wave/DoEffectPulse()
>>>>>>> d7f2f2b100a... Merge pull request #8626 from Atermonera/singunomaly
	var/atom/holder = get_master_holder()
	holder.visible_message("<span class='alien'>\The [holder] distorts as local gravity intensifies, and shifts toward it.</span>")
	gravwave(get_turf(holder), effectrange, pull_power)

/datum/artifact_effect/extreme/gravity_wave/proc/gravwave(var/atom/target, var/pull_range = 7, var/pull_power = STAGE_TWO)
	for(var/atom/A in oview(pull_range, target))
		A.singularity_pull(target, pull_power)
