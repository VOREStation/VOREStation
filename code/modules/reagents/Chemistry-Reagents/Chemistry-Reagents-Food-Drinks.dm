/* Food */

/datum/reagent/nutriment
	name = "Nutriment"
	id = "nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	reagent_state = SOLID
	metabolism = REM * 4
	ingest_met = REM * 4
	var/nutriment_factor = 30 // Per unit
	var/injectable = 0
	color = "#664330"

/datum/reagent/nutriment/mix_data(var/list/newdata, var/newamount)

	if(!islist(newdata) || !newdata.len)
		return

	//add the new taste data
	for(var/taste in newdata)
		if(taste in data)
			data[taste] += newdata[taste]
		else
			data[taste] = newdata[taste]

	//cull all tastes below 10% of total
	var/totalFlavor = 0
	for(var/taste in data)
		totalFlavor += data[taste]
	if(totalFlavor) //Let's not divide by zero for things w/o taste
		for(var/taste in data)
			if(data[taste]/totalFlavor < 0.1)
				data -= taste

/datum/reagent/nutriment/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!injectable && alien != IS_SLIME && alien != IS_CHIMERA) //VOREStation Edit
		M.adjustToxLoss(0.1 * removed)
		return
	affect_ingest(M, alien, removed)

/datum/reagent/nutriment/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
		if(IS_DIONA) return
		if(IS_UNATHI) removed *= 0.5
		if(IS_CHIMERA) removed *= 0.25 //VOREStation Edit
	if(issmall(M)) removed *= 2 // Small bodymass, more effect from lower volume.
	M.heal_organ_damage(0.5 * removed, 0)
	if(M.species.gets_food_nutrition) //VOREStation edit. If this is set to 0, they don't get nutrition from food.
		M.nutrition += nutriment_factor * removed // For hunger and fatness
	M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)

/datum/reagent/nutriment/glucose
	name = "Glucose"
	id = "glucose"
	taste_description = "sweetness"
	color = "#FFFFFF"

	injectable = 1

/datum/reagent/nutriment/protein // Bad for Skrell!
	name = "animal protein"
	id = "protein"
	taste_description = "some sort of meat"
	color = "#440000"

/datum/reagent/nutriment/protein/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
		if(IS_SKRELL)
			M.adjustToxLoss(0.5 * removed)
		if(IS_TESHARI)
			..(M, alien, removed*1.2) // Teshari get a bit more nutrition from meat.
		if(IS_UNATHI)
			..(M, alien, removed*2.25) //Unathi get most of their nutrition from meat.
		//VOREStation Edit Start
		if(IS_CHIMERA)
			..(M, alien, removed*4) //Xenochimera are obligate carnivores.
		//VOREStation Edit End
		else
			..()

/datum/reagent/nutriment/protein/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_SKRELL)
		M.adjustToxLoss(2 * removed)
		return
	..()

/datum/reagent/nutriment/protein/egg // Also bad for skrell.
	name = "egg yolk"
	id = "egg"
	taste_description = "egg"
	color = "#FFFFAA"

/datum/reagent/nutriment/protein/murk
	name = "murkfin protein"
	id = "murk_protein"
	taste_description = "mud"
	color = "#664330"

/datum/reagent/nutriment/honey
	name = "Honey"
	id = "honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 10
	color = "#FFFF00"

/datum/reagent/nutriment/honey/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(alien == IS_UNATHI)
		if(effective_dose < 2)
			if(effective_dose == metabolism * 2 || prob(5))
				M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.sleeping = max(M.sleeping, 20)
			M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/nutriment/mayo
	name = "mayonnaise"
	id = "mayo"
	description = "A thick, bitter sauce."
	taste_description = "unmistakably mayonnaise"
	nutriment_factor = 10
	color = "#FFFFFF"

/datum/reagent/nutriment/yeast
	name = "Yeast"
	id = "yeast"
	description = "For making bread rise!"
	taste_description = "yeast"
	nutriment_factor = 1
	color = "#D3AF70"

/datum/reagent/nutriment/flour
	name = "Flour"
	id = "flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	taste_description = "chalky wheat"
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"

/datum/reagent/nutriment/flour/touch_turf(var/turf/simulated/T)
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/flour(T)

/datum/reagent/nutriment/coffee
	name = "Coffee Powder"
	id = "coffeepowder"
	description = "A bitter powder made by grinding coffee beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#482000"

/datum/reagent/nutriment/tea
	name = "Tea Powder"
	id = "teapowder"
	description = "A dark, tart powder made from black tea leaves."
	taste_description = "tartness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#101000"

/datum/reagent/nutriment/coco
	name = "Coco Powder"
	id = "coco"
	description = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#302000"

/datum/reagent/nutriment/instantjuice
	name = "Juice Powder"
	id = "instantjuice"
	description = "Dehydrated, powdered juice of some kind."
	taste_mult = 1.3
	nutriment_factor = 1

/datum/reagent/nutriment/instantjuice/grape
	name = "Grape Juice Powder"
	id = "instantgrape"
	description = "Dehydrated, powdered grape juice."
	taste_description = "dry grapes"
	color = "#863333"

/datum/reagent/nutriment/instantjuice/orange
	name = "Orange Juice Powder"
	id = "instantorange"
	description = "Dehydrated, powdered orange juice."
	taste_description = "dry oranges"
	color = "#e78108"

/datum/reagent/nutriment/instantjuice/watermelon
	name = "Watermelon Juice Powder"
	id = "instantwatermelon"
	description = "Dehydrated, powdered watermelon juice."
	taste_description = "dry sweet watermelon"
	color = "#b83333"

/datum/reagent/nutriment/instantjuice/apple
	name = "Apple Juice Powder"
	id = "instantapple"
	description = "Dehydrated, powdered apple juice."
	taste_description = "dry sweet apples"
	color = "#c07c40"

/datum/reagent/nutriment/soysauce
	name = "Soysauce"
	id = "soysauce"
	description = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#792300"

/datum/reagent/nutriment/ketchup
	name = "Ketchup"
	id = "ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	taste_description = "ketchup"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#731008"

/datum/reagent/nutriment/rice
	name = "Rice"
	id = "rice"
	description = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"

/datum/reagent/nutriment/cherryjelly
	name = "Cherry Jelly"
	id = "cherryjelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#801E28"

/datum/reagent/nutriment/cornoil
	name = "Corn Oil"
	id = "cornoil"
	description = "An oil derived from various types of corn."
	taste_description = "slime"
	taste_mult = 0.1
	reagent_state = LIQUID
	nutriment_factor = 20
	color = "#302000"

/datum/reagent/nutriment/cornoil/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if(volume >= 3)
		T.wet_floor()

/datum/reagent/nutriment/peanutoil
	name = "Peanut Oil"
	id = "peanutoil"
	description = "An oil derived from various types of nuts."
	taste_description = "nuts"
	taste_mult = 0.3
	reagent_state = LIQUID
	nutriment_factor = 15
	color = "#4F3500"

/datum/reagent/nutriment/peanutoil/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if(volume >= 5)
		T.wet_floor()

/datum/reagent/nutriment/peanutbutter
	name = "Peanut Butter"
	id = "peanutbutter"
	description = "A butter derived from various types of nuts."
	taste_description = "peanuts"
	taste_mult = 0.5
	reagent_state = LIQUID
	nutriment_factor = 30
	color = "#4F3500"

/datum/reagent/nutriment/vanilla
	name = "Vanilla Extract"
	id = "vanilla"
	description = "Vanilla extract. Tastes suspiciously like boring ice-cream."
	taste_description = "vanilla"
	taste_mult = 5
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#0F0A00"

/datum/reagent/nutriment/durian
	name = "Durian Paste"
	id = "durianpaste"
	description = "A strangely sweet and savory paste."
	taste_description = "sweet and savory"
	color = "#757631"

	glass_name = "durian paste"
	glass_desc = "Durian paste. It smells horrific."

/datum/reagent/nutriment/durian/touch_mob(var/mob/M, var/amount)
	if(iscarbon(M) && !M.isSynthetic())
		var/message = pick("Oh god, it smells disgusting here.", "What is that stench?", "That's an awful odor.")
		to_chat(M, "<span class='alien'>[message]</span>")
		if(prob(CLAMP(amount, 5, 90)))
			var/mob/living/L = M
			L.vomit()
	return ..()

/datum/reagent/nutriment/durian/touch_turf(var/turf/T, var/amount)
	if(istype(T))
		var/obj/effect/decal/cleanable/chemcoating/C = new /obj/effect/decal/cleanable/chemcoating(T)
		C.reagents.add_reagent(id, amount)
	return ..()

/datum/reagent/nutriment/virus_food
	name = "Virus Food"
	id = "virusfood"
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	taste_description = "vomit"
	taste_mult = 2
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#899613"

/datum/reagent/nutriment/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "sugar"
	nutriment_factor = 1
	color = "#FF00FF"

/datum/reagent/nutriment/mint
	name = "Mint"
	id = "mint"
	description = "Also known as Mentha."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#CF3600"

/datum/reagent/lipozine // The anti-nutriment.
	name = "Lipozine"
	id = "lipozine"
	description = "A chemical compound that causes a powerful fat-burning reaction."
	taste_description = "mothballs"
	reagent_state = LIQUID
	color = "#BBEDA4"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition = max(M.nutrition - 10 * removed, 0)
	M.overeatduration = 0
	if(M.nutrition < 0)
		M.nutrition = 0

/* Non-food stuff like condiments */

/datum/reagent/sodiumchloride
	name = "Table Salt"
	id = "sodiumchloride"
	description = "A salt made of sodium chloride. Commonly used to season food."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE
	ingest_met = REM

/datum/reagent/sodiumchloride/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed)

/datum/reagent/sodiumchloride/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	var/pass_mod = rand(3,5)
	var/passthrough = (removed - (removed/pass_mod)) //Some may be nullified during consumption, between one third and one fifth.
	affect_blood(M, alien, passthrough)

/datum/reagent/blackpepper
	name = "Black Pepper"
	id = "blackpepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	taste_description = "pepper"
	reagent_state = SOLID
	ingest_met = REM
	color = "#000000"

/datum/reagent/enzyme
	name = "Universal Enzyme"
	id = "enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	taste_description = "sweetness"
	taste_mult = 0.7
	reagent_state = LIQUID
	color = "#365E30"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/frostoil
	name = "Frost Oil"
	id = "frostoil"
	description = "A special oil that noticably chills the body. Extracted from Ice Peppers."
	taste_description = "mint"
	taste_mult = 1.5
	reagent_state = LIQUID
	ingest_met = REM
	color = "#B31008"

/datum/reagent/frostoil/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 215)
	if(prob(1))
		M.emote("shiver")
	holder.remove_reagent("capsaicin", 5)

/datum/reagent/frostoil/cryotoxin //A longer lasting version of frost oil.
	name = "Cryotoxin"
	id = "cryotoxin"
	description = "Lowers the body's internal temperature."
	reagent_state = LIQUID
	color = "#B31008"
	metabolism = REM * 0.5

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	id = "capsaicin"
	description = "This is what makes chilis hot."
	taste_description = "hot peppers"
	taste_mult = 1.5
	reagent_state = LIQUID
	ingest_met = REM
	color = "#B31008"

/datum/reagent/capsaicin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(0.5 * removed)

