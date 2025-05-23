/* Food */

/datum/reagent/nutriment
	name = REAGENT_NUTRIMENT
	id = REAGENT_ID_NUTRIMENT
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	reagent_state = SOLID
	metabolism = REM * 4
	ingest_met = REM * 4
	var/nutriment_factor = 30 // Per unit
	var/injectable = 0
	color = "#664330"
	affects_robots = 1	//VOREStation Edit

/datum/reagent/nutriment/mix_data(var/list/newdata, var/newamount)

	if(!islist(newdata) || !newdata.len)
		return

	//add the new taste data
	if(islist(data))
		for(var/taste in newdata)
			if(taste in data)
				data[taste] += newdata[taste]
			else
				data[taste] = newdata[taste]
	else
		initialize_data(newdata)

	//cull all tastes below 10% of total
	var/totalFlavor = 0
	for(var/taste in data)
		totalFlavor += data[taste]
	if(totalFlavor) //Let's not divide by zero for things w/o taste
		for(var/taste in data)
			if(data[taste]/totalFlavor < 0.1)
				data -= taste

/datum/reagent/nutriment/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!injectable && alien != IS_SLIME && alien != IS_CHIMERA && !M.isSynthetic()) //VOREStation Edit
		M.adjustToxLoss(0.1 * removed)
		return
	affect_ingest(M, alien, removed)
	//VOREStation Edits Start
	if(M.isSynthetic())
		M.adjust_nutrition((nutriment_factor * removed) * M.species.synthetic_food_coeff)
	//VOREStation Edits End
	..()

/datum/reagent/nutriment/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
		if(IS_DIONA) return
		if(IS_UNATHI) removed *= 0.5
		if(IS_CHIMERA) removed *= 0.25 //VOREStation Edit
	if(issmall(M)) removed *= 2 // Small bodymass, more effect from lower volume.
	//VOREStation Edits Start
	if(!M.isSynthetic())
		if(!(M.species.allergens & allergen_type))	//assuming it doesn't cause a horrible reaction, we'll be ok!
			M.heal_organ_damage(0.5 * removed, 0)
			M.adjust_nutrition(((nutriment_factor + M.food_preference(allergen_type)) * removed) * M.species.organic_food_coeff) //RS edit
			M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)
	else
		M.adjust_nutrition(((nutriment_factor + M.food_preference(allergen_type)) * removed) * M.species.synthetic_food_coeff) //RS edit

	//VOREStation Edits Stop

// Aurora Cooking Port Insertion Begin

/*
	Coatings are used in cooking. Dipping food items in a reagent container with a coating in it
	allows it to be covered in that, which will add a masked overlay to the sprite.
	Coatings have both a raw and a cooked image. Raw coating is generally unhealthy
	Generally coatings are intended for deep frying foods
*/
/datum/reagent/nutriment/coating
	name = REAGENT_COATING
	id = REAGENT_ID_COATING
	nutriment_factor = 6 //Less dense than the food itself, but coatings still add extra calories
	var/messaged = 0
	var/icon_raw
	var/icon_cooked
	var/coated_adj = "coated"
	var/cooked_name = "coating"

/datum/reagent/nutriment/coating/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)

	//We'll assume that the batter isnt going to be regurgitated and eaten by someone else. Only show this once
	if(data["cooked"] != 1)
		if (!messaged)
			to_chat(M, span_warning("Ugh, this raw [name] tastes disgusting."))
			nutriment_factor *= 0.5
			messaged = 1

		//Raw coatings will sometimes cause vomiting. 75% chance of this happening.
		if(prob(75))
			M.vomit()
	..()

/datum/reagent/nutriment/coating/initialize_data(var/newdata) // Called when the reagent is created.
	..()
	if (!data)
		data = list()
	else
		if (isnull(data["cooked"]))
			data["cooked"] = 0
		return
	data["cooked"] = 0
	if (holder && holder.my_atom && istype(holder.my_atom,/obj/item/reagent_containers/food/snacks))
		data["cooked"] = 1
		name = cooked_name

		//Batter which is part of objects at compiletime spawns in a cooked state


//Handles setting the temperature when oils are mixed
/datum/reagent/nutriment/coating/mix_data(var/newdata, var/newamount)
	if (!data)
		data = list()

	data["cooked"] = newdata["cooked"]

/datum/reagent/nutriment/coating/batter
	name = REAGENT_BATTER
	cooked_name = REAGENT_ID_BATTER
	id = REAGENT_ID_BATTER
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "battered"
	allergen_type = ALLERGEN_GRAINS | ALLERGEN_EGGS //Made with flour(grain), and eggs(eggs)

/datum/reagent/nutriment/coating/beerbatter
	name = REAGENT_BEERBATTER
	cooked_name = "beer batter"
	id = REAGENT_ID_BEERBATTER
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "beer-battered"
	allergen_type = ALLERGEN_GRAINS | ALLERGEN_EGGS //Made with flour(grain), eggs(eggs), and beer(grain)

/datum/reagent/nutriment/coating/beerbatter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_ALCOHOL, 0.02) //Very slightly alcoholic

//=========================
//Fats
//=========================
/datum/reagent/nutriment/triglyceride
	name = REAGENT_TRIGLYCERIDE
	id = REAGENT_ID_TRIGLYCERIDE
	description = "More commonly known as fat, the third macronutrient, with over double the energy content of carbs and protein"

	reagent_state = SOLID
	taste_description = "greasiness"
	taste_mult = 0.1
	nutriment_factor = 27//The caloric ratio of carb/protein/fat is 4:4:9
	color = "#CCCCCC"

/datum/reagent/nutriment/triglyceride/oil
	//Having this base class incase we want to add more variants of oil
	name = REAGENT_OIL
	id = REAGENT_ID_OIL
	description = "Oils are liquid fats."
	reagent_state = LIQUID
	taste_description = "oil"
	color = "#c79705"
	touch_met = 1.5
	var/lastburnmessage = 0

/datum/reagent/nutriment/triglyceride/oil/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	..()

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if(volume >= 3)
		T.wet_floor(2)

/datum/reagent/nutriment/triglyceride/oil/initialize_data(var/newdata) // Called when the reagent is created.
	..()
	if (!data)
		data = list("temperature" = T20C)

//Handles setting the temperature when oils are mixed
/datum/reagent/nutriment/triglyceride/oil/mix_data(var/newdata, var/newamount)

	if (!data)
		data = list()

	var/ouramount = volume - newamount
	if (ouramount <= 0 || !data["temperature"] || !volume)
		//If we get here, then this reagent has just been created, just copy the temperature exactly
		data["temperature"] = newdata["temperature"]

	else
		//Our temperature is set to the mean of the two mixtures, taking volume into account
		var/total = (data["temperature"] * ouramount) + (newdata["temperature"] * newamount)
		data["temperature"] = total / volume

	return ..()


//Calculates a scaling factor for scalding damage, based on the temperature of the oil and creature's heat resistance
/datum/reagent/nutriment/triglyceride/oil/proc/heatdamage(var/mob/living/carbon/M)
	var/threshold = 360//Human heatdamage threshold
	var/datum/species/S = M.get_species(1)
	if (S && istype(S))
		threshold = S.heat_level_1

	//If temperature is too low to burn, return a factor of 0. no damage
	if (data["temperature"] < threshold)
		return 0

	//Step = degrees above heat level 1 for 1.0 multiplier
	var/step = 60
	if (S && istype(S))
		step = (S.heat_level_2 - S.heat_level_1)*1.5

	. = data["temperature"] - threshold
	. /= step
	. = min(., 2.5)//Cap multiplier at 2.5

/datum/reagent/nutriment/triglyceride/oil/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/dfactor = heatdamage(M)
	if (dfactor)
		M.take_organ_damage(0, removed * 1.5 * dfactor)
		data["temperature"] -= (6 * removed) / (1 + volume*0.1)//Cools off as it burns you
		if (lastburnmessage+100 < world.time	)
			to_chat(M, span_danger("Searing hot oil burns you, wash it off quick!"))
			lastburnmessage = world.time

/datum/reagent/nutriment/triglyceride/oil/cooking
	name = REAGENT_COOKINGOIL
	id = REAGENT_ID_COOKINGOIL
	description = "A general-purpose cooking oil."
	reagent_state = LIQUID

/datum/reagent/nutriment/triglyceride/oil/corn
	name = REAGENT_CORNOIL
	id = REAGENT_ID_CORNOIL
	description = "An oil derived from various types of corn."
	reagent_state = LIQUID
	allergen_type = ALLERGEN_VEGETABLE //Corn is a vegetable

/datum/reagent/nutriment/triglyceride/oil/peanut
	name = REAGENT_PEANUTOIL
	id = REAGENT_ID_PEANUTOIL
	description = "An oil derived from various types of nuts."
	taste_description = "nuts"
	taste_mult = 0.3
	nutriment_factor = 15
	color = "#4F3500"
	allergen_type = ALLERGEN_SEEDS //Peanut oil would come from peanuts, hence seeds.

// Aurora Cooking Port Insertion End

/datum/reagent/nutriment/glucose
	name = REAGENT_GLUCOSE
	id = REAGENT_ID_GLUCOSE
	taste_description = "sweetness"
	color = "#FFFFFF"
	cup_prefix = "sweetened"

	injectable = 1

/datum/reagent/nutriment/protein // Bad for Skrell!
	name = REAGENT_PROTEIN
	id = REAGENT_ID_PROTEIN
	taste_description = "some sort of meat"
	color = "#440000"
	allergen_type = ALLERGEN_MEAT //"Animal protein" implies it comes from animals, therefore meat.

/datum/reagent/nutriment/protein/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
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

/datum/reagent/nutriment/protein/tofu
	name = REAGENT_TOFU
	id = REAGENT_ID_TOFU
	color = "#fdffa8"
	taste_description = "tofu"
	allergen_type = ALLERGEN_BEANS //Made from soy beans

/datum/reagent/nutriment/protein/seafood
	name = REAGENT_SEAFOOD
	id = REAGENT_ID_SEAFOOD
	color = "#f5f4e9"
	taste_description = "fish"
	allergen_type = ALLERGEN_FISH //I suppose the fish allergy likely refers to seafood in general.

/datum/reagent/nutriment/protein/cheese
	name = REAGENT_CHEESE
	id = REAGENT_ID_CHEESE
	color = "#EDB91F"
	taste_description = "cheese"
	allergen_type = ALLERGEN_DAIRY //Cheese is made from dairy
	cup_prefix = "cheesy"

/datum/reagent/nutriment/protein/egg
	name = REAGENT_EGG
	id = REAGENT_ID_EGG
	taste_description = "egg"
	color = "#FFFFAA"
	allergen_type = ALLERGEN_EGGS //Eggs contain egg
	cup_prefix = "eggy"

/datum/reagent/nutriment/protein/murk
	name = REAGENT_MURK_PROTEIN
	id = REAGENT_ID_MURK_PROTEIN
	taste_description = "mud"
	color = "#664330"
	allergen_type = ALLERGEN_FISH //Murkfin is fish

/datum/reagent/nutriment/protein/bean
	name = REAGENT_BEANPROTEIN
	id = REAGENT_ID_BEANPROTEIN
	taste_description = "beans"
	color = "#562e0b"
	allergen_type = ALLERGEN_BEANS //Made from soy beans

/datum/reagent/nutriment/honey
	name = REAGENT_HONEY
	id = REAGENT_ID_HONEY
	description = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 10
	color = "#FFFF00"
	cup_prefix = REAGENT_ID_HONEY

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
			M.Sleeping(20)
			M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/nutriment/mayo
	name = REAGENT_MAYO
	id = REAGENT_ID_MAYO
	description = "A thick, bitter sauce."
	taste_description = "unmistakably mayonnaise"
	nutriment_factor = 10
	color = "#FFFFFF"
	allergen_type = ALLERGEN_EGGS	//Mayo is made from eggs
	cup_prefix = REAGENT_ID_MAYO

/datum/reagent/nutriment/yeast
	name = REAGENT_YEAST
	id = REAGENT_ID_YEAST
	description = "For making bread rise!"
	taste_description = "yeast"
	nutriment_factor = 1
	color = "#D3AF70"

/datum/reagent/nutriment/flour
	name = REAGENT_FLOUR
	id = REAGENT_ID_FLOUR
	description = "This is what you rub all over yourself to pretend to be a ghost."
	taste_description = "chalky wheat"
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"
	allergen_type = ALLERGEN_GRAINS //Flour is made from grain

/datum/reagent/nutriment/flour/touch_turf(var/turf/simulated/T)
	..()
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/flour(T)

/datum/reagent/nutriment/coffee
	name = REAGENT_COFFEEPOWDER
	id = REAGENT_ID_COFFEEPOWDER
	description = "A bitter powder made by grinding coffee beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#482000"
	allergen_type = ALLERGEN_COFFEE | ALLERGEN_STIMULANT //Again, coffee contains coffee

/datum/reagent/nutriment/tea
	name = REAGENT_TEAPOWDER
	id = REAGENT_ID_TEAPOWDER
	description = "A dark, tart powder made from black tea leaves."
	taste_description = "tartness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#101000"
	allergen_type = ALLERGEN_STIMULANT //Strong enough to contain caffeine

/datum/reagent/nutriment/decaf_tea
	name = REAGENT_DECAFTEAPOWDER
	id = REAGENT_ID_DECAFTEAPOWDER
	description = "A dark, tart powder made from black tea leaves, treated to remove caffeine content."
	taste_description = "tartness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#101000"

/datum/reagent/nutriment/coco
	name = REAGENT_COCO
	id = REAGENT_ID_COCO
	description = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#302000"
	allergen_type = ALLERGEN_CHOCOLATE
	cup_prefix = REAGENT_ID_COCO

/datum/reagent/nutriment/chocolate
	name = REAGENT_CHOCOLATE
	id = REAGENT_ID_CHOCOLATE
	description = "Great for cooking or on its own!"
	taste_description = "chocolate"
	color = "#582815"
	nutriment_factor = 5
	taste_mult = 1.3
	allergen_type = ALLERGEN_CHOCOLATE
	cup_prefix = REAGENT_ID_CHOCOLATE

/datum/reagent/nutriment/instantjuice
	name = REAGENT_INSTANTJUICE
	id = REAGENT_ID_INSTANTJUICE
	description = "Dehydrated, powdered juice of some kind."
	taste_mult = 1.3
	nutriment_factor = 1
	allergen_type = ALLERGEN_FRUIT //I suppose it's implied here that the juice is from dehydrated fruit.

/datum/reagent/nutriment/instantjuice/grape
	name = REAGENT_INSTANTGRAPE
	id = REAGENT_ID_INSTANTGRAPE
	description = "Dehydrated, powdered grape juice."
	taste_description = "dry grapes"
	color = "#863333"
	cup_prefix = "grape"

/datum/reagent/nutriment/instantjuice/orange
	name = REAGENT_INSTANTORANGE
	id = REAGENT_ID_INSTANTORANGE
	description = "Dehydrated, powdered orange juice."
	taste_description = "dry oranges"
	color = "#e78108"
	cup_prefix = "orange"

/datum/reagent/nutriment/instantjuice/watermelon
	name = REAGENT_INSTANTWATERMELON
	id = REAGENT_ID_INSTANTWATERMELON
	description = "Dehydrated, powdered watermelon juice."
	taste_description = "dry sweet watermelon"
	color = "#b83333"
	cup_prefix = "melon"

/datum/reagent/nutriment/instantjuice/apple
	name = REAGENT_INSTANTAPPLE
	id = REAGENT_ID_INSTANTAPPLE
	description = "Dehydrated, powdered apple juice."
	taste_description = "dry sweet apples"
	color = "#c07c40"
	cup_prefix = "apple"

/datum/reagent/nutriment/soysauce
	name = REAGENT_SOYSAUCE
	id = REAGENT_ID_SOYSAUCE
	description = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#792300"
	allergen_type = ALLERGEN_BEANS //Soy (beans)
	cup_prefix = "umami"

/datum/reagent/nutriment/vinegar
	name = REAGENT_VINEGAR
	id = REAGENT_ID_VINEGAR
	description = "vinegar, great for fish and pickles."
	taste_description = "vinegar"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#54410C"
	cup_prefix = "acidic"

/datum/reagent/nutriment/ketchup
	name = REAGENT_KETCHUP
	id = REAGENT_ID_KETCHUP
	description = "Ketchup, catsup, whatever. It's tomato paste."
	taste_description = "ketchup"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#731008"
	allergen_type = ALLERGEN_FRUIT 	//Tomatoes are a fruit.
	cup_prefix = "tomato"

/datum/reagent/nutriment/mustard
	name = REAGENT_MUSTARD
	id = REAGENT_ID_MUSTARD
	description = "Delicious mustard. Good on Hot Dogs."
	taste_description = "mustard"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#E3BD00"
	cup_prefix = REAGENT_ID_MUSTARD

/datum/reagent/nutriment/barbecue
	name = REAGENT_BARBECUE
	id = REAGENT_ID_BARBECUE
	description = "Barbecue sauce for barbecues and long shifts."
	taste_description = "barbeque"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#4F330F"
	cup_prefix = REAGENT_ID_BARBECUE

/datum/reagent/nutriment/rice
	name = REAGENT_RICE
	id = REAGENT_ID_RICE
	description = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"

/datum/reagent/nutriment/cherryjelly
	name = REAGENT_CHERRYJELLY
	id = REAGENT_ID_CHERRYJELLY
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#801E28"
	allergen_type = ALLERGEN_FRUIT //Cherries are fruits

/datum/reagent/nutriment/peanutbutter
	name = REAGENT_PEANUTBUTTER
	id = REAGENT_ID_PEANUTBUTTER
	description = "A butter derived from various types of nuts."
	taste_description = "peanuts"
	taste_mult = 0.5
	reagent_state = LIQUID
	nutriment_factor = 30
	color = "#4F3500"
	allergen_type = ALLERGEN_SEEDS //Peanuts(seeds)
	cup_prefix = "peanut butter"

/datum/reagent/nutriment/vanilla
	name = REAGENT_VANILLA
	id = REAGENT_ID_VANILLA
	description = "Vanilla extract. Tastes suspiciously like boring ice-cream."
	taste_description = "vanilla"
	taste_mult = 5
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#0F0A00"
	cup_prefix = REAGENT_ID_VANILLA

/datum/reagent/nutriment/durian
	name = REAGENT_DURIANPASTE
	id = REAGENT_ID_DURIANPASTE
	description = "A strangely sweet and savory paste."
	taste_description = "sweet and savory"
	color = "#757631"

	glass_name = "durian paste"
	glass_desc = "Durian paste. It smells horrific."

/datum/reagent/nutriment/durian/touch_mob(var/mob/M, var/amount)
	..()
	if(iscarbon(M) && !M.isSynthetic())
		var/message = pick("Oh god, it smells disgusting here.", "What is that stench?", "That's an awful odor.")
		to_chat(M, span_alien("[message]"))
		if(prob(CLAMP(amount, 5, 90)))
			var/mob/living/L = M
			L.vomit()
	return ..()

/datum/reagent/nutriment/durian/touch_turf(var/turf/T, var/amount)
	..()
	if(istype(T))
		var/obj/effect/decal/cleanable/chemcoating/C = new /obj/effect/decal/cleanable/chemcoating(T)
		C.reagents.add_reagent(id, amount)
	return ..()

/datum/reagent/nutriment/virus_food
	name = REAGENT_VIRUSFOOD
	id = REAGENT_ID_VIRUSFOOD
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	taste_description = "vomit"
	taste_mult = 2
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#899613"
	allergen_type = ALLERGEN_DAIRY	//incase anyone is dumb enough to drink it - it does contain milk!

/datum/reagent/nutriment/sprinkles
	name = REAGENT_SPRINKLES
	id = REAGENT_ID_SPRINKLES
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "sugar"
	nutriment_factor = 1
	color = "#FF00FF"
	cup_prefix = "sprinkled"

/datum/reagent/nutriment/mint
	name = REAGENT_MINT
	id = REAGENT_ID_MINT
	description = "Also known as Mentha."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#CF3600"
	cup_prefix = "minty"

/datum/reagent/lipozine // The anti-nutriment.
	name = REAGENT_LIPOZINE
	id = REAGENT_ID_LIPOZINE
	description = "A chemical compound that causes a powerful fat-burning reaction."
	taste_description = "mothballs"
	reagent_state = LIQUID
	color = "#BBEDA4"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(-10 * removed)

