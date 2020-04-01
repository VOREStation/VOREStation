
/datum/artifact_effect/electric_field
	name = "electric field"
	effect_type = EFFECT_ENERGY

/datum/artifact_effect/electric_field/DoEffectTouch(var/mob/user)
	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		if(L == user)	// You're "grounded" when you contact the artifact.
			continue
		if(!L.stat)
			nearby_mobs |= L

	for(var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()

	for(var/mob/living/L in nearby_mobs)
		if(L.isSynthetic())
			to_chat(L, "<span class='danger'>ERROR: Electrical fault detected!</span>")
			L.stuttering += 3

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(rand(25, 40), holder, H.get_siemens_coefficient_organ(affected), affected)
		else
			L.electrocute_act(rand(25, 40), holder, 0.75, BP_TORSO)

/datum/artifact_effect/electric_field/DoEffectAura()
	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		if(!L.stat)
			nearby_mobs |= L

	for(var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()

	for(var/mob/living/L in nearby_mobs)
		if(L.isSynthetic())
			to_chat(L, "<span class='danger'>ERROR: Electrical fault detected!</span>")
			L.stuttering += 3

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(rand(1, 10), holder, H.get_siemens_coefficient_organ(affected), affected)
		else
			L.electrocute_act(rand(1, 10), holder, 0.75, BP_TORSO)

/datum/artifact_effect/electric_field/DoEffectPulse()
	var/list/nearby_mobs = list()
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		if(!L.stat)
			nearby_mobs |= L

	for(var/obj/machinery/light/light in range(effectrange, get_turf(holder)))
		light.flicker()

	for(var/mob/living/L in nearby_mobs)
		if(L.isSynthetic())
			to_chat(L, "<span class='danger'>ERROR: Electrical fault detected!</span>")
			L.stuttering += 3

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affected = H.get_organ(check_zone(BP_TORSO))
			H.electrocute_act(rand(10, 30), holder, H.get_siemens_coefficient_organ(affected), affected)
		else
			L.electrocute_act(rand(10, 30), holder, 0.75, BP_TORSO)