/datum/reagent/capsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return

	if(dose < 5 && (dose == metabolism || prob(5)))
		to_chat(M, "<span class='danger'>Your insides feel uncomfortably hot!</span>")
	if(dose >= 5)
		M.apply_effect(2, AGONY, 0)
		if(prob(5))
			M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!")]</span>", "<span class='danger'>You feel like your insides are burning!</span>")
	holder.remove_reagent("frostoil", 5)

/datum/reagent/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	description = "A chemical agent used for self-defense and in police work."
	taste_description = "fire"
	taste_mult = 10
	reagent_state = LIQUID
	touch_met = 50 // Get rid of it quickly
	ingest_met = REM
	color = "#B31008"

/datum/reagent/condensedcapsaicin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(0.5 * removed)

/datum/reagent/condensedcapsaicin/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/eyes_covered = 0
	var/mouth_covered = 0

	var/head_covered = 0
	var/arms_covered = 0 //These are used for the effects on slime-based species.
	var/legs_covered = 0
	var/hands_covered = 0
	var/feet_covered = 0
	var/chest_covered = 0
	var/groin_covered = 0

	var/obj/item/safe_thing = null

	var/effective_strength = 5

	if(alien == IS_SKRELL)	//Larger eyes means bigger targets.
		effective_strength = 8

	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
		if(H.head)
			if(H.head.body_parts_covered & EYES)
				eyes_covered = 1
				safe_thing = H.head
			if((H.head.body_parts_covered & FACE) && !(H.head.item_flags & FLEXIBLEMATERIAL))
				mouth_covered = 1
				safe_thing = H.head
		if(H.wear_mask)
			if(!eyes_covered && H.wear_mask.body_parts_covered & EYES)
				eyes_covered = 1
				safe_thing = H.wear_mask
			if(!mouth_covered && (H.wear_mask.body_parts_covered & FACE) && !(H.wear_mask.item_flags & FLEXIBLEMATERIAL))
				mouth_covered = 1
				safe_thing = H.wear_mask
		if(H.glasses && H.glasses.body_parts_covered & EYES)
			if(!eyes_covered)
				eyes_covered = 1
				if(!safe_thing)
					safe_thing = H.glasses
		if(alien == IS_SLIME)
			for(var/obj/item/clothing/C in H.worn_clothing)
				if(C.body_parts_covered & HEAD)
					head_covered = 1
				if(C.body_parts_covered & UPPER_TORSO)
					chest_covered = 1
				if(C.body_parts_covered & LOWER_TORSO)
					groin_covered = 1
				if(C.body_parts_covered & LEGS)
					legs_covered = 1
				if(C.body_parts_covered & ARMS)
					arms_covered = 1
				if(C.body_parts_covered & HANDS)
					hands_covered = 1
				if(C.body_parts_covered & FEET)
					feet_covered = 1
				if(head_covered && chest_covered && groin_covered && legs_covered && arms_covered && hands_covered && feet_covered)
					break
	if(eyes_covered && mouth_covered)
		to_chat(M, "<span class='warning'>Your [safe_thing] protects you from the pepperspray!</span>")
		if(alien != IS_SLIME)
			return
	else if(eyes_covered)
		to_chat(M, "<span class='warning'>Your [safe_thing] protects you from most of the pepperspray!</span>")
		M.eye_blurry = max(M.eye_blurry, effective_strength * 3)
		M.Blind(effective_strength)
		M.Stun(5)
		M.Weaken(5)
		if(alien != IS_SLIME)
			return
	else if(mouth_covered) // Mouth cover is better than eye cover
		to_chat(M, "<span class='warning'>Your [safe_thing] protects your face from the pepperspray!</span>")
		M.eye_blurry = max(M.eye_blurry, effective_strength)
		if(alien != IS_SLIME)
			return
	else// Oh dear :D
		to_chat(M, "<span class='warning'>You're sprayed directly in the eyes with pepperspray!</span>")
		M.eye_blurry = max(M.eye_blurry, effective_strength * 5)
		M.Blind(effective_strength * 2)
		M.Stun(5)
		M.Weaken(5)
		if(alien != IS_SLIME)
			return
	if(alien == IS_SLIME)
		if(!head_covered)
			if(prob(33))
				to_chat(M, "<span class='warning'>The exposed flesh on your head burns!</span>")
			M.apply_effect(5 * effective_strength, AGONY, 0)
		if(!chest_covered)
			if(prob(33))
				to_chat(M, "<span class='warning'>The exposed flesh on your chest burns!</span>")
			M.apply_effect(5 * effective_strength, AGONY, 0)
		if(!groin_covered && prob(75))
			if(prob(33))
				to_chat(M, "<span class='warning'>The exposed flesh on your groin burns!</span>")
			M.apply_effect(3 * effective_strength, AGONY, 0)
		if(!arms_covered && prob(45))
			if(prob(33))
				to_chat(M, "<span class='warning'>The exposed flesh on your arms burns!</span>")
			M.apply_effect(3 * effective_strength, AGONY, 0)
		if(!legs_covered && prob(45))
			if(prob(33))
				to_chat(M, "<span class='warning'>The exposed flesh on your legs burns!</span>")
			M.apply_effect(3 * effective_strength, AGONY, 0)
		if(!hands_covered && prob(20))
			if(prob(33))
				to_chat(M, "<span class='warning'>The exposed flesh on your hands burns!</span>")
			M.apply_effect(effective_strength / 2, AGONY, 0)
		if(!feet_covered && prob(20))
			if(prob(33))
				to_chat(M, "<span class='warning'>The exposed flesh on your feet burns!</span>")
			M.apply_effect(effective_strength / 2, AGONY, 0)

/datum/reagent/condensedcapsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(dose == metabolism)
		to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
	else
		M.apply_effect(4, AGONY, 0)
		if(prob(5))
			M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!")]</span>", "<span class='danger'>You feel like your insides are burning!</span>")
	holder.remove_reagent("frostoil", 5)

/* Drinks */

/datum/reagent/drink
	name = "Drink"
	id = "drink"
	description = "Uh, some kind of drink."
	ingest_met = REM
	reagent_state = LIQUID
	color = "#E78108"
	var/nutrition = 0 // Per unit
	var/adj_dizzy = 0 // Per tick
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0
	var/water_based = TRUE

/datum/reagent/drink/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/strength_mod = 1
	if(alien == IS_SLIME && water_based)
		strength_mod = 3
	M.adjustToxLoss(removed * strength_mod) // Probably not a good idea; not very deadly though
	return

/datum/reagent/drink/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition += nutrition * removed
	M.dizziness = max(0, M.dizziness + adj_dizzy)
	M.drowsyness = max(0, M.drowsyness + adj_drowsy)
	M.sleeping = max(0, M.sleeping + adj_sleepy)
	if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > 310)
		M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	/* VOREStation Removal
	if(alien == IS_SLIME && water_based)
		M.adjustToxLoss(removed * 2)
	*/ //VOREStation Removal End

/datum/reagent/drink/overdose(var/mob/living/carbon/M, var/alien) //Add special interactions here in the future if desired.
	..()

// Juices

/datum/reagent/drink/juice/banana
	name = "Banana Juice"
	id = "banana"
	description = "The raw essence of a banana."
	taste_description = "banana"
	color = "#C3AF00"

	glass_name = "banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/datum/reagent/drink/juice/berry
	name = "Berry Juice"
	id = "berryjuice"
	description = "A delicious blend of several different kinds of berries."
	taste_description = "berries"
	color = "#990066"

	glass_name = "berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/datum/reagent/drink/juice/pineapple
	name = "Pineapple Juice"
	id = "pineapplejuice"
	description = "A sour but refreshing juice from a pineapple."
	taste_description = "pineapple"
	color = "#C3AF00"

	glass_name = "pineapple juice"
	glass_desc = "Pineapple juice. Or maybe it's spineapple. Who cares?"

/datum/reagent/drink/juice/carrot
	name = "Carrot juice"
	id = "carrotjuice"
	description = "It is just like a carrot but without crunching."
	taste_description = "carrots"
	color = "#FF8C00" // rgb: 255, 140, 0

	glass_name = "carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/datum/reagent/drink/juice/carrot/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.reagents.add_reagent("imidazoline", removed * 0.2)

/datum/reagent/drink/juice
	name = "Grape Juice"
	id = "grapejuice"
	description = "It's grrrrrape!"
	taste_description = "grapes"
	color = "#863333"

	glass_name = "grape juice"
	glass_desc = "It's grrrrrape!"

/datum/reagent/drink/juice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/effective_dose = dose/2
	if(issmall(M))
		effective_dose *= 2

/* //VOREStation Removal - Assuming all juice has sugar is silly
	if(alien == IS_UNATHI)
		if(effective_dose < 2)
			if(effective_dose == metabolism * 2 || prob(5))
				M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.sleeping = max(M.sleeping, 20)
			M.drowsyness = max(M.drowsyness, 60)
*/

/datum/reagent/drink/juice/lemon
	name = "Lemon Juice"
	id = "lemonjuice"
	description = "This juice is VERY sour."
	taste_description = "sourness"
	taste_mult = 1.1
	color = "#AFAF00"

	glass_name = "lemon juice"
	glass_desc = "Sour..."

/datum/reagent/drink/juice/apple
	name = "Apple Juice"
	id = "applejuice"
	description = "The most basic juice."
	taste_description = "crispness"
	taste_mult = 1.1
	color = "#E2A55F"

	glass_name = "apple juice"
	glass_desc = "An earth favorite."

/datum/reagent/drink/juice/lime
	name = "Lime Juice"
	id = "limejuice"
	description = "The sweet-sour juice of limes."
	taste_description = "sourness"
	taste_mult = 1.8
	color = "#365E30"

	glass_name = "lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/datum/reagent/drink/juice/lime/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/juice/orange
	name = "Orange juice"
	id = "orangejuice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	taste_description = "oranges"
	color = "#E78108"

	glass_name = "orange juice"
	glass_desc = "Vitamins! Yay!"

/datum/reagent/drink/orangejuice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustOxyLoss(-2 * removed)

/datum/reagent/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = "Poison Berry Juice"
	id = "poisonberryjuice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	taste_description = "berries"
	color = "#863353"
	strength = 5

	glass_name = "poison berry juice"
	glass_desc = "A glass of deadly juice."

/datum/reagent/drink/juice/potato
	name = "Potato Juice"
	id = "potatojuice"
	description = "Juice of the potato. Bleh."
	taste_description = "potatoes"
	nutrition = 2
	color = "#302000"

	glass_name = "potato juice"
	glass_desc = "Juice from a potato. Bleh."

/datum/reagent/drink/juice/tomato
	name = "Tomato Juice"
	id = "tomatojuice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	taste_description = "tomatoes"
	color = "#731008"

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/drink/juice/tomato/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.heal_organ_damage(0, 0.5 * removed)

/datum/reagent/drink/juice/watermelon
	name = "Watermelon Juice"
	id = "watermelonjuice"
	description = "Delicious juice made from watermelon."
	taste_description = "sweet watermelon"
	color = "#B83333"

	glass_name = "watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

// Everything else

/datum/reagent/drink/milk
	name = "Milk"
	id = "milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	taste_description = "milk"
	color = "#DFDFDF"

	glass_name = "milk"
	glass_desc = "White and nutritious goodness!"

	cup_icon_state = "cup_cream"
	cup_name = "cup of milk"
	cup_desc = "White and nutritious goodness!"

