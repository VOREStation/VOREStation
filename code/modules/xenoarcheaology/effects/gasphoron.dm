/datum/artifact_effect/gasphoron
	name = "phoron creation"

	effect_color = "#c408ba"

/datum/artifact_effect/gasphoron/Initialize()
	. = ..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

/datum/artifact_effect/gasphoron/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("phoron", rand(2, 15))

/datum/artifact_effect/gasphoron/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("phoron", pick(0, 0, 0.1, rand()))
