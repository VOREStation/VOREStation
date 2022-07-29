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
	taste_description = "undefinable blandness" //This gets updated with our printed food's taste descriptor
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
	var/id = null

/datum/category_group/synthesizer/New()
	..()

/datum/category_group/synthesizer/appasnack
	name = "Snack / Appetizers"
	id = "appasnacc"
	category_item_type = /datum/category_item/synthesizer/appasnack

/datum/category_group/synthesizer/breakfastmenu
	name = "Breakfast Menu"
	id = "breakfast"
	category_item_type = /datum/category_item/synthesizer/breakfastmenu

/datum/category_group/synthesizer/lunchmenu
	name = "Lunch Menu"
	id = "lunch"
	category_item_type = /datum/category_item/synthesizer/lunchmenu

/datum/category_group/synthesizer/dinnermenu
	name = "Dinner Menu"
	id = "dinner"
	category_item_type = /datum/category_item/synthesizer/dinnermenu

/datum/category_group/synthesizer/dessertmenu
	name = "Dessert Menu"
	id = "dessert"
	category_item_type = /datum/category_item/synthesizer/dessert

/datum/category_group/synthesizer/exoticmenu
	name = "Exotic Menu"
	id = "exotic"
	category_item_type = /datum/category_item/synthesizer/exotic

/datum/category_group/synthesizer/rawmenu
	name = "Raw Offerings"
	id = "raw"
	category_item_type = /datum/category_item/synthesizer/raw

/*******************
* Category entries *
*******************/

/datum/category_item/synthesizer
	var/path							//food item path
	var/hidden = FALSE					//is it illegal/nonstandard?
	var/list/voice_order				//what can we say to get this? Avoid exact same phrases.
	var/voice_temp						//mostly flavor but maybe also setting stuff that will warm/cool you off? idk


/*********
* Snacks *
**********/

/datum/category_item/synthesizer/appasnack/popcorn
	name = "Popcorn"
	path = /obj/item/weapon/reagent_containers/food/snacks/popcorn
	voice_order = list("popcorn", "corn of popping")
	voice_temp = "hot"

/datum/category_item/synthesizer/appasnack/nuggies
	name = "chicken nugget"
	path = /obj/item/weapon/reagent_containers/food/snacks/nugget
	voice_order = list("chimkin nuggy", "chicken nugget")
	voice_temp = "hot"

/datum/category_item/synthesizer/appasnack/flatbread
	name = "Flatbread"
	path = /obj/item/weapon/reagent_containers/food/snacks/flatbread
	voice_order = list("flatbread")
	voice_temp = "cold"

/datum/category_item/synthesizer/appasnack/tortilla
	name = "Flour Tortilla"
	path = /obj/item/weapon/reagent_containers/food/snacks/tortilla
	voice_order = list("tortilla", "flour tortilla")
	voice_temp = "hot" //imagine liking *cold* Tortillas. Ugh. It offends my Texan sensibilites.

/datum/category_item/synthesizer/appasnack/bun
	name = "Burger Bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/bun
	voice_order = list("Burger bun", "plain bun")
	voice_temp = "cold"

/datum/category_item/synthesizer/appasnack/eggroll
	name = "egg roll"
	path = /obj/item/weapon/reagent_containers/food/snacks/eggroll
	voice_order = list("egg roll", "happy ending")
	voice_temp = "hot"

/datum/category_item/synthesizer/appasnack/friedmushroom
	name = "fried mushroom"
	path = /obj/item/weapon/reagent_containers/food/snacks/friedmushroom
	voice_order = list("fried mushroom","fried cap")
	voice_temp = "hot"

/datum/category_item/synthesizer/appasnack/watermelonslice
	name = "Watermelon Slice"
	path = /obj/item/weapon/reagent_containers/food/snacks/watermelonslice
	voice_order = list("watermelon slice")
	voice_temp = "cold"