/datum/reagent/drink/milk/chocolate
	name =  "Chocolate Milk"
	id = "chocolate_milk"
	description = "A delicious mixture of perfectly healthy mix and terrible chocolate."
	taste_description = "chocolate milk"
	color = "#74533b"

	cup_icon_state = "cup_brown"
	cup_name = "cup of chocolate milk"
	cup_desc = "Deliciously fattening!"

	glass_name = "chocolate milk"
	glass_desc = "Deliciously fattening!"


/datum/reagent/drink/milk/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.heal_organ_damage(0.5 * removed, 0)
	holder.remove_reagent("capsaicin", 10 * removed)

/datum/reagent/drink/milk/cream
	name = "Cream"
	id = "cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	taste_description = "thick milk"
	color = "#DFD7AF"

	glass_name = "cream"
	glass_desc = "Ewwww..."

	cup_icon_state = "cup_cream"
	cup_name = "cup of cream"
	cup_desc = "Ewwww..."

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	id = "soymilk"
	description = "An opaque white liquid made from soybeans."
	taste_description = "soy milk"
	color = "#DFDFC7"

	glass_name = "soy milk"
	glass_desc = "White and nutritious soy goodness!"

	cup_icon_state = "cup_cream"
	cup_name = "cup of milk"
	cup_desc = "White and nutritious goodness!"

/datum/reagent/drink/tea
	name = "Tea"
	id = "tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	taste_description = "black tea"
	color = "#832700"
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20

	glass_name = "cup of tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

	cup_icon_state = "cup_tea"
	cup_name = "cup of tea"
	cup_desc = "Tasty black tea, it has antioxidants, it's good for you!"

/datum/reagent/drink/tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/tea/icetea
	name = "Iced Tea"
	id = "icetea"
	description = "No relation to a certain rap artist/ actor."
	taste_description = "sweet tea"
	color = "#AC7F24" // rgb: 16, 64, 56
	adj_temp = -5

	glass_name = "iced tea"
	glass_desc = "No relation to a certain rap artist/ actor."
	glass_special = list(DRINK_ICE)

	cup_icon_state = "cup_tea"
	cup_name = "cup of iced tea"
	cup_desc = "No relation to a certain rap artist/ actor."

/datum/reagent/drink/tea/icetea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(M.bodytemperature > T0C)
			M.bodytemperature -= 0.5
		if(M.bodytemperature < T0C)
			M.bodytemperature += 0.5
		//M.adjustToxLoss(5 * removed) //VOREStation Removal

/datum/reagent/drink/tea/icetea/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(M.bodytemperature > T0C)
			M.bodytemperature -= 0.5
		if(M.bodytemperature < T0C)
			M.bodytemperature += 0.5
		//M.adjustToxLoss(5 * removed) //VOREStation Removal

/datum/reagent/drink/tea/minttea
	name = "Mint Tea"
	id = "minttea"
	description = "A tasty mixture of mint and tea. It's apparently good for you!"
	color = "#A8442C"
	taste_description = "black tea with tones of mint"

	glass_name = "mint tea"
	glass_desc = "A tasty mixture of mint and tea. It's apparently good for you!"

	cup_name = "cup of mint tea"
	cup_desc = "A tasty mixture of mint and tea. It's apparently good for you!"

/datum/reagent/drink/tea/lemontea
	name = "Lemon Tea"
	id = "lemontea"
	description = "A tasty mixture of lemon and tea. It's apparently good for you!"
	color = "#FC6A00"
	taste_description = "black tea with tones of lemon"

	glass_name = "lemon tea"
	glass_desc = "A tasty mixture of lemon and tea. It's apparently good for you!"

	cup_name = "cup of lemon tea"
	cup_desc = "A tasty mixture of lemon and tea. It's apparently good for you!"

/datum/reagent/drink/tea/limetea
	name = "Lime Tea"
	id = "limetea"
	description = "A tasty mixture of lime and tea. It's apparently good for you!"
	color = "#DE4300"
	taste_description = "black tea with tones of lime"

	glass_name = "lime tea"
	glass_desc = "A tasty mixture of lime and tea. It's apparently good for you!"

	cup_name = "cup of lime tea"
	cup_desc = "A tasty mixture of lime and tea. It's apparently good for you!"

/datum/reagent/drink/tea/orangetea
	name = "Orange Tea"
	id = "orangetea"
	description = "A tasty mixture of orange and tea. It's apparently good for you!"
	color = "#FB4F06"
	taste_description = "black tea with tones of orange"

	glass_name = "orange tea"
	glass_desc = "A tasty mixture of orange and tea. It's apparently good for you!"

	cup_name = "cup of orange tea"
	cup_desc = "A tasty mixture of orange and tea. It's apparently good for you!"

/datum/reagent/drink/tea/berrytea
	name = "Berry Tea"
	id = "berrytea"
	description = "A tasty mixture of berries and tea. It's apparently good for you!"
	color = "#A60735"
	taste_description = "black tea with tones of berries"

	glass_name = "berry tea"
	glass_desc = "A tasty mixture of berries and tea. It's apparently good for you!"

	cup_name = "cup of berry tea"
	cup_desc = "A tasty mixture of berries and tea. It's apparently good for you!"

/datum/reagent/drink/coffee
	name = "Coffee"
	id = "coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	taste_description = "coffee"
	taste_mult = 1.3
	color = "#482000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25
	overdose = 45

	cup_icon_state = "cup_coffee"
	cup_name = "cup of coffee"
	cup_desc = "Don't drop it, or you'll send scalding liquid and ceramic shards everywhere."

	glass_name = "coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."


/datum/reagent/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	//if(alien == IS_TAJARA) //VOREStation Edit Begin
		//M.adjustToxLoss(0.5 * removed)
		//M.make_jittery(4) //extra sensitive to caffine
	if(adj_temp > 0)
		holder.remove_reagent("frostoil", 10 * removed)

/datum/reagent/drink/coffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	//if(alien == IS_TAJARA)
		//M.adjustToxLoss(2 * removed)
		//M.make_jittery(4)
		//return

/datum/reagent/drink/coffee/overdose(var/mob/living/carbon/M, var/alien)
	if(alien == IS_DIONA)
		return
	//if(alien == IS_TAJARA)
		//M.adjustToxLoss(4 * REM)
		//M.apply_effect(3, STUTTER) //VOREStation Edit end
	M.make_jittery(5)

/datum/reagent/drink/coffee/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	description = "Coffee and ice, refreshing and cool."
	color = "#102838"
	adj_temp = -5

	glass_name = "iced coffee"
	glass_desc = "A drink to perk you up and refresh you!"
	glass_special = list(DRINK_ICE)

/datum/reagent/drink/coffee/icecoffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(M.bodytemperature > T0C)
			M.bodytemperature -= 0.5
		if(M.bodytemperature < T0C)
			M.bodytemperature += 0.5
		//M.adjustToxLoss(5 * removed) //VOREStation Removal

/datum/reagent/drink/coffee/icecoffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(M.bodytemperature > T0C)
			M.bodytemperature -= 0.5
		if(M.bodytemperature < T0C)
			M.bodytemperature += 0.5
		//M.adjustToxLoss(5 * removed) //VOREStation Removal

/datum/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	description = "A nice and tasty beverage while you are reading your hippie books."
	taste_description = "creamy coffee"
	color = "#C65905"
	adj_temp = 5

	glass_desc = "A nice and refreshing beverage while you are reading."
	glass_name = "soy latte"
	glass_desc = "A nice and refrshing beverage while you are reading."

	cup_icon_state = "cup_latte"
	cup_name = "cup of soy latte"
	cup_desc = "A nice and refreshing beverage while you are reading."

/datum/reagent/drink/coffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	description = "A nice, strong and tasty beverage while you are reading."
	taste_description = "bitter cream"
	color = "#C65905"
	adj_temp = 5

	glass_name = "cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading."

	cup_icon_state = "cup_latte"
	cup_name = "cup of cafe latte"
	cup_desc = "A nice and refreshing beverage while you are reading."

/datum/reagent/drink/coffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/decaf
	name = "Decaf Coffee"
	id = "decaf"
	description = "Coffee with all the wake-up sucked out."
	taste_description = "bad coffee"
	taste_mult = 1.3
	color = "#482000"
	adj_temp = 25

	cup_icon_state = "cup_coffee"
	cup_name = "cup of decaf"
	cup_desc = "Basically just brown, bitter water."

	glass_name = "decaf coffee"
	glass_desc = "Basically just brown, bitter water."

/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	id = "hot_coco"
	description = "Made with love! And cocoa beans."
	taste_description = "creamy chocolate"
	reagent_state = LIQUID
	color = "#403010"
	nutrition = 2
	adj_temp = 5

	glass_name = "hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

	cup_icon_state = "cup_coco"
	cup_name = "cup of hot chocolate"
	cup_desc = "Made with love! And cocoa beans."

/datum/reagent/drink/soda/sodawater
	name = "Soda Water"
	id = "sodawater"
	description = "A can of club soda. Why not make a scotch and soda?"
	taste_description = "carbonated water"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	description = "Grapes made into a fine drank."
	taste_description = "grape soda"
	color = "#421C52"
	adj_drowsy = -3

	glass_name = "grape soda"
	glass_desc = "Looks like a delicious drink!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/tonic
	name = "Tonic Water"
	id = "tonic"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	taste_description = "tart and fresh"
	color = "#619494"

	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = -5

	glass_name = "tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/datum/reagent/drink/soda/lemonade
	name = "Lemonade"
	id = "lemonade"
	description = "Oh the nostalgia..."
	taste_description = "lemonade"
	color = "#FFFF00"
	adj_temp = -5

	glass_name = "lemonade"
	glass_desc = "Oh the nostalgia..."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/melonade
	name = "Melonade"
	id = "melonade"
	description = "Oh the.. nostalgia?"
	taste_description = "watermelon"
	color = "#FFB3BB"
	adj_temp = -5

	glass_name = "melonade"
	glass_desc = "Oh the.. nostalgia?"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/appleade
	name = "Appleade"
	id = "appleade"
	description = "Applejuice, improved."
	taste_description = "apples"
	color = "#FFD1B3"
	adj_temp = -5

	glass_name = "appleade"
	glass_desc = "Applejuice, improved."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/pineappleade
	name = "Pineappleade"
	id = "pineappleade"
	description = "Spineapple, juiced up."
	taste_description = "sweet`n`sour pineapples"
	color = "#FFFF00"
	adj_temp = -5

	glass_name = "pineappleade"
	glass_desc = "Spineapple, juiced up."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/kiraspecial
	name = "Kira Special"
	id = "kiraspecial"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	taste_description = "fruity sweetness"
	color = "#CCCC99"
	adj_temp = -5

	glass_name = "Kira Special"
	glass_desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/brownstar
	name = "Brown Star"
	id = "brownstar"
	description = "It's not what it sounds like..."
	taste_description = "orange and cola soda"
	color = "#9F3400"
	adj_temp = -2

	glass_name = "Brown Star"
	glass_desc = "It's not what it sounds like..."

/datum/reagent/drink/milkshake
	name = "Milkshake"
	id = "milkshake"
	description = "Glorious brainfreezing mixture."
	taste_description = "vanilla milkshake"
	color = "#AEE5E4"
	adj_temp = -9

	glass_name = "milkshake"
	glass_desc = "Glorious brainfreezing mixture."

