/datum/artifact_effect/gasnitro
	name = "N2 creation"

	effect_color = "#c2d3d8"

/datum/artifact_effect/gasnitro/Initialize()
	. = ..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

/datum/artifact_effect/gasnitro/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("nitrogen", rand(2, 15))

/datum/artifact_effect/gasnitro/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("nitrogen", pick(0, 0, 0.1, rand()))
