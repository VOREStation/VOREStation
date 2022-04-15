/datum/recipe/ovenfries
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/ovenfries

//Roasts
//---------------

/datum/recipe/dionaroast
	appliance = OVEN
	fruit = list("apple" = 1)
	reagents = list("pacid" = 5) //It dissolves the carapace. Still poisonous, though.
	items = list(/obj/item/weapon/holder/diona)
	result = /obj/item/weapon/reagent_containers/food/snacks/dionaroast
	reagent_mix = RECIPE_REAGENT_REPLACE //No eating polyacid

/datum/recipe/monkeysdelight
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkeysdelight
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/ribplate
	appliance = OVEN
	reagents = list("honey" = 5, "spacespice" = 2, "blackpepper" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/ribplate

/datum/recipe/turkey
	appliance = OVEN
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/chicken,
		/obj/item/weapon/reagent_containers/food/snacks/stuffing
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/turkey

/datum/recipe/tofurkey
	appliance = OVEN
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/stuffing
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tofurkey

/datum/recipe/zestfish
	appliance = OVEN
	fruit = list("lemon" = 1)
	reagents = list("sodiumchloride" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/zestfish

/datum/recipe/limezestfish
	appliance = OVEN
	fruit = list("lime" = 1)
	reagents = list("sodiumchloride" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/zestfish


//Predesigned breads
//================================
/datum/recipe/bread
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	reagents = list("sodiumchloride" = 1, "yeast" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/bread

/datum/recipe/baguette
	appliance = OVEN
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1,  "yeast" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/baguette


/datum/recipe/tofubread
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread


/datum/recipe/creamcheesebread
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread

/datum/recipe/flatbread
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/flatbread

/datum/recipe/tortilla
	appliance = OVEN
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tortilla

/datum/recipe/meatbread
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread

/datum/recipe/syntibread
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread

/datum/recipe/xenomeatbread
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/xenomeat,
		/obj/item/weapon/reagent_containers/food/snacks/xenomeat,
		/obj/item/weapon/reagent_containers/food/snacks/xenomeat,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread

/datum/recipe/bananabread
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread


/datum/recipe/bun
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bun

//Predesigned pies
//=======================

/datum/recipe/meatpie
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/meat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatpie

/datum/recipe/tofupie
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tofupie

/datum/recipe/xemeatpie
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/xemeatpie

/datum/recipe/pie
	appliance = OVEN
	fruit = list("banana" = 1)
	reagents = list("sugar" = 5)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie

/datum/recipe/cherrypie
	appliance = OVEN
	fruit = list("cherries" = 1)
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cherrypie

/datum/recipe/amanita_pie
	appliance = OVEN
	reagents = list("amatoxin" = 5)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/weapon/reagent_containers/food/snacks/amanita_pie

/datum/recipe/plump_pie
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/weapon/reagent_containers/food/snacks/plump_pie

/datum/recipe/applepie
	appliance = OVEN
	fruit = list("apple" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/weapon/reagent_containers/food/snacks/applepie

/datum/recipe/pumpkinpie
	appliance = OVEN
	fruit = list("pumpkin" = 1)
	reagents = list("sugar" = 5)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pumpkinpie

/datum/recipe/appletart
	appliance = OVEN
	fruit = list("goldapple" = 1)
	reagents = list("sugar" = 10)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/weapon/reagent_containers/food/snacks/appletart
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/keylimepie
	appliance = OVEN
	fruit = list("lime" = 2)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/keylimepie
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

/datum/recipe/quiche
	appliance = OVEN
	reagents = list("milk" = 5, "egg" = 9, "flour" = 10)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/quiche
	reagent_mix = RECIPE_REAGENT_REPLACE //No raw egg in finished product, protein after cooking causes magic meatballs otherwise

//Baked sweets:
//---------------

/datum/recipe/cookie
	appliance = OVEN
	reagents = list("milk" = 10, "sugar" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cookie
	result_quantity = 4
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/ovenfortunecookie
	appliance = OVEN
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/paper
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fortunecookie

/datum/recipe/poppypretzel
	appliance = OVEN
	fruit = list("poppy" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/dough)
	result = /obj/item/weapon/reagent_containers/food/snacks/poppypretzel
	result_quantity = 2

/datum/recipe/cracker
	appliance = OVEN
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cracker

/datum/recipe/brownies
	appliance = OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/brownies


/datum/recipe/cosmicbrownies
	appliance = OVEN
	reagents = list("browniemix" = 10, "egg" = 3)
	fruit = list("ambrosia" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //No egg or mix in final recipe
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/cosmicbrownies

/datum/recipe/buchedenoel
	appliance = OVEN
	fruit = list("berries" = 2)
	reagents = list("milk" = 5, "flour" = 15, "cream" = 10, "coco" = 5, "egg" = 6)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/buchedenoel

/datum/recipe/cinnamonbun
	appliance = OVEN
	reagents = list("sugar" = 15, "cream" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/cinnamonbun
	result_quantity = 4


//Pizzas
//=========================
/datum/recipe/pizzamargherita
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita

/datum/recipe/meatpizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/syntipizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/mushroompizza
	appliance = OVEN
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)

	reagent_mix = RECIPE_REAGENT_REPLACE //No vomit taste in finished product from chanterelles
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/datum/recipe/vegetablepizza
	appliance = OVEN
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/datum/recipe/pineapplepizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/pineapple_ring,
		/obj/item/weapon/reagent_containers/food/snacks/pineapple_ring
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/pineapple

//Spicy
//================

/datum/recipe/enchiladas
	appliance = OVEN
	fruit = list("chili" = 2)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/enchiladas


// Cakes.
//============
/datum/recipe/cake
	appliance = OVEN
	reagents = list("milk" = 5, "flour" = 15, "sugar" = 15, "egg" = 9, "vanilla" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/cake/carrot
	appliance = OVEN
	fruit = list("carrot" = 3)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9,"sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake

/datum/recipe/cake/cheese
	appliance = OVEN
	reagents = list("milk" = 5, "flour" = 15, "sugar" = 15, "egg" = 9)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake

/datum/recipe/cake/peanut
	fruit = list("peanut" = 3)
	reagents = list("milk" = 5, "flour" = 10, "sugar" = 5, "egg" = 6, "peanutbutter" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/peanutcake

/datum/recipe/cake/orange
	appliance = OVEN
	fruit = list("orange" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/orangecake

/datum/recipe/cake/lime
	appliance = OVEN
	fruit = list("lime" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "limejuice" = 3, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/limecake

/datum/recipe/cake/lemon
	appliance = OVEN
	fruit = list("lemon" = 1)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "lemonjuice" = 3, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/lemoncake

/datum/recipe/cake/chocolate
	appliance = OVEN
	items = list(/obj/item/weapon/reagent_containers/food/snacks/chocolatebar)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "coco" = 4, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake

/datum/recipe/cake/birthday
	appliance = OVEN
	reagents = list("milk" = 5, "flour" = 15, "sugar" = 15, "egg" = 9)
	items = list(/obj/item/clothing/head/cakehat)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake

/datum/recipe/cake/apple
	appliance = OVEN
	fruit = list("apple" = 2)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9,"sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake

/datum/recipe/cake/brain
	appliance = OVEN
	reagents = list("milk" = 5, "flour" = 15, "sugar" = 15, "egg" = 9)
	items = list(/obj/item/organ/internal/brain)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/braincake

/datum/recipe/pancakes
	appliance = OVEN
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pancakes

/datum/recipe/pancakes/berry
	appliance = OVEN
	fruit = list("berries" = 2)
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/pancakes/berry

/datum/recipe/lasagna
	appliance = OVEN
	fruit = list("tomato" = 2, "eggplant" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/lasagna
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/honeybun
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	reagents = list("milk" = 5, "egg" = 3,"honey" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/honeybun

//Bacon
/datum/recipe/bacon_oven
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawbacon,
		/obj/item/weapon/reagent_containers/food/snacks/rawbacon,
		/obj/item/weapon/reagent_containers/food/snacks/rawbacon,
		/obj/item/weapon/reagent_containers/food/snacks/rawbacon,
		/obj/item/weapon/reagent_containers/food/snacks/rawbacon,
		/obj/item/weapon/reagent_containers/food/snacks/rawbacon,
		/obj/item/weapon/reagent_containers/food/snacks/spreads
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bacon/oven
	result_quantity = 6

/datum/recipe/meat_pocket
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meat_pocket
	result_quantity = 2

/datum/recipe/bacon_flatbread
	appliance = OVEN
	fruit = list("tomato" = 2)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bacon_flatbread

/datum/recipe/truffle
	appliance = OVEN
	reagents = list("sugar" = 5, "cream" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/truffle
	result_quantity = 4

/datum/recipe/croissant
	appliance = OVEN
	reagents = list("sodiumchloride" = 1, "water" = 5, "milk" = 5, "yeast" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(/obj/item/weapon/reagent_containers/food/snacks/dough)
	result = /obj/item/weapon/reagent_containers/food/snacks/croissant

/datum/recipe/macncheese
	appliance = OVEN
	reagents = list("milk" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spagetti,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/macncheese

/datum/recipe/suppermatter
	appliance = OVEN
	reagents = list("radium" = 5, "milk" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake
		)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/suppermatter

/datum/recipe/excitingsuppermatter
	appliance = OVEN
	reagents = list("radium" = 5, "spacespice" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake
		)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/excitingsuppermatter

/datum/recipe/waffles
	appliance = OVEN
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/waffles

/datum/recipe/loadedbakedpotatooven
	appliance = OVEN
	fruit = list("potato" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato

/datum/recipe/meatbun
	appliance = OVEN
	fruit = list("cabbage" = 1)
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/weapon/reagent_containers/food/snacks/meatbun

/datum/recipe/spicedmeatbun
	appliance = OVEN
	reagents = list("spacespice" = 2, "water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/weapon/reagent_containers/food/snacks/spicedmeatbun

/datum/recipe/custardbun
	appliance = OVEN
	reagents = list("spacespice" = 1, "water" = 5, "egg" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/weapon/reagent_containers/food/snacks/custardbun

/datum/recipe/chickenmomo
	appliance = OVEN
	reagents = list("spacespice" = 2, "water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/chickenmomo

/datum/recipe/veggiemomo
	appliance = OVEN
	reagents = list("spacespice" = 2, "water" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
<<<<<<< HEAD
	result = /obj/item/weapon/reagent_containers/food/snacks/veggiemomo
=======
	result = /obj/item/weapon/reagent_containers/food/snacks/veggiemomo

/datum/recipe/lobster
	appliance = OVEN
	fruit = list("lemon" = 1, "lettuce" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/lobster
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/lobstercooked

/datum/recipe/cuttlefish
	appliance = OVEN
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cuttlefish
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cuttlefishcooked

/datum/recipe/monkfish
	appliance = OVEN
	fruit = list("chili" = 1, "onion" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkfishfillet
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkfishcooked

/datum/recipe/sharksteak
	appliance = OVEN
	reagents = list("blackpepper"= 1, "sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat/fish/sharkmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sharkmeatcooked
>>>>>>> 3a14333c8f8... Merge pull request #8536 from Cerebulon/lettucefeast