/datum/reagent/milkshake/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/effective_dose = dose/2
	if(issmall(M))
		effective_dose *= 2

	if(alien == IS_UNATHI)
		if(effective_dose < 2)
			if(effective_dose == metabolism * 2 || prob(5))
				M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.sleeping = max(M.sleeping, 20)
			M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/drink/milkshake/chocoshake
	name = "Chocolate Milkshake"
	id = "chocoshake"
	description = "A refreshing chocolate milkshake."
	taste_description = "cold refreshing chocolate and cream"
	color = "#8e6f44" // rgb(142, 111, 68)
	adj_temp = -9

	glass_name = "Chocolate Milkshake"
	glass_desc = "A refreshing chocolate milkshake, just like mom used to make."

/datum/reagent/drink/milkshake/berryshake
	name = "Berry Milkshake"
	id = "berryshake"
	description = "A refreshing berry milkshake."
	taste_description = "cold refreshing berries and cream"
	color = "#ffb2b2" // rgb(255, 178, 178)
	adj_temp = -9

	glass_name = "Berry Milkshake"
	glass_desc = "A refreshing berry milkshake, just like mom used to make."

/datum/reagent/drink/milkshake/coffeeshake
	name = "Coffee Milkshake"
	id = "coffeeshake"
	description = "A refreshing coffee milkshake."
	taste_description = "cold energizing coffee and cream"
	color = "#8e6f44" // rgb(142, 111, 68)
	adj_temp = -9
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2


	glass_name = "Coffee Milkshake"
	glass_desc = "An energizing coffee milkshake, perfect for hot days at work.."

/datum/reagent/drink/milkshake/coffeeshake/overdose(var/mob/living/carbon/M, var/alien)
	M.make_jittery(5)

/datum/reagent/drink/milkshake/peanutshake
	name = "Peanut Milkshake"
	id = "peanutmilkshake"
	description = "Savory cream in an ice-cold stature."
	taste_description = "cold peanuts and cream"
	color = "#8e6f44"

	glass_name = "Peanut Milkshake"
	glass_desc = "Savory cream in an ice-cold stature."

/datum/reagent/drink/rewriter
	name = "Rewriter"
	id = "rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	taste_description = "citrus and coffee"
	color = "#485000"
	adj_temp = -5

	glass_name = "Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."

/datum/reagent/drink/rewriter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.make_jittery(5)

/datum/reagent/drink/soda/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
	description = "Cola, cola never changes."
	taste_description = "cola"
	color = "#100800"
	adj_temp = -5
	adj_sleepy = -2

	glass_name = "Nuka-Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/nuka_cola/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.make_jittery(20)
	M.druggy = max(M.druggy, 30)
	M.dizziness += 5
	M.drowsyness = 0

/datum/reagent/drink/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	taste_description = "100% pure pomegranate"
	color = "#FF004F"
	water_based = FALSE

	glass_name = "grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."

/datum/reagent/drink/soda/space_cola
	name = "Space Cola"
	id = "cola"
	description = "A refreshing beverage."
	taste_description = "cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Space Cola"
	glass_desc = "A glass of refreshing Space Cola"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/spacemountainwind
	name = "Mountain Wind"
	id = "spacemountainwind"
	description = "Blows right through you like a space wind."
	taste_description = "sweet citrus soda"
	color = "#102000"
	adj_drowsy = -7
	adj_sleepy = -1
	adj_temp = -5

	glass_name = "Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/dr_gibb
	name = "Dr. Gibb"
	id = "dr_gibb"
	description = "A delicious blend of 42 different flavors"
	taste_description = "cherry soda"
	color = "#102000"
	adj_drowsy = -6
	adj_temp = -5

	glass_name = "Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."

/datum/reagent/drink/soda/space_up
	name = "Space-Up"
	id = "space_up"
	description = "Tastes like a hull breach in your mouth."
	taste_description = "citrus soda"
	color = "#202800"
	adj_temp = -8

	glass_name = "Space-up"
	glass_desc = "Space-up. It helps keep your cool."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/lemon_lime
	name = "Lemon Lime"
	id = "lemon_lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	taste_description = "tangy lime and lemon soda"
	color = "#878F00"
	adj_temp = -8

	glass_name = "lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/gingerale
	name = "Ginger Ale"
	id = "gingerale"
	description = "The original."
	taste_description = "somewhat tangy ginger ale"
	color = "#edcf8f"
	adj_temp = -8

	glass_name = "ginger ale"
	glass_desc = "The original, refreshing not-actually-ale."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/shirley_temple
	name = "Shirley Temple"
	id =  "shirley_temple"
	description = "A sweet concotion hated even by its namesake."
	taste_description = "sweet ginger ale"
	color = "#EF304F"
	adj_temp = -8

	glass_name = "shirley temple"
	glass_desc = "A sweet concotion hated even by its namesake."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/roy_rogers
	name = "Roy Rogers"
	id = "roy_rogers"
	description = "I'm a cowboy, on a steel horse I ride."
	taste_description = "cola and fruit"
	color = "#4F1811"
	adj_temp = -8

	glass_name = "roy rogers"
	glass_desc = "I'm a cowboy, on a steel horse I ride"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/collins_mix
	name = "Collins Mix"
	id = "collins_mix"
	description = "Best hope it isn't a hoax."
	taste_description = "gin and lemonade"
	color = "#D7D0B3"
	adj_temp = -8

	glass_name = "collins mix"
	glass_desc = "Best hope it isn't a hoax."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/arnold_palmer
	name = "Arnold Palmer"
	id = "arnold_palmer"
	description = "Tastes just like the old man."
	taste_description = "lemon and sweet tea"
	color = "#AF5517"
	adj_temp = -8

	glass_name = "arnold palmer"
	glass_desc = "Tastes just like the old man."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/doctor_delight
	name = "The Doctor's Delight"
	id = "doctorsdelight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	taste_description = "homely fruit smoothie"
	reagent_state = LIQUID
	color = "#FF8CFF"
	nutrition = 1

	glass_name = "The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."

/datum/reagent/drink/doctor_delight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustOxyLoss(-4 * removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustToxLoss(-2 * removed)
	if(M.dizziness)
		M.dizziness = max(0, M.dizziness - 15)
	if(M.confused)
		M.Confuse(-5)

/datum/reagent/drink/dry_ramen
	name = "Dry Ramen"
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	taste_description = "dry cheap noodles"
	reagent_state = SOLID
	nutrition = 1
	color = "#302000"

/datum/reagent/drink/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "noodles and salt"
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	adj_temp = 5

/datum/reagent/drink/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "noodles and spice"
	taste_mult = 1.7
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5

/datum/reagent/drink/hell_ramen/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT

/datum/reagent/drink/sweetsundaeramen
	name = "Dessert Ramen"
	id = "dessertramen"
	description = "How many things can you add to a cup of ramen before it begins to question its existance?"
	taste_description = "unbearable sweetness"
	color = "#4444FF"
	nutrition = 5

	glass_name = "Sweet Sundae Ramen"
	glass_desc = "How many things can you add to a cup of ramen before it begins to question its existance?"

/datum/reagent/drink/ice
	name = "Ice"
	id = "ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	taste_description = "ice"
	reagent_state = SOLID
	color = "#619494"
	adj_temp = -5

	glass_name = "ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/drink/ice/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(M.bodytemperature > T0C)
			M.bodytemperature -= rand(1,3)
		if(M.bodytemperature < T0C)
			M.bodytemperature += rand(1,3)
		//M.adjustToxLoss(5 * removed) //VOREStation Removal

/datum/reagent/drink/ice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		if(M.bodytemperature > T0C)
			M.bodytemperature -= rand(1,3)
		if(M.bodytemperature < T0C)
			M.bodytemperature += rand(1,3)
		//M.adjustToxLoss(5 * removed) //VOREStation Removal

/datum/reagent/drink/nothing
	name = "Nothing"
	id = "nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"

	glass_name = "nothing"
	glass_desc = "Absolutely nothing."

/datum/reagent/drink/dreamcream
	name = "Dream Cream"
	id = "dreamcream"
	description = "A smoothy, silky mix of honey and dairy."
	taste_description = "sweet, soothing dairy"
	color = "#fcfcc9" // rgb(252, 252, 201)

	glass_name = "Dream Cream"
	glass_desc = "A smoothy, silky mix of honey and dairy."

/datum/reagent/drink/soda/vilelemon
	name = "Vile Lemon"
	id = "vilelemon"
	description = "A fizzy, sour lemonade mix."
	taste_description = "fizzy, sour lemon"
	color = "#c6c603" // rgb(198, 198, 3)

	glass_name = "Vile Lemon"
	glass_desc = "A sour, fizzy drink with lemonade and lemonlime."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/entdraught
	name = "Ent's Draught"
	id = "entdraught"
	description = "A natural, earthy combination of all things peaceful."
	taste_description = "fresh rain and sweet memories"
	color = "#3a6617" // rgb(58, 102, 23)

	glass_name = "Ent's Draught"
	glass_desc = "You can almost smell the tranquility emanating from this."

/datum/reagent/drink/lovepotion
	name = "Love Potion"
	id = "lovepotion"
	description = "Creamy strawberries and sugar, simple and sweet."
	taste_description = "strawberries and cream"
	color = "#fc8a8a" // rgb(252, 138, 138)

	glass_name = "Love Potion"
	glass_desc = "Love me tender, love me sweet."

/datum/reagent/drink/oilslick
	name = "Oil Slick"
	id = "oilslick"
	description = "A viscous, but sweet, ooze."
	taste_description = "honey"
	color = "#FDF5E6" // rgb(253,245,230)
	water_based = FALSE

	glass_name = "Oil Slick"
	glass_desc = "A concoction that should probably be in an engine, rather than your stomach."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/drink/slimeslammer
	name = "Slick Slimes Slammer"
	id = "slimeslammer"
	description = "A viscous, but savory, ooze."
	taste_description = "peanuts`n`slime"
	color = "#93604D"
	water_based = FALSE

	glass_name = "Slick Slime Slammer"
	glass_desc = "A concoction that should probably be in an engine, rather than your stomach. Still."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/drink/eggnog
	name = "Eggnog"
	id = "eggnog"
	description = "A creamy, rich beverage made out of whisked eggs, milk and sugar, for when you feel like celebrating the winter holidays."
	taste_description = "thick cream and vanilla"
	color = "#fff3c1" // rgb(255, 243, 193)

	glass_name = "Eggnog"
	glass_desc = "You can't egg-nore the holiday cheer all around you"

/datum/reagent/drink/nuclearwaste
	name = "Nuclear Waste"
	id = "nuclearwaste"
	description = "A viscous, glowing slurry."
	taste_description = "sour honey drops"
	color = "#7FFF00" // rgb(127,255,0)
	water_based = FALSE

	glass_name = "Nuclear Waste"
	glass_desc = "Sadly, no super powers."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/nuclearwaste/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.bloodstr.add_reagent("radium", 0.3)

/datum/reagent/drink/nuclearwaste/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.ingested.add_reagent("radium", 0.25)

/datum/reagent/drink/sodaoil //Mixed with normal drinks to make a 'potable' version for Prometheans if mixed 1-1. Dilution is key.
	name = "Soda Oil"
	id = "sodaoil"
	description = "A thick, bubbling soda."
	taste_description = "chewy water"
	color = "#F0FFF0" // rgb(245,255,250)
	water_based = FALSE

	glass_name = "Soda Oil"
	glass_desc = "A pitiful sludge that looks vaguely like a soda.. if you look at it a certain way."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/sodaoil/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(M.bloodstr) // If, for some reason, they are injected, dilute them as well.
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(istype(R, /datum/reagent/drink))
				var/datum/reagent/drink/D = R
				if(D.water_based)
					M.adjustToxLoss(removed * -3)

/datum/reagent/drink/sodaoil/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(M.ingested) // Find how many drinks are causing tox, and negate them.
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(istype(R, /datum/reagent/drink))
				var/datum/reagent/drink/D = R
				if(D.water_based)
					M.adjustToxLoss(removed * -2)

/datum/reagent/drink/mojito
	name = "Mojito"
	id = "virginmojito"
	description = "Mint, bubbly water, and citrus, made for sailing."
	taste_description = "mint and lime"
	color = "#FFF7B3"

	glass_name = "mojito"
	glass_desc = "Mint, bubbly water, and citrus, made for sailing."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/sexonthebeach
	name = "Virgin Sex On The Beach"
	id = "virginsexonthebeach"
	description = "A secret combination of orange juice and pomegranate."
	taste_description = "60% orange juice, 40% pomegranate"
	color = "#7051E3"

	glass_name = "sex on the beach"
	glass_desc = "A secret combination of orange juice and pomegranate."

/datum/reagent/drink/driverspunch
	name = "Driver's Punch"
	id = "driverspunch"
	description = "A fruity punch!"
	taste_description = "sharp, sour apples"
	color = "#D2BA6E"

	glass_name = "driver`s punch"
	glass_desc = "A fruity punch!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/mintapplesparkle
	name = "Mint Apple Sparkle"
	id = "mintapplesparkle"
	description = "Delicious appleade with a touch of mint."
	taste_description = "minty apples"
	color = "#FDDA98"

	glass_name = "mint apple sparkle"
	glass_desc = "Delicious appleade with a touch of mint."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/berrycordial
	name = "Berry Cordial"
	id = "berrycordial"
	description = "How <font face='comic sans ms'>berry cordial</font> of you."
	taste_description = "sweet chivalry"
	color = "#D26EB8"

	glass_name = "berry cordial"
	glass_desc = "How <font face='comic sans ms'>berry cordial</font> of you."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/drink/tropicalfizz
	name = "Tropical Fizz"
	id = "tropicalfizz"
	description = "One sip and you're in the bahamas."
	taste_description = "tropical"
	color = "#69375C"

	glass_name = "tropical fizz"
	glass_desc = "One sip and you're in the bahamas."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/fauxfizz
	name = "Faux Fizz"
	id = "fauxfizz"
	description = "One sip and you're in the bahamas... maybe."
	taste_description = "slightly tropical"
	color = "#69375C"

	glass_name = "tropical fizz"
	glass_desc = "One sip and you're in the bahamas... maybe."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)

