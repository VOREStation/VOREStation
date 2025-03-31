/datum/reagent/nutriment
	nutriment_factor = 10

/datum/reagent/toxin/meatcolony
	name = REAGENT_MEATCOLONY
	id = REAGENT_ID_MEATCOLONY
	description = "Specialised cells designed to produce a large amount of meat once activated, whilst manufacturers have managed to stop these cells from taking over the body when ingested, it's still poisonous."
	taste_description = "a fibrous mess"
	reagent_state = LIQUID
	color = "#ff2424"
	strength = 10

/datum/reagent/toxin/plantcolony
	name = REAGENT_PLANTCOLONY
	id = REAGENT_ID_PLANTCOLONY
	description = "Specialised cells designed to produce a large amount of nutriment once activated, whilst manufacturers have managed to stop these cells from taking over the body when ingested, it's still poisonous."
	taste_description = "a fibrous mess"
	reagent_state = LIQUID
	color = "#7ce01f"
	strength = 10

/datum/reagent/nutriment/grubshake
	name = REAGENT_GRUBSHAKE
	id = REAGENT_ID_GRUBSHAKE
	description = "An odd fluid made from grub guts, supposedly filling."
	taste_description = "sparkles"
	taste_mult = 1.3
	nutriment_factor = 5
	color = "#fff200"
	wiki_flag = WIKI_DRINK

/datum/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(-20 * removed)

/datum/reagent/ethanol/burnout
	name = REAGENT_BURNOUT
	id = REAGENT_ID_BURNOUT
	description = "A bubbling orange alcoholic fluid that radiates a large amount of heat."
	taste_description = "powerful alcoholic inferno"
	color = "#cc5500"
	taste_mult = 5
	strength = 10
	adj_temp = 10
	targ_temp = 380

	glass_name = REAGENT_BURNOUT
	glass_desc = "A swirling brew of fluids that leaves even the glass itself hot to the touch."

/datum/reagent/ethanol/burnout/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	// Deathbell effects.
	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		if(dose * strength >= strength)
			M.make_dizzy(24)
		if(dose * strength >= strength * 2.5)
			M.slurring = max(M.slurring, 30)
		// Simulating heat effects of spice. Without spice.
		if(alien == IS_DIONA || alien == IS_ALRAUNE)
			return
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.can_feel_pain())
				return
			else
				if((dose < 5) && (dose == metabolism || prob(5)))
					to_chat(M, span_danger("Your insides feel uncomfortably hot!"))
				if(dose >= 5 && prob(5))
					M.visible_message(span_warning("[M] [pick("dry heaves!","coughs!","splutters!")]"), pick(span_danger("You feel like your insides are burning!"), span_danger("You feel like your insides are on fire!"), span_danger("You feel like your belly is full of lava!")))

/datum/reagent/ethanol/monstertamer
	name = REAGENT_MONSTERTAMER
	id = REAGENT_ID_MONSTERTAMER
	description = "A questionably-delicious blend of a carnivore's favorite food and a potent neural depressant."
	taste_description = "the gross yet satisfying combination of chewing on a raw steak while downing a shot of whiskey"
	strength = 50
	color = "#d3785d"
	metabolism = REM * 2.5 // about right for mixing nutriment and ethanol.
	var/alt_nutriment_factor = 5 //half as much as protein since it's half protein.
	//using a new variable instead of nutriment_factor so we can call ..() without that adding nutrition for us without taking factors for protein into account

	glass_name = REAGENT_MONSTERTAMER
	glass_desc = "This looks like a vaguely-alcoholic slurry of meat. Gross."

/datum/reagent/ethanol/monstertamer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(!(M.isSynthetic()))
		if(M.species.organic_food_coeff) //it's still food!
			switch(alien)
				if(IS_DIONA) //Diona don't get any nutrition from nutriment or protein.
					pass()
				if(IS_SKRELL)
					M.adjustToxLoss(0.25 * removed)  //Equivalent to half as much protein, since it's half protein.
				if(IS_TESHARI)
					M.adjust_nutrition(alt_nutriment_factor * 1.2 * removed) //Give them the same nutrition they would get from protein.
				if(IS_UNATHI)
					M.adjust_nutrition(alt_nutriment_factor * 1.125 * removed) //Give them the same nutrition they would get from protein.
					//Takes into account the 0.5 factor for all nutriment which is applied on top of the 2.25 factor for protein.
				//Chimera don't need their own case here since their factors for nutriment and protein cancel out.
				else
					M.adjust_nutrition(alt_nutriment_factor * removed)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.feral > 0 && H.nutrition > 150 && H.traumatic_shock < 20 && H.jitteriness < 100) //Same check as feral triggers to stop them immediately re-feralling
				H.feral -= removed * 3 // should calm them down quick, provided they're actually in a state to STAY calm.
				if (H.feral <=0) //check if they're unferalled
					H.feral = 0
					to_chat(H, span_info("Your mind starts to clear, soothed into a state of clarity as your senses return."))
					log_and_message_admins("is no longer feral.", H)

