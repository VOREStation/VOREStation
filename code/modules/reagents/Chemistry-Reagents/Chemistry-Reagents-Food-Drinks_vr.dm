/datum/reagent/nutriment
	nutriment_factor = 10

/datum/reagent/toxin/meatcolony
	name = "A colony of meat cells"
	id = "meatcolony"
	description = "Specialised cells designed to produce a large amount of meat once activated, whilst manufacturers have managed to stop these cells from taking over the body when ingested, it's still poisonous."
	taste_description = "a fibrous mess"
	reagent_state = LIQUID
	color = "#ff2424"
	strength = 10

/datum/reagent/toxin/plantcolony
	name = "A colony of plant cells"
	id = "plantcolony"
	description = "Specialised cells designed to produce a large amount of nutriment once activated, whilst manufacturers have managed to stop these cells from taking over the body when ingested, it's still poisonous."
	taste_description = "a fibrous mess"
	reagent_state = LIQUID
	color = "#7ce01f"
	strength = 10

/datum/reagent/nutriment/grubshake
	name = "Grub shake"
	id = "grubshake"
	description = "An odd fluid made from grub guts, supposedly filling."
	taste_description = "sparkles"
	taste_mult = 1.3
	nutriment_factor = 5
	color = "#fff200"

/datum/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition = max(M.nutrition - 20 * removed, 0)
	M.overeatduration = 0
	if(M.nutrition < 0)
		M.nutrition = 0

/datum/reagent/ethanol/deathbell
	name = "Deathbell"
	id = "deathbell"
	description = "A successful experiment to make the most alcoholic thing possible."
	taste_description = "your brains smashed out by a smooth brick of hard, ice cold alcohol"
	color = "#9f6aff"
	taste_mult = 5
	strength = 10
	adj_temp = 10
	targ_temp = 330

	glass_name = "Deathbell"
	glass_desc = "The perfect blend of the most alcoholic things a bartender can get their hands on."

/datum/reagent/ethanol/deathbell/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(dose * strength >= strength) // Early warning
		M.make_dizzy(24) // Intentionally higher than normal to compensate for it's previous effects.
	if(dose * strength >= strength * 2.5) // Slurring takes longer. Again, intentional.
		M.slurring = max(M.slurring, 30)

/datum/reagent/ethanol/monstertamer
	name = "Monster Tamer"
	id = "monstertamer"
	description = "A questionably-delicious blend of a carnivore's favorite food and a potent neural depressant."
	taste_description = "the gross yet satisfying combination of chewing on a raw steak while downing a shot of whiskey"
	strength = 50
	color = "#d3785d"
	metabolism = REM * 2.5 // about right for mixing nutriment and ethanol.
	var/alt_nutriment_factor = 5 //half as much as protein since it's half protein.
	//using a new variable instead of nutriment_factor so we can call ..() without that adding nutrition for us without taking factors for protein into account

	glass_name = "Monster Tamer"
	glass_desc = "This looks like a vaguely-alcoholic slurry of meat. Gross."

/datum/reagent/ethanol/monstertamer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(M.species.gets_food_nutrition) //it's still food!
		switch(alien)
			if(IS_DIONA) //Diona don't get any nutrition from nutriment or protein.
			if(IS_SKRELL)
				M.adjustToxLoss(0.25 * removed)  //Equivalent to half as much protein, since it's half protein.
			if(IS_TESHARI)
				M.nutrition += (alt_nutriment_factor * 1.2 * removed) //Give them the same nutrition they would get from protein.
			if(IS_UNATHI)
				M.nutrition += (alt_nutriment_factor * 1.125 * removed) //Give them the same nutrition they would get from protein.
				//Takes into account the 0.5 factor for all nutriment which is applied on top of the 2.25 factor for protein.
			//Chimera don't need their own case here since their factors for nutriment and protein cancel out.
			else
				M.nutrition += (alt_nutriment_factor * removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.feral > 0 && H.nutrition > 100 && H.traumatic_shock < min(60, H.nutrition/10) && H.jitteriness < 100) // same check as feral triggers to stop them immediately re-feralling
			H.feral -= removed * 3 // should calm them down quick, provided they're actually in a state to STAY calm.
			if (H.feral <=0) //check if they're unferalled
				H.feral = 0
				to_chat(H, "<span class='info'>Your mind starts to clear, soothed into a state of clarity as your senses return.</span>")
				log_and_message_admins("is no longer feral.", H)

/datum/reagent/ethanol/monstertamer/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SKRELL)
		M.adjustToxLoss(removed)  //Equivalent to half as much protein, since it's half protein.
	if(M.species.gets_food_nutrition)
		if(alien == IS_SLIME || alien == IS_CHIMERA) //slimes and chimera can get nutrition from injected nutriment and protein
			M.nutrition += (alt_nutriment_factor * removed)



/datum/reagent/nutriment/magicdust/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	playsound(M.loc, 'sound/items/hooh.ogg', 50, 1, -1)
	if(prob(5))
		to_chat(M, "<span class='warning'>You feel like you've been gnomed...</span>")