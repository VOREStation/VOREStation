/datum/recipe/ovenfries
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/ovenfries

//Roasts
//---------------

/datum/recipe/dionaroast
	appliance = OVEN
	fruit = list(PLANT_APPLE = 1)
	reagents = list(REAGENT_ID_PACID = 5) //It dissolves the carapace. Still poisonous, though.
	items = list(/obj/item/holder/diona)
	result = /obj/item/reagent_containers/food/snacks/dionaroast
	reagent_mix = RECIPE_REAGENT_REPLACE //No eating polyacid

/datum/recipe/monkeysdelight
	appliance = OVEN
	fruit = list(PLANT_BANANA = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1, REAGENT_ID_FLOUR = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeycube
	)
	result = /obj/item/reagent_containers/food/snacks/monkeysdelight
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/ribplate
	appliance = OVEN
	reagents = list(REAGENT_ID_HONEY = 5, REAGENT_ID_SPACESPICE = 2, REAGENT_ID_BLACKPEPPER = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/ribplate

/* OLD RECIPE
/datum/recipe/turkey
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/stuffing
		)
	result = /obj/item/reagent_containers/food/snacks/sliceable/turkey
*/

/datum/recipe/turkey
	appliance = OVEN
	fruit = list(PLANT_POTATO = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawturkey,
		/obj/item/reagent_containers/food/snacks/stuffing
		)
	result = /obj/item/reagent_containers/food/snacks/sliceable/turkey

/datum/recipe/tofurkey
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing
	)
	result = /obj/item/reagent_containers/food/snacks/tofurkey