/datum/reagent/ethanol/monstertamer/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(M.species.organic_food_coeff)
		if(alien == IS_SLIME || alien == IS_CHIMERA) //slimes and chimera can get nutrition from injected nutriment and protein
			M.adjust_nutrition(alt_nutriment_factor * removed)

/datum/reagent/ethanol/pink_russian
	name = REAGENT_PINKRUSSIAN
	id = REAGENT_ID_PINKRUSSIAN
	description = "Like a White Russian but with 100% more pink!"
	taste_description = "strawberry icecream, with a coffee kick"
	color = "#d789bd"
	strength = 15

	glass_name = REAGENT_PINKRUSSIAN
	glass_desc = "A very pink drink, yet with strong sense of power to it."

/datum/reagent/ethanol/originalsin
	name = REAGENT_ORIGINALSIN
	id = REAGENT_ID_ORIGINALSIN
	description = "Angel Ichor, entirely transformed by one drop of apple juice"
	taste_description = "the apple Eve gave to Adam"
	color = "#99CC35"
	strength = 17

	glass_name = REAGENT_ORIGINALSIN
	glass_desc = "A drink so fine, you may just risk eternal damnation!"

/datum/reagent/ethanol/newyorksour
	name = REAGENT_NEWYORKSOUR
	id = REAGENT_ID_NEWYORKSOUR
	description = "Whiskey sour, with a layer of wine and egg white."
	taste_description = "refreshing lemoned whiskey, smoothed with wine"
	color = "#FFBF3C"
	strength = 17

	glass_name = REAGENT_NEWYORKSOUR
	glass_desc = "A carefully poured three layered drink"

/datum/reagent/ethanol/windgarita
	name = REAGENT_WINDGARITA
	id = REAGENT_ID_WINDGARITA
	description = "A highly questionable combination of margarita and Space Mountain Wind"
	taste_description = "like sin, and some tequilia"
	color = "#90D93D"
	strength = 15

	glass_name = REAGENT_WINDGARITA
	glass_desc = "Who the hell comes up with these drinks?!"

/datum/reagent/ethanol/mudslide
	name = REAGENT_MUDSLIDE
	id = REAGENT_ID_MUDSLIDE
	description = "Vodka, Kahlua and Irish Cream together at last."
	taste_description = "a mocha milkshake, with a splash of vodka."
	color = "#8B6338"
	strength = 13

	glass_name = REAGENT_MUDSLIDE
	glass_desc = "A richly coloured drink, comes with a chocolate garnish!"

/datum/reagent/ethanol/galacticpanic
	name = REAGENT_GALACTICPANIC
	id = REAGENT_ID_GALACTICPANIC
	description = "The absolute worst thing you could ever put in your body."
	taste_description = "an entire galaxy collasping in on itself"
	strength = 10
	druggy = 50
	halluci = 30
	var/adj_dizzy = 10
	color = "#d3785d"

	glass_name = REAGENT_GALACTICPANIC
	glass_desc = "Looking into this is like staring at the stars."

/datum/reagent/ethanol/galacticpanic/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.Stun(2)

/datum/reagent/ethanol/galacticpanic/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		if(dose * strength >= strength) // Early warning
			M.make_dizzy(24) // Intentionally higher than normal to compensate for it's previous effects.
		if(dose * strength >= strength * 2.5) // Slurring takes longer. Again, intentional.
			M.slurring = max(M.slurring, 30)

/datum/reagent/ethanol/bulldog
	name = REAGENT_BULLDOG
	id = REAGENT_ID_BULLDOG
	description = "An inventive kahlua recipe."
	taste_description = "fizzy, creamy, soda and coffee hell"
	strength = 30
	color = "#d3785d"

	glass_name = REAGENT_BULLDOG
	glass_desc = "It looks like someone poured cola in a cup of coffee."

/datum/reagent/ethanol/sbagliato
	name = REAGENT_SBAGLIATO
	id = REAGENT_ID_SBAGLIATO
	description = "A drink invented because a bartender was too drunk."
	taste_description = "sweet bubbly wine and vermouth"
	strength = 30
	color = "#d3785d"

	glass_name = REAGENT_SBAGLIATO
	glass_desc = "Bubbles constantly pop up to the surface with a quiet fizz."

/datum/reagent/ethanol/italiancrisis
	name = REAGENT_ITALIANCRISIS
	id = REAGENT_ID_ITALIANCRISIS
	description = "This drink was concocted by a madwoman, causing the Italian Crisis of 2123."
	taste_description = "cola, fruit, fizz, coffee, and cream swirled together in an old boot"
	strength = 20
	druggy = 0
	halluci = 0
	var/adj_dizzy = 0
	color = "#d3785d"

	glass_name = REAGENT_ITALIANCRISIS
	glass_desc = "This drink looks like it was a mistake."

