
// see code/datums/recipe.dm


/* No telebacon. just no...
/datum/recipe/telebacon
	items = list(
		/obj/item/food/meat,
		/obj/item/assembly/signaler
	)
	result = /obj/item/food/telebacon

I said no!
/datum/recipe/syntitelebacon
	items = list(
		/obj/item/food/meat/syntiflesh,
		/obj/item/assembly/signaler
	)
	result = /obj/item/food/telebacon
*/

/datum/recipe/friedegg
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/food/egg
	)
	result = /obj/item/food/friedegg

/datum/recipe/boiledegg
	reagents = list(REAGENT_ID_WATER = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/food/egg
	)
	result = /obj/item/food/boiledegg

/datum/recipe/devilledegg
	fruit = list(PLANT_CHILI = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, REAGENT_ID_MAYO = 5)
	items = list(
		/obj/item/food/egg,
		/obj/item/food/egg
	)
	result = /obj/item/food/devilledegg

/datum/recipe/donkpocket
	items = list(
		/obj/item/food/dough,
		/obj/item/food/meatball
	)
	result = /obj/item/food/donkpocket //SPECIAL
	wiki_flag = WIKI_SPOILER

/datum/recipe/donkpocket/proc/warm_up(var/obj/item/food/donkpocket/being_cooked)
	being_cooked.heat()

/datum/recipe/donkpocket/make_food(var/obj/container as obj)
	. = ..(container)
	for (var/obj/item/food/donkpocket/D in .)
		if (!D.warm)
			warm_up(D)

/datum/recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/food/donkpocket
	)
	result = /obj/item/food/donkpocket //SPECIAL

/datum/recipe/donkpocket/warm/make_food(var/obj/container)
	var/list/results = list()
	var/obj/item/food/donkpocket/D = locate(/obj/item/food/donkpocket) in container
	if(!D)
		return results
	if(!D.warm)
		warm_up(D)
	results.Add(D)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_FOOD_PREPARED, container, results)
	return results

/datum/recipe/muffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/food/dough,
	)
	result = /obj/item/food/muffin
	result_quantity = 2

/datum/recipe/eggplantparm
	fruit = list(PLANT_EGGPLANT = 1)
	items = list(
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
		)
	result = /obj/item/food/eggplantparm

/datum/recipe/soylenviridians
	fruit = list(PLANT_SOYBEAN = 1)
	reagents = list(REAGENT_ID_FLOUR = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/soylenviridians

/datum/recipe/soylentgreen
	reagents = list(REAGENT_ID_FLOUR = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/food/meat/human,
		/obj/item/food/meat/human
	)
	result = /obj/item/food/soylentgreen

/datum/recipe/berryclafoutis
	fruit = list(PLANT_BERRIES = 1)
	items = list(
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/berryclafoutis/berry

/datum/recipe/poisonberryclafoutis
	fruit = list(PLANT_POISONBERRIES = 1)
	items = list(
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/berryclafoutis/poison
	wiki_flag = WIKI_SPOILER

/datum/recipe/wingfangchu
	reagents = list(REAGENT_ID_SOYSAUCE = 5)
	items = list(
		/obj/item/food/xenomeat
	)
	result = /obj/item/food/wingfangchu

/datum/recipe/loadedbakedpotato
	fruit = list(PLANT_POTATO = 1)
	items = list(/obj/item/food/cheesewedge)
	result = /obj/item/food/loadedbakedpotato

/datum/recipe/microfries
	appliance = MICROWAVE
	items = list(
		/obj/item/food/rawsticks
	)
	result = /obj/item/food/microfries

/datum/recipe/bangersandmash
	items = list(
		/obj/item/food/mashedpotato,
		/obj/item/food/sausage,
	)
	result = /obj/item/food/bangersandmash

/datum/recipe/cheesymash
	items = list(
		/obj/item/food/mashedpotato,
		/obj/item/food/cheesewedge,
	)
	result = /obj/item/food/cheesymash

/datum/recipe/blackpudding
	reagents = list(REAGENT_ID_BLOOD = 5)
	items = list(
		/obj/item/food/sausage,
	)
	result = /obj/item/food/blackpudding

/datum/recipe/popcorn
	fruit = list(PLANT_CORN = 1)
	result = /obj/item/food/popcorn

/datum/recipe/fortunecookie
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/doughslice,
		/obj/item/paper,
	)
	result = /obj/item/food/fortunecookie

/datum/recipe/syntisteak
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(/obj/item/food/meat/syntiflesh)
	result = /obj/item/food/meatsteak

/datum/recipe/spacylibertyduff
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_VODKA = 5, REAGENT_ID_PSILOCYBIN = 5)
	result = /obj/item/food/spacylibertyduff

/datum/recipe/amanitajelly
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_VODKA = 5, REAGENT_ID_AMATOXIN = 5)
	result = /obj/item/food/amanitajelly