/datum/recipe/zestfish
	appliance = OVEN
	fruit = list(PLANT_LEMON = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/zestfish

/datum/recipe/limezestfish
	appliance = OVEN
	fruit = list(PLANT_LIME = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/zestfish


//Predesigned breads
//================================
/datum/recipe/bread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_YEAST = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bread

/datum/recipe/baguette
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1,  REAGENT_ID_YEAST = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/baguette


/datum/recipe/tofubread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/tofubread


/datum/recipe/creamcheesebread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread

/datum/recipe/flatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/flatbread

/datum/recipe/tortilla
	appliance = OVEN
	reagents = list(REAGENT_ID_FLOUR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/tortilla
	result_quantity = 3

/datum/recipe/meatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/datum/recipe/syntibread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/datum/recipe/xenomeatbread
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/xenomeat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread

/datum/recipe/bananabread
	appliance = OVEN
	fruit = list(PLANT_BANANA = 1)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 15)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bananabread


/datum/recipe/bun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/bun
	result_quantity = 3

//Predesigned pies
//=======================

/datum/recipe/meatpie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/meatpie

/datum/recipe/tofupie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofupie

/datum/recipe/xemeatpie
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xemeatpie

/datum/recipe/pie
	appliance = OVEN
	fruit = list(PLANT_BANANA = 1)
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/pie

/datum/recipe/cherrypie
	appliance = OVEN
	fruit = list(PLANT_CHERRY = 1)
	reagents = list(REAGENT_ID_SUGAR = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/cherrypie

/datum/recipe/amanita_pie
	appliance = OVEN
	reagents = list(REAGENT_ID_AMATOXIN = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/amanita_pie

/datum/recipe/plump_pie
	appliance = OVEN
	fruit = list(PLANT_PLUMPHELMET = 1)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/plump_pie

/datum/recipe/applepie
	appliance = OVEN
	fruit = list(PLANT_APPLE = 1)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/applepie

/datum/recipe/pumpkinpie
	appliance = OVEN
	fruit = list(PLANT_PUMPKIN = 1)
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie

/datum/recipe/appletart
	appliance = OVEN
	fruit = list(PLANT_GOLDAPPLE = 1)
	reagents = list(REAGENT_ID_SUGAR = 10)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/appletart
	result_quantity = 2
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/keylimepie
	appliance = OVEN
	fruit = list(PLANT_LIME = 2)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3, REAGENT_ID_FLOUR = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/datum/recipe/quiche
	appliance = OVEN
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_EGG = 9, REAGENT_ID_FLOUR = 10)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/sliceable/quiche
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

//Baked sweets:
//---------------

/datum/recipe/cookie
	appliance = OVEN
	reagents = list(REAGENT_ID_MILK = 10, REAGENT_ID_SUGAR = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/cookie
	result_quantity = 4
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/ovenfortunecookie
	appliance = OVEN
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie

/datum/recipe/poppypretzel
	appliance = OVEN
	fruit = list(PLANT_POPPIES = 1)
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/poppypretzel
	result_quantity = 2

/datum/recipe/cracker
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/cracker

/datum/recipe/brownies
	appliance = OVEN
	reagents = list(REAGENT_ID_BROWNIEMIX = 10, REAGENT_ID_EGG = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/brownies

/datum/recipe/cosmicbrownies
	appliance = OVEN
	reagents = list(REAGENT_ID_BROWNIEMIX = 10, REAGENT_ID_EGG = 3)
	fruit = list(PLANT_AMBROSIA = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies

/datum/recipe/buchedenoel
	appliance = OVEN
	fruit = list(PLANT_BERRIES = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 20, REAGENT_ID_CREAM = 10, REAGENT_ID_COCO = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/buchedenoel

/datum/recipe/cinnamonbun
	appliance = OVEN
	reagents = list(REAGENT_ID_SUGAR = 15, REAGENT_ID_CREAM = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
		)
	result = /obj/item/reagent_containers/food/snacks/cinnamonbun
	result_quantity = 4

/datum/recipe/jaffacake
	appliance = OVEN
	fruit = list(PLANT_ORANGE = 1)
	reagents = list(REAGENT_ID_CAKEBATTER = 15, REAGENT_ID_COCO = 10)
	result = /obj/item/reagent_containers/food/snacks/jaffacake
	result_quantity = 6

//Pizzas
//=========================
/datum/recipe/pizzamargherita
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita

/datum/recipe/meatpizza
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/syntipizza
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/mushroompizza
	appliance = OVEN
	fruit = list(PLANT_MUSHROOMS = 5, PLANT_TOMATO = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)

	reagent_mix = RECIPE_REAGENT_REPLACE //No vomit taste in finished product from chanterelles
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/datum/recipe/vegetablepizza
	appliance = OVEN
	fruit = list(PLANT_EGGPLANT = 1, PLANT_CARROT = 1, PLANT_CORN = 1, PLANT_TOMATO = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/datum/recipe/pineapplepizza
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/pineapple_ring,
		/obj/item/reagent_containers/food/snacks/pineapple_ring
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple

//Spicy
//================

/datum/recipe/enchiladas
	appliance = OVEN
	fruit = list(PLANT_CHILI = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/enchiladas


// Cakes.
//============
/datum/recipe/cake
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30, REAGENT_ID_VANILLA = 2)
	result = /obj/item/reagent_containers/food/snacks/sliceable/plaincake
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/cake/carrot
	appliance = OVEN
	fruit = list(PLANT_CARROT = 3)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake

/datum/recipe/cake/cheese
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake

/datum/recipe/cake/peanut
	fruit = list(PLANT_PEANUT = 1)
	reagents = list(REAGENT_ID_CAKEBATTER = 30, REAGENT_ID_PEANUTBUTTER = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/peanutcake

/datum/recipe/cake/orange
	appliance = OVEN
	fruit = list(PLANT_ORANGE = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/reagent_containers/food/snacks/sliceable/orangecake

/datum/recipe/cake/lime
	appliance = OVEN
	fruit = list(PLANT_LIME = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/reagent_containers/food/snacks/sliceable/limecake

/datum/recipe/cake/lemon
	appliance = OVEN
	fruit = list(PLANT_LEMON = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake

/datum/recipe/cake/chocolate
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30, REAGENT_ID_COCO = 5)
	result = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake

/datum/recipe/cake/birthday
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	items = list(/obj/item/clothing/head/cakehat)
	result = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake

/datum/recipe/cake/apple
	appliance = OVEN
	fruit = list(PLANT_APPLE = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/reagent_containers/food/snacks/sliceable/applecake

/datum/recipe/cake/brain
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/reagent_containers/food/snacks/sliceable/braincake

/datum/recipe/pancakes
	appliance = OVEN
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 15)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/pancakes
	result_quantity = 2

/datum/recipe/pancakes/berry
	appliance = OVEN
	fruit = list(PLANT_BERRIES = 2)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 15)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/pancakes/berry
	result_quantity = 2

/datum/recipe/lasagna
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 2, PLANT_EGGPLANT = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/lasagna
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/honeybun
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_EGG = 3,REAGENT_ID_HONEY = 5)
	result = /obj/item/reagent_containers/food/snacks/honeybun
	result_quantity = 4

//Bacon
/datum/recipe/bacon_oven
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/spreads
	)
	result = /obj/item/reagent_containers/food/snacks/bacon/oven
	result_quantity = 6

/datum/recipe/meat_pocket
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/meat_pocket
	result_quantity = 2

/datum/recipe/bacon_flatbread
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_flatbread

/datum/recipe/truffle
	appliance = OVEN
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_CREAM = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/truffle
	result_quantity = 4

/datum/recipe/croissant
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_WATER = 5, REAGENT_ID_MILK = 5, REAGENT_ID_YEAST = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/croissant
	result_quantity = 2

/datum/recipe/macncheese
	appliance = OVEN
	reagents = list(REAGENT_ID_MILK = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/macncheese

/datum/recipe/suppermatter
	appliance = OVEN
	reagents = list(REAGENT_ID_RADIUM = 5, REAGENT_ID_MILK = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/cheesecake
		)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/sliceable/suppermatter

/datum/recipe/excitingsuppermatter
	appliance = OVEN
	reagents = list(REAGENT_ID_RADIUM = 5, REAGENT_ID_SPACESPICE = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/cheesecake
		)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/sliceable/excitingsuppermatter

/datum/recipe/waffles
	appliance = OVEN
	reagents = list(REAGENT_ID_SUGAR = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/waffles
	result_quantity = 2

/datum/recipe/loadedbakedpotatooven
	appliance = OVEN
	fruit = list(PLANT_POTATO = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

/datum/recipe/meatbun
	appliance = OVEN
	fruit = list(PLANT_CABBAGE = 1)
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/reagent_containers/food/snacks/meatbun
	result_quantity = 2

/datum/recipe/spicedmeatbun
	appliance = OVEN
	reagents = list(REAGENT_ID_SPACESPICE = 2, REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/reagent_containers/food/snacks/spicedmeatbun
	result_quantity = 2

/datum/recipe/custardbun
	appliance = OVEN
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_WATER = 5, REAGENT_ID_EGG = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/reagent_containers/food/snacks/custardbun

/datum/recipe/chickenmomo
	appliance = OVEN
	reagents = list(REAGENT_ID_SPACESPICE = 2, REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chickenmomo
	result_quantity = 2

/datum/recipe/veggiemomo
	appliance = OVEN
	reagents = list(REAGENT_ID_SPACESPICE = 2, REAGENT_ID_WATER = 5)
	fruit = list(PLANT_CARROT = 1, PLANT_CABBAGE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/veggiemomo
	result_quantity = 2