/datum/reagent/ethanol/sugarrush
	name = REAGENT_SUGARRUSH
	id = REAGENT_ID_SUGARRUSH
	description = "A favorite drink amongst poor bartenders living in Neo Detroit."
	taste_description = "sweet bubblegum vodka"
	strength = 30
	color = "#d3785d"

	glass_name = REAGENT_SUGARRUSH
	glass_desc = "This looks like it might rot your teeth out."

/datum/reagent/ethanol/lotus
	name = REAGENT_LOTUS
	id = REAGENT_ID_LOTUS
	description = "The result of making one mistake after another and trying to cover it up with sugar."
	taste_description = "rich, sweet fruit and even more sugar"
	strength = 25
	color = "#d3785d"

	glass_name = REAGENT_LOTUS
	glass_desc = "A promotional drink for a movie that only ever played in Neo Detroit theatres."

/datum/reagent/ethanol/shroomjuice
	name = REAGENT_SHROOMJUICE
	id = REAGENT_ID_SHROOMJUICE
	description = "The mushroom farmer didn't sort through their stock very well."
	taste_description = "sweet and sour citrus with a savory kick"
	strength = 100
	druggy = 30
	halluci = 30
	var/adj_dizzy = 30
	color = "#d3785d"

	glass_name = REAGENT_SHROOMJUICE
	glass_desc = "Touch fuzzy, get dizzy."

/datum/reagent/ethanol/russianroulette
	name = REAGENT_RUSSIANROULETTE
	id = REAGENT_ID_RUSSIANROULETTE
	description = "The perfect drink for wagering your liver on a game of cards."
	taste_description = "coffee, vodka, cream, and a hot metal slug"
	strength = 30
	var/adj_dizzy = 30
	color = "#d3785d"

	glass_name = REAGENT_RUSSIANROULETTE
	glass_desc = "A favorite drink amongst the Pan-Slavic speaking community."

/datum/reagent/ethanol/russianroulette/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(M.species.robo_ethanol_drunk || !(M.isSynthetic()))
		M.Stun(2)

/datum/reagent/ethanol/lovemaker
	name = REAGENT_LOVEMAKER
	id = REAGENT_ID_LOVEMAKER
	description = "A drink said to help one find true love."
	taste_description = "sweet fruit and honey"
	strength = 30
	druggy = 0
	halluci = 0
	var/adj_dizzy = 30
	adj_temp = 10
	targ_temp = 360
	color = "#d3785d"

	glass_name = REAGENT_LOVEMAKER
	glass_desc = "A drink said to help one find the perfect fuck."

/datum/reagent/ethanol/honeyshot
	name = REAGENT_HONEYSHOT
	id = REAGENT_ID_HONEYSHOT
	description = "The perfect drink for bees."
	taste_description = "sweet tart grenadine flavored with honey"
	strength = 40
	var/adj_dizzy = 10
	color = "#d3785d"

	glass_name = REAGENT_HONEYSHOT
	glass_desc = "A glass of golden liquid."

/datum/reagent/ethanol/appletini
	name = REAGENT_APPLETINI
	id = REAGENT_ID_APPLETINIT
	description = "A classic cocktail using every grandma's favorite fruit."
	taste_description = "green sour apple with a hint of alcohol"
	strength = 45
	color = "#d3785d"

	glass_name = REAGENT_APPLETINI
	glass_desc = "The perfect fruit cocktail for a fancy night at the bar."

/datum/reagent/ethanol/glowingappletini
	name = REAGENT_GLOWINGAPPLETINI
	id = REAGENT_ID_GLOWINGAPPLETINI
	description = "A new nuclear take on a pre-modern classic!"
	taste_description = "overwhelmingly sour apples powered by a nuclear fission reactor"
	strength = 30
	druggy = 20
	var/adj_dizzy = 20
	color = "#d3785d"

	glass_name = REAGENT_GLOWINGAPPLETINI
	glass_desc = "The atomic option to fruity cocktails."

/datum/reagent/ethanol/scsatw
	name = REAGENT_SCSATW
	id = REAGENT_ID_SCSATW
	description = "The screwdriver's bigger cousin."
	taste_description = "smooth, savory booze and tangy orange juice"
	strength = 30
	druggy = 0
	halluci = 0
	var/adj_dizzy = 0
	color = "#d3785d"

	glass_name = REAGENT_SCSATW
	glass_desc = "The best accessory to daydrinking."

/datum/reagent/drink
	name = REAGENT_DEVELOPER_WARNING // Unit test ignore

/datum/reagent/drink/choccymilk
	name = REAGENT_CHOCCYMILK
	id = REAGENT_ID_CHOCCYMILK
	description = "Coco and milk, a timeless classic."
	taste_description = "sophisticated bittersweet chocolate mixed with silky, creamy, whole milk"
	color = "#d3785d"

	glass_name = REAGENT_CHOCCYMILK
	glass_desc = "The most iconic duo in the galaxy, chocolate, and milk."