/* Alcohol */

// Basic

/datum/reagent/ethanol/absinthe
	name = "Absinthe"
	id = "absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	taste_description = "licorice"
	taste_mult = 1.5
	color = "#33EE00"
	strength = 12

	glass_name = "absinthe"
	glass_desc = "Wormwood, anise, oh my."

/datum/reagent/ethanol/ale
	name = "Ale"
	id = "ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	taste_description = "hearty barley ale"
	color = "#4C3100"
	strength = 50

	glass_name = "ale"
	glass_desc = "A freezing pint of delicious ale"

/datum/reagent/ethanol/beer
	name = "Beer"
	id = "beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	taste_description = "beer"
	color = "#FFD300"
	strength = 50
	nutriment_factor = 1

	glass_name = "beer"
	glass_desc = "A freezing pint of beer"

/datum/reagent/ethanol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.jitteriness = max(M.jitteriness - 3, 0)

/datum/reagent/ethanol/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000CD"
	strength = 15

	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."

/datum/reagent/ethanol/cognac
	name = "Cognac"
	id = "cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#AB3C05"
	strength = 15

	glass_name = "cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."

/datum/reagent/ethanol/deadrum
	name = "Deadrum"
	id = "deadrum"
	description = "Popular with the sailors. Not very popular with everyone else."
	taste_description = "butterscotch and salt"
	taste_mult = 1.1
	color = "#ECB633"
	strength = 50

	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"

/datum/reagent/ethanol/deadrum/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.dizziness +=5

/datum/reagent/ethanol/firepunch
	name = "Fire Punch"
	id = "firepunch"
	description = "Yo ho ho and a jar of honey."
	taste_description = "sharp butterscotch"
	color = "#ECB633"
	strength = 7

	glass_name = "fire punch"
	glass_desc = "Yo ho ho and a jar of honey."

/datum/reagent/ethanol/gin
	name = "Gin"
	id = "gin"
	description = "It's gin. In space. I say, good sir."
	taste_description = "an alcoholic christmas tree"
	color = "#0064C6"
	strength = 50

	glass_name = "gin"
	glass_desc = "A crystal clear glass of Griffeater gin."

//Base type for alchoholic drinks containing coffee
/datum/reagent/ethanol/coffee
	overdose = 45

/datum/reagent/ethanol/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.sleeping = max(0, M.sleeping - 2)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	//if(alien == IS_TAJARA)
		//M.adjustToxLoss(0.5 * removed)
		//M.make_jittery(4) //extra sensitive to caffine

/datum/reagent/ethanol/coffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	//if(alien == IS_TAJARA)
		//M.adjustToxLoss(2 * removed)
		//M.make_jittery(4)
		//return
	..()

/datum/reagent/ethanol/coffee/overdose(var/mob/living/carbon/M, var/alien)
	if(alien == IS_DIONA)
		return
	//if(alien == IS_TAJARA)
		//M.adjustToxLoss(4 * REM)
		//M.apply_effect(3, STUTTER) //VOREStation Edit end
	M.make_jittery(5)

/datum/reagent/ethanol/coffee/kahlua
	name = "Kahlua"
	id = "kahlua"
	description = "A widely known, Mexican coffee-flavored liqueur. In production since 1936!"
	taste_description = "spiked latte"
	taste_mult = 1.1
	color = "#4C3100"
	strength = 15

	glass_name = "RR coffee liquor"
	glass_desc = "A widely known, Mexican coffee-flavored liqueur. In production since 1936!"
//	glass_desc = "DAMN, THIS THING LOOKS ROBUST" //If this isn't what our players should talk like, it isn't what our game should say to them.

/datum/reagent/ethanol/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 50

	glass_name = "melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."

/datum/reagent/ethanol/melonspritzer
	name = "Melon Spritzer"
	id = "melonspritzer"
	description = "Melons: Citrus style."
	taste_description = "sour melon"
	color = "#934D5D"
	strength = 10

	glass_name = "melon spritzer"
	glass_desc = "Melons: Citrus style."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/ethanol/rum
	name = "Rum"
	id = "rum"
	description = "Yo-ho-ho and all that."
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#ECB633"
	strength = 15

	glass_name = "rum"
	glass_desc = "Makes you want to buy a ship and just go pillaging."

/datum/reagent/ethanol/sake
	name = "Sake"
	id = "sake"
	description = "Anime's favorite drink."
	taste_description = "dry alcohol"
	color = "#DDDDDD"
	strength = 25

	glass_name = "sake"
	glass_desc = "A glass of sake."

/datum/reagent/ethanol/sexonthebeach
	name = "Sex On The Beach"
	id = "sexonthebeach"
	description = "A concoction of vodka and a secret combination of orange juice and pomegranate."
	taste_description = "60% orange juice, 40% pomegranate, 100% alcohol"
	color = "#7051E3"
	strength = 15

	glass_name = "sex on the beach"
	glass_desc = "A concoction of vodka and a secret combination of orange juice and pomegranate."

/datum/reagent/ethanol/tequila
	name = "Tequila"
	id = "tequilla"
	description = "A strong and mildly flavored, Mexican produced spirit. Feeling thirsty hombre?"
	taste_description = "paint thinner"
	color = "#FFFF91"
	strength = 25

	glass_name = "Tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"

/datum/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	id = "thirteenloko"
	description = "A potent mixture of caffeine and alcohol."
	taste_description = "battery acid"
	color = "#102000"
	strength = 25
	nutriment_factor = 1

	glass_name = "Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/datum/reagent/ethanol/thirteenloko/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(0, M.drowsyness - 7)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)

/datum/reagent/ethanol/vermouth
	name = "Vermouth"
	id = "vermouth"
	description = "You suddenly feel a craving for a martini..."
	taste_description = "dry alcohol"
	taste_mult = 1.3
	color = "#91FF91" // rgb: 145, 255, 145
	strength = 15

	glass_name = "vermouth"
	glass_desc = "You wonder why you're even drinking this straight."

/datum/reagent/ethanol/vodka
	name = "Vodka"
	id = "vodka"
	description = "Number one drink AND fueling choice for Russians worldwide."
	taste_description = "grain alcohol"
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka"
	glass_desc = "The glass contain wodka. Xynta."

/datum/reagent/ethanol/vodka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.apply_effect(max(M.radiation - 1 * removed, 0), IRRADIATE, check_protection = 0)

/datum/reagent/ethanol/whiskey
	name = "Whiskey"
	id = "whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	taste_description = "molasses"
	color = "#4C3100"
	strength = 25

	glass_name = "whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."

/datum/reagent/ethanol/wine
	name = "Wine"
	id = "wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	taste_description = "bitter sweetness"
	color = "#7E4043" // rgb: 126, 64, 67
	strength = 15

	glass_name = "wine"
	glass_desc = "A very classy looking drink."

/datum/reagent/ethanol/wine/champagne
	name = "Champagne"
	id = "champagne"
	description = "A sparkling wine made with Pinot Noir, Pinot Meunier, and Chardonnay."
	taste_description = "fizzy bitter sweetness"
	color = "#D1B166"

	glass_name = "champagne"
	glass_desc = "An even classier looking drink."


/datum/reagent/ethanol/cider
	name = "Cider"
	id = "cider"
	description = "Hard? Soft? No-one knows but it'll get you drunk."
	taste_description = "tartness"
	color = "#CE9C00" // rgb: 206, 156, 0
	strength = 10

	glass_name = "cider"
	glass_desc = "The second most Irish drink."
	glass_special = list(DRINK_FIZZ)

// Cocktails


/datum/reagent/ethanol/acid_spit
	name = "Acid Spit"
	id = "acidspit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	taste_description = "bitter tang"
	reagent_state = LIQUID
	color = "#365000"
	strength = 30

	glass_name = "Acid Spit"
	glass_desc = "A drink from the company archives. Made from live aliens."

/datum/reagent/ethanol/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	taste_description = "bitter sweetness"
	color = "#D8AC45"
	strength = 25

	glass_name = "Allies cocktail"
	glass_desc = "A drink made from your allies."

/datum/reagent/ethanol/aloe
	name = "Aloe"
	id = "aloe"
	description = "So very, very, very good."
	taste_description = "sweet and creamy"
	color = "#B7EA75"
	strength = 15

	glass_name = "Aloe"
	glass_desc = "Very, very, very good."

/datum/reagent/ethanol/amasec
	name = "Amasec"
	id = "amasec"
	description = "Official drink of the Gun Club!"
	taste_description = "dark and metallic"
	reagent_state = LIQUID
	color = "#FF975D"
	strength = 25

	glass_name = "Amasec"
	glass_desc = "Always handy before combat!"

/datum/reagent/ethanol/andalusia
	name = "Andalusia"
	id = "andalusia"
	description = "A nice, strangely named drink."
	taste_description = "lemons"
	color = "#F4EA4A"
	strength = 15

	glass_name = "Andalusia"
	glass_desc = "A nice, strange named drink."

/datum/reagent/ethanol/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	description = "Ultimate refreshment."
	taste_description = "ice cold vodka"
	color = "#56DEEA"
	strength = 12
	adj_temp = 20
	targ_temp = 330

	glass_name = "Anti-freeze"
	glass_desc = "The ultimate refreshment."

