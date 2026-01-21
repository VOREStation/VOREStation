
//Original Casino Code created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 for use with VOREstation

//
//The code for Casino Vendors
//Devs Feel free to modify this to vend what you please
//

//
//Locked Vendors (require access to use)
//
/obj/machinery/vending/deluxe_boozeomat
	name = "Premium Drink Distributor"
	desc = "A top of the line drink vendor that carries some of the finest drinks in the frontier."
	icon = 'icons/obj/casino.dmi'
	icon_state = "premiumbooze"
	products = list(/obj/item/glass_extra/stick = 50,
					/obj/item/glass_extra/straw = 50,
					/obj/item/food/drinks/glass2/square = 25,
					/obj/item/food/drinks/glass2/rocks = 25,
					/obj/item/food/drinks/glass2/shake = 25,
					/obj/item/food/drinks/glass2/cocktail = 25,
					/obj/item/food/drinks/glass2/shot = 25,
					/obj/item/food/drinks/glass2/pint = 25,
					/obj/item/food/drinks/glass2/mug = 25,
					/obj/item/food/drinks/glass2/wine = 25,
					/obj/item/food/drinks/glass2/carafe = 2,
					/obj/item/food/drinks/glass2/pitcher = 2,
					/obj/item/food/drinks/metaglass = 25,
					/obj/item/food/drinks/metaglass/metapint = 25,
					/obj/item/food/drinks/bottle/gin = 10,
					/obj/item/food/drinks/bottle/absinthe = 10,
					/obj/item/food/drinks/bottle/bluecuracao = 10,
					/obj/item/food/drinks/bottle/cognac = 10,
					/obj/item/food/drinks/bottle/grenadine = 10,
					/obj/item/food/drinks/bottle/kahlua = 10,
					/obj/item/food/drinks/bottle/melonliquor = 10,
					/obj/item/food/drinks/bottle/rum = 10,
					/obj/item/food/drinks/bottle/sake = 10,
					/obj/item/food/drinks/bottle/specialwhiskey = 10,
					/obj/item/food/drinks/bottle/tequila = 10,
					/obj/item/food/drinks/bottle/vermouth = 10,
					/obj/item/food/drinks/bottle/vodka = 10,
					/obj/item/food/drinks/bottle/whiskey = 10,
					/obj/item/food/drinks/bottle/wine = 10,
					/obj/item/food/drinks/bottle/redeemersbrew = 10,
					/obj/item/food/drinks/bottle/patron = 10,
					/obj/item/food/drinks/bottle/goldschlager = 10,
					/obj/item/food/drinks/bottle/champagne = 10,
					/obj/item/food/drinks/bottle/bottleofnothing = 10,
					/obj/item/food/drinks/bottle/holywater = 10,
					/obj/item/food/drinks/bottle/small/ale = 15,
					/obj/item/food/drinks/bottle/small/ale/hushedwhisper = 15,
					/obj/item/food/drinks/bottle/small/beer = 15,
					/obj/item/food/drinks/bottle/small/beer/silverdragon = 15,
					/obj/item/food/drinks/bottle/small/beer/meteor = 15,
					/obj/item/food/drinks/bottle/small/litebeer = 15,
					/obj/item/food/drinks/bottle/small/cider = 15,
					/obj/item/food/drinks/cans/tonic = 50,
					/obj/item/food/drinks/cans/gingerale = 50,
					/obj/item/food/drinks/cans/sodawater = 50,
					/obj/item/food/drinks/tea = 50,
					/obj/item/food/drinks/bottle/cola = 15,
					/obj/item/food/drinks/bottle/space_up = 15,
					/obj/item/food/drinks/bottle/space_mountain_wind = 15,
					/obj/item/food/drinks/bottle/orangejuice = 10,
					/obj/item/food/drinks/bottle/tomatojuice = 10,
					/obj/item/food/drinks/bottle/limejuice = 10,
					/obj/item/food/drinks/bottle/lemonjuice = 10,
					/obj/item/food/drinks/bottle/applejuice = 10,
					/obj/item/food/drinks/bottle/milk = 10,
					/obj/item/food/drinks/bottle/cream = 10,
					/obj/item/food/drinks/ice = 10
					)

	contraband = list()
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_access = list(ACCESS_BAR)
	req_log_access = ACCESS_BAR
	has_logs = 1
	vending_sound = "machines/vending/vending_cans.ogg"

