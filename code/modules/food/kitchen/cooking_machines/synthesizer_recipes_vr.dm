/datum/category_item/synthesizer/New()
	..()
	var/obj/item/I
	if(path)
		I = new path()

	if(!I)	// Something has gone horribly wrong, or right.
		log_debug("[name] created an Synthesizer design without an assigned path.")
		return
	qdel(I)

/*********************
* Synthed Food Setup *
**********************/
/obj/item/weapon/reagent_containers/food/snacks/synthsized_meal
	name = "Nutrient paste meal"
	desc = "It's a synthisized edible wafer of nutrients. Everything you need and makes field rations a delicacy in comparison."
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "pasteblock"
	filling_color = "#c5e384"
	center_of_mass = list("x"=16, "y"=6)
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/reagent_containers/food/snacks/synthsized_meal/Initialize()
	. = ..()
	reagents.add_reagent("nutripaste", 1)

/datum/reagent/nutriment/synthmealgoop
	name = "Nutriment Paste"
	id = "nutripaste"
	description = "a revoltingly bland paste of nutrition."
	taste_description = "undefinable blandness"
	taste_mult = 1
	nutriment_factor = 15 //half the power of real Nutriment. for balance.
	reagent_state = SOLID
	color = "#c5e384"

//gotta make the fuel a thing, might as well make it horrid, amirite. Should only be a cargo import.
/datum/reagent/nutriment/synthsyolent
	name = "Soylent Agent Green"
	id = "synthsoygreen"
	description = "An thick, horridly rubbery fluid that somehow can be synthisized into 'edible' meals."
	taste_description = "unrefined cloying oil"
	taste_mult = 1.3
	nutriment_factor = 1
	reagent_state = LIQUID
	color = "#4b0082"

/****************************
* Category Collection Setup *
****************************/

/datum/category_collection/synthesizer_recipes
	category_group_type = /datum/category_group/synthesizer



/*************
* Categories *
*************/

/datum/category_group/synthesizer

/datum/category_group/synthesizer/all
	name = "All"
	category_item_type = /datum/category_item/synthesizer

/datum/category_group/synthesizer/all/New()
	..()

/datum/category_group/synthesizer/basic
	name = "Basics"
	category_item_type = /datum/category_item/synthesizer/basic

/datum/category_group/synthesizer/raw
	name = "Raw"
	category_item_type = /datum/category_item/synthesizer/raw

/datum/category_group/synthesizer/cooked
	name = "Cooked"
	category_item_type = /datum/category_item/synthesizer/cooked

/datum/category_group/synthesizer/liquid
	name = "Liquid"
	category_item_type = /datum/category_item/synthesizer/liquid

/datum/category_group/synthesizer/dessert
	name = "Desserts"
	category_item_type = /datum/category_item/synthesizer/dessert

/datum/category_group/synthesizer/exotic
	name = "Exotic"
	category_item_type = /datum/category_item/synthesizer/exotic

/*******************
* Category entries *
*******************/

/datum/category_item/synthesizer
	var/path
	var/hidden = FALSE
	var/list/voice_order
	var/voice_temp


/*********
* Basics *
**********/
/datum/category_item/synthesizer/basic/muffin
	name = "plain muffin"
	path = /obj/item/weapon/reagent_containers/food/snacks/muffin
	voice_order = list("plain muffin", "bald cupcake")
	voice_temp = "cold"