/* Non-food stuff like condiments */

/datum/reagent/sodiumchloride
	name = REAGENT_SODIUMCHLORIDE
	id = REAGENT_ID_SODIUMCHLORIDE
	description = "A salt made of sodium chloride. Commonly used to season food."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE
	ingest_met = REM
	cup_prefix = "salty"

/datum/reagent/sodiumchloride/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed)

/datum/reagent/sodiumchloride/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	var/pass_mod = rand(3,5)
	var/passthrough = (removed - (removed/pass_mod)) //Some may be nullified during consumption, between one third and one fifth.
	affect_blood(M, alien, passthrough)

/datum/reagent/blackpepper
	name = REAGENT_BLACKPEPPER
	id = REAGENT_ID_BLACKPEPPER
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	taste_description = "pepper"
	reagent_state = SOLID
	ingest_met = REM
	color = "#000000"
	cup_prefix = "peppery"

/datum/reagent/enzyme
	name = REAGENT_ENZYME
	id = REAGENT_ID_ENZYME
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	taste_description = "sweetness"
	taste_mult = 0.7
	reagent_state = LIQUID
	color = "#365E30"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/spacespice
	name = REAGENT_SPACESPICE
	id = REAGENT_ID_SPACESPICE
	description = "An exotic blend of spices for cooking. Definitely not worms."
	reagent_state = SOLID
	color = "#e08702"
	cup_prefix = "spicy"

/datum/reagent/browniemix
	name = REAGENT_BROWNIEMIX
	id = REAGENT_ID_BROWNIEMIX
	description = "A dry mix for making delicious brownies."
	reagent_state = SOLID
	color = "#441a03"
	allergen_type = ALLERGEN_CHOCOLATE

/datum/reagent/cakebatter
	name = REAGENT_CAKEBATTER
	id = REAGENT_ID_CAKEBATTER
	description = "A batter for making delicious cakes."
	reagent_state = LIQUID
	color = "#F0EDDA"

/datum/reagent/frostoil
	name = REAGENT_FROSTOIL
	id = REAGENT_ID_FROSTOIL
	description = "A special oil that noticably chills the body. Extracted from Ice Peppers."
	taste_description = "mint"
	taste_mult = 1.5
	reagent_state = LIQUID
	ingest_met = REM
	color = "#B31008"

/datum/reagent/frostoil/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.bodytemperature = min(M.bodytemperature, max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 215))
	if(prob(1))
		M.emote("shiver")
	holder.remove_reagent(REAGENT_ID_CAPSAICIN, 5)

/datum/reagent/frostoil/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed) // Eating frostoil now acts like capsaicin. Wee!
	if(alien == IS_DIONA)
		return
	if(alien == IS_ALRAUNE) // VOREStation Edit: It wouldn't affect plants that much.
		if(prob(5))
			to_chat(M, span_rose("You feel a chilly, tingling sensation in your mouth."))
		M.bodytemperature -= rand(10, 25)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	var/effective_dose = (dose * M.species.spice_mod)
	if((effective_dose < 5) && (dose == metabolism || prob(5)))
		to_chat(M, span_danger("Your insides suddenly feel a spreading chill!"))
	if(effective_dose >= 5)
		M.apply_effect(2 * M.species.spice_mod, AGONY, 0)
		M.bodytemperature -= rand(1, 5) * M.species.spice_mod // Really fucks you up, cause it makes you cold.
		if(prob(5))
			M.visible_message(span_warning("[M] [pick("dry heaves!","coughs!","splutters!")]"), pick(span_danger("You feel like your insides are freezing!"), span_danger("Your insides feel like they're turning to ice!")))
	// holder.remove_reagent(REAGENT_ID_CAPSAICIN, 5) // VOREStation Edit: Nop, we don't instadelete spices for free.

/datum/reagent/frostoil/cryotoxin //A longer lasting version of frost oil.
	name = REAGENT_CRYOTOXIN
	id = REAGENT_ID_CRYOTOXIN
	description = "Lowers the body's internal temperature."
	reagent_state = LIQUID
	color = "#B31008"
	metabolism = REM * 0.5

/datum/reagent/capsaicin
	name = REAGENT_CAPSAICIN
	id = REAGENT_ID_CAPSAICIN
	description = "This is what makes chilis hot."
	taste_description = "hot peppers"
	taste_mult = 1.5
	reagent_state = LIQUID
	ingest_met = REM
	color = "#B31008"
	cup_prefix = "hot"

/datum/reagent/capsaicin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(0.5 * removed)

/datum/reagent/capsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(alien == IS_ALRAUNE) // VOREStation Edit: It wouldn't affect plants that much.
		if(prob(5))
			to_chat(M, span_rose("You feel a pleasant sensation in your mouth."))
		M.bodytemperature += rand(10, 25)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return

	var/effective_dose = (dose * M.species.spice_mod)
	if((effective_dose < 5) && (dose == metabolism || prob(5)))
		to_chat(M, span_danger("Your insides feel uncomfortably hot!"))
	if(effective_dose >= 5)
		M.apply_effect(2 * M.species.spice_mod, AGONY, 0)
		M.bodytemperature += rand(1, 5) * M.species.spice_mod // Really fucks you up, cause it makes you overheat, too.
		if(prob(5))
			M.visible_message(span_warning("[M] [pick("dry heaves!","coughs!","splutters!")]"), pick(span_danger("You feel like your insides are burning!"), span_danger("You feel like your insides are on fire!"), span_danger("You feel like your belly is full of lava!")))
	// holder.remove_reagent(REAGENT_ID_FROSTOIL, 5)  // VOREStation Edit: Nop, we don't instadelete spices for free.

/datum/reagent/condensedcapsaicin
	name = REAGENT_CONDENSEDCAPSAICIN
	id = REAGENT_ID_CONDENSEDCAPSAICIN
	description = "A chemical agent used for self-defense and in police work."
	taste_description = "fire"
	taste_mult = 10
	reagent_state = LIQUID
	touch_met = 50 // Get rid of it quickly
	ingest_met = REM
	color = "#B31008"
	cup_prefix = "dangerously hot"

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

	if(ishuman(M))
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
		to_chat(M, span_warning("Your [safe_thing] protects you from the pepperspray!"))
		if(alien != IS_SLIME)
			return
	else if(eyes_covered)
		to_chat(M, span_warning("Your [safe_thing] protects you from most of the pepperspray!"))
		M.eye_blurry = max(M.eye_blurry, effective_strength * 3)
		M.Blind(effective_strength)
		M.Stun(5)
		M.Weaken(5)
		if(alien != IS_SLIME)
			return
	else if(mouth_covered) // Mouth cover is better than eye cover
		to_chat(M, span_warning("Your [safe_thing] protects your face from the pepperspray!"))
		M.eye_blurry = max(M.eye_blurry, effective_strength)
		if(alien != IS_SLIME)
			return
	else// Oh dear :D
		to_chat(M, span_warning("You're sprayed directly in the eyes with pepperspray!"))
		M.eye_blurry = max(M.eye_blurry, effective_strength * 5)
		M.Blind(effective_strength * 2)
		M.Stun(5)
		M.Weaken(5)
		if(alien != IS_SLIME)
			return
	if(alien == IS_SLIME)
		if(!head_covered)
			if(prob(33))
				to_chat(M, span_warning("The exposed flesh on your head burns!"))
			M.apply_effect(5 * effective_strength, AGONY, 0)
		if(!chest_covered)
			if(prob(33))
				to_chat(M, span_warning("The exposed flesh on your chest burns!"))
			M.apply_effect(5 * effective_strength, AGONY, 0)
		if(!groin_covered && prob(75))
			if(prob(33))
				to_chat(M, span_warning("The exposed flesh on your groin burns!"))
			M.apply_effect(3 * effective_strength, AGONY, 0)
		if(!arms_covered && prob(45))
			if(prob(33))
				to_chat(M, span_warning("The exposed flesh on your arms burns!"))
			M.apply_effect(3 * effective_strength, AGONY, 0)
		if(!legs_covered && prob(45))
			if(prob(33))
				to_chat(M, span_warning("The exposed flesh on your legs burns!"))
			M.apply_effect(3 * effective_strength, AGONY, 0)
		if(!hands_covered && prob(20))
			if(prob(33))
				to_chat(M, span_warning("The exposed flesh on your hands burns!"))
			M.apply_effect(effective_strength / 2, AGONY, 0)
		if(!feet_covered && prob(20))
			if(prob(33))
				to_chat(M, span_warning("The exposed flesh on your feet burns!"))
			M.apply_effect(effective_strength / 2, AGONY, 0)

/datum/reagent/condensedcapsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(dose == metabolism)
		to_chat(M, span_danger("You feel like your insides are burning!"))
	else
		M.apply_effect(4, AGONY, 0)
		if(prob(5))
			M.visible_message(span_warning("[M] [pick("dry heaves!","coughs!","splutters!")]"), span_danger("You feel like your insides are burning!"))

/* Drinks */

/datum/reagent/drink
	name = REAGENT_DRINK
	id = REAGENT_ID_DRINK
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
	if(!(M.species.allergens & allergen_type))
		var/bonus = M.food_preference(allergen_type)
		M.adjust_nutrition((nutrition + bonus) * removed)
	M.dizziness = max(0, M.dizziness + adj_dizzy)
	M.drowsyness = max(0, M.drowsyness + adj_drowsy)
	M.AdjustSleeping(adj_sleepy)
	if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > 310)
		M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/drink/overdose(var/mob/living/carbon/M, var/alien) //Add special interactions here in the future if desired.
	..()

// Juices

/datum/reagent/drink/juice/banana
	name = REAGENT_BANANA
	id = REAGENT_ID_BANANA
	description = "The raw essence of a banana."
	taste_description = "banana"
	color = "#C3AF00"

	glass_name = "banana juice"
	glass_desc = "The raw essence of a banana. HONK!"
	allergen_type = ALLERGEN_FRUIT //Bananas are fruit
	cup_prefix = REAGENT_ID_BANANA

/datum/reagent/drink/juice/berry
	name = REAGENT_BERRYJUICE
	id = REAGENT_ID_BERRYJUICE
	description = "A delicious blend of several different kinds of berries."
	taste_description = "berries"
	color = "#990066"

	glass_name = "berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"
	allergen_type = ALLERGEN_FRUIT //Berries are fruit
	cup_prefix = "berry"

/datum/reagent/drink/juice/pineapple
	name = REAGENT_PINEAPPLEJUICE
	id = REAGENT_ID_PINEAPPLEJUICE
	description = "A sour but refreshing juice from a pineapple."
	taste_description = "pineapple"
	color = "#C3AF00"

	glass_name = "pineapple juice"
	glass_desc = "Pineapple juice. Or maybe it's spineapple. Who cares?"
	allergen_type = ALLERGEN_FRUIT //Pineapples are fruit
	cup_prefix = "pineapple"

/datum/reagent/drink/juice/carrot
	name = REAGENT_CARROTJUICE
	id = REAGENT_ID_CARROTJUICE
	description = "It is just like a carrot but without crunching."
	taste_description = "carrots"
	color = "#FF8C00" // rgb: 255, 140, 0

	glass_name = "carrot juice"
	glass_desc = "It is just like a carrot but without crunching."
	allergen_type = ALLERGEN_VEGETABLE //Carrots are vegetables
	cup_prefix = "carrot"

/datum/reagent/drink/juice/carrot/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.reagents.add_reagent(REAGENT_ID_IMIDAZOLINE, removed * 0.2)

/datum/reagent/drink/juice/lettuce
	name = REAGENT_LETTUCEJUICE
	id = REAGENT_ID_LETTUCEJUICE
	description = "It's mostly water, just a bit more lettucy."
	taste_description = "fresh greens"
	color = "#29df4b"

	glass_name = "lettuce juice"
	glass_desc = "This is just lettuce water. Fresh but boring."
	cup_prefix = "lettuce"

/datum/reagent/drink/juice
	name = REAGENT_GRAPEJUICE
	id = REAGENT_ID_GRAPEJUICE
	description = "It's grrrrrape!"
	taste_description = "grapes"
	color = "#863333"
	var/sugary = TRUE ///So non-sugary juices don't make Unathi snooze.

	glass_name = "grape juice"
	glass_desc = "It's grrrrrape!"
	allergen_type = ALLERGEN_FRUIT //Grapes are fruit
	cup_prefix = "grape"

/datum/reagent/drink/juice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/effective_dose = dose/2
	if(issmall(M))
		effective_dose *= 2

	if(alien == IS_UNATHI)
		if(sugary == TRUE)
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
				M.Sleeping(20)
				M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/drink/juice/lemon
	name = REAGENT_LEMONJUICE
	id = REAGENT_ID_LEMONJUICE
	description = "This juice is VERY sour."
	taste_description = "sourness"
	taste_mult = 1.1
	color = "#AFAF00"

	glass_name = "lemon juice"
	glass_desc = "Sour..."
	allergen_type = ALLERGEN_FRUIT //Lemons are fruit
	cup_prefix = "lemon"


/datum/reagent/drink/juice/apple
	name = REAGENT_APPLEJUICE
	id = REAGENT_ID_APPLEJUICE
	description = "The most basic juice."
	taste_description = "crispness"
	taste_mult = 1.1
	color = "#E2A55F"

	glass_name = "apple juice"
	glass_desc = "An earth favorite."
	allergen_type = ALLERGEN_FRUIT //Apples are fruit
	cup_prefix = "apple"

/datum/reagent/drink/juice/lime
	name = REAGENT_LIMEJUICE
	id = REAGENT_ID_LIMEJUICE
	description = "The sweet-sour juice of limes."
	taste_description = "sourness"
	taste_mult = 1.8
	color = "#365E30"

	glass_name = "lime juice"
	glass_desc = "A glass of sweet-sour lime juice"
	allergen_type = ALLERGEN_FRUIT //Limes are fruit
	cup_prefix = "lime"

/datum/reagent/drink/juice/lime/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/juice/orange
	name = REAGENT_ORANGEJUICE
	id = REAGENT_ID_ORANGEJUICE
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	taste_description = "oranges"
	color = "#E78108"

	glass_name = "orange juice"
	glass_desc = "Vitamins! Yay!"
	allergen_type = ALLERGEN_FRUIT //Oranges are fruit
	cup_prefix = "orange"

/datum/reagent/drink/juice/orange/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustOxyLoss(-2 * removed)

/datum/reagent/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = REAGENT_POISONBERRYJUICE
	id = REAGENT_ID_POISONBERRYJUICE
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	taste_description = "berries"
	color = "#863353"
	strength = 5

	glass_name = "poison berry juice"
	glass_desc = "A glass of deadly juice."
	cup_prefix = "poison"

/datum/reagent/drink/juice/potato
	name = REAGENT_POTATOJUICE
	id = REAGENT_ID_POTATOJUICE
	description = "Juice of the potato. Bleh."
	taste_description = "potatoes"
	nutrition = 2
	color = "#302000"
	sugary = FALSE

	glass_name = "potato juice"
	glass_desc = "Juice from a potato. Bleh."
	allergen_type = ALLERGEN_VEGETABLE //Potatoes are vegetables
	cup_prefix = "potato"

/datum/reagent/drink/juice/turnip
	name = REAGENT_TURNIPJUICE
	id = REAGENT_ID_TURNIPJUICE
	description = "Juice of the turnip. A step below the potato."
	taste_description = "turnips"
	nutrition = 2
	color = "#251e2e"
	sugary = FALSE

	glass_name = "turnip juice"
	glass_desc = "Juice of the turnip. A step below the potato."
	allergen_type = ALLERGEN_VEGETABLE //Turnips are vegetables
	cup_prefix = "turnip"

/datum/reagent/drink/juice/tomato
	name = REAGENT_TOMATOJUICE
	id = REAGENT_ID_TOMATOJUICE
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	taste_description = "tomatoes"
	color = "#731008"
	sugary = FALSE
	cup_prefix = "tomato"

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"
	allergen_type = ALLERGEN_FRUIT //Yes tomatoes are a fruit

/datum/reagent/drink/juice/tomato/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.heal_organ_damage(0, 0.5 * removed)

/datum/reagent/drink/juice/watermelon
	name = REAGENT_WATERMELONJUICE
	id = REAGENT_ID_WATERMELONJUICE
	description = "Delicious juice made from watermelon."
	taste_description = "sweet watermelon"
	color = "#B83333"
	cup_prefix = "melon"

	glass_name = "watermelon juice"
	glass_desc = "Delicious juice made from watermelon."
	allergen_type = ALLERGEN_FRUIT //Watermelon is a fruit

// Everything else

/datum/reagent/drink/milk
	name = REAGENT_MILK
	id = REAGENT_ID_MILK
	description = "An opaque white liquid produced by the mammary glands of mammals."
	taste_description = "milk"
	color = "#DFDFDF"

	glass_name = REAGENT_ID_MILK
	glass_desc = "White and nutritious goodness!"

	cup_icon_state = "cup_cream"
	cup_name = REAGENT_ID_MILK
	cup_desc = "White and nutritious goodness!"
	allergen_type = ALLERGEN_DAIRY //Milk is dairy

/datum/reagent/drink/milk/chocolate
	name =  REAGENT_CHOCOLATEMILK
	id = REAGENT_ID_CHOCOLATEMILK
	description = "A delicious mixture of perfectly healthy mix and terrible chocolate."
	taste_description = "chocolate milk"
	color = "#74533b"

	cup_icon_state = "cup_brown"
	cup_name = "chocolate milk"
	cup_desc = "Deliciously fattening!"

	glass_name = "chocolate milk"
	glass_desc = "Deliciously fattening!"
	allergen_type = ALLERGEN_CHOCOLATE

/datum/reagent/drink/milk/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.heal_organ_damage(0.5 * removed, 0)
	holder.remove_reagent(REAGENT_ID_CAPSAICIN, 10 * removed)
	//VOREStation Edit
	if(ishuman(M) && rand(1,10000) == 1)
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			if(O.status & ORGAN_BROKEN)
				O.mend_fracture()
				H.custom_pain("You feel the agonizing power of calcium mending your bones!",60)
				H.AdjustWeakened(1)
				break // Only mend one bone, whichever comes first in the list
	//VOREStation Edit End

/datum/reagent/drink/milk/cream
	name = REAGENT_CREAM
	id = REAGENT_ID_CREAM
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	taste_description = "thick milk"
	color = "#DFD7AF"

	glass_name = REAGENT_ID_CREAM
	glass_desc = "Ewwww..."

	cup_icon_state = "cup_cream"
	cup_name = REAGENT_ID_CREAM
	cup_desc = "Ewwww..."
	allergen_type = ALLERGEN_DAIRY //Cream is dairy

/datum/reagent/drink/milk/soymilk
	name = REAGENT_SOYMILK
	id = REAGENT_ID_SOYMILK
	description = "An opaque white liquid made from soybeans."
	taste_description = "soy milk"
	color = "#DFDFC7"

	glass_name = "soy milk"
	glass_desc = "White and nutritious soy goodness!"

	cup_icon_state = "cup_cream"
	cup_name = REAGENT_ID_MILK
	cup_desc = "White and nutritious goodness!"
	allergen_type = ALLERGEN_BEANS //Would be made from soy beans

/datum/reagent/drink/milk/foam
	name = REAGENT_MILKFOAM
	id = REAGENT_ID_MILKFOAM
	description = "Light and airy foamed milk."
	taste_description = "airy milk"
	color = "#eeebdf"

	glass_name = "foam"
	glass_desc = "Fluffy..."

	cup_icon_state = "cup_cream"
	cup_name = "foam"
	cup_desc = "Fluffy..."
	allergen_type = ALLERGEN_DAIRY //Cream is dairy


/datum/reagent/drink/tea
	name = REAGENT_TEA
	id = REAGENT_ID_TEA
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
	cup_name = REAGENT_ID_TEA
	cup_desc = "Tasty black tea, it has antioxidants, it's good for you!"
	allergen_type = ALLERGEN_STIMULANT //Black tea strong enough to have significant caffeine content