/datum/category_item/synthesizer/appasnack/truffle
	name = "Candy (Truffle)"
	path = /obj/item/weapon/reagent_containers/food/snacks/truffle
	voice_order = list("chocolate truffle")
	voice_temp = "cold"

/datum/category_item/synthesizer/appasnack/mint
	name = "Candy (Mint)"
	path = /obj/item/weapon/reagent_containers/food/snacks/mint
	voice_order = list("candy mints", "mint candy")
	voice_temp = "cold"

/datum/category_item/synthesizer/appasnack/candybar
	name = "Candy (Bar)"
	path = /obj/item/weapon/reagent_containers/food/snacks/candy
	voice_order = list("candy bar", "chocolate bar")
	voice_temp = "cold"

/datum/category_item/synthesizer/appasnack/proteinbar
	name = "Candy (Protein)"
	path = /obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar
	voice_order = list("protein candy bar", "protein bar")
	voice_temp = "cold"

/datum/category_item/synthesizer/appasnack/cb10
	name = "Candy (Nutty)"
	path = /obj/item/weapon/reagent_containers/food/snacks/cb10
	voice_order = list("shantak","shantak bar", "chocolate nut bar")
	voice_temp = "cold"

/datum/category_item/synthesizer/appasnack/skrellsnacks
	name = "Skrell Snacks"
	path = /obj/item/weapon/reagent_containers/food/snacks/skrellsnacks
	voice_order = list("skrell snacks", "skrell snacc", "skrell treats")
	voice_temp = "cold"

/datum/category_item/synthesizer/appasnack/admints
	name = "Admints"
	path = /obj/item/weapon/reagent_containers/food/snacks/mint/admints
	voice_order = list("admints", "admin mints")
	voice_temp = "cold"

/*********
* Breakfast *
**********/

/datum/category_item/synthesizer/breakfastmenu/muffin
	name = "plain muffin"
	path = /obj/item/weapon/reagent_containers/food/snacks/muffin
	voice_order = list("plain muffin", "bald cupcake")
	voice_temp = "cold"

/datum/category_item/synthesizer/breakfastmenu/bagelplain
	name = "Bagel (Plain)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelplain
	voice_order = list("bagel", "plain bagel")
	voice_temp = "cold"

/datum/category_item/synthesizer/breakfastmenu/bagelsunflower
	name = "Bagel (Sunflower)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelsunflower
	voice_order = list("sunflower bagel", "bagel sunflower", "bagel with sunflower")
	voice_temp = "cold"

/datum/category_item/synthesizer/breakfastmenu/bagelcheese
	name = "Bagel (Cheese)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelcheese
	voice_order = list("cream cheese bagel","cheese bagel", "bagel with cheese")
	voice_temp = "cold"

/datum/category_item/synthesizer/breakfastmenu/bagelraisin
	name = "Bagel (Raisin)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelraisin
	voice_order = list("raisin bagel", "raisen bagel", "bagel with raisins", "bagel with raisens")
	voice_temp = "cold"

/datum/category_item/synthesizer/breakfastmenu/bagelpoppy
	name = "Bagel (Poppyseed)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bagelpoppy
	voice_order = list("poppyseed bagel", "bagel with poppyseeds")
	voice_temp = "cold"

/datum/category_item/synthesizer/breakfastmenu/croissant
	name = "Croissant"
	path = /obj/item/weapon/reagent_containers/food/snacks/croissant
	voice_order = list("croissant", "crossant")
	voice_temp = "cold"