/datum/reagent/ethanol/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	description = "Nuclear proliferation never tasted so good."
	taste_description = "coffee, almonds, and whiskey, with a kick"
	reagent_state = LIQUID
	color = "#666300"
	strength = 10
	druggy = 50

	glass_name = "Atomic Bomb"
	glass_desc = "We cannot take legal responsibility for your actions after imbibing."

/datum/reagent/ethanol/coffee/b52
	name = "B-52"
	id = "b52"
	description = "Kahlua, Irish cream, and cognac. You will get bombed."
	taste_description = "coffee, almonds, and whiskey"
	taste_mult = 1.3
	color = "#997650"
	strength = 12

	glass_name = "B-52"
	glass_desc = "Kahlua, Irish cream, and cognac. You will get bombed."

/datum/reagent/ethanol/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	description = "Tropical cocktail."
	taste_description = "lime and orange"
	color = "#FF7F3B"
	strength = 25

	glass_name = "Bahama Mama"
	glass_desc = "Tropical cocktail."

/datum/reagent/ethanol/bananahonk
	name = "Banana Mama"
	id = "bananahonk"
	description = "A drink from Clown Heaven."
	taste_description = "bananas and sugar"
	nutriment_factor = 1
	color = "#FFFF91"
	strength = 12

	glass_name = "Banana Honk"
	glass_desc = "A drink from Banana Heaven."

/datum/reagent/ethanol/barefoot
	name = "Barefoot"
	id = "barefoot"
	description = "Barefoot and pregnant."
	taste_description = "creamy berries"
	color = "#FFCDEA"
	strength = 30

	glass_name = "Barefoot"
	glass_desc = "Barefoot and pregnant."

/datum/reagent/ethanol/beepsky_smash
	name = "Beepsky Smash"
	id = "beepskysmash"
	description = "Deny drinking this and prepare for THE LAW."
	taste_description = "whiskey and citrus"
	taste_mult = 2
	reagent_state = LIQUID
	color = "#404040"
	strength = 12

	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."

/datum/reagent/ethanol/beepsky_smash/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.Stun(2)

/datum/reagent/ethanol/bilk
	name = "Bilk"
	id = "bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	taste_description = "sour milk"
	color = "#895C4C"
	strength = 50
	nutriment_factor = 2

	glass_name = "bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."

/datum/reagent/ethanol/black_russian
	name = "Black Russian"
	id = "blackrussian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	taste_description = "coffee"
	color = "#360000"
	strength = 15

	glass_name = "Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."

/datum/reagent/ethanol/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	taste_description = "tomatoes with a hint of lime"
	color = "#B40000"
	strength = 15

	glass_name = "Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."

/datum/reagent/ethanol/booger
	name = "Booger"
	id = "booger"
	description = "Ewww..."
	taste_description = "sweet 'n creamy"
	color = "#8CFF8C"
	strength = 30

	glass_name = "Booger"
	glass_desc = "Ewww..."

/datum/reagent/ethanol/coffee/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	description = "It's just as effective as Dutch-Courage!"
	taste_description = "coffee and paint thinner"
	taste_mult = 1.1
	color = "#4C3100"
	strength = 15

	glass_name = "Brave Bull"
	glass_desc = "Tequilla and coffee liquor, brought together in a mouthwatering mixture. Drink up."

/datum/reagent/ethanol/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	description = "You take a tiny sip and feel a burning sensation..."
	taste_description = "constantly changing flavors"
	color = "#2E6671"
	strength = 10

	glass_name = "Changeling Sting"
	glass_desc = "A stingy drink."

/datum/reagent/ethanol/martini
	name = "Classic Martini"
	id = "martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "dry class"
	color = "#0064C8"
	strength = 25

	glass_name = "classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."

/datum/reagent/ethanol/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	description = "Rum, mixed with cola. Viva la revolucion."
	taste_description = "cola"
	color = "#3E1B00"
	strength = 30

	glass_name = "Cuba Libre"
	glass_desc = "A classic mix of rum and cola."

/datum/reagent/ethanol/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	description = "This thing makes the hair on the back of your neck stand up."
	taste_description = "sweet tasting iron"
	taste_mult = 1.5
	color = "#820000"
	strength = 15

	glass_name = "Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair on the back of your neck stand up."

/datum/reagent/ethanol/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	description = "Creepy time!"
	taste_description = "bitter iron"
	color = "#A68310"
	strength = 15

	glass_name = "Devil's Kiss"
	glass_desc = "Creepy time!"

/datum/reagent/ethanol/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	taste_description = "a beach"
	nutriment_factor = 1
	color = "#2E6671"
	strength = 12

	glass_name = "Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."

/datum/reagent/ethanol/ginfizz
	name = "Gin Fizz"
	id = "ginfizz"
	description = "Refreshingly lemony, deliciously dry."
	taste_description = "dry, tart lemons"
	color = "#FFFFAE"
	strength = 30

	glass_name = "gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."

/datum/reagent/ethanol/grog
	name = "Grog"
	id = "grog"
	description = "Watered-down rum, pirate approved!"
	taste_description = "a poor excuse for alcohol"
	reagent_state = LIQUID
	color = "#FFBB00"
	strength = 100


	glass_name = "grog"
	glass_desc = "A fine and cepa drink for Space."

/datum/reagent/ethanol/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	description = "The surprise is, it's green!"
	taste_description = "tartness and bananas"
	color = "#2E6671"
	strength = 15

	glass_name = "Erika Surprise"
	glass_desc = "The surprise is, it's green!"

/datum/reagent/ethanol/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	description = "Whoah, this stuff looks volatile!"
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"
	taste_mult = 5
	reagent_state = LIQUID
	color = "#7F00FF"
	strength = 10
	druggy = 15

	glass_name = "Pan-Galactic Gargle Blaster"
	glass_desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."

/datum/reagent/ethanol/gintonic
	name = "Gin and Tonic"
	id = "gintonic"
	description = "An all time classic, mild cocktail."
	taste_description = "mild and tart"
	color = "#0064C8"
	strength = 50

	glass_name = "gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."

/datum/reagent/ethanol/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	taste_description = "burning cinnamon"
	taste_mult = 1.3
	color = "#F4E46D"
	strength = 15

	glass_name = "Goldschlager"
	glass_desc = "100 proof that teen girls will drink anything with gold in it."

/datum/reagent/ethanol/hippies_delight
	name = "Hippies' Delight"
	id = "hippiesdelight"
	description = "You just don't get it maaaan."
	taste_description = "giving peace a chance"
	reagent_state = LIQUID
	color = "#FF88FF"
	strength = 15
	druggy = 50

	glass_name = "Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."

/datum/reagent/ethanol/hooch
	name = "Hooch"
	id = "hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	taste_description = "pure alcohol"
	color = "#4C3100"
	strength = 25
	toxicity = 2

	glass_name = "Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	description = "A beer which is so cold the air around it freezes."
	taste_description = "refreshingly cold"
	color = "#FFD300"
	strength = 50
	adj_temp = -20
	targ_temp = 280

	glass_name = "iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_special = list(DRINK_ICE)

/datum/reagent/ethanol/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	description = "Mmm, tastes like chocolate cake..."
	taste_description = "delicious anger"
	color = "#2E6671"
	strength = 15

	glass_name = "Irish Car Bomb"
	glass_desc = "An irish car bomb."

/datum/reagent/ethanol/coffee/irishcoffee
	name = "Irish Coffee"
	id = "irishcoffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	taste_description = "giving up on the day"
	color = "#4C3100"
	strength = 15

	glass_name = "Irish coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."

/datum/reagent/ethanol/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	taste_description = "creamy alcohol"
	color = "#DDD9A3"
	strength = 25

	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"

/datum/reagent/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	taste_description = "sweet tea, with a kick"
	color = "#895B1F"
	strength = 12

	glass_name = "Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."

/datum/reagent/ethanol/manhattan
	name = "Manhattan"
	id = "manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	taste_description = "mild dryness"
	color = "#C13600"
	strength = 15

	glass_name = "Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."

/datum/reagent/ethanol/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	taste_description = "death, the destroyer of worlds"
	color = "#C15D00"
	strength = 10
	druggy = 30

	glass_name = "Manhattan Project"
	glass_desc = "A scientist's drink of choice, for thinking how to blow up the station."

/datum/reagent/ethanol/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	taste_description = "hair on your chest and your chin"
	color = "#4C3100"
	strength = 25

	glass_name = "The Manly Dorf"
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."

/datum/reagent/ethanol/margarita
	name = "Margarita"
	id = "margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	taste_description = "dry and salty"
	color = "#8CFF8C"
	strength = 15

	glass_name = "margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"

/datum/reagent/ethanol/mead
	name = "Mead"
	id = "mead"
	description = "A Viking's drink, though a cheap one."
	taste_description = "sweet yet alcoholic"
	reagent_state = LIQUID
	color = "#FFBB00"
	strength = 30
	nutriment_factor = 1

	glass_name = "mead"
	glass_desc = "A Viking's beverage, though a cheap one."

/datum/reagent/ethanol/moonshine
	name = "Moonshine"
	id = "moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_description = "bitterness"
	taste_mult = 2.5
	color = "#0064C8"
	strength = 12

	glass_name = "moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "a numbing sensation"
	reagent_state = LIQUID
	color = "#2E2E61"
	strength = 10

	glass_name = "Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list("neuroright")

/datum/reagent/ethanol/neurotoxin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.Weaken(3)

/datum/reagent/ethanol/patron
	name = "Patron"
	id = "patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	taste_description = "metallic paint thinner"
	color = "#585840"
	strength = 30

	glass_name = "Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."

/datum/reagent/ethanol/pwine
	name = "Poison Wine"
	id = "pwine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	color = "#000000"
	strength = 10
	druggy = 50
	halluci = 10

	glass_name = "???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"

/datum/reagent/ethanol/pwine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(dose > 30)
		M.adjustToxLoss(2 * removed)
	if(dose > 60 && ishuman(M) && prob(5))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/L = H.internal_organs_by_name[O_HEART]
		if (L && istype(L))
			if(dose < 120)
				L.take_damage(10 * removed, 0)
			else
				L.take_damage(100, 0)

/datum/reagent/ethanol/red_mead
	name = "Red Mead"
	id = "red_mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	taste_description = "sweet and salty alcohol"
	color = "#C73C00"
	strength = 30

	glass_name = "red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."

/datum/reagent/ethanol/sbiten
	name = "Sbiten"
	id = "sbiten"
	description = "A spicy Vodka! Might be a bit hot for the little guys!"
	taste_description = "hot and spice"
	color = "#FFA371"
	strength = 15
	adj_temp = 50
	targ_temp = 360

	glass_name = "Sbiten"
	glass_desc = "A spicy mix of Vodka and Spice. Very hot."

/datum/reagent/ethanol/screwdrivercocktail
	name = "Screwdriver"
	id = "screwdrivercocktail"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	taste_description = "oranges"
	color = "#A68310"
	strength = 15

	glass_name = "Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."

/datum/reagent/ethanol/silencer
	name = "Silencer"
	id = "silencer"
	description = "A drink from Mime Heaven."
	taste_description = "a pencil eraser"
	taste_mult = 1.2
	nutriment_factor = 1
	color = "#FFFFFF"
	strength = 12

	glass_name = "Silencer"
	glass_desc = "A drink from mime Heaven."