/datum/reagent/drink/tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/tea/decaf
	name = REAGENT_TEADECAF
	id = REAGENT_ID_TEADECAF
	description = "Tasty black tea, it has antioxidants, it's good for you, and won't keep you up at night!"
	color = "#832700"
	adj_dizzy = 0
	adj_drowsy = 0 //Decaf won't help you here.
	adj_sleepy = 0

	glass_name = "cup of decaf tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you, and won't keep you up at night!"

	cup_name = "decaf tea"
	cup_desc = "Tasty black tea, it has antioxidants, it's good for you, and won't keep you up at night!"
	allergen_type = null //Certified cat-safe!


/datum/reagent/drink/tea/icetea
	name = REAGENT_ICETEA
	id = REAGENT_ID_ICETEA
	description = "No relation to a certain rap artist/ actor."
	taste_description = "sweet tea"
	color = "#AC7F24" // rgb: 16, 64, 56
	adj_temp = -5

	glass_name = "iced tea"
	glass_desc = "No relation to a certain rap artist/ actor."
	glass_special = list(DRINK_ICE)

	cup_icon_state = "cup_tea"
	cup_name = "iced tea"
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

/datum/reagent/drink/tea/icetea/decaf
	name = REAGENT_ICETEADECAF
	id = REAGENT_ID_ICETEADECAF
	glass_name = "decaf iced tea"
	cup_name = "decaf iced tea"
	adj_dizzy = 0
	adj_drowsy = 0
	adj_sleepy = 0
	allergen_type = null

/datum/reagent/drink/tea/minttea
	name = REAGENT_MINTTEA
	id = REAGENT_ID_MINTTEA
	description = "A tasty mixture of mint and tea. It's apparently good for you!"
	color = "#A8442C"
	taste_description = "black tea with tones of mint"

	glass_name = "mint tea"
	glass_desc = "A tasty mixture of mint and tea. It's apparently good for you!"

	cup_name = "mint tea"
	cup_desc = "A tasty mixture of mint and tea. It's apparently good for you!"

/datum/reagent/drink/tea/minttea/decaf
	name = REAGENT_MINTTEADECAF
	id = REAGENT_ID_MINTTEADECAF
	glass_name = "decaf mint tea"
	cup_name = "decaf mint tea"
	adj_dizzy = 0
	adj_drowsy = 0
	adj_sleepy = 0
	allergen_type = null

/datum/reagent/drink/tea/lemontea
	name = REAGENT_LEMONTEA
	id = REAGENT_ID_LEMONTEA
	description = "A tasty mixture of lemon and tea. It's apparently good for you!"
	color = "#FC6A00"
	taste_description = "black tea with tones of lemon"

	glass_name = "lemon tea"
	glass_desc = "A tasty mixture of lemon and tea. It's apparently good for you!"

	cup_name = "lemon tea"
	cup_desc = "A tasty mixture of lemon and tea. It's apparently good for you!"
	allergen_type = ALLERGEN_FRUIT | ALLERGEN_STIMULANT //Made with lemon juice, still tea

/datum/reagent/drink/tea/lemontea/decaf
	name = REAGENT_LEMONTEADECAF
	id = REAGENT_ID_LEMONTEADECAF
	glass_name = "decaf lemon tea"
	cup_name = "decaf lemon tea"
	adj_dizzy = 0
	adj_drowsy = 0
	adj_sleepy = 0
	allergen_type = ALLERGEN_FRUIT //No caffine, still lemon.

/datum/reagent/drink/tea/limetea
	name = REAGENT_LIMETEA
	id = REAGENT_ID_LIMETEA
	description = "A tasty mixture of lime and tea. It's apparently good for you!"
	color = "#DE4300"
	taste_description = "black tea with tones of lime"

	glass_name = "lime tea"
	glass_desc = "A tasty mixture of lime and tea. It's apparently good for you!"

	cup_name = "lime tea"
	cup_desc = "A tasty mixture of lime and tea. It's apparently good for you!"
	allergen_type = ALLERGEN_FRUIT | ALLERGEN_STIMULANT //Made with lime juice, still tea

/datum/reagent/drink/tea/limetea/decaf
	name = REAGENT_LIMETEADECAF
	id = REAGENT_ID_LIMETEADECAF
	glass_name = "decaf lime tea"
	cup_name = "decaf lime tea"
	adj_dizzy = 0
	adj_drowsy = 0
	adj_sleepy = 0
	allergen_type = ALLERGEN_FRUIT //No caffine, still lime.

/datum/reagent/drink/tea/orangetea
	name = REAGENT_ORANGETEA
	id = REAGENT_ID_ORANGETEA
	description = "A tasty mixture of orange and tea. It's apparently good for you!"
	color = "#FB4F06"
	taste_description = "black tea with tones of orange"

	glass_name = "orange tea"
	glass_desc = "A tasty mixture of orange and tea. It's apparently good for you!"

	cup_name = "orange tea"
	cup_desc = "A tasty mixture of orange and tea. It's apparently good for you!"
	allergen_type = ALLERGEN_FRUIT | ALLERGEN_STIMULANT //Made with orange juice, still tea

/datum/reagent/drink/tea/orangetea/decaf
	name = REAGENT_ORANGETEADECAF
	id = REAGENT_ID_ORANGETEADECAF
	glass_name = "decaf orange tea"
	cup_name = "decaf orange tea"
	adj_dizzy = 0
	adj_drowsy = 0
	adj_sleepy = 0
	allergen_type = ALLERGEN_FRUIT //No caffine, still orange.

/datum/reagent/drink/tea/berrytea
	name = REAGENT_BERRYTEA
	id = REAGENT_ID_BERRYTEA
	description = "A tasty mixture of berries and tea. It's apparently good for you!"
	color = "#A60735"
	taste_description = "black tea with tones of berries"

	glass_name = "berry tea"
	glass_desc = "A tasty mixture of berries and tea. It's apparently good for you!"

	cup_name = "berry tea"
	cup_desc = "A tasty mixture of berries and tea. It's apparently good for you!"
	allergen_type = ALLERGEN_FRUIT | ALLERGEN_STIMULANT //Made with berry juice, still tea

/datum/reagent/drink/tea/berrytea/decaf
	name = REAGENT_BERRYTEADECAF
	id = REAGENT_ID_BERRYTEADECAF
	glass_name = "decaf berry tea"
	cup_name = "decaf berry tea"
	adj_dizzy = 0
	adj_drowsy = 0
	adj_sleepy = 0
	allergen_type = ALLERGEN_FRUIT //No caffine, still berries.

/datum/reagent/drink/greentea
	name = REAGENT_GREENTEA
	id = REAGENT_ID_GREENTEA
	description = "A subtle blend of green tea. It's apparently good for you!"
	color = "#A8442C"
	taste_description = "green tea"

	glass_name = "green tea"
	glass_desc = "A subtle blend of green tea. It's apparently good for you!"

	cup_name = "green tea"
	cup_desc = "A subtle blend of green tea. It's apparently good for you!"

/datum/reagent/drink/tea/chaitea
	name = REAGENT_CHAITEA
	id = REAGENT_ID_CHAITEA
	description = "A milky tea spiced with cinnamon and cloves."
	color = "#A8442C"
	taste_description = "creamy cinnamon and spice"

	glass_name = "chai tea"
	glass_desc = "A milky tea spiced with cinnamon and cloves."

	cup_name = "chai tea"
	cup_desc = "A milky tea spiced with cinnamon and cloves."
	allergen_type = ALLERGEN_STIMULANT|ALLERGEN_DAIRY //Made with milk and tea.

/datum/reagent/drink/tea/chaitea/decaf
	name = REAGENT_CHAITEADECAF
	id = REAGENT_ID_CHAITEADECAF
	glass_name = "decaf chai tea"
	cup_name = "decaf chai tea"
	adj_dizzy = 0
	adj_drowsy = 0
	adj_sleepy = 0
	allergen_type = ALLERGEN_DAIRY //No caffeine, still milk.

/datum/reagent/drink/coffee
	name = REAGENT_COFFEE
	id = REAGENT_ID_COFFEE
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	taste_description = "coffee"
	taste_mult = 1.3
	color = "#482000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25
	overdose = REAGENTS_OVERDOSE *1.5

	cup_icon_state = "cup_coffee"
	cup_name = REAGENT_ID_COFFEE
	cup_desc = "Don't drop it, or you'll send scalding liquid and ceramic shards everywhere."

	glass_name = REAGENT_ID_COFFEE
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."
	allergen_type = ALLERGEN_COFFEE | ALLERGEN_STIMULANT //Apparently coffee contains coffee

/datum/reagent/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()

	//if(alien == IS_TAJARA) //VOREStation Edit Begin
		//M.adjustToxLoss(0.5 * removed)
		//M.make_jittery(4) //extra sensitive to caffine
	if(adj_temp > 0)
		holder.remove_reagent(REAGENT_ID_FROSTOIL, 10 * removed)

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
	name = REAGENT_ICECOFFEE
	id = REAGENT_ID_ICECOFFEE
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
	name = REAGENT_SOYLATTE
	id = REAGENT_ID_SOYLATTE
	description = "A nice and tasty beverage while you are reading your hippie books."
	taste_description = "creamy coffee"
	color = "#C65905"
	adj_temp = 5

	glass_desc = "A nice and refreshing beverage while you are reading."
	glass_name = "soy latte"

	cup_icon_state = "cup_latte"
	cup_name = "soy latte"
	cup_desc = "A nice and refreshing beverage while you are reading."
	allergen_type = ALLERGEN_COFFEE|ALLERGEN_BEANS 	//Soy(beans) and coffee

/datum/reagent/drink/coffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/cafe_latte
	name = REAGENT_CAFELATTE
	id = REAGENT_ID_CAFELATTE
	description = "A nice, strong and tasty beverage while you are reading."
	taste_description = "bitter cream"
	color = "#C65905"
	adj_temp = 5

	glass_name = "cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading."

	cup_icon_state = "cup_latte"
	cup_name = "cafe latte"
	cup_desc = "A nice and refreshing beverage while you are reading."
	allergen_type = ALLERGEN_COFFEE|ALLERGEN_DAIRY //Cream and coffee

/datum/reagent/drink/coffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/decaf
	name = REAGENT_DECAF
	id = REAGENT_ID_DECAF
	description = "Coffee with all the wake-up sucked out."
	taste_description = "bad coffee"
	taste_mult = 1.3
	color = "#482000"
	adj_temp = 25

	cup_icon_state = "cup_coffee"
	cup_name = REAGENT_ID_DECAF
	cup_desc = "Basically just brown, bitter water."

	glass_name = "decaf coffee"
	glass_desc = "Basically just brown, bitter water."
	allergen_type = ALLERGEN_COFFEE //Decaf coffee is still coffee, just less stimulating.

/datum/reagent/drink/hot_coco
	name = REAGENT_HOTCOCO
	id = REAGENT_ID_HOTCOCO
	description = "Made with love! And cocoa beans."
	taste_description = "creamy chocolate"
	reagent_state = LIQUID
	color = "#403010"
	nutrition = 2
	adj_temp = 5

	glass_name = "hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

	cup_icon_state = "cup_coco"
	cup_name = "hot chocolate"
	cup_desc = "Made with love! And cocoa beans."
	allergen_type = ALLERGEN_CHOCOLATE

/datum/reagent/drink/coffee/blackeye
	name = REAGENT_BLACKEYE
	id = REAGENT_ID_BLACKEYE
	description = "Coffee but with more coffee for that extra coffee kick."
	taste_description = "very concentrated coffee"
	color = "#241001"
	adj_temp = 5

	glass_desc = "Coffee but with more coffee for that extra coffee kick."
	glass_name = "black eye coffee"

	cup_icon_state = "cup_coffee"
	cup_name = "black eye coffee"
	cup_desc = "Coffee but with more coffee for that extra coffee kick."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/drip
	name = REAGENT_DRIPCOFFEE
	id = REAGENT_ID_DRIPCOFFEE
	description = "Coffee made by soaking beans in hot water and allowing it seep through."
	taste_description = "very concentrated coffee"
	color = "#3d1a00"
	adj_temp = 5

	glass_desc = "Coffee made by soaking beans in hot water and allowing it seep through."
	glass_name = "drip coffee"

	cup_icon_state = "cup_coffee"
	cup_name = "drip brewed coffee"
	cup_desc = "Coffee made by soaking beans in hot water and allowing it seep through."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/americano
	name = REAGENT_AMERICANO
	id = REAGENT_ID_AMERICANO
	description = "A traditional coffee that is more dilute and perfect for a gentle start to the day."
	taste_description = "pleasant coffee"
	color = "#6d3205"
	adj_temp = 5

	glass_desc = "A traditional coffee that is more dilute and perfect for a gentle start to the day."
	glass_name = REAGENT_ID_AMERICANO

	cup_icon_state = "cup_coffee"
	cup_name = REAGENT_ID_AMERICANO
	cup_desc = "A traditional coffee that is more dilute and perfect for a gentle start to the day."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/long_black
	name = REAGENT_LONGBLACK
	id = REAGENT_ID_LONGBLACK
	description = "A traditional coffee with a little more kick."
	taste_description = "modestly bitter coffee"
	color = "#6d3205"
	adj_temp = 5

	glass_desc = "A traditional coffee with a little more kick."
	glass_name = REAGENT_ID_LONGBLACK

	cup_icon_state = "cup_coffee"
	cup_name = "long black coffee"
	cup_desc = "A traditional coffee with a little more kick."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/macchiato
	name = REAGENT_MACCHIATO
	id = REAGENT_ID_MACCHIATO
	description = "A coffee mixed with steamed milk, it has swirling patterns on top."
	taste_description = "milky coffee"
	color = "#ad5817"
	adj_temp = 5

	glass_desc = "A coffee mixed with steamed milk, it has swirling patterns on top."
	glass_name = REAGENT_ID_MACCHIATO

	cup_icon_state = "cup_latte"
	cup_name = REAGENT_ID_MACCHIATO
	cup_desc = "A coffee mixed with steamed milk, it has swirling patterns on top."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/cortado
	name = REAGENT_CORTADO
	id = REAGENT_ID_CORTADO
	description = "Espresso mixed with equal parts milk and a layer of foam on top."
	taste_description = "milky coffee"
	color = "#ad5817"
	adj_temp = 5

	glass_desc = "Espresso mixed with equal parts milk and a layer of foam on top."
	glass_name = REAGENT_ID_CORTADO

	cup_icon_state = "cup_latte"
	cup_name = REAGENT_ID_CORTADO
	cup_desc = "Espresso mixed with equal parts milk and a layer of foam on top."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/breve
	name = REAGENT_BREVE
	id = REAGENT_ID_BREVE
	description = "Espresso topped with half-and-half, with a layer of foam on top."
	taste_description = "creamy coffee"
	color = "#d1905e"
	adj_temp = 5

	glass_desc = "Espresso topped with half-and-half, with a layer of foam on top."
	glass_name = REAGENT_ID_BREVE

	cup_icon_state = "cup_cream"
	cup_name = REAGENT_ID_BREVE
	cup_desc = "Espresso topped with half-and-half, with a layer of foam on top."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/cappuccino
	name = REAGENT_CAPPUCCINO
	id = REAGENT_ID_CAPPUCCINO
	description = "Espresso with a large portion of milk and a hefty layer of foam."
	taste_description = "classic coffee"
	color = "#d1905e"
	adj_temp = 5

	glass_desc = "Espresso with a large portion of milk and a hefty layer of foam."
	glass_name = REAGENT_ID_CAPPUCCINO

	cup_icon_state = "cup_cream"
	cup_name = REAGENT_ID_CAPPUCCINO
	cup_desc = "Espresso with a large portion of milk and a hefty layer of foam."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/flat_white
	name = REAGENT_FLATWHITE
	id = REAGENT_ID_FLATWHITE
	description = "A very milky coffee that is particularly light and airy."
	taste_description = "very milky coffee"
	color = "#ed9f64"
	adj_temp = 5

	glass_desc = "A very milky coffee that is particularly light and airy."
	glass_name = REAGENT_ID_FLATWHITE

	cup_icon_state = "cup_latte"
	cup_name = "flat white coffee"
	cup_desc = "A very milky coffee that is particularly light and airy."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/mocha
	name = REAGENT_MOCHA
	id = REAGENT_ID_MOCHA
	description = "A chocolate and coffee mix topped with a lot of milk and foam."
	taste_description = "chocolatey coffee"
	color = "#984201"
	adj_temp = 5

	glass_desc = "A chocolate and coffee mix topped with a lot of milk and foam."
	glass_name = REAGENT_ID_MOCHA

	cup_icon_state = "cup_cream"
	cup_name = REAGENT_ID_MOCHA
	cup_desc = "A chocolate and coffee mix topped with a lot of milk and foam."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/coffee/vienna
	name = REAGENT_VIENNA
	id = REAGENT_ID_VIENNA
	description = "A very sweet espresso topped with a lot of whipped cream."
	taste_description = "super sweet and creamy coffee"
	color = "#8e7059"
	adj_temp = 5

	glass_desc = "A very sweet espresso topped with a lot of whipped cream."
	glass_name = REAGENT_ID_VIENNA

	cup_icon_state = "cup_cream"
	cup_name = REAGENT_ID_VIENNA
	cup_desc = "A very sweet espresso topped with a lot of whipped cream."
	allergen_type = ALLERGEN_COFFEE

/datum/reagent/drink/soda/sodawater
	name = REAGENT_SODAWATER
	id = REAGENT_ID_SODAWATER
	description = "A can of club soda. Why not make a scotch and soda?"
	taste_description = "carbonated water"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_temp = -5
	cup_prefix = "fizzy"

	glass_name = "soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/grapesoda
	name = REAGENT_GRAPESODA
	id = REAGENT_ID_GRAPESODA
	description = "Grapes made into a fine drank."
	taste_description = "grape soda"
	color = "#421C52"
	adj_drowsy = -3
	cup_prefix = "grape soda"

	glass_name = "grape soda"
	glass_desc = "Looks like a delicious drink!"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with grape juice

/datum/reagent/drink/soda/tonic
	name = REAGENT_TONIC
	id = REAGENT_ID_TONIC
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	taste_description = "tart and fresh"
	color = "#619494"
	cup_prefix = REAGENT_ID_TONIC

	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = -5

	glass_name = "tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/datum/reagent/drink/soda/lemonade
	name = REAGENT_LEMONADE
	id = REAGENT_ID_LEMONADE
	description = "Oh the nostalgia..."
	taste_description = REAGENT_ID_LEMONADE
	color = "#FFFF00"
	adj_temp = -5
	cup_prefix = REAGENT_ID_LEMONADE

	glass_name = REAGENT_ID_LEMONADE
	glass_desc = "Oh the nostalgia..."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with lemon juice

/datum/reagent/drink/soda/melonade
	name = REAGENT_MELONADE
	id = REAGENT_ID_MELONADE
	description = "Oh the.. nostalgia?"
	taste_description = "watermelon"
	color = "#FFB3BB"
	adj_temp = -5
	cup_prefix = REAGENT_ID_MELONADE

	glass_name = REAGENT_ID_MELONADE
	glass_desc = "Oh the.. nostalgia?"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with watermelon juice

/datum/reagent/drink/soda/appleade
	name = REAGENT_APPLEADE
	id = REAGENT_ID_APPLEADE
	description = "Applejuice, improved."
	taste_description = "apples"
	color = "#FFD1B3"
	adj_temp = -5
	cup_prefix = REAGENT_ID_APPLEADE

	glass_name = REAGENT_ID_APPLEADE
	glass_desc = "Applejuice, improved."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with apple juice

/datum/reagent/drink/soda/pineappleade
	name = REAGENT_PINEAPPLEADE
	id = REAGENT_ID_PINEAPPLEADE
	description = "Pineapple, juiced up."
	taste_description = "sweet`n`sour pineapples"
	color = "#FFFF00"
	adj_temp = -5
	cup_prefix = REAGENT_ID_PINEAPPLEADE

	glass_name = REAGENT_ID_PINEAPPLEADE
	glass_desc = "Pineapple, juiced up."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with pineapple juice

/datum/reagent/drink/soda/kiraspecial
	name = REAGENT_KIRASPECIAL
	id = REAGENT_ID_KIRASPECIAL
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	taste_description = "fruity sweetness"
	color = "#CCCC99"
	adj_temp = -5

	glass_name = REAGENT_KIRASPECIAL
	glass_desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made from orange and lime juice