/datum/reagent/ethanol/redspaceflush
	name = REAGENT_REDSPACEFLUSH
	id = REAGENT_ID_REDSPACEFLUSH
	description = "A drink made by imbueing the essence of redspace into the spirits."
	taste_description = "whiskey and rum strung out through a hellish dimensional rift"
	strength = 30
	druggy = 10
	var/adj_dizzy = 10
	color = "#d3785d"

	glass_name = REAGENT_REDSPACEFLUSH
	glass_desc = "A drink imbued with the very essence of Redspace."

/datum/reagent/drink/graveyard
	name = REAGENT_GRAVEYARD
	id = REAGENT_ID_GRAVEYARD
	description = "The result of taking a cup and filling it with all the drinks at the fountain."
	taste_description = "sugar and fizz"
	color = "#d3785d"

	glass_name = REAGENT_GRAVEYARD
	glass_desc = "Hahaha softdrink machine go pshshhhhh..."

/datum/reagent/ethanol/bigbeer
	name = REAGENT_BIGBEER
	id = REAGENT_ID_BIGBEER
	description = "Bars in Neo Detroit started to sell this drink when the city put mandatory drink limits in 2289."
	taste_description = "beer, but bigger"
	strength = 40
	color = "#d3785d"

	glass_name = REAGENT_BIGBEER
	glass_desc = "The Neo Detroit beer and ale cocktail, perfect for your average drunk."

/datum/reagent/ethanol/manager_summoner
	name = REAGENT_MANAGERSUMMONER
	id = REAGENT_ID_MANAGERSUMMONER
	description = "A horrifying cocktail for those who desperately want feel above their peers."
	taste_description = "bitter and sweet, with a hint of superiority"
	strength = 30
	color = "#c9716b"

	glass_name = REAGENT_MANAGERSUMMONER
	glass_desc = "The dreaded red juice of those who insist on taking advantage of minor positions of power to make the lives of bar staff unbearable."

/datum/reagent/drink/sweettea
	name = REAGENT_SWEETTEA
	id = REAGENT_ID_SWEETTEA
	description = "Tea that is sweetened with some form of sweetener."
	taste_description = "tea that is sweet"
	color = "#d3785d"

	glass_name = REAGENT_SWEETTEA
	glass_desc = "A southern classic. Southern what? You know, southern."

/datum/reagent/ethanol/unsweettea
	name = REAGENT_UNSWEETTEA
	id = REAGENT_ID_UNSWEETTEA
	description = "A sick experiment to take the sweetness out of tea after sugar has been added resulted in this."
	taste_description = "bland, slightly bitter, discount black tea"
	strength = 80
	druggy = 10
	color = "#d3785d"

	glass_name = REAGENT_UNSWEETTEA
	glass_desc = "A drink with all the calories of sweet tea, but with none of the satisfaction. Slightly psychoactive."

/datum/reagent/ethanol/hairoftherat
	name = REAGENT_HAIROFTHERAT
	id = REAGENT_ID_HAIROFTHERAT
	description = "A meatier version of the monster tamer, complete with extra meat."
	taste_description = "meat, whiskey, ground meat, and more meat"
	strength = 45
	color = "#d3785d"
	metabolism = REM * 3.5 // about right for mixing nutriment and ethanol.
	var/alt_nutriment_factor = 5 //half as much as protein since it's half protein.
	//using a new variable instead of nutriment_factor so we can call ..() without that adding nutrition for us without taking factors for protein into account

	glass_name = REAGENT_HAIROFTHERAT
	glass_desc = "The alcoholic equivalent of saying your burger isn't cooked rare enough."

/datum/reagent/ethanol/hairoftherat/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(!(M.isSynthetic()))
		if(M.species.organic_food_coeff) //it's still food!
			switch(alien)
				if(IS_DIONA) //Diona don't get any nutrition from nutriment or protein.
					pass()
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
					to_chat(H, span_info("Your mind starts to clear, soothed into a state of clarity as your senses return."))
					log_and_message_admins("is no longer feral.", H)

/datum/reagent/ethanol/hairoftherat/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(M.species.organic_food_coeff)
		if(alien == IS_SLIME || alien == IS_CHIMERA) //slimes and chimera can get nutrition from injected nutriment and protein
			M.nutrition += (alt_nutriment_factor * removed)

//////////////////////Bepis Drinks (04/29/2021)//////////////////////

