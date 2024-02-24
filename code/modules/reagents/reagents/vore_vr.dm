
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
	M.resize(M.size_multiplier+0.01, uncapped = M.has_large_resize_bounds()) //Incrrease 1% per tick.
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
	M.resize(M.size_multiplier-0.01, uncapped = M.has_large_resize_bounds()) //Decrease 1% per tick.
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

	for(var/obj/belly/B as anything in M.vore_organs)
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

	for(var/obj/belly/B as anything in M.vore_organs)

		if(B.digest_mode == DM_ABSORB) //Turn off absorbing on bellies
			B.digest_mode = DM_HOLD

		for(var/mob/living/P in B)
			if(!P.absorbed)
				continue

			else if(prob(1))
				playsound(M, 'sound/vore/schlorp.ogg', 50, 1)
				P.absorbed = 0
				M.visible_message(span_green("<b>Something spills into [M]'s [lowertext(B.name)]!</b>"))

////////////////////////// TF Drugs //////////////////////////

/datum/reagent/amorphorovir
	name = "Amorphorovir"
	id = "amorphorovir"
	description = "A base medical concoction, capable of rapidly altering genetic and physical structure of the body. Requires extra processing to allow for a targeted transformation."
	reagent_state = LIQUID
	color = "#AAAAAA"

/datum/reagent/androrovir
	name = "Androrovir"
	id = "androrovir"
	description = "A medical concoction, capable of rapidly altering genetic and physical structure of the body. This one seems to realign the target's gender to be male."
	reagent_state = LIQUID
	color = "#00BBFF"

/datum/reagent/androrovir/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!(M.allow_spontaneous_tf))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(M.reagents.has_reagent("gynorovir") || M.reagents.has_reagent("androgynorovir"))
			H.Confuse(1)
		else
			if(!(H.gender == MALE))
				H.set_gender(MALE)
				H.change_gender_identity(MALE)
				H.visible_message("<span class='notice'>[H] suddenly twitches as some of their features seem to contort and reshape, adjusting... In the end, it seems they are now male.</span>",
								"<span class='warning'>Your body suddenly contorts, feeling very different in various ways... By the time the rushing feeling is over it seems you just became male.</span>")

/datum/reagent/gynorovir
	name = "Gynorovir"
	id = "gynorovir"
	description = "A medical concoction, capable of rapidly altering genetic and physical structure of the body. This one seems to realign the target's gender to be female."
	reagent_state = LIQUID
	color = "#FF00AA"

/datum/reagent/gynorovir/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!(M.allow_spontaneous_tf))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(M.reagents.has_reagent("androrovir") || M.reagents.has_reagent("androgynorovir"))
			H.Confuse(1)
		else
			if(!(H.gender == FEMALE))
				H.set_gender(FEMALE)
				H.change_gender_identity(FEMALE)
				H.visible_message("<span class='notice'>[H] suddenly twitches as some of their features seem to contort and reshape, adjusting... In the end, it seems they are now female.</span>",
								"<span class='warning'>Your body suddenly contorts, feeling very different in various ways... By the time the rushing feeling is over it seems you just became female.</span>")

/datum/reagent/androgynorovir
	name = "Androgynorovir"
	id = "androgynorovir"
	description = "A medical concoction, capable of rapidly altering genetic and physical structure of the body. This one seems to realign the target's gender to be mixed."
	reagent_state = LIQUID
	color = "#6600FF"

/datum/reagent/androgynorovir/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!(M.allow_spontaneous_tf))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(M.reagents.has_reagent("gynorovir") || M.reagents.has_reagent("androrovir"))
			H.Confuse(1)
		else
			if(!(H.gender == PLURAL))
				H.set_gender(PLURAL)
				H.change_gender_identity(PLURAL)
				H.visible_message("<span class='notice'>[H] suddenly twitches as some of their features seem to contort and reshape, adjusting... In the end, it seems they are now of mixed gender.</span>",
								"<span class='warning'>Your body suddenly contorts, feeling very different in various ways... By the time the rushing feeling is over it seems you just became of mixed gender.</span>")