/datum/reagent/drink/soda/brownstar
	name = REAGENT_BROWNSTAR
	id = REAGENT_ID_BROWNSTAR
	description = "It's not what it sounds like..."
	taste_description = "orange and cola soda"
	color = "#9F3400"
	adj_temp = -2

	glass_name = REAGENT_BROWNSTAR
	glass_desc = "It's not what it sounds like..."
	allergen_type = ALLERGEN_FRUIT | ALLERGEN_STIMULANT //Made with orangejuice and cola

/datum/reagent/drink/soda/brownstar_decaf //For decaf starkist
	name = REAGENT_BROWNSTARDECAF
	id = REAGENT_ID_BROWNSTARDECAF
	description = "It's not what it sounds like..."
	taste_description = "orange and cola soda"
	color = "#9F3400"
	adj_temp = -2

	glass_name = REAGENT_BROWNSTAR
	glass_desc = "It's not what it sounds like..."

/datum/reagent/drink/milkshake
	name = REAGENT_MILKSHAKE
	id = REAGENT_ID_MILKSHAKE
	description = "Glorious brainfreezing mixture."
	taste_description = "vanilla milkshake"
	color = "#AEE5E4"
	adj_temp = -9

	glass_name = REAGENT_ID_MILKSHAKE
	glass_desc = "Glorious brainfreezing mixture."
	allergen_type = ALLERGEN_DAIRY //Made with dairy products

/datum/reagent/drink/milkshake/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
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
			M.Sleeping(20)
			M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/drink/milkshake/chocoshake
	name = REAGENT_CHOCOSHAKE
	id = REAGENT_ID_CHOCOSHAKE
	description = "A refreshing chocolate milkshake."
	taste_description = "cold refreshing chocolate and cream"
	color = "#8e6f44" // rgb(142, 111, 68)
	adj_temp = -9

	glass_name = REAGENT_CHOCOSHAKE
	glass_desc = "A refreshing chocolate milkshake, just like mom used to make."
	allergen_type = ALLERGEN_DAIRY|ALLERGEN_CHOCOLATE //Made with dairy products

/datum/reagent/drink/milkshake/berryshake
	name = REAGENT_BERRYSHAKE
	id = REAGENT_ID_BERRYSHAKE
	description = "A refreshing berry milkshake."
	taste_description = "cold refreshing berries and cream"
	color = "#ffb2b2" // rgb(255, 178, 178)
	adj_temp = -9

	glass_name = REAGENT_BERRYSHAKE
	glass_desc = "A refreshing berry milkshake, just like mom used to make."
	allergen_type = ALLERGEN_FRUIT|ALLERGEN_DAIRY //Made with berry juice and dairy products

/datum/reagent/drink/milkshake/coffeeshake
	name = REAGENT_COFFEESHAKE
	id = REAGENT_ID_COFFEESHAKE
	description = "A refreshing coffee milkshake."
	taste_description = "cold energizing coffee and cream"
	color = "#8e6f44" // rgb(142, 111, 68)
	adj_temp = -9
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2

	glass_name = REAGENT_COFFEESHAKE
	glass_desc = "An energizing coffee milkshake, perfect for hot days at work.."
	allergen_type = ALLERGEN_DAIRY|ALLERGEN_COFFEE //Made with coffee and dairy products

/datum/reagent/drink/milkshake/coffeeshake/overdose(var/mob/living/carbon/M, var/alien)
	M.make_jittery(5)

/datum/reagent/drink/milkshake/peanutshake
	name = REAGENT_PEANUTMILKSHAKE
	id = REAGENT_ID_PEANUTMILKSHAKE
	description = "Savory cream in an ice-cold stature."
	taste_description = "cold peanuts and cream"
	color = "#8e6f44"

	glass_name = REAGENT_PEANUTMILKSHAKE
	glass_desc = "Savory cream in an ice-cold stature."
	allergen_type = ALLERGEN_SEEDS|ALLERGEN_DAIRY //Made with peanutbutter(seeds) and dairy products

/datum/reagent/drink/rewriter
	name = REAGENT_REWRITER
	id = REAGENT_ID_REWRITER
	description = "The secret of the sanctuary of the Libarian..."
	taste_description = "citrus and coffee"
	color = "#485000"
	adj_temp = -5

	glass_name = REAGENT_REWRITER
	glass_desc = "The secret of the sanctuary of the Libarian..."
	allergen_type = ALLERGEN_FRUIT|ALLERGEN_COFFEE|ALLERGEN_STIMULANT //Made with space mountain wind (Fruit, caffeine)

/datum/reagent/drink/rewriter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.make_jittery(5)

/datum/reagent/drink/soda/nuka_cola
	name = REAGENT_NUKACOLA
	id = REAGENT_ID_NUKACOLA
	description = "Cola, cola never changes."
	taste_description = "cola"
	color = "#100800"
	adj_temp = -5
	adj_sleepy = -2

	glass_name = "Nuka-Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_STIMULANT

/datum/reagent/drink/soda/nuka_cola/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.make_jittery(20)
	M.druggy = max(M.druggy, 30)
	M.dizziness += 5
	M.drowsyness = 0

/datum/reagent/drink/grenadine 	//Description implies that the grenadine we would be working with does not contain fruit, so no allergens.
	name = REAGENT_GRENADINE
	id = REAGENT_ID_GRENADINE
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	taste_description = "100% pure pomegranate"
	color = "#FF004F"
	water_based = FALSE

	glass_name = "grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."

/datum/reagent/drink/soda/space_cola
	name = REAGENT_COLA
	id = REAGENT_ID_COLA
	description = "A refreshing beverage."
	taste_description = "cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_COLA
	glass_desc = "A glass of refreshing Space Cola"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_STIMULANT //Cola is typically caffeinated.

/datum/reagent/drink/soda/decaf_cola
	name = REAGENT_DECAFCOLA
	id = REAGENT_ID_DECAFCOLA
	description = "A refreshing beverage with none of the jitters."
	taste_description = "cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_temp = -5

	glass_name = REAGENT_DECAFCOLA
	glass_desc = "A glass of refreshing Space Cola Free"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/lemon_soda
	name = REAGENT_LEMONSODA
	id = REAGENT_ID_LEMONSODA
	description = "Soda made using lemon concentrate. Sour."
	taste_description = "strong sourness"
	reagent_state = LIQUID
	color = "#ffe658"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "lemon Soda"
	glass_desc = "A glass of refreshing Lemon Soda. So sour!"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT

/datum/reagent/drink/soda/apple_soda
	name = REAGENT_APPLESODA
	id = REAGENT_ID_APPLESODA
	description = "Soda made using fresh apples."
	taste_description = "crisp juiciness"
	reagent_state = LIQUID
	color = "#c73737"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_APPLESODA
	glass_desc = "A glass of refreshing Apple Soda. Crisp!"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT


/datum/reagent/drink/soda/straw_soda
	name = REAGENT_STRAWSODA
	id = REAGENT_ID_STRAWSODA
	description = "Soda made using sweet berries."
	taste_description = "oddly bland"
	reagent_state = LIQUID
	color = "#ffa3a3"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_STRAWSODA
	glass_desc = "A glass of refreshing Strawberry Soda"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT

/datum/reagent/drink/soda/orangesoda
	name = REAGENT_ORANGESODA
	id = REAGENT_ID_ORANGESODA
	description = "Soda made using fresh picked oranges."
	taste_description = "sweet and citrusy"
	reagent_state = LIQUID
	color = "#ff992c"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_ORANGESODA
	glass_desc = "A glass of refreshing Orange Soda. Delicious!"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT

/datum/reagent/drink/soda/grapesoda
	name = REAGENT_GRAPESODA
	id = REAGENT_ID_GRAPESODA
	description = "Soda made of carbonated grapejuice."
	taste_description = "tangy goodness"
	reagent_state = LIQUID
	color = "#9862d2"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_GRAPESODA
	glass_desc = "A glass of refreshing Grape Soda. Tangy!"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT

/datum/reagent/drink/soda/sarsaparilla
	name = REAGENT_SARSAPARILLA
	id = REAGENT_ID_SARSAPARILLA
	description = "Soda made from genetically modified Mexican sarsaparilla plants."
	taste_description = "licorice and caramel"
	reagent_state = LIQUID
	color = "#e1bb59"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_SARSAPARILLA
	glass_desc = "A glass of refreshing Sarsaparilla. Delicious!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/pork_soda
	name = REAGENT_PORKSODA
	id = REAGENT_ID_PORKSODA
	description = "Soda made using pork like flavoring."
	taste_description = "sugar coated bacon"
	reagent_state = LIQUID
	color = "ff8080"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_PORKSODA
	glass_desc = "A glass of Bacon Soda, very odd..."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/spacemountainwind
	name = REAGENT_SPACEMOUNTAINWIND
	id = REAGENT_ID_SPACEMOUNTAINWIND
	description = "Blows right through you like a space wind."
	taste_description = "sweet citrus soda"
	color = "#102000"
	adj_drowsy = -7
	adj_sleepy = -1
	adj_temp = -5

	glass_name = "Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT|ALLERGEN_STIMULANT //Citrus, and caffeination

/datum/reagent/drink/soda/dr_gibb
	name = REAGENT_DRGIBB
	id = REAGENT_ID_DRGIBB
	description = "A delicious blend of 42 different flavors."
	taste_description = "cherry soda"
	color = "#102000"
	adj_drowsy = -6
	adj_temp = -5

	glass_name = REAGENT_DRGIBB
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."
	allergen_type = ALLERGEN_STIMULANT

/datum/reagent/drink/soda/space_up
	name = REAGENT_SPACEUP
	id = REAGENT_ID_SPACEUP
	description = "Tastes like a hull breach in your mouth."
	taste_description = "citrus soda"
	color = "#202800"
	adj_temp = -8

	glass_name = "Space-up"
	glass_desc = "Space-up. It helps keep your cool."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT

/datum/reagent/drink/soda/lemon_lime
	name = REAGENT_LEMONLIME
	id = REAGENT_ID_LEMONLIME
	description = "A tangy substance made of 0.5% natural citrus!"
	taste_description = "tangy lime and lemon soda"
	color = "#878F00"
	adj_temp = -8

	glass_name = "lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with lemon and lime juice

/datum/reagent/drink/soda/gingerale
	name = REAGENT_GINGERALE
	id = REAGENT_ID_GINGERALE
	description = "The original."
	taste_description = "somewhat tangy ginger ale"
	color = "#edcf8f"
	adj_temp = -8

	glass_name = "ginger ale"
	glass_desc = "The original, refreshing not-actually-ale."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/root_beer
	name = REAGENT_ROOTBEER
	id = REAGENT_ID_ROOTBEER
	color = "#211100"
	adj_drowsy = -6
	taste_description = "sassafras and anise soda"

	glass_name = "glass of R&D Root Beer"
	glass_desc = "A glass of bubbly R&D Root Beer."

/datum/reagent/drink/dr_gibb_diet
	name = REAGENT_DIETDRGIBB
	id = REAGENT_ID_DIETDRGIBB
	color = "#102000"
	taste_description = "chemically sweetened cherry soda"

	glass_name = "glass of Diet Dr. Gibb"
	glass_desc = "Regular Dr.Gibb is probably healthier than this cocktail of artificial flavors."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/shirley_temple
	name = REAGENT_SHIRLEYTEMPLE
	id =  REAGENT_ID_SHIRLEYTEMPLE
	description = "A sweet concotion hated even by its namesake."
	taste_description = "sweet ginger ale"
	color = "#EF304F"
	adj_temp = -8

	glass_name = "shirley temple"
	glass_desc = "A sweet concotion hated even by its namesake."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/roy_rogers
	name = REAGENT_ROYROGERS
	id = REAGENT_ID_ROYROGERS
	description = "I'm a cowboy, on a steel horse I ride."
	taste_description = "cola and fruit"
	color = "#4F1811"
	adj_temp = -8

	glass_name = "roy rogers"
	glass_desc = "I'm a cowboy, on a steel horse I ride"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT | ALLERGEN_STIMULANT //Made with lemon lime and cola

/datum/reagent/drink/collins_mix
	name = REAGENT_COLLINSMIX
	id = REAGENT_ID_COLLINSMIX
	description = "Best hope it isn't a hoax."
	taste_description = "gin and lemonade"
	color = "#D7D0B3"
	adj_temp = -8

	glass_name = "collins mix"
	glass_desc = "Best hope it isn't a hoax."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with lemon lime

/datum/reagent/drink/arnold_palmer
	name = REAGENT_ARNOLDPALMER
	id = REAGENT_ID_ARNOLDPALMER
	description = "Tastes just like the old man."
	taste_description = "lemon and sweet tea"
	color = "#AF5517"
	adj_temp = -8

	glass_name = "arnold palmer"
	glass_desc = "Tastes just like the old man."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT | ALLERGEN_STIMULANT //Made with lemonade and tea

/datum/reagent/drink/doctor_delight
	name = REAGENT_DOCTORSDELIGHT
	id = REAGENT_ID_DOCTORSDELIGHT
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	taste_description = "homely fruit smoothie"
	reagent_state = LIQUID
	color = "#FF8CFF"
	nutrition = 1

	glass_name = REAGENT_DOCTORSDELIGHT
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
	allergen_type = ALLERGEN_FRUIT|ALLERGEN_DAIRY //Made from several fruit juices, and cream.

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
	name = REAGENT_DRYRAMEN
	id = REAGENT_ID_DRYRAMEN
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	taste_description = "dry cheap noodles"
	reagent_state = SOLID
	nutrition = 1
	color = "#302000"

/datum/reagent/drink/hot_ramen
	name = REAGENT_HOTRAMEN
	id = REAGENT_ID_HOTRAMEN
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "noodles and salt"
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	adj_temp = 5

/datum/reagent/drink/hell_ramen
	name = REAGENT_HELLRAMEN
	id = REAGENT_ID_HELLRAMEN
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
	name = REAGENT_DESSERTRAMEN
	id = REAGENT_ID_DESSERTRAMEN
	description = "How many things can you add to a cup of ramen before it begins to question its existance?"
	taste_description = "unbearable sweetness"
	color = "#4444FF"
	nutrition = 5

	glass_name = "Sweet Sundae Ramen"
	glass_desc = "How many things can you add to a cup of ramen before it begins to question its existance?"

/datum/reagent/drink/ice
	name = REAGENT_ICE
	id = REAGENT_ID_ICE
	description = "Frozen water, your dentist wouldn't like you chewing this."
	taste_description = "ice"
	reagent_state = SOLID
	color = "#619494"
	adj_temp = -5

	glass_name = REAGENT_ID_ICE
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
	name = REAGENT_NOTHING
	id = REAGENT_ID_NOTHING
	description = "Absolutely nothing."
	taste_description = REAGENT_ID_NOTHING

	glass_name = REAGENT_ID_NOTHING
	glass_desc = "Absolutely nothing."

/datum/reagent/drink/dreamcream
	name = REAGENT_DREAMCREAM
	id = REAGENT_ID_DREAMCREAM
	description = "A smoothy, silky mix of honey and dairy."
	taste_description = "sweet, soothing dairy"
	color = "#fcfcc9" // rgb(252, 252, 201)

	glass_name = REAGENT_DREAMCREAM
	glass_desc = "A smoothy, silky mix of honey and dairy."
	allergen_type = ALLERGEN_DAIRY //Made using dairy

/datum/reagent/drink/soda/vilelemon
	name = REAGENT_VILELEMON
	id = REAGENT_ID_VILELEMON
	description = "A fizzy, sour lemonade mix."
	taste_description = "fizzy, sour lemon"
	color = "#c6c603" // rgb(198, 198, 3)

	glass_name = REAGENT_VILELEMON
	glass_desc = "A sour, fizzy drink with lemonade and lemonlime."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT|ALLERGEN_STIMULANT //Made from lemonade and mtn wind(caffeine)

/datum/reagent/drink/entdraught
	name = REAGENT_ENTDRAUGHT
	id = REAGENT_ID_ENTDRAUGHT
	description = "A natural, earthy combination of all things peaceful."
	taste_description = "fresh rain and sweet memories"
	color = "#3a6617" // rgb(58, 102, 23)

	glass_name = REAGENT_ENTDRAUGHT
	glass_desc = "You can almost smell the tranquility emanating from this."
	//allergen_type = ALLERGEN_FRUIT Sorry to break the news, chief. Honey is not a fruit.

/datum/reagent/drink/love_potion
	name = REAGENT_LOVEPOTION
	id = REAGENT_ID_LOVEPOTION
	description = "Creamy strawberries and sugar, simple and sweet."
	taste_description = "strawberries and cream"
	color = "#fc8a8a" // rgb(252, 138, 138)

	glass_name = REAGENT_LOVEPOTION
	glass_desc = "Love me tender, love me sweet."
	allergen_type = ALLERGEN_FRUIT|ALLERGEN_DAIRY //Made from cream(dairy) and berryjuice(fruit)

/datum/reagent/drink/oilslick
	name = REAGENT_OILSLICK
	id = REAGENT_ID_OILSLICK
	description = "A viscous, but sweet, ooze."
	taste_description = "honey"
	color = "#FDF5E6" // rgb(253,245,230)
	water_based = FALSE

	glass_name = REAGENT_OILSLICK
	glass_desc = "A concoction that should probably be in an engine, rather than your stomach."
	glass_icon = DRINK_ICON_NOISY
	allergen_type = ALLERGEN_VEGETABLE //Made from corn oil

/datum/reagent/drink/slimeslammer
	name = REAGENT_SLIMESLAMMER
	id = REAGENT_ID_SLIMESLAMMER
	description = "A viscous, but savory, ooze."
	taste_description = "peanuts`n`slime"
	color = "#93604D"
	water_based = FALSE

	glass_name = "Slick Slime Slammer"
	glass_desc = "A concoction that should probably be in an engine, rather than your stomach. Still."
	glass_icon = DRINK_ICON_NOISY
	allergen_type = ALLERGEN_VEGETABLE|ALLERGEN_SEEDS //Made from corn oil and peanutbutter

/datum/reagent/drink/eggnog
	name = REAGENT_EGGNOG
	id = REAGENT_ID_EGGNOG
	description = "A creamy, rich beverage made out of whisked eggs, milk and sugar, for when you feel like celebrating the winter holidays."
	taste_description = "thick cream and vanilla"
	color = "#fff3c1" // rgb(255, 243, 193)

	glass_name = REAGENT_EGGNOG
	glass_desc = "You can't egg-nore the holiday cheer all around you"
	allergen_type = ALLERGEN_DAIRY|ALLERGEN_EGGS //Eggnog is made with dairy and eggs.

/datum/reagent/drink/nuclearwaste
	name = REAGENT_NUCLEARWASTE
	id = REAGENT_ID_NUCLEARWASTE
	description = "A viscous, glowing slurry."
	taste_description = "sour honey drops"
	color = "#7FFF00" // rgb(127,255,0)
	water_based = FALSE

	glass_name = REAGENT_NUCLEARWASTE
	glass_desc = "Sadly, no super powers."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_VEGETABLE //Made from oilslick, so has the same allergens.

/datum/reagent/drink/nuclearwaste/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.bloodstr.add_reagent(REAGENT_ID_RADIUM, 0.3)

/datum/reagent/drink/nuclearwaste/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.ingested.add_reagent(REAGENT_ID_RADIUM, 0.25)

/datum/reagent/drink/sodaoil //Mixed with normal drinks to make a 'potable' version for Prometheans if mixed 1-1. Dilution is key.
	name = REAGENT_SODAOIL
	id = REAGENT_ID_SODAOIL
	description = "A thick, bubbling soda."
	taste_description = "chewy water"
	color = "#F0FFF0" // rgb(245,255,250)
	water_based = FALSE

	glass_name = REAGENT_SODAOIL
	glass_desc = "A pitiful sludge that looks vaguely like a soda.. if you look at it a certain way."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_VEGETABLE //Made from corn oil

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

/datum/reagent/drink/virgin_mojito
	name = REAGENT_VIRGINMOJITO
	id = REAGENT_ID_VIRGINMOJITO
	description = "Mint, bubbly water, and citrus, made for sailing."
	taste_description = "mint and lime"
	color = "#FFF7B3"

	glass_name = REAGENT_ID_MOJITO
	glass_desc = "Mint, bubbly water, and citrus, made for sailing."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with lime juice