/*
/datum/category_item/synthesizer/basic/popcorn
name = "Popcorn"
path = /obj/item/weapon/reagent_containers/food/snacks/popcorn

/datum/category_item/synthesizer/basic/genericsandwich
name = "Sandwich"
path = /obj/item/weapon/reagent_containers/food/snacks/sandwich

/datum/category_item/synthesizer/basic/tastybread
/obj/item/weapon/reagent_containers/food/snacks/tastybread

/datum/category_item/synthesizer/basic/bagelplain
/obj/item/weapon/reagent_containers/food/snacks/bagelplain

/datum/category_item/synthesizer/basic/bagelsunflower
/obj/item/weapon/reagent_containers/food/snacks/bagelsunflower

/datum/category_item/synthesizer/basic/bagelcheese
/obj/item/weapon/reagent_containers/food/snacks/bagelcheese

/datum/category_item/synthesizer/basic/bagelraisin
/obj/item/weapon/reagent_containers/food/snacks/bagelraisin

/datum/category_item/synthesizer/basic/bagelpoppy
/obj/item/weapon/reagent_containers/food/snacks/bagelpoppy

/datum/category_item/synthesizer/basic/croissant
/obj/item/weapon/reagent_containers/food/snacks/croissant
	name = "croissant"

/datum/category_item/synthesizer/basic/meatbreadslice
/obj/item/weapon/reagent_containers/food/snacks/slice/meatbread/filled

/datum/category_item/synthesizer/basic/tofubreadslice
/obj/item/weapon/reagent_containers/food/snacks/slice/tofubread/filled

/datum/category_item/synthesizer/basic/creamcheesebreadslice
/obj/item/weapon/reagent_containers/food/snacks/slice/creamcheesebread/filled

/datum/catagory_item/synthesizer/basic/xenobreadslice
/obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread

/datum/category_item/synthesizer/basic/margheritaslice
/obj/item/weapon/reagent_containers/food/snacks/slice/margherita/filled

/datum/category_item/synthesizer/basic/meatpizzaslice
/obj/item/weapon/reagent_containers/food/snacks/slice/meatpizza/filled

/datum/category_item/synthesizer/basic/mushroompizzasilce
/obj/item/weapon/reagent_containers/food/snacks/slice/mushroompizza/filled

/datum/category_item/synthesizer/basic/veggiepizzaslice
/obj/item/weapon/reagent_containers/food/snacks/slice/vegetablepizza/filled

/datum/category_item/synthesizer/basic/pineapplepizzaslice
/obj/item/weapon/reagent_containers/food/snacks/pineappleslice/filled

/datum/category_item/synthesizer/basic/corndog
/obj/item/weapon/reagent_containers/food/snacks/corn_dog

/datum/category_item/synthesizer/basic/spicedmeatbun
/obj/item/weapon/reagent_containers/food/snacks/spicedmeatbun

/datum/category_item/synthesizer/basic/quicheslice
/obj/item/weapon/reagent_containers/food/snacks/quicheslice/filled

/datum/category_item/synthesizer/basic/poached egg
/obj/item/weapon/reagent_containers/food/snacks/poachedegg
	name = "poached egg"

/datum/category_item/synthesizer/basic/boiledegg
/obj/item/weapon/reagent_containers/food/snacks/boiledegg

/datum/category_item/synthesizer/basic/friedegg
/obj/item/weapon/reagent_containers/food/snacks/friedegg

/datum/category_item/synthesizer/basic/chiliedegg
/obj/item/weapon/reagent_containers/food/snacks/chilied_eggs

/datum/category_item/synthesizer/basic/bacon
/obj/item/weapon/reagent_containers/food/snacks/bacon_stick

/datum/category_item/synthesizer/basic/eggbacon
/obj/item/weapon/reagent_containers/food/snacks/bacon_and_eggs

/datum/category_item/synthesizer/basic/blt
/obj/item/weapon/reagent_containers/food/snacks/blt

/datum/category_item/synthesizer/basic/mintcandy
/obj/item/weapon/reagent_containers/food/snacks/mint
	name = "mint"

/datum/category_item/synthesizer/basic/candybar
/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "Grandma Ellen's Candy Bar"

/datum/category_item/synthesizer/basic/proteinbar
/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar
	name = "SwoleMAX protein bar" */

/datum/category_item/synthesizer/basic/cb10
	name = "Shantak Bar"
	path = /obj/item/weapon/reagent_containers/food/snacks/cb10
	voice_order = list("shantak","shantak bar", "chocolate nut bar")
	voice_temp = "cold"

/*********
* FOOKIN RAAAWH *
**********/

/datum/category_item/synthesizer/raw/meat
	name = "meat steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat
	voice_order = list("meat slab","slab of meat","raw steak", "raw meat steak")
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/corgi
	name = "corgi steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	voice_order = list("Dog steak", "Dog", "Canine")
	voice_temp = "cold"
	hidden = TRUE

/*********
* Cooked *
**********/
/datum/category_item/synthesizer/cooked/ribplate
	name = "plate of ribs"
	path = /obj/item/weapon/reagent_containers/food/snacks/ribplate
	voice_order = list("plate of ribs", "rib plate")
	voice_temp = "hot"