/datum/category_item/synthesizer/breakfastmenu/pancakes
	name = "Pancakes"
	path = /obj/item/weapon/reagent_containers/food/snacks/pancakes
	voice_order = list("plain pancakes")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/berrypancake
	name = "Berry Pancakes"
	path = /obj/item/weapon/reagent_containers/food/snacks/pancakes/berry
	voice_order = list("berry pancakes", "pancakes with berries")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/ntmuffin
	name = "Dwarven Breakfast Muffin"
	path = /obj/item/weapon/reagent_containers/food/snacks/nt_muffin
	voice_order = list("breakfast muffin", "nt muffin")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/breakfastburrito
	name = "breakfast burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/breakfast_wrap
	voice_order = list("Breakfast burrito")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/quicheslice
	name = "Quiche Slice"
	path = /obj/item/weapon/reagent_containers/food/snacks/quicheslice/filled
	voice_order = list("quiche")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/poachedegg
	name = "Egg (Poached)"
	path = /obj/item/weapon/reagent_containers/food/snacks/poachedegg
	voice_order = list("poached egg")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/boiledegg
	name = "Egg (Boiled)"
	path = /obj/item/weapon/reagent_containers/food/snacks/boiledegg
	voice_order = list("boiled egg")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/friedegg
	name = "Egg (Fried)"
	path = /obj/item/weapon/reagent_containers/food/snacks/friedegg
	voice_order = list("fried egg", "egg well")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/chiliedegg
	name = "Egg (Chilied)"
	path = /obj/item/weapon/reagent_containers/food/snacks/chilied_eggs
	voice_order = list("redeemed eggs", "chili eggs")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/bacon
	name = "Bacon wafer"
	path = /obj/item/weapon/reagent_containers/food/snacks/bacon_stick
	voice_order = list("bacon stick", "stick of bacon")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/ovenbacon
	name = "Oven baked bacon"
	path = /obj/item/weapon/reagent_containers/food/snacks/bacon/oven
	voice_order = list("oven bacon", "epic bacon")
	voice_temp = "hot"

/datum/category_item/synthesizer/breakfastmenu/eggbacon
	name = "Bacon and Eggs"
	path = /obj/item/weapon/reagent_containers/food/snacks/bacon_and_eggs
	voice_order = list("bacon and eggs", "eggs and bacon")
	voice_temp = "hot"

/********
* Lunch *
*********/

/datum/category_item/synthesizer/lunchmenu/blt
	name = "BLT sandwich"
	path = /obj/item/weapon/reagent_containers/food/snacks/blt
	voice_order = list("blt sandwich", "sandwich blt")
	voice_temp = "cold"

/datum/category_item/synthesizer/lunchmenu/genericsandwich
	name = "lunchmenu Sandvich"
	path = /obj/item/weapon/reagent_containers/food/snacks/sandwich
	voice_order = list("lunchmenu sandwich", "sandwich")
	voice_temp = "cold"

/datum/category_item/synthesizer/lunchmenu/meatbreadslice
	name = "Meat bread (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/meatbread/filled
	voice_order = list("meat bread slice", "slice of meat bread")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/tofubreadslice
	name = "Tofu bread (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/tofubread/filled
	voice_order = list("tofu bread slice", "slice of tofu bread")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/creamcheesebreadslice
	name = "Cream cheese bread (slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/creamcheesebread/filled
	voice_order = list("cream cheese bread slice", "slice of cream cheese bread")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/margheritaslice
	name = "Margherita Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/margherita/filled
	voice_order = list("margherita pizza", "neapolitan pizza")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/meatpizzaslice
	name = "Meat Lovers Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/meatpizza/filled
	voice_order = list("meat pizza", "meat lovers pizza", "pizza with meat")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/mushroompizzasilce
	name = "Mushroom Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/mushroompizza/filled
	voice_order = list("mushroom pizza", "pizza with mushroom")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/veggiepizzaslice
	name = "Vegetable Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/vegetablepizza/filled
	voice_order = list("veggie pizza", "vegetable pizza", "pizza with veggies", "pizza with vegetable")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/pineapplepizzaslice
	name = "Pineapple Pizza (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/pineappleslice/filled
	voice_order = list("pineapple pizza", "pizza with pineapple", "abomination pizza", "best pizza")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/chickensandwich
	name = "chicken fillet sandwich"
	path = /obj/item/weapon/reagent_containers/food/snacks/chickenfillet
	voice_order = list("Chicken sandwich", "Chimkin sammich", "Chimkin sandwich")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/corndog
	name = "County Fair Corndog"
	path = /obj/item/weapon/reagent_containers/food/snacks/corn_dog
	voice_order = list("corndog", "hotdog on a stick")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/ovenfries
	name = "Oven baked fries"
	path = /obj/item/weapon/reagent_containers/food/snacks/ovenfries
	voice_order = list("oven fries")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/bread
	name = "Bread Loaf"
	path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
	voice_order = list("bread loaf", "loaf of bread")
	voice_temp = "cold"