/datum/recipe/amanitajelly/make_food(var/obj/container as obj)
	. = ..(container)
	for(var/obj/item/food/amanitajelly/being_cooked in .)
		being_cooked.reagents.del_reagent(REAGENT_ID_AMATOXIN)

/datum/recipe/meatballsoup
	fruit = list(PLANT_CARROT = 1, PLANT_POTATO = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	items = list(/obj/item/food/meatball)
	result = /obj/item/food/meatballsoup

/datum/recipe/vegetablesoup
	fruit = list(PLANT_CARROT = 1, PLANT_POTATO = 1, PLANT_CORN = 1, PLANT_EGGPLANT = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	result = /obj/item/food/vegetablesoup

/datum/recipe/nettlesoup
	fruit = list(PLANT_NETTLE = 1, PLANT_POTATO = 1)
	reagents = list(REAGENT_ID_WATER = 10, REAGENT_ID_EGG = 3)
	result = /obj/item/food/nettlesoup

/datum/recipe/wishsoup
	reagents = list(REAGENT_ID_WATER = 20)
	result= /obj/item/food/wishsoup

/datum/recipe/hotchili
	fruit = list(PLANT_CHILI = 1, PLANT_TOMATO = 1)
	items = list(/obj/item/food/meat)
	result = /obj/item/food/hotchili

/datum/recipe/coldchili
	fruit = list(PLANT_ICECHILI = 1, PLANT_TOMATO = 1)
	items = list(/obj/item/food/meat)
	result = /obj/item/food/coldchili

/datum/recipe/fishandchips
	items = list(
		/obj/item/food/fries,
		/obj/item/food/carpmeat,
	)
	result = /obj/item/food/fishandchips

/datum/recipe/sandwich
	items = list(
		/obj/item/food/meatsteak,
		/obj/item/food/slice/bread,
		/obj/item/food/slice/bread,
		/obj/item/food/cheesewedge,
	)
	result = /obj/item/food/sandwich

/datum/recipe/peanutbutterjellysandwich
	reagents = list(REAGENT_ID_CHERRYJELLY = 5, REAGENT_ID_PEANUTBUTTER = 5)
	items = list(
		/obj/item/food/slice/bread,
		/obj/item/food/slice/bread
	)
	result = /obj/item/food/jellysandwich/peanutbutter

/datum/recipe/clubsandwich
	reagents = list(REAGENT_ID_MAYO = 5)
	items = list(
		/obj/item/food/slice/bread,
		/obj/item/food/slice/bread,
		/obj/item/food/meat/chicken,
		/obj/item/food/bacon,
		/obj/item/food/cheesewedge
	)
	fruit = list(PLANT_TOMATO = 1, PLANT_LETTUCE = 1)
	result = /obj/item/food/clubsandwich

/datum/recipe/tomatosoup
	fruit = list(PLANT_TOMATO = 2)
	reagents = list(REAGENT_ID_WATER = 10)
	result = /obj/item/food/tomatosoup

/datum/recipe/rofflewaffles
	reagents = list(REAGENT_ID_PSILOCYBIN = 5, REAGENT_ID_SUGAR = 10)
	items = list(
		/obj/item/food/dough,
		/obj/item/food/dough,
	)
	result = /obj/item/food/rofflewaffles
	result_quantity = 2

/datum/recipe/stew
	fruit = list(PLANT_POTATO = 1, PLANT_TOMATO = 1, PLANT_CARROT = 1, PLANT_EGGPLANT = 1, PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	items = list(/obj/item/food/meat)
	result = /obj/item/food/stew

/datum/recipe/slimetoast
	reagents = list(REAGENT_ID_SLIMEJELLY = 5)
	items = list(
		/obj/item/food/slice/bread,
	)
	result = /obj/item/food/jelliedtoast/slime

/datum/recipe/jelliedtoast
	reagents = list(REAGENT_ID_CHERRYJELLY = 5)
	items = list(
		/obj/item/food/slice/bread,
	)
	result = /obj/item/food/jelliedtoast/cherry

/datum/recipe/milosoup
	reagents = list(REAGENT_ID_WATER = 10)
	items = list(
		/obj/item/food/soydope,
		/obj/item/food/soydope,
		/obj/item/food/tofu,
		/obj/item/food/tofu,
	)
	result = /obj/item/food/milosoup

/datum/recipe/stewedsoymeat
	fruit = list(PLANT_CARROT = 1, PLANT_TOMATO = 1)
	items = list(
		/obj/item/food/soydope,
		/obj/item/food/soydope
	)
	result = /obj/item/food/stewedsoymeat

/datum/recipe/boiledspagetti
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/spagetti,
	)
	result = /obj/item/food/boiledspagetti

/datum/recipe/boiledrice
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_RICE = 10)
	result = /obj/item/food/boiledrice

/datum/recipe/ricepudding
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_RICE = 10)
	result = /obj/item/food/ricepudding

