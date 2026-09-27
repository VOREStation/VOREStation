/datum/category_item/synthesizer/New()
	..()
	var/obj/item/reagent_containers/food/snacks/snacc = build_path
	if(!snacc)	// Something has gone horribly wrong, or right.
		log_game("[name] created an Synthesizer design without an assigned build_path.")
		return
	desc = initial(snacc.desc) //Let's get our description text

/*********************
* Synthed Food Setup *
**********************/
/obj/item/reagent_containers/food/snacks/synthsized_meal
	name = "Nutrient paste wafer"
	desc = "It's a synthisized edible wafer of nutrients. Everything you need and makes field rations a delicacy in comparison."
	icon = 'icons/obj/machines/foodsynthesizer.dmi'
	icon_state = "pasteblock"
	filling_color = "#c5e384"
	center_of_mass_x = 16
	center_of_mass_y = 6
	w_class = ITEMSIZE_SMALL
	bitesize = 5

/obj/item/reagent_containers/food/snacks/synthsized_meal/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_NUTRIPASTE, 5)

/obj/item/reagent_containers/food/snacks/synthsized_meal/crewblock
	name = "Crew paste block"
	desc = "It's a synthisized edible wafer of nutrients. Everything you need and makes field rations a delicacy in comparison."
	icon_state = "crewblock"
	bitesize = 30 //one chomp. bitesize = amount taken per bite? I guess? weird.
	eating_sound = 'sound/vore/sunesound/pred/swallow_01.ogg' //hehe

/datum/reagent/nutriment/synthmealgoop
	name = REAGENT_NUTRIPASTE
	id = REAGENT_ID_NUTRIPASTE
	description = "a revoltingly bland paste of nutrition."
	taste_description = "undefinable blandness" //This gets updated with our printed food's taste descriptor
	taste_mult = 1
	nutriment_factor = 6 // 2/3rds the power of real Nutriment (10). for balance.
	reagent_state = SOLID
	color = "#c5e384"

//gotta make the fuel a thing, might as well make it horrid, amirite. Should only be a cargo import. Shouldn't be aquirable!
/datum/reagent/nutriment/synthsoylent
	name = REAGENT_NUTRIPASTE_SOYLENT
	id = REAGENT_ID_NUTRIPASTE_SOYLENT
	description = "An thick, horridly rubbery fluid that somehow can be synthisized into 'edible' meals."
	taste_description = "unrefined cloying oil"
	taste_mult = 1.3
	nutriment_factor = 1
	reagent_state = LIQUID
	color = "#4b0082"

//Supply pack refills
/datum/supply_pack/vending_refills/synthesizer
	contains = list(/obj/item/reagent_containers/synthdispcart)
	name = "Food Synthesizer Cartridge (Standard)"
	cost = 20 //pricy so chef value is ever better.
	containername = "food synthesizer cartridge crate"

/datum/supply_pack/vending_refills/synthesizer/smol
	contains = list(/obj/item/reagent_containers/synthdispcart/small)
	name = "Food Synthesizer Cartridge (Portable)"
	cost = 10
	containername = "portable food synthesizer cartridge crate"

/****************************
* Category Collection Setup *
****************************/

/datum/category_collection/synthesizer
	category_group_type = /datum/category_group/synthesizer

/*************
* Categories *
*************/
#define MENU_SNACC		0
#define MENU_BREKKIE	1
#define MENU_LONCH		2
#define MENU_DINNAH		3
#define MENU_DESLUT		4
#define MENU_EROTIC		5
#define MENU_RHAWH		6
#define MENU_MEHARTY	7

/datum/category_group/synthesizer
	var/id
	var/sortorder

/datum/category_group/synthesizer/New()
	..()

/datum/category_group/synthesizer/appasnack
	name = "Appetizers"
	id = "appasnacc"
	sortorder = MENU_SNACC
	category_item_type = /datum/category_item/synthesizer/appasnack

/datum/category_group/synthesizer/breakfastmenu
	name = "Breakfasts"
	id = "breakfast"
	sortorder = MENU_BREKKIE
	category_item_type = /datum/category_item/synthesizer/breakfastmenu

/datum/category_group/synthesizer/lunchmenu
	name = "Lunches"
	id = "lunch"
	sortorder = MENU_LONCH
	category_item_type = /datum/category_item/synthesizer/lunchmenu

/datum/category_group/synthesizer/dinnermenu
	name = "Dinners"
	id = "dinner"
	sortorder = MENU_DINNAH
	category_item_type = /datum/category_item/synthesizer/dinnermenu

/datum/category_group/synthesizer/dessertmenu
	name = "Desserts"
	id = "dessert"
	sortorder = MENU_DESLUT
	category_item_type = /datum/category_item/synthesizer/dessert

/datum/category_group/synthesizer/exoticmenu
	name = "Exotics"
	id = "exotic"
	sortorder = MENU_EROTIC
	category_item_type = /datum/category_item/synthesizer/exotic

/datum/category_group/synthesizer/rawmenu
	name = "Raw Offerings"
	id = "raw"
	sortorder = MENU_RHAWH
	category_item_type = /datum/category_item/synthesizer/raw

/datum/category_group/synthesizer/crewmenu
	name = "Crew Cookies"
	id = "crew"
	sortorder = MENU_MEHARTY
	category_item_type = /datum/category_item/synthesizer/crew

#undef MENU_SNACC
#undef MENU_BREKKIE
#undef MENU_LONCH
#undef MENU_DINNAH
#undef MENU_DESLUT
#undef MENU_EROTIC
#undef MENU_RHAWH
#undef MENU_MEHARTY

/*******************
* Category entries *
*******************/

/datum/category_item/synthesizer
	var/desc							//food description to be applied to the UI.
	var/build_path						//food item build_path
	var/hidden = FALSE					//is it illegal/nonstandard?

/*********
* Snacks *
**********/

/datum/category_item/synthesizer/appasnack/popcorn
	name = "Popcorn"
	build_path = /obj/item/reagent_containers/food/snacks/popcorn

