/*
*	Here is where any supply packs related
*		to being hospitable tasks live
*/


/datum/supply_pack/hospitality
	group = "Hospitality"

/datum/supply_pack/hospitality/party
	name = "Party equipment"
	contains = list(
			/obj/item/storage/box/mixedglasses = 2,
			/obj/item/storage/box/glasses/square,
			/obj/item/reagent_containers/food/drinks/shaker,
			/obj/item/reagent_containers/food/drinks/flask/barflask,
			/obj/item/reagent_containers/food/drinks/bottle/patron,
			/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
			/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,
			/obj/item/reagent_containers/food/drinks/bottle/jager,
			/obj/item/storage/fancy/cigarettes/dromedaryco,
			/obj/item/lipstick/random,
			/obj/item/reagent_containers/food/drinks/bottle/small/ale = 2,
			/obj/item/reagent_containers/food/drinks/bottle/small/beer = 4,
			)
	cost = 10
	containertype = /obj/structure/closet/crate/gilthari
	containername = "Party equipment"

/datum/supply_pack/hospitality/barsupplies
	name = "Bar supplies"
	contains = list(
			/obj/item/storage/box/glasses/cocktail,
			/obj/item/storage/box/glasses/rocks,
			/obj/item/storage/box/glasses/square,
			/obj/item/storage/box/glasses/pint,
			/obj/item/storage/box/glasses/wine,
			/obj/item/storage/box/glasses/shake,
			/obj/item/storage/box/glasses/shot,
			/obj/item/storage/box/glasses/mug,
			/obj/item/storage/box/glasses/meta,
			/obj/item/storage/box/glasses/meta/metapint,
			/obj/item/reagent_containers/food/drinks/shaker,
			/obj/item/storage/box/glass_extras/straws,
			/obj/item/storage/box/glass_extras/sticks
			)
	cost = 10
	containertype = /obj/structure/closet/crate/gilthari
	containername = "crate of bar supplies"

/datum/supply_pack/hospitality/cookingoil
	name = "Cooking oil tank crate"
	contains = list(/obj/structure/reagent_dispensers/cookingoil)
	cost = 10
	containertype = /obj/structure/largecrate
	containername = "cooking oil tank crate"

/datum/supply_pack/hospitality/pizza
	name = "Surprise pack of five pizzas"
	contains = list(
			/obj/random/pizzabox/supplypack = 5,
			/obj/item/material/knife/plastic,
			/obj/item/clothing/under/pizzaguy,
			/obj/item/clothing/head/pizzaguy
			)
	cost = 15
	containertype = /obj/structure/closet/crate/freezer/centauri
	containername = "Pizza crate"

/datum/supply_pack/hospitality/gifts
	name = "Gift crate"
	contains = list(
		/obj/item/toy/bouquet = 3,
		/obj/item/storage/fancy/heartbox = 2,
		/obj/item/paper/card/smile,
		/obj/item/paper/card/heart,
		/obj/item/paper/card/cat,
		/obj/item/paper/card/flower
		)
	cost = 10
	containertype = /obj/structure/closet/crate/allico
	containername = "crate of gifts"

/datum/supply_pack/hospitality/painting
	name = "Painting equipment"
	contains = list(
		/obj/item/paint_brush = 2,
		/obj/item/paint_palette = 2,
		/obj/item/reagent_containers/glass/rag = 2,
		/obj/structure/easel = 1, // How does that even fit
		/obj/item/canvas = 1,
		/obj/item/canvas/nineteen_nineteen = 1,
		/obj/item/canvas/twentyfour_twentyfour = 1,
		/obj/item/canvas/twentythree_nineteen = 1,
		/obj/item/canvas/twentythree_twentythree = 1
	)
	cost = 20
	containertype = /obj/structure/closet/crate/centauri
	containername = "Painting equipment"

/datum/supply_pack/hospitality/holywater
	name = "Holy water crate"
	contains = list(
		/obj/item/reagent_containers/food/drinks/bottle/holywater = 3
		)
	cost = 15
	containertype = /obj/structure/closet/crate/gilthari
	containername = "holy water crate"

/datum/supply_pack/randomised/hospitality/
	group = "Hospitality"

/datum/supply_pack/randomised/hospitality/burgers_vr
	num_contained = 5
	contains = list(
			/obj/item/reagent_containers/food/snacks/bigbiteburger,
			/obj/item/reagent_containers/food/snacks/cheeseburger,
			/obj/item/reagent_containers/food/snacks/jellyburger,
			/obj/item/reagent_containers/food/snacks/tofuburger,
			/obj/item/reagent_containers/food/snacks/fries
			)
	name = "Burger crate"
	cost = 25
	containertype = /obj/structure/closet/crate/freezer
	containername = "Burger crate"