/datum/category_item/synthesizer/lunchmenu/baguette
	name = "Baguette"
	path = /obj/item/weapon/reagent_containers/food/snacks/baguette
	voice_order = list("baguette", "french bread")
	voice_temp = "cold"

/datum/category_item/synthesizer/lunchmenu/tofubread
	name = "Tofu Bread Loaf"
	path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread
	voice_order = list("tofu bread loaf")
	voice_temp = "cold"

/datum/category_item/synthesizer/lunchmenu/macncheese
	name = "Mac and Cheese"
	path = /obj/item/weapon/reagent_containers/food/snacks/macncheese
	voice_order = list("Mac n cheese", "macaroni and cheese", "mac and cheese")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/chickenmomo
	name = "Chicken MoMo"
	path = /obj/item/weapon/reagent_containers/food/snacks/chickenmomo
	voice_order = list("chicken momo", "chicken dumplings")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/veggiemomo
	name = "Veggie MoMo"
	path = /obj/item/weapon/reagent_containers/food/snacks/veggiemomo
	voice_order = list("veggie momo", "veggie dumplings", "vegetarian dumplings")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/eggpancake
	name = "burger omelette"
	path = /obj/item/weapon/reagent_containers/food/snacks/egg_pancake
	voice_order = list("egg pancake", "burger omelette")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/mysteryburrito
	name = "mystery meat burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_mystery
	voice_order = list("mystery burrito")
	voice_temp = "hot"
	hidden = TRUE

/datum/category_item/synthesizer/lunchmenu/fuegoburrito
	name = "fuego phoron burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/fuegoburrito
	voice_order = list("fire veggie burrito", "fuego phoron burrito")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/meatburrito
	name = "carne asada burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/meatburrito
	voice_order = list("steak burrito", "carne asada burrito")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/cheeseburrito
	name = "Cheese burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/cheeseburrito
	voice_order = list("cheese burrito", "burrito with cheese")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/burrito
	name = "Generic Burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito
	voice_order = list("plain burrito")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/spicyburrito
	name = "spicy burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_spicy
	voice_order = list("spicy burrito")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/meatcheeseburrito
	name = "carne queso burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_cheese
	voice_order = list("meat and cheese burrito", "carne queso burrito")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/spicycheeseburrito
	name = "spicy cheese burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_cheese_spicy
	voice_order = list("spicy cheese burrito", "calente queso burrito")
	voice_temp = "hot"

/datum/category_item/synthesizer/lunchmenu/veganburrito
	name = "vegan burrito"
	path = /obj/item/weapon/reagent_containers/food/snacks/burrito_vegan
	voice_order = list("veggie burrito", "vegan burrito")
	voice_temp = "hot"

/*********
* Dinner *
**********/