/*
/datum/category_item/synthesizer/cooked/ovenfries
/obj/item/weapon/reagent_containers/food/snacks/ovenfries

/datum/category_item/synthesizer/cooked/dionaroast
/obj/item/weapon/reagent_containers/food/snacks/dionaroast

/datum/category_item/synthesizer/cooked/monkeydelight
/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight

/datum/category_item/synthesizer/cooked/turkey
/obj/item/weapon/reagent_containers/food/snacks/sliceable/turkey

/datum/category_item/synthesizer/cooked/tofurkey
/obj/item/weapon/reagent_containers/food/snacks/tofurkey

/datum/category_item/synthesizer/cooked/zestfish
/obj/item/weapon/reagent_containers/food/snacks/zestfish

/datum/category_item/synthesizer/cooked/bread
/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread

/datum/category_item/synthesizer/cooked/baguette
/obj/item/weapon/reagent_containers/food/snacks/baguette

/datum/category_item/synthesizer/cooked/tofubread
/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread

/datum/category_item/synthesizer/cooked/flatbread
/obj/item/weapon/reagent_containers/food/snacks/flatbread

/datum/category_item/synthesizer/cooked/tortilla
/obj/item/weapon/reagent_containers/food/snacks/tortilla
	name = "tortilla"
/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread
/obj/item/weapon/reagent_containers/food/snacks/bun

/datum/category_item/synthesizer/cooked/meatpie
/obj/item/weapon/reagent_containers/food/snacks/meatpie

/datum/category_item/synthesizer/cooked/tofupie
/obj/item/weapon/reagent_containers/food/snacks/tofupie

/datum/category_item/synthesizer/cooked/xenopie
/obj/item/weapon/reagent_containers/food/snacks/xemeatpie

/datum/category_item/synthesizer/cooked/plumppie
/obj/item/weapon/reagent_containers/food/snacks/plump_pie

/datum/category_item/synthesizer/cooked/enchiladas
/obj/item/weapon/reagent_containers/food/snacks/enchiladas

/datum/category_item/synthesizer/cooked/lasagna
/obj/item/weapon/reagent_containers/food/snacks/lasagna

/datum/category_item/synthesizer/cooked/ovenbacon
/obj/item/weapon/reagent_containers/food/snacks/bacon/oven

/datum/category_item/synthesizer/cooked/macncheese
/obj/item/weapon/reagent_containers/food/snacks/macncheese

/datum/category_item/synthesizer/cooked/chickenmomo
/obj/item/weapon/reagent_containers/food/snacks/chickenmomo
	name = "chicken momo"

/datum/category_item/synthesizer/cooked/veggiemomo
/obj/item/weapon/reagent_containers/food/snacks/veggiemomo
	name = "veggie momo"

/datum/category_item/synthesizer/cooked/sweetnsour
/obj/item/weapon/reagent_containers/food/snacks/sweet_and_sour

/datum/category_item/synthesizer/cooked/baconflatbread
/obj/item/weapon/reagent_containers/food/snacks/bacon_flatbread

/datum/category_item/synthesizer/cooked/meatpocket
/obj/item/weapon/reagent_containers/food/snacks/meat_pocket

/datum/category_item/synthesizer/cooked/fishtaco
/obj/item/weapon/reagent_containers/food/snacks/fish_taco

/datum/category_item/synthesizer/cooked/ntmuffin
/obj/item/weapon/reagent_containers/food/snacks/nt_muffin

/datum/category_item/synthesizer/cooked/porkbowl
/obj/item/weapon/reagent_containers/food/snacks/porkbowl

/datum/category_item/synthesizer/cooked/baconburger
/obj/item/weapon/reagent_containers/food/snacks/burger/bacon

/datum/category_item/synthesizer/cooked/loadedpotato
/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato

/datum/category_item/synthesizer/cooked/britishpotatos
/obj/item/weapon/reagent_containers/food/snacks/bangersandmash	name = "Bangers and Mash"

/datum/category_item/synthesizer/cooked/cheesemash
/obj/item/weapon/reagent_containers/food/snacks/cheesymash
	name = "Cheesy Mashed Potato"

/datum/category_item/synthesizer/cooked/nuggies
/obj/item/weapon/reagent_containers/food/snacks/nugget
	name = "chicken nugget"

/datum/category_item/synthesizer/cooked/fuegoburrito
/obj/item/weapon/reagent_containers/food/snacks/fuegoburrito
	name = "fuego phoron burrito"

/datum/category_item/synthesizer/cooked/meatburrito
/obj/item/weapon/reagent_containers/food/snacks/meatburrito
	name = "carne asada burrito"

/datum/category_item/synthesizer/cooked/cheeseburrito
/obj/item/weapon/reagent_containers/food/snacks/cheeseburrito
	name = "Cheese burrito"

/datum/category_item/synthesizer/cooked/eggroll
/obj/item/weapon/reagent_containers/food/snacks/eggroll
	name = "egg roll"

/datum/category_item/synthesizer/cooked/chilliburrito
/obj/item/weapon/reagent_containers/food/snacks/burrito
	name = "chilli burrito"

/datum/category_item/synthesizer/cooked/spicyburrito
/obj/item/weapon/reagent_containers/food/snacks/burrito_spicy
	name = "spicy burrito"

/datum/category_item/synthesizer/cooked/meatcheeseburrito
/obj/item/weapon/reagent_containers/food/snacks/burrito_cheese
	name = "carne queso burrito"

/datum/category_item/synthesizer/cooked/spicycheeseburrito
/obj/item/weapon/reagent_containers/food/snacks/burrito_cheese_spicy
	name = "spicy cheese burrito"

/datum/category_item/synthesizer/cooked/veganburrito
/obj/item/weapon/reagent_containers/food/snacks/burrito_vegan
	name = "vegan burrito"

/datum/category_item/synthesizer/cooked/breakfastburrito
/obj/item/weapon/reagent_containers/food/snacks/breakfast_wrap
	name = "breakfast wrap"

/datum/category_item/synthesizer/cooked/mysteryburrito
/obj/item/weapon/reagent_containers/food/snacks/burrito_mystery
	name = "mystery meat burrito"

/datum/category_item/synthesizer/cooked/hellrito
/obj/item/weapon/reagent_containers/food/snacks/burrito_hell
	name = "el diablo"

/datum/category_item/synthesizer/cooked/stuffedmeatball
/obj/item/weapon/reagent_containers/food/snacks/stuffed_meatball
	name = "stuffed meatball"

/datum/category_item/synthesizer/cooked/eggpancake
/obj/item/weapon/reagent_containers/food/snacks/egg_pancake
	name = "egg pancake"

/datum/category_item/synthesizer/cooked/redcurry
/obj/item/weapon/reagent_containers/food/snacks/redcurry
	name = "red curry"

/datum/category_item/synthesizer/cooked/greencurry
/obj/item/weapon/reagent_containers/food/snacks/greencurry
	name = "green curry"

/datum/category_item/synthesizer/cooked/yellowcurry
/obj/item/weapon/reagent_containers/food/snacks/yellowcurry
	name = "yellow curry"

/datum/category_item/synthesizer/cooked/bibimbap
/obj/item/weapon/reagent_containers/food/snacks/bibimbap
	name = "bibimbap bowl"

/datum/category_item/synthesizer/cooked/lomein
/obj/item/weapon/reagent_containers/food/snacks/lomein
	name = "lo mein"

/datum/category_item/synthesizer/cooked/friedrice
/obj/item/weapon/reagent_containers/food/snacks/friedrice
	name = "fried rice"

/datum/category_item/synthesizer/cooked/risotto
/obj/item/weapon/reagent_containers/food/snacks/risotto
	name = "risotto"

/datum/category_item/synthesizer/cooked/risottoballs
/obj/item/weapon/reagent_containers/food/snacks/risottoballs
	name = "risotto balls"

/datum/category_item/synthesizer/cooked/chickensandwich
/obj/item/weapon/reagent_containers/food/snacks/chickenfillet
	name = "chicken fillet sandwich"

/datum/category_item/synthesizer/cooked/friedmushroom
/obj/item/weapon/reagent_containers/food/snacks/friedmushroom
	name = "fried mushroom"

/datum/category_item/synthesizer/cooked/meatleaf
/obj/item/weapon/reagent_containers/food/snacks/meatbun
	name = "meat and leaf bun"

/datum/category_item/synthesizer/cooked/spicybun
/obj/item/weapon/reagent_containers/food/snacks/spicedmeatbun
	name = "char sui meat bun"

/datum/category_item/synthesizer/cooked/eggrice
/obj/item/weapon/reagent_containers/food/snacks/omurice
	name = "omelette rice (regular)"

/datum/category_item/synthesizer/cooked/eggriceheart
	name = "omelette rice (heart)"
	/obj/item/weapon/reagent_containers/food/snacks/omurice/heart

/datum/category_item/synthesizer/cooked/eggriceface
	name = "omelette rice (face)"
	/obj/item/weapon/reagent_containers/food/snacks/omurice/face */