/datum/category_item/synthesizer/appasnack/nuggies
	name = "Chicken Nugget"
	build_path = /obj/item/reagent_containers/food/snacks/nugget

/datum/category_item/synthesizer/appasnack/chickenwing
	name = "Chicken Wing"
	build_path = /obj/item/reagent_containers/food/snacks/chickenwing

/datum/category_item/synthesizer/appasnack/corn_dog
	name = "Corn Dog"
	build_path = /obj/item/reagent_containers/food/snacks/corn_dog

/datum/category_item/synthesizer/appasnack/flatbread
	name = "Flatbread"
	build_path = /obj/item/reagent_containers/food/snacks/flatbread

/datum/category_item/synthesizer/appasnack/rawsunflower
	name = "Sunflower Seeds"
	build_path = /obj/item/reagent_containers/food/snacks/rawsunflower

/datum/category_item/synthesizer/appasnack/roastedsunflower
	name = "Roasted Sunflower Seeds"
	build_path = /obj/item/reagent_containers/food/snacks/roastedsunflower

/datum/category_item/synthesizer/appasnack/tortilla
	name = "Flour Tortilla"
	build_path = /obj/item/reagent_containers/food/snacks/tortilla

/datum/category_item/synthesizer/appasnack/nachos
	name = "Plain Nachos"
	build_path = /obj/item/reagent_containers/food/snacks/nachos

/datum/category_item/synthesizer/appasnack/cheesenachos
	name = "Cheesy Nachos"
	build_path = /obj/item/reagent_containers/food/snacks/cheesenachos

/datum/category_item/synthesizer/appasnack/donkpocket
	name = "Donk-pocket"
	build_path = /obj/item/reagent_containers/food/snacks/donkpocket

/datum/category_item/synthesizer/appasnack/ascendeddonkpocket
	name = "Donk-pocket EX"
	build_path = /obj/item/reagent_containers/food/snacks/donkpocket/ascended
	hidden = TRUE

/datum/category_item/synthesizer/appasnack/bun
	name = "Burger Bun"
	build_path = /obj/item/reagent_containers/food/snacks/bun

/datum/category_item/synthesizer/appasnack/eggroll
	name = "Egg Roll"
	build_path = /obj/item/reagent_containers/food/snacks/eggroll

/datum/category_item/synthesizer/appasnack/sashimi
	name = "Sashimi"
	build_path = /obj/item/reagent_containers/food/snacks/sashimi

/datum/category_item/synthesizer/appasnack/boiledrice
	name = "Steamed Rice"
	build_path = /obj/item/reagent_containers/food/snacks/boiledrice

/datum/category_item/synthesizer/appasnack/friedmushroom
	name = "Fried Mushroom"
	build_path = /obj/item/reagent_containers/food/snacks/friedmushroom

/datum/category_item/synthesizer/appasnack/watermelonslice
	name = "Watermelon Slice"
	build_path = /obj/item/reagent_containers/food/snacks/watermelonslice

/datum/category_item/synthesizer/appasnack/truffle
	name = "Candy (Truffle)"
	build_path = /obj/item/reagent_containers/food/snacks/truffle

/datum/category_item/synthesizer/appasnack/trufflerandom
	name = "Candy (Mystery Truffle)"
	build_path =/obj/item/reagent_containers/food/snacks/truffle/random

/datum/category_item/synthesizer/appasnack/mint
	name = "Candy (Mint)"
	build_path = /obj/item/reagent_containers/food/snacks/mint

/datum/category_item/synthesizer/appasnack/candybar
	name = "Candy (Bar)"
	build_path = /obj/item/reagent_containers/food/snacks/candy

/datum/category_item/synthesizer/appasnack/proteinbar
	name = "Candy (Protein)"
	build_path = /obj/item/reagent_containers/food/snacks/candy/proteinbar

/datum/category_item/synthesizer/appasnack/cb10
	name = "Candy (Nutty)"
	build_path = /obj/item/reagent_containers/food/snacks/cb10

/datum/category_item/synthesizer/appasnack/skrellsnacks
	name = "Skrell Snacks"
	build_path = /obj/item/reagent_containers/food/snacks/skrellsnacks

/datum/category_item/synthesizer/appasnack/gigapuddi
	name = "Astro-Pudding"
	build_path = /obj/item/reagent_containers/food/snacks/gigapuddi

/datum/category_item/synthesizer/appasnack/admints
	name = "Admints"
	build_path = /obj/item/reagent_containers/food/snacks/mint/admints

/datum/category_item/synthesizer/appasnack/cheesetoast
	name = "Cheese Toast"
	build_path = /obj/item/reagent_containers/food/snacks/cheesetoast

/datum/category_item/synthesizer/appasnack/jalapopper
	name = "jalapeno popper"
	build_path = /obj/item/reagent_containers/food/snacks/jalapeno_poppers

/datum/category_item/synthesizer/appasnack/domesticsausage
	name = "battered sausage"
	build_path = /obj/item/reagent_containers/food/snacks/sausage/battered

/datum/category_item/synthesizer/appasnack/chickenkatsu
	name = "chicken katsu"
	build_path = /obj/item/reagent_containers/food/snacks/chickenkatsu

/datum/category_item/synthesizer/appasnack/mashedpotato
	name = "mashed potatoes"
	build_path = /obj/item/reagent_containers/food/snacks/mashedpotato

/datum/category_item/synthesizer/appasnack/macncheese
	name = "macaroni and cheese"
	build_path = /obj/item/reagent_containers/food/snacks/macncheese

/datum/category_item/synthesizer/appasnack/tossedsalad
	name = "tossed salad"
	build_path = /obj/item/reagent_containers/food/snacks/tossedsalad

/datum/category_item/synthesizer/appasnack/validsalad
	name = "valid salad"
	build_path = /obj/item/reagent_containers/food/snacks/validsalad

/datum/category_item/synthesizer/appasnack/milosoup
	name = "Miso soup"
	build_path = /obj/item/reagent_containers/food/snacks/milosoup

