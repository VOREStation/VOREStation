
////////////////////////////
/// NW's shrinking serum ///
////////////////////////////

/datum/reagent/macrocillin
	name = "Macrocillin"
	id = "macrocillin"
	description = "Glowing yellow liquid."
	reagent_state = LIQUID
	color = "#FFFF00" // rgb: 255, 255, 0
	metabolism = 0.01
	mrate_static = TRUE

/datum/reagent/macrocillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.size_multiplier < RESIZE_HUGE)
		M.resize(M.size_multiplier+0.01)//Incrrease 1% per tick.
	return

/datum/reagent/microcillin
	name = "Microcillin"
	id = "microcillin"
	description = "Murky purple liquid."
	reagent_state = LIQUID
	color = "#800080"
	metabolism = 0.01
	mrate_static = TRUE

/datum/reagent/microcillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.size_multiplier > RESIZE_TINY)
		M.resize(M.size_multiplier-0.01) //Decrease 1% per tick.
	return


/datum/reagent/normalcillin
	name = "Normalcillin"
	id = "normalcillin"
	description = "Translucent cyan liquid."
	reagent_state = LIQUID
	color = "#00FFFF"
	metabolism = 0.01 //One unit will be just enough to bring someone from 200% to 100%
	mrate_static = TRUE

/datum/reagent/normalcillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.size_multiplier > RESIZE_NORMAL)
		M.resize(M.size_multiplier-0.01) //Decrease by 1% size per tick.
	else if(M.size_multiplier < RESIZE_NORMAL)
		M.resize(M.size_multiplier+0.01) //Increase 1% per tick.
	return


/datum/reagent/sizeoxadone
	name = "Sizeoxadone"
	id = "sizeoxadone"
	description = "A volatile liquid used as a precursor to size-altering chemicals. Causes dizziness if taken unprocessed."
	reagent_state = LIQUID
	color = "#1E90FF"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/sizeoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.make_dizzy(1)
	if(!M.confused) M.confused = 1
	M.confused = max(M.confused, 20)
	return


////////////////////////// Anti-Noms Drugs //////////////////////////

/datum/reagent/ickypak
	name = "Ickypak"
	id = "ickypak"
	description = "A foul-smelling green liquid, for inducing muscle contractions to expel accidentally ingested things."
	reagent_state = LIQUID
	color = "#0E900E"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ickypak/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.make_dizzy(1)
	M.adjustHalLoss(2)

	for(var/belly in M.vore_organs)
		var/obj/belly/B = belly
		for(var/atom/movable/A in B)
			if(isliving(A))
				var/mob/living/P = A
				if(P.absorbed)
					continue
			if(prob(5))
				playsound(M, 'sound/effects/splat.ogg', 50, 1)
				B.release_specific_contents(A)

/datum/reagent/unsorbitol
	name = "Unsorbitol"
	id = "unsorbitol"
	description = "A frothy pink liquid, for causing cellular-level hetrogenous structure separation."
	reagent_state = LIQUID
	color = "#EF77E5"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/unsorbitol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.make_dizzy(1)
	M.adjustHalLoss(1)
	if(!M.confused) M.confused = 1
	M.confused = max(M.confused, 20)
	M.hallucination += 15

	for(var/belly in M.vore_organs)
		var/obj/belly/B = belly

		if(B.digest_mode == DM_ABSORB) //Turn off absorbing on bellies
			B.digest_mode = DM_HOLD

		for(var/mob/living/P in B)
			if(!P.absorbed)
				continue

			else if(prob(1))
				playsound(M, 'sound/vore/schlorp.ogg', 50, 1)
				P.absorbed = 0
				M.visible_message("<font color='green'><b>Something spills into [M]'s [lowertext(B.name)]!</b></font>")

//Special toxins for solargrubs

/datum/reagent/grubshock
	name = "200 V" //in other words a painful shock
	id = "shockchem"
	description = "A liquid that quickly dissapates to deliver a painful shock."
	reagent_state = LIQUID
	color = "#E4EC2F"
	metabolism = 2.50
	var/power = 9

/datum/reagent/grubshock/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * power * 0.2)
