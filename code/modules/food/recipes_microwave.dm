
// see code/datums/recipe.dm


/* No telebacon. just no...
/datum/recipe/telebacon
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/assembly/signaler
	)
	result = /obj/item/reagent_containers/food/snacks/telebacon

I said no!
/datum/recipe/syntitelebacon
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/assembly/signaler
	)
	result = /obj/item/reagent_containers/food/snacks/telebacon
*/

/datum/recipe/friedegg
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg

/datum/recipe/boiledegg
	reagents = list(REAGENT_ID_WATER = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/boiledegg

/datum/recipe/devilledegg
	fruit = list(PLANT_CHILI = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, REAGENT_ID_MAYO = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/devilledegg

/datum/recipe/donkpocket
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //SPECIAL
	wiki_flag = WIKI_SPOILER

/datum/recipe/donkpocket/proc/warm_up(var/obj/item/reagent_containers/food/snacks/donkpocket/being_cooked)
	being_cooked.heat()

/datum/recipe/donkpocket/make_food(var/obj/container as obj)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/donkpocket/D in .)
		if (!D.warm)
			warm_up(D)

/datum/recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //SPECIAL

/datum/recipe/muffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/reagent_containers/food/snacks/muffin
	result_quantity = 2

/datum/recipe/eggplantparm
	fruit = list(PLANT_EGGPLANT = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
		)
	result = /obj/item/reagent_containers/food/snacks/eggplantparm

/datum/recipe/soylenviridians
	fruit = list(PLANT_SOYBEAN = 1)
	reagents = list(REAGENT_ID_FLOUR = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soylenviridians

/datum/recipe/soylentgreen
	reagents = list(REAGENT_ID_FLOUR = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human
	)
	result = /obj/item/reagent_containers/food/snacks/soylentgreen

/datum/recipe/berryclafoutis
	fruit = list(PLANT_BERRIES = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis/berry

/datum/recipe/poisonberryclafoutis
	fruit = list(PLANT_POISONBERRIES = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis/poison
	wiki_flag = WIKI_SPOILER

/datum/recipe/wingfangchu
	reagents = list(REAGENT_ID_SOYSAUCE = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/wingfangchu

/datum/recipe/loadedbakedpotato
	fruit = list(PLANT_POTATO = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

/datum/recipe/microfries
	appliance = MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/microfries

/datum/recipe/bangersandmash
	items = list(
		/obj/item/reagent_containers/food/snacks/mashedpotato,
		/obj/item/reagent_containers/food/snacks/sausage,
	)
	result = /obj/item/reagent_containers/food/snacks/bangersandmash

/datum/recipe/cheesymash
	items = list(
		/obj/item/reagent_containers/food/snacks/mashedpotato,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/cheesymash

/datum/recipe/blackpudding
	reagents = list(REAGENT_ID_BLOOD = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
	)
	result = /obj/item/reagent_containers/food/snacks/blackpudding

/datum/recipe/popcorn
	fruit = list(PLANT_CORN = 1)
	result = /obj/item/reagent_containers/food/snacks/popcorn

/datum/recipe/fortunecookie
	reagents = list(REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper,
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie

/datum/recipe/syntisteak
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat/syntiflesh)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/datum/recipe/spacylibertyduff
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_VODKA = 5, REAGENT_ID_PSILOCYBIN = 5)
	result = /obj/item/reagent_containers/food/snacks/spacylibertyduff

/datum/recipe/amanitajelly
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_VODKA = 5, REAGENT_ID_AMATOXIN = 5)
	result = /obj/item/reagent_containers/food/snacks/amanitajelly

/datum/recipe/amanitajelly/make_food(var/obj/container as obj)
	. = ..(container)
	for(var/obj/item/reagent_containers/food/snacks/amanitajelly/being_cooked in .)
		being_cooked.reagents.del_reagent(REAGENT_ID_AMATOXIN)

/datum/recipe/meatballsoup
	fruit = list(PLANT_CARROT = 1, PLANT_POTATO = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/meatballsoup

/datum/recipe/vegetablesoup
	fruit = list(PLANT_CARROT = 1, PLANT_POTATO = 1, PLANT_CORN = 1, PLANT_EGGPLANT = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	result = /obj/item/reagent_containers/food/snacks/vegetablesoup

/datum/recipe/nettlesoup
	fruit = list(PLANT_NETTLE = 1, PLANT_POTATO = 1)
	reagents = list(REAGENT_ID_WATER = 10, REAGENT_ID_EGG = 3)
	result = /obj/item/reagent_containers/food/snacks/nettlesoup

/datum/recipe/wishsoup
	reagents = list(REAGENT_ID_WATER = 20)
	result= /obj/item/reagent_containers/food/snacks/wishsoup

/datum/recipe/hotchili
	fruit = list(PLANT_CHILI = 1, PLANT_TOMATO = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/hotchili

/datum/recipe/coldchili
	fruit = list(PLANT_ICECHILI = 1, PLANT_TOMATO = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/coldchili

/datum/recipe/fishandchips
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/carpmeat,
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips

/datum/recipe/sandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/sandwich

/datum/recipe/peanutbutterjellysandwich
	reagents = list(REAGENT_ID_CHERRYJELLY = 5, REAGENT_ID_PEANUTBUTTER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/peanutbutter

/datum/recipe/clubsandwich
	reagents = list(REAGENT_ID_MAYO = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/meat/chicken,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list(PLANT_TOMATO = 1, PLANT_LETTUCE = 1)
	result = /obj/item/reagent_containers/food/snacks/clubsandwich

/datum/recipe/tomatosoup
	fruit = list(PLANT_TOMATO = 2)
	reagents = list(REAGENT_ID_WATER = 10)
	result = /obj/item/reagent_containers/food/snacks/tomatosoup

/datum/recipe/rofflewaffles
	reagents = list(REAGENT_ID_PSILOCYBIN = 5, REAGENT_ID_SUGAR = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/reagent_containers/food/snacks/rofflewaffles
	result_quantity = 2

/datum/recipe/stew
	fruit = list(PLANT_POTATO = 1, PLANT_TOMATO = 1, PLANT_CARROT = 1, PLANT_EGGPLANT = 1, PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/stew

/datum/recipe/slimetoast
	reagents = list(REAGENT_ID_SLIMEJELLY = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime

/datum/recipe/jelliedtoast
	reagents = list(REAGENT_ID_CHERRYJELLY = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry

/datum/recipe/milosoup
	reagents = list(REAGENT_ID_WATER = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/reagent_containers/food/snacks/milosoup

/datum/recipe/stewedsoymeat
	fruit = list(PLANT_CARROT = 1, PLANT_TOMATO = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat

/datum/recipe/boiledspagetti
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
	)
	result = /obj/item/reagent_containers/food/snacks/boiledspagetti

/datum/recipe/boiledrice
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_RICE = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledrice

/datum/recipe/ricepudding
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_RICE = 10)
	result = /obj/item/reagent_containers/food/snacks/ricepudding

/datum/recipe/pastatomato
	fruit = list(PLANT_TOMATO = 2)
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(/obj/item/reagent_containers/food/snacks/spagetti)
	result = /obj/item/reagent_containers/food/snacks/pastatomato

/datum/recipe/meatballspagetti
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
	)
	result = /obj/item/reagent_containers/food/snacks/meatballspagetti

/datum/recipe/spesslaw
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
	)
	result = /obj/item/reagent_containers/food/snacks/spesslaw

/datum/recipe/candiedapple
	fruit = list(PLANT_APPLE = 1)
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_SUGAR = 5) //Makes sense seeing as how it's just syrup on the exterior
	result = /obj/item/reagent_containers/food/snacks/candiedapple

/datum/recipe/caramelapple
	fruit = list(PLANT_APPLE = 1)
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5) //Since caramel can be made with milk I thought this was appropriate
	result = /obj/item/reagent_containers/food/snacks/caramelapple

/datum/recipe/twobread
	reagents = list(REAGENT_ID_REDWINE = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/reagent_containers/food/snacks/twobread

/datum/recipe/slimesandwich
	reagents = list(REAGENT_ID_SLIMEJELLY = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/slime

/datum/recipe/cherrysandwich
	reagents = list(REAGENT_ID_CHERRYJELLY = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
	)
	result = /obj/item/reagent_containers/food/snacks/jellysandwich/cherry

/datum/recipe/bloodsoup
	reagents = list(REAGENT_ID_BLOOD = 30)
	result = /obj/item/reagent_containers/food/snacks/bloodsoup

/datum/recipe/slimesoup
	reagents = list(REAGENT_ID_WATER = 10, REAGENT_ID_SLIMEJELLY = 5)
	items = list()
	result = /obj/item/reagent_containers/food/snacks/slimesoup

/datum/recipe/boiledslimeextract
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/slime_extract,
	)
	result = /obj/item/reagent_containers/food/snacks/boiledslimecore

/datum/recipe/chocolateegg
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar,
	)
	result = /obj/item/reagent_containers/food/snacks/chocolateegg

/datum/recipe/sausage
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cutlet,
	)
	result = /obj/item/reagent_containers/food/snacks/sausage
	result_quantity = 2

/datum/recipe/kudzudonburi
	fruit = list(PLANT_KUDZU = 1)
	reagents = list(REAGENT_ID_RICE = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/kudzudonburi

/datum/recipe/mysterysoup
	reagents = list(REAGENT_ID_WATER = 10, REAGENT_ID_EGG = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/mysterysoup

/datum/recipe/plumphelmetbiscuit
	fruit = list(PLANT_PLUMPHELMET = 1)
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_FLOUR = 5)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	result_quantity = 2

/datum/recipe/mushroomsoup
	fruit = list(PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_MILK = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/mushroomsoup

/datum/recipe/chawanmushi
	fruit = list(PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_SOYSAUCE = 5, REAGENT_ID_EGG = 6)
	result = /obj/item/reagent_containers/food/snacks/chawanmushi

/datum/recipe/beetsoup
	fruit = list(PLANT_WHITEBEET = 1, PLANT_CABBAGE = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	result = /obj/item/reagent_containers/food/snacks/beetsoup

/datum/recipe/tossedsalad
	fruit = list(PLANT_LETTUCE = 2, PLANT_TOMATO = 1, PLANT_CARROT = 1, PLANT_APPLE = 1)
	result = /obj/item/reagent_containers/food/snacks/tossedsalad

/datum/recipe/flowersalad
	fruit = list(PLANT_HAREBELLS = 1, PLANT_POPPIES = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/roastedsunflower
	)
	result = /obj/item/reagent_containers/food/snacks/flowerchildsalad

/datum/recipe/rosesalad
	fruit = list(PLANT_HAREBELLS = 1, PLANT_ROSE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/roastedsunflower
	)
	result = /obj/item/reagent_containers/food/snacks/rosesalad

/datum/recipe/aesirsalad
	fruit = list(PLANT_GOLDAPPLE = 1, PLANT_AMBROSIADEUS = 1)
	result = /obj/item/reagent_containers/food/snacks/aesirsalad

/datum/recipe/validsalad
	fruit = list(PLANT_POTATO = 1, PLANT_AMBROSIA = 3)
	items = list(/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/validsalad

/datum/recipe/dankpocket
	fruit = list(PLANT_AMBROSIA = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket/dankpocket
	wiki_flag = WIKI_SPOILER

/datum/recipe/validsalad/make_food(var/obj/container as obj)
	. = ..(container)
	for (var/obj/item/reagent_containers/food/snacks/validsalad/being_cooked in .)
		being_cooked.reagents.del_reagent(REAGENT_ID_TOXIN)

/datum/recipe/stuffing
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/bread,
	)
	result = /obj/item/reagent_containers/food/snacks/stuffing
	result_quantity = 2

/datum/recipe/mashedpotato
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads
	)
	fruit = list(PLANT_POTATO = 1)
	result = /obj/item/reagent_containers/food/snacks/mashedpotato

/datum/recipe/icecreamsandwich
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_ICE = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/icecream
	)
	result = /obj/item/reagent_containers/food/snacks/icecreamsandwich

/datum/recipe/onionsoup
	fruit = list(PLANT_ONION = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/onion

/datum/recipe/microwavebun
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/bun
	result_quantity = 3

/datum/recipe/microwaveflatbread
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/flatbread

/datum/recipe/meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball
	)
	result = /obj/item/reagent_containers/food/snacks/meatball

/datum/recipe/cutlet
	items = list(
		/obj/item/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/reagent_containers/food/snacks/cutlet

/datum/recipe/roastedcornsunflowerseeds
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_CORNOIL = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsunflower
	)
	result = /obj/item/reagent_containers/food/snacks/roastedsunflower
	result_quantity = 2
	wiki_flag = WIKI_SPOILER // Other recipies are other oils

/datum/recipe/roastedsunflowerseeds
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_COOKINGOIL = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsunflower
	)
	result = /obj/item/reagent_containers/food/snacks/roastedsunflower
	result_quantity = 2

/datum/recipe/roastedpeanutsunflowerseeds
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_PEANUTOIL = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsunflower
	)
	result = /obj/item/reagent_containers/food/snacks/roastedsunflower
	result_quantity = 2
	wiki_flag = WIKI_SPOILER // Other recipies are other oils

/datum/recipe/roastedpeanuts
	fruit = list(PLANT_PEANUT = 2)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, REAGENT_ID_COOKINGOIL = 1)
	result = /obj/item/reagent_containers/food/snacks/roastedpeanuts
	result_quantity = 2

/datum/recipe/roastedpeanutscorn
	fruit = list(PLANT_PEANUT = 2)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, REAGENT_ID_CORNOIL = 1)
	result = /obj/item/reagent_containers/food/snacks/roastedpeanuts
	result_quantity = 2
	wiki_flag = WIKI_SPOILER // other recipies are just other oils

/datum/recipe/roastedpeanutspeanut
	fruit = list(PLANT_PEANUT = 2)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 2, REAGENT_ID_PEANUTOIL = 1)
	result = /obj/item/reagent_containers/food/snacks/roastedpeanuts
	result_quantity = 2
	wiki_flag = WIKI_SPOILER // other recipies are just other oils

/datum/recipe/mint
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_FROSTOIL = 5)
	result = /obj/item/reagent_containers/food/snacks/mint

/datum/recipe/sashimi
	reagents = list(REAGENT_ID_SOYSAUCE = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/sashimi

/datum/recipe/benedict
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	result = /obj/item/reagent_containers/food/snacks/benedict

/datum/recipe/bakedbeans
	fruit = list(PLANT_SOYBEAN = 2)
	reagents = list(REAGENT_ID_KETCHUP = 5)
	result = /obj/item/reagent_containers/food/snacks/beans

/datum/recipe/sugarcookie
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	reagents = list(REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3)
	result = /obj/item/reagent_containers/food/snacks/sugarcookie
	result_quantity = 4

/datum/recipe/berrymuffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	fruit = list(PLANT_BERRIES = 1)
	result = /obj/item/reagent_containers/food/snacks/berrymuffin/berry
	result_quantity = 2

/datum/recipe/poisonberrymuffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	fruit = list(PLANT_POISONBERRIES = 1)
	result = /obj/item/reagent_containers/food/snacks/berrymuffin/poison
	result_quantity = 2
	wiki_flag = WIKI_SPOILER

/datum/recipe/ghostmuffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/ectoplasm
	)
	fruit = list(PLANT_BERRIES = 1)
	result = /obj/item/reagent_containers/food/snacks/ghostmuffin/berry
	result_quantity = 2

/datum/recipe/poisonghostmuffin
	reagents = list(REAGENT_ID_MILK = 5, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/ectoplasm
	)
	fruit = list(PLANT_POISONBERRIES = 1)
	result = /obj/item/reagent_containers/food/snacks/ghostmuffin/poison
	result_quantity = 2
	wiki_flag = WIKI_SPOILER

/datum/recipe/eggroll
	reagents = list(REAGENT_ID_SOYSAUCE = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	fruit = list(PLANT_CABBAGE = 1)
	result = /obj/item/reagent_containers/food/snacks/eggroll

/datum/recipe/fruitsalad
	fruit = list(PLANT_ORANGE = 1, PLANT_APPLE = 1, PLANT_GRAPES = 1, PLANT_WATERMELON = 1)
	result = /obj/item/reagent_containers/food/snacks/fruitsalad

/datum/recipe/eggbowl
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_RICE = 10, REAGENT_ID_EGG = 3)
	result = /obj/item/reagent_containers/food/snacks/eggbowl

/datum/recipe/porkbowl
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_RICE = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/porkbowl

/datum/recipe/cubannachos
	fruit = list(PLANT_CHILI = 1)
	reagents = list(REAGENT_ID_KETCHUP = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/cubannachos

/datum/recipe/curryrice
	fruit = list(PLANT_CHILI = 1)
	reagents = list(REAGENT_ID_RICE = 10)
	result = /obj/item/reagent_containers/food/snacks/curryrice

/datum/recipe/piginblanket
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/piginblanket

/datum/recipe/bagelplain
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/bagelplain

/datum/recipe/bagelsunflower
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/rawsunflower
	)
	result = /obj/item/reagent_containers/food/snacks/bagelsunflower

/datum/recipe/bagelcheese
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/bagelcheese

/datum/recipe/bagelraisin
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/no_raisin
	)
	result = /obj/item/reagent_containers/food/snacks/bagelraisin

/datum/recipe/bagelpoppy
	fruit = list(PLANT_POPPIES = 1)
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/bagelpoppy

/datum/recipe/bageleverything
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/fuel_assembly/supermatter
	)
	result = /obj/item/reagent_containers/food/snacks/bageleverything

/datum/recipe/bageltwo
	reagents = list(REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/soulstone
	)
	result = /obj/item/reagent_containers/food/snacks/bageltwo

//Recipes that use RECIPE_REAGENT_REPLACE will
//simplify the end product and balance the amount of reagents
//in some foods. Many require the space spice reagent/condiment
//to reduce the risk of future recipe conflicts.

/datum/recipe/redcurry
	reagents = list(REAGENT_ID_CREAM = 5, REAGENT_ID_SPACESPICE = 2, REAGENT_ID_RICE = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/redcurry

/datum/recipe/greencurry
	reagents = list(REAGENT_ID_CREAM = 5, REAGENT_ID_SPACESPICE = 2, REAGENT_ID_RICE = 5)
	fruit = list(PLANT_CHILI = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/greencurry

/datum/recipe/yellowcurry
	reagents = list(REAGENT_ID_CREAM = 5, REAGENT_ID_SPACESPICE = 2, REAGENT_ID_RICE = 5)
	fruit = list(PLANT_PEANUT = 2, PLANT_POTATO = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/yellowcurry

/datum/recipe/bearchili
	fruit = list(PLANT_CHILI = 1, PLANT_TOMATO = 1)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearchili

/datum/recipe/bearstew
	fruit = list(PLANT_POTATO = 1, PLANT_TOMATO = 1, PLANT_CARROT = 1, PLANT_EGGPLANT = 1, PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearstew

/datum/recipe/bibimbap
	fruit = list(PLANT_CARROT = 1, PLANT_CABBAGE = 1, PLANT_MUSHROOMS = 1)
	reagents = list(REAGENT_ID_RICE = 5, REAGENT_ID_SPACESPICE = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bibimbap

/datum/recipe/friedrice
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_RICE = 10, REAGENT_ID_SOYSAUCE = 5)
	fruit = list(PLANT_CARROT = 1, PLANT_CABBAGE = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/friedrice

/datum/recipe/lomein
	reagents = list(REAGENT_ID_WATER = 5, REAGENT_ID_SOYSAUCE = 5)
	fruit = list(PLANT_CARROT = 1, PLANT_CABBAGE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/spagetti
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/lomein

/datum/recipe/chickennoodlesoup
	fruit = list(PLANT_CARROT = 1)
	reagents = list(REAGENT_ID_WATER = 10)
	items = list( /obj/item/reagent_containers/food/snacks/spagetti, /obj/item/reagent_containers/food/snacks/rawcutlet)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chickennoodlesoup

/datum/recipe/chilicheesefries
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/hotchili
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/chilicheesefries

/datum/recipe/risotto
	reagents = list(REAGENT_ID_REDWINE = 5, REAGENT_ID_RICE = 10, REAGENT_ID_SPACESPICE = 1)
	fruit = list(PLANT_MUSHROOMS = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here
	result = /obj/item/reagent_containers/food/snacks/risotto

/datum/recipe/poachedegg
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1, REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/poachedegg

/datum/recipe/nugget
	reagents = list(REAGENT_ID_FLOUR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nugget
	result_quantity = 3

// Chip update
/datum/recipe/microwavetortilla
	reagents = list(REAGENT_ID_FLOUR = 5, REAGENT_ID_WATER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/tortilla
	reagent_mix = RECIPE_REAGENT_REPLACE //no gross flour or water
	result_quantity = 3

/datum/recipe/taco
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco

/datum/recipe/chips
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate

/datum/recipe/nachos
	items = list(
		/obj/item/reagent_containers/food/snacks/chipplate,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/nachos

/datum/recipe/salsa
	fruit = list(PLANT_CHILI = 1, PLANT_TOMATO = 1, PLANT_LIME = 1)
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_BLACKPEPPER = 1,REAGENT_ID_SODIUMCHLORIDE = 1)
	result = /obj/item/reagent_containers/food/snacks/dip/salsa
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/guac
	fruit = list(PLANT_CHILI = 1, PLANT_LIME = 1)
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_BLACKPEPPER = 1,REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/dip/guac
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/cheesesauce
	fruit = list(PLANT_CHILI = 1, PLANT_TOMATO = 1)
	reagents = list(REAGENT_ID_SPACESPICE = 1, REAGENT_ID_BLACKPEPPER = 1,REAGENT_ID_SODIUMCHLORIDE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/dip
	reagent_mix = RECIPE_REAGENT_REPLACE //Ingredients are mixed together.

/datum/recipe/burrito
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	reagents = list(REAGENT_ID_SPACESPICE = 1)
	result = /obj/item/reagent_containers/food/snacks/burrito

/datum/recipe/burrito_vegan
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_vegan

/datum/recipe/burrito_cheese
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_cheese

/datum/recipe/burrito_cheese_spicy
	fruit = list(PLANT_CHILI = 2, PLANT_SOYBEAN = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_cheese_spicy

/datum/recipe/burrito_hell
	fruit = list(PLANT_SOYBEAN = 1, PLANT_CHILI = 10)
	reagents = list(REAGENT_ID_SPACESPICE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_hell
	reagent_mix = RECIPE_REAGENT_REPLACE //Already hot sauce

/datum/recipe/meatburrito
	fruit = list(PLANT_SOYBEAN = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	result = /obj/item/reagent_containers/food/snacks/meatburrito

/datum/recipe/cheeseburrito
	fruit = list(PLANT_SOYBEAN = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/cheeseburrito

/datum/recipe/fuegoburrito
	fruit = list(PLANT_SOYBEAN = 1, PLANT_CHILI = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/fuegoburrito

/datum/recipe/breakfast_wrap
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/breakfast_wrap

/datum/recipe/burrito_mystery
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/mysterysoup
	)
	result = /obj/item/reagent_containers/food/snacks/burrito_mystery

/datum/recipe/baconmicrowave
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon/microwave

/datum/recipe/chilied_eggs
	items = list(
		/obj/item/reagent_containers/food/snacks/hotchili,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/chilied_eggs

/datum/recipe/red_sun_special
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/cheesewedge

	)
	result = /obj/item/reagent_containers/food/snacks/red_sun_special

/datum/recipe/hatchling_suprise
	items = list(
		/obj/item/reagent_containers/food/snacks/poachedegg,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon

	)
	result = /obj/item/reagent_containers/food/snacks/hatchling_suprise

/datum/recipe/riztizkzi_sea
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagents = list(REAGENT_ID_BLOOD = 15)
	result = /obj/item/reagent_containers/food/snacks/riztizkzi_sea

/datum/recipe/father_breakfast
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/meatsteak
	)
	reagents = list(REAGENT_ID_EGG = 6)
	result = /obj/item/reagent_containers/food/snacks/father_breakfast

/datum/recipe/stuffed_meatball
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	fruit = list(PLANT_CABBAGE = 1)
	result = /obj/item/reagent_containers/food/snacks/stuffed_meatball
	result_quantity = 2

/datum/recipe/egg_pancake
	items = list(
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	reagents = list(REAGENT_ID_EGG = 6)
	result = /obj/item/reagent_containers/food/snacks/egg_pancake

/datum/recipe/bacon_stick
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/boiledegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_stick

/datum/recipe/bacon_and_eggs
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_and_eggs

/datum/recipe/ntmuffin
	items = list(
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/nt_muffin

/datum/recipe/fish_taco
	fruit = list(PLANT_CHILI = 1, PLANT_LEMON = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	result = /obj/item/reagent_containers/food/snacks/fish_taco

/datum/recipe/blt
	fruit = list(PLANT_TOMATO = 1, PLANT_LETTUCE = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/blt

/datum/recipe/gigapuddi
	reagents = list(REAGENT_ID_MILK = 15)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
		)
	result = /obj/item/reagent_containers/food/snacks/gigapuddi

/datum/recipe/gigapuddi/happy
	reagents = list(REAGENT_ID_MILK = 15, REAGENT_ID_SUGAR = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
		)
	result = /obj/item/reagent_containers/food/snacks/gigapuddi/happy

/datum/recipe/gigapuddi/anger
	reagents = list(REAGENT_ID_MILK = 15, REAGENT_ID_SODIUMCHLORIDE = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
		)
	result = /obj/item/reagent_containers/food/snacks/gigapuddi/anger