/datum/category_item/synthesizer/appasnack/hotandsoursoup
	name = "hot & sour soup"
	build_path = /obj/item/reagent_containers/food/snacks/hotandsoursoup

/datum/category_item/synthesizer/appasnack/tomatosoup
	name = "Tomato Soup"
	build_path = /obj/item/reagent_containers/food/snacks/tomatosoup

/datum/category_item/synthesizer/appasnack/mushroomsoup
	name = "chantrelle soup"
	build_path = /obj/item/reagent_containers/food/snacks/mushroomsoup

/datum/category_item/synthesizer/appasnack/beetsoup
	name = "beet soup"
	build_path = /obj/item/reagent_containers/food/snacks/beetsoup

/datum/category_item/synthesizer/appasnack/onionsoup
	name = "onion soup"
	build_path = /obj/item/reagent_containers/food/snacks/soup/onion

/datum/category_item/synthesizer/appasnack/chickennoodlesoup
	name = "chicken noodle soup"
	build_path = /obj/item/reagent_containers/food/snacks/chickennoodlesoup

/datum/category_item/synthesizer/appasnack/stew
	name = "Stew"
	build_path = /obj/item/reagent_containers/food/snacks/stew

/datum/category_item/synthesizer/appasnack/hotchili
	name = "Hot Chili"
	build_path = /obj/item/reagent_containers/food/snacks/hotchili

/datum/category_item/synthesizer/appasnack/coldchili
	name = "Cold Chili"
	build_path = /obj/item/reagent_containers/food/snacks/coldchili

/datum/category_item/synthesizer/appasnack/mysterysoup
	name = "Mystery soup"
	build_path = /obj/item/reagent_containers/food/snacks/mysterysoup
	hidden = TRUE

/*********
* Breakfast *
**********/

/datum/category_item/synthesizer/breakfastmenu/muffin
	name = "Muffin (Plain)"
	build_path = /obj/item/reagent_containers/food/snacks/muffin

/datum/category_item/synthesizer/breakfastmenu/bagelplain
	name = "Bagel (Plain)"
	build_path = /obj/item/reagent_containers/food/snacks/bagelplain

/datum/category_item/synthesizer/breakfastmenu/bagelsunflower
	name = "Bagel (Sunflower)"
	build_path = /obj/item/reagent_containers/food/snacks/bagelsunflower

/datum/category_item/synthesizer/breakfastmenu/bagelcheese
	name = "Bagel (Cheese)"
	build_path = /obj/item/reagent_containers/food/snacks/bagelcheese

/datum/category_item/synthesizer/breakfastmenu/bagelraisin
	name = "Bagel (Raisin)"
	build_path = /obj/item/reagent_containers/food/snacks/bagelraisin

/datum/category_item/synthesizer/breakfastmenu/bagelpoppy
	name = "Bagel (Poppyseed)"
	build_path = /obj/item/reagent_containers/food/snacks/bagelpoppy

/datum/category_item/synthesizer/breakfastmenu/croissant
	name = "Croissant"
	build_path = /obj/item/reagent_containers/food/snacks/croissant

/datum/category_item/synthesizer/breakfastmenu/pancakes
	name = "Pancakes"
	build_path = /obj/item/reagent_containers/food/snacks/pancakes

/datum/category_item/synthesizer/breakfastmenu/berrypancake
	name = "Berry Pancakes"
	build_path = /obj/item/reagent_containers/food/snacks/pancakes/berry

/datum/category_item/synthesizer/breakfastmenu/ntmuffin
	name = "Dwarven Breakfast Muffin"
	build_path = /obj/item/reagent_containers/food/snacks/nt_muffin

/datum/category_item/synthesizer/breakfastmenu/breakfastburrito
	name = "Breakfast Burrito"
	build_path = /obj/item/reagent_containers/food/snacks/breakfast_wrap

/datum/category_item/synthesizer/breakfastmenu/quicheslice
	name = "Quiche Slice"
	build_path = /obj/item/reagent_containers/food/snacks/quicheslice/filled

/datum/category_item/synthesizer/breakfastmenu/poachedegg
	name = "Egg (Poached)"
	build_path = /obj/item/reagent_containers/food/snacks/poachedegg

/datum/category_item/synthesizer/breakfastmenu/boiledegg
	name = "Egg (Boiled)"
	build_path = /obj/item/reagent_containers/food/snacks/boiledegg

/datum/category_item/synthesizer/breakfastmenu/friedegg
	name = "Egg (Fried)"
	build_path = /obj/item/reagent_containers/food/snacks/friedegg

/datum/category_item/synthesizer/breakfastmenu/chiliedegg
	name = "Egg (Chilied)"
	build_path = /obj/item/reagent_containers/food/snacks/chilied_eggs

/datum/category_item/synthesizer/breakfastmenu/bacon
	name = "Bacon wafer"
	build_path = /obj/item/reagent_containers/food/snacks/bacon_stick

/datum/category_item/synthesizer/breakfastmenu/ovenbacon
	name = "Oven-baked bacon"
	build_path = /obj/item/reagent_containers/food/snacks/bacon/oven

/datum/category_item/synthesizer/breakfastmenu/eggbacon
	name = "Bacon and Eggs"
	build_path = /obj/item/reagent_containers/food/snacks/bacon_and_eggs

/datum/category_item/synthesizer/breakfastmenu/eggbenedict
	name = "Egg Benedict"
	build_path = /obj/item/reagent_containers/food/snacks/benedict

/datum/category_item/synthesizer/breakfastmenu/devilledegg
	name = "Devilled Egg"
	build_path = /obj/item/reagent_containers/food/snacks/devilledegg

/datum/category_item/synthesizer/breakfastmenu/piginblanket
	name = "Koblasnek"
	build_path = /obj/item/reagent_containers/food/snacks/piginblanket

