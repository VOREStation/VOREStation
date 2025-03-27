/datum/recipe/fries
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/fries

/datum/recipe/cheesyfries
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/cheesyfries

/datum/recipe/jpoppers
	appliance = FRYER
	fruit = list(PLANT_CHILI = 1)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/jalapeno_poppers
	result_quantity = 2

/datum/recipe/risottoballs
	appliance = FRYER
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(/obj/item/reagent_containers/food/snacks/risotto)
	coating = /datum/reagent/nutriment/coating/batter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/risottoballs
	result_quantity = 2

/datum/recipe/bellefritter
	appliance = FRYER
	coating = /datum/reagent/nutriment/coating/batter
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(/obj/item/reagent_containers/food/snacks/frostbelle)
	result = /obj/item/reagent_containers/food/snacks/bellefritter
	result_quantity = 2

/datum/recipe/onionrings
	appliance = FRYER
	coating = /datum/reagent/nutriment/coating/batter
	fruit = list(PLANT_ONION = 1)
	result = /obj/item/reagent_containers/food/snacks/onionrings
	result_quantity = 2

//Meaty Recipes
//====================
/datum/recipe/cubancarp
	appliance = FRYER
	fruit = list(PLANT_CHILI = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/cubancarp

/datum/recipe/batteredsausage
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/sausage/battered
	coating = /datum/reagent/nutriment/coating/batter


/datum/recipe/katsu
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	result = /obj/item/reagent_containers/food/snacks/chickenkatsu
	coating = /datum/reagent/nutriment/coating/beerbatter


/datum/recipe/pizzacrunch_1
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	coating = /datum/reagent/nutriment/coating/batter

//Alternate pizza crunch recipe for combination pizzas made in oven
/datum/recipe/pizzacrunch_2
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/variable/pizza
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	coating = /datum/reagent/nutriment/coating/batter
	wiki_flag = WIKI_SPOILER

/datum/recipe/friedmushroom
	appliance = FRYER
	fruit = list(PLANT_PLUMPHELMET = 1)
	coating = /datum/reagent/nutriment/coating/beerbatter
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedmushroom

/datum/recipe/fishfingers
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat,
	)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/fishfingers
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/corn_dog
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage
	)
	fruit = list(PLANT_CORN = 1)
	coating = /datum/reagent/nutriment/coating/batter
	result = /obj/item/reagent_containers/food/snacks/corn_dog

/datum/recipe/sweet_and_sour
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagents = list(REAGENT_ID_SOYSAUCE = 5, REAGENT_ID_BATTER = 10)
	result = /obj/item/reagent_containers/food/snacks/sweet_and_sour

//Sweet Recipes.
//==================
// All donuts were given reagents of 5 to equal old recipes and make for faster cook times.
/datum/recipe/jellydonut
	appliance = FRYER
	reagents = list(REAGENT_ID_BERRYJUICE = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/plain/jelly
	result_quantity = 2

/datum/recipe/jellydonut/poisonberry
	reagents = list(REAGENT_ID_POISONBERRYJUICE = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/donut/plain/jelly/poisonberry
	wiki_flag = WIKI_SPOILER

/datum/recipe/jellydonut/slime // Subtypes of jellydonut, appliance inheritance applies.
	reagents = list(REAGENT_ID_SLIMEJELLY = 5, REAGENT_ID_SUGAR = 5)
	result = /obj/item/reagent_containers/food/snacks/donut/plain/jelly/slimejelly

/datum/recipe/jellydonut/cherry // Subtypes of jellydonut, appliance inheritance applies.
	reagents = list(REAGENT_ID_CHERRYJELLY = 5, REAGENT_ID_SUGAR = 5)
	result = /obj/item/reagent_containers/food/snacks/donut/plain/jelly/cherryjelly

/datum/recipe/donut
	appliance = FRYER
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/plain
	result_quantity = 2

/datum/recipe/chaosdonut
	appliance = FRYER
	reagents = list(REAGENT_ID_FROSTOIL = 10, REAGENT_ID_CAPSAICIN = 10, REAGENT_ID_SUGAR = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //This creates its own reagents
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donut/chaos
	result_quantity = 2
	wiki_flag = WIKI_SPOILER

/datum/recipe/funnelcake
	appliance = FRYER
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_BATTER = 10)
	result = /obj/item/reagent_containers/food/snacks/funnelcake
	result_quantity = 2

/datum/recipe/pisanggoreng
	appliance = FRYER
	fruit = list(PLANT_BANANA = 2)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/pisanggoreng
	coating = /datum/reagent/nutriment/coating/batter

//VOREStation Add Start
/datum/recipe/generalschicken
	appliance = FRYER
	reagents = list(REAGENT_ID_CAPSAICIN = 2, REAGENT_ID_SUGAR = 2, REAGENT_ID_BATTER = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/generalschicken

/datum/recipe/chickenwings
	appliance = FRYER
	reagents = list(REAGENT_ID_CAPSAICIN = 5, REAGENT_ID_BATTER = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/storage/box/wings //This is kinda like the donut box.
//VOREStation Add End
