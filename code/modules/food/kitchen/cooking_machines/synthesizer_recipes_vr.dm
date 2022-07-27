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
/datum/reagent/nutriment/synthsoylent
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

/datum/category_group/synthesizer/crewprint
	name = "Crew"
	category_item_type = /datum/category_item/synthesizer/crewprint

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

	name = ""
	path =
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/popcorn
	name = "Popcorn"
	path = /obj/item/weapon/reagent_containers/food/snacks/popcorn
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/genericsandwich
	name = "Basic Sandvich"
	path = /obj/item/weapon/reagent_containers/food/snacks/sandwich
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/tastybread
	name = "Tubular Bread"
	path = /obj/item/weapon/reagent_containers/food/snacks/tastybread
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/bagelplain
	name = "Bagel (Plain)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelplain
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/bagelsunflower
	name = "Bagel (Sunflower)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelsunflower
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/bagelcheese
	name = "Bagel (Cheese)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelcheese
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/bagelraisin
	name = "Bagel (Raisin)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelraisin
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/bagelpoppy
	name = "Bagel (Poppyseed)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelpoppy
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/croissant
	name = "Croissant"
	path = /obj/item/weapon/reagent_containers/food/snacks/croissant
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/meatbreadslice
	name = "Meat bread (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/meatbread/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/tofubreadslice
	name = "Tofu bread (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/tofubread/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/creamcheesebreadslice
	name = "Creamcheese bread (slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/creamcheesebread/filled
	voice_order = list()
	voice_temp = ""

/datum/catagory_item/synthesizer/basic/xenobreadslice
	name = "Xeno Bread (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/margheritaslice
	name = "Margherita Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/margherita/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/meatpizzaslice
	name = "Meat Lovers Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/meatpizza/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/mushroompizzasilce
	name = "Mushroom Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/mushroompizza/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/veggiepizzaslice
	name = "The Works Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/vegetablepizza/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/pineapplepizzaslice
	name = "Pineapple Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/pineappleslice/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/corndog
	name = "County Fair Corndog"
	path = /obj/item/weapon/reagent_containers/food/snacks/corn_dog
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/spicedmeatbun
	name = "Spiced Meat Bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/spicedmeatbun
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/quicheslice
	name = "Quiche Slice"
	path = /obj/item/weapon/reagent_containers/food/snacks/quicheslice/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/poached egg
	name = "Egg (Poached)"
	path = /obj/item/weapon/reagent_containers/food/snacks/poachedegg
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/boiledegg
	name = "Egg (Boiled)"
	path = /obj/item/weapon/reagent_containers/food/snacks/boiledegg
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/friedegg
	name = "Egg (Fried)"
	path = /obj/item/weapon/reagent_containers/food/snacks/friedegg
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/chiliedegg
	name = "Egg (Deviled)"
	path = /obj/item/weapon/reagent_containers/food/snacks/chilied_eggs
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/bacon
	name = "Bacon wafer"
	path = /obj/item/weapon/reagent_containers/food/snacks/bacon_stick
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/eggbacon
	name = "Bacon and Eggs"
	path = /obj/item/weapon/reagent_containers/food/snacks/bacon_and_eggs
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/blt
	name = "BLT sandwich"
	path = /obj/item/weapon/reagent_containers/food/snacks/blt
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/mint
	name = "Candy (Mint)"
	path = /obj/item/weapon/reagent_containers/food/snacks/mint
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/basic/candybar
	name = "Candy (Bar)"
	path = /obj/item/weapon/reagent_containers/food/snacks/candy
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/basic/proteinbar
	name = "Candy (Protein)"
	path = /obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/basic/cb10
	name = "Candy (Nutty)"
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

/datum/category_item/synthesizer/raw/bacon
	name = "Bacon (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/rawbacon
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/mushroom
	name = "Mushroom slice"
	path = /obj/item/weapon/reagent_containers/food/snacks/mushroomslice
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/tomato
	name = "Tomato steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/tomatomeat
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/bear
	name = "Bear steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bearmeat
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/xeno
	name = "Xeno steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/xenomeat
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/spider
	name = "Spider steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/xenomeat/spidermeat
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/spahgetti
	name = "Spaghetti (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/spagetti
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/corgi
	name = "corgi steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	voice_order = list("Dog steak", "Dog", "Canine steak")
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

/datum/category_item/synthesizer/cooked/ovenfries
	name = "Oven baked fries"
	path = /obj/item/weapon/reagent_containers/food/snacks/ovenfries
	voice_order = list()
	voice_temp = "hot"

/datum/category_item/synthesizer/cooked/monkeydelight
	name = "Monkey's Delight"
	path = /obj/item/weapon/reagent_containers/food/snacks/monkeysdelight
	voice_order = list()
	voice_temp = "cold"