//American Continents
/datum/category_item/synthesizer/dinnermenu/ribplate
	name = "Rib plate"
	path = /obj/item/weapon/reagent_containers/food/snacks/ribplate
	voice_order = list("plate of ribs", "rib plate")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/baconburger
	name = "Bacon Burger"
	path = /obj/item/weapon/reagent_containers/food/snacks/burger/bacon
	voice_order = list("bacon burger", "burger with bacon")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/taco
	name = "Taco"
	path = /obj/item/weapon/reagent_containers/food/snacks/taco
	voice_order = list("regular taco")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/fishtaco
	name = "Fish Taco"
	path = /obj/item/weapon/reagent_containers/food/snacks/fish_taco
	voice_order = list("fish taco")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/enchiladas
	name = "Enchiladas"
	path = /obj/item/weapon/reagent_containers/food/snacks/enchiladas
	voice_order = list("enchiladas")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/turkey
	name = "Turkey (Whole)"
	path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/turkey
	voice_order = list("turkey", "whole turkey")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/tofurkey
	name = "Tofurkey"
	path = /obj/item/weapon/reagent_containers/food/snacks/tofurkey
	voice_order = list("tofurkey", "tofu turkey", "whole tofurkey")
	voice_temp = "hot"

//European

/datum/category_item/synthesizer/dinnermenu/loadedpotato
	name = "Loaded Baked Potato"
	path = /obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
	voice_order = list("loaded potato", "baked loaded potato", "loaded baked potato")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/britishpotatos
	name = "Bangers and Mash"
	path = /obj/item/weapon/reagent_containers/food/snacks/bangersandmash
	voice_order = list("bangers and mash", "sausage and potatoes")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/cheesemash
	name = "Cheesy Mashed Potato"
	path = /obj/item/weapon/reagent_containers/food/snacks/cheesymash
	voice_order = list("cheese potatoes", "cheese mashed potatoes")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/zestfish
	name = "Zesty Fish"
	path = /obj/item/weapon/reagent_containers/food/snacks/zestfish
	voice_order = list("zesty fish", "fish dinner")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/meatpie
	name = "Pie (Meat)"
	path = /obj/item/weapon/reagent_containers/food/snacks/meatpie
	voice_order = list("meat pie", "pie of meat")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/tofupie
	name = "Pie (Tofu)"
	path = /obj/item/weapon/reagent_containers/food/snacks/tofupie
	voice_order = list("tofu pie", "pie of tofu")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/plumppie
	name = "Pie (Mushroom)"
	path = /obj/item/weapon/reagent_containers/food/snacks/plump_pie
	voice_order = list("mushroom pie", "plump hemlet pie")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/lasagna
	name = "Lasagne"
	path = /obj/item/weapon/reagent_containers/food/snacks/lasagna
	voice_order = list("lasagne", "garfield special")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/baconflatbread
	name = "Bacon Flatbread"
	path = /obj/item/weapon/reagent_containers/food/snacks/bacon_flatbread
	voice_order = list("bacon flatbread", "bacon with flatbread")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/meatpocket
	name = "Meat and Cheese Flatbread"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat_pocket
	voice_order = list("meat and cheese flatbread")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/risotto
	name = "risotto"
	path = /obj/item/weapon/reagent_containers/food/snacks/risotto
	voice_order = list("bowl of risotto", "regular risotto")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/risottoballs
	name = "risotto balls"
	path = /obj/item/weapon/reagent_containers/food/snacks/risottoballs
	voice_order = list("risotto balls")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/stuffedmeatball
	name = "stuffed meatball"
	path = /obj/item/weapon/reagent_containers/food/snacks/stuffed_meatball
	voice_order = list("stuffed meatball")
	voice_temp = "hot"

//Asian

/datum/category_item/synthesizer/dinnermenu/redcurry
	name = "Red Curry"
	path = /obj/item/weapon/reagent_containers/food/snacks/redcurry
	voice_order = list("red curry", "curry red")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/greencurry
	name = "Green Curry"
	path = /obj/item/weapon/reagent_containers/food/snacks/greencurry
	voice_order = list("green curry", "curry green")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/yellowcurry
	name = "Yellow Curry"
	path = /obj/item/weapon/reagent_containers/food/snacks/yellowcurry
	voice_order = list("yellow curry", "curry yellow")
	voice_temp = "Hot"