/*
/datum/supply_pack/randomised/hospitality/bakery_vr
	num_contained = 5
	contains = list(
			/obj/item/reagent_containers/food/snacks/baguette,
			/obj/item/reagent_containers/food/snacks/appletart,
			/obj/item/reagent_containers/food/snacks/berrymuffin,
			/obj/item/reagent_containers/food/snacks/bunbun,
			/obj/item/reagent_containers/food/snacks/cherrypie,
			/obj/item/reagent_containers/food/snacks/cookie,
			/obj/item/reagent_containers/food/snacks/croissant,
			/obj/item/reagent_containers/food/snacks/donut/normal,
			/obj/item/reagent_containers/food/snacks/donut/jelly,
			/obj/item/reagent_containers/food/snacks/donut/cherryjelly,
			/obj/item/reagent_containers/food/snacks/muffin,
			/obj/item/reagent_containers/food/snacks/pie,
			/obj/item/reagent_containers/food/snacks/plump_pie,
			/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
			/obj/item/reagent_containers/food/snacks/poppypretzel,
			/obj/item/reagent_containers/food/snacks/sugarcookie,
			/obj/item/reagent_containers/food/snacks/waffles
			)
	name = "Bakery products crate"
	cost = 25
	containertype = /obj/structure/closet/crate/freezer
	containername = "Bakery products crate"

/datum/supply_pack/randomised/hospitality/cakes_vr
	num_contained = 2
	contains = list(
			/obj/item/reagent_containers/food/snacks/sliceable/applecake,
			/obj/item/reagent_containers/food/snacks/sliceable/birthdaycake,
			/obj/item/reagent_containers/food/snacks/sliceable/carrotcake,
			/obj/item/reagent_containers/food/snacks/sliceable/cheesecake,
			/obj/item/reagent_containers/food/snacks/sliceable/chocolatecake,
			/obj/item/reagent_containers/food/snacks/sliceable/lemoncake,
			/obj/item/reagent_containers/food/snacks/sliceable/limecake,
			/obj/item/reagent_containers/food/snacks/sliceable/orangecake,
			/obj/item/reagent_containers/food/snacks/sliceable/plaincake
			)
	name = "Cake crate"
	cost = 100
	containertype = /obj/structure/closet/crate/freezer
	containername = "Cake crate"

/datum/supply_pack/randomised/hospitality/mexican_vr
	num_contained = 5
	contains = list(
			/obj/item/reagent_containers/food/snacks/cheeseburrito,
			/obj/item/reagent_containers/food/snacks/enchiladas,
			/obj/item/reagent_containers/food/snacks/meatburrito,
			/obj/item/reagent_containers/food/snacks/taco
			)
	name = "Mexican takeout crate"
	cost = 50
	containertype = /obj/structure/closet/crate/freezer
	containername = "Mexican takeout crate"
*/
/datum/supply_pack/randomised/hospitality/asian_vr
	num_contained = 5
	contains = list(
			/obj/item/reagent_containers/food/snacks/generalschicken,
			/obj/item/reagent_containers/food/snacks/hotandsoursoup
			)
	name = "Chinese takeout crate"
	cost = 50
	containertype = /obj/structure/closet/crate/freezer
	containername = "Chinese takeout crate"

/datum/supply_pack/randomised/hospitality/jaffacake
	contains = list(
		/obj/item/storage/box/jaffacake,
		/obj/item/storage/box/jaffacake,
		/obj/item/storage/box/jaffacake,
		/obj/item/storage/box/jaffacake,
		/obj/item/storage/box/jaffacake,
		/obj/item/storage/box/jaffacake,
		/obj/item/storage/box/jaffacake,
		/obj/item/storage/box/jaffacake,
		/obj/item/storage/box/jaffacake,
		/obj/item/storage/box/jaffacake
		)
	name = "Desatti jaffa cake crate"
	cost = 25
	containertype = /obj/structure/closet/crate/freezer
	containername = "Desatti jaffa cake crate"

/datum/supply_pack/randomised/hospitality/sweets
	num_contained = 5
	contains = list(
			/obj/item/storage/box/jaffacake,
			/obj/item/storage/box/winegum,
			/obj/item/storage/box/saucer,
			/obj/item/storage/box/shrimpsandbananas,
			/obj/item/storage/box/rhubarbcustard
			)
	name = "Sweets crate"
	cost = 25
	containertype = /obj/structure/closet/crate/freezer
	containername = "Sweets crate"