/*********
* Liquid *
**********/

/datum/category_item/synthesizer/liquid/liquidfood
	name = "LiquidFood Ration"
	path = /obj/item/weapon/reagent_containers/food/snacks/liquidfood
	voice_order = list("Liquid ration", "food drink", "Liquidfood")
	voice_temp = "cold"

//obj/item/weapon/reagent_containers/food/snacks/liquidprotein,
//obj/item/weapon/reagent_containers/food/snacks/liquidvitamin,
/**********
* Dessert *
***********/
/*
/obj/item/weapon/reagent_containers/food/snacks/donut/plain/jelly,
/obj/item/weapon/reagent_containers/food/snacks/donut/plain/jelly/cherryjelly,
/obj/item/weapon/reagent_containers/food/snacks/candiedapple,
/obj/item/weapon/reagent_containers/food/snacks/applepie,
/obj/item/weapon/reagent_containers/food/snacks/cherrypie,
/obj/item/weapon/reagent_containers/food/snacks/appletart, */

/datum/category_item/synthesizer/dessert/cinnamonbun
	name = "cinnamon bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/cinnamonbun
	voice_order = list("Cinnamon bun","sweetroll", "cinnabun")
	voice_temp = "hot"

/*
/obj/item/weapon/reagent_containers/food/snacks/slice/carrotcake/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/cheesecake/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/plaincake/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/orangecake/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/limecake/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/lemoncake/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/chocolatecake/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/birthdaycake/filled,
/obj/item/weapon/reagent_containers/food/snacks/watermelonslice,
/obj/item/weapon/reagent_containers/food/snacks/slice/applecake/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/pumpkinpie/filled,
/obj/item/weapon/reagent_containers/food/snacks/keylimepieslice/filled,
/obj/item/weapon/reagent_containers/food/snacks/browniesslice/filled,
/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks,
/obj/item/weapon/reagent_containers/food/snacks/mint/admints,
/obj/item/weapon/reagent_containers/food/snacks/sugarcookie,
/obj/item/weapon/reagent_containers/food/snacks/custardbun
	name = "custard bun"
/obj/item/weapon/reagent_containers/food/snacks/honeybun
	name = "honey bun"
/obj/item/weapon/reagent_containers/food/snacks/honeytoast,
/obj/item/weapon/reagent_containers/food/snacks/cookie,
/obj/item/weapon/reagent_containers/food/snacks/fruitbar,
/obj/item/weapon/reagent_containers/food/snacks/pie
/obj/item/weapon/reagent_containers/food/snacks/amanita_pie
/obj/item/weapon/reagent_containers/food/snacks/pancakes
	name = "pancakes"
/obj/item/weapon/reagent_containers/food/snacks/pancakes/berry
/obj/item/weapon/reagent_containers/food/snacks/funnelcake
/obj/item/weapon/reagent_containers/food/snacks/truffle
/obj/item/weapon/reagent_containers/food/snacks/icecreamsandwich
	name = "ice cream sandwich"
/obj/item/weapon/reagent_containers/food/snacks/pisanggoreng
	name = "pisang goreng" */