/datum/reagent/drink/soda/bepis_cola
	name = REAGENT_BEPIS
	id = REAGENT_ID_BEPIS
	description = "A weird cola-like beverage."
	taste_description = "bepsi"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_BEPIS
	glass_desc = "A glass of weird cola beverage."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/buzz_fuzz
	name = REAGENT_BUZZFUZZ
	id = REAGENT_ID_BUZZFUZZ
	description = "A delicious frontier beverage that's simply a Hive of Flavour!"
	taste_description = "carbonated honey and pollen"
	reagent_state = LIQUID
	color = "#8CFF00"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_BUZZFUZZ
	glass_desc = "A glass that's stinging with flavour."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/sprited_cranberry
	name = REAGENT_SPRITEDCRANBERRY
	id = REAGENT_ID_SPRITEDCRANBERRY
	description = "A winter spiced cranberry drink. Perfect for year-round consumption."
	taste_description = "sweet spiced cranberry"
	reagent_state = LIQUID
	color = "#fffafa"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_SPRITEDCRANBERRY
	glass_desc = "A glass of sprited cranberry"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/soda/shamblers
	name = REAGENT_SHAMBLERS
	id = REAGENT_ID_SHAMBLERS
	description = "A strange off-brand beverage that's bursting with flavor."
	taste_description = "carbonated metallic soda"
	reagent_state = LIQUID
	color = "#f00060"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = REAGENT_SHAMBLERS
	glass_desc = "A glass of something shambly"
	glass_special = list(DRINK_FIZZ)

////////////////START BrainzSnax Reagents////////////////

/datum/reagent/nutriment/protein/brainzsnax
	name = REAGENT_BRAINPROTEIN
	id = REAGENT_ID_BRAINPROTEIN
	taste_description = "fatty, mushy meat and allspice"
	color = "#caa3c9"
	wiki_flag = WIKI_FOOD|WIKI_SPOILER

/datum/reagent/nutriment/protein/brainzsnax/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(prob(5) && !(alien == IS_CHIMERA || alien == IS_SLIME || alien == IS_PLANT || alien == IS_DIONA || alien == IS_SHADEKIN && !M.isSynthetic()))
		M.adjustBrainLoss(removed) //Any other species risks prion disease.
		M.Confuse(5)
		M.hallucination = max(M.hallucination, 25)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.feral > 0 && H.nutrition > 150 && H.traumatic_shock < 20 && H.jitteriness < 100) //Same check as feral triggers to stop them immediately re-feralling
			H.feral -= removed * 3 //Should calm them down quick, provided they're actually in a state to STAY calm.
			if(H.feral <=0) //Check if they're unferalled
				H.feral = 0
				to_chat(H, span_info("Your mind starts to clear, soothed into a state of clarity as your senses return."))
				log_and_message_admins("is no longer feral.", H)

/datum/reagent/nutriment/protein/brainzsnax/red
	id = REAGENT_ID_REDBRAINPROTEIN
	taste_description = "fatty, mushy meat and cheap tomato sauce"
	color = "#a6898d"

////////////////END BrainzSnax Reagents////////////////

/datum/reagent/nutriment/protein_powder
	name = REAGENT_PROTEINPOWDER
	id = REAGENT_ID_PROTEINPOWDER
	description = "Pure, powdered protein commonly used as a meal supplement."
	taste_description = "powdery protein"
	color = "#f4e6dd"

/datum/reagent/nutriment/protein_shake
	name = REAGENT_PROTEINSHAKE
	id = REAGENT_ID_PROTEINSHAKE
	description = "A mixture of water and protein commonly used as a meal supplement."
	taste_description = "pure protein"
	color = "#ebd8cb"
	wiki_flag = WIKI_DRINK

/datum/reagent/nutriment/protein_powder/vanilla
	name = REAGENT_VANILLAPROTEINPOWDER
	id = REAGENT_ID_VANILLAPROTEINPOWDER
	description = "Pure, powdered protein commonly used as a meal supplement. This one has added vanilla flavoring."
	taste_description = "powdery vanilla"
	color = "#fff7d2"

/datum/reagent/nutriment/protein_shake/vanilla
	name = REAGENT_VANILLAPROTEINSHAKE
	id = REAGENT_ID_VANILLAPROTEINSHAKER
	description = "A mixture of water and protein commonly used as a meal supplement. This one has added vanilla flavoring."
	taste_description = "vanilla"
	color = "#faefbc"

/datum/reagent/nutriment/protein_powder/banana
	name = REAGENT_BANANAPROTEINPOWDER
	id = REAGENT_ID_BANANAPROTEINPOWDER
	description = "Pure, powdered protein commonly used as a meal supplement. This one has added banana flavoring."
	taste_description = "powdery banana"
	color = "#faefbc"

/datum/reagent/nutriment/protein_shake/banana
	name = REAGENT_BANANAPROTEINSHAKE
	id = REAGENT_ID_BANANAPROTEINSHAKE
	description = "A mixture of water and protein commonly used as a meal supplement. This one has added banana flavoring."
	taste_description = "banana"
	color = "#e6daa1"

