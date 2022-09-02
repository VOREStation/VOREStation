<<<<<<< HEAD

/datum/artifact_effect/electric_field
=======
/datum/artifact_effect/uncommon/electric_field
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	name = "electric field"
	effect_type = EFFECT_ENERGY
	effect_color = "#ffff00"

<<<<<<< HEAD
/datum/artifact_effect/electric_field/DoEffectTouch(var/mob/user)
=======

/datum/artifact_effect/uncommon/electric_field/DoEffectTouch(mob/living/user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	var/list/nearby_mobs = list()
	for (var/mob/living/L in oview(effectrange, get_turf(holder)))
		if (L == user)	// You're "grounded" when you contact the artifact.
			continue
		if (!L.stat)
			nearby_mobs |= L
	for (var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()
	for (var/mob/living/L in nearby_mobs)
		if (L.isSynthetic())
			to_chat(L, "<span class='danger'>ERROR: Electrical fault detected!</span>")
			L.stuttering += 3
		if (ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(rand(25, 40), holder, H.get_siemens_coefficient_organ(affected), affected)
		else
			L.electrocute_act(rand(25, 40), holder, 0.75, BP_TORSO)

<<<<<<< HEAD
/datum/artifact_effect/electric_field/DoEffectAura()
=======

/datum/artifact_effect/uncommon/electric_field/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	var/list/nearby_mobs = list()
	for (var/mob/living/L in oview(effectrange, get_turf(holder)))
		if (!L.stat)
			nearby_mobs |= L
	for (var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()
	for (var/mob/living/L in nearby_mobs)
		if (L.isSynthetic())
			to_chat(L, "<span class='danger'>ERROR: Electrical fault detected!</span>")
			L.stuttering += 3
		if (ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(rand(1, 10), holder, H.get_siemens_coefficient_organ(affected), affected)
		else
			L.electrocute_act(rand(1, 10), holder, 0.75, BP_TORSO)

<<<<<<< HEAD
/datum/artifact_effect/electric_field/DoEffectPulse()
=======

/datum/artifact_effect/uncommon/electric_field/DoEffectPulse()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	var/list/nearby_mobs = list()
	for (var/mob/living/L in oview(effectrange, get_turf(holder)))
		if (!L.stat)
			nearby_mobs |= L
	for (var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()
	for (var/mob/living/L in nearby_mobs)
		if (L.isSynthetic())
			to_chat(L, "<span class='danger'>ERROR: Electrical fault detected!</span>")
			L.stuttering += 3
		if (ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(rand(10, 30), holder, H.get_siemens_coefficient_organ(affected), affected)
		else
			L.electrocute_act(rand(10, 30), holder, 0.75, BP_TORSO)