/datum/category_item/synthesizer/dinnermenu/bibimbap
	name = "Bibimbap Bowl" //The best thing. Seriously.
	path = /obj/item/weapon/reagent_containers/food/snacks/bibimbap
	voice_order = list("bibimbap", "korean hot pot")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/lomein
	name = "lo mein"
	path = /obj/item/weapon/reagent_containers/food/snacks/lomein
	voice_order = list("lo mein", "low main", "chinese noodles")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/friedrice
	name = "plain fried rice"
	path = /obj/item/weapon/reagent_containers/food/snacks/friedrice
	voice_order = list("egg fried rice", "plain fried rice")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/porkbowl
	name = "Pork Fried Rice"
	path = /obj/item/weapon/reagent_containers/food/snacks/porkbowl
	voice_order = list("pork bowl", "pork fried rice")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/sweetnsour
	name = "Sweet and Sour Pork"
	path = /obj/item/weapon/reagent_containers/food/snacks/sweet_and_sour
	voice_order = list("sweet and sour pork", "sweet sour pork")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/meatbun
	name = "meat and leaf bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/meatbun
	voice_order = list("baozi", "meat and leaf dumpling", "meat and leaf bun")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/spicedmeatbun
	name = "Spiced Meat Bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/spicedmeatbun
	voice_order = list("spiced meat bun", "char sui", "char sui bun")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/eggrice
	name = "Omelette Rice (regular)"
	path = /obj/item/weapon/reagent_containers/food/snacks/omurice
	voice_order = list("regular omelette rice", "regular omurice")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/eggriceheart
	name = "Omelette Rice (heart)"
	path = /obj/item/weapon/reagent_containers/food/snacks/omurice/heart
	voice_order = list("omelette rice with heart", "omurice heart", "omurice with heart", "heart omurice")
	voice_temp = "hot"

/datum/category_item/synthesizer/dinnermenu/eggriceface
	name = "Omelette Rice (face)"
	path = /obj/item/weapon/reagent_containers/food/snacks/omurice/face
	voice_order = list("omelette rice with face", "omurice face", "omurice with face", "face omurice")
	voice_temp = "hot"

/**********
* Dessert *
***********/

/datum/category_item/synthesizer/dessert/donut
	name = "Donut (Plain)"
	path = /obj/item/weapon/reagent_containers/food/snacks/donut/plain
	voice_order = list("plain donut", "donut with nothing")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/chocolate_donut
	name = "Donut (Chocolate)"
	path = /obj/item/weapon/reagent_containers/food/snacks/donut/choc
	voice_order = list("chocolate donut", "donut with chocolate")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/pink_donut
	name = "Donut (Pink Frosting)"
	path = /obj/item/weapon/reagent_containers/food/snacks/donut/pink
	voice_order = list("pink frosted donut", "donut with pink frosting")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/homer
	name = "Donut (Sprinkles)"
	path = /obj/item/weapon/reagent_containers/food/snacks/donut/homer
	voice_order = list("homer donut", "donut with sprinkles")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/jelly_donut
	name = "Donut (Jelly)"
	path = /obj/item/weapon/reagent_containers/food/snacks/donut/plain/jelly
	voice_order = list("jelly donut", "donut with jelly")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/meat_donut
	name = "Donut (Meat)"
	path = /obj/item/weapon/reagent_containers/food/snacks/donut/meat
	voice_order = list("meat donut", "donut with meat")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/chaos_donut
	name = "Donut (Chaos)"
	path = /obj/item/weapon/reagent_containers/food/snacks/donut/plain
	voice_order = list("chaos donut", "donut with chaos", "madness donut")
	voice_temp = "cold"
	hidden = TRUE

