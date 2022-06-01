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
	nutriment_desc = list("undefinable blandness" = 1)
	w_class = ITEMSIZE_SMALL
	nutriment_amt = 1

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
name = "Popcorn (popped)"
path = /obj/item/weapon/reagent_containers/food/snacks/popcorn

name = "Sandwich"
path = /obj/item/weapon/reagent_containers/food/snacks/sandwich

/obj/item/weapon/reagent_containers/food/snacks/tastybread,
/obj/item/weapon/reagent_containers/food/snacks/bagelplain,
/obj/item/weapon/reagent_containers/food/snacks/bagelsunflower,
/obj/item/weapon/reagent_containers/food/snacks/bagelcheese,
/obj/item/weapon/reagent_containers/food/snacks/bagelraisin,
/obj/item/weapon/reagent_containers/food/snacks/bagelpoppy,
/obj/item/weapon/reagent_containers/food/snacks/croissant
	name = "croissant"
/obj/item/weapon/reagent_containers/food/snacks/slice/meatbread/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/tofubread/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/creamcheesebread/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/margherita/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/meatpizza/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/mushroompizza/filled,
/obj/item/weapon/reagent_containers/food/snacks/slice/vegetablepizza/filled,
/obj/item/weapon/reagent_containers/food/snacks/pineappleslice/filled,
/obj/item/weapon/reagent_containers/food/snacks/corn_dog,
/obj/item/weapon/reagent_containers/food/snacks/spicedmeatbun,
/obj/item/weapon/reagent_containers/food/snacks/quicheslice/filled
/obj/item/weapon/reagent_containers/food/snacks/poachedegg
	name = "poached egg"
/obj/item/weapon/reagent_containers/food/snacks/boiledegg,
/obj/item/weapon/reagent_containers/food/snacks/friedegg
/obj/item/weapon/reagent_containers/food/snacks/chilied_eggs
/obj/item/weapon/reagent_containers/food/snacks/bacon_stick
/obj/item/weapon/reagent_containers/food/snacks/bacon_and_eggs
/obj/item/weapon/reagent_containers/food/snacks/blt
/obj/item/weapon/reagent_containers/food/snacks/mint
	name = "mint"
/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "Grandma Ellen's Candy Bar"
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
	voice_order = list("meat slab","slab of meat","steak", "raw meat steak")
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
/obj/item/weapon/reagent_containers/food/snacks/ovenfries
/obj/item/weapon/reagent_containers/food/snacks/dionaroast
/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight
/obj/item/weapon/reagent_containers/food/snacks/sliceable/turkey
/obj/item/weapon/reagent_containers/food/snacks/tofurkey
/obj/item/weapon/reagent_containers/food/snacks/zestfish
/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
/obj/item/weapon/reagent_containers/food/snacks/baguette
/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread
/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread
/obj/item/weapon/reagent_containers/food/snacks/flatbread
/obj/item/weapon/reagent_containers/food/snacks/tortilla
	name = "tortilla"
/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread
/obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread
/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread
/obj/item/weapon/reagent_containers/food/snacks/bun
/obj/item/weapon/reagent_containers/food/snacks/meatpie
/obj/item/weapon/reagent_containers/food/snacks/tofupie
/obj/item/weapon/reagent_containers/food/snacks/xemeatpie
/obj/item/weapon/reagent_containers/food/snacks/plump_pie
/obj/item/weapon/reagent_containers/food/snacks/enchiladas
/obj/item/weapon/reagent_containers/food/snacks/lasagna
/obj/item/weapon/reagent_containers/food/snacks/bacon/oven
/obj/item/weapon/reagent_containers/food/snacks/macncheese
/obj/item/weapon/reagent_containers/food/snacks/chickenmomo
	name = "chicken momo"
/obj/item/weapon/reagent_containers/food/snacks/veggiemomo
	name = "veggie momo"
/obj/item/weapon/reagent_containers/food/snacks/sweet_and_sour
/obj/item/weapon/reagent_containers/food/snacks/bacon_flatbread
/obj/item/weapon/reagent_containers/food/snacks/meat_pocket
/obj/item/weapon/reagent_containers/food/snacks/fish_taco
/obj/item/weapon/reagent_containers/food/snacks/nt_muffin
/obj/item/weapon/reagent_containers/food/snacks/porkbowl
/obj/item/weapon/reagent_containers/food/snacks/burger/bacon
/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
/obj/item/weapon/reagent_containers/food/snacks/bangersandmash	name = "Bangers and Mash"
/obj/item/weapon/reagent_containers/food/snacks/cheesymash
	name = "Cheesy Mashed Potato"
/obj/item/weapon/reagent_containers/food/snacks/nugget
	name = "chicken nugget"
/obj/item/weapon/reagent_containers/food/snacks/fuegoburrito
	name = "fuego phoron burrito"
/obj/item/weapon/reagent_containers/food/snacks/meatburrito
	name = "carne asada burrito"
/obj/item/weapon/reagent_containers/food/snacks/cheeseburrito
	name = "Cheese burrito"
/obj/item/weapon/reagent_containers/food/snacks/eggroll
	name = "egg roll"
/obj/item/weapon/reagent_containers/food/snacks/burrito
	name = "chilli burrito"
/obj/item/weapon/reagent_containers/food/snacks/burrito_spicy
	name = "spicy burrito"
/obj/item/weapon/reagent_containers/food/snacks/burrito_cheese
	name = "carne queso burrito"
/obj/item/weapon/reagent_containers/food/snacks/burrito_cheese_spicy
	name = "spicy cheese burrito"
/obj/item/weapon/reagent_containers/food/snacks/burrito_vegan
	name = "vegan burrito"
/obj/item/weapon/reagent_containers/food/snacks/breakfast_wrap
	name = "breakfast wrap"
/obj/item/weapon/reagent_containers/food/snacks/burrito_mystery
	name = "mystery meat burrito"
/obj/item/weapon/reagent_containers/food/snacks/burrito_hell
	name = "el diablo"
/obj/item/weapon/reagent_containers/food/snacks/stuffed_meatball
	name = "stuffed meatball"
/obj/item/weapon/reagent_containers/food/snacks/egg_pancake
	name = "meat pancake"
/obj/item/weapon/reagent_containers/food/snacks/redcurry
	name = "red curry"
/obj/item/weapon/reagent_containers/food/snacks/greencurry
	name = "green curry"
/obj/item/weapon/reagent_containers/food/snacks/yellowcurry
	name = "yellow curry"
/obj/item/weapon/reagent_containers/food/snacks/bibimbap
	name = "bibimbap bowl"
/obj/item/weapon/reagent_containers/food/snacks/lomein
	name = "lo mein"
/obj/item/weapon/reagent_containers/food/snacks/friedrice
	name = "fried rice"
/obj/item/weapon/reagent_containers/food/snacks/risotto
	name = "risotto"
/obj/item/weapon/reagent_containers/food/snacks/risottoballs
	name = "risotto balls"
/obj/item/weapon/reagent_containers/food/snacks/chickenfillet
	name = "chicken fillet sandwich"
/obj/item/weapon/reagent_containers/food/snacks/friedmushroom
	name = "fried mushroom"
/obj/item/weapon/reagent_containers/food/snacks/meatbun
	name = "meat and leaf bun"
/obj/item/weapon/reagent_containers/food/snacks/spicedmeatbun
	name = "char sui meat bun"
/obj/item/weapon/reagent_containers/food/snacks/omurice
	name = "omelette rice"
	/obj/item/weapon/reagent_containers/food/snacks/omurice/heart
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