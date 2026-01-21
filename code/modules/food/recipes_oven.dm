/datum/recipe/ovenfries
	appliance = OVEN
	items = list(
		/obj/item/food/rawsticks
	)
	result = /obj/item/food/ovenfries

//Roasts
//---------------

/datum/recipe/dionaroast
	appliance = OVEN
	fruit = list(PLANT_APPLE = 1)
	reagents = list(REAGENT_ID_PACID = 5) //It dissolves the carapace. Still poisonous, though.
	items = list(/obj/item/holder/diona)
	result = /obj/item/food/dionaroast
	reagent_mix = RECIPE_REAGENT_REPLACE //No eating polyacid

/datum/recipe/monkeysdelight
	appliance = OVEN
	fruit = list(PLANT_BANANA = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1, REAGENT_ID_FLOUR = 10)
	items = list(
		/obj/item/food/monkeycube
	)
	result = /obj/item/food/monkeysdelight
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/ribplate
	appliance = OVEN
	reagents = list(REAGENT_ID_HONEY = 5, REAGENT_ID_SPACESPICE = 2, REAGENT_ID_BLACKPEPPER = 1)
	items = list(/obj/item/food/meat)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/ribplate

/* OLD RECIPE
/datum/recipe/turkey
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/food/meat/chicken,
		/obj/item/food/stuffing
		)
	result = /obj/item/food/sliceable/turkey
*/

/datum/recipe/turkey
	appliance = OVEN
	fruit = list(PLANT_POTATO = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/food/rawturkey,
		/obj/item/food/stuffing
		)
	result = /obj/item/food/sliceable/turkey

/datum/recipe/tofurkey
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/food/tofu,
		/obj/item/food/tofu,
		/obj/item/food/stuffing
	)
	result = /obj/item/food/tofurkey

/datum/recipe/zestfish
	appliance = OVEN
	fruit = list(PLANT_LEMON = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 3)
	items = list(
		/obj/item/food/carpmeat
	)
	result = /obj/item/food/zestfish

/datum/recipe/limezestfish
	appliance = OVEN
	fruit = list(PLANT_LIME = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 3)
	items = list(
		/obj/item/food/carpmeat
	)
	result = /obj/item/food/zestfish
	wiki_flag = WIKI_SPOILER // secret if you know!


//Predesigned breads
//================================
/datum/recipe/bread
	appliance = OVEN
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough
	)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_YEAST = 5)
	result = /obj/item/food/sliceable/bread

/datum/recipe/baguette
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1,  REAGENT_ID_YEAST = 5)
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough
	)
	result = /obj/item/food/baguette


/datum/recipe/tofubread
	appliance = OVEN
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough,
		/obj/item/food/tofu,
		/obj/item/food/tofu,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/tofubread


/datum/recipe/creamcheesebread
	appliance = OVEN
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/creamcheesebread

/datum/recipe/flatbread
	appliance = OVEN
	items = list(
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/flatbread

/datum/recipe/tortilla
	appliance = OVEN
	reagents = list(REAGENT_ID_FLOUR = 5)
	items = list(
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/tortilla
	result_quantity = 3

/datum/recipe/meatbread
	appliance = OVEN
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough,
		/obj/item/food/meat,
		/obj/item/food/meat,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/meatbread

/datum/recipe/syntibread
	appliance = OVEN
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough,
		/obj/item/food/meat/syntiflesh,
		/obj/item/food/meat/syntiflesh,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/meatbread
	wiki_flag = WIKI_SPOILER // Synthflesh secret

/datum/recipe/xenomeatbread
	appliance = OVEN
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough,
		/obj/item/food/xenomeat,
		/obj/item/food/xenomeat,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/xenomeatbread

/datum/recipe/bananabread
	appliance = OVEN
	fruit = list(PLANT_BANANA = 1)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 15)
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough
	)
	result = /obj/item/food/sliceable/bananabread


/datum/recipe/bun
	appliance = OVEN
	items = list(
		/obj/item/food/dough
	)
	result = /obj/item/food/bun
	result_quantity = 3

//Predesigned pies
//=======================

/datum/recipe/meatpie
	appliance = OVEN
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/meat
	)
	result = /obj/item/food/meatpie