/datum/reagent/drink/sexonthebeach
	name = REAGENT_VIRGINSEXONTHEBEACH
	id = REAGENT_ID_VIRGINSEXONTHEBEACH
	description = "A secret combination of orange juice and pomegranate."
	taste_description = "60% orange juice, 40% pomegranate"
	color = "#7051E3"

	glass_name = "sex on the beach"
	glass_desc = "A secret combination of orange juice and pomegranate."
	allergen_type = ALLERGEN_FRUIT //Made with orange juice

/datum/reagent/drink/driverspunch
	name = REAGENT_DRIVERSPUNCH
	id = REAGENT_ID_DRIVERSPUNCH
	description = "A fruity punch!"
	taste_description = "sharp, sour apples"
	color = "#D2BA6E"

	glass_name = "driver`s punch"
	glass_desc = "A fruity punch!"
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with appleade and orange juice

/datum/reagent/drink/mintapplesparkle
	name = REAGENT_MINTAPPLESPARKLE
	id = REAGENT_ID_MINTAPPLESPARKLE
	description = "Delicious appleade with a touch of mint."
	taste_description = "minty apples"
	color = "#FDDA98"

	glass_name = "mint apple sparkle"
	glass_desc = "Delicious appleade with a touch of mint."
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with appleade

/datum/reagent/drink/berrycordial
	name = REAGENT_BERRYCORDIAL
	id = REAGENT_ID_BERRYCORDIAL
	description = "How <font face='comic sans ms'>berry cordial</font> of you."
	taste_description = "sweet chivalry"
	color = "#D26EB8"

	glass_name = "berry cordial"
	glass_desc = "How <font face='comic sans ms'>berry cordial</font> of you."
	glass_icon = DRINK_ICON_NOISY
	allergen_type = ALLERGEN_FRUIT //Made with berry and lemonjuice

/datum/reagent/drink/tropicalfizz
	name = REAGENT_TROPICALFIZZ
	id = REAGENT_ID_TROPICALFIZZ
	description = "One sip and you're in the bahamas."
	taste_description = "tropical"
	color = "#69375C"

	glass_name = "tropical fizz"
	glass_desc = "One sip and you're in the bahamas."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //Made with several fruit juices

/datum/reagent/drink/fauxfizz
	name = REAGENT_FAUXFIZZ
	id = REAGENT_ID_FAUXFIZZ
	description = "One sip and you're in the bahamas... maybe."
	taste_description = "slightly tropical"
	color = "#69375C"

	glass_name = "tropical fizz"
	glass_desc = "One sip and you're in the bahamas... maybe."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)
	allergen_type = ALLERGEN_FRUIT //made with several fruit juices

/datum/reagent/drink/syrup
	name = REAGENT_SYRUP
	id = REAGENT_ID_SYRUP
	description = "A generic, sugary syrup."
	taste_description = "sweetness"
	color = "#fffbe8"
	cup_prefix = "extra sweet"

	glass_name = REAGENT_ID_SYRUP
	glass_desc = "That is just way too much syrup to drink on its own."
	allergen_type = ALLERGEN_SUGARS

	overdose = REAGENTS_OVERDOSE *1.5

/datum/reagent/drink/syrup/overdose(var/mob/living/carbon/M, var/alien)
	if(alien == IS_DIONA)
		return
	M.make_dizzy(1)

/datum/reagent/drink/syrup/pumpkin
	name = REAGENT_SYRUPPUMPKIN
	id = REAGENT_ID_SYRUPPUMPKIN
	description = "A sugary syrup that tastes of pumpkin spice."
	taste_description = "pumpkin spice"
	color = "#e0b439"
	cup_prefix = "pumpkin spice"

	allergen_type = ALLERGEN_SUGARS|ALLERGEN_FRUIT

/datum/reagent/drink/syrup/caramel
	name = REAGENT_SYRUPCARAMEL
	id = REAGENT_ID_SYRUPCARAMEL
	description = "A sugary syrup that tastes of caramel."
	taste_description = "caramel"
	color = "#b47921"
	cup_prefix = "caramel"

/datum/reagent/drink/syrup/scaramel
	name = REAGENT_SYRUPSALTEDCARAMEL
	id = REAGENT_ID_SYRUPSALTEDCARAMEL
	description = "A sugary syrup that tastes of salted caramel."
	taste_description = "salty caramel"
	color = "#9f6714"
	cup_prefix = "salted caramel"

/datum/reagent/drink/syrup/irish
	name = REAGENT_SYRUPIRISH
	id = REAGENT_ID_SYRUPIRISH
	description = "A sugary syrup that tastes of a light, sweet cream."
	taste_description = "creaminess"
	color = "#ead3b0"
	cup_prefix = "irish"

/datum/reagent/drink/syrup/almond
	name = REAGENT_SYRUPALMOND
	id = REAGENT_ID_SYRUPALMOND
	description = "A sugary syrup that tastes of almonds."
	taste_description = "almonds"
	color = "#ffb64a"
	cup_prefix = "almond"

	allergen_type = ALLERGEN_SUGARS|ALLERGEN_SEEDS

/datum/reagent/drink/syrup/cinnamon
	name = REAGENT_SYRUPCINNAMON
	id = REAGENT_ID_SYRUPCINNAMON
	description = "A sugary syrup that tastes of cinnamon."
	taste_description = "cinnamon"
	color = "#ec612a"
	cup_prefix = "cinnamon"

/datum/reagent/drink/syrup/pistachio
	name = REAGENT_SYRUPPISTACHIO
	id = REAGENT_ID_SYRUPPISTACHIO
	description = "A sugary syrup that tastes of pistachio."
	taste_description = "pistachio"
	color = "#c9eb59"
	cup_prefix = "pistachio"

	allergen_type = ALLERGEN_SUGARS|ALLERGEN_SEEDS

/datum/reagent/drink/syrup/vanilla
	name = REAGENT_SYRUPVANILLA
	id = REAGENT_ID_SYRUPVANILLA
	description = "A sugary syrup that tastes of vanilla."
	taste_description = "vanilla"
	color = "#eaebd1"
	cup_prefix = REAGENT_ID_VANILLA

/datum/reagent/drink/syrup/toffee
	name = REAGENT_SYRUPTOFFEE
	id = REAGENT_ID_SYRUPTOFFEE
	description = "A sugary syrup that tastes of toffee."
	taste_description = "toffee"
	color = "#aa7143"
	cup_prefix = "toffee"

/datum/reagent/drink/syrup/cherry
	name = REAGENT_SYRUPCHERRY
	id = REAGENT_ID_SYRUPCHERRY
	description = "A sugary syrup that tastes of cherries."
	taste_description = "cherries"
	color = "#ff0000"
	cup_prefix = "cherry"

	allergen_type = ALLERGEN_SUGARS|ALLERGEN_FRUIT

/datum/reagent/drink/syrup/butterscotch
	name = REAGENT_SYRUPBUTTERSCOTCH
	id = REAGENT_ID_SYRUPBUTTERSCOTCH
	description = "A sugary syrup that tastes of butterscotch."
	taste_description = "butterscotch"
	color = "#e6924e"
	cup_prefix = "butterscotch"

/datum/reagent/drink/syrup/chocolate
	name = REAGENT_SYRUPCHOCOLATE
	id = REAGENT_ID_SYRUPCHOCOLATE
	description = "A sugary syrup that tastes of chocolate."
	taste_description = REAGENT_ID_CHOCOLATE
	color = "#873600"
	cup_prefix = REAGENT_ID_CHOCOLATE

	allergen_type = ALLERGEN_SUGARS|ALLERGEN_CHOCOLATE

/datum/reagent/drink/syrup/wchocolate
	name = REAGENT_SYRUPWHITECHOCOLATE
	id = REAGENT_ID_SYRUPWHITECHOCOLATE
	description = "A sugary syrup that tastes of white chocolate."
	taste_description = "white chocolate"
	color = "#c4c6a5"
	cup_prefix = "white chocolate"

	allergen_type = ALLERGEN_SUGARS|ALLERGEN_CHOCOLATE

/datum/reagent/drink/syrup/strawberry
	name = REAGENT_SYRUPSTRAWBERRY
	id = REAGENT_ID_SYRUPSTRAWBERRY
	description = "A sugary syrup that tastes of strawberries."
	taste_description = "strawberries"
	color = "#ff2244"
	cup_prefix = "strawberry"

	allergen_type = ALLERGEN_SUGARS|ALLERGEN_FRUIT

/datum/reagent/drink/syrup/coconut
	name = REAGENT_SYRUPCOCONUT
	id = REAGENT_ID_SYRUPCOCONUT
	description = "A sugary syrup that tastes of coconut."
	taste_description = "coconut"
	color = "#ffffff"
	cup_prefix = "coconut"

	allergen_type = ALLERGEN_SUGARS|ALLERGEN_FRUIT

/datum/reagent/drink/syrup/ginger
	name = REAGENT_SYRUPGINGER
	id = REAGENT_ID_SYRUPGINGER
	description = "A sugary syrup that tastes of ginger."
	taste_description = "ginger"
	color = "#d09740"
	cup_prefix = "ginger"

/datum/reagent/drink/syrup/gingerbread
	name = REAGENT_SYRUPGINGERBREAD
	id = REAGENT_ID_SYRUPGINGERBREAD
	description = "A sugary syrup that tastes of gingerbread."
	taste_description = "gingerbread"
	color = "#b6790f"
	cup_prefix = "gingerbread"

/datum/reagent/drink/syrup/peppermint
	name = REAGENT_SYRUPPEPPERMINT
	id = REAGENT_ID_SYRUPPEPPERMINT
	description = "A sugary syrup that tastes of peppermint."
	taste_description = "peppermint"
	color = "#9ce06e"
	cup_prefix = "peppermint"

/datum/reagent/drink/syrup/birthday_cake
	name = REAGENT_SYRUPBIRTHDAY
	id = REAGENT_ID_SYRUPBIRTHDAY
	description = "A sugary syrup that tastes of an overload of sweetness."
	taste_description = "far too much sugar"
	color = "#ff00e6"
	cup_prefix = "birthday cake"

/* Alcohol */

// Basic

/datum/reagent/ethanol/absinthe
	name = REAGENT_ABSINTHE
	id = REAGENT_ID_ABSINTHE
	description = "Watch out that the Green Fairy doesn't come for you!"
	taste_description = "licorice"
	taste_mult = 1.5
	color = "#33EE00"
	strength = 12

	glass_name = REAGENT_ID_ABSINTHE
	glass_desc = "Wormwood, anise, oh my."

/datum/reagent/ethanol/ale
	name = REAGENT_ALE
	id = REAGENT_ID_ALE
	description = "A dark alcoholic beverage made by malted barley and yeast."
	taste_description = "hearty barley ale"
	color = "#4C3100"
	strength = 50

	glass_name = REAGENT_ID_ALE
	glass_desc = "A freezing pint of delicious ale"

	allergen_type = ALLERGEN_GRAINS //Barley is grain

/datum/reagent/ethanol/beer
	name = REAGENT_BEER
	id = REAGENT_ID_BEER
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	taste_description = "beer"
	color = "#FFD300"
	strength = 50
	nutriment_factor = 1

	glass_name = REAGENT_ID_BEER
	glass_desc = "A freezing pint of beer"

	allergen_type = ALLERGEN_GRAINS //Made from grains

/datum/reagent/ethanol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		if(alien == IS_DIONA)
			return
		M.adjust_nutrition((M.food_preference(allergen_type) / 2) * removed) //RS edit
		M.jitteriness = max(M.jitteriness - 3, 0)

/datum/reagent/ethanol/beer/lite
	name = REAGENT_LITEBEER
	id = REAGENT_ID_LITEBEER
	description = "An alcoholic beverage made from malted grains, hops, yeast, water, and water."
	taste_description = "bad beer"
	color = "#FFD300"
	strength = 75
	nutriment_factor = 1

	glass_name = "lite beer"
	glass_desc = "A freezing pint of lite beer"

	allergen_type = ALLERGEN_GRAINS //Made from grains

/datum/reagent/ethanol/bluecuracao
	name = REAGENT_BLUECURACAO
	id = REAGENT_ID_BLUECURACAO
	description = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000CD"
	strength = 15

	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."

	allergen_type = ALLERGEN_FRUIT //Made from oranges(fruit)

/datum/reagent/ethanol/cognac
	name = REAGENT_COGNAC
	id = REAGENT_ID_COGNAC
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#AB3C05"
	strength = 15

	glass_name = REAGENT_ID_COGNAC
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."

	allergen_type = ALLERGEN_FRUIT //Cognac is made from wine which is made from grapes.

/datum/reagent/ethanol/deadrum
	name = REAGENT_DEADRUM
	id = REAGENT_ID_DEADRUM
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
	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		M.dizziness +=5

/datum/reagent/ethanol/firepunch
	name = REAGENT_FIREPUNCH
	id = REAGENT_ID_FIREPUNCH
	description = "Yo ho ho and a jar of honey."
	taste_description = "sharp butterscotch"
	color = "#ECB633"
	strength = 7

	glass_name = "fire punch"
	glass_desc = "Yo ho ho and a jar of honey."

/datum/reagent/ethanol/gin
	name = REAGENT_GIN
	id = REAGENT_ID_GIN
	description = "It's gin. In space. I say, good sir."
	taste_description = "an alcoholic christmas tree"
	color = "#0064C6"
	strength = 50

	glass_name = REAGENT_ID_GIN
	glass_desc = "A crystal clear glass of Griffeater gin."

	allergen_type = ALLERGEN_FRUIT //Made from juniper berries

//Base type for alchoholic drinks containing coffee
/datum/reagent/ethanol/coffee
	name = REAGENT_DEVELOPER_WARNING
	id = REAGENT_ID_DEVELOPER_WARNING
	overdose = REAGENTS_OVERDOSE *1.5
	allergen_type = ALLERGEN_COFFEE|ALLERGEN_STIMULANT //Contains coffee or is made from coffee

/datum/reagent/ethanol/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(!(M.isSynthetic()))
		if(alien == IS_DIONA)
			return
		..()
		M.dizziness = max(0, M.dizziness - 5)
		M.drowsyness = max(0, M.drowsyness - 3)
		M.AdjustSleeping(-2)
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

/datum/reagent/ethanol/coffee/overdose(var/mob/living/carbon/M, var/alien)
	if(alien == IS_DIONA)
		return
	//if(alien == IS_TAJARA)
		//M.adjustToxLoss(4 * REM)
		//M.apply_effect(3, STUTTER) //VOREStation Edit end
	if(!(M.isSynthetic()))
		M.make_jittery(5)

/datum/reagent/ethanol/coffee/kahlua
	name = REAGENT_KAHLUA
	id = REAGENT_ID_KAHLUA
	description = "A widely known, Mexican coffee-flavored liqueur. In production since 1936!"
	taste_description = "spiked latte"
	taste_mult = 1.1
	color = "#4C3100"
	strength = 15

	glass_name = "RR coffee liquor"
	glass_desc = "A widely known, Mexican coffee-flavored liqueur. In production since 1936!"
//	glass_desc = "DAMN, THIS THING LOOKS ROBUST" //If this isn't what our players should talk like, it isn't what our game should say to them.

/datum/reagent/ethanol/melonliquor
	name = REAGENT_MELONLIQUOR
	id = REAGENT_ID_MELONLIQUOR
	description = "A relatively sweet and fruity 46 proof liquor."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 50

	glass_name = "melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."

	allergen_type = ALLERGEN_FRUIT //Made from watermelons

/datum/reagent/ethanol/melonspritzer
	name = REAGENT_MELONSPRITZER
	id = REAGENT_ID_MELONSPRITZER
	description = "Melons: Citrus style."
	taste_description = "sour melon"
	color = "#934D5D"
	strength = 10

	glass_name = "melon spritzer"
	glass_desc = "Melons: Citrus style."
	glass_special = list(DRINK_FIZZ)

	allergen_type = ALLERGEN_FRUIT //Made from watermelon juice, apple juice, and lime juice

/datum/reagent/ethanol/rum
	name = REAGENT_RUM
	id = REAGENT_ID_RUM
	description = "Yo-ho-ho and all that."
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#ECB633"
	strength = 15

	glass_name = REAGENT_ID_RUM
	glass_desc = "Makes you want to buy a ship and just go pillaging."

/datum/reagent/ethanol/sake //Made from rice, yes. Rice is technically a grain, but also kinda a psuedo-grain, so I don't count it for grain allergies.
	name = REAGENT_SAKE
	id = REAGENT_ID_SAKE
	description = "Anime's favorite drink."
	taste_description = "dry alcohol"
	color = "#DDDDDD"
	strength = 25

	glass_name = REAGENT_ID_SAKE
	glass_desc = "A glass of sake."

/datum/reagent/ethanol/sexonthebeach
	name = REAGENT_SEXONTHEBEACH
	id = REAGENT_ID_SEXONTHEBEACH
	description = "A concoction of vodka and a secret combination of orange juice and pomegranate."
	taste_description = "60% orange juice, 40% pomegranate, 100% alcohol"
	color = "#7051E3"
	strength = 15

	glass_name = "sex on the beach"
	glass_desc = "A concoction of vodka and a secret combination of orange juice and pomegranate."

	allergen_type = ALLERGEN_FRUIT //Made from orange juice

/datum/reagent/ethanol/tequila
	name = REAGENT_TEQUILA
	id = REAGENT_ID_TEQUILA
	description = "A strong and mildly flavored, Mexican produced spirit. Feeling thirsty hombre?"
	taste_description = "paint thinner"
	color = "#FFFF91"
	strength = 25

	glass_name = "Tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"

/datum/reagent/ethanol/thirteenloko
	name = REAGENT_THIRTEENLOKO
	id =REAGENT_ID_THIRTEENLOKO
	description = "A potent mixture of caffeine and alcohol."
	taste_description = "battery acid"
	color = "#102000"
	strength = 25
	nutriment_factor = 1

	glass_name = REAGENT_THIRTEENLOKO
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."
	allergen_type = ALLERGEN_STIMULANT //Holy shit dude.

/datum/reagent/ethanol/thirteenloko/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(!(M.isSynthetic()))
		if(alien == IS_DIONA)
			return
		M.drowsyness = max(0, M.drowsyness - 7)
		if (M.bodytemperature > 310)
			M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
		M.make_jittery(5)

/datum/reagent/ethanol/vermouth
	name = REAGENT_VERMOUTH
	id = REAGENT_ID_VERMOUTH
	description = "You suddenly feel a craving for a martini..."
	taste_description = "dry alcohol"
	taste_mult = 1.3
	color = "#91FF91" // rgb: 145, 255, 145
	strength = 15

	glass_name = REAGENT_ID_VERMOUTH
	glass_desc = "You wonder why you're even drinking this straight."
	allergen_type = ALLERGEN_FRUIT //Vermouth is made from wine which is made from grapes(fruit)

/datum/reagent/ethanol/vodka
	name = REAGENT_VODKA
	id = REAGENT_ID_VODKA
	description = "Number one drink AND fueling choice for Russians worldwide."
	taste_description = "grain alcohol"
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 15

	glass_name = REAGENT_ID_VODKA
	glass_desc = "The glass contain wodka. Xynta."

	allergen_type = ALLERGEN_GRAINS //Vodka is made from grains

/datum/reagent/ethanol/vodka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(!(M.isSynthetic()))
		M.apply_effect(max(M.radiation - 1 * removed, 0), IRRADIATE, check_protection = 0)

/datum/reagent/ethanol/whiskey
	name = REAGENT_WHISKEY
	id = REAGENT_ID_WHISKEY
	description = "A superb and well-aged single-malt whiskey. Damn."
	taste_description = "molasses"
	color = "#4C3100"
	strength = 25

	glass_name = REAGENT_ID_WHISKEY
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."

	allergen_type = ALLERGEN_GRAINS //Whiskey is also made from grain.

/datum/reagent/ethanol/redwine
	name = REAGENT_REDWINE
	id = REAGENT_ID_REDWINE
	description = "An premium alchoholic beverage made from distilled grape juice."
	taste_description = "bitter sweetness"
	color = "#7E4043" // rgb: 126, 64, 67
	strength = 15

	glass_name = "red wine"
	glass_desc = "A very classy looking drink."

	allergen_type = ALLERGEN_FRUIT //Wine is made from grapes (fruit)