/datum/category_item/synthesizer/breakfastmenu/blackpudding
	name = "Black Pudding"
	build_path = /obj/item/reagent_containers/food/snacks/blackpudding

/********
* Lunch *
*********/

/datum/category_item/synthesizer/lunchmenu/blt
	name = "BLT sandwich"
	build_path = /obj/item/reagent_containers/food/snacks/blt

/datum/category_item/synthesizer/lunchmenu/genericsandwich
	name = "Sandvich"
	build_path = /obj/item/reagent_containers/food/snacks/sandwich

/datum/category_item/synthesizer/lunchmenu/clubsandwich
	name = "Club Sandwich"
	build_path = /obj/item/reagent_containers/food/snacks/clubsandwich

/datum/category_item/synthesizer/lunchmenu/toastedsandwich
	name = "Toasted Sandwich"
	build_path = /obj/item/reagent_containers/food/snacks/toastedsandwich

/datum/category_item/synthesizer/lunchmenu/grilledcheese
	name = "Grilled Cheese Sandwich"
	build_path = /obj/item/reagent_containers/food/snacks/grilledcheese

/datum/category_item/synthesizer/lunchmenu/jellysandwich
	name = "Jelly Sandwich"
	build_path = /obj/item/reagent_containers/food/snacks/jellysandwich

/datum/category_item/synthesizer/lunchmenu/pbjsandwich
	name = "Peanut Butter Jelly Sandwich"
	build_path = /obj/item/reagent_containers/food/snacks/jellysandwich/peanutbutter

/datum/category_item/synthesizer/lunchmenu/meatbreadslice
	name = "Meat bread (Slice)"
	build_path = /obj/item/reagent_containers/food/snacks/slice/meatbread/filled

/datum/category_item/synthesizer/lunchmenu/tofubreadslice
	name = "Tofu bread (Slice)"
	build_path = /obj/item/reagent_containers/food/snacks/slice/tofubread/filled

/datum/category_item/synthesizer/lunchmenu/creamcheesebreadslice
	name = "Cream cheese bread (slice)"
	build_path = /obj/item/reagent_containers/food/snacks/slice/creamcheesebread/filled

/datum/category_item/synthesizer/lunchmenu/margheritaslice
	name = "Margherita Pizza (Slice)"
	build_path = /obj/item/reagent_containers/food/snacks/slice/margherita/filled

/datum/category_item/synthesizer/lunchmenu/meatpizzaslice
	name = "Meat Lovers Pizza (Slice)"
	build_path = /obj/item/reagent_containers/food/snacks/slice/meatpizza/filled

/datum/category_item/synthesizer/lunchmenu/mushroompizzasilce
	name = "Mushroom Pizza (Slice)"
	build_path = /obj/item/reagent_containers/food/snacks/slice/mushroompizza/filled

/datum/category_item/synthesizer/lunchmenu/veggiepizzaslice
	name = "Vegetable Pizza (Slice)"
	build_path = /obj/item/reagent_containers/food/snacks/slice/vegetablepizza/filled

/datum/category_item/synthesizer/lunchmenu/pineapplepizzaslice
	name = "Pineapple Pizza (Slice)"
	build_path = /obj/item/reagent_containers/food/snacks/pineappleslice/filled

/datum/category_item/synthesizer/lunchmenu/chickensandwich
	name = "Chicken Fillet Sandwich"
	build_path = /obj/item/reagent_containers/food/snacks/chickenfillet

/datum/category_item/synthesizer/lunchmenu/corndog
	name = "County Fair Corndog"
	build_path = /obj/item/reagent_containers/food/snacks/corn_dog

/datum/category_item/synthesizer/lunchmenu/ovenfries
	name = "Oven baked fries"
	build_path = /obj/item/reagent_containers/food/snacks/ovenfries

/datum/category_item/synthesizer/lunchmenu/onionrings
	name = "Onion Rings"
	build_path = /obj/item/reagent_containers/food/snacks/onionrings

/datum/category_item/synthesizer/lunchmenu/carrotfries
	name = "Carrot Fries"
	build_path = /obj/item/reagent_containers/food/snacks/carrotfries

/datum/category_item/synthesizer/lunchmenu/cheesyfries
	name = "Cheesy Fries"
	build_path = /obj/item/reagent_containers/food/snacks/cheesyfries

/datum/category_item/synthesizer/lunchmenu/chilicheesefries
	name = "Chili Cheesy Fries"
	build_path = /obj/item/reagent_containers/food/snacks/chilicheesefries

/datum/category_item/synthesizer/lunchmenu/turkeyslice
	name = "Turkey'n'mash"
	build_path =/obj/item/reagent_containers/food/snacks/turkeyslice

/datum/category_item/synthesizer/lunchmenu/cuttlefishcooked
	name = "Cooked Cuttlefish"
	build_path =/obj/item/reagent_containers/food/snacks/cuttlefishcooked

/datum/category_item/synthesizer/lunchmenu/monkfishcooked
	name = "Seasoned Monkfish"
	build_path =/obj/item/reagent_containers/food/snacks/monkfishcooked

/datum/category_item/synthesizer/lunchmenu/sharkmeatcooked
	name = "Grilled Shark Steak"
	build_path =/obj/item/reagent_containers/food/snacks/sharkmeatcooked

/datum/category_item/synthesizer/lunchmenu/lobstercooked
	name = "Cooked Lobster"
	build_path =/obj/item/reagent_containers/food/snacks/lobstercooked

/datum/category_item/synthesizer/lunchmenu/bread
	name = "Bread Loaf"
	build_path = /obj/item/reagent_containers/food/snacks/sliceable/bread

/datum/category_item/synthesizer/lunchmenu/baguette
	name = "Baguette"
	build_path = /obj/item/reagent_containers/food/snacks/baguette

/datum/category_item/synthesizer/lunchmenu/tofubread
	name = "Tofu Bread Loaf"
	build_path = /obj/item/reagent_containers/food/snacks/sliceable/tofubread