/datum/recipe/tofupie
	appliance = OVEN
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/tofu
	)
	result = /obj/item/food/tofupie

/datum/recipe/xemeatpie
	appliance = OVEN
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/xenomeat
	)
	result = /obj/item/food/xemeatpie

/datum/recipe/pie
	appliance = OVEN
	fruit = list(PLANT_BANANA = 1)
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(/obj/item/food/sliceable/flatdough)
	result = /obj/item/food/pie

/datum/recipe/cherrypie
	appliance = OVEN
	fruit = list(PLANT_CHERRY = 1)
	reagents = list(REAGENT_ID_SUGAR = 10)
	items = list(
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/cherrypie

/datum/recipe/amanita_pie
	appliance = OVEN
	reagents = list(REAGENT_ID_AMATOXIN = 5)
	items = list(/obj/item/food/sliceable/flatdough)
	result = /obj/item/food/amanita_pie

/datum/recipe/plump_pie
	appliance = OVEN
	fruit = list(PLANT_PLUMPHELMET = 1)
	items = list(/obj/item/food/sliceable/flatdough)
	result = /obj/item/food/plump_pie

/datum/recipe/applepie
	appliance = OVEN
	fruit = list(PLANT_APPLE = 1)
	items = list(/obj/item/food/sliceable/flatdough)
	result = /obj/item/food/applepie

/datum/recipe/pumpkinpie
	appliance = OVEN
	fruit = list(PLANT_PUMPKIN = 1)
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(/obj/item/food/sliceable/flatdough)
	result = /obj/item/food/sliceable/pumpkinpie

/datum/recipe/appletart
	appliance = OVEN
	fruit = list(PLANT_GOLDAPPLE = 1)
	reagents = list(REAGENT_ID_SUGAR = 10)
	items = list(/obj/item/food/sliceable/flatdough)
	result = /obj/item/food/appletart
	result_quantity = 2
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/keylimepie
	appliance = OVEN
	fruit = list(PLANT_LIME = 2)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3, REAGENT_ID_FLOUR = 10)
	result = /obj/item/food/sliceable/keylimepie
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/datum/recipe/quiche
	appliance = OVEN
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_EGG = 9, REAGENT_ID_FLOUR = 10)
	items = list(/obj/item/food/cheesewedge)
	result = /obj/item/food/sliceable/quiche
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

//Baked sweets:
//---------------

/datum/recipe/cookie
	appliance = OVEN
	reagents = list(REAGENT_ID_MILK = 10, REAGENT_ID_SUGAR = 10)
	items = list(
		/obj/item/food/dough,
		/obj/item/food/chocolatebar
	)
	result = /obj/item/food/cookie
	result_quantity = 4
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/ovenfortunecookie
	appliance = OVEN
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/doughslice,
		/obj/item/paper
	)
	result = /obj/item/food/fortunecookie

/datum/recipe/poppypretzel
	appliance = OVEN
	fruit = list(PLANT_POPPIES = 1)
	items = list(/obj/item/food/dough)
	result = /obj/item/food/poppypretzel
	result_quantity = 2

/datum/recipe/cracker
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/food/doughslice
	)
	result = /obj/item/food/cracker