/datum/category_item/synthesizer/dessert/candyapple
	name = "Candied Apple"
	path = /obj/item/weapon/reagent_containers/food/snacks/candiedapple
	voice_order = list("candy apple", "candied apple")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/applepie
	name = "Pie (Apple)"
	path = /obj/item/weapon/reagent_containers/food/snacks/applepie
	voice_order = list("apple pie", "pie with apple", "American pie")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/cherrypie
	name = "Pie (Cherry)"
	path = /obj/item/weapon/reagent_containers/food/snacks/cherrypie
	voice_order = list("cherry pie", "pie with cherry")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/appletart
	name = "Apple Tart"
	path = /obj/item/weapon/reagent_containers/food/snacks/appletart
	voice_order = list("apple tart")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/cinnamonbun
	name = "cinnamon bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/cinnamonbun
	voice_order = list("Cinnamon bun","sweetroll", "cinnabun")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/tastybread
	name = "Tubular Sweet Bread"
	path = /obj/item/weapon/reagent_containers/food/snacks/tastybread
	voice_order = list("bread tube")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/carrotcake
	name = "Carrot Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/carrotcake/filled
	voice_order = list("carrot cake")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/cheesecake
	name = "Cheesecake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/cheesecake/filled
	voice_order = list("cheese cake")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/plaincake
	name = "Plain Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/plaincake/filled
	voice_order = list("plain cake")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/orangecake
	name = "Orange Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/orangecake/filled
	voice_order = list("orange cake")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/limecake
	name = "Lime Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/limecake/filled
	voice_order = list("lime cake")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/lemoncake
	name = "Lemon Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/lemoncake/filled
	voice_order = list("lemon cake")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/chocolatecake
	name = "Chocolate Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/chocolatecake/filled
	voice_order = list("chocolate cake", "mudpie")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/birthdaycake
	name = "Birthday Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/birthdaycake/filled
	voice_order = list("Birthday cake")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/applecake
	name = "Apple Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/applecake/filled
	voice_order = list("apple cake")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/pumpkinpie
	name = "Pumpkin Pie"
	path = /obj/item/weapon/reagent_containers/food/snacks/slice/pumpkinpie/filled
	voice_order = list("pumpkin pie")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/keylimepieslice
	name = "Key Lime Pie"
	path = /obj/item/weapon/reagent_containers/food/snacks/keylimepieslice/filled
	voice_order = list("key lime pie")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/browniesslice
	name = "Brownie"
	path = /obj/item/weapon/reagent_containers/food/snacks/browniesslice/filled
	voice_order = list("brownie")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/sugarcookie
	name = "Sugar Cookie"
	path = /obj/item/weapon/reagent_containers/food/snacks/sugarcookie
	voice_order = list("sugar cookie")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/custardbun
	name = "Custard Bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/custardbun
	voice_order = list("custard bun")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/honeybun
	name = "Honey Bun"
	path = /obj/item/weapon/reagent_containers/food/snacks/honeybun
	voice_order = list("honey bun")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/cookie
	name = "Cookie"
	path = /obj/item/weapon/reagent_containers/food/snacks/cookie
	voice_order = list("plain cookie", "chocolate chip cookie")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/fruitbar
	name = "Fruit Bar"
	path = /obj/item/weapon/reagent_containers/food/snacks/fruitbar
	voice_order = list("fruit bar")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/pie
	name = "Plain Pie"
	path = /obj/item/weapon/reagent_containers/food/snacks/pie
	voice_order = list("plain pie", "nothing pie")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/amanita_pie
	name = "Amanita Pie"
	path = /obj/item/weapon/reagent_containers/food/snacks/amanita_pie
	voice_order = list("amanita pie", "weed pie")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/funnelcake
	name = "Funnel Cake"
	path = /obj/item/weapon/reagent_containers/food/snacks/funnelcake
	voice_order = list("funnel cake", "fair cake")
	voice_temp = "hot"

