/*
/datum/recipe/unique_name
	fruit = list("example_fruit1" = 1, "example_fruit2" = 2)
	reagents = list("example_reagent1" = 10, "example_reagent2" = 5)
	items = list(
		/obj/item/food/meat/imaginary_meat_ingredient,
		/obj/item/food/meat/this_won't_compile
	)
	result = /obj/item/food/path_to_some_food
*/
// All of this shit needs to be gone through and reorganized into different recipes per machine - Rykka 7/16/2020

/datum/recipe/sushi
	fruit = list(PLANT_CABBAGE = 1)
	reagents = list(REAGENT_ID_RICE = 20)
	items = list(
		/obj/item/food/meat,
		/obj/item/food/meat,
		/obj/item/food/meat
	)
	result = /obj/item/food/sliceable/sushi

/datum/recipe/goulash
	fruit = list(PLANT_TOMATO = 1)
	items = list(
		/obj/item/food/cutlet,
		/obj/item/food/spagetti
	)
	result = /obj/item/food/goulash

/datum/recipe/donerkebab
	fruit = list(PLANT_TOMATO = 1, PLANT_CABBAGE = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/food/meatsteak,
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/donerkebab


/datum/recipe/roastbeef
	fruit = list(PLANT_CARROT = 2, PLANT_POTATO = 2)
	items = list(
		/obj/item/food/meat
	)
	result = /obj/item/food/roastbeef

/datum/recipe/reishicup
	reagents = list(REAGENT_ID_PSILOCYBIN = 3, REAGENT_ID_SUGAR = 3)
	items = list(
		/obj/item/food/chocolatebar
	)
	result = /obj/item/food/reishicup

/datum/recipe/hotandsoursoup
	fruit = list(PLANT_CABBAGE = 1, PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, REAGENT_ID_BLACKPEPPER = 2, REAGENT_ID_WATER = 10)
	items = list(
		/obj/item/food/tofu
	)
	result = /obj/item/food/hotandsoursoup

/datum/recipe/kitsuneudon
	reagents = list(REAGENT_ID_EGG = 3)
	items = list(
		/obj/item/food/spagetti,
		/obj/item/food/tofu
	)
	result = /obj/item/food/kitsuneudon

/datum/recipe/pillbugball
	reagents = list(REAGENT_ID_CARBON = 5)
	items = list(
		/obj/item/food/meat/grubmeat
	)
	result = /obj/item/food/bugball

/datum/recipe/mammi
	fruit = list(PLANT_ORANGE = 1)
	reagents = list(REAGENT_ID_WATER = 10, REAGENT_ID_FLOUR = 10, REAGENT_ID_MILK = 5, REAGENT_ID_SODIUMCHLORIDE = 1)
	result = /obj/item/food/mammi

/datum/recipe/makaroni
	reagents = list(REAGENT_ID_FLOUR = 15, REAGENT_ID_MILK = 5)
	items = list(
		/obj/item/food/meat/grubmeat,
		/obj/item/food/egg,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/makaroni

/datum/recipe/carpsushi
	fruit = list(PLANT_CABBAGE = 1)
	reagents = list(REAGENT_ID_RICE = 20)
	items = list(
		/obj/item/food/carpmeat,
		/obj/item/food/carpmeat,
		/obj/item/food/carpmeat
	)
	result = /obj/item/food/sliceable/sushi
	wiki_flag = WIKI_SPOILER // Secretish? Just assume carp is fish anyway

/datum/recipe/lobster
	fruit = list(PLANT_LEMON = 1, PLANT_LETTUCE = 1)
	items = list(
		/obj/item/food/lobster
	)
	result = /obj/item/food/lobstercooked

/datum/recipe/cuttlefish
	items = list(
		/obj/item/food/cuttlefish
	)
	result = /obj/item/food/cuttlefishcooked

/datum/recipe/monkfish
	fruit = list(PLANT_CHILI = 1, PLANT_ONION = 1)
	items = list(
		/obj/item/food/monkfishfillet
	)
	result = /obj/item/food/monkfishcooked

/datum/recipe/sharksteak
	reagents = list(REAGENT_ID_BLACKPEPPER= 1, REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/food/carpmeat/fish/sharkmeat
	)
	result = /obj/item/food/sharkmeatcooked

/datum/recipe/sharkdip
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1)
	fruit = list(PLANT_CHILI = 1)
	items = list(
		/obj/item/food/carpmeat/fish/sharkmeat
	)
	result = /obj/item/food/sharkmeatdip

/datum/recipe/sharkcubes
	reagents = list(REAGENT_ID_SOYSAUCE = 5, REAGENT_ID_SODIUMCHLORIDE = 1)
	fruit = list(PLANT_POTATO = 1)
	items = list(
		/obj/item/food/carpmeat/fish/sharkmeat
	)
	result = /obj/item/food/sharkmeatcubes

//// food cubes

/datum/recipe/foodcubes
	reagents = list(REAGENT_ID_ENZYME = 20, REAGENT_ID_VIRUSFOOD = 5, REAGENT_ID_NUTRIMENT = 15, REAGENT_ID_PROTEIN = 15) // labor intensive
	items = list()
	result = /obj/item/storage/box/wings/tray

/datum/recipe/bucket
	fruit = list(PLANT_DURIAN = 1)
	items = list(
		/obj/item/food/meat,
		/obj/item/food/meat,
		/obj/item/food/meat,
		/obj/item/food/meat
	)
	result = /obj/item/storage/box/wings/bucket

/datum/recipe/grub_pink
	fruit = list(PLANT_CHERRY = 1)
	items = list(
		/obj/item/food/grub
	)
	result = /obj/item/food/grub_pink

/datum/recipe/grub_blue
	fruit = list(PLANT_BERRIES = 1)
	items = list(
		/obj/item/food/grub
	)
	result = /obj/item/food/grub_blue

/datum/recipe/grub_purple
	fruit = list(PLANT_GRAPES = 1)
	items = list(
		/obj/item/food/grub
	)
	result = /obj/item/food/grub_purple

/datum/recipe/honey_candy
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_NUTRIMENT = 5)
	items = list()
	result = /obj/item/food/honey_candy

/datum/recipe/altevian_steak
	items = list(
		/obj/item/food/ratprotein,
		/obj/item/food/ratveggies,
		/obj/item/food/ratliquid
	)
	result = /obj/item/food/ratsteak