/datum/reagent/nutriment/protein_powder/chocolate
	name = REAGENT_CHOCOLATEPROTEINPOWDER
	id = REAGENT_ID_CHOCOLATEPROTEINPOWDER
	description = "Pure, powdered protein commonly used as a meal supplement. This one has added chocolate flavoring."
	taste_description = "powdery chocolate"
	color = "#865b3e"

/datum/reagent/nutriment/protein_shake/chocolate
	name = REAGENT_CHOCOLATEPROTEINSHAKE
	id = REAGENT_ID_CHOCOLATEPROTEINSHAKE
	description = "A mixture of water and protein commonly used as a meal supplement. This one has added chocolate flavoring."
	taste_description = "chocolate"
	color = "#644730"

/datum/reagent/nutriment/protein_powder/strawberry
	name = REAGENT_STRAWBERRYPROTEINPOWDER
	id = REAGENT_ID_STRAWBERRYPROTEINPOWDER
	description = "Pure, powdered protein commonly used as a meal supplement. This one has added strawberry flavoring."
	taste_description = "powdery strawberry"
	color = "#eba1a1"

/datum/reagent/nutriment/protein_shake/strawberry
	name = REAGENT_STRAWBERRYPROTEINSHAKE
	id = REAGENT_ID_STRAWBERRYPROTEINSHAKE
	description = "A mixture of water and protein commonly used as a meal supplement. This one has added strawberry flavoring."
	taste_description = "strawberry"
	color = "#e28585"

//SOUPS. Don't use the base soup reagent.
/datum/reagent/drink/soup
	name = REAGENT_SOUP
	id = REAGENT_ID_SOUP
	description = "An indistinct soupy mass of nominal goodness, but questionable flavour."
	taste_description = "upsettingly bland soup"
	color = "#9a9a9a"
	nutrition = 30	//same as base nutriment

/datum/reagent/drink/soup/tomato
	name = REAGENT_TOMATOSOUP
	id = REAGENT_ID_TOMATOSOUP
	description = "A thick and creamy tomato soup. Delicious! Definitely not ketchup."
	taste_description = "rich, creamy tomato"
	color = "#e4612d"
	allergen_type = ALLERGEN_FRUIT //tomatoes are fruit, etc. etc.

/datum/reagent/drink/soup/mushroom
	name = REAGENT_MUSHROOMSOUP
	id = REAGENT_ID_MUSHROOMSOUP
	description = "A rich, earthy mushroom soup."
	taste_description = "earthy mushrooms"
	color = "#a59a83"
	allergen_type = ALLERGEN_FUNGI //shrooms!

/datum/reagent/drink/soup/chicken
	name = REAGENT_CHICKENSOUP
	id = REAGENT_ID_CHICKENSOUP
	description = "A fairly thick, warming chicken-based soup."
	taste_description = "savoury chicken goodness"
	color = "#d4c574"
	allergen_type = ALLERGEN_MEAT //plain ol' chimken

/datum/reagent/drink/soup/chicken_noodle
	name = REAGENT_CHICKENNOODLESOUP
	id = REAGENT_ID_CHICKENNOODLESOUP
	description = "A thin chicken broth with added noodles. If you're lucky there might be some chunks of chicken and veggies in there! Maybe."
	taste_description = "savoury chicken-noodle goodness"
	color = "#a27a41"
	allergen_type = ALLERGEN_MEAT|ALLERGEN_GRAINS|ALLERGEN_VEGETABLE //chicken + grain-based noodles + veggie chunks

/datum/reagent/drink/soup/onion
	name = REAGENT_ONIONSOUP
	id = REAGENT_ID_ONIONSOUP
	description = "A humble staple of humanity throughout the centuries."
	taste_description = "caramelized onions"
	color = "#5d3918"
	allergen_type = ALLERGEN_VEGETABLE //onions are veg, right?

/datum/reagent/drink/soup/vegetable
	name = REAGENT_VEGETABLESOUP
	id = REAGENT_ID_VEGETABLESOUP
	description = "A mix of various kinds of tasty vegetables, in soup format!"
	taste_description = "mixed vegetables"
	color = "#824005"
	allergen_type = ALLERGEN_VEGETABLE //mixed veg

/datum/reagent/drink/soup/beet
	name = REAGENT_BEETSOUP
	id = REAGENT_ID_BEETSOUP
	description = "A hearty mix of tomatoes and beets, with a meat stock base."
	taste_description = "sour tomatoes and some killer beets"
	color = "#471b1c"
	allergen_type = ALLERGEN_MEAT|ALLERGEN_FRUIT|ALLERGEN_VEGETABLE //meat stock, tomatoes, and beets

/datum/reagent/drink/soup/hot_and_sour
	name = REAGENT_HOTNSOURSOUP
	id = REAGENT_ID_HOTNSOURSOUP
	description = "A spicy tofu-based soup."
	taste_description = "spicy, sour tofu"
	color = "#5f1b06"
	allergen_type = ALLERGEN_BEANS|ALLERGEN_VEGETABLE|ALLERGEN_FUNGI //tofu is soy-based, ergo, beans. base recipe also uses cabbage and mushroom.