/datum/reagent/ethanol/whitewine
	name = REAGENT_WHITEWINE
	id = REAGENT_ID_WHITEWINE
	description = "An premium alchoholic beverage made from fermenting of the non-coloured pulp of grapes."
	taste_description = "light fruity flavor"
	color = "#F4EFB0" // rgb: 244, 239, 176
	strength = 15

	glass_name = "white wine"
	glass_desc = "A very classy looking drink."

	allergen_type = ALLERGEN_FRUIT //Wine is made from grapes (fruit)

/datum/reagent/ethanol/carnoth
	name = REAGENT_CARNOTH
	id = REAGENT_ID_CARNOTH
	description = "An premium alchoholic beverage made with multiple hybridized species of grapes that give it a dark maroon coloration."
	taste_description = "alcoholic sweet flavor"
	color = "#5B0000" // rgb: 0, 100, 35
	strength = 20

	glass_name = REAGENT_ID_CARNOTH
	glass_desc = "A very classy looking drink."

	allergen_type = ALLERGEN_FRUIT //Wine is made from grapes (fruit)

/datum/reagent/ethanol/pwine
	name = REAGENT_PWINE
	id = REAGENT_ID_PWINE
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	color = "#000000"
	strength = 10
	druggy = 50
	halluci = 10

	glass_name = "???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"
	allergen_type = ALLERGEN_FRUIT //Made from berries which are fruit

/datum/reagent/ethanol/pwine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(!(M.isSynthetic()))
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

/datum/reagent/ethanol/wine
	name = REAGENT_DEVELOPER_WARNING // Unit test ignore
	id = REAGENT_ID_DEVELOPER_WARNING

/datum/reagent/ethanol/wine/champagne
	name = REAGENT_CHAMPAGNE
	id = REAGENT_ID_CHAMPAGNE
	description = "A sparkling wine made with Pinot Noir, Pinot Meunier, and Chardonnay."
	taste_description = "fizzy bitter sweetness"
	color = "#D1B166"

	glass_name = REAGENT_ID_CHAMPAGNE
	glass_desc = "An even classier looking drink."

	allergen_type = ALLERGEN_FRUIT //Still wine, and still made from grapes (fruit)

/datum/reagent/ethanol/cider
	name = REAGENT_CIDER
	id = REAGENT_ID_CIDER
	description = "Hard? Soft? No-one knows but it'll get you drunk."
	taste_description = "tartness"
	color = "#CE9C00" // rgb: 206, 156, 0
	strength = 10

	glass_name = REAGENT_ID_CIDER
	glass_desc = "The second most Irish drink."
	glass_special = list(DRINK_FIZZ)

	allergen_type = ALLERGEN_FRUIT //Made from fruit

// Cocktails


/datum/reagent/ethanol/acid_spit
	name = REAGENT_ACIDSPIT
	id = REAGENT_ID_ACIDSPIT
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	taste_description = "bitter tang"
	reagent_state = LIQUID
	color = "#365000"
	strength = 30

	glass_name = REAGENT_ACIDSPIT
	glass_desc = "A drink from the company archives. Made from live aliens."

	allergen_type = ALLERGEN_FRUIT //Made from wine (fruit)

/datum/reagent/ethanol/alliescocktail
	name = REAGENT_ALLIESCOCKTAIL
	id = REAGENT_ID_ALLIESCOCKTAIL
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	taste_description = "bitter sweetness"
	color = "#D8AC45"
	strength = 25

	glass_name = "Allies cocktail"
	glass_desc = "A drink made from your allies."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from vodka(grain) as well as martini(vermouth(fruit) and gin(fruit))

/datum/reagent/ethanol/aloe
	name = REAGENT_ALOE
	id = REAGENT_ID_ALOE
	description = "So very, very, very good."
	taste_description = "sweet and creamy"
	color = "#B7EA75"
	strength = 15

	glass_name = REAGENT_ALOE
	glass_desc = "Very, very, very good."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_DAIRY|ALLERGEN_GRAINS //Made from cream(dairy), whiskey(grains), and watermelon juice(fruit)

/datum/reagent/ethanol/amasec
	name = REAGENT_AMASEC
	id = REAGENT_ID_AMASEC
	description = "Official drink of the Gun Club!"
	taste_description = "dark and metallic"
	reagent_state = LIQUID
	color = "#FF975D"
	strength = 25

	glass_name = REAGENT_AMASEC
	glass_desc = "Always handy before combat!"

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from wine(fruit) and vodka(grains)

/datum/reagent/ethanol/andalusia
	name = REAGENT_ANDALUSIA
	id = REAGENT_ID_ANDALUSIA
	description = "A nice, strangely named drink."
	taste_description = "lemons"
	color = "#F4EA4A"
	strength = 15

	glass_name = REAGENT_ANDALUSIA
	glass_desc = "A nice, strange named drink."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from whiskey(grains) and lemonjuice (fruit)

/datum/reagent/ethanol/antifreeze
	name = REAGENT_ANTIFREEZE
	id = REAGENT_ID_ANTIFREEZE
	description = "Ultimate refreshment."
	taste_description = "ice cold vodka"
	color = "#56DEEA"
	strength = 12
	adj_temp = 20
	targ_temp = 330

	glass_name = REAGENT_ANTIFREEZE
	glass_desc = "The ultimate refreshment."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_DAIRY //Made from vodka(grains) and cream(dairy)

/datum/reagent/ethanol/atomicbomb
	name = REAGENT_ATOMICBOMB
	id = REAGENT_ID_ATOMICBOMB
	description = "Nuclear proliferation never tasted so good."
	taste_description = "coffee, almonds, and whiskey, with a kick"
	reagent_state = LIQUID
	color = "#666300"
	strength = 10
	druggy = 50

	glass_name = REAGENT_ATOMICBOMB
	glass_desc = "We cannot take legal responsibility for your actions after imbibing."

	allergen_type = ALLERGEN_COFFEE|ALLERGEN_DAIRY|ALLERGEN_FRUIT|ALLERGEN_GRAINS|ALLERGEN_STIMULANT //Made from b52 which contains kahlua(coffee/caffeine), cognac(fruit), and irish cream(Whiskey(grains),cream(dairy))

/datum/reagent/ethanol/coffee/b52
	name = REAGENT_B52
	id = REAGENT_ID_B52
	description = "Kahlua, Irish cream, and cognac. You will get bombed."
	taste_description = "coffee, almonds, and whiskey"
	taste_mult = 1.3
	color = "#997650"
	strength = 12

	glass_name = REAGENT_B52
	glass_desc = "Kahlua, Irish cream, and cognac. You will get bombed."

	allergen_type = ALLERGEN_COFFEE|ALLERGEN_DAIRY|ALLERGEN_FRUIT|ALLERGEN_GRAINS|ALLERGEN_STIMULANT //Made from kahlua(coffee/caffeine), cognac(fruit), and irish cream(Whiskey(grains),cream(dairy))

/datum/reagent/ethanol/bahama_mama
	name = REAGENT_BAHAMAMAMA
	id = REAGENT_ID_BAHAMAMAMA
	description = "Tropical cocktail."
	taste_description = "lime and orange"
	color = "#FF7F3B"
	strength = 25

	glass_name = "Bahama Mama"
	glass_desc = "Tropical cocktail."

	allergen_type = ALLERGEN_FRUIT //Made from orange juice and lime juice

/datum/reagent/ethanol/bananahonk
	name = REAGENT_BANANAHONK
	id = REAGENT_ID_BANANAHONK
	description = "A drink from " + JOB_CLOWN + " Heaven."
	taste_description = "bananas and sugar"
	nutriment_factor = 1
	color = "#FFFF91"
	strength = 12

	glass_name = "Banana Honk"
	glass_desc = "A drink from Banana Heaven."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_DAIRY //Made from banana juice(fruit) and cream(dairy)

/datum/reagent/ethanol/barefoot
	name = REAGENT_BAREFOOT
	id = REAGENT_ID_BAREFOOT
	description = "Barefoot and pregnant."
	taste_description = "creamy berries"
	color = "#FFCDEA"
	strength = 30

	glass_name = REAGENT_BAREFOOT
	glass_desc = "Barefoot and pregnant."

	allergen_type = ALLERGEN_DAIRY|ALLERGEN_FRUIT //Made from berry juice (fruit), cream(dairy), and vermouth(fruit)

/datum/reagent/ethanol/beepsky_smash
	name = REAGENT_BEEPSKYSMASH
	id = REAGENT_ID_BEEPSKYSMASH
	description = "Deny drinking this and prepare for THE LAW."
	taste_description = "whiskey and citrus"
	taste_mult = 2
	reagent_state = LIQUID
	color = "#404040"
	strength = 12

	glass_name = REAGENT_BEEPSKYSMASH
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from whiskey(grains), and limejuice(fruit)

/datum/reagent/ethanol/beepsky_smash/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		M.Stun(2)

/datum/reagent/ethanol/bilk
	name = REAGENT_BILK
	id = REAGENT_ID_BILK
	description = "This appears to be beer mixed with milk. Disgusting."
	taste_description = "sour milk"
	color = "#895C4C"
	strength = 50
	nutriment_factor = 2

	glass_name = REAGENT_ID_BILK
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_DAIRY //Made from milk(dairy) and beer(grains)

/datum/reagent/ethanol/black_russian
	name = REAGENT_BLACKRUSSIAN
	id = REAGENT_ID_BLACKRUSSIAN
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	taste_description = "coffee"
	color = "#360000"
	strength = 15

	glass_name = REAGENT_BLACKRUSSIAN
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."

	allergen_type = ALLERGEN_COFFEE|ALLERGEN_GRAINS|ALLERGEN_STIMULANT //Made from vodka(grains) and kahlua(coffee/caffeine)

/datum/reagent/ethanol/bloody_mary
	name = REAGENT_BLOODYMARY
	id = REAGENT_ID_BLOODYMARY
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	taste_description = "tomatoes with a hint of lime"
	color = "#B40000"
	strength = 15

	glass_name = REAGENT_BLOODYMARY
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from vodka (grains), tomato juice(fruit), and lime juice(fruit)

/datum/reagent/ethanol/booger
	name = REAGENT_BOOGER
	id = REAGENT_ID_BOOGER
	description = "Ewww..."
	taste_description = "sweet 'n creamy"
	color = "#8CFF8C"
	strength = 30

	glass_name = REAGENT_BOOGER
	glass_desc = "Ewww..."

	allergen_type = ALLERGEN_DAIRY|ALLERGEN_FRUIT //Made from cream(dairy), banana juice(fruit), and watermelon juice(fruit)

/datum/reagent/ethanol/coffee/brave_bull //Since it's under the /coffee subtype, it already has coffee and caffeine allergens.
	name = REAGENT_BRAVEBULL
	id = REAGENT_ID_BRAVEBULL
	description = "It's just as effective as Dutch-Courage!"
	taste_description = "coffee and paint thinner"
	taste_mult = 1.1
	color = "#4C3100"
	strength = 15

	glass_name = REAGENT_BRAVEBULL
	glass_desc = "Tequilla and coffee liquor, brought together in a mouthwatering mixture. Drink up."

/datum/reagent/ethanol/changeling_sting
	name = REAGENT_CHANGELINGSTING
	id = REAGENT_ID_CHANGELINGSTING
	description = "You take a tiny sip and feel a burning sensation..."
	taste_description = "constantly changing flavors"
	color = "#2E6671"
	strength = 10

	glass_name = REAGENT_CHANGELINGSTING
	glass_desc = "A stingy drink."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from screwdriver(vodka(grains), orange juice(fruit)), lime juice(fruit), and lemon juice(fruit)

/datum/reagent/ethanol/martini
	name = REAGENT_MARTINI
	id = REAGENT_ID_MARTINI
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "dry class"
	color = "#0064C8"
	strength = 25

	glass_name = "classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."

	allergen_type = ALLERGEN_FRUIT //Made from gin(fruit) and vermouth(fruit)

/datum/reagent/ethanol/cuba_libre
	name = REAGENT_CUBALIBRE
	id = REAGENT_ID_CUBALIBRE
	description = "Rum, mixed with cola and a splash of lime. Viva la revolucion."
	taste_description = "cola with lime"
	color = "#3E1B00"
	strength = 30

	glass_name = REAGENT_CUBALIBRE
	glass_desc = "A classic mix of rum, cola, and lime."
	allergen_type = ALLERGEN_STIMULANT //Cola

/datum/reagent/ethanol/rum_and_cola
	name = REAGENT_RUMANDCOLA
	id = REAGENT_ID_RUMANDCOLA
	description = "A classic mix of sugar with more sugar."
	taste_description = "cola"
	color = "#3E1B00"
	strength = 30

	glass_name = "rum and cola"
	glass_desc = "A classic mix of rum and cola."
	allergen_type = ALLERGEN_STIMULANT // Cola

/datum/reagent/ethanol/demonsblood
	name = REAGENT_DEMONSBLOOD
	id = REAGENT_ID_DEMONSBLOOD
	description = "This thing makes the hair on the back of your neck stand up."
	taste_description = "sweet tasting iron"
	taste_mult = 1.5
	color = "#820000"
	strength = 15

	glass_name = "Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair on the back of your neck stand up."
	allergen_type = ALLERGEN_FRUIT|ALLERGEN_STIMULANT //Made from space mountain wind(fruit) and dr.gibb(caffeine)

/datum/reagent/ethanol/devilskiss
	name = REAGENT_DEVILSKISS
	id = REAGENT_ID_DEVILSKISS
	description = "Creepy time!"
	taste_description = "bitter iron"
	color = "#A68310"
	strength = 15

	glass_name = "Devil's Kiss"
	glass_desc = "Creepy time!"
	allergen_type = ALLERGEN_COFFEE|ALLERGEN_STIMULANT //Made from kahlua (Coffee)

/datum/reagent/ethanol/driestmartini
	name = REAGENT_DRIESTMARTINI
	id = REAGENT_ID_DRIESTMARTINI
	description = "Only for the experienced. You think you see sand floating in the glass."
	taste_description = "a beach"
	nutriment_factor = 1
	color = "#2E6671"
	strength = 12

	glass_name = REAGENT_DRIESTMARTINI
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."
	allergen_type = ALLERGEN_FRUIT //Made from gin(fruit)

/datum/reagent/ethanol/ginfizz
	name = REAGENT_GINFIZZ
	id = REAGENT_ID_GINFIZZ
	description = "Refreshingly lemony, deliciously dry."
	taste_description = "dry, tart lemons"
	color = "#FFFFAE"
	strength = 30

	glass_name = "gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."

	allergen_type = ALLERGEN_FRUIT //Made from gin(fruit) and lime juice(fruit)

/datum/reagent/ethanol/grog
	name = REAGENT_GROG
	id = REAGENT_ID_GROG
	description = "Watered-down rum, pirate approved!"
	taste_description = "a poor excuse for alcohol"
	reagent_state = LIQUID
	color = "#FFBB00"
	strength = 100

	glass_name = REAGENT_ID_GROG
	glass_desc = "A fine and cepa drink for Space."

/datum/reagent/ethanol/erikasurprise
	name = REAGENT_ERIKASURPRISE
	id = REAGENT_ID_ERIKASURPRISE
	description = "The surprise is, it's green!"
	taste_description = "tartness and bananas"
	color = "#2E6671"
	strength = 15

	glass_name = REAGENT_ERIKASURPRISE
	glass_desc = "The surprise is, it's green!"

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from ale (grains), lime juice (fruit), whiskey(grains), banana juice(fruit)

/datum/reagent/ethanol/gargle_blaster
	name = REAGENT_GARGLEBLASTER
	id = REAGENT_ID_GARGLEBLASTER
	description = "Whoah, this stuff looks volatile!"
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"
	taste_mult = 5
	reagent_state = LIQUID
	color = "#7F00FF"
	strength = 10
	druggy = 15

	glass_name = REAGENT_GARGLEBLASTER
	glass_desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from vodka(grains), gin(fruit), whiskey(grains), cognac(fruit), and lime juice(fruit)

/datum/reagent/ethanol/gintonic
	name = REAGENT_GINTONIC
	id = REAGENT_ID_GINTONIC
	description = "An all time classic, mild cocktail."
	taste_description = "mild and tart"
	color = "#0064C8"
	strength = 50

	glass_name = "gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."

	allergen_type = ALLERGEN_FRUIT //Made from gin(fruit)

/datum/reagent/ethanol/goldschlager
	name = REAGENT_GOLDSCHLAGER
	id = REAGENT_ID_GOLDSCHLAGER
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	taste_description = "burning cinnamon"
	taste_mult = 1.3
	color = "#F4E46D"
	strength = 15

	glass_name = REAGENT_GOLDSCHLAGER
	glass_desc = "100 proof that teen girls will drink anything with gold in it."

	allergen_type = ALLERGEN_GRAINS //Made from vodka(grains)

/datum/reagent/ethanol/hippies_delight
	name = REAGENT_HIPPIESDELIGHT
	id = REAGENT_ID_HIPPIESDELIGHT
	description = "You just don't get it maaaan."
	taste_description = "giving peace a chance"
	reagent_state = LIQUID
	color = "#FF88FF"
	strength = 15
	druggy = 50

	glass_name = "Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from gargle blaster which contains vodka(grains), gin(fruit), whiskey(grains), cognac(fruit), and lime juice(fruit)
	//Also, yes. Mushrooms produce psilocybin; however, it's also still just a chemical compound, and not necessarily going to trigger a fungi allergy.

/datum/reagent/ethanol/hooch
	name = REAGENT_HOOCH
	id = REAGENT_ID_HOOCH
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	taste_description = "pure alcohol"
	color = "#4C3100"
	strength = 25
	toxicity = 2

	glass_name = REAGENT_HOOCH
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/iced_beer
	name = REAGENT_ICEDBEER
	id = REAGENT_ID_ICEDBEER
	description = "A beer which is so cold the air around it freezes."
	taste_description = "refreshingly cold"
	color = "#FFD300"
	strength = 50
	adj_temp = -20
	targ_temp = 280

	glass_name = "iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_special = list(DRINK_ICE)
	allergen_type = ALLERGEN_GRAINS //Made from beer(grains)

/datum/reagent/ethanol/irishcarbomb
	name = REAGENT_IRISHCARBOMB
	id = REAGENT_ID_IRISHCARBOMB
	description = "Mmm, tastes like chocolate cake..."
	taste_description = "delicious anger"
	color = "#2E6671"
	strength = 15

	glass_name = REAGENT_IRISHCARBOMB
	glass_desc = "An irish car bomb."

	allergen_type = ALLERGEN_DAIRY|ALLERGEN_GRAINS //Made from ale(grains) and irish cream(whiskey(grains), cream(dairy))

/datum/reagent/ethanol/coffee/irishcoffee
	name = REAGENT_IRISHCOFFEE
	id = REAGENT_ID_IRISHCOFFEE
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	taste_description = "giving up on the day"
	color = "#4C3100"
	strength = 15

	glass_name = "Irish coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."

	allergen_type = ALLERGEN_COFFEE|ALLERGEN_DAIRY|ALLERGEN_GRAINS|ALLERGEN_STIMULANT //Made from Coffee(coffee/caffeine) and irish cream(whiskey(grains), cream(dairy))

/datum/reagent/ethanol/irish_cream
	name = REAGENT_IRISHCREAM
	id = REAGENT_ID_IRISHCREAM
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	taste_description = "creamy alcohol"
	color = "#DDD9A3"
	strength = 25

	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"

	allergen_type = ALLERGEN_DAIRY|ALLERGEN_GRAINS //Made from cream(dairy) and whiskey(grains)

/datum/reagent/ethanol/longislandicedtea
	name = REAGENT_LONGISLANDICEDTEA
	id = REAGENT_ID_LONGISLANDICEDTEA
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	taste_description = "sweet tea, with a kick"
	color = "#895B1F"
	strength = 12

	glass_name = "Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT|ALLERGEN_STIMULANT //Made from vodka(grains), cola(caffeine) and gin(fruit)

/datum/reagent/ethanol/manhattan
	name = REAGENT_MANHATTAN
	id = REAGENT_ID_MANHATTAN
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	taste_description = "mild dryness"
	color = "#C13600"
	strength = 15

	glass_name = REAGENT_MANHATTAN
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from whiskey(grains), and vermouth(fruit)

