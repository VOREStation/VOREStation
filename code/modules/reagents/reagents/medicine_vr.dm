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
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/epinephrine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_CHIMERA || alien == IS_DIONA) return
	switch(volume)
		if(4 to 15)
			M.add_chemical_effect(CE_PAINKILLER, 25) //paracetamol level painkiller. Prevents pain slowdown while in effect. Almost counters broken bone
		if(16 to 30)
			M.add_chemical_effect(CE_PAINKILLER, 50) //Twice the strength of paracetamol. Counters pain from broken bone and some more
			if(M.exertionLevel < 15)
				M.add_chemical_effect(CE_SPEEDBOOST, 1) //Counters slowdown from broken bone. Only works if we aren't already exhausted
		if(31 to INFINITY) //we're overdosed at this point
			M.SetWeakened(0) //
			M.add_chemical_effect(CE_PAINKILLER, 80) //Tramadol strength painkiller
			if(M.exertionLevel < 30)
				M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.reagents.add_reagent("metanephrine", removed * 1) //Add 0.2 metanephrine.

/datum/reagent/epinephrine/overdose(var/mob/living/carbon/M, var/alien)
	if(alien != IS_CHIMERA && alien != IS_DIONA && ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(10))
			to_chat(src, "<span class='warning'> You feel lightheaded from over-exertion!</span>")
			H.eye_blurry += 1
			M.make_jittery(10)
		M.reagents.add_reagent("metanephrine", 0.2) //Double metanephrine build up while in OD!




/datum/reagent/metanephrine
	name = "Metanephrine"
	id = "metanephrine"
	description = "Natural metabolite of epinephrine. Acts as a weak painkiller in low doses. Accompanies severe side effects when found in large amounts in the bloodstream."
	taste_description = "bitterness"
	color = "#C8A5DC" //Same as the other adrenaline reagent
	mrate_static = TRUE
	metabolism = REM * 0.5 //Slow metabolism. Sit down to clear it faster! 0.1 per tick.
	overdose = REAGENTS_OVERDOSE * 0.5 //tiered overdose, weak effects starting at 15
	scannable = 1

/datum/reagent/metanephrine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 10) //weak painkiller
	if(volume < 2)
		M.metanephrine_overexerted = FALSE //we can tear muscles again, yay!
	if(volume < 15)
		if(M.has_modifier_of_type(/datum/modifier/adrenaline_unsteady))
			M.remove_a_modifier_of_type(/datum/modifier/adrenaline_unsteady)
		if(M.has_modifier_of_type(/datum/modifier/adrenaline_jittery))
			M.remove_a_modifier_of_type(/datum/modifier/adrenaline_jittery)





/datum/reagent/metanephrine/overdose(var/mob/living/carbon/M, var/alien) //technically it's not an overdose, but rather indicative of over-exerted state
	switch(volume)
		if(15 to 25)
			if(world.time > M.metanephrine_lasteffect + 200)
				to_chat(M, "<span class='warning'> You are starting to get winded. Better find somewhere safe to rest!</span>")
				if(M.has_modifier_of_type(/datum/modifier/adrenaline_jittery))
					M.remove_a_modifier_of_type(/datum/modifier/adrenaline_jittery)
				if(!M.has_modifier_of_type(/datum/modifier/adrenaline_unsteady))
					M.add_modifier(/datum/modifier/adrenaline_unsteady)
				M.metanephrine_lasteffect = world.time
		if(26 to 35)
			if(world.time > M.metanephrine_lasteffect + 200)
				to_chat(M, "<span class='warning'> It's becoming hard to keep a steady hand! You really need to rest a few moments.</span>")
				if(M.has_modifier_of_type(/datum/modifier/adrenaline_unsteady))
					M.remove_a_modifier_of_type(/datum/modifier/adrenaline_unsteady)
				if(!M.has_modifier_of_type(/datum/modifier/adrenaline_jittery))
					M.add_modifier(/datum/modifier/adrenaline_jittery)
				M.metanephrine_lasteffect = world.time
		if(36 to 60)
			if(world.time > M.metanephrine_lasteffect + 150)
				if(M.has_modifier_of_type(/datum/modifier/adrenaline_unsteady))
					M.remove_a_modifier_of_type(/datum/modifier/adrenaline_unsteady)
				if(!M.has_modifier_of_type(/datum/modifier/adrenaline_jittery))
					M.add_modifier(/datum/modifier/adrenaline_jittery)
				to_chat(M, "<span class='warning'> Sit down or even lie down! Keep pushing, and you may pull a muscle!</span>")
				var/exhaustion = rand(0,100)
				switch(exhaustion)
					if(0 to 30)
						to_chat(M, "<span class='warning'> You feel light headed!</span>")
						M.make_dizzy(10)
						M.eye_blurry += 10
					if(31 to 60)
						to_chat(M, "<span class='warning'> Your muscles burn from breathlessness!</span>")
						M.SetLosebreath(2) //For 2 ticks, be unable to catch their breath
						M.adjustOxyLoss(5)
					if(61 to 90)
						to_chat(M, "<span class='warning'> Controlling your muscles is becoming a challenge!</span>")
						M.Confuse(2)
					if(91 to 99)
						if(!M.metanephrine_overexerted)
							to_chat(M, "<span class='warning'> You dull sensation has you realize you pulled a muscle!</span>")
							M.take_organ_damage(5, 0)
					if(100)
						to_chat(M, "<span class='warning'> Nausea overtakes you!</span>")
						if(prob(25))
							M.vomit(1)
				M.metanephrine_lasteffect = world.time
		if(61 to INFINITY) //severe build up
			if(world.time > M.metanephrine_lasteffect + 100)
				if(M.has_modifier_of_type(/datum/modifier/adrenaline_unsteady))
					M.remove_a_modifier_of_type(/datum/modifier/adrenaline_unsteady)
				if(!M.has_modifier_of_type(/datum/modifier/adrenaline_jittery))
					M.add_modifier(/datum/modifier/adrenaline_jittery)
				to_chat(M, "<span class='warning'> Over-exertion is tearing your body apart! Find somewhere to sit or lie down, or suffer.</span>")
				var/exhaustion = rand(0,100)
				switch(exhaustion)
					if(0 to 30)
						to_chat(M, "<span class='warning'> Your muscles burn from breathlessness!</span>")
						M.SetLosebreath(8) //For 8 ticks, be unable to catch their breath
					if(31 to 70)
						to_chat(M, "<span class='warning'> Controlling your muscles is becoming a challenge!</span>")
						M.Confuse(10)
					if(71 to 90)
						if(!M.metanephrine_overexerted)
							to_chat(M, "<span class='warning'> You dull sensation has you realize you pulled multiple muscles!</span>")
							M.take_organ_damage(15, 0)
					if(91 to 95)
						to_chat(M, "<span class='warning'> Nausea overtakes you!</span>")
						M.vomit(1)
					if(96 to 100)
						to_chat(M, "<span class='warning'> Your give legs out!</span>")
						M.AdjustWeakened(5)
				M.metanephrine_lasteffect = world.time








