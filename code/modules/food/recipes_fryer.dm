/datum/recipe/fries
	appliance = FRYER
	items = list(
		/obj/item/food/rawsticks
	)
	result = /obj/item/food/fries

/datum/recipe/cheesyfries
	appliance = FRYER
	items = list(
		/obj/item/food/fries,
		/obj/item/food/cheesewedge,
	)
	result = /obj/item/food/cheesyfries

/datum/recipe/jpoppers
	appliance = FRYER
	fruit = list(PLANT_CHILI = 1)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/food/jalapeno_poppers
	result_quantity = 2

/datum/recipe/risottoballs
	appliance = FRYER
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(/obj/item/food/risotto)
	coating = /datum/reagent/nutriment/coating/batter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/risottoballs
	result_quantity = 2

/datum/recipe/bellefritter
	appliance = FRYER
	coating = /datum/reagent/nutriment/coating/batter
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(/obj/item/food/frostbelle)
	result = /obj/item/food/bellefritter
	result_quantity = 2

/datum/recipe/onionrings
	appliance = FRYER
	coating = /datum/reagent/nutriment/coating/batter
	fruit = list(PLANT_ONION = 1)
	result = /obj/item/food/onionrings
	result_quantity = 2

//Meaty Recipes
//====================
/datum/recipe/cubancarp
	appliance = FRYER
	fruit = list(PLANT_CHILI = 1)
	items = list(
		/obj/item/food/dough,
		/obj/item/food/carpmeat
	)
	result = /obj/item/food/cubancarp

/datum/recipe/batteredsausage
	appliance = FRYER
	items = list(
		/obj/item/food/sausage
	)
	result = /obj/item/food/sausage/battered
	coating = /datum/reagent/nutriment/coating/batter


/datum/recipe/katsu
	appliance = FRYER
	items = list(
		/obj/item/food/meat/chicken
	)
	result = /obj/item/food/chickenkatsu
	coating = /datum/reagent/nutriment/coating/beerbatter


/datum/recipe/pizzacrunch_1
	appliance = FRYER
	items = list(
		/obj/item/food/sliceable/pizza
	)
	result = /obj/item/food/sliceable/pizza/crunch
	coating = /datum/reagent/nutriment/coating/batter

//Alternate pizza crunch recipe for combination pizzas made in oven
/datum/recipe/pizzacrunch_2
	appliance = FRYER
	items = list(
		/obj/item/food/variable/pizza
	)
	result = /obj/item/food/sliceable/pizza/crunch
	coating = /datum/reagent/nutriment/coating/batter
	wiki_flag = WIKI_SPOILER

/datum/recipe/friedmushroom
	appliance = FRYER
	fruit = list(PLANT_PLUMPHELMET = 1)
	coating = /datum/reagent/nutriment/coating/beerbatter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/friedmushroom

/datum/recipe/fishfingers
	items = list(
		/obj/item/food/carpmeat,
	)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/food/fishfingers
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/corn_dog
	appliance = FRYER
	items = list(
		/obj/item/food/sausage
	)
	fruit = list(PLANT_CORN = 1)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/food/corn_dog

/datum/recipe/sweet_and_sour
	appliance = FRYER
	items = list(
		/obj/item/food/bacon,
		/obj/item/food/cutlet
	)
	reagents = list(REAGENT_ID_SOYSAUCE = 5, REAGENT_ID_BATTER = 10)
	result = /obj/item/food/sweet_and_sour

//Sweet Recipes.
//==================
// All donuts were given reagents of 5 to equal old recipes and make for faster cook times.
/datum/recipe/jellydonut
	appliance = FRYER
	reagents = list(REAGENT_ID_BERRYJUICE = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/doughslice
	)
	result = /obj/item/food/donut/plain/jelly
	result_quantity = 2

/datum/recipe/jellydonut/poisonberry
	reagents = list(REAGENT_ID_POISONBERRYJUICE = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/dough
	)
	result = /obj/item/food/donut/plain/jelly/poisonberry
	wiki_flag = WIKI_SPOILER

/datum/recipe/jellydonut/slime // Subtypes of jellydonut, appliance inheritance applies.
	reagents = list(REAGENT_ID_SLIMEJELLY = 5, REAGENT_ID_SUGAR = 5)
	result = /obj/item/food/donut/plain/jelly/slimejelly

/datum/recipe/jellydonut/cherry // Subtypes of jellydonut, appliance inheritance applies.
	reagents = list(REAGENT_ID_CHERRYJELLY = 5, REAGENT_ID_SUGAR = 5)
	result = /obj/item/food/donut/plain/jelly/cherryjelly

/datum/recipe/donut
	appliance = FRYER
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/doughslice
	)
	result = /obj/item/food/donut/plain
	result_quantity = 2

/datum/recipe/chaosdonut
	appliance = FRYER
	reagents = list(REAGENT_ID_FROSTOIL = 10, REAGENT_ID_CAPSAICIN = 10, REAGENT_ID_SUGAR = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //This creates its own reagents
	items = list(
		/obj/item/food/doughslice
	)
	result = /obj/item/food/donut/chaos
	result_quantity = 2
	wiki_flag = WIKI_SPOILER

/datum/recipe/funnelcake
	appliance = FRYER
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_BATTER = 10)
	result = /obj/item/food/funnelcake
	result_quantity = 2

/datum/recipe/pisanggoreng
	appliance = FRYER
	fruit = list(PLANT_BANANA = 2)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/pisanggoreng
	coating = /datum/reagent/nutriment/coating/batter

//VOREStation Add Start
/datum/recipe/generalschicken
	appliance = FRYER
	reagents = list(REAGENT_ID_CAPSAICIN = 2, REAGENT_ID_SUGAR = 2, REAGENT_ID_BATTER = 10)
	items = list(
		/obj/item/food/meat,
		/obj/item/food/meat
	)
	result = /obj/item/food/generalschicken

/datum/recipe/chickenwings
	appliance = FRYER
	reagents = list(REAGENT_ID_CAPSAICIN = 5, REAGENT_ID_BATTER = 10)
	items = list(
		/obj/item/food/meat,
		/obj/item/food/meat,
		/obj/item/food/meat,
		/obj/item/food/meat
	)
	result = /obj/item/storage/box/wings //This is kinda like the donut box.
//VOREStation Add End

/datum/recipe/churro
	appliance = FRYER
	items = list(
		/obj/item/food/doughslice
		)
	result = /obj/item/food/churro