/datum/category_item/synthesizer/lunchmenu/macncheese
	name = "Mac and Cheese"
	build_path = /obj/item/reagent_containers/food/snacks/macncheese

/datum/category_item/synthesizer/lunchmenu/chickenmomo
	name = "Chicken MoMo"
	build_path = /obj/item/reagent_containers/food/snacks/chickenmomo

/datum/category_item/synthesizer/lunchmenu/veggiemomo
	name = "Veggie MoMo"
	build_path = /obj/item/reagent_containers/food/snacks/veggiemomo

/datum/category_item/synthesizer/lunchmenu/eggpancake
	name = "Burger Omelette"
	build_path = /obj/item/reagent_containers/food/snacks/egg_pancake

/datum/category_item/synthesizer/lunchmenu/mysteryburrito
	name = "Burrito (Mystery Meat)"
	build_path = /obj/item/reagent_containers/food/snacks/burrito_mystery
	hidden = TRUE

/datum/category_item/synthesizer/lunchmenu/fuegoburrito
	name = "Burrito (Fuego Phoron)"
	build_path = /obj/item/reagent_containers/food/snacks/fuegoburrito

/datum/category_item/synthesizer/lunchmenu/meatburrito
	name = "Burrito (carne asada)"
	build_path = /obj/item/reagent_containers/food/snacks/meatburrito

/datum/category_item/synthesizer/lunchmenu/cheeseburrito
	name = "Burrito (Cheese)"
	build_path = /obj/item/reagent_containers/food/snacks/cheeseburrito

/datum/category_item/synthesizer/lunchmenu/burrito
	name = "Burrito (Generic)"
	build_path = /obj/item/reagent_containers/food/snacks/burrito

/datum/category_item/synthesizer/lunchmenu/spicyburrito
	name = "Burrito (Spicy)"
	build_path = /obj/item/reagent_containers/food/snacks/burrito_spicy

/datum/category_item/synthesizer/lunchmenu/meatcheeseburrito
	name = "Burrito (Carne Queso)"
	build_path = /obj/item/reagent_containers/food/snacks/burrito_cheese

/datum/category_item/synthesizer/lunchmenu/spicycheeseburrito
	name = "Burrito (Spicy Cheese)"
	build_path = /obj/item/reagent_containers/food/snacks/burrito_cheese_spicy

/datum/category_item/synthesizer/lunchmenu/veganburrito
	name = "Burrito (Vegan)"
	build_path = /obj/item/reagent_containers/food/snacks/burrito_vegan

/*********
* Dinner *
**********/

/datum/category_item/synthesizer/dinnermenu/ribplate
	name = "Rib plate"
	build_path = /obj/item/reagent_containers/food/snacks/ribplate

/datum/category_item/synthesizer/dinnermenu/monkeyburger
	name = "Hamburger"
	build_path = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/category_item/synthesizer/dinnermenu/cheeseburger
	name = "Cheeseburger"
	build_path = /obj/item/reagent_containers/food/snacks/cheeseburger

/datum/category_item/synthesizer/dinnermenu/fishburger
	name = "Fish Burger"
	build_path = /obj/item/reagent_containers/food/snacks/fishburger

/datum/category_item/synthesizer/dinnermenu/tofuburger
	name = "Tofu Burger"
	build_path = /obj/item/reagent_containers/food/snacks/tofuburger

/datum/category_item/synthesizer/dinnermenu/superbiteburger
	name = "Super Bite Burger"
	build_path = /obj/item/reagent_containers/food/snacks/superbiteburger

/datum/category_item/synthesizer/dinnermenu/baconburger
	name = "Burger (Bacon)"
	build_path = /obj/item/reagent_containers/food/snacks/burger/bacon

/datum/category_item/synthesizer/dinnermenu/taco
	name = "Taco"
	build_path = /obj/item/reagent_containers/food/snacks/taco

/datum/category_item/synthesizer/dinnermenu/fishtaco
	name = "Fish Taco"
	build_path = /obj/item/reagent_containers/food/snacks/fish_taco

/datum/category_item/synthesizer/dinnermenu/enchiladas
	name = "Enchiladas"
	build_path = /obj/item/reagent_containers/food/snacks/enchiladas

/datum/category_item/synthesizer/dinnermenu/turkey
	name = "Turkey (Whole)"
	build_path = /obj/item/reagent_containers/food/snacks/sliceable/turkey

/datum/category_item/synthesizer/dinnermenu/tofurkey
	name = "Tofurkey (Whole)"
	build_path = /obj/item/reagent_containers/food/snacks/tofurkey

/datum/category_item/synthesizer/dinnermenu/loadedpotato
	name = "Loaded Baked Potato"
	build_path = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

/datum/category_item/synthesizer/dinnermenu/britishpotatos
	name = "Bangers and Mash"
	build_path = /obj/item/reagent_containers/food/snacks/bangersandmash

/datum/category_item/synthesizer/dinnermenu/cheesemash
	name = "Cheesy Mashed Potato"
	build_path = /obj/item/reagent_containers/food/snacks/cheesymash

/datum/category_item/synthesizer/dinnermenu/zestfish
	name = "Zesty Fish"
	build_path = /obj/item/reagent_containers/food/snacks/zestfish

/datum/category_item/synthesizer/dinnermenu/meatpie
	name = "Pie (Meat)"
	build_path = /obj/item/reagent_containers/food/snacks/meatpie

/datum/category_item/synthesizer/dinnermenu/tofupie
	name = "Pie (Tofu)"
	build_path = /obj/item/reagent_containers/food/snacks/tofupie

/datum/category_item/synthesizer/dinnermenu/plumppie
	name = "Pie (Mushroom)"
	build_path = /obj/item/reagent_containers/food/snacks/plump_pie

/datum/category_item/synthesizer/dinnermenu/pastatomato
	name = "Spaghetti"
	build_path = /obj/item/reagent_containers/food/snacks/pastatomato

/datum/category_item/synthesizer/dinnermenu/meatballspagetti
	name = "Spaghetti & Meatballs"
	build_path = /obj/item/reagent_containers/food/snacks/meatballspagetti

