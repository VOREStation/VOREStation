/*
/datum/recipe/unique_name
	fruit = list("example_fruit1" = 1, "example_fruit2" = 2)
	reagents = list("example_reagent1" = 10, "example_reagent2" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/imaginary_meat_ingredient,
		/obj/item/weapon/reagent_containers/food/snacks/meat/this_won't_compile
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/path_to_some_food
*/

/datum/recipe/jellydonut
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice)

/datum/recipe/jellydonut/slime
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice)

/datum/recipe/jellydonut/cherry
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice)

/datum/recipe/donut
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice)

/datum/recipe/sushi
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/sushi

/datum/recipe/lasagna
	fruit = list("tomato" = 2, "eggplant" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/lasagna

/datum/recipe/goulash
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/spagetti
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/goulash

/datum/recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatsteak,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donerkebab

/datum/recipe/roastbeef
	fruit = list("carrot" = 2, "potato" = 2)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/roastbeef

/datum/recipe/reishicup
	reagents = list("psilocybin" = 3, "sugar" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/reishicup

/datum/recipe/chickenwings
	reagents = list("capsaicin" = 5, "flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat
	)
	result = /obj/item/weapon/storage/box/wings //This is kinda like the donut box.

/datum/recipe/hotandsoursoup
	fruit = list("cabbage" = 1, "mushroom" = 1)
	reagents = list("sodiumchloride" = 2, "blackpepper" = 2, "water" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/hotandsoursoup

/datum/recipe/kitsuneudon
	reagents = list("egg" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spagetti,
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kitsuneudon

/datum/recipe/generalschicken
	reagents = list("capsaicin" = 2, "sugar" = 2, "flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/generalschicken

/datum/recipe/chocroizegg
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar,
		/obj/item/weapon/reagent_containers/food/snacks/egg/roiz
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chocolateegg/roiz

/datum/recipe/friedroizegg
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg/roiz
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/friedegg/roiz

/datum/recipe/boiledroizegg
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg/roiz
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/boiledegg/roiz

/datum/recipe/pillbugball
	reagents = list("carbon" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/grubmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bugball

/datum/recipe/mammi
	fruit = list("orange" = 1)
	reagents = list("water" = 10, "flour" = 10, "milk" = 5, "sodiumchloride" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/mammi

/datum/recipe/makaroni
	reagents = list("flour" = 15, "milk" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/grubmeat,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/makaroni

/datum/recipe/lobster
	fruit = list("lemon" = 1, "cabbage" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/lobster
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/lobstercooked

/datum/recipe/cuttlefish
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cuttlefish
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cuttlefishcooked

/datum/recipe/monkfish
	fruit = list("chili" = 1, "onion" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkfishfillet
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkfishcooked

/datum/recipe/sharksteak
	reagents = list("blackpepper"= 1, "sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sharkmeatcooked

/datum/recipe/sharkdip
	reagents = list("sodiumchloride" = 1)
	fruit = list("chili" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sharkmeatdip

/datum/recipe/sharkcubes
	reagents = list("soysauce" = 5, "sodiumchloride" = 1)
	fruit = list("potato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sharkmeatcubes

/datum/recipe/margheritapizzacargo
	reagents = list()
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/pizza/margfrozen
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margcargo

/datum/recipe/mushroompizzacargo
	reagents = list()
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/pizza/mushfrozen
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushcargo

/datum/recipe/meatpizzacargo
	reagents = list()
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/pizza/meatfrozen
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatcargo

/datum/recipe/vegtablepizzacargo
	reagents = list()
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/pizza/vegfrozen
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegcargo

//// food cubes

/datum/recipe/foodcubes
	reagents = list("enzyme" = 20,"virusfood" = 5, "nutriment" = 15, "protein" = 15) // labor intensive
	items = list()
	result = /obj/item/weapon/storage/box/wings/tray