/////////Energy Drinks/////////

/datum/reagent/drink/coffee/nukie

	name = REAGENT_NUKIE
	id = REAGENT_ID_NUKIE
	description = "An extremely concentrated caffinated drink."
	color = "#102838"
	adj_temp = 0
	adj_dizzy = 0
	adj_drowsy = -5
	adj_sleepy = -10

	glass_name = REAGENT_ID_NUKIE
	glass_desc = "A drink to perk you up and refresh you!"
	overdose = REAGENTS_OVERDOSE

	taste_description = "flavourless energy"

/datum/reagent/drink/coffee/nukie/peach
	name = REAGENT_NUKIEPEACH
	id = REAGENT_ID_NUKIEPEACH
	color = "#ffc76e"
	taste_description = "battery acid with a hint of artificial peach"

/datum/reagent/drink/coffee/nukie/pear
	name = REAGENT_NUKIEPEAR
	id = REAGENT_ID_NUKIEPEAR
	color = "#d4c03d"
	taste_description = "electrostimulation with a hint of artificial pear"

/datum/reagent/drink/coffee/nukie/cherry
	name = REAGENT_NUKIECHERRY
	id = REAGENT_ID_NUKIECHERRY
	color = "#b00707"
	taste_description = "the rapid acceleration of tooth decay with a hint of artificial cherry"

/datum/reagent/drink/coffee/nukie/melon
	name = REAGENT_NUKIEMELON
	id = REAGENT_ID_NUKIEMELON
	color = "#00bf06"
	taste_description = "something is crawling under your skin with a hint of artificial melon"

/datum/reagent/drink/coffee/nukie/banana
	name = REAGENT_NUKIEBANANA
	id = REAGENT_ID_NUKIEBANANA
	color = "#ffee00"
	taste_description = "imminent cardiac arrest with a hint of something that doesn't really taste like banana at all but is clearly intending to be banana"

/datum/reagent/drink/coffee/nukie/rose
	name = REAGENT_NUKIEROSE
	id = REAGENT_ID_NUKIEROSE
	color = "#ff7df4"
	taste_description = "paint stripper, space cleaner and some sort of cheap perfume"

/datum/reagent/drink/coffee/nukie/lemon
	name = REAGENT_NUKIELEMON
	id = REAGENT_ID_NUKIELEMON
	color = "#c3ff00"
	taste_description = "something that once resembled lemon mixed thoroughly with literal toxic waste"

/datum/reagent/drink/coffee/nukie/fruit
	name = REAGENT_NUKIEFRUIT
	id = REAGENT_ID_NUKIEFRUIT
	color = "#b300ff"
	taste_description = "the colour purple"

/datum/reagent/drink/coffee/nukie/special
	name = REAGENT_NUKIESPECIAL
	id = REAGENT_ID_NUKIESPECIAL
	color = "#ffffff"
	taste_description = "sitting in your college dorm one week before your exams start, staring at a screen without anything particularly interesting on, knowing that you should really be studying, but you can put it off for another day right? Plus your friends are gonna be getting on soon and there's an event starting that you need to prep for"

/datum/reagent/drink/coffee/nukie/mega

	name = REAGENT_NUKIEMEGA
	id = REAGENT_ID_NUKIEMEGA
	description = "An extremely dangerously concentrated caffinated drink."
	color = "#102838"
	adj_temp = 0
	adj_dizzy = 0
	adj_drowsy = -5
	adj_sleepy = -10

	glass_name = REAGENT_ID_NUKIE
	glass_desc = "A drink that might just explode your heart!"
	overdose = 5

	taste_description = "flavourless energy"

/datum/reagent/drink/coffee/nukie/mega/sight
	name = REAGENT_NUKIEMEGASIGHT
	id = REAGENT_ID_NUKIEMEGASIGHT
	color = "#f4fc03"
	taste_description = "seeing beyond the margins of this world"

/datum/reagent/drink/coffee/nukie/mega/sight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(prob(1))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
			if(istype(E))
				if(E.robotic >= ORGAN_ROBOT)
					return
				if(E.damage < 100)
					E.damage = max(E.damage + 1 * removed, 0)
	M.add_chemical_effect(CE_DARKSIGHT, 1)

/datum/reagent/drink/coffee/nukie/mega/heart //Heals you pretty damn well but damages your heart
	name = REAGENT_NUKIEMEGAHEART
	id = REAGENT_ID_NUKIEMEGAHEART
	color = "#fc03e7"
	taste_description = "the end is rapidly approaching, yet remains forever far"

/datum/reagent/drink/coffee/nukie/mega/heart/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1 * M.species.chem_strength_heal
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(6 * removed * chem_effective, 6 * removed * chem_effective) //VOREStation Edit
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if(I.robotic >= ORGAN_ROBOT || !(I.organ_tag in list(O_HEART)))
				continue
			if(I.damage < 100 && prob(10))
				I.damage = max(I.damage + 0.2 * removed, 0)
	..()