/datum/category_item/synthesizer/dessert/icecreamsandwich
	name = "Ice Cream Sandwich"
	path = /obj/item/weapon/reagent_containers/food/snacks/icecreamsandwich
	voice_order = list("icecream sandwich", "ice cream sandwich", "sandwich with ice cream")
	voice_temp = "cold"

/datum/category_item/synthesizer/dessert/pisanggoreng
	name = "Pisang Goreng"
	path = /obj/item/weapon/reagent_containers/food/snacks/pisanggoreng
	voice_order = list("pisang goreng", "banana fritter")
	voice_temp = "hot"

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
	voice_order = list("diona roast", "plant roast")
	voice_temp = "hot"

/datum/category_item/synthesizer/exotic/burnedmess
	name = "Dubious Food"
	path = /obj/item/weapon/reagent_containers/food/snacks/badrecipe
	voice_order = list("right proper fuckup", "Whatever", "my college existance", "chef's disappointment", "Ramsey's nightmare")
	voice_temp = "hot"

/datum/category_item/synthesizer/exotic/monkeydelight
	name = "Monkey's Delight"
	path = /obj/item/weapon/reagent_containers/food/snacks/monkeysdelight
	voice_order = list("fancy banana", "monkey delight")
	voice_temp = "cold"

/datum/category_item/synthesizer/exotic/xenopie
	name = "Pie (Xeno)"
	path = /obj/item/weapon/reagent_containers/food/snacks/xemeatpie
	voice_order = list("xeno pie", "pie of xeno")
	voice_temp = "hot"

/datum/category_item/synthesizer/exotic/xenobreadslice
	name = "Xeno Bread (Slice)"
	path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread
	voice_order = list("meat bread slice", "slice of meat bread")
	voice_temp = "hot"

/datum/category_item/synthesizer/exotic/liquidfood
	name = "Liquid Ration (Generic)"
	path = /obj/item/weapon/reagent_containers/food/snacks/liquidfood
	voice_order = list("Liquid ration", "food drink", "Liquidfood")
	voice_temp = "cold"

/datum/category_item/synthesizer/exotic/liquidprotein
	name = "Liquid Ration (Protein)"
	path = /obj/item/weapon/reagent_containers/food/snacks/liquidprotein
	voice_order = list("protein liquid ration", "protein ration")
	voice_temp = "cold"

/datum/category_item/synthesizer/exotic/liquidvitamin
	name = "Liquid Ration (Vitamin)"
	path = /obj/item/weapon/reagent_containers/food/snacks/liquidvitamin
	voice_order = list("vitamin liquid ration", "vitamin ration")
	voice_temp = "cold"

/*****************
 * FOOKIN RAAAWH *
 *****************/

/datum/category_item/synthesizer/raw/meat
	name = "meat steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat
	voice_order = list("meat slab","slab of meat","raw steak", "raw meat steak")
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/bacon
	name = "Bacon (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/rawbacon
	voice_order = list("raw bacon")
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/mushroom
	name = "Mushroom slice"
	path = /obj/item/weapon/reagent_containers/food/snacks/mushroomslice
	voice_order = list("mushroom slice", "raw mushroom")
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/tomato
	name = "Tomato steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/tomatomeat
	voice_order = list("tomato slice")
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/bear
	name = "Bear steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/bearmeat
	voice_order = list("raw bear steak", "slice of bear")
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/xeno
	name = "Xeno steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/xenomeat
	voice_order = list("raw xeno steak")
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/spider
	name = "Spider steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/xenomeat/spidermeat
	voice_order = list("raw spider steak")
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/spahgetti
	name = "Spaghetti (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/spagetti
	voice_order = list("raw spaghetti", "uncooked spaghett")
	voice_temp = "cold"

/datum/category_item/synthesizer/raw/corgi
	name = "corgi steak (raw)"
	path = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	voice_order = list("Dog steak", "Dog", "Canine steak")
	voice_temp = "cold"
	hidden = TRUE

/datum/category_item/synthesizer/dd_SortValue()
	return name