/*********
* Exotic *
**********/
/datum/category_item/synthesizer/exotic/hatchling_suprise
	name = "hatchling suprise"
	path = /obj/item/weapon/reagent_containers/food/snacks/hatchling_suprise
	voice_order = list("hatchling surpise")
	voice_temp = "hot"

/*
/obj/item/weapon/reagent_containers/food/snacks/red_sun_special
	name = "red sun special"
/obj/item/weapon/reagent_containers/food/snacks/riztizkzi_sea
	name = "moghesian sea delight"
/obj/item/weapon/reagent_containers/food/snacks/father_breakfast
	name = "breakfast of champions"
/obj/item/weapon/reagent_containers/food/snacks/bearburger
	name = "bearburger"
/obj/item/weapon/reagent_containers/food/snacks/namagashi
	name = "Ryo-kucha Namagashi"

/datum/category_item/synthesizer/exotic/micro
	name = "Crew Replica"
	path = /obj/item/weapon/holder/micro
	voice_order = list("micro", "crewmember", "crew member", "crew", "nerd", "snackrifice", "snacksized", "snack-sized", "snack sized")
	voice_temp = findsnackrifice(

/datum/category_item/synthesizer/exotic/micro/proc/findsnackrifice(mob/snack)
	var/mob/snack
	var/matrix/original_transform

/datum/category_item/synthesizer/exotic/micro/proc/assemblesnackrifice
	vis_contents += held
	name = held.name
	original_transform = held.transform
	held.transform = null */

/datum/category_item/synthesizer/dd_SortValue()
	return name