
// see code/datums/recipe.dm


/* No telebacon. just no...
/datum/recipe/telebacon
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/device/assembly/signaler
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/telebacon

I said no!
/datum/recipe/syntitelebacon
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/device/assembly/signaler
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/telebacon
*/

/datum/recipe/friedegg
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/friedegg

/datum/recipe/boiledegg
	reagents = list("water" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/boiledegg

/datum/recipe/devilledegg
	fruit = list("chili" = 1)
	reagents = list("sodiumchloride" = 2, "mayo" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/devilledegg

/datum/recipe/waffles
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/waffles

/datum/recipe/donkpocket
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donkpocket //SPECIAL
	proc/warm_up(var/obj/item/weapon/reagent_containers/food/snacks/donkpocket/being_cooked)
		being_cooked.heat()
	make_food(var/obj/container as obj)
		. = ..(container)
		for (var/obj/item/weapon/reagent_containers/food/snacks/donkpocket/D in .)
			if (!D.warm)
				warm_up(D)

/datum/recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donkpocket //SPECIAL

/datum/recipe/omelette
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	reagents = list("egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/omelette

/datum/recipe/muffin
	reagents = list("milk" = 5, "sugar" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/muffin

/datum/recipe/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/eggplantparm

/datum/recipe/soylenviridians
	fruit = list("soybeans" = 1)
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/soylenviridians

/datum/recipe/soylentgreen
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/human,
		/obj/item/weapon/reagent_containers/food/snacks/meat/human
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/soylentgreen

/datum/recipe/berryclafoutis
	fruit = list("berries" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/berryclafoutis/berry

/datum/recipe/poisonberryclafoutis
	fruit = list("poisonberries" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/berryclafoutis/poison

/datum/recipe/wingfangchu
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/wingfangchu

/datum/recipe/loadedbakedpotato
	fruit = list("potato" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato

/datum/recipe/microchips
	appliance = MICROWAVE
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/microchips

/datum/recipe/mashedpotato
	fruit = list("potato" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/mashedpotato

/datum/recipe/bangersandmash
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/mashedpotato,
		/obj/item/weapon/reagent_containers/food/snacks/sausage,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bangersandmash

/datum/recipe/cheesymash
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/mashedpotato,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cheesymash

/datum/recipe/blackpudding
	reagents = list("blood" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sausage,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/blackpudding

/datum/recipe/popcorn
	fruit = list("corn" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/popcorn

/datum/recipe/fortunecookie
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/paper,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fortunecookie

/datum/recipe/meatsteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatsteak

/datum/recipe/syntisteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatsteak

/datum/recipe/pizzahawaiian
	fruit = list("tomato" = 1, "pineapple" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/pineapple

/datum/recipe/spacylibertyduff
	reagents = list("water" = 5, "vodka" = 5, "psilocybin" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/spacylibertyduff

/datum/recipe/amanitajelly
	reagents = list("water" = 5, "vodka" = 5, "amatoxin" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/amanitajelly

/datum/recipe/amanitajelly/make_food(var/obj/container as obj)
	. = ..(container)
	for(var/obj/item/weapon/reagent_containers/food/snacks/amanitajelly/being_cooked in .)
		being_cooked.reagents.del_reagent("amatoxin")

/datum/recipe/meatballsoup
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list("water" = 10)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meatball)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatballsoup

/datum/recipe/vegetablesoup
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list("water" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/vegetablesoup

/datum/recipe/nettlesoup
	fruit = list("nettle" = 1, "potato" = 1)
	reagents = list("water" = 10, "egg" = 3)
	result = /obj/item/weapon/reagent_containers/food/snacks/nettlesoup

/datum/recipe/wishsoup
	reagents = list("water" = 20)
	result= /obj/item/weapon/reagent_containers/food/snacks/wishsoup

/datum/recipe/hotchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	result = /obj/item/weapon/reagent_containers/food/snacks/hotchili

/datum/recipe/coldchili
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	result = /obj/item/weapon/reagent_containers/food/snacks/coldchili

/datum/recipe/fishandchips
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/fries,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishandchips

/datum/recipe/sandwich
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatsteak,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sandwich

/datum/recipe/toastedsandwich
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/toastedsandwich

/datum/recipe/peanutbutterjellysandwich
	reagents = list("cherryjelly" = 5, "peanutbutter" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jellysandwich/peanutbutter

/datum/recipe/grilledcheese
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/grilledcheese

/datum/recipe/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list("water" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/tomatosoup

/datum/recipe/rofflewaffles
	reagents = list("psilocybin" = 5, "sugar" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/rofflewaffles

/datum/recipe/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list("water" = 10)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	result = /obj/item/weapon/reagent_containers/food/snacks/stew

/datum/recipe/slimetoast
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/slime

/datum/recipe/jelliedtoast
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/cherry

/datum/recipe/milosoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/soydope,
		/obj/item/weapon/reagent_containers/food/snacks/soydope,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/milosoup

/datum/recipe/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/soydope,
		/obj/item/weapon/reagent_containers/food/snacks/soydope
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat

/datum/recipe/boiledspagetti
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spagetti,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/boiledspagetti

/datum/recipe/boiledrice
	reagents = list("water" = 5, "rice" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/boiledrice

/datum/recipe/ricepudding
	reagents = list("milk" = 5, "rice" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/ricepudding

/datum/recipe/pastatomato
	fruit = list("tomato" = 2)
	reagents = list("water" = 5)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/spagetti)
	result = /obj/item/weapon/reagent_containers/food/snacks/pastatomato

/datum/recipe/meatballspagetti
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spagetti,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatballspagetti

/datum/recipe/spesslaw
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spagetti,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/spesslaw

/datum/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list("water" = 5, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/candiedapple

/datum/recipe/applepie
	fruit = list("apple" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/weapon/reagent_containers/food/snacks/applepie

/datum/recipe/twobread
	reagents = list("wine" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/twobread

/datum/recipe/slimesandwich
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jellysandwich/slime

/datum/recipe/cherrysandwich
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jellysandwich/cherry

/datum/recipe/bloodsoup
	reagents = list("blood" = 30)
	result = /obj/item/weapon/reagent_containers/food/snacks/bloodsoup

/datum/recipe/slimesoup
	reagents = list("water" = 10, "slimejelly" = 5)
	items = list()
	result = /obj/item/weapon/reagent_containers/food/snacks/slimesoup

/datum/recipe/boiledslimeextract
	reagents = list("water" = 5)
	items = list(
		/obj/item/slime_extract,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/boiledslimecore

/datum/recipe/chocolateegg
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chocolateegg

/datum/recipe/sausage
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sausage
	result_quantity = 2

/datum/recipe/fishfingers
	reagents = list("flour" = 10, "egg" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishfingers
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/zestfish
	fruit = list("lemon" = 1)
	reagents = list("sodiumchloride" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/zestfish

/datum/recipe/limezestfish
	fruit = list("lime" = 1)
	reagents = list("sodiumchloride" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/zestfish

/datum/recipe/kudzudonburi
	fruit = list("kudzu" = 1)
	reagents = list("rice" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/kudzudonburi

/datum/recipe/mysterysoup
	reagents = list("water" = 10, "egg" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/badrecipe,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/mysterysoup

/datum/recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list("water" = 5, "flour" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit

/datum/recipe/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "milk" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/mushroomsoup

/datum/recipe/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "soysauce" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chawanmushi

/datum/recipe/beetsoup
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list("water" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/beetsoup

/datum/recipe/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/tossedsalad

/datum/recipe/flowersalad
	fruit = list("harebell" = 1, "poppy" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/roastedsunflower
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/flowerchildsalad

/datum/recipe/rosesalad
	fruit = list("harebell" = 1, "rose" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/roastedsunflower
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/rosesalad

/datum/recipe/aesirsalad
	fruit = list("goldapple" = 1, "ambrosiadeus" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/aesirsalad

/datum/recipe/validsalad
	fruit = list("potato" = 1, "ambrosia" = 3)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meatball)
	result = /obj/item/weapon/reagent_containers/food/snacks/validsalad

/datum/recipe/validsalad/make_food(var/obj/container as obj)
	. = ..(container)
	for (var/obj/item/weapon/reagent_containers/food/snacks/validsalad/being_cooked in .)
		being_cooked.reagents.del_reagent("toxin")

/datum/recipe/stuffing
	reagents = list("water" = 5, "sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/stuffing

/datum/recipe/tofurkey
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/stuffing,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tofurkey

/datum/recipe/mashedpotato
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spreads/butter // to prevent conflicts with yellow curry
	)
	fruit = list("potato" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/mashedpotato

/datum/recipe/icecreamsandwich
	reagents = list("milk" = 5, "ice" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/icecream
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/icecreamsandwich

// Fuck Science!
/datum/recipe/ruinedvirusdish
	items = list(
		/obj/item/weapon/virusdish
	)
	result = /obj/item/weapon/ruinedvirusdish

/datum/recipe/onionrings
	fruit = list("onion" = 1)
	reagents = list("flour" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/onionrings

/datum/recipe/onionsoup
	fruit = list("onion" = 1)
	reagents = list("water" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/onionsoup

//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/datum/recipe/taco
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/taco

/datum/recipe/microwavebun
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bun

/datum/recipe/microwaveflatbread
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/flatbread

/datum/recipe/meatball
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawmeatball
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatball

/datum/recipe/cutlet
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cutlet

/datum/recipe/roastedsunflowerseeds
	reagents = list("sodiumchloride" = 1, "cornoil" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawsunflower
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/roastedsunflower

/datum/recipe/roastedpeanutsunflowerseeds
	reagents = list("sodiumchloride" = 1, "peanutoil" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawsunflower
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/roastedsunflower

/datum/recipe/roastedpeanuts
	fruit = list("peanut" = 2)
	reagents = list("sodiumchloride" = 2, "cornoil" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/roastedpeanuts

/datum/recipe/mint
	reagents = list("sugar" = 5, "frostoil" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/mint

////////////////////////
// TGstation food ports
////////////////////////

/datum/recipe/meatbun
	fruit = list("cabbage" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatbun

/datum/recipe/sashimi
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sashimi

/datum/recipe/benedict
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/friedegg,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/benedict

/datum/recipe/bakedbeans
	fruit = list("soybeans" = 2)
	reagents = list("ketchup" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/beans

/datum/recipe/sugarcookie
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	reagents = list("sugar" = 5, "egg" = 3)
	result = /obj/item/weapon/reagent_containers/food/snacks/sugarcookie

/datum/recipe/berrymuffin
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	fruit = list("berries" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/berrymuffin/berry

/datum/recipe/poisonberrymuffin
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	fruit = list("poisonberries" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/berrymuffin/poison

/datum/recipe/ghostmuffin
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/ectoplasm
	)
	fruit = list("berries" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/ghostmuffin/berry

/datum/recipe/poisonghostmuffin
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/ectoplasm
	)
	fruit = list("poisonberries" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/ghostmuffin/poison

/datum/recipe/eggroll
	reagents = list("soysauce" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/friedegg
	)
	fruit = list("cabbage" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/eggroll

/datum/recipe/fruitsalad
	fruit = list("orange" = 1, "apple" = 1, "grapes" = 1, "watermelon" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/fruitsalad

/datum/recipe/eggbowl
	reagents = list("water" = 5, "rice" = 10, "egg" = 3)
	result = /obj/item/weapon/reagent_containers/food/snacks/eggbowl

/datum/recipe/porkbowl
	reagents = list("water" = 5, "rice" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/porkbowl

/datum/recipe/microwavetortilla
	reagents = list("flour" = 5, "water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tortilla

/datum/recipe/meatburrito
	fruit = list("soybeans" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatburrito

/datum/recipe/cheeseburrito
	fruit = list("soybeans" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cheeseburrito

/datum/recipe/fuegoburrito
	fruit = list("soybeans" = 1, "chili" = 2)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fuegoburrito

/datum/recipe/nachos
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/nachos

/datum/recipe/cheesenachos
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cheesenachos

/datum/recipe/cubannachos
	fruit = list("chili" = 1)
	reagents = list("ketchup" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cubannachos

/datum/recipe/curryrice
	fruit = list("chili" = 1)
	reagents = list("rice" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/curryrice

/datum/recipe/piginblanket
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/piginblanket

/datum/recipe/bagelplain
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bagelplain

/datum/recipe/bagelsunflower
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/rawsunflower
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bagelsunflower

/datum/recipe/bagelcheese
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bagelcheese

/datum/recipe/bagelraisin
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/no_raisin
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bagelraisin

/datum/recipe/bagelpoppy
	fruit = list("poppy" = 1)
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bagelpoppy

/datum/recipe/bageleverything
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/fuel_assembly/supermatter
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bageleverything

/datum/recipe/bageltwo
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/device/soulstone
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bageltwo

/////////////////////////////////////////////////////////////
//Synnono Meme Foods
//
//Most recipes replace reagents with RECIPE_REAGENT_REPLACE
//to simplify the end product and balance the amount of reagents
//in some foods. Many require the space spice reagent/condiment
//to reduce the risk of future recipe conflicts.
/////////////////////////////////////////////////////////////


/datum/recipe/redcurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/redcurry

/datum/recipe/greencurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("chili" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/greencurry

/datum/recipe/yellowcurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("peanut" = 2, "potato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/yellowcurry

/datum/recipe/bearchili
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/bearchili

/datum/recipe/bearstew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list("water" = 10)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/bearstew

/datum/recipe/bibimbap
	fruit = list("carrot" = 1, "cabbage" = 1, "mushroom" = 1)
	reagents = list("rice" = 5, "spacespice" = 2)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/bibimbap

/datum/recipe/friedrice
	reagents = list("water" = 5, "rice" = 10, "soysauce" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/friedrice

/datum/recipe/lomein
	reagents = list("water" = 5, "soysauce" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spagetti
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/lomein

/datum/recipe/chickenfillet //Also just combinable, like burgers and hot dogs.
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/chickenkatsu,
		/obj/item/weapon/reagent_containers/food/snacks/bun
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chickenfillet
	
/datum/recipe/chickennoodlesoup
	fruit = list("carrot" = 1)
	reagents = list("water" = 10)
	items = list( /obj/item/weapon/reagent_containers/food/snacks/spagetti, /obj/item/weapon/reagent_containers/food/snacks/rawcutlet)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/chickennoodlesoup

/datum/recipe/chickennoodlesoup
	fruit = list("carrot" = 1)
	reagents = list("water" = 10)
	items = list( /obj/item/weapon/reagent_containers/food/snacks/spagetti, /obj/item/weapon/reagent_containers/food/snacks/rawcutlet)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/chickennoodlesoup

/datum/recipe/chilicheesefries
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/fries,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/hotchili
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/chilicheesefries

/datum/recipe/meatbun
	reagents = list("spacespice" = 1, "water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking
	result = /obj/item/weapon/reagent_containers/food/snacks/meatbun

/datum/recipe/custardbun
	reagents = list("spacespice" = 1, "water" = 5, "egg" = 3)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking
	result = /obj/item/weapon/reagent_containers/food/snacks/custardbun

/datum/recipe/chickenmomo
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
	reagents = list("spacespice" = 2, "water" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/doughslice
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/weapon/reagent_containers/food/snacks/veggiemomo

/datum/recipe/risotto
	reagents = list("wine" = 5, "rice" = 10, "spacespice" = 1)
	fruit = list("mushroom" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here
	result = /obj/item/weapon/reagent_containers/food/snacks/risotto

/datum/recipe/poachedegg
	reagents = list("spacespice" = 1, "sodiumchloride" = 1, "blackpepper" = 1, "water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/weapon/reagent_containers/food/snacks/poachedegg

/datum/recipe/honeytoast
	reagents = list("honey" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/honeytoast


/datum/recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatsteak,
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donerkebab


/datum/recipe/sashimi
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sashimi

/datum/recipe/nugget
	reagents = list("flour" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/nugget

// Chip update
/datum/recipe/tortila
	reagents = list("flour" = 5,"water" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/tortilla
	reagent_mix = RECIPE_REAGENT_REPLACE //no gross flour or water

/datum/recipe/taconew
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/taco

/datum/recipe/chips
	reagents = list("sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chipplate

/datum/recipe/nachos
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/chipplate,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chipplate/nachos

/datum/recipe/salsa
	fruit = list("chili" = 1, "tomato" = 1, "lime" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/dip/salsa
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/guac
	fruit = list("chili" = 1, "lime" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/dip/guac
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/cheesesauce
	fruit = list("chili" = 1, "tomato" = 1)
	reagents = list("spacespice" = 1, "blackpepper" = 1,"sodiumchloride" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/burrito
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/meatball
	)
	reagents = list("spacespice" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/burrito

/datum/recipe/burrito_vegan
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/tortilla,
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burrito_vegan

/datum/recipe/burrito_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/burrito
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burrito_spicy

/datum/recipe/burrito_cheese
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/burrito,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burrito_cheese

/datum/recipe/burrito_cheese_spicy
	fruit = list("chili" = 2)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/burrito,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burrito_cheese_spicy

/datum/recipe/burrito_hell
	fruit = list("chili" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/burrito_spicy
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burrito_hell
	reagent_mix = RECIPE_REAGENT_REPLACE //Already hot sauce

/datum/recipe/breakfast_wrap
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/tortilla,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/breakfast_wrap

/datum/recipe/burrito_mystery
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/burrito,
		/obj/item/weapon/reagent_containers/food/snacks/mysterysoup
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burrito_mystery

//Ligger food, and also bacon.

/datum/recipe/bacon
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bacon

/datum/recipe/chilied_eggs
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/hotchili,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chilied_eggs

/datum/recipe/red_sun_special
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sausage,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge

	)
	result = /obj/item/weapon/reagent_containers/food/snacks/red_sun_special

/datum/recipe/hatchling_suprise
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/poachedegg,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon

	)
	result = /obj/item/weapon/reagent_containers/food/snacks/hatchling_suprise

/datum/recipe/riztizkzi_sea
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	reagents = list("blood" = 15)
	result = /obj/item/weapon/reagent_containers/food/snacks/riztizkzi_sea

/datum/recipe/father_breakfast
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sausage,
		/obj/item/weapon/reagent_containers/food/snacks/omelette,
		/obj/item/weapon/reagent_containers/food/snacks/meatsteak
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/father_breakfast

/datum/recipe/stuffed_meatball
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list("cabbage" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/stuffed_meatball

/datum/recipe/egg_pancake
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/omelette
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/egg_pancake

/datum/recipe/grilled_carp
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	reagents = list("spacespice" = 1)
	fruit = list("cabbage" = 1, "lime" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/grilled_carp

/datum/recipe/bacon_stick
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bacon_stick

/datum/recipe/cheese_cracker
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spreads/butter,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list("spacespice" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/cheese_cracker
	result_quantity = 4

/datum/recipe/bacon_and_eggs
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/friedegg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bacon_and_eggs

/datum/recipe/ntmuffin
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/weapon/reagent_containers/food/snacks/sausage,
		/obj/item/weapon/reagent_containers/food/snacks/friedegg,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/nt_muffin

/datum/recipe/fish_taco
	fruit = list("chili" = 1, "lemon" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fish_taco

/datum/recipe/blt
	fruit = list("tomato" = 1, "cabbage" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/blt

/datum/recipe/onionrings
	fruit = list("onion" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/onionrings

/datum/recipe/berrymuffin
	reagents = list("milk" = 5, "sugar" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	fruit = list("berries" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/muffin

/datum/recipe/onionsoup
	fruit = list("onion" = 1)
	reagents = list("water" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/soup/onion

/datum/recipe/porkbowl
	reagents = list("water" = 5, "rice" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/porkbowl

/datum/recipe/sushi
	fruit = list("cabbage" = 1)
	reagents = list("rice" = 20)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/sushi

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

/datum/recipe/gigapuddi
	reagents = list("milk" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/gigapuddi

/datum/recipe/gigapuddi/happy
	reagents = list("milk" = 15, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/gigapuddi/happy

/datum/recipe/gigapuddi/anger
	reagents = list("milk" = 15, "sodiumchloride" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/gigapuddi/anger

/datum/recipe/buchedenoel
	fruit = list("berries" = 2)
	reagents = list("milk" = 5, "flour" = 15, "cream" = 10, "coco" = 5, "egg" = 6)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/buchedenoel

/datum/recipe/turkey
	fruit = list("carrot" = 2)
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/chicken,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/turkey

/datum/recipe/cinnamonbun
	reagents = list("sugar" = 15, "cream" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/cinnamonbun
	result_quantity = 4