/datum/recipe/pastatomato
	fruit = list(PLANT_TOMATO = 2)
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(/obj/item/food/spagetti)
	result = /obj/item/food/pastatomato

/datum/recipe/meatballspagetti
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/spagetti,
		/obj/item/food/meatball,
		/obj/item/food/meatball,
	)
	result = /obj/item/food/meatballspagetti

/datum/recipe/spesslaw
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/spagetti,
		/obj/item/food/meatball,
		/obj/item/food/meatball,
		/obj/item/food/meatball,
		/obj/item/food/meatball,
	)
	result = /obj/item/food/spesslaw

/datum/recipe/candiedapple
	fruit = list(PLANT_APPLE = 1)
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_SUGAR = 5) //Makes sense seeing as how it's just syrup on the exterior
	result = /obj/item/food/candiedapple

/datum/recipe/caramelapple
	fruit = list(PLANT_APPLE = 1)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5) //Since caramel can be made with milk I thought this was appropriate
	result = /obj/item/food/caramelapple

/datum/recipe/twobread
	reagents = list(REAGENT_ID_REDWINE = 5)
	items = list(
		/obj/item/food/slice/bread,
		/obj/item/food/slice/bread,
	)
	result = /obj/item/food/twobread

/datum/recipe/slimesandwich
	reagents = list(REAGENT_ID_SLIMEJELLY = 5)
	items = list(
		/obj/item/food/slice/bread,
		/obj/item/food/slice/bread,
	)
	result = /obj/item/food/jellysandwich/slime

/datum/recipe/cherrysandwich
	reagents = list(REAGENT_ID_CHERRYJELLY = 5)
	items = list(
		/obj/item/food/slice/bread,
		/obj/item/food/slice/bread,
	)
	result = /obj/item/food/jellysandwich/cherry

/datum/recipe/bloodsoup
	reagents = list(REAGENT_ID_BLOOD = 30)
	result = /obj/item/food/bloodsoup

/datum/recipe/slimesoup
	reagents = list(REAGENT_ID_WATER = 10, REAGENT_ID_SLIMEJELLY = 5)
	items = list()
	result = /obj/item/food/slimesoup

/datum/recipe/boiledslimeextract
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/slime_extract,
	)
	result = /obj/item/food/boiledslimecore

/datum/recipe/chocolateegg
	items = list(
		/obj/item/food/egg,
		/obj/item/food/chocolatebar,
	)
	result = /obj/item/food/chocolateegg

/datum/recipe/sausage
	items = list(
		/obj/item/food/meatball,
		/obj/item/food/cutlet,
	)
	result = /obj/item/food/sausage
	result_quantity = 2

