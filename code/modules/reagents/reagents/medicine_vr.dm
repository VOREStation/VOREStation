/datum/reagent/adranol
	name = "Adranol"
	id = "adranol"
	description = "A mild sedative that calms the nerves and relaxes the patient."
	taste_description = "milk"
	reagent_state = LIQUID
	color = "#d5e2e5"
	scannable = 1

/datum/reagent/adranol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.confused)
		M.Confuse(-8*removed)
	if(M.eye_blurry)
		M.eye_blurry = max(M.eye_blurry - 25*removed, 0)
	if(M.jitteriness)
		M.make_jittery(max(M.jitteriness - 25*removed,0))

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
	if(prob(0.01)) //1 in 10000 chance per tick. Extremely rare.
		to_chat(M,"<span class='warning'>Your body feels numb as a light, tingly sensation spreads throughout it, like some odd warmth.</span>")
	//Not noted here, but a movement debuff of 1.5 is handed out in human_movement.dm when numbing_enzyme is in a person's bloodstream!

/datum/reagent/numbing_enzyme/overdose(var/mob/living/carbon/M, var/alien)
	//..() //Add this if you want it to do toxin damage. Personally, let's allow them to have the horrid effects below without toxin damage.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(1))
			to_chat(H,"<span class='warning'>Your entire body feels numb and the sensation of pins and needles continually assaults you. You blink and the next thing you know, your legs give out momentarily!</span>")
			H.AdjustWeakened(5) //Fall onto the floor for a few moments.
			H.Confuse(15) //Be unable to walk correctly for a bit longer.
		if(prob(1))
			if(H.losebreath <= 1 && H.oxyloss <= 20) //Let's not suffocate them to the point that they pass out.
				to_chat(H,"<span class='warning'>You feel a sharp stabbing pain in your chest and quickly realize that your lungs have stopped functioning!</span>") //Let's scare them a bit.
				H.losebreath = 10
				H.adjustOxyLoss(5)
		if(prob(2))
			to_chat(H,"<span class='warning'>You feel a dull pain behind your eyes and at thee back of your head...</span>")
			H.hallucination += 20 //It messes with your mind for some reason.
			H.eye_blurry += 20 //Groggy vision for a small bit.
		if(prob(3))
			to_chat(H,"<span class='warning'>You shiver, your body continually being assaulted by the sensation of pins and needles.</span>")
			H.emote("shiver")
			H.make_jittery(10)
		if(prob(3))
			to_chat(H,"<span class='warning'>Your tongue feels numb and unresponsive.</span>")
			H.stuttering += 20

/datum/reagent/vermicetol
	name = "Vermicetol"
	id = "vermicetol"
	description = "A potent chemical that treats physical damage at an exceptional rate."
	taste_description = "sparkles"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#750404"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/vermicetol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(8 * removed * chem_effective, 0)

/datum/reagent/sleevingcure
	name = "Kitsuhanan Cure"
	id = "sleevingcure"
	description = "A rare cure provided by KHI that helps counteract negative side effects of using imperfect resleeving machinery."
	taste_description = "chocolate peanut butter"
	taste_mult = 2
	reagent_state = LIQUID
	color = "#b4dcdc"
	overdose = 5
	scannable = 0

/datum/reagent/sleevingcure/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.remove_a_modifier_of_type(/datum/modifier/resleeving_sickness)
	M.remove_a_modifier_of_type(/datum/modifier/faux_resleeving_sickness)

/datum/reagent/epinephrine
	name = "Epinephrine" //Named because we already got an adrenaline reagent and I don't want to touch it.
	id = "epinephrine"
	description = "A natural drug produced by organics as part of Fight and Flight response. May cause injuries from over-exertion. Metabolises to metanephrine."
	taste_description = "bitterness"
	color = "#C8A5DC" //Same as the other adrenaline reagent
	mrate_static = TRUE
	overdose = REAGENTS_OVERDOSE * 2 //same as inaprovaline
	scannable = 1

/datum/reagent/epinephrine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.SetWeakened(0) //Countering early shock_stages' random knockdown
	M.add_chemical_effect(CE_PAINKILLER, 80) //Same as Tramadol
	M.reagents.add_reagent("metanephrine", removed * 2.5)
	M.add_chemical_effect(CE_SPEEDBOOST, 1)

/datum/reagent/epinephrine/overdose(var/mob/living/carbon/M, var/alien)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(15))
			to_chat(src, "<span class='danger'> You feel lightheaded from over-exertion!</span>")
			H.eye_blurry += 5  //A warning to get to safety, as the crash that will come from metaneprhine WILL hurt.




/datum/reagent/metanephrine
	name = "Metanephrine"
	id = "metanephrine"
	description = "Natural metabolite of epinephrine. Acts as a weak painkiller in low doses. Accompanies severe side effects when found in large amounts in the bloodstream."
	taste_description = "bitterness"
	color = "#C8A5DC" //Same as the other adrenaline reagent
	mrate_static = TRUE
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/metanephrine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 10) //Same as Inaprovaline
	if(volume < 2)
		M.metanephrine_overexerted = FALSE //we can tear muscles again, yay!
		M.metanephrine_lasteffect = world.time



/datum/reagent/metanephrine/overdose(var/mob/living/carbon/M, var/alien) //technically it's not an overdose, but rather indicative of over-exerted state
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/last_effect = M.metanephrine_lasteffect
		var/exerted = M.metanephrine_overexerted
		if(prob(25) && world.time > last_effect + 60)
			to_chat(H,"<span class='warning'>Your legs give out from over-exertion!</span>")
			H.AdjustWeakened(20)
			H.Confuse(15)
			last_effect = world.time
		if(prob(5) && !exerted)
			H.take_organ_damage(10, 0)
			to_chat(H,"<span class='warning'>It feels like you pulled a muscle!</span>")
			last_effect = world.time
			M.metanephrine_overexerted = TRUE
		if(prob(10) && world.time > last_effect + 60)
			to_chat(H,"<span class='warning'>You feel butterflies in your stomach</span>")
			H.vomit(1)
			last_effect = world.time
		if(prob(50) && world.time > last_effect + 60)
			to_chat(H,"<span class='warning'>You feel lightheaded!</span>")
			H.eye_blurry += 20
			M.make_dizzy(5)
			last_effect = world.time
		if(prob(10) && worldtime > last_effect + 60)
			to_chat(H,"<span_class='warning'>Your hands shake uncontrollably!</span>")
			M.make_jittery(10)
		M.metanephrine_lasteffect = last_effect




