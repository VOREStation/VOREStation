//Dionaea regenerate health and nutrition in light.
/mob/living/carbon/diona_nymph/handle_environment(datum/gas_mixture/environment)

	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(loc)) //else, there's considered to be no light
		var/turf/T = loc
		light_amount = T.get_lumcount() * 5

	adjust_nutrition(light_amount)

	if(light_amount > 2) //if there's enough light, heal
		adjustBruteLoss(-1)
		adjustFireLoss(-1)
		adjustToxLoss(-1)
		adjustOxyLoss(-1)


 	if(!client)
 		handle_npc(src)

/mob/living/carbon/diona_nymph/handle_mutations_and_radiation()
	if(!radiation)
		return

	var/rads = radiation/25
	radiation -= rads
	adjust_nutrition(rads)
	heal_overall_damage(rads,rads)
	adjustOxyLoss(-(rads))
	adjustToxLoss(-(rads))
	return

/mob/living/carbon/diona_nymph/Life()
	..()
	if (stat != DEAD) //still breathing
		// GROW!
		update_progression()