/datum/recipe/brownies
	appliance = OVEN
	reagents = list(REAGENT_ID_BROWNIEMIX = 10, REAGENT_ID_EGG = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/food/sliceable/brownies

/datum/recipe/cosmicbrownies
	appliance = OVEN
	reagents = list(REAGENT_ID_BROWNIEMIX = 10, REAGENT_ID_EGG = 3)
	fruit = list(PLANT_AMBROSIA = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/food/sliceable/cosmicbrownies

/datum/recipe/buchedenoel
	appliance = OVEN
	fruit = list(PLANT_BERRIES = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 20, REAGENT_ID_CREAM = 10, REAGENT_ID_COCO = 5)
	result = /obj/item/food/sliceable/buchedenoel

/datum/recipe/cinnamonbun
	appliance = OVEN
	reagents = list(REAGENT_ID_SUGAR = 15, REAGENT_ID_CREAM = 10)
	items = list(
		/obj/item/food/dough
		)
	result = /obj/item/food/cinnamonbun
	result_quantity = 4

/datum/recipe/jaffacake
	appliance = OVEN
	fruit = list(PLANT_ORANGE = 1)
	reagents = list(REAGENT_ID_CAKEBATTER = 15, REAGENT_ID_COCO = 10)
	result = /obj/item/food/jaffacake
	result_quantity = 6

//Pizzas
//=========================
/datum/recipe/pizzamargherita
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/pizza/margherita

/datum/recipe/meatpizza
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/meat,
		/obj/item/food/meat,
		/obj/item/food/meat,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/pizza/meatpizza

/datum/recipe/syntipizza
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/meat/syntiflesh,
		/obj/item/food/meat/syntiflesh,
		/obj/item/food/meat/syntiflesh,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/pizza/meatpizza
	wiki_flag = WIKI_SPOILER // Synthflesh spoiler

/datum/recipe/mushroompizza
	appliance = OVEN
	fruit = list(PLANT_MUSHROOMS = 5, PLANT_TOMATO = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/cheesewedge
	)

	reagent_mix = RECIPE_REAGENT_REPLACE //No vomit taste in finished product from chanterelles
	result = /obj/item/food/sliceable/pizza/mushroompizza

/datum/recipe/vegetablepizza
	appliance = OVEN
	fruit = list(PLANT_EGGPLANT = 1, PLANT_CARROT = 1, PLANT_CORN = 1, PLANT_TOMATO = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/pizza/vegetablepizza

/datum/recipe/pineapplepizza
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/cheesewedge,
		/obj/item/food/pineapple_ring,
		/obj/item/food/pineapple_ring
	)
	result = /obj/item/food/sliceable/pizza/pineapple

//Spicy
//================

/datum/recipe/enchiladas
	appliance = OVEN
	fruit = list(PLANT_CHILI = 2)
	items = list(
		/obj/item/food/cutlet,
		/obj/item/food/tortilla
	)
	result = /obj/item/food/enchiladas


// Cakes.
//============
/datum/recipe/cake
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30, REAGENT_ID_VANILLA = 2)
	result = /obj/item/food/sliceable/plaincake
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/cake/carrot
	appliance = OVEN
	fruit = list(PLANT_CARROT = 3)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/food/sliceable/carrotcake

/datum/recipe/cake/cheese
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	items = list(
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/sliceable/cheesecake

/datum/recipe/cake/peanut
	fruit = list(PLANT_PEANUT = 1)
	reagents = list(REAGENT_ID_CAKEBATTER = 30, REAGENT_ID_PEANUTBUTTER = 5)
	result = /obj/item/food/sliceable/peanutcake

/datum/recipe/cake/orange
	appliance = OVEN
	fruit = list(PLANT_ORANGE = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/food/sliceable/orangecake

/datum/recipe/cake/lime
	appliance = OVEN
	fruit = list(PLANT_LIME = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/food/sliceable/limecake

/datum/recipe/cake/lemon
	appliance = OVEN
	fruit = list(PLANT_LEMON = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/food/sliceable/lemoncake

/datum/recipe/cake/chocolate
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30, REAGENT_ID_COCO = 5)
	result = /obj/item/food/sliceable/chocolatecake

/datum/recipe/cake/birthday
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	items = list(/obj/item/clothing/head/cakehat)
	result = /obj/item/food/sliceable/birthdaycake

/datum/recipe/cake/apple
	appliance = OVEN
	fruit = list(PLANT_APPLE = 2)
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	result = /obj/item/food/sliceable/applecake

/datum/recipe/cake/brain
	appliance = OVEN
	reagents = list(REAGENT_ID_CAKEBATTER = 30)
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/food/sliceable/braincake

/datum/recipe/pancakes
	appliance = OVEN
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 15)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/pancakes
	result_quantity = 2

/datum/recipe/pancakes/berry
	appliance = OVEN
	fruit = list(PLANT_BERRIES = 2)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 15)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/pancakes/berry
	result_quantity = 2

/datum/recipe/lasagna
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 2, PLANT_EGGPLANT = 1)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/cutlet,
		/obj/item/food/cutlet
	)
	result = /obj/item/food/lasagna
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/honeybun
	appliance = OVEN
	items = list(
		/obj/item/food/dough
	)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_EGG = 3,REAGENT_ID_HONEY = 5)
	result = /obj/item/food/honeybun
	result_quantity = 4

