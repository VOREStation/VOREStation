/datum/reagent/adranol
	name = "Adranol"
	id = "adranol"
	description = "A mild sedative that calms the nerves and relaxes the patient."
	taste_description = "milk"
	reagent_state = SOLID
	color = "#d5e2e5"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/adranol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.confused)
		M.Confuse(-8*removed)
	if(M.eye_blurry)
		M.eye_blurry = max(M.eye_blurry - 8*removed, 0)
	if(M.jitteriness)
		M.make_jittery(max(M.jitteriness - 8*removed,0))

/datum/reagent/numbing_enzyme
	name = "Numbing Enzyme"
	id = "numbenzyme"
	description = "Some sort of organic painkiller."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#800080"
	metabolism = 0.1 //Lasts up to 200 seconds if you give 20u which is OD.
	mrate_static = TRUE
	overdose = 20 //High OD. This is to make numbing bites have somewhat of a downside if you get bit too much. Have to go to medical for dialysis.
	scannable = 0 //Let's not have medical mechs able to make an extremely strong organic painkiller

/datum/reagent/numbing_enzyme/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 200)
	if(prob(1))
		to_chat(H,"<span class='warning'>Your body feels numb, a light, tingly sensation spreading throughout it.</span>")

/datum/reagent/numbing_enzyme/overdose(var/mob/living/carbon/M, var/alien)
	//..() //Add this if you want it to do toxin damage. Personally, let's allow them to have the horrid effects below without toxin damage.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(1)
			to_chat(H,"<span class='warning'>Your entire body feels numb and the sensation of pins and needles continually assaults you. You blink and the next thing you know, your legs give out momentarily!</span>") 
			H.AdjustWeakened(5) //Fall onto the floor for a few moments.
			H.Confuse(15) //Be unable to walk for a bit longer.
		if(prob(1)
			if(H.losebreath <= 1 && H.oxyloss <= 20) //Let's not suffocate them to the point that they pass out.
				to_chat(H,"<span class='warning'>You feel a sharp stabbing pain in your chest and quickly realize that your lungs have stopped functioning!</span>") //Let's scare them a bit. 
				H.losebreath = 10
				H.adjustOxyLoss(5)
		if(prob(2)
			to_chat(H,"<span class='warning'>You feel a dull pain behind your eyes and at thee back of your head...</span>") 
			H.hallucination += 20 //It messes with your mind for some reason.
			H.eye_blurry += 20 //Groggy vision for a small bit.
		if(prob(3))
			to_chat(H,"<span class='warning'>You shiver, your body continually being assaulted by the sensation of pens and needles.</span>")
			H.emote("shiver")
			H.make_jittery(10)
		if(prob(3))
			to_chat(H,"<span class='warning'>Your tongue feels numb and unresponsive.</span>")
			H.stuttering += 20
