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
			/obj/random/pizzabox = 5,
			/obj/item/material/knife/plastic
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

/datum/supply_pack/randomised/hospitality/
	group = "Hospitality"