/datum/reagent/drink/coffee/nukie/mega/nega //Makes you both jittery and sleepy
	name = REAGENT_NUKIEMEGASLEEP
	id = REAGENT_ID_NUKIEMEGASLEEP
	color = "#00dded"
	taste_description = "the void encompassing you"
	adj_drowsy = 0
	adj_sleepy = 0
	var/adj_tiredness = 5

/datum/reagent/drink/coffee/nukie/mega/nega/affect_ingest(var/mob/living/carbon/human/M)
	if(M.tiredness < 105)
		M.tiredness = (M.tiredness + adj_tiredness)
	..()

/datum/reagent/drink/coffee/nukie/mega/shock //Rapidly fills you up and even repairs your NIF, unless you don't have one in which case you'll be confused.
	name = REAGENT_NUKIEMEGASHOCK
	id = REAGENT_ID_NUKIEMEGASHOCK
	color = "#ede500"
	taste_description = "a thousand volts running down your spine"

/datum/reagent/drink/coffee/nukie/mega/shock/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.nif)
			var/obj/item/nif/nif = H.nif //L o c a l
			if(nif.stat == NIF_TEMPFAIL)
				nif.stat = NIF_INSTALLING
			nif.repair(removed)
		else if(prob(5))
			M.confused = max(M.confused, 20)
			M.emote(pick("shudders", "seems lost", "blanks for a moment"))
	M.adjust_nutrition(4 * removed)


/datum/reagent/drink/coffee/nukie/mega/fast //Like hyperzine, but instead of overdosing, it occassionally burns you
	name = REAGENT_NUKIEMEGAFAST
	id = REAGENT_ID_NUKIEMEGAFAST
	color = "#000000"
	taste_description = "more, more, now, quick, get yourself some more, don't stop"

/datum/reagent/drink/coffee/nukie/mega/fast/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(prob(1))
		M.visible_message(span_danger("\The [M] sizzles!"))
		M.adjustFireLoss(5)
	M.add_chemical_effect(CE_SPEEDBOOST, 1)

/datum/reagent/drink/coffee/nukie/mega/high //Simultaneously makes you high and hungry
	name = REAGENT_NUKIEMEGAHIGH
	id = REAGENT_ID_NUKIEMEGAHIGH
	color = "#fafafa"
	taste_description = "moreishness, you could really go for a proper snack right now"

/datum/reagent/drink/coffee/nukie/mega/high/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	var/threshold = 1
	if(M.species.chem_strength_tox > 0) //Closer to 0 means they're more resistant to toxins. Higher than 1 means they're weaker to toxins.
		threshold /= M.species.chem_strength_tox

	if(alien == IS_SLIME)
		threshold *= 0.15 //~1/6

	M.druggy = max(M.druggy, 30)
	M.adjust_nutrition(-10 * removed)

	var/drug_strength = 20
	var/effective_dose = dose
	if(issmall(M)) effective_dose *= 2
	if(effective_dose < 1 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_dizzy(5)
		if(prob(3))
			M.emote(pick("twitch", "giggle"))
	else if(effective_dose < 2 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_jittery(5)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		M.hallucination = max(M.hallucination, drug_strength * threshold)
		if(prob(5))
			M.emote(pick("twitch", "giggle"))
	else
		M.apply_effect(3, STUTTER)
		M.make_jittery(10)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		M.hallucination = max(M.hallucination, drug_strength * threshold)
		if(prob(10))
			M.emote(pick("twitch", "giggle"))

/datum/reagent/drink/coffee/nukie/mega/shrink //Basically microcillin but for ingesting
	name = REAGENT_NUKIEMEGASHRINK
	id = REAGENT_ID_NUKIEMEGASHRINK
	color = "#15ff00"
	taste_description = "a plastic bag floating gently on the breeze"

/datum/reagent/drink/coffee/nukie/mega/shrink/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	var/new_size = clamp((M.size_multiplier - 0.01), RESIZE_MINIMUM_DORMS, RESIZE_MAXIMUM_DORMS)
	M.resize(new_size, uncapped = M.has_large_resize_bounds(), aura_animation = FALSE)

/datum/reagent/drink/coffee/nukie/mega/grow //Basically macrocillin but for ingesting
	name = REAGENT_NUKIEMEGAGROWTH
	id = REAGENT_ID_NUKIEMEGAGROWTH
	color = "#90ed87"
	taste_description = "absurd hugeness"

/datum/reagent/drink/coffee/nukie/mega/grow/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	var/new_size = clamp((M.size_multiplier + 0.01), RESIZE_MINIMUM_DORMS, RESIZE_MAXIMUM_DORMS)
	M.resize(new_size, uncapped = M.has_large_resize_bounds(), aura_animation = FALSE)