/datum/category_item/synthesizer/dinnermenu/lasagna
	name = "Lasagne"
	build_path = /obj/item/reagent_containers/food/snacks/lasagna

/datum/category_item/synthesizer/dinnermenu/baconflatbread
	name = "Bacon Flatbread"
	build_path = /obj/item/reagent_containers/food/snacks/bacon_flatbread

/datum/category_item/synthesizer/dinnermenu/meatpocket
	name = "Meat and Cheese Flatbread"
	build_path = /obj/item/reagent_containers/food/snacks/meat_pocket

/datum/category_item/synthesizer/dinnermenu/risotto
	name = "Risotto"
	build_path = /obj/item/reagent_containers/food/snacks/risotto

/datum/category_item/synthesizer/dinnermenu/risottoballs
	name = "Risotto Balls"
	build_path = /obj/item/reagent_containers/food/snacks/risottoballs

/datum/category_item/synthesizer/dinnermenu/stuffedmeatball
	name = "Stuffed Meatball"
	build_path = /obj/item/reagent_containers/food/snacks/stuffed_meatball

/datum/category_item/synthesizer/dinnermenu/goulash
	name = "goulash"
	build_path = /obj/item/reagent_containers/food/snacks/goulash

/datum/category_item/synthesizer/dinnermenu/donerkebab
	name = "doner kebab"
	build_path = /obj/item/reagent_containers/food/snacks/donerkebab

/datum/category_item/synthesizer/dinnermenu/roastbeef
	name = "roast beef"
	build_path = /obj/item/reagent_containers/food/snacks/roastbeef

/datum/category_item/synthesizer/dinnermenu/makaroni
	name = "makaronilaatikko"
	build_path = /obj/item/reagent_containers/food/snacks/makaroni

/datum/category_item/synthesizer/dinnermenu/lobstercooked
	name = "cooked lobster"
	build_path = /obj/item/reagent_containers/food/snacks/lobstercooked

/datum/category_item/synthesizer/dinnermenu/redcurry
	name = "Red Curry"
	build_path = /obj/item/reagent_containers/food/snacks/redcurry

/datum/category_item/synthesizer/dinnermenu/greencurry
	name = "Green Curry"
	build_path = /obj/item/reagent_containers/food/snacks/greencurry

/datum/category_item/synthesizer/dinnermenu/yellowcurry
	name = "Yellow Curry"
	build_path = /obj/item/reagent_containers/food/snacks/yellowcurry

/datum/category_item/synthesizer/dinnermenu/bibimbap
	name = "Bibimbap Bowl" //The best thing. Seriously.
	build_path = /obj/item/reagent_containers/food/snacks/bibimbap

/datum/category_item/synthesizer/dinnermenu/kitsuneudon
	name = "kitsune udon"
	build_path = /obj/item/reagent_containers/food/snacks/kitsuneudon

/datum/category_item/synthesizer/dinnermenu/generalschicken
	name = "general's chicken"
	build_path = /obj/item/reagent_containers/food/snacks/generalschicken

/datum/category_item/synthesizer/dinnermenu/lomein
	name = "Lo Mein"
	build_path = /obj/item/reagent_containers/food/snacks/lomein

/datum/category_item/synthesizer/dinnermenu/friedrice
	name = "Fried Rice (Plain)"
	build_path = /obj/item/reagent_containers/food/snacks/friedrice

/datum/category_item/synthesizer/dinnermenu/porkbowl
	name = "Fried Rice (Pork)"
	build_path = /obj/item/reagent_containers/food/snacks/porkbowl

/datum/category_item/synthesizer/dinnermenu/sweetnsour
	name = "Sweet and Sour Pork"
	build_path = /obj/item/reagent_containers/food/snacks/sweet_and_sour

/datum/category_item/synthesizer/dinnermenu/chickenmomo
	name = "Chicken Momo"
	build_path = /obj/item/reagent_containers/food/snacks/chickenmomo

/datum/category_item/synthesizer/dinnermenu/veggiemomo
	name = "Veggie Momo"
	build_path = /obj/item/reagent_containers/food/snacks/veggiemomo

/datum/category_item/synthesizer/dinnermenu/meatbun
	name = "Baozi"
	build_path = /obj/item/reagent_containers/food/snacks/meatbun

/datum/category_item/synthesizer/dinnermenu/spicedmeatbun
	name = "Spiced Baozi"
	build_path = /obj/item/reagent_containers/food/snacks/spicedmeatbun

/datum/category_item/synthesizer/dinnermenu/eggrice
	name = "Omelette Rice (regular)"
	build_path = /obj/item/reagent_containers/food/snacks/omurice

/datum/category_item/synthesizer/dinnermenu/eggriceheart
	name = "Omelette Rice (heart)"
	build_path = /obj/item/reagent_containers/food/snacks/omurice/heart

/datum/category_item/synthesizer/dinnermenu/eggriceface
	name = "Omelette Rice (face)"
	build_path = /obj/item/reagent_containers/food/snacks/omurice/face

/**********
* Dessert *
***********/

/datum/category_item/synthesizer/dessert/donut
	name = "Donut (Plain)"
	build_path = /obj/item/reagent_containers/food/snacks/donut/plain

/datum/category_item/synthesizer/dessert/chocolate_donut
	name = "Donut (Chocolate)"
	build_path = /obj/item/reagent_containers/food/snacks/donut/choc

/datum/category_item/synthesizer/dessert/pink_donut
	name = "Donut (Pink Frosting)"
	build_path = /obj/item/reagent_containers/food/snacks/donut/pink

/datum/category_item/synthesizer/dessert/homer
	name = "Donut (Sprinkles)"
	build_path = /obj/item/reagent_containers/food/snacks/donut/homer

/datum/category_item/synthesizer/dessert/jelly_donut
	name = "Donut (Jelly)"
	build_path = /obj/item/reagent_containers/food/snacks/donut/plain/jelly

