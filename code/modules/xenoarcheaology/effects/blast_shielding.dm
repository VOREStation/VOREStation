/datum/artifact_effect/uncommon/blast_shielding
	name = "blast_shielding"
	effect_color = "#c09951"
	effect_type = EFFECT_ENERGY


/datum/artifact_effect/uncommon/blast_shielding/DoEffectTouch(mob/living/user)
	if (user && isliving(user))
		user.add_modifier(/datum/modifier/blastshield, 2 MINUTES)


/datum/artifact_effect/uncommon/blast_shielding/DoEffectAura()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			if (prob(10))
				L.add_modifier(/datum/modifier/blastshield, 10 SECONDS)


/datum/artifact_effect/uncommon/blast_shielding/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			L.add_modifier(/datum/modifier/blastshield, 30 SECONDS)