/datum/reagent/ethanol/manhattan_proj
	name = REAGENT_MANHATTANPROJ
	id = REAGENT_ID_MANHATTANPROJ
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	taste_description = "death, the destroyer of worlds"
	color = "#C15D00"
	strength = 10
	druggy = 30

	glass_name = REAGENT_MANHATTANPROJ
	glass_desc = "A scientist's drink of choice, for thinking how to blow up the station."
	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from manhattan which is made from whiskey(grains), and vermouth(fruit)

/datum/reagent/ethanol/manly_dorf
	name = REAGENT_MANLYDORF
	id = REAGENT_ID_MANLYDORF
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	taste_description = "hair on your chest and your chin"
	color = "#4C3100"
	strength = 25

	glass_name = REAGENT_MANLYDORF
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."

	allergen_type = ALLERGEN_GRAINS //Made from beer(grains) and ale(grains)

/datum/reagent/ethanol/margarita
	name = REAGENT_MARGARITA
	id = REAGENT_ID_MARGARITA
	description = "On the rocks with salt on the rim. Arriba~!"
	taste_description = "dry and salty"
	color = "#8CFF8C"
	strength = 15

	glass_name = REAGENT_ID_MARGARITA
	glass_desc = "On the rocks with salt on the rim. Arriba~!"

	allergen_type = ALLERGEN_FRUIT //Made from lime juice(fruit)

/datum/reagent/ethanol/mead
	name = REAGENT_MEAD
	id = REAGENT_ID_MEAD
	description = "A Viking's drink, though a cheap one."
	taste_description = "sweet yet alcoholic"
	reagent_state = LIQUID
	color = "#FFBB00"
	strength = 30
	nutriment_factor = 1

	glass_name = REAGENT_ID_MEAD
	glass_desc = "A Viking's beverage, though a cheap one."

/datum/reagent/ethanol/moonshine
	name = REAGENT_MOONSHINE
	id = REAGENT_ID_MOONSHINE
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_description = "bitterness"
	taste_mult = 2.5
	color = "#0064C8"
	strength = 12

	glass_name = REAGENT_ID_MOONSHINE
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/neurotoxin
	name = REAGENT_NEUROTOXIN
	id = REAGENT_ID_NEUROTOXIN
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "a numbing sensation"
	reagent_state = LIQUID
	color = "#2E2E61"
	strength = 10

	glass_name = REAGENT_NEUROTOXIN
	glass_desc = "A drink that is guaranteed to knock you silly."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list("neuroright")

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from gargle blaster which is made from vodka(grains), gin(fruit), whiskey(grains), cognac(fruit), and lime juice(fruit)

/datum/reagent/ethanol/neurotoxin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		M.Weaken(3)

/datum/reagent/ethanol/patron
	name = REAGENT_PATRON
	id = REAGENT_ID_PATRON
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	taste_description = "metallic paint thinner"
	color = "#585840"
	strength = 30

	glass_name = REAGENT_PATRON
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."

/datum/reagent/ethanol/red_mead
	name = REAGENT_REDMEAD
	id = REAGENT_ID_REDMEAD
	description = "The true Viking's drink! Even though it has a strange red color."
	taste_description = "sweet and salty alcohol"
	color = "#C73C00"
	strength = 30

	glass_name = "red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."

/datum/reagent/ethanol/sbiten
	name = REAGENT_SBITEN
	id = REAGENT_ID_SBITEN
	description = "A spicy Vodka! Might be a bit hot for the little guys!"
	taste_description = "hot and spice"
	color = "#FFA371"
	strength = 15
	adj_temp = 50
	targ_temp = 360

	glass_name = REAGENT_SBITEN
	glass_desc = "A spicy mix of Vodka and Spice. Very hot."

	allergen_type = ALLERGEN_GRAINS //Made from vodka(grains)

/datum/reagent/ethanol/screwdrivercocktail
	name = REAGENT_SCREWDRIVERCOCKTAIL
	id = REAGENT_ID_SCREWDRIVERCOCKTAIL
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	taste_description = "oranges"
	color = "#A68310"
	strength = 15

	glass_name = REAGENT_SCREWDRIVERCOCKTAIL
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from vodka(grains) and orange juice(fruit)

/datum/reagent/ethanol/silencer
	name = REAGENT_SILENCER
	id = REAGENT_ID_SILENCER
	description = "A drink from " + JOB_MIME + " Heaven."
	taste_description = "a pencil eraser"
	taste_mult = 1.2
	nutriment_factor = 1
	color = "#FFFFFF"
	strength = 12

	glass_name = REAGENT_SILENCER
	glass_desc = "A drink from mime Heaven."
	allergen_type = ALLERGEN_DAIRY //Made from cream (dairy)

/datum/reagent/ethanol/singulo
	name = REAGENT_SINGULO
	id = REAGENT_ID_SINGULO
	description = "A blue-space beverage!"
	taste_description = "concentrated matter"
	color = "#2E6671"
	strength = 10

	glass_name = REAGENT_SINGULO
	glass_desc = "A blue-space beverage."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from vodka(grains) and wine(fruit)

/datum/reagent/ethanol/snowwhite
	name = REAGENT_SNOWWHITE
	id = REAGENT_ID_SNOWWHITE
	description = "A cold refreshment"
	taste_description = "refreshing cold"
	color = "#FFFFFF"
	strength = 30

	glass_name = REAGENT_SNOWWHITE
	glass_desc = "A cold refreshment."

	allergen_type = ALLERGEN_COFFEE|ALLERGEN_FRUIT|ALLERGEN_STIMULANT //made from Pineapple juice(fruit), lemon_lime(fruit), and kahlua(coffee/caffine)

/datum/reagent/ethanol/suidream
	name = REAGENT_SUIDREAM
	id = REAGENT_ID_SUIDREAM
	description = "Comprised of: White soda, blue curacao, melon liquor."
	taste_description = "fruit"
	color = "#00A86B"
	strength = 100

	glass_name = REAGENT_SUIDREAM
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."

	allergen_type = ALLERGEN_FRUIT //Made from blue curacao(fruit) and melon liquor(fruit)

/datum/reagent/ethanol/syndicatebomb
	name = REAGENT_SYNDICATEBOMB
	id = REAGENT_ID_SYNDICATEBOMB
	description = "Tastes like terrorism!"
	taste_description = "strong alcohol"
	color = "#2E6671"
	strength = 10

	glass_name = REAGENT_SYNDICATEBOMB
	glass_desc = "Tastes like terrorism!"

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_STIMULANT //Made from beer(grain) and whiskeycola(whiskey(grain) and cola(caffeine))

/datum/reagent/ethanol/tequila_sunrise
	name = REAGENT_TEQUILASUNRISE
	id = REAGENT_ID_TEQUILASUNRISE
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~."
	taste_description = "oranges"
	color = "#FFE48C"
	strength = 25

	glass_name = "Tequilla Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Earth..."

/datum/reagent/ethanol/threemileisland
	name = REAGENT_THREEMILEISLAND
	id = REAGENT_ID_THREEMILEISLAND
	description = "Made for a woman, strong enough for a man."
	taste_description = "dry"
	color = "#666340"
	strength = 10
	druggy = 50

	glass_name = "Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from long island iced tea(vodka(grains) and gin(fruit))

/datum/reagent/ethanol/toxins_special
	name = REAGENT_PHORONSPECIAL
	id = REAGENT_ID_PHORONSPECIAL
	description = "This thing is literally on fire!"
	taste_description = "spicy toxins"
	reagent_state = LIQUID
	color = "#7F00FF"
	strength = 10
	adj_temp = 15
	targ_temp = 330

	glass_name = REAGENT_PHORONSPECIAL
	glass_desc = "Whoah, this thing is on fire!"

	allergen_type = ALLERGEN_FRUIT //Made from vermouth(fruit)

/datum/reagent/ethanol/vodkamartini
	name = REAGENT_VODKAMARTINI
	id = REAGENT_ID_VODKAMARTINI
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "shaken, not stirred"
	color = "#0064C8"
	strength = 12

	glass_name = "vodka martini"
	glass_desc ="A bastardization of the classic martini. Still great."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //made from vodka(grains) and vermouth(fruit)

/datum/reagent/ethanol/vodkatonic
	name = REAGENT_VODKATONIC
	id = REAGENT_ID_VODKATONIC
	description = "For when a gin and tonic isn't Russian enough."
	taste_description = "tart bitterness"
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."

	allergen_type = ALLERGEN_GRAINS //Made from vodka(grains)

/datum/reagent/ethanol/white_russian
	name = REAGENT_WHITERUSSIAN
	id = REAGENT_ID_WHITERUSSIAN
	description = "That's just, like, your opinion, man..."
	taste_description = "coffee icecream"
	color = "#A68340"
	strength = 15

	glass_name = REAGENT_WHITERUSSIAN
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."

	allergen_type = ALLERGEN_COFFEE|ALLERGEN_GRAINS|ALLERGEN_DAIRY|ALLERGEN_STIMULANT //Made from black russian(vodka(grains), kahlua(coffee/caffeine)) and cream(dairy)

/datum/reagent/ethanol/whiskey_cola
	name = REAGENT_WHISKEYCOLA
	id = REAGENT_ID_WHISKEYCOLA
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	taste_description = "cola with an alcoholic undertone"
	color = "#3E1B00"
	strength = 25

	glass_name = "whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_STIMULANT //Made from whiskey(grains) and cola(caffeine)

/datum/reagent/ethanol/whiskeysoda
	name = REAGENT_WHISKEYSODA
	id = REAGENT_ID_WHISKEYSODA
	description = "Ultimate refreshment."
	taste_description = "carbonated whiskey"
	color = "#EAB300"
	strength = 15

	glass_name = "whiskey soda"
	glass_desc = "Ultimate refreshment."

	allergen_type = ALLERGEN_GRAINS //Made from whiskey(grains)

/datum/reagent/ethanol/specialwhiskey // I have no idea what this is and where it comes from
	name = REAGENT_SPECIALWHISKEY
	id = REAGENT_ID_SPECIALWHISKEY
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything. The smell of it singes your nostrils."
	taste_description = "unspeakable whiskey bliss"
	color = "#523600"
	strength = 7

	glass_name = "special blend whiskey"
	glass_desc = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."

	allergen_type = ALLERGEN_GRAINS //Whiskey(grains)

/datum/reagent/ethanol/unathiliquor
	name = REAGENT_UNATHILIQUOR
	id = REAGENT_ID_UNATHILIQUOR
	description = "This barely qualifies as a drink, and could give jet fuel a run for its money. Also known to cause feelings of euphoria and numbness."
	taste_description = "spiced numbness"
	color = "#242424"
	strength = 5

	glass_name = "unathi liquor"
	glass_desc = "This barely qualifies as a drink, and may cause euphoria and numbness. Imbiber beware!"