/datum/category_item/synthesizer/cooked/turkey
	name = "Turkey (Whole)"
	path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/turkey
	voice_order = list()
	voice_temp = "hot"

/datum/category_item/synthesizer/cooked/tofurkey
	name = "Tofurkey"
	path = /obj/item/weapon/reagent_containers/food/snacks/tofurkey
	voice_order = list()
	voice_temp = "hot"


/datum/category_item/synthesizer/cooked/zestfish
	name = "Zesty Fish"
	path = /obj/item/weapon/reagent_containers/food/snacks/zestfish
	voice_order = list()
	voice_temp = "hot"

/datum/category_item/synthesizer/cooked/bread
	name = "Bread Loaf"
	path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/baguette
	name = "Baguette"
	path = /obj/item/weapon/reagent_containers/food/snacks/baguette
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/tofubread
	name = "Tofu Bread Loaf"
	path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/flatbread
	name = "Flatbread"
	path = /obj/item/weapon/reagent_containers/food/snacks/flatbread
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/tortilla
	name = "Flour Tortilla"
	path = /obj/item/weapon/reagent_containers/food/snacks/tortilla
	voice_order = list()
	voice_temp = ""

/obj/item/weapon/reagent_containers/food/snacks/bun
	name = "Burger Bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/bun
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/meatpie
	name = "Pie (Meat)"
	path = /obj/item/weapon/reagent_containers/food/snacks/meatpie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/tofupie
	name = "Pie (Tofu)"
	path = /obj/item/weapon/reagent_containers/food/snacks/tofupie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/xenopie
	name = "Pie (Xeno)"
	path = /obj/item/weapon/reagent_containers/food/snacks/xemeatpie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/plumppie
	name = "Pie (Mushroom)"
	path = /obj/item/weapon/reagent_containers/food/snacks/plump_pie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/enchiladas
	name = "Enchiladas"
	path = /obj/item/weapon/reagent_containers/food/snacks/enchiladas
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/lasagna
	name = "Lasagne"
	path = /obj/item/weapon/reagent_containers/food/snacks/lasagna
	voice_order = list()
	voice_temp = ""


/datum/category_item/synthesizer/cooked/ovenbacon
	name = "Oven baked bacon"
	path = /obj/item/weapon/reagent_containers/food/snacks/bacon/oven
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/macncheese
	name = "Mac and Cheese"
	path = /obj/item/weapon/reagent_containers/food/snacks/macncheese
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/chickenmomo
	name = "chicken momo"
	path = /obj/item/weapon/reagent_containers/food/snacks/chickenmomo
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/veggiemomo
	name = "veggie momo"
	path = /obj/item/weapon/reagent_containers/food/snacks/veggiemomo
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/sweetnsour
	name = "Sweet and Sour Pork"
	path = /obj/item/weapon/reagent_containers/food/snacks/sweet_and_sour
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/baconflatbread
	name = "Bacon Flatbread"
	path = /obj/item/weapon/reagent_containers/food/snacks/bacon_flatbread
	voice_order = list()
	voice_temp = ""


/datum/category_item/synthesizer/cooked/meatpocket
	name = "Meat and Cheese Flatbread"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat_pocket
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/fishtaco
	name = "Taco"
	path = /obj/item/weapon/reagent_containers/food/snacks/taco
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/fishtaco
	name = "Fish Taco"
	path = /obj/item/weapon/reagent_containers/food/snacks/fish_taco
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/ntmuffin
	name = "Dwarven Breakfast Muffin"
	path = /obj/item/weapon/reagent_containers/food/snacks/nt_muffin
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/porkbowl
	name = "Pork Bowl"
	path = /obj/item/weapon/reagent_containers/food/snacks/porkbowl
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/baconburger
	name = "Bacon Burger"
	path = /obj/item/weapon/reagent_containers/food/snacks/burger/bacon
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/loadedpotato
	name = "Loaded Baked Potato"
	path = /obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
	voice_order = list()
	voice_temp = ""


