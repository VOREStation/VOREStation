/*
/datum/recipe/unique_name
	fruit = list("example_fruit1" = 1, "example_fruit2" = 2)
	reagents = list("example_reagent1" = 10, "example_reagent2" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/imaginary_meat_ingredient,
		/obj/item/reagent_containers/food/snacks/meat/this_won't_compile
	)
	result = /obj/item/reagent_containers/food/snacks/path_to_some_food
*/
// All of this shit needs to be gone through and reorganized into different recipes per machine - Rykka 7/16/2020

/datum/recipe/sushi
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/datum/recipe/goulash
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	result = /obj/item/reagent_containers/food/snacks/goulash

/datum/recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/donerkebab


/datum/recipe/roastbeef
	fruit = list("carrot" = 2, "potato" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/roastbeef

/datum/recipe/reishicup
	reagents = list(REAGENT_ID_PSILOCYBIN = 3, REAGENT_ID_SUGAR = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/reishicup

/datum/recipe/hotandsoursoup
	fruit = list("cabbage" = 1, "mushroom" = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, "blackpepper" = 2, REAGENT_ID_WATER = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/hotandsoursoup

/datum/recipe/kitsuneudon
	reagents = list("egg" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/kitsuneudon

/datum/recipe/pillbugball
	reagents = list(REAGENT_ID_CARBON = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/grubmeat
	)
	result = /obj/item/reagent_containers/food/snacks/bugball

/datum/recipe/mammi
	fruit = list("orange" = 1)
	reagents = list(REAGENT_ID_WATER = 10, "flour" = 10, "milk" = 5, REAGENT_ID_SODIUMCHLORIDE = 1)
	result = /obj/item/reagent_containers/food/snacks/mammi

/datum/recipe/makaroni
	reagents = list("flour" = 15, "milk" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/grubmeat,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/makaroni

/datum/recipe/carpsushi
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/sushi

/datum/recipe/lobster
	fruit = list("lemon" = 1, "lettuce" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/lobster
	)
	result = /obj/item/reagent_containers/food/snacks/lobstercooked

/datum/recipe/cuttlefish
	items = list(
		/obj/item/reagent_containers/food/snacks/cuttlefish
	)
	result = /obj/item/reagent_containers/food/snacks/cuttlefishcooked

/datum/recipe/monkfish
	fruit = list("chili" = 1, "onion" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/monkfishfillet
	)
	result = /obj/item/reagent_containers/food/snacks/monkfishcooked

/datum/recipe/sharksteak
	reagents = list("blackpepper"= 1, REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	)
	result = /obj/item/reagent_containers/food/snacks/sharkmeatcooked

/datum/recipe/sharkdip
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1)
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	)
	result = /obj/item/reagent_containers/food/snacks/sharkmeatdip

/datum/recipe/sharkcubes
	reagents = list("soysauce" = 5, REAGENT_ID_SODIUMCHLORIDE = 1)
	fruit = list("potato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	)
	result = /obj/item/reagent_containers/food/snacks/sharkmeatcubes

//// food cubes

/datum/recipe/foodcubes
	reagents = list("enzyme" = 20, "virusfood" = 5, REAGENT_ID_NUTRIMENT = 15, "protein" = 15) // labor intensive
	items = list()
	result = /obj/item/storage/box/wings/tray

/datum/recipe/bucket
	fruit = list("durian" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/storage/box/wings/bucket

/datum/recipe/grub_pink
	fruit = list("cherries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/grub
	)
	result = /obj/item/reagent_containers/food/snacks/grub_pink

/datum/recipe/grub_blue
	fruit = list("berries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/grub
	)
	result = /obj/item/reagent_containers/food/snacks/grub_blue

/datum/recipe/grub_purple
	fruit = list("grapes" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/grub
	)
	result = /obj/item/reagent_containers/food/snacks/grub_purple

/datum/recipe/honey_candy
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_NUTRIMENT = 5)
	items = list()
	result = /obj/item/reagent_containers/food/snacks/honey_candy

/datum/recipe/altevian_steak
	items = list(
		/obj/item/reagent_containers/food/snacks/ratprotein,
		/obj/item/reagent_containers/food/snacks/ratveggies,
		/obj/item/reagent_containers/food/snacks/ratliquid
	)
	result = /obj/item/reagent_containers/food/snacks/ratsteak