/datum/reagent/ethanol/unathiliquor/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		if(alien == IS_DIONA)
			return

		var/drug_strength = 10
		if(alien == IS_SKRELL)
			drug_strength = drug_strength * 0.8

		M.druggy = max(M.druggy, drug_strength)
		if(prob(10) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
			step(M, pick(cardinal))

/datum/reagent/ethanol/sakebomb
	name = REAGENT_SAKEBOMB
	id = REAGENT_ID_SAKEBOMB
	description = "Alcohol in more alcohol."
	taste_description = "thick, dry alcohol"
	color = "#FFFF7F"
	strength = 12
	nutriment_factor = 1

	glass_name = REAGENT_SAKEBOMB
	glass_desc = "Some sake mixed into a pint of beer."

	allergen_type = ALLERGEN_GRAINS //Made from beer(grains)

/datum/reagent/ethanol/tamagozake
	name = REAGENT_TAMAGOZAKE
	id = REAGENT_ID_TAMAGOZAKE
	description = "Sake, egg, and sugar. A disgusting folk cure."
	taste_description = "eggy booze"
	color = "#E8C477"
	strength = 30
	nutriment_factor = 3

	glass_name = REAGENT_TAMAGOZAKE
	glass_desc = "An egg cracked into sake and sugar."
	allergen_type = ALLERGEN_EGGS //Made with eggs

/datum/reagent/ethanol/ginzamary
	name = REAGENT_GINZAMARY
	id = REAGENT_ID_GINZAMARY
	description = "An alcoholic drink made with vodka, sake, and juices."
	taste_description = "spicy tomato sake"
	color = "#FF3232"
	strength = 25

	glass_name = REAGENT_GINZAMARY
	glass_desc = "Tomato juice, vodka, and sake make something not quite completely unlike a Bloody Mary."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from vodka(grains) and tomatojuice(fruit)

/datum/reagent/ethanol/tokyorose
	name = REAGENT_TOKYOROSE
	id = REAGENT_ID_TOKYOROSE
	description = "A pale pink cocktail made with sake and berry juice."
	taste_description = "fruity booze"
	color = "#FA8072"
	strength = 35

	glass_name = REAGENT_TOKYOROSE
	glass_desc = "It's kinda pretty!"

	allergen_type = ALLERGEN_FRUIT //Made from berryjuice

/datum/reagent/ethanol/saketini
	name = REAGENT_SAKETINI
	id = REAGENT_ID_SAKETINI
	description = "For when you're too weeb for a real martini."
	taste_description = "dry alcohol"
	color = "#0064C8"
	strength = 15

	glass_name = REAGENT_SAKETINI
	glass_desc = "What are you doing drinking this outside of New Kyoto?"

	allergen_type = ALLERGEN_FRUIT //Made from gin(fruit)

/datum/reagent/ethanol/coffee/elysiumfacepunch
	name = REAGENT_ELYSIUMFACEPUNCH
	id = REAGENT_ID_ELYSIUMFACEPUNCH
	description = "A loathesome cocktail favored by Heaven's skeleton shift workers."
	taste_description = "sour coffee"
	color = "#8f7729"
	strength = 20

	glass_name = REAGENT_ELYSIUMFACEPUNCH
	glass_desc = "A loathesome cocktail favored by Heaven's skeleton shift workers."

	allergen_type = ALLERGEN_COFFEE|ALLERGEN_FRUIT|ALLERGEN_STIMULANT //Made from kahlua(Coffee/caffeine) and lemonjuice(fruit)

/datum/reagent/ethanol/erebusmoonrise
	name = REAGENT_EREBUSMOONRISE
	id = REAGENT_ID_EREBUSMOONRISE
	description = "A deeply alcoholic mix, popular in Nyx."
	taste_description = "hard alcohol"
	color = "#947459"
	strength = 10

	glass_name = REAGENT_EREBUSMOONRISE
	glass_desc = "A deeply alcoholic mix, popular in Nyx."

	allergen_type = ALLERGEN_GRAINS //Made from whiskey(grains) and Vodka(grains)

/datum/reagent/ethanol/balloon
	name = REAGENT_BALLOON
	id = REAGENT_ID_BALLOON
	description = "A strange drink invented in the aerostats of Venus."
	taste_description = "strange alcohol"
	color = "#FAEBD7"
	strength = 66

	glass_name = REAGENT_BALLOON
	glass_desc = "A strange drink invented in the aerostats of Venus."

	allergen_type = ALLERGEN_DAIRY|ALLERGEN_FRUIT //Made from blue curacao(fruit) and cream(dairy)

/datum/reagent/ethanol/natunabrandy
	name = REAGENT_NATUNABRANDY
	id = REAGENT_ID_NATUNABRANDY
	description = "On Natuna, they do the best with what they have."
	taste_description = "watered-down beer"
	color = "#FFFFCC"
	strength = 80

	glass_name = REAGENT_NATUNABRANDY
	glass_desc = "On Natuna, they do the best with what they have."
	glass_special = list(DRINK_FIZZ)

	allergen_type = ALLERGEN_GRAINS //Made from beer(grains)

/datum/reagent/ethanol/euphoria
	name = REAGENT_EUPHORIA
	id = REAGENT_ID_EUPHORIA
	description = "Invented by a Eutopian marketing team, this is one of the most expensive cocktails in existence."
	taste_description = "impossibly rich alcohol"
	color = "#614126"
	strength = 9

	glass_name = REAGENT_EUPHORIA
	glass_desc = "Invented by a Eutopian marketing team, this is one of the most expensive cocktails in existence."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from specialwhiskey(grain) and cognac(fruit)

/datum/reagent/ethanol/xanaducannon
	name = REAGENT_XANADUCANNON
	id = REAGENT_ID_XANADUCANNON
	description = "Common in the entertainment districts of Titan."
	taste_description = "sweet alcohol"
	color = "#614126"
	strength = 50

	glass_name = REAGENT_XANADUCANNON
	glass_desc = "Common in the entertainment districts of Titan."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_STIMULANT //Made from ale(grain) and dr.gibb(caffeine)

/datum/reagent/ethanol/debugger
	name = REAGENT_DEBUGGER
	id = REAGENT_ID_DEBUGGER
	description = "From Shelf. Not for human consumption."
	taste_description = "oily bitterness"
	color = "#d3d3d3"
	strength = 32

	glass_name = REAGENT_DEBUGGER
	glass_desc = "From Shelf. Not for human consumption."
	allergen_type = ALLERGEN_VEGETABLE //Made from corn oil(vegetable)

/datum/reagent/ethanol/spacersbrew
	name = REAGENT_SPACERSBREW
	id = REAGENT_ID_SPACERSBREW
	description = "Ethanol and orange soda. A common emergency drink on frontier colonies."
	taste_description = "bitter oranges"
	color = "#ffc04c"
	strength = 43

	glass_name = REAGENT_SPACERSBREW
	glass_desc = "Ethanol and orange soda. A common emergency drink on frontier colonies."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_STIMULANT //Made from brownstar(orange juice(fruit) + cola(caffeine)

/datum/reagent/ethanol/binmanbliss
	name = REAGENT_BINMANBLISS
	id = REAGENT_ID_BINMANBLISS
	description = "A dry cocktail popular on Binma."
	taste_description = "very dry alcohol"
	color = "#c3c3c3"
	strength = 24

	glass_name = REAGENT_BINMANBLISS
	glass_desc = "A dry cocktail popular on Binma."

/datum/reagent/ethanol/chrysanthemum
	name = REAGENT_CHRYSANTHEMUM
	id = REAGENT_ID_CHRYSANTHEMUM
	description = "An exotic cocktail from New Kyoto."
	taste_description = "fruity liquor"
	color = "#9999FF"
	strength = 35

	glass_name = REAGENT_CHRYSANTHEMUM
	glass_desc = "An exotic cocktail from New Kyoto."

	allergen_type = ALLERGEN_FRUIT //Made from melon liquor(fruit)

/datum/reagent/ethanol/bitters
	name = REAGENT_BITTERS
	id = REAGENT_ID_BITTERS
	description = "An aromatic, typically alcohol-based infusions of bittering botanticals and flavoring agents like fruit peels, spices, dried flowers, and herbs."
	taste_description = "sharp bitterness"
	color = "#9b6241" // rgb(155, 98, 65)
	strength = 50

	glass_name = REAGENT_BITTERS
	glass_desc = "An aromatic, typically alcohol-based infusions of bittering botanticals and flavoring agents like fruit peels, spices, dried flowers, and herbs."

/datum/reagent/ethanol/soemmerfire
	name = REAGENT_SOEMMERFIRE
	id = REAGENT_ID_SOEMMERFIRE
	description = "A painfully hot mixed drink, for when you absolutely need to hurt right now."
	taste_description = "pure fire"
	color = "#d13b21" // rgb(209, 59, 33)
	strength = 25

	glass_name = REAGENT_SOEMMERFIRE
	glass_desc = "A painfully hot mixed drink, for when you absolutely need to hurt right now."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from manhattan(whiskey(grains), vermouth(fruit))

/datum/reagent/ethanol/soemmerfire/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT

/datum/reagent/ethanol/winebrandy
	name = REAGENT_WINEBRANDY
	id = REAGENT_ID_WINEBRANDY
	description = "A premium spirit made from distilled wine."
	taste_description = "very sweet dried fruit with many elegant notes"
	color = "#4C130B" // rgb(76,19,11)
	strength = 20

	glass_name = REAGENT_WINEBRANDY
	glass_desc = "A very classy looking after-dinner drink."

	allergen_type = ALLERGEN_FRUIT //Made from wine, which is made from fruit

/datum/reagent/ethanol/morningafter
	name = REAGENT_MORNINGAFTER
	id = REAGENT_ID_MORNINGAFTER
	description = "The finest hair of the dog, coming up!"
	taste_description = "bitter regrets"
	color = "#482000" // rgb(72, 32, 0)
	strength = 60

	glass_name = REAGENT_MORNINGAFTER
	glass_desc = "The finest hair of the dog, coming up!"

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_COFFEE|ALLERGEN_STIMULANT //Made from sbiten(vodka(grain)) and coffee(coffee/caffine)

/datum/reagent/ethanol/vesper
	name = REAGENT_VESPER
	id = REAGENT_ID_VESPER
	description = "A dry martini, ice cold and well shaken."
	taste_description = "lemony class"
	color = "#cca01c" // rgb(204, 160, 28)
	strength = 20

	glass_name = REAGENT_VESPER
	glass_desc = "A dry martini, ice cold and well shaken."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from wine(fruit), vodka(grain), and gin(fruit)

/datum/reagent/ethanol/rotgut
	name = REAGENT_ROTGUT
	id = REAGENT_ID_ROTGUT
	description = "A heinous combination of clashing flavors."
	taste_description = "plague and coldsweats"
	color = "#3a6617" // rgb(58, 102, 23)
	strength = 10

	glass_name = REAGENT_ROTGUT
	glass_desc = "Why are you doing this to yourself?"

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_STIMULANT //Made from whiskey(grains), cola (caffeine) and vodka(grains)

/datum/reagent/ethanol/voxdelight
	name = REAGENT_VOXDELIGHT
	id = REAGENT_ID_VOXDELIGHT
	description = "A dangerous combination of all things flammable. Why would you drink this?"
	taste_description = "corrosive death"
	color = "#7c003a" // rgb(124, 0, 58)
	strength = 10

	glass_name = REAGENT_VOXDELIGHT
	glass_desc = "Not recommended if you enjoy having organs."

/datum/reagent/ethanol/voxdelight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	if(alien == IS_VOX)
		M.adjustToxLoss(-0.5 * removed)
		return
	M.adjustToxLoss(3 * removed)

/datum/reagent/ethanol/screamingviking
	name =REAGENT_SCREAMINGVIKING
	id = REAGENT_ID_SCREAMINGVIKING
	description = "A boozy, citrus-packed brew."
	taste_description = "the bartender's frustration"
	color = "#c6c603" // rgb(198, 198, 3)
	strength = 9

	glass_name =REAGENT_SCREAMINGVIKING
	glass_desc = "A boozy, citrus-packed brew."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from martini(gin(fruit), vermouth(fruit)), vodka tonic(vodka(grain)), and lime juice(fruit)

/datum/reagent/ethanol/robustin
	name = REAGENT_ROBUSTIN
	id = REAGENT_ID_ROBUSTIN
	description = "A bootleg brew of all the worst things on station."
	taste_description = "cough syrup and fire"
	color = "#6b0145" // rgb(107, 1, 69)
	strength = 10

	glass_name = REAGENT_ROBUSTIN
	glass_desc = "A bootleg brew of all the worst things on station."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_DAIRY //Made from antifreeze(vodka(grains),cream(dairy)) and vodka(grains)

/datum/reagent/ethanol/virginsip
	name = REAGENT_VIRGINSIP
	id = REAGENT_ID_VIRGINSIP
	description = "A perfect martini, watered down and ruined."
	taste_description = "emasculation and failure"
	color = "#2E6671" // rgb(46, 102, 113)
	strength = 60

	glass_name = REAGENT_VIRGINSIP
	glass_desc = "A perfect martini, watered down and ruined."

	allergen_type = ALLERGEN_FRUIT //Made from driest martini(gin(fruit))

/datum/reagent/ethanol/jellyshot
	name = REAGENT_JELLYSHOT
	id = REAGENT_ID_JELLYSHOT
	description = "A thick and vibrant alcoholic gel, perfect for the night life."
	taste_description = "thick, alcoholic cherry gel"
	color = "#e00b0b" // rgb(224, 11, 11)
	strength = 10

	glass_name = REAGENT_JELLYSHOT
	glass_desc = "A thick and vibrant alcoholic gel, perfect for the night life."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from cherry jelly(fruit), and vodka(grains)

/datum/reagent/ethanol/slimeshot
	name = REAGENT_SLIMESHOT
	id = REAGENT_ID_SLIMESHOT
	description = "A thick and toxic slime jelly shot."
	taste_description = "liquified organs"
	color = "#6fa300" // rgb(111, 163, 0)
	strength = 10

	glass_name = REAGENT_SLIMESHOT
	glass_desc = "A thick slime jelly shot. You can feel your death approaching."

	allergen_type = ALLERGEN_GRAINS //Made from vodka(grains)

/datum/reagent/ethanol/slimeshot/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.reagents.add_reagent(REAGENT_ID_SLIMEJELLY, 0.25)

/datum/reagent/ethanol/cloverclub
	name = REAGENT_CLOVERCLUB
	id = REAGENT_ID_CLOVERCLUB
	description = "A light and refreshing raspberry cocktail."
	taste_description = "sweet raspberry"
	color = "#dd00a6" // rgb(221, 0, 166)
	strength = 30

	glass_name = REAGENT_CLOVERCLUB
	glass_desc = "A light and refreshing raspberry cocktail."

	allergen_type = ALLERGEN_FRUIT //Made from berry juice(fruit), lemon juice(fruit), and gin(fruit)

/datum/reagent/ethanol/negroni
	name = REAGENT_NEGRONI
	id = REAGENT_ID_NEGRONI
	description = "A dark, complicated mix of gin and campari... classy."
	taste_description = "summer nights and wood smoke"
	color = "#77000d" // rgb(119, 0, 13)
	strength = 25

	glass_name = REAGENT_NEGRONI
	glass_desc = "A dark, complicated blend, perfect for relaxing nights by the fire."

	allergen_type = ALLERGEN_FRUIT //Made from gin(fruit) and vermouth(fruit)

/datum/reagent/ethanol/whiskeysour
	name = REAGENT_WHISKEYSOUR
	id = REAGENT_ID_WHISKEYSOUR
	description = "A smokey, refreshing lemoned whiskey."
	taste_description = "smoke and citrus"
	color = "#a0692e" // rgb(160, 105, 46)
	strength = 20

	glass_name = REAGENT_WHISKEYSOUR
	glass_desc = "A smokey, refreshing lemoned whiskey."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_FRUIT //Made from whiskey(grains) and lemon juice(fruit)

/datum/reagent/ethanol/oldfashioned
	name = REAGENT_OLDFASHIONED
	id = REAGENT_ID_OLDFASHIONED
	description = "A classic mix of whiskey and sugar... simple and direct."
	taste_description = "smokey, divine whiskey"
	color = "#774410" // rgb(119, 68, 16)
	strength = 15

	glass_name = REAGENT_OLDFASHIONED
	glass_desc = "A classic mix of whiskey and sugar... simple and direct."

	allergen_type = ALLERGEN_GRAINS //Made from whiskey(grains)

/datum/reagent/ethanol/daiquiri
	name = REAGENT_DAIQUIRI
	id = REAGENT_ID_DAIQUIRI
	description = "Refeshing rum and citrus. Time for a tropical get away."
	taste_description = "refreshing citrus and rum"
	color = "#d1ff49" // rgb(209, 255, 73
	strength = 25

	glass_name = REAGENT_DAIQUIRI
	glass_desc = "Refeshing rum and citrus. Time for a tropical get away."

	allergen_type = ALLERGEN_FRUIT //Made from lime juice(fruit)

/datum/reagent/ethanol/mojito
	name = REAGENT_MOJITO
	id = REAGENT_ID_MOJITO
	description = "Minty rum and citrus, made for sailing."
	taste_description = "minty rum and lime"
	color = "#d1ff49" // rgb(209, 255, 73
	strength = 30

	glass_name = REAGENT_MOJITO
	glass_desc = "Minty rum and citrus, made for sailing."
	glass_special = list(DRINK_FIZZ)

	allergen_type = ALLERGEN_FRUIT //Made from lime juice(fruit)

/datum/reagent/ethanol/paloma
	name = REAGENT_PALOMA
	id = REAGENT_ID_PALOMA
	description = "Tequila and citrus, iced just right..."
	taste_description = "grapefruit and cold fire"
	color = "#ffb070" // rgb(255, 176, 112)
	strength = 20

	glass_name = REAGENT_PALOMA
	glass_desc = "Tequila and citrus, iced just right..."
	glass_special = list(DRINK_FIZZ)

	allergen_type = ALLERGEN_FRUIT //Made from orange juice(fruit)

/datum/reagent/ethanol/piscosour
	name = REAGENT_PISCOSOUR
	id = REAGENT_ID_PISCOSOUR
	description = "Wine Brandy, Lemon, and a dream. A South American classic"
	taste_description = "light sweetness"
	color = "#f9f96b" // rgb(249, 249, 107)
	strength = 30

	glass_name = REAGENT_PISCOSOUR
	glass_desc = "South American bliss, served ice cold."

	allergen_type = ALLERGEN_FRUIT //Made from wine brandy(fruit), and lemon juice(fruit)

/datum/reagent/ethanol/coldfront
	name = REAGENT_COLDFRONT
	id = REAGENT_ID_COLDFRONT
	description = "Minty, rich, and painfully cold. It's a blizzard in a cup."
	taste_description = "biting cold"
	color = "#ffe8c4" // rgb(255, 232, 196)
	strength = 30
	adj_temp = -20
	targ_temp = 220 //Dangerous to certain races. Drink in moderation.

	glass_name = REAGENT_COLDFRONT
	glass_desc = "Minty, rich, and painfully cold. It's a blizzard in a cup."

	allergen_type = ALLERGEN_COFFEE|ALLERGEN_STIMULANT //Made from iced coffee(coffee)

/datum/reagent/ethanol/mintjulep
	name = REAGENT_MINTJULEP
	id = REAGENT_ID_MINTJULEP
	description = "Minty and refreshing, perfect for a hot day."
	taste_description = "refreshing mint"
	color = "#bbfc8a" // rgb(187, 252, 138)
	strength = 25
	adj_temp = -5

	glass_name = REAGENT_MINTJULEP
	glass_desc = "Minty and refreshing, perfect for a hot day."

/datum/reagent/ethanol/godsake
	name = REAGENT_GODSAKE
	id = REAGENT_ID_GODSAKE
	description = "Anime's favorite drink."
	taste_description = "the power of god and anime"
	color = "#DDDDDD"
	strength = 25

	glass_name = "God's Sake"
	glass_desc = "A glass of sake."

/datum/reagent/ethanol/godka
	name = REAGENT_GODKA
	id = REAGENT_ID_GODKA
	description = "Number one drink AND fueling choice for Russians multiverse-wide."
	taste_description = "russian steel and a hint of grain"
	color = "#0064C8"
	strength = 50

	glass_name = REAGENT_GODKA
	glass_desc = "The glass is barely able to contain the wodka. Xynta."
	glass_special = list(DRINK_FIZZ)

	allergen_type = ALLERGEN_GRAINS //Made from vodka(grain)

/datum/reagent/ethanol/godka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(!(M.isSynthetic()))
		M.apply_effect(max(M.radiation - 5 * removed, 0), IRRADIATE, check_protection = 0)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.species.has_organ[O_LIVER])
				var/obj/item/organ/L = H.internal_organs_by_name[O_LIVER]
				if(!L)
					return
				var/adjust_liver = rand(-3, 2)
				if(prob(L.damage))
					to_chat(M, span_cult("You feel woozy..."))
				L.damage = max(L.damage + (adjust_liver * removed), 0)
		var/adjust_tox = rand(-4, 2)
		M.adjustToxLoss(adjust_tox * removed)

/datum/reagent/ethanol/holywine
	name = REAGENT_HOLYWINE
	id = REAGENT_ID_HOLYWINE
	description = "A premium alcoholic beverage made from distilled angel blood."
	taste_description = "wings in a glass, and a hint of grape"
	color = "#C4921E"
	strength = 20

	glass_name = REAGENT_HOLYWINE
	glass_desc = "A very pious looking drink."
	glass_icon = DRINK_ICON_NOISY

	allergen_type = ALLERGEN_FRUIT //Made from grapes(fruit)

/datum/reagent/ethanol/holy_mary
	name = REAGENT_HOLYMARY
	id = REAGENT_ID_HOLYMARY
	description = "A strange yet pleasurable mixture made of vodka, angel's ichor and lime juice. Or at least you THINK the yellow stuff is angel's ichor."
	taste_description = "grapes with a hint of lime"
	color = "#DCAE12"
	strength = 20

	glass_name = REAGENT_HOLYMARY
	glass_desc = "Angel's Ichor, mixed with Vodka and a lil' bit of lime. Tastes like liquid ascension."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from vodka(grain), holy wine(fruit), and lime juice(fruit)

/datum/reagent/ethanol/angelswrath
	name = REAGENT_ANGELSWRATH
	id = REAGENT_ID_ANGELSWRATH
	description = "This thing makes the hair on the back of your neck stand up."
	taste_description = "sweet victory and sour iron"
	taste_mult = 1.5
	color = "#F3C906"
	strength = 30

	glass_name = "Angels' Wrath"
	glass_desc = "Just looking at this thing makes you sweat."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list(DRINK_FIZZ)

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_STIMULANT //Made from space mountain wind(fruit), dr.gibb(caffine) and holy wine(fruit)

/datum/reagent/ethanol/angelskiss
	name = REAGENT_ANGELSKISS
	id = REAGENT_ID_ANGELSKISS
	description = "Miracle time!"
	taste_description = "sweet forgiveness and bitter iron"
	color = "#AD772B"
	strength = 25

	glass_name = "Angel's Kiss"
	glass_desc = "Miracle time!"

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_COFFEE|ALLERGEN_STIMULANT //Made from holy wine(fruit), and kahlua(coffee)

/datum/reagent/ethanol/ichor_mead
	name = REAGENT_ICHORMEAD
	id = REAGENT_ID_ICHORMEAD
	description = "A trip to Valhalla."
	taste_description = "valhalla"
	color = "#955B37"
	strength = 30

	glass_name = REAGENT_ICHORMEAD
	glass_desc = "A trip to Valhalla."

	allergen_type = ALLERGEN_FRUIT //Made from holy wine(fruit)

/datum/reagent/ethanol/schnapps_pep
	name = REAGENT_SCHNAPPSPEP
	id = REAGENT_ID_SCHNAPPSPEP
	description = "Achtung, pfefferminze."
	taste_description = "minty alcohol"
	color = "#8FC468"
	strength = 25

	glass_name = "peppermint schnapps"
	glass_desc = "A glass of peppermint schnapps. It seems like it'd be better, mixed."

/datum/reagent/ethanol/schnapps_pea
	name = REAGENT_SCHNAPPSPEA
	id = REAGENT_ID_SCHNAPPSPEA
	description = "Achtung, fruchtig."
	taste_description = "peaches"
	color = "#d67d4d"
	strength = 25

	glass_name = "peach schnapps"
	glass_desc = "A glass of peach schnapps. It seems like it'd be better, mixed."

	allergen_type = ALLERGEN_FRUIT //Made from peach(fruit)

/datum/reagent/ethanol/schnapps_lem
	name = REAGENT_SCHNAPPSLEM
	id = REAGENT_ID_SCHNAPPSLEM
	description = "Childhood memories are not included."
	taste_description = "sweet, lemon-y alcohol"
	color = "#FFFF00"
	strength = 25

	glass_name = "lemonade schnapps"
	glass_desc = "A glass of lemonade schnapps. It seems like it'd be better, mixed."

	allergen_type = ALLERGEN_FRUIT //Made from lemons(fruit)

/datum/reagent/ethanol/jager
	name = REAGENT_JAGER
	id = REAGENT_ID_JAGER
	description = "A complex alcohol that leaves you feeling all warm inside."
	taste_description = "complex, rich alcohol"
	color = "#7f6906"
	strength = 25

	glass_name = "schusskonig"
	glass_desc = "A glass of schusskonig digestif. Good for shooting or mixing."

/datum/reagent/ethanol/fusionnaire
	name = REAGENT_FUSIONNAIRE
	id = REAGENT_ID_FUSIONNAIRE
	description = "A drink for the brave."
	taste_description = "a painfully alcoholic lemon soda with an undertone of mint"
	color = "#6BB486"
	strength = 9

	glass_name = REAGENT_ID_FUSIONNAIRE
	glass_desc = "A relatively new cocktail, mostly served in the bars of NanoTrasen owned stations."

	allergen_type = ALLERGEN_FRUIT|ALLERGEN_GRAINS //Made from lemon juice(fruit), vodka(grains), and lemon schnapps(fruit)

/datum/reagent/ethanol/deathbell
	name = REAGENT_DEATHBELL
	id = REAGENT_ID_DEATHBELL
	description = "A successful experiment to make the most alcoholic thing possible."
	taste_description = "your brains smashed out by a smooth brick of hard, ice cold alcohol"
	color = "#9f6aff"
	taste_mult = 5
	strength = 10
	adj_temp = 10
	targ_temp = 330

	glass_name = REAGENT_DEATHBELL
	glass_desc = "The perfect blend of the most alcoholic things a bartender can get their hands on."

	allergen_type = ALLERGEN_GRAINS|ALLERGEN_DAIRY|ALLERGEN_FRUIT //Made from antifreeze(vodka(grains),cream(dairy)), gargleblaster(vodka(grains),gin(fruit),whiskey(grains),cognac(fruit),lime juice(fruit)), and syndicate bomb(beer(grain),whiskeycola(whiskey(grain)))

/datum/reagent/ethanol/deathbell/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		if(dose * strength >= strength) // Early warning
			M.make_dizzy(24) // Intentionally higher than normal to compensate for it's previous effects.
		if(dose * strength >= strength * 2.5) // Slurring takes longer. Again, intentional.
			M.slurring = max(M.slurring, 30)

/datum/reagent/nutriment/magicdust
	name = REAGENT_MAGICDUST
	id = REAGENT_ID_MAGICDUST
	description = "A dust harvested from gnomes, aptly named by pre-industrial civilizations."
	taste_description = "something tingly"
	taste_mult = 2
	reagent_state = LIQUID
	nutriment_factor = 40 //very filling
	color = "#d169b2"

/datum/reagent/nutriment/magicdust/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	playsound(M, 'sound/items/hooh.ogg', 50, 1, -1)
	if(prob(5))
		to_chat(M, span_warning("You feel like you've been gnomed..."))

/datum/reagent/drink/soda/kompot
	name = REAGENT_KOMPOT
	id = REAGENT_ID_KOMPOT
	description = "A traditional Eastern European beverage once used to preserve fruit in the 1980s"
	taste_description = "refreshingly sweet and fruity"
	color = "#ed9415" // rgb: 237, 148, 21
	adj_drowsy = -1
	adj_temp = -6
	glass_name = REAGENT_ID_KOMPOT
	glass_desc = "A glass of refreshing kompot."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/ethanol/kvass
	name = REAGENT_KVASS
	id = REAGENT_ID_KVASS
	description = "A traditional fermented Slavic and Baltic beverage commonly made from rye bread."
	taste_description = "a warm summer day at babushka's cabin"
	color = "#b78315" // rgb: 183, 131, 21
	strength = 95 //It's just soda to Russians
	nutriment_factor = 2
	glass_name = REAGENT_ID_KVASS
	glass_desc = "A hearty glass of Slavic brew."

/datum/reagent/cinnamonpowder
	name = REAGENT_CINNAMONPOWDER
	id = REAGENT_ID_CINNAMONPOWDER
	description = "Cinnamon, a spice made from tree bark, ground into a fine powder. Probably not a good idea to eat on its own!"
	taste_description= "sweet spice with a hint of wood"
	color = "#a96622"

	glass_name = REAGENT_ID_CINNAMONPOWDER
	glass_desc = "A glass of ground cinnamon. Dare you take the challenge?"

/datum/reagent/gelatin
	name = REAGENT_GELATIN
	id = REAGENT_ID_GELATIN
	description = "It doesnt taste like anything."
	taste_description = REAGENT_ID_NOTHING
	color = "#aaabcf"

	glass_name = REAGENT_GELATIN
	glass_desc = "It's like flavourless slime."