/datum/recipe/kudzudonburi
	fruit = list(PLANT_KUDZU = 1)
	reagents = list(REAGENT_ID_RICE = 10)
	items = list(
		/obj/item/food/carpmeat
	)
	result = /obj/item/food/kudzudonburi

/datum/recipe/mysterysoup
	reagents = list(REAGENT_ID_WATER = 10, REAGENT_ID_EGG = 3)
	items = list(
		/obj/item/food/badrecipe,
		/obj/item/food/tofu,
		/obj/item/food/cheesewedge,
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/mysterysoup

/datum/recipe/plumphelmetbiscuit
	fruit = list(PLANT_PLUMPHELMET = 1)
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_FLOUR = 5)
	result = /obj/item/food/plumphelmetbiscuit
	result_quantity = 2

/datum/recipe/mushroomsoup
	fruit = list(PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_MILK = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/mushroomsoup

/datum/recipe/chawanmushi
	fruit = list(PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_SOYSAUCE = 5, REAGENT_ID_EGG = 6)
	result = /obj/item/food/chawanmushi

/datum/recipe/beetsoup
	fruit = list(PLANT_WHITEBEET = 1, PLANT_CABBAGE = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	result = /obj/item/food/beetsoup

/datum/recipe/tossedsalad
	fruit = list(PLANT_LETTUCE = 2, PLANT_TOMATO = 1, PLANT_CARROT = 1, PLANT_APPLE = 1)
	result = /obj/item/food/tossedsalad

/datum/recipe/flowersalad
	fruit = list(PLANT_HAREBELLS = 1, PLANT_POPPIES = 1)
	items = list(
		/obj/item/food/roastedsunflower
	)
	result = /obj/item/food/flowerchildsalad

/datum/recipe/rosesalad
	fruit = list(PLANT_HAREBELLS = 1, PLANT_ROSE = 1)
	items = list(
		/obj/item/food/roastedsunflower
	)
	result = /obj/item/food/rosesalad

/datum/recipe/aesirsalad
	fruit = list(PLANT_GOLDAPPLE = 1, PLANT_AMBROSIADEUS = 1)
	result = /obj/item/food/aesirsalad

/datum/recipe/validsalad
	fruit = list(PLANT_POTATO = 1, PLANT_AMBROSIA = 3)
	items = list(/obj/item/food/meatball)
	result = /obj/item/food/validsalad

/datum/recipe/dankpocket
	fruit = list(PLANT_AMBROSIA = 2)
	items = list(
		/obj/item/food/meatball,
		/obj/item/food/doughslice
	)
	result = /obj/item/food/donkpocket/dankpocket
	wiki_flag = WIKI_SPOILER

/datum/recipe/validsalad/make_food(var/obj/container as obj)
	. = ..(container)
	for (var/obj/item/food/validsalad/being_cooked in .)
		being_cooked.reagents.del_reagent(REAGENT_ID_TOXIN)

/datum/recipe/stuffing
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/food/sliceable/bread,
	)
	result = /obj/item/food/stuffing
	result_quantity = 2

/datum/recipe/mashedpotato
	items = list(
		/obj/item/food/spreads
	)
	fruit = list(PLANT_POTATO = 1)
	result = /obj/item/food/mashedpotato

/datum/recipe/icecreamsandwich
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_ICE = 5)
	items = list(
		/obj/item/food/icecream
	)
	result = /obj/item/food/icecreamsandwich

/datum/recipe/onionsoup
	fruit = list(PLANT_ONION = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	result = /obj/item/food/soup/onion

/datum/recipe/microwavebun
	items = list(
		/obj/item/food/dough
	)
	result = /obj/item/food/bun
	result_quantity = 3

/datum/recipe/microwaveflatbread
	items = list(
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/flatbread

/datum/recipe/meatball
	items = list(
		/obj/item/food/rawmeatball
	)
	result = /obj/item/food/meatball

/datum/recipe/cutlet
	items = list(
		/obj/item/food/rawcutlet
	)
	result = /obj/item/food/cutlet

/datum/recipe/roastedcornsunflowerseeds
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_CORNOIL = 1)
	items = list(
		/obj/item/food/rawsunflower
	)
	result = /obj/item/food/roastedsunflower
	result_quantity = 2
	wiki_flag = WIKI_SPOILER // Other recipies are other oils

/datum/recipe/roastedsunflowerseeds
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_COOKINGOIL = 1)
	items = list(
		/obj/item/food/rawsunflower
	)
	result = /obj/item/food/roastedsunflower
	result_quantity = 2