/datum/reagent/ethanol/singulo
	name = "Singulo"
	id = "singulo"
	description = "A blue-space beverage!"
	taste_description = "concentrated matter"
	color = "#2E6671"
	strength = 10

	glass_name = "Singulo"
	glass_desc = "A blue-space beverage."

/datum/reagent/ethanol/snowwhite
	name = "Snow White"
	id = "snowwhite"
	description = "A cold refreshment"
	taste_description = "refreshing cold"
	color = "#FFFFFF"
	strength = 30

	glass_name = "Snow White"
	glass_desc = "A cold refreshment."

/datum/reagent/ethanol/suidream
	name = "Sui Dream"
	id = "suidream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	taste_description = "fruit"
	color = "#00A86B"
	strength = 100

	glass_name = "Sui Dream"
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."

/datum/reagent/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	description = "Tastes like terrorism!"
	taste_description = "strong alcohol"
	color = "#2E6671"
	strength = 10

	glass_name = "Syndicate Bomb"
	glass_desc = "Tastes like terrorism!"

/datum/reagent/ethanol/tequilla_sunrise
	name = "Tequila Sunrise"
	id = "tequillasunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~."
	taste_description = "oranges"
	color = "#FFE48C"
	strength = 25

	glass_name = "Tequilla Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Earth..."

/datum/reagent/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	description = "Made for a woman, strong enough for a man."
	taste_description = "dry"
	color = "#666340"
	strength = 10
	druggy = 50

	glass_name = "Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."

/datum/reagent/ethanol/toxins_special
	name = "Toxins Special"
	id = "phoronspecial"
	description = "This thing is literally on fire!"
	taste_description = "spicy toxins"
	reagent_state = LIQUID
	color = "#7F00FF"
	strength = 10
	adj_temp = 15
	targ_temp = 330

	glass_name = "Toxins Special"
	glass_desc = "Whoah, this thing is on fire!"

/datum/reagent/ethanol/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "shaken, not stirred"
	color = "#0064C8"
	strength = 12

	glass_name = "vodka martini"
	glass_desc ="A bastardization of the classic martini. Still great."


/datum/reagent/ethanol/vodkatonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	description = "For when a gin and tonic isn't russian enough."
	taste_description = "tart bitterness"
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."


/datum/reagent/ethanol/white_russian
	name = "White Russian"
	id = "whiterussian"
	description = "That's just, like, your opinion, man..."
	taste_description = "coffee icecream"
	color = "#A68340"
	strength = 15

	glass_name = "White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."


/datum/reagent/ethanol/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	taste_description = "cola with an alcoholic undertone"
	color = "#3E1B00"
	strength = 25

	glass_name = "whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."


/datum/reagent/ethanol/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	description = "Ultimate refreshment."
	taste_description = "carbonated whiskey"
	color = "#EAB300"
	strength = 15

	glass_name = "whiskey soda"
	glass_desc = "Ultimate refreshment."

/datum/reagent/ethanol/specialwhiskey // I have no idea what this is and where it comes from
	name = "Special Blend Whiskey"
	id = "specialwhiskey"
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything. The smell of it singes your nostrils."
	taste_description = "unspeakable whiskey bliss"
	color = "#523600"
	strength = 7

	glass_name = "special blend whiskey"
	glass_desc = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."

/datum/reagent/ethanol/unathiliquor
	name = "Redeemer's Brew"
	id = "unathiliquor"
	description = "This barely qualifies as a drink, and could give jet fuel a run for its money. Also known to cause feelings of euphoria and numbness."
	taste_description = "spiced numbness"
	color = "#242424"
	strength = 5

	glass_name = "unathi liquor"
	glass_desc = "This barely qualifies as a drink, and may cause euphoria and numbness. Imbiber beware!"

/datum/reagent/ethanol/unathiliquor/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return

	var/drug_strength = 10
	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8

	M.druggy = max(M.druggy, drug_strength)
	if(prob(10) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))

/datum/reagent/ethanol/sakebomb
	name = "Sake Bomb"
	id = "sakebomb"
	description = "Alcohol in more alcohol."
	taste_description = "thick, dry alcohol"
	color = "#FFFF7F"
	strength = 12
	nutriment_factor = 1

	glass_name = "Sake Bomb"
	glass_desc = "Some sake mixed into a pint of beer."

/datum/reagent/ethanol/tamagozake
	name = "Tamagozake"
	id = "tamagozake"
	description = "Sake, egg, and sugar. A disgusting folk cure."
	taste_description = "eggy booze"
	color = "#E8C477"
	strength = 30
	nutriment_factor = 3

	glass_name = "Tamagozake"
	glass_desc = "An egg cracked into sake and sugar."

/datum/reagent/ethanol/ginzamary
	name = "Ginza Mary"
	id = "ginzamary"
	description = "An alcoholic drink made with vodka, sake, and juices."
	taste_description = "spicy tomato sake"
	color = "#FF3232"
	strength = 25

	glass_name = "Ginza Mary"
	glass_desc = "Tomato juice, vodka, and sake make something not quite completely unlike a Bloody Mary."

/datum/reagent/ethanol/tokyorose
	name = "Tokyo Rose"
	id = "tokyorose"
	description = "A pale pink cocktail made with sake and berry juice."
	taste_description = "fruity booze"
	color = "#FA8072"
	strength = 35

	glass_name = "Tokyo Rose"
	glass_desc = "It's kinda pretty!"

/datum/reagent/ethanol/saketini
	name = "Saketini"
	id = "saketini"
	description = "For when you're too weeb for a real martini."
	taste_description = "dry alcohol"
	color = "#0064C8"
	strength = 15

	glass_name = "Saketini"
	glass_desc = "What are you doing drinking this outside of New Kyoto?"

/datum/reagent/ethanol/coffee/elysiumfacepunch
	name = "Elysium Facepunch"
	id = "elysiumfacepunch"
	description = "A lothesome cocktail favored by Heaven's skeleton shift workers."
	taste_description = "sour coffee"
	color = "#8f7729"
	strength = 20

	glass_name = "Elysium Facepunch"
	glass_desc = "A lothesome cocktail favored by Heaven's skeleton shift workers."

/datum/reagent/ethanol/erebusmoonrise
	name = "Erebus Moonrise"
	id = "erebusmoonrise"
	description = "A deeply alcoholic mix, popular in Nyx."
	taste_description = "hard alcohol"
	color = "#947459"
	strength = 10

	glass_name = "Erebus Moonrise"
	glass_desc = "A deeply alcoholic mix, popular in Nyx."

/datum/reagent/ethanol/balloon
	name = "Balloon"
	id = "balloon"
	description = "A strange drink invented in the aerostats of Venus."
	taste_description = "strange alcohol"
	color = "#FAEBD7"
	strength = 66

	glass_name = "Balloon"
	glass_desc = "A strange drink invented in the aerostats of Venus."

/datum/reagent/ethanol/natunabrandy
	name = "Natuna Brandy"
	id = "natunabrandy"
	description = "On Natuna, they do the best with what they have."
	taste_description = "watered-down beer"
	color = "#FFFFCC"
	strength = 80

	glass_name = "Natuna Brandy"
	glass_desc = "On Natuna, they do the best with what they have."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/ethanol/euphoria
	name = "Euphoria"
	id = "euphoria"
	description = "Invented by a Eutopian marketing team, this is one of the most expensive cocktails in existence."
	taste_description = "impossibly rich alcohol"
	color = "#614126"
	strength = 9

	glass_name = "Euphoria"
	glass_desc = "Invented by a Eutopian marketing team, this is one of the most expensive cocktails in existence."

/datum/reagent/ethanol/xanaducannon
	name = "Xanadu Cannon"
	id = "xanaducannon"
	description = "Common in the entertainment districts of Titan."
	taste_description = "sweet alcohol"
	color = "#614126"
	strength = 50

	glass_name = "Xanadu Cannon"
	glass_desc = "Common in the entertainment districts of Titan."

/datum/reagent/ethanol/debugger
	name = "Debugger"
	id = "debugger"
	description = "From Shelf. Not for human consumption."
	taste_description = "oily bitterness"
	color = "#d3d3d3"
	strength = 32

	glass_name = "Debugger"
	glass_desc = "From Shelf. Not for human consumption."

/datum/reagent/ethanol/spacersbrew
	name = "Spacer's Brew"
	id = "spacersbrew"
	description = "Ethanol and orange soda. A common emergency drink on frontier colonies."
	taste_description = "bitter oranges"
	color = "#ffc04c"
	strength = 43

	glass_name = "Spacer's Brew"
	glass_desc = "Ethanol and orange soda. A common emergency drink on frontier colonies."

/datum/reagent/ethanol/binmanbliss
	name = "Binman Bliss"
	id = "binmanbliss"
	description = "A dry cocktail popular on Binma."
	taste_description = "very dry alcohol"
	color = "#c3c3c3"
	strength = 24

	glass_name = "Binman Bliss"
	glass_desc = "A dry cocktail popular on Binma."

/datum/reagent/ethanol/chrysanthemum
	name = "Chrysanthemum"
	id = "chrysanthemum"
	description = "An exotic cocktail from New Kyoto."
	taste_description = "fruity liquor"
	color = "#9999FF"
	strength = 35

	glass_name = "Chrysanthemum"
	glass_desc = "An exotic cocktail from New Kyoto."

/datum/reagent/ethanol/bitters
	name = "Bitters"
	id = "bitters"
	description = "A blend of fermented fruits and herbs, commonly used in cocktails."
	taste_description = "sharp bitterness"
	color = "#9b6241" // rgb(155, 98, 65)
	strength = 50

	glass_name = "Bitters"
	glass_desc = "A blend of fermented fruits and herbs, commonly used in cocktails."

/datum/reagent/ethanol/soemmerfire
	name = "Soemmer Fire"
	id = "soemmerfire"
	description = "A painfully hot mixed drink, for when you absolutely need to hurt right now."
	taste_description = "pure fire"
	color = "#d13b21" // rgb(209, 59, 33)
	strength = 25

	glass_name = "Soemmer Fire"
	glass_desc = "A painfully hot mixed drink, for when you absolutely need to hurt right now."

/datum/reagent/drink/soemmerfire/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT

/datum/reagent/ethanol/winebrandy
	name = "Wine Brandy"
	id = "winebrandy"
	description = "A premium spirit made from distilled wine."
	taste_description = "very sweet dried fruit with many elegant notes"
	color = "#4C130B" // rgb(76,19,11)
	strength = 20

	glass_name = "Wine Brandy"
	glass_desc = "A very classy looking after-dinner drink."

/datum/reagent/ethanol/morningafter
	name = "Morning After"
	id = "morningafter"
	description = "The finest hair of the dog, coming up!"
	taste_description = "bitter regrets"
	color = "#482000" // rgb(72, 32, 0)
	strength = 60

	glass_name = "Morning After"
	glass_desc = "The finest hair of the dog, coming up!"

/datum/reagent/ethanol/vesper
	name = "Vesper"
	id = "vesper"
	description = "A dry martini, ice cold and well shaken."
	taste_description = "lemony class"
	color = "#cca01c" // rgb(204, 160, 28)
	strength = 20

	glass_name = "Vesper"
	glass_desc = "A dry martini, ice cold and well shaken."

/datum/reagent/ethanol/rotgut
	name = "Rotgut Fever Dream"
	id = "rotgut"
	description = "A heinous combination of clashing flavors."
	taste_description = "plague and coldsweats"
	color = "#3a6617" // rgb(58, 102, 23)
	strength = 10

	glass_name = "Rotgut Fever Dream"
	glass_desc = "Why are you doing this to yourself?"

