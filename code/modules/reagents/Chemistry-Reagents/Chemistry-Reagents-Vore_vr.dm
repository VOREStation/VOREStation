
////////////////////////////
/// NW's shrinking serum ///
////////////////////////////

/datum/reagent/macrocillin
	name = "Macrocillin"
	id = "macrocillin"
	description = "Glowing yellow liquid."
	reagent_state = LIQUID
	color = "#FFFF00" // rgb: 255, 255, 0
	metabolism = 2.5

/datum/reagent/macrocillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	for(var/size in list(RESIZE_SMALL, RESIZE_NORMAL, RESIZE_BIG, RESIZE_HUGE))
		if(M.size_multiplier < size)
			M.resize(size)
			M << "<font color='green'>You grow!</font>"
			break
	return

/datum/reagent/microcillin
	name = "Microcillin"
	id = "microcillin"
	description = "Murky purple liquid."
	reagent_state = LIQUID
	color = "#800080"
	metabolism = 2.5

/datum/reagent/microcillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	for(var/size in list(RESIZE_BIG, RESIZE_NORMAL, RESIZE_SMALL, RESIZE_TINY))
		if(M.size_multiplier > size)
			M.resize(size)
			M << "<span class='alert'>You shrink!</span>"
			break;
	return


/datum/reagent/normalcillin
	name = "Normalcillin"
	id = "normalcillin"
	description = "Translucent cyan liquid."
	reagent_state = LIQUID
	color = "#00FFFF"
	metabolism = 2.5

/datum/reagent/normalcillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(M.size_multiplier > RESIZE_BIG)
		M.resize(RESIZE_BIG)
		M << "<span class='alert'>You shrink!</span>"
	else if(M.size_multiplier > RESIZE_NORMAL)
		M.resize(RESIZE_NORMAL)
		M << "<span class='alert'>You shrink!</span>"
	else if(M.size_multiplier < RESIZE_NORMAL)
		M.resize(RESIZE_NORMAL)
		M << "<font color='green'>You grow!</font>"
	else if(M.size_multiplier < RESIZE_SMALL)
		M.resize(RESIZE_SMALL)
		M << "<font color='green'>You grow!</font>"
	return


/datum/reagent/sizeoxadone
	name = "Sizeoxadone"
	id = "sizeoxadone"
	description = "A volatile liquid used as a precursor to size-altering chemicals. Causes dizziness if taken unprocessed."
	reagent_state = LIQUID
	color = "#1E90FF"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/sizeoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
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
	..()
	M.make_dizzy(1)
	M.adjustHalLoss(2)

	for(var/I in M.vore_organs)
		var/datum/belly/B = M.vore_organs[I]
		for(var/atom/movable/A in B.internal_contents)
			if(isliving(A))
				var/mob/living/P = A
				if(P.absorbed)
					continue
			if(prob(5))
				playsound(M, 'sound/effects/splat.ogg', 50, 1)
				B.release_specific_contents(A)
	return


/datum/reagent/unsorbitol
	name = "Unsorbitol"
	id = "unsorbitol"
	description = "A frothy pink liquid, for causing cellular-level hetrogenous structure separation."
	reagent_state = LIQUID
	color = "#EF77E5"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/unsorbitol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.make_dizzy(1)
	M.adjustHalLoss(1)
	if(!M.confused) M.confused = 1
	M.confused = max(M.confused, 20)
	M.hallucination += 15

	for(var/I in M.vore_organs)
		var/datum/belly/B = M.vore_organs[I]

		if(B.digest_mode == DM_ABSORB) //Turn off absorbing on bellies
			B.digest_mode = DM_HOLD

		for(var/mob/living/P in B.internal_contents)
			if(!P.absorbed)
				continue

			else if(prob(1))
				playsound(M, 'sound/vore/schlorp.ogg', 50, 1)
				P.absorbed = 0
				M.visible_message("<font color='green'><b>Something spills into [M]'s [lowertext(B.name)]!</b></font>")
	return