/datum/recipe/roastedpeanutsunflowerseeds
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_PEANUTOIL = 1)
	items = list(
		/obj/item/food/rawsunflower
	)
	result = /obj/item/food/roastedsunflower
	result_quantity = 2
	wiki_flag = WIKI_SPOILER // Other recipies are other oils

/datum/recipe/roastedpeanuts
	fruit = list(PLANT_PEANUT = 2)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, REAGENT_ID_COOKINGOIL = 1)
	result = /obj/item/food/roastedpeanuts
	result_quantity = 2

/datum/recipe/roastedpeanutscorn
	fruit = list(PLANT_PEANUT = 2)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, REAGENT_ID_CORNOIL = 1)
	result = /obj/item/food/roastedpeanuts
	result_quantity = 2
	wiki_flag = WIKI_SPOILER // other recipies are just other oils

/datum/recipe/roastedpeanutspeanut
	fruit = list(PLANT_PEANUT = 2)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, REAGENT_ID_PEANUTOIL = 1)
	result = /obj/item/food/roastedpeanuts
	result_quantity = 2
	wiki_flag = WIKI_SPOILER // other recipies are just other oils

/datum/recipe/mint
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_FROSTOIL = 5)
	result = /obj/item/food/mint

/datum/recipe/sashimi
	reagents = list(REAGENT_ID_SOYSAUCE = 5)
	items = list(
		/obj/item/food/carpmeat
	)
	result = /obj/item/food/sashimi

/datum/recipe/benedict
	items = list(
		/obj/item/food/cutlet,
		/obj/item/food/friedegg,
		/obj/item/food/slice/bread
	)
	result = /obj/item/food/benedict

/datum/recipe/bakedbeans
	fruit = list(PLANT_SOYBEAN = 2)
	reagents = list(REAGENT_ID_KETCHUP = 5)
	result = /obj/item/food/beans

/datum/recipe/sugarcookie
	items = list(
		/obj/item/food/dough
	)
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3)
	result = /obj/item/food/sugarcookie
	result_quantity = 4

/datum/recipe/berrymuffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/dough
	)
	fruit = list(PLANT_BERRIES = 1)
	result = /obj/item/food/berrymuffin/berry
	result_quantity = 2

/datum/recipe/poisonberrymuffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/dough
	)
	fruit = list(PLANT_POISONBERRIES = 1)
	result = /obj/item/food/berrymuffin/poison
	result_quantity = 2
	wiki_flag = WIKI_SPOILER

/datum/recipe/ghostmuffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/dough,
		/obj/item/ectoplasm
	)
	fruit = list(PLANT_BERRIES = 1)
	result = /obj/item/food/ghostmuffin/berry
	result_quantity = 2

/datum/recipe/poisonghostmuffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/dough,
		/obj/item/ectoplasm
	)
	fruit = list(PLANT_POISONBERRIES = 1)
	result = /obj/item/food/ghostmuffin/poison
	result_quantity = 2
	wiki_flag = WIKI_SPOILER

/datum/recipe/eggroll
	reagents = list(REAGENT_ID_SOYSAUCE = 10)
	items = list(
		/obj/item/food/friedegg
	)
	fruit = list(PLANT_CABBAGE = 1)
	result = /obj/item/food/eggroll

/datum/recipe/fruitsalad
	fruit = list(PLANT_ORANGE = 1, PLANT_APPLE = 1, PLANT_GRAPES = 1, PLANT_WATERMELON = 1)
	result = /obj/item/food/fruitsalad

/datum/recipe/eggbowl
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_RICE = 10, REAGENT_ID_EGG = 3)
	result = /obj/item/food/eggbowl

/datum/recipe/porkbowl
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_RICE = 10)
	items = list(
		/obj/item/food/cutlet
	)
	result = /obj/item/food/porkbowl