/datum/category_item/synthesizer/cooked/britishpotatos
	name = "Bangers and Mash"
	path = /obj/item/weapon/reagent_containers/food/snacks/bangersandmash
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/cheesemash
	name = "Cheesy Mashed Potato"
	path = /obj/item/weapon/reagent_containers/food/snacks/cheesymash
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/nuggies
	name = "chicken nugget"
	path = /obj/item/weapon/reagent_containers/food/snacks/nugget
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/fuegoburrito
	name = "fuego phoron burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/fuegoburrito
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/meatburrito
	name = "carne asada burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/meatburrito
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/cheeseburrito
	name = "Cheese burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/cheeseburrito
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/eggroll
	name = "egg roll"
	path = /obj/item/weapon/reagent_containers/food/snacks/eggroll
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/chilliburrito
	name = "chilli burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/spicyburrito
	name = "spicy burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_spicy
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/meatcheeseburrito
	name = "carne queso burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_cheese
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/spicycheeseburrito
	name = "spicy cheese burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_cheese_spicy
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/veganburrito
	name = "vegan burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_vegan
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/breakfastburrito
	name = "breakfast wrap"
	path = /obj/item/weapon/reagent_containers/food/snacks/breakfast_wrap
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/mysteryburrito
	name = "mystery meat burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_mystery
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/hellrito
	name = "el diablo"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_hell
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/stuffedmeatball
	name = "stuffed meatball"
	path = /obj/item/weapon/reagent_containers/food/snacks/stuffed_meatball
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/eggpancake
	name = "Egg Pancake"
	path = /obj/item/weapon/reagent_containers/food/snacks/egg_pancake
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/redcurry
	name = "Red Curry"
	path = /obj/item/weapon/reagent_containers/food/snacks/redcurry
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/greencurry
	name = "Green Curry"
	path = /obj/item/weapon/reagent_containers/food/snacks/greencurry
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/yellowcurry
	name = "Yellow Curry"
	path = /obj/item/weapon/reagent_containers/food/snacks/yellowcurry
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/bibimbap
	name = "Bibimbap Bowl"
	path = /obj/item/weapon/reagent_containers/food/snacks/bibimbap
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/lomein
	name = "lo mein"
	path = /obj/item/weapon/reagent_containers/food/snacks/lomein
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/friedrice
	name = "fried rice"
	path = /obj/item/weapon/reagent_containers/food/snacks/friedrice
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/risotto
	name = "risotto"
	path = /obj/item/weapon/reagent_containers/food/snacks/risotto
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/risottoballs
	name = "risotto balls"
	path = /obj/item/weapon/reagent_containers/food/snacks/risottoballs
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/chickensandwich
	name = "chicken fillet sandwich"
	path = /obj/item/weapon/reagent_containers/food/snacks/chickenfillet
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/friedmushroom
	name = "fried mushroom"
	path = /obj/item/weapon/reagent_containers/food/snacks/friedmushroom
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/meatbun
	name = "meat and leaf bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/meatbun
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/spicybun
	name = "Char Sui Meat Bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/spicedmeatbun
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/eggrice
	name = "Omelette Rice (regular)"
	path = /obj/item/weapon/reagent_containers/food/snacks/omurice
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/eggriceheart
	name = "Omelette Rice (heart)"
	path = /obj/item/weapon/reagent_containers/food/snacks/omurice/heart
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/cooked/eggriceface
	name = "Omelette Rice (face)"
	path = /obj/item/weapon/reagent_containers/food/snacks/omurice/face
	voice_order = list()
	voice_temp = ""

/*********
* Liquid *
**********/

/datum/category_item/synthesizer/liquid/liquidfood
	name = "Liquid Ration (Generic)"
	path = /obj/item/weapon/reagent_containers/food/snacks/liquidfood
	voice_order = list("Liquid ration", "food drink", "Liquidfood")
	voice_temp = "cold"

/datum/category_item/synthesizer/liquid/liquidprotein
	name = "Liquid Ration (Protein)"
	path = /obj/item/weapon/reagent_containers/food/snacks/liquidprotein
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/liquid/liquidvitamin
	name = "Liquid Ration (Vitamin)"
	path = /obj/item/weapon/reagent_containers/food/snacks/liquidvitamin
	voice_order = list()
	voice_temp = ""


/**********
* Dessert *
***********/

/datum/category_item/synthesizer/dessert/jelly_donut
	name = "Donut (Jelly)"
	path = /obj/item/weapon/reagent_containers/food/snacks/donut/plain/jelly
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/cherry_donut
	name = "Donut (Cherry)"
	path = /obj/item/weapon/reagent_containers/food/snacks/donut/plain/jelly/cherryjelly
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/candyapple
	name = "Candied Apple"
	path = /obj/item/weapon/reagent_containers/food/snacks/candiedapple
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/applepie
	name = "Pie (Apple)"
	path = /obj/item/weapon/reagent_containers/food/snacks/applepie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/cherrypie
	name = "Pie (Cherry)"
	path = /obj/item/weapon/reagent_containers/food/snacks/cherrypie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/appletart
	name = "Apple Tart"
	path = /obj/item/weapon/reagent_containers/food/snacks/appletart
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/cinnamonbun
	name = "cinnamon bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/cinnamonbun
	voice_order = list("Cinnamon bun","sweetroll", "cinnabun")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/carrotcake
	name = "Carrot Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/carrotcake/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/cheesecake
	name = "Cheesecake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/cheesecake/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/plaincake
	name = "Plain Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/plaincake/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/orangecake
	name = "Orange Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/orangecake/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/limecake
	name = "Lime Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/limecake/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/lemoncake
	name = "Lemon Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/lemoncake/filled

