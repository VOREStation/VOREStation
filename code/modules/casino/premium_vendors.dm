
//Original Casino Code created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 for use with VOREstation

//
//The code for Casino Vendors
//Devs Feel free to modify this to vend what you please
//

/obj/machinery/vending/deluxe_boozeomat
	name = "Premium Drink Distributor"
	desc = "A top of the line drink vendor that carries some of the finest drinks."
	icon = 'icons/obj/casino.dmi'
	icon_state = "premiumbooze"
	products = list(/obj/item/weapon/glass_extra/stick = 50,
					/obj/item/weapon/glass_extra/straw = 50,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/square = 25,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/rocks = 25,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/shake = 25,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail = 25,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/shot = 25,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/pint = 25,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/mug = 25,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/wine = 25,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/carafe = 2,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/pitcher = 2,
					/obj/item/weapon/reagent_containers/food/drinks/metaglass = 25,
					/obj/item/weapon/reagent_containers/food/drinks/metaglass/metapint = 25,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/gin = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/bluecuracao = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/grenadine = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/rum = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/sake = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/wine = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/redeemersbrew = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/patron = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/champagne = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale/hushedwhisper = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer/silverdragon = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer/meteor = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/litebeer = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/cider = 15,
					/obj/item/weapon/reagent_containers/food/drinks/cans/tonic = 50,
					/obj/item/weapon/reagent_containers/food/drinks/cans/gingerale = 50,
					/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater = 50,
					/obj/item/weapon/reagent_containers/food/drinks/tea = 50,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cola = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/space_up = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/space_mountain_wind = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/lemonjuice = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/applejuice = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/milk = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 10,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 10
					)

	contraband = list()
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_access = list(access_bar)
	req_log_access = access_bar
	has_logs = 1
	vending_sound = "machines/vending/vending_cans.ogg"

/obj/machinery/vending/deluxe_dinner
	name = "Premium Dining Distributor"
	desc = "A top of the line drink vendor that carries some of the finest foods in the frontier."
	icon = 'icons/obj/casino.dmi'
	icon_state = "premiumfood"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger = 30,
					/obj/item/weapon/reagent_containers/food/snacks/meatsteak = 30,
					/obj/item/weapon/reagent_containers/food/snacks/fries = 30,
					/obj/item/weapon/reagent_containers/food/snacks/onionrings = 30,
					/obj/item/weapon/reagent_containers/food/snacks/cheeseburrito= 30,
					/obj/item/weapon/reagent_containers/food/snacks/enchiladas= 30,
					/obj/item/weapon/reagent_containers/food/snacks/meatburrito= 30,
					/obj/item/weapon/reagent_containers/food/snacks/taco= 30,
					/obj/item/weapon/reagent_containers/food/snacks/cheesenachos= 30,
					/obj/item/weapon/reagent_containers/food/snacks/cubannachos= 30,
					/obj/item/weapon/reagent_containers/food/snacks/stew= 20,
					/obj/item/weapon/reagent_containers/food/snacks/roastbeef = 20,
					/obj/item/weapon/reagent_containers/food/snacks/aesirsalad = 20,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/sushi = 20,
					/obj/item/weapon/reagent_containers/food/snacks/kitsuneudon = 20,
					/obj/item/weapon/reagent_containers/food/snacks/baguette = 30,
					/obj/item/weapon/reagent_containers/food/snacks/appletart = 30,
					/obj/item/weapon/reagent_containers/food/snacks/muffin = 30,
					/obj/item/weapon/reagent_containers/food/snacks/berrymuffin = 30,
					/obj/item/weapon/reagent_containers/food/snacks/cherrypie = 30,
					/obj/item/weapon/reagent_containers/food/snacks/croissant = 30,
					/obj/item/weapon/reagent_containers/food/snacks/pie = 30,
					/obj/item/weapon/reagent_containers/food/snacks/poppypretzel = 30,
					/obj/item/weapon/reagent_containers/food/snacks/sugarcookie = 30,
					/obj/item/weapon/reagent_containers/food/snacks/waffles = 30,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/lemoncake = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/limecake = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/orangecake = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake = 2
					)

	contraband = list()
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_access = list(access_bar)
	req_log_access = access_bar
	has_logs = 1
	vending_sound = "machines/vending/vending_cans.ogg"