/datum/reagent/ethanol/voxdelight
	name = "Vox's Delight"
	id = "voxdelight"
	description = "A dangerous combination of all things flammable. Why would you drink this?"
	taste_description = "corrosive death"
	color = "#7c003a" // rgb(124, 0, 58)
	strength = 10

	glass_name = "Vox's Delight"
	glass_desc = "Not recommended if you enjoy having organs."

/datum/reagent/drink/voxdelight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	if(alien == IS_VOX)
		M.adjustToxLoss(-0.5 * removed)
		return
	M.adjustToxLoss(3 * removed)

/datum/reagent/ethanol/screamingviking
	name = "Screaming Viking"
	id = "screamingviking"
	description = "A boozy, citrus-packed brew."
	taste_description = "the bartender's frustration"
	color = "#c6c603" // rgb(198, 198, 3)
	strength = 9

	glass_name = "Screaming Viking"
	glass_desc = "A boozy, citrus-packed brew."

/datum/reagent/ethanol/robustin
	name = "Robustin"
	id = "robustin"
	description = "A bootleg brew of all the worst things on station."
	taste_description = "cough syrup and fire"
	color = "#6b0145" // rgb(107, 1, 69)
	strength = 10

	glass_name = "Robustin"
	glass_desc = "A bootleg brew of all the worst things on station."

/datum/reagent/ethanol/virginsip
	name = "Virgin Sip"
	id = "virginsip"
	description = "A perfect martini, watered down and ruined."
	taste_description = "emasculation and failure"
	color = "#2E6671" // rgb(46, 102, 113)
	strength = 60

	glass_name = "Virgin Sip"
	glass_desc = "A perfect martini, watered down and ruined."

/datum/reagent/ethanol/jellyshot
	name = "Jelly Shot"
	id = "jellyshot"
	description = "A thick and vibrant alcoholic gel, perfect for the night life."
	taste_description = "thick, alcoholic cherry gel"
	color = "#e00b0b" // rgb(224, 11, 11)
	strength = 10

	glass_name = "Jelly Shot"
	glass_desc = "A thick and vibrant alcoholic gel, perfect for the night life."

/datum/reagent/ethanol/slimeshot
	name = "Named Bullet"
	id = "slimeshot"
	description = "A thick and toxic slime jelly shot."
	taste_description = "liquified organs"
	color = "#6fa300" // rgb(111, 163, 0)
	strength = 10

	glass_name = "Named Bullet"
	glass_desc = "A thick slime jelly shot. You can feel your death approaching."

/datum/reagent/drink/slimeshot/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.reagents.add_reagent("slimejelly", 0.25)

/datum/reagent/ethanol/cloverclub
	name = "Clover Club"
	id = "cloverclub"
	description = "A light and refreshing rasberry cocktail."
	taste_description = "sweet raspberry"
	color = "#dd00a6" // rgb(221, 0, 166)
	strength = 30

	glass_name = "Clover Club"
	glass_desc = "A light and refreshing rasberry cocktail."

/datum/reagent/ethanol/negroni
	name = "Negroni"
	id = "negroni"
	description = "A dark, complicated mix of gin and campari... classy."
	taste_description = "summer nights and wood smoke"
	color = "#77000d" // rgb(119, 0, 13)
	strength = 25

	glass_name = "Negroni"
	glass_desc = "A dark, complicated blend, perfect for relaxing nights by the fire."

/datum/reagent/ethanol/whiskeysour
	name = "Whiskey Sour"
	id = "whiskeysour"
	description = "A smokey, refreshing lemoned whiskey."
	taste_description = "smoke and citrus"
	color = "#a0692e" // rgb(160, 105, 46)
	strength = 20

	glass_name = "Whiskey Sour"
	glass_desc = "A smokey, refreshing lemoned whiskey."

/datum/reagent/ethanol/oldfashioned
	name = "Old Fashioned"
	id = "oldfashioned"
	description = "A classic mix of whiskey and sugar... simple and direct."
	taste_description = "smokey, divine whiskey"
	color = "#774410" // rgb(119, 68, 16)
	strength = 15

	glass_name = "Old Fashioned"
	glass_desc = "A classic mix of whiskey and sugar... simple and direct."

/datum/reagent/ethanol/daiquiri
	name = "Daiquiri"
	id = "daiquiri"
	description = "Refeshing rum and citrus. Time for a tropical get away."
	taste_description = "refreshing citrus and rum"
	color = "#d1ff49" // rgb(209, 255, 73
	strength = 25

	glass_name = "Daiquiri"
	glass_desc = "Refeshing rum and citrus. Time for a tropical get away."

/datum/reagent/ethanol/mojito
	name = "Mojito"
	id = "mojito"
	description = "Minty rum and citrus, made for sailing."
	taste_description = "minty rum and lime"
	color = "#d1ff49" // rgb(209, 255, 73
	strength = 30

	glass_name = "Mojito"
	glass_desc = "Minty rum and citrus, made for sailing."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/ethanol/paloma
	name = "Paloma"
	id = "paloma"
	description = "Tequila and citrus, iced just right..."
	taste_description = "grapefruit and cold fire"
	color = "#ffb070" // rgb(255, 176, 112)
	strength = 20

	glass_name = "Paloma"
	glass_desc = "Tequila and citrus, iced just right..."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/ethanol/piscosour
	name = "Pisco Sour"
	id = "piscosour"
	description = "Wine Brandy, Lemon, and a dream. A South American classic"
	taste_description = "light sweetness"
	color = "#f9f96b" // rgb(249, 249, 107)
	strength = 30

	glass_name = "Pisco Sour"
	glass_desc = "South American bliss, served ice cold."

/datum/reagent/ethanol/coldfront
	name = "Cold Front"
	id = "coldfront"
	description = "Minty, rich, and painfully cold. It's a blizzard in a cup."
	taste_description = "biting cold"
	color = "#ffe8c4" // rgb(255, 232, 196)
	strength = 30
	adj_temp = -20
	targ_temp = 220 //Dangerous to certain races. Drink in moderation.

	glass_name = "Cold Front"
	glass_desc = "Minty, rich, and painfully cold. It's a blizzard in a cup."

/datum/reagent/ethanol/mintjulep
	name = "Mint Julep"
	id = "mintjulep"
	description = "Minty and refreshing, perfect for a hot day."
	taste_description = "refreshing mint"
	color = "#bbfc8a" // rgb(187, 252, 138)
	strength = 25
	adj_temp = -5

	glass_name = "Mint Julep"
	glass_desc = "Minty and refreshing, perfect for a hot day."

/datum/reagent/ethanol/godsake
	name = "Gods Sake"
	id = "godsake"
	description = "Anime's favorite drink."
	taste_description = "the power of god and anime"
	color = "#DDDDDD"
	strength = 25

	glass_name = "God's Sake"
	glass_desc = "A glass of sake."

/datum/reagent/ethanol/godka
	name = "Godka"
	id = "godka"
	description = "Number one drink AND fueling choice for Russians multiverse-wide."
	taste_description = "russian steel and a hint of grain"
	color = "#0064C8"
	strength = 50

	glass_name = "Godka"
	glass_desc = "The glass is barely able to contain the wodka. Xynta."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/ethanol/godka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.apply_effect(max(M.radiation - 5 * removed, 0), IRRADIATE, check_protection = 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.has_organ[O_LIVER])
			var/obj/item/organ/L = H.internal_organs_by_name[O_LIVER]
			if(!L)
				return
			var/adjust_liver = rand(-3, 2)
			if(prob(L.damage))
				to_chat(M, "<span class='cult'>You feel woozy...</span>")
			L.damage = max(L.damage + (adjust_liver * removed), 0)
	var/adjust_tox = rand(-4, 2)
	M.adjustToxLoss(adjust_tox * removed)

/datum/reagent/ethanol/holywine
	name = "Angel Ichor"
	id = "holywine"
	description = "A premium alchoholic beverage made from distilled angel blood."
	taste_description = "wings in a glass, and a hint of grape"
	color = "#C4921E"
	strength = 20

	glass_name = "Angel Ichor"
	glass_desc = "A very pious looking drink."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/ethanol/holy_mary
	name = "Holy Mary"
	id = "holymary"
	description = "A strange yet pleasurable mixture made of vodka, angel's ichor and lime juice. Or at least you THINK the yellow stuff is angel's ichor."
	taste_description = "grapes with a hint of lime"
	color = "#DCAE12"
	strength = 20

	glass_name = "Holy Mary"
	glass_desc = "Angel's Ichor, mixed with Vodka and a lil' bit of lime. Tastes like liquid ascension."

/datum/reagent/ethanol/angelswrath
	name = "Angels Wrath"
	id = "angelswrath"
	description = "This thing makes the hair on the back of your neck stand up."
	taste_description = "sweet victory and sour iron"
	taste_mult = 1.5
	color = "#F3C906"
	strength = 30

	glass_name = "Angels' Wrath"
	glass_desc = "Just looking at this thing makes you sweat."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)

/datum/reagent/ethanol/angelskiss
	name = "Angels Kiss"
	id = "angelskiss"
	description = "Miracle time!"
	taste_description = "sweet forgiveness and bitter iron"
	color = "#AD772B"
	strength = 25

	glass_name = "Angel's Kiss"
	glass_desc = "Miracle time!"

/datum/reagent/ethanol/ichor_mead
	name = "Ichor Mead"
	id = "ichor_mead"
	description = "A trip to Valhalla."
	taste_description = "valhalla"
	color = "#955B37"
	strength = 30

	glass_name = "Ichor Mead"
	glass_desc = "A trip to Valhalla."

/datum/reagent/ethanol/schnapps_pep
	name = "Peppermint Schnapps"
	id = "schnapps_pep"
	description = "Achtung, pfefferminze."
	taste_description = "minty alcohol"
	color = "#8FC468"
	strength = 25

	glass_name = "peppermint schnapps"
	glass_desc = "A glass of peppermint schnapps. It seems like it'd be better, mixed."

/datum/reagent/ethanol/schnapps_pea
	name = "Peach Schnapps"
	id = "schnapps_pea"
	description = "Achtung, fruchtig."
	taste_description = "peaches"
	color = "#d67d4d"
	strength = 25

	glass_name = "peach schnapps"
	glass_desc = "A glass of peach schnapps. It seems like it'd be better, mixed."

/datum/reagent/ethanol/schnapps_lem
	name = "Lemonade Schnapps"
	id = "schnapps_lem"
	description = "Childhood memories are not included."
	taste_description = "sweet, lemon-y alcohol"
	color = "#FFFF00"
	strength = 25

	glass_name = "lemonade schnapps"
	glass_desc = "A glass of lemonade schnapps. It seems like it'd be better, mixed."

/datum/reagent/ethanol/fusionnaire
	name = "Fusionnaire"
	id = "fusionnaire"
	description = "A drink for the brave."
	taste_description = "a painfully alcoholic lemon soda with an undertone of mint"
	color = "#6BB486"
	strength = 9

	glass_name = "fusionnaire"
	glass_desc = "A relatively new cocktail, mostly served in the bars of NanoTrasen owned stations."

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

/datum/reagent/nutriment/magicdust
	name = "Magic Dust"
	id = "magicdust"
	description = "A dust harvested from gnomes, aptly named by pre-industrial civilizations."
	taste_description = "something tingly"
	taste_mult = 2
	reagent_state = LIQUID
	nutriment_factor = 40 //very filling
	color = "#d169b2"