/datum/category_item/synthesizer/dessert/chocolatecake
	name = "Chocolate Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/chocolatecake/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/birthdaycake
	name = "Birthday Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/birthdaycake/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/watermelonslice
	name = "Watermelon Slice"
	path = /obj/item/weapon/reagent_containers/food/snacks/watermelonslice
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/applecake
	name = "Apple Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/applecake/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/pumpkinpie
	name = "Pumpkin Pie"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/pumpkinpie/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/keylimepieslice
	name = "Key Lime Pie"
	path = /obj/item/weapon/reagent_containers/food/snacks/keylimepieslice/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/browniesslice
	name = "Brownie"
	path = /obj/item/weapon/reagent_containers/food/snacks/browniesslice/filled
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/skrellsnacks
	name = "Skrell Snacks"
	path = /obj/item/weapon/reagent_containers/food/snacks/skrellsnacks
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/admints
	name = "Admints"
	path = /obj/item/weapon/reagent_containers/food/snacks/mint/admints
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/sugarcookie
	name = "Sugar Cookie"
	path = /obj/item/weapon/reagent_containers/food/snacks/sugarcookie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/custardbun
	name = "Custard Bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/custardbun
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/honeybun
	name = "Honey Bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/honeybun
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/honeytoast
	name = "Honey Toast"
	path = /obj/item/weapon/reagent_containers/food/snacks/honeytoast

/datum/category_item/synthesizer/dessert/cookie
	name = "Cookie"
	path = /obj/item/weapon/reagent_containers/food/snacks/cookie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/fruitbar
	name = "Fruit Bar"
	path = /obj/item/weapon/reagent_containers/food/snacks/fruitbar
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/pie
	name = "Plain Pie"
	path = /obj/item/weapon/reagent_containers/food/snacks/pie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/amanita_pie
	name = "Amanita Pie"
	path = /obj/item/weapon/reagent_containers/food/snacks/amanita_pie
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/pancakes
	name = "Pancakes"
	path = /obj/item/weapon/reagent_containers/food/snacks/pancakes
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/berrypancake
	name = "Berry Pancakes"
	path = /obj/item/weapon/reagent_containers/food/snacks/pancakes/berry
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/funnelcake
	name = "Funnel Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/funnelcake
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/truffle
	name = "Truffle"
	path = /obj/item/weapon/reagent_containers/food/snacks/truffle
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/icecreamsandwich
	name = "Ice Cream Sandwich"
	path = /obj/item/weapon/reagent_containers/food/snacks/icecreamsandwich
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/dessert/pisanggoreng
	name = "Pisang Goreng"
	path = /obj/item/weapon/reagent_containers/food/snacks/pisanggoreng
	voice_order = list()
	voice_temp = ""

/*********
* Exotic *
**********/

/datum/category_item/synthesizer/exotic/hatchling_suprise
	name = "Hatchling Suprise"
	path = /obj/item/weapon/reagent_containers/food/snacks/hatchling_suprise
	voice_order = list("hatchling surpise")
	voice_temp = "hot"


/datum/category_item/synthesizer/exotic/red_sun_special
	name = "Red Sun Special"
	path = /obj/item/weapon/reagent_containers/food/snacks/red_sun_special
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/exotic/riztizkzi_sea
	name = "Moghesian Sea Delight"
	path = /obj/item/weapon/reagent_containers/food/snacks/riztizkzi_sea
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/exotic/father_breakfast
	name = "Fatherly Breakfast"
	path = /obj/item/weapon/reagent_containers/food/snacks/father_breakfast
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/exotic/bearburger
	name = "Bear Burger"
	path = /obj/item/weapon/reagent_containers/food/snacks/bearburger
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/exotic/namagashi
	name = "Ryo-kucha Namagashi"
	path = /obj/item/weapon/reagent_containers/food/snacks/namagashi
	voice_order = list()
	voice_temp = ""

/datum/category_item/synthesizer/exotic/dionaroast
	name = "Diona Roast"
	path = /obj/item/weapon/reagent_containers/food/snacks/dionaroast
	voice_order = list()
	voice_temp = "hot"

/datum/category_item/synthesizer/exotic/burnedmess
	name = "Dubious Food"
	path = /obj/item/weapon/reagent_containers/food/snacks/badrecipe
	voice_order = list()
	voice_temp = "hot"

/*
/datum/category_item/synthesizer/crewprint/micro
	name = "Crew Replica"
	path = /mob/living/carbon/human/mannequin
	voice_order = list("micro", "crewmember", "crew member", "crew", "nerd", "snackrifice", "snacksized", "snack-sized", "snack sized")
//	voice_temp = "[findsnackrifice()]"

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