/datum/category_item/synthesizer/dessert/meat_donut
	name = "Donut (Meat)"
	build_path = /obj/item/reagent_containers/food/snacks/donut/meat

/datum/category_item/synthesizer/dessert/chaos_donut
	name = "Donut (Chaos)"
	build_path = /obj/item/reagent_containers/food/snacks/donut/plain
	hidden = TRUE

/datum/category_item/synthesizer/dessert/candyapple
	name = "Candied Apple"
	build_path = /obj/item/reagent_containers/food/snacks/candiedapple

/datum/category_item/synthesizer/dessert/applepie
	name = "Pie (Apple)"
	build_path = /obj/item/reagent_containers/food/snacks/applepie

/datum/category_item/synthesizer/dessert/cherrypie
	name = "Pie (Cherry)"
	build_path = /obj/item/reagent_containers/food/snacks/cherrypie

/datum/category_item/synthesizer/dessert/appletart
	name = "Apple Tart"
	build_path = /obj/item/reagent_containers/food/snacks/appletart

/datum/category_item/synthesizer/dessert/cinnamonbun
	name = "cinnamon bun"
	build_path = /obj/item/reagent_containers/food/snacks/cinnamonbun

/datum/category_item/synthesizer/dessert/tastybread
	name = "Tubular Sweet Bread"
	build_path = /obj/item/reagent_containers/food/snacks/tastybread

/datum/category_item/synthesizer/dessert/carrotcake
	name = "Carrot Cake"
	build_path = /obj/item/reagent_containers/food/snacks/slice/carrotcake/filled

/datum/category_item/synthesizer/dessert/cheesecake
	name = "Cheesecake"
	build_path = /obj/item/reagent_containers/food/snacks/slice/cheesecake/filled

/datum/category_item/synthesizer/dessert/plaincake
	name = "Plain Cake"
	build_path = /obj/item/reagent_containers/food/snacks/slice/plaincake/filled

/datum/category_item/synthesizer/dessert/orangecake
	name = "Orange Cake"
	build_path = /obj/item/reagent_containers/food/snacks/slice/orangecake/filled

/datum/category_item/synthesizer/dessert/limecake
	name = "Lime Cake"
	build_path = /obj/item/reagent_containers/food/snacks/slice/limecake/filled

/datum/category_item/synthesizer/dessert/lemoncake
	name = "Lemon Cake"
	build_path = /obj/item/reagent_containers/food/snacks/slice/lemoncake/filled

/datum/category_item/synthesizer/dessert/chocolatecake
	name = "Chocolate Cake"
	build_path = /obj/item/reagent_containers/food/snacks/slice/chocolatecake/filled

/datum/category_item/synthesizer/dessert/birthdaycake
	name = "Birthday Cake"
	build_path = /obj/item/reagent_containers/food/snacks/slice/birthdaycake/filled

/datum/category_item/synthesizer/dessert/applecake
	name = "Apple Cake"
	build_path = /obj/item/reagent_containers/food/snacks/slice/applecake/filled

/datum/category_item/synthesizer/dessert/pumpkinpie
	name = "Pumpkin Pie"
	build_path = /obj/item/reagent_containers/food/snacks/slice/pumpkinpie/filled

/datum/category_item/synthesizer/dessert/keylimepieslice
	name = "Key Lime Pie"
	build_path = /obj/item/reagent_containers/food/snacks/keylimepieslice/filled

/datum/category_item/synthesizer/dessert/browniesslice
	name = "Brownie"
	build_path = /obj/item/reagent_containers/food/snacks/browniesslice/filled

/datum/category_item/synthesizer/dessert/sugarcookie
	name = "Sugar Cookie"
	build_path = /obj/item/reagent_containers/food/snacks/sugarcookie

/datum/category_item/synthesizer/dessert/custardbun
	name = "Custard Bun"
	build_path = /obj/item/reagent_containers/food/snacks/custardbun

/datum/category_item/synthesizer/dessert/honeybun
	name = "Honey Bun"
	build_path = /obj/item/reagent_containers/food/snacks/honeybun

/datum/category_item/synthesizer/dessert/cookie
	name = "Cookie"
	build_path = /obj/item/reagent_containers/food/snacks/cookie

/datum/category_item/synthesizer/dessert/fruitbar
	name = "Fruit Bar"
	build_path = /obj/item/reagent_containers/food/snacks/fruitbar

/datum/category_item/synthesizer/dessert/pie
	name = "Plain Pie"
	build_path = /obj/item/reagent_containers/food/snacks/pie

/datum/category_item/synthesizer/dessert/amanita_pie
	name = "Amanita Pie"
	build_path = /obj/item/reagent_containers/food/snacks/amanita_pie

/datum/category_item/synthesizer/dessert/funnelcake
	name = "Funnel Cake"
	build_path = /obj/item/reagent_containers/food/snacks/funnelcake

/datum/category_item/synthesizer/dessert/brownie
	name = "brownie"
	build_path = /obj/item/reagent_containers/food/snacks/browniesslice

/datum/category_item/synthesizer/dessert/icecreamsandwich
	name = "Ice Cream Sandwich"
	build_path = /obj/item/reagent_containers/food/snacks/icecreamsandwich

/datum/category_item/synthesizer/dessert/pisanggoreng
	name = "Pisang Goreng"
	build_path = /obj/item/reagent_containers/food/snacks/pisanggoreng

/datum/category_item/synthesizer/dessert/ricepudding
	name = "Rice Pudding"
	build_path = /obj/item/reagent_containers/food/snacks/ricepudding

/datum/category_item/synthesizer/dessert/mammi
	name = "Mämmi"
	build_path = /obj/item/reagent_containers/food/snacks/mammi


/*********
* Exotic *
**********/

/datum/category_item/synthesizer/exotic/hatchling_suprise
	name = "Hatchling Suprise"
	build_path = /obj/item/reagent_containers/food/snacks/hatchling_suprise

/datum/category_item/synthesizer/exotic/red_sun_special
	name = "Red Sun Special"
	build_path = /obj/item/reagent_containers/food/snacks/red_sun_special

/datum/category_item/synthesizer/exotic/riztizkzi_sea
	name = "Moghesian Sea Delight"
	build_path = /obj/item/reagent_containers/food/snacks/riztizkzi_sea

/datum/category_item/synthesizer/exotic/father_breakfast
	name = "Fatherly Breakfast"
	build_path = /obj/item/reagent_containers/food/snacks/father_breakfast

/datum/category_item/synthesizer/exotic/bearburger
	name = "Bear Burger"
	build_path = /obj/item/reagent_containers/food/snacks/bearburger

/datum/category_item/synthesizer/exotic/roburger
	name = "Roburger"
	build_path = /obj/item/reagent_containers/food/snacks/roburger

/datum/category_item/synthesizer/exotic/spellburger
	name = "Magicburger"
	build_path = /obj/item/reagent_containers/food/snacks/spellburger

/datum/category_item/synthesizer/exotic/namagashi
	name = "Ryo-kucha Namagashi"
	build_path = /obj/item/reagent_containers/food/snacks/namagashi

/datum/category_item/synthesizer/exotic/dionaroast
	name = "Diona Roast"
	build_path = /obj/item/reagent_containers/food/snacks/dionaroast

/datum/category_item/synthesizer/exotic/burnedmess
	name = "Dubious Food"
	build_path = /obj/item/reagent_containers/food/snacks/badrecipe

/datum/category_item/synthesizer/exotic/monkeydelight
	name = "Monkey's Delight"
	build_path = /obj/item/reagent_containers/food/snacks/monkeysdelight

/datum/category_item/synthesizer/exotic/monkeycube
	name = "Imitation Monkey Cube"
	build_path = /obj/item/reagent_containers/food/snacks/monkeycube

/datum/category_item/synthesizer/exotic/xenopie
	name = "Pie (Xeno)"
	build_path = /obj/item/reagent_containers/food/snacks/xemeatpie

/datum/category_item/synthesizer/exotic/xenobreadslice
	name = "Xeno Bread (Slice)"
	build_path = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread

/datum/category_item/synthesizer/exotic/wingfangchu
	name = "Wing Fang Chu"
	build_path = /obj/item/reagent_containers/food/snacks/wingfangchu

/datum/category_item/synthesizer/exotic/liquidfood
	name = "Liquid Ration (Generic)"
	build_path = /obj/item/reagent_containers/food/snacks/liquidfood

/datum/category_item/synthesizer/exotic/liquidprotein
	name = "Liquid Ration (Protein)"
	build_path = /obj/item/reagent_containers/food/snacks/liquidprotein

/datum/category_item/synthesizer/exotic/liquidvitamin
	name = "Liquid Ration (Vitamin)"
	build_path = /obj/item/reagent_containers/food/snacks/liquidvitamin

/*****************
 * FOOKIN RAAAWH *
 *****************/

/datum/category_item/synthesizer/raw/meat
	name = "Meat Steak (raw)"
	build_path = /obj/item/reagent_containers/food/snacks/meat

/datum/category_item/synthesizer/raw/monkfishfillet
	name = "monkfish fillet"
	build_path = /obj/item/reagent_containers/food/snacks/monkfishfillet

/datum/category_item/synthesizer/raw/cuttlefish
	name = "raw cuttlefish"
	build_path = /obj/item/reagent_containers/food/snacks/cuttlefish

/datum/category_item/synthesizer/raw/lobster
	name = "raw lobster"
	build_path = /obj/item/reagent_containers/food/snacks/lobster

/datum/category_item/synthesizer/raw/sharkmeat
	name = "slice of sharkmeat"
	build_path = /obj/item/reagent_containers/food/snacks/carpmeat/fish/sharkmeat

/datum/category_item/synthesizer/raw/bacon
	name = "Bacon (raw)"
	build_path = /obj/item/reagent_containers/food/snacks/rawbacon

/datum/category_item/synthesizer/raw/mushroom
	name = "Mushroom Slice"
	build_path = /obj/item/reagent_containers/food/snacks/mushroomslice

/datum/category_item/synthesizer/raw/tomato
	name = "Tomato Steak (raw)"
	build_path = /obj/item/reagent_containers/food/snacks/tomatomeat

/datum/category_item/synthesizer/raw/bear
	name = "Bear Steak (raw)"
	build_path = /obj/item/reagent_containers/food/snacks/bearmeat

/datum/category_item/synthesizer/raw/xeno
	name = "Xeno Steak (raw)"
	build_path = /obj/item/reagent_containers/food/snacks/xenomeat

/datum/category_item/synthesizer/raw/spider
	name = "Spider Steak (raw)"
	build_path = /obj/item/reagent_containers/food/snacks/xenomeat/spidermeat

/datum/category_item/synthesizer/raw/spahgetti
	name = "Spaghetti (raw)"
	build_path = /obj/item/reagent_containers/food/snacks/spagetti

/datum/category_item/synthesizer/raw/corgi
	name = "Corgi Steak (raw)"
	build_path = /obj/item/reagent_containers/food/snacks/meat/corgi
	hidden = TRUE

/datum/category_item/synthesizer/raw/grub
	name = "grub"
	build_path = /obj/item/reagent_containers/food/snacks/grub

/datum/category_item/synthesizer/raw/waferblock
	name = "Nutrient paste wafer"
	build_path = /obj/item/reagent_containers/food/snacks/synthsized_meal

/datum/category_item/synthesizer/raw/wafercrewblock
	name = "Generic Crew Cookie"
	build_path = /obj/item/reagent_containers/food/snacks/synthsized_meal/crewblock

/*********
* Crew Cookie *
**********/
/datum/category_item/synthesizer/crew/crewcookie
	name = "Generic Crew Cookie"
	build_path = /obj/item/reagent_containers/food/snacks/synthsized_meal/crewblock

/datum/category_item/synthesizer/dd_SortValue()
	return name