/datum/recipe/cubannachos
	fruit = list(PLANT_CHILI = 1)
	reagents = list(REAGENT_ID_KETCHUP = 5)
	items = list(
		/obj/item/food/tortilla
	)
	result = /obj/item/food/cubannachos

/datum/recipe/curryrice
	fruit = list(PLANT_CHILI = 1)
	reagents = list(REAGENT_ID_RICE = 10)
	result = /obj/item/food/curryrice

/datum/recipe/piginblanket
	items = list(
		/obj/item/food/doughslice,
		/obj/item/food/sausage
	)
	result = /obj/item/food/piginblanket

/datum/recipe/bagelplain
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/bun
	)
	result = /obj/item/food/bagelplain

/datum/recipe/bagelsunflower
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/bun,
		/obj/item/food/rawsunflower
	)
	result = /obj/item/food/bagelsunflower

/datum/recipe/bagelcheese
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/bun,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/bagelcheese

/datum/recipe/bagelraisin
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/bun,
		/obj/item/food/no_raisin
	)
	result = /obj/item/food/bagelraisin

/datum/recipe/bagelpoppy
	fruit = list(PLANT_POPPIES = 1)
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/bun
	)
	result = /obj/item/food/bagelpoppy

/datum/recipe/bageleverything
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/bun,
		/obj/item/fuel_assembly/supermatter
	)
	result = /obj/item/food/bageleverything

/datum/recipe/bageltwo
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/bun,
		/obj/item/soulstone
	)
	result = /obj/item/food/bageltwo

//Recipes that use RECIPE_REAGENT_REPLACE will
//simplify the end product and balance the amount of reagents
//in some foods. Many require the space spice reagent/condiment
//to reduce the risk of future recipe conflicts.