/obj/machinery/vending/deluxe_dinner
	name = "Premium Dining Distributor"
	desc = "A top of the line drink vendor that carries some of the finest foods in the frontier."
	icon = 'icons/obj/casino.dmi'
	icon_state = "premiumfood"
	products = list(/obj/item/food/bigbiteburger = 30,
					/obj/item/food/meatsteak = 30,
					/obj/item/food/fries = 30,
					/obj/item/food/onionrings = 30,
					/obj/item/food/cheeseburrito= 30,
					/obj/item/food/enchiladas= 30,
					/obj/item/food/meatburrito= 30,
					/obj/item/food/taco= 30,
					/obj/item/food/cheesenachos= 30,
					/obj/item/food/cubannachos= 30,
					/obj/item/food/stew= 20,
					/obj/item/food/roastbeef = 20,
					/obj/item/food/aesirsalad = 20,
					/obj/item/food/sliceable/sushi = 20,
					/obj/item/food/kitsuneudon = 20,
					/obj/item/food/baguette = 30,
					/obj/item/food/appletart = 30,
					/obj/item/food/muffin = 30,
					/obj/item/food/berrymuffin = 30,
					/obj/item/food/cherrypie = 30,
					/obj/item/food/croissant = 30,
					/obj/item/food/pie = 30,
					/obj/item/food/poppypretzel = 30,
					/obj/item/food/sugarcookie = 30,
					/obj/item/food/waffles = 30,
					/obj/item/food/sliceable/applecake = 2,
					/obj/item/food/sliceable/birthdaycake = 2,
					/obj/item/food/sliceable/carrotcake = 2,
					/obj/item/food/sliceable/cheesecake = 2,
					/obj/item/food/sliceable/chocolatecake = 2,
					/obj/item/food/sliceable/lemoncake = 2,
					/obj/item/food/sliceable/limecake = 2,
					/obj/item/food/sliceable/orangecake = 2,
					/obj/item/food/sliceable/plaincake = 2
					)

	contraband = list()
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_access = list(ACCESS_BAR)
	req_log_access = ACCESS_BAR
	has_logs = 1
	vending_sound = "machines/vending/vending_cans.ogg"

/obj/machinery/vending/deluxe_cigs
	name = "Premium Tobacco Distributor"
	desc = "A top of the line smokes vendor that carries some of the finest tobacco based goods in the frontier."
	icon = 'icons/obj/casino.dmi'
	icon_state = "premiumcigs"
	products = list(/obj/item/storage/fancy/cigar = 15,
					/obj/item/storage/fancy/cigarettes/carcinomas = 15,
					/obj/item/storage/fancy/cigarettes/professionals = 15,
					/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba = 30,
					/obj/item/clothing/mask/smokable/cigarette/cigar/havana = 30,
					/obj/item/storage/box/matches = 5,
					/obj/item/flame/lighter/zippo = 10
					)

	contraband = list()
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_access = list(ACCESS_BAR)
	req_log_access = ACCESS_BAR
	has_logs = 1
	vending_sound = "machines/vending/vending_cans.ogg"

//
//Unlocked Vendors
//
/obj/machinery/vending/deluxe_boozeomat/open
	req_access = null
	req_log_access = null

/obj/machinery/vending/deluxe_dinner/open
	req_access = null
	req_log_access = null

/obj/machinery/vending/deluxe_cigs/open
	req_access = null
	req_log_access = null