//Bacon
/datum/recipe/bacon_oven
	appliance = OVEN
	items = list(
		/obj/item/food/rawbacon,
		/obj/item/food/rawbacon,
		/obj/item/food/rawbacon,
		/obj/item/food/rawbacon,
		/obj/item/food/rawbacon,
		/obj/item/food/rawbacon,
		/obj/item/food/spreads
	)
	result = /obj/item/food/bacon/oven
	result_quantity = 6

/datum/recipe/meat_pocket
	appliance = OVEN
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/meatball,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/meat_pocket
	result_quantity = 2

/datum/recipe/bacon_flatbread
	appliance = OVEN
	fruit = list(PLANT_TOMATO = 2)
	items = list(
		/obj/item/food/sliceable/flatdough,
		/obj/item/food/cheesewedge,
		/obj/item/food/bacon,
		/obj/item/food/bacon,
		/obj/item/food/bacon,
		/obj/item/food/bacon
	)
	result = /obj/item/food/bacon_flatbread

/datum/recipe/truffle
	appliance = OVEN
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_CREAM = 5)
	items = list(
		/obj/item/food/chocolatebar
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/truffle
	result_quantity = 4

/datum/recipe/croissant
	appliance = OVEN
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_WATER = 5, REAGENT_ID_MILK = 5, REAGENT_ID_YEAST = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(/obj/item/food/dough)
	result = /obj/item/food/croissant
	result_quantity = 2

/datum/recipe/macncheese
	appliance = OVEN
	reagents = list(REAGENT_ID_MILK = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/food/spagetti,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/macncheese

/datum/recipe/suppermatter
	appliance = OVEN
	reagents = list(REAGENT_ID_RADIUM = 5, REAGENT_ID_MILK = 5)
	items = list(
		/obj/item/food/sliceable/cheesecake
		)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/sliceable/suppermatter

/datum/recipe/excitingsuppermatter
	appliance = OVEN
	reagents = list(REAGENT_ID_RADIUM = 5, REAGENT_ID_SPACESPICE = 5)
	items = list(
		/obj/item/food/sliceable/cheesecake
		)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/sliceable/excitingsuppermatter

/datum/recipe/waffles
	appliance = OVEN
	reagents = list(REAGENT_ID_SUGAR = 10)
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough
	)
	result = /obj/item/food/waffles
	result_quantity = 2

/datum/recipe/loadedbakedpotatooven
	appliance = OVEN
	fruit = list(PLANT_POTATO = 1)
	items = list(/obj/item/food/cheesewedge)
	result = /obj/item/food/loadedbakedpotato

/datum/recipe/meatbun
	appliance = OVEN
	fruit = list(PLANT_CABBAGE = 1)
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/meatball,
		/obj/item/food/sliceable/flatdough,
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/food/meatbun
	result_quantity = 2

/datum/recipe/spicedmeatbun
	appliance = OVEN
	reagents = list(REAGENT_ID_SPACESPICE = 2, REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/doughslice,
		/obj/item/food/rawcutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/food/spicedmeatbun
	result_quantity = 2

/datum/recipe/custardbun
	appliance = OVEN
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_WATER = 5, REAGENT_ID_EGG = 3)
	items = list(
		/obj/item/food/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/food/custardbun

/datum/recipe/chickenmomo
	appliance = OVEN
	reagents = list(REAGENT_ID_SPACESPICE = 2, REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/doughslice,
		/obj/item/food/doughslice,
		/obj/item/food/doughslice,
		/obj/item/food/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/chickenmomo
	result_quantity = 2

/datum/recipe/veggiemomo
	appliance = OVEN
	reagents = list(REAGENT_ID_SPACESPICE = 2, REAGENT_ID_WATER = 5)
	fruit = list(PLANT_CARROT = 1, PLANT_CABBAGE = 1)
	items = list(
		/obj/item/food/doughslice,
		/obj/item/food/doughslice,
		/obj/item/food/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/food/veggiemomo
	result_quantity = 2