/datum/recipe/redcurry
	reagents = list(REAGENT_ID_CREAM = 5, REAGENT_ID_SPACESPICE = 2, REAGENT_ID_RICE = 5)
	items = list(
		/obj/item/food/cutlet,
		/obj/item/food/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/redcurry

/datum/recipe/greencurry
	reagents = list(REAGENT_ID_CREAM = 5, REAGENT_ID_SPACESPICE = 2, REAGENT_ID_RICE = 5)
	fruit = list(PLANT_CHILI = 1)
	items = list(
		/obj/item/food/tofu,
		/obj/item/food/tofu
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/greencurry

/datum/recipe/yellowcurry
	reagents = list(REAGENT_ID_CREAM = 5, REAGENT_ID_SPACESPICE = 2, REAGENT_ID_RICE = 5)
	fruit = list(PLANT_PEANUT = 2, PLANT_POTATO = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/yellowcurry

/datum/recipe/bearchili
	fruit = list(PLANT_CHILI = 1, PLANT_TOMATO = 1)
	items = list(/obj/item/food/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/bearchili

/datum/recipe/bearstew
	fruit = list(PLANT_POTATO = 1, PLANT_TOMATO = 1, PLANT_CARROT = 1, PLANT_EGGPLANT = 1, PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	items = list(/obj/item/food/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/bearstew

/datum/recipe/bibimbap
	fruit = list(PLANT_CARROT = 1, PLANT_CABBAGE = 1, PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_RICE = 5, REAGENT_ID_SPACESPICE = 2)
	items = list(
		/obj/item/food/egg,
		/obj/item/food/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/bibimbap

/datum/recipe/friedrice
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_RICE = 10, REAGENT_ID_SOYSAUCE = 5)
	fruit = list(PLANT_CARROT = 1, PLANT_CABBAGE = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/friedrice

/datum/recipe/lomein
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_SOYSAUCE = 5)
	fruit = list(PLANT_CARROT = 1, PLANT_CABBAGE = 1)
	items = list(
		/obj/item/food/spagetti
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/lomein

/datum/recipe/chickennoodlesoup
	fruit = list(PLANT_CARROT = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	items = list( /obj/item/food/spagetti, /obj/item/food/rawcutlet)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/chickennoodlesoup

/datum/recipe/chilicheesefries
	items = list(
		/obj/item/food/fries,
		/obj/item/food/cheesewedge,
		/obj/item/food/hotchili
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/chilicheesefries

/datum/recipe/risotto
	reagents = list(REAGENT_ID_REDWINE = 5, REAGENT_ID_RICE = 10, REAGENT_ID_SPACESPICE = 1)
	fruit = list(PLANT_MUSHROOMS = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here
	result = /obj/item/food/risotto

/datum/recipe/poachedegg
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1, REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/egg
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/food/poachedegg

/datum/recipe/nugget
	reagents = list(REAGENT_ID_FLOUR = 5)
	items = list(
		/obj/item/food/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/nugget
	result_quantity = 3

// Chip update
/datum/recipe/microwavetortilla
	reagents = list(REAGENT_ID_FLOUR = 5, REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/food/sliceable/flatdough
	)
	result = /obj/item/food/tortilla
	reagent_mix = RECIPE_REAGENT_REPLACE //no gross flour or water
	result_quantity = 3

/datum/recipe/taco
	items = list(
		/obj/item/food/tortilla,
		/obj/item/food/cutlet,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/taco

/datum/recipe/chips
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/food/tortilla
	)
	result = /obj/item/food/chipplate

/datum/recipe/nachos
	items = list(
		/obj/item/food/chipplate,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/chipplate/nachos

/datum/recipe/salsa
	fruit = list(PLANT_CHILI = 1, PLANT_TOMATO = 1, PLANT_LIME = 1)
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_BLACKPEPPER = 1,REAGENT_ID_SODIUMCHLORIDE = 1)
	result = /obj/item/food/dip/salsa
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/guac
	fruit = list(PLANT_CHILI = 1, PLANT_LIME = 1)
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_BLACKPEPPER = 1,REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/food/tofu
	)
	result = /obj/item/food/dip/guac
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/cheesesauce
	fruit = list(PLANT_CHILI = 1, PLANT_TOMATO = 1)
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_BLACKPEPPER = 1,REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/burrito
	items = list(
		/obj/item/food/tortilla,
		/obj/item/food/meatball,
		/obj/item/food/meatball
	)
	reagents = list(REAGENT_ID_SPACESPICE = 1)
	result = /obj/item/food/burrito

/datum/recipe/burrito_vegan
	items = list(
		/obj/item/food/tortilla,
		/obj/item/food/tofu
	)
	result = /obj/item/food/burrito_vegan

/datum/recipe/burrito_cheese
	items = list(
		/obj/item/food/tortilla,
		/obj/item/food/meatball,
		/obj/item/food/meatball,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/burrito_cheese

/datum/recipe/burrito_cheese_spicy
	fruit = list(PLANT_CHILI = 2, PLANT_SOYBEAN = 1)
	items = list(
		/obj/item/food/tortilla,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge,
	)
	result = /obj/item/food/burrito_cheese_spicy

/datum/recipe/burrito_hell
	fruit = list(PLANT_SOYBEAN = 1, PLANT_CHILI = 10)
	reagents = list(REAGENT_ID_SPACESPICE = 1)
	items = list(
		/obj/item/food/tortilla,
		/obj/item/food/meatball,
		/obj/item/food/meatball
	)
	result = /obj/item/food/burrito_hell
	reagent_mix = RECIPE_REAGENT_REPLACE //Already hot sauce

/datum/recipe/meatburrito
	fruit = list(PLANT_SOYBEAN = 1)
	items = list(
		/obj/item/food/tortilla,
		/obj/item/food/cutlet,
		/obj/item/food/cutlet
	)
	result = /obj/item/food/meatburrito

/datum/recipe/cheeseburrito
	fruit = list(PLANT_SOYBEAN = 1)
	items = list(
		/obj/item/food/tortilla,
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/cheeseburrito

/datum/recipe/fuegoburrito
	fruit = list(PLANT_SOYBEAN = 1, PLANT_CHILI = 2)
	items = list(
		/obj/item/food/tortilla
	)
	result = /obj/item/food/fuegoburrito

/datum/recipe/breakfast_wrap
	items = list(
		/obj/item/food/bacon,
		/obj/item/food/tortilla,
		/obj/item/food/cheesewedge,
		/obj/item/food/egg
	)
	result = /obj/item/food/breakfast_wrap

/datum/recipe/burrito_mystery
	items = list(
		/obj/item/food/tortilla,
		/obj/item/food/mysterysoup
	)
	result = /obj/item/food/burrito_mystery

/datum/recipe/baconmicrowave
	items = list(
		/obj/item/food/rawbacon
	)
	result = /obj/item/food/bacon/microwave

/datum/recipe/chilied_eggs
	items = list(
		/obj/item/food/hotchili,
		/obj/item/food/boiledegg,
		/obj/item/food/boiledegg,
		/obj/item/food/boiledegg
	)
	result = /obj/item/food/chilied_eggs

/datum/recipe/red_sun_special
	items = list(
		/obj/item/food/sausage,
		/obj/item/food/cheesewedge

	)
	result = /obj/item/food/red_sun_special

/datum/recipe/hatchling_suprise
	items = list(
		/obj/item/food/poachedegg,
		/obj/item/food/bacon,
		/obj/item/food/bacon,
		/obj/item/food/bacon

	)
	result = /obj/item/food/hatchling_suprise

/datum/recipe/riztizkzi_sea
	items = list(
		/obj/item/food/egg,
		/obj/item/food/egg,
		/obj/item/food/egg
	)
	reagents = list(REAGENT_ID_BLOOD = 15)
	result = /obj/item/food/riztizkzi_sea

/datum/recipe/father_breakfast
	items = list(
		/obj/item/food/sausage,
		/obj/item/food/meatsteak
	)
	reagents = list(REAGENT_ID_EGG = 6)
	result = /obj/item/food/father_breakfast

/datum/recipe/stuffed_meatball
	items = list(
		/obj/item/food/meatball,
		/obj/item/food/cheesewedge
	)
	fruit = list(PLANT_CABBAGE = 1)
	result = /obj/item/food/stuffed_meatball
	result_quantity = 2

/datum/recipe/egg_pancake
	items = list(
		/obj/item/food/meatball,
		/obj/item/food/meatball,
		/obj/item/food/meatball
	)
	reagents = list(REAGENT_ID_EGG = 6)
	result = /obj/item/food/egg_pancake

/datum/recipe/bacon_stick
	items = list(
		/obj/item/food/bacon,
		/obj/item/food/boiledegg
	)
	result = /obj/item/food/bacon_stick

/datum/recipe/bacon_and_eggs
	items = list(
		/obj/item/food/bacon,
		/obj/item/food/friedegg
	)
	result = /obj/item/food/bacon_and_eggs

/datum/recipe/ntmuffin
	items = list(
		/obj/item/food/plumphelmetbiscuit,
		/obj/item/food/sausage,
		/obj/item/food/friedegg,
		/obj/item/food/cheesewedge
	)
	result = /obj/item/food/nt_muffin

/datum/recipe/fish_taco
	fruit = list(PLANT_CHILI = 1, PLANT_LEMON = 1)
	items = list(
		/obj/item/food/carpmeat,
		/obj/item/food/tortilla
	)
	result = /obj/item/food/fish_taco

/datum/recipe/blt
	fruit = list(PLANT_TOMATO = 1, PLANT_LETTUCE = 1)
	items = list(
		/obj/item/food/slice/bread,
		/obj/item/food/slice/bread,
		/obj/item/food/bacon,
		/obj/item/food/bacon
	)
	result = /obj/item/food/blt

/datum/recipe/gigapuddi
	reagents = list(REAGENT_ID_MILK = 15)
	items = list(
		/obj/item/food/egg,
		/obj/item/food/egg
		)
	result = /obj/item/food/gigapuddi

/datum/recipe/gigapuddi/happy
	reagents = list(REAGENT_ID_MILK = 15, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/food/egg,
		/obj/item/food/egg
		)
	result = /obj/item/food/gigapuddi/happy

/datum/recipe/gigapuddi/anger
	reagents = list(REAGENT_ID_MILK = 15, REAGENT_ID_SODIUMCHLORIDE = 5)
	items = list(
		/obj/item/food/egg,
		/obj/item/food/egg
		)
	result = /obj/item/food/gigapuddi/anger
