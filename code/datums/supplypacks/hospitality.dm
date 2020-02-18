/*
*	Here is where any supply packs related
*		to being hospitable tasks live
*/


/datum/supply_pack/hospitality
	group = "Hospitality"

/datum/supply_pack/hospitality/party
	name = "Party equipment"
	contains = list(
			/obj/item/weapon/storage/box/mixedglasses = 2,
			/obj/item/weapon/storage/box/glasses/square,
			/obj/item/weapon/reagent_containers/food/drinks/shaker,
			/obj/item/weapon/reagent_containers/food/drinks/flask/barflask,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/patron,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey,
			/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
			/obj/item/weapon/lipstick/random,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale = 2,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer = 4,
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Party equipment"

/datum/supply_pack/hospitality/barsupplies
	name = "Bar supplies"
	contains = list(
			/obj/item/weapon/storage/box/glasses/cocktail,
			/obj/item/weapon/storage/box/glasses/rocks,
			/obj/item/weapon/storage/box/glasses/square,
			/obj/item/weapon/storage/box/glasses/pint,
			/obj/item/weapon/storage/box/glasses/wine,
			/obj/item/weapon/storage/box/glasses/shake,
			/obj/item/weapon/storage/box/glasses/shot,
			/obj/item/weapon/storage/box/glasses/mug,
			/obj/item/weapon/storage/box/glasses/meta,
			/obj/item/weapon/reagent_containers/food/drinks/shaker,
			/obj/item/weapon/storage/box/glass_extras/straws,
			/obj/item/weapon/storage/box/glass_extras/sticks
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "crate of bar supplies"

/datum/supply_pack/randomised/hospitality/
	group = "Hospitality"

/datum/supply_pack/randomised/hospitality/pizza
	num_contained = 5
	contains = list(
			/obj/item/pizzabox/margherita,
			/obj/item/pizzabox/mushroom,
			/obj/item/pizzabox/meat,
			/obj/item/pizzabox/vegetable,
			/obj/item/pizzabox/pineapple
			)
	name = "Surprise pack of five pizzas"
	cost = 15
	containertype = /obj/structure/closet/crate/freezer
	containername = "Pizza crate"

/datum/supply_pack/hospitality/gifts
	name = "Gift crate"
	contains = list(
		/obj/item/toy/bouquet = 3,
		/obj/item/weapon/storage/fancy/heartbox = 2,
		/obj/item/weapon/paper/card/smile,
		/obj/item/weapon/paper/card/heart,
		/obj/item/weapon/paper/card/cat,
		/obj/item/weapon/paper/card/flower
		)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "crate of gifts"