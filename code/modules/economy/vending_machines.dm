//
//The code for machines are in vending.dm
//Only put machines here.
//
//


/*
 * Vending machine types
 */

/*

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 15
	products = list()
	contraband = list()
	premium = list()

*/

/*
/obj/machinery/vending/atmospherics //Commenting this out until someone ponies up some actual working, broken, and unpowered sprites - Quarxink
	name = "Tank Vendor"
	desc = "A vendor with a wide variety of masks and gas tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	product_paths = "/obj/item/tank/oxygen;/obj/item/tank/phoron;/obj/item/tank/emergency_oxygen;/obj/item/tank/emergency_oxygen/engi;/obj/item/clothing/mask/breath"
	productamounts = "10;10;10;5;25"
	vend_delay = 0
*/



/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, the ads would have you believe this is able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"
	products = list(/obj/item/reagent_containers/food/drinks/glass2/square = 10,
					/obj/item/reagent_containers/food/drinks/glass2/rocks = 10,
					/obj/item/reagent_containers/food/drinks/glass2/shake = 10,
					/obj/item/reagent_containers/food/drinks/glass2/cocktail = 10,
					/obj/item/reagent_containers/food/drinks/glass2/shot = 10,
					/obj/item/reagent_containers/food/drinks/glass2/pint = 10,
					/obj/item/reagent_containers/food/drinks/glass2/mug = 10,
					/obj/item/reagent_containers/food/drinks/glass2/carafe = 2,	//VOREStation Add - Carafes and Pitchers
					/obj/item/reagent_containers/food/drinks/glass2/pitcher = 2,	//VOREStation Add - Carafes and Pitchers
					/obj/item/reagent_containers/food/drinks/glass2/wine = 10,
					/obj/item/reagent_containers/food/drinks/bottle/whitewine = 5,
					/obj/item/reagent_containers/food/drinks/bottle/grapejuice = 5,
					/obj/item/reagent_containers/food/drinks/metaglass = 10,
					/obj/item/reagent_containers/food/drinks/metaglass/metapint = 10,
					/obj/item/reagent_containers/glass/beaker/stopperedbottle = 10,
					/obj/item/reagent_containers/food/drinks/bottle/gin = 5,
					/obj/item/reagent_containers/food/drinks/bottle/absinthe = 5,
					/obj/item/reagent_containers/food/drinks/bottle/bluecuracao = 5,
					/obj/item/reagent_containers/food/drinks/bottle/cognac = 5,
					/obj/item/reagent_containers/food/drinks/bottle/grenadine = 5,
					/obj/item/reagent_containers/food/condiment/cookingoil = 5,
					/obj/item/reagent_containers/food/condiment/cornoil = 5,
					/obj/item/reagent_containers/food/drinks/bottle/kahlua = 5,
					/obj/item/reagent_containers/food/drinks/bottle/melonliquor = 5,
					/obj/item/reagent_containers/food/drinks/bottle/peppermintschnapps = 5,
					/obj/item/reagent_containers/food/drinks/bottle/peachschnapps = 5,
					/obj/item/reagent_containers/food/drinks/bottle/lemonadeschnapps = 5,
					/obj/item/reagent_containers/food/drinks/bottle/rum = 5,
					/obj/item/reagent_containers/food/drinks/bottle/sake = 5,
					/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey = 5,
					/obj/item/reagent_containers/food/drinks/bottle/tequila = 5,
					/obj/item/reagent_containers/food/drinks/bottle/vermouth = 5,
					/obj/item/reagent_containers/food/drinks/bottle/vodka = 5,
					/obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
					/obj/item/reagent_containers/food/drinks/bottle/wine = 5,
					/obj/item/reagent_containers/food/drinks/bottle/jager = 5,
					/obj/item/reagent_containers/food/drinks/bottle/small/ale = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/ale/hushedwhisper = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/beer = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/beer/silverdragon = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/beer/meteor = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/litebeer = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/cider = 15,
					/obj/item/reagent_containers/food/drinks/cans/beercan = 15,
					/obj/item/reagent_containers/food/drinks/cans/alecan = 15,
					/obj/item/reagent_containers/food/drinks/bottle/orangejuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/tomatojuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/limejuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/lemonjuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/applejuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/milk = 5,
					/obj/item/reagent_containers/food/drinks/bottle/cream = 5,
					/obj/item/reagent_containers/food/drinks/bottle/cola = 5,
					/obj/item/reagent_containers/food/drinks/bottle/decaf_cola = 5,
					/obj/item/reagent_containers/food/drinks/bottle/space_up = 5,
					/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind = 5,
					/obj/item/reagent_containers/food/drinks/bottle/dr_gibb = 5,
					/obj/item/reagent_containers/food/drinks/bottle/small/cola = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/space_up = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/space_mountain_wind = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/dr_gibb = 15,
					/obj/item/reagent_containers/food/drinks/cans/sodawater = 15,
					/obj/item/reagent_containers/food/drinks/cans/tonic = 15,
					/obj/item/reagent_containers/food/drinks/cans/gingerale = 15,
					/obj/item/reagent_containers/food/drinks/flask/barflask = 5,
					/obj/item/reagent_containers/food/drinks/flask/vacuumflask = 5,
					/obj/item/reagent_containers/food/drinks/ice = 10,
					/obj/item/reagent_containers/food/drinks/tea = 15,
					/obj/item/glass_extra/stick = 30,
					/obj/item/glass_extra/straw = 30)
	contraband = list()
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this station?"
	product_ads = "Drink up!;Booze is good for you!;Alcohol is humanity's best friend.;Quite delighted to serve you!;Care for a nice, cold beer?;Nothing cures you like booze!;Have a sip!;Have a drink!;Have a beer!;Beer is good for you!;Only the finest alcohol!;Best quality booze since 2053!;Award-winning wine!;Maximum alcohol!;Man loves beer.;A toast for progress!"
	req_access = list(access_bar)
	req_log_access = access_bar
	has_logs = 1
	vending_sound = "machines/vending/vending_cans.ogg"

/obj/machinery/vending/boozeomat/virgin
	name = "Virgin-O-Mat"
	products = list(/obj/item/reagent_containers/food/drinks/glass2/square = 10,
					/obj/item/reagent_containers/food/drinks/glass2/rocks = 10,
					/obj/item/reagent_containers/food/drinks/glass2/shake = 10,
					/obj/item/reagent_containers/food/drinks/glass2/cocktail = 10,
					/obj/item/reagent_containers/food/drinks/glass2/shot = 10,
					/obj/item/reagent_containers/food/drinks/glass2/pint = 10,
					/obj/item/reagent_containers/food/drinks/glass2/mug = 10,
					/obj/item/reagent_containers/food/drinks/glass2/carafe = 2,	//VOREStation Add - Carafes and Pitchers
					/obj/item/reagent_containers/food/drinks/glass2/pitcher = 2,	//VOREStation Add - Carafes and Pitchers
					/obj/item/reagent_containers/food/drinks/glass2/wine = 10,
					/obj/item/reagent_containers/food/drinks/bottle/whitewine = 5,
					/obj/item/reagent_containers/food/drinks/bottle/grapejuice = 5,
					/obj/item/reagent_containers/food/drinks/metaglass = 10,
					/obj/item/reagent_containers/food/drinks/metaglass/metapint = 10,
					/obj/item/reagent_containers/glass/beaker/stopperedbottle = 10,
					/obj/item/reagent_containers/food/drinks/bottle/grenadine = 5,
					/obj/item/reagent_containers/food/condiment/cookingoil = 5,
					/obj/item/reagent_containers/food/condiment/cornoil = 5,
					/obj/item/reagent_containers/food/drinks/bottle/orangejuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/tomatojuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/limejuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/lemonjuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/applejuice = 5,
					/obj/item/reagent_containers/food/drinks/bottle/milk = 5,
					/obj/item/reagent_containers/food/drinks/bottle/cream = 5,
					/obj/item/reagent_containers/food/drinks/bottle/cola = 5,
					/obj/item/reagent_containers/food/drinks/bottle/decaf_cola = 5,
					/obj/item/reagent_containers/food/drinks/bottle/space_up = 5,
					/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind = 5,
					/obj/item/reagent_containers/food/drinks/bottle/dr_gibb = 5,
					/obj/item/reagent_containers/food/drinks/bottle/small/cola = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/space_up = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/space_mountain_wind = 15,
					/obj/item/reagent_containers/food/drinks/bottle/small/dr_gibb = 15,
					/obj/item/reagent_containers/food/drinks/cans/sodawater = 15,
					/obj/item/reagent_containers/food/drinks/cans/tonic = 15,
					/obj/item/reagent_containers/food/drinks/cans/gingerale = 15,
					/obj/item/reagent_containers/food/drinks/flask/barflask = 5,
					/obj/item/reagent_containers/food/drinks/flask/vacuumflask = 5,
					/obj/item/reagent_containers/food/drinks/ice = 10,
					/obj/item/reagent_containers/food/drinks/tea = 15,
					/obj/item/glass_extra/stick = 30,
					/obj/item/glass_extra/straw = 30)

	product_slogans = "I hope hope someone asks me for a cup o' tea...;Alcohol is humanity's enemy. Would you join a foe?;Quite delighted to serve you!;Is nobody thirsty on this station?"
	product_ads = "Drink up responsibly!;Booze is bad for you!;Alcohol is humanity's worst enemy.;Quite delighted to serve you!;Care for a nice, cold ginger ale?;Nothing cures you like tea!;Have a sip!;Have a drink!;Have a water!;Beer is not good for you!;Only the finest non-alcoholic beverages!;Best quality soft drinks since 2053!;Award-winning lemonade!;Minimum alcohol!;Man loathes beer.;A toast for sobriety!"

/obj/machinery/vending/assist
	products = list(	/obj/item/assembly/prox_sensor = 5,
						/obj/item/assembly/igniter = 3,
						/obj/item/assembly/signaler = 4,
						/obj/item/tool/wirecutters = 1,
						/obj/item/cartridge/signal = 4)
	contraband = list(/obj/item/flashlight = 5,
						/obj/item/assembly/timer = 2)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A Galaksi brand vending machine which dispenses hot drinks."
	description_fluff = "The Ward-Takahashi Galaksi Samovar 55 has been reconstituting hot drinks from their powdered forms since... Well, 2305, but the design has hardly changed in a century or so."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	vend_delay = 34
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(/obj/item/reagent_containers/food/drinks/coffee = 25,
					/obj/item/reagent_containers/food/drinks/decaf = 15,
					/obj/item/reagent_containers/food/drinks/tea = 25,
					/obj/item/reagent_containers/food/drinks/decaf_tea = 25,
					/obj/item/reagent_containers/food/drinks/h_chocolate = 25,
					/obj/item/reagent_containers/food/drinks/greentea = 15,
					/obj/item/reagent_containers/food/drinks/chaitea = 15)
	contraband = list(/obj/item/reagent_containers/food/drinks/ice = 10)
	prices = list(/obj/item/reagent_containers/food/drinks/coffee = 2,
					/obj/item/reagent_containers/food/drinks/decaf = 3,
					/obj/item/reagent_containers/food/drinks/tea = 2,
					/obj/item/reagent_containers/food/drinks/decaf_tea = 2,
					/obj/item/reagent_containers/food/drinks/h_chocolate = 2,
					/obj/item/reagent_containers/food/drinks/greentea = 10,
					/obj/item/reagent_containers/food/drinks/chaitea = 5) // VOREStation Edit - Lowers Coffee/Hot Chocolate/Tea Prices from 3 -> 2.
	vending_sound = "machines/vending/vending_coffee.ogg"

/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, a Centauri Provisions brand."
	description_fluff = "Despite its name, the Getmore Chocolate Corporation does not produce chocolate - or any foods at all. The company exists soley to refit Ward-Takahashi's Galaksi brand vending products to accept Centauri Provisions' massive range of snackfoods, and sell them at a significant markup. Generic vendors are not authorized to vend Centauri products, and their popularity forces the market to Getmore or Get Lost."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Get More with Getmore!;Best quality snacks from Centauri Provisions.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	products = list(/obj/item/reagent_containers/food/snacks/candy = 12,
					/obj/item/reagent_containers/food/snacks/candy/gummy = 12,
					/obj/item/reagent_containers/food/drinks/dry_ramen = 12,
					/obj/item/reagent_containers/food/snacks/chips = 12,
					/obj/item/reagent_containers/food/snacks/chips/bbq = 12,
					/obj/item/reagent_containers/food/snacks/chips/snv = 12,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 12,
					/obj/item/reagent_containers/food/snacks/pistachios = 12,
					/obj/item/reagent_containers/food/snacks/semki = 12,
					/obj/item/reagent_containers/food/snacks/sosjerky = 12,
					/obj/item/reagent_containers/food/snacks/packaged/vendburger = 12,
					/obj/item/reagent_containers/food/snacks/packaged/vendhotdog = 12,
					/obj/item/reagent_containers/food/snacks/packaged/vendburrito = 12,
					/obj/item/reagent_containers/food/snacks/no_raisin = 12,
					/obj/item/reagent_containers/food/snacks/packaged/spacetwinkie = 12,
					/obj/item/reagent_containers/food/snacks/tastybread = 12,
					/obj/item/reagent_containers/food/snacks/skrellsnacks = 6,
					/obj/item/reagent_containers/food/snacks/cookiesnack = 6,
					/obj/item/storage/box/gum = 4,
					/obj/item/clothing/mask/chewable/candy/lolli = 8,
					/obj/item/storage/box/admints = 4,
					/obj/item/reagent_containers/food/snacks/cb01 = 6,
					/obj/item/reagent_containers/food/snacks/cb02 = 6,
					/obj/item/reagent_containers/food/snacks/cb03 = 6,
					/obj/item/reagent_containers/food/snacks/cb04 = 6,
					/obj/item/reagent_containers/food/snacks/cb05 = 6,
					/obj/item/reagent_containers/food/snacks/cb06 = 6,
					/obj/item/reagent_containers/food/snacks/cb07 = 6,
					/obj/item/reagent_containers/food/snacks/cb08 = 6,
					/obj/item/reagent_containers/food/snacks/cb09 = 6,
					/obj/item/reagent_containers/food/snacks/cb10 = 6,
					/obj/item/reagent_containers/food/snacks/tuna = 2)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6,
					/obj/item/reagent_containers/food/snacks/unajerky = 12,
					/obj/item/reagent_containers/food/snacks/canned/brainzsnax = 6)
	prices = list(/obj/item/reagent_containers/food/snacks/candy = 1,
				/obj/item/reagent_containers/food/snacks/candy/gummy = 2,
				/obj/item/reagent_containers/food/drinks/dry_ramen = 5,
				/obj/item/reagent_containers/food/snacks/chips = 1,
				/obj/item/reagent_containers/food/snacks/chips/bbq = 1,
				/obj/item/reagent_containers/food/snacks/chips/snv = 1,
				/obj/item/reagent_containers/food/snacks/cheesiehonkers = 1,
				/obj/item/reagent_containers/food/snacks/pistachios = 1,
				/obj/item/reagent_containers/food/snacks/semki = 1,
				/obj/item/reagent_containers/food/snacks/sosjerky = 2,
				/obj/item/reagent_containers/food/snacks/packaged/vendburger = 7,
				/obj/item/reagent_containers/food/snacks/packaged/vendhotdog = 7,
				/obj/item/reagent_containers/food/snacks/packaged/vendburrito = 7,
				/obj/item/reagent_containers/food/snacks/no_raisin = 1,
				/obj/item/reagent_containers/food/snacks/packaged/spacetwinkie = 1,
				/obj/item/reagent_containers/food/snacks/tastybread = 2,
				/obj/item/reagent_containers/food/snacks/skrellsnacks = 4,
				/obj/item/storage/box/gum = 15,
				/obj/item/clothing/mask/chewable/candy/lolli = 2,
				/obj/item/storage/box/admints = 5,
				/obj/item/reagent_containers/food/snacks/cookiesnack = 20,
				/obj/item/reagent_containers/food/snacks/cb01 = 5,
				/obj/item/reagent_containers/food/snacks/cb02 = 3,
				/obj/item/reagent_containers/food/snacks/cb03 = 5,
				/obj/item/reagent_containers/food/snacks/cb04 = 4,
				/obj/item/reagent_containers/food/snacks/cb05 = 3,
				/obj/item/reagent_containers/food/snacks/cb06 = 7,
				/obj/item/reagent_containers/food/snacks/cb07 = 4,
				/obj/item/reagent_containers/food/snacks/cb08 = 6,
				/obj/item/reagent_containers/food/snacks/cb09 = 10,
				/obj/item/reagent_containers/food/snacks/cb10 = 8,
				/obj/item/reagent_containers/food/snacks/tuna = 23)

/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor graciously provided by NanoTrasen's own vending division."
	description_fluff = "In a genius sales move, the only vendor authorized to dispense 'outside' beverages (at temperatures lower than 30 degrees celcius) aboard NanoTrasen stations... Is NanoTrasen themselves."
	icon_state = "Cola_Machine"
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in the galaxy."
	products = list(/obj/item/reagent_containers/food/drinks/cans/cola = 10,
					/obj/item/reagent_containers/food/drinks/cans/decaf_cola = 10,
					/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 10,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb_diet = 10,
					/obj/item/reagent_containers/food/drinks/cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/cans/starkistdecaf = 10,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 10,
					/obj/item/reagent_containers/food/drinks/cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/cans/iced_tea = 10,
					/obj/item/reagent_containers/food/drinks/cans/grape_juice = 10,
					/obj/item/reagent_containers/food/drinks/cans/gingerale = 10,
					/obj/item/reagent_containers/food/drinks/cans/root_beer = 10)

	contraband = list(/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5,
					/obj/item/reagent_containers/food/snacks/liquidfood = 6)
	prices = list(/obj/item/reagent_containers/food/drinks/cans/cola = 1,
					/obj/item/reagent_containers/food/drinks/cans/decaf_cola = 2,
					/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 1,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb_diet = 1,
					/obj/item/reagent_containers/food/drinks/cans/starkist = 1,
					/obj/item/reagent_containers/food/drinks/cans/starkistdecaf = 1,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 2,
					/obj/item/reagent_containers/food/drinks/cans/space_up = 1,
					/obj/item/reagent_containers/food/drinks/cans/iced_tea = 1,
					/obj/item/reagent_containers/food/drinks/cans/grape_juice = 1,
					/obj/item/reagent_containers/food/drinks/cans/gingerale = 1,
					/obj/item/reagent_containers/food/drinks/cans/root_beer = 1)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vending_sound = "machines/vending/vending_cans.ogg"

/obj/machinery/vending/fitness
	name = "SweatMAX"
	desc = "Fueled by your inner inadequacy!"
	description_fluff = "Provided by NanoMed, SweatMAX promises solutions to all of your problems. Premium gains at premium prices. Resale of SweatMAX products is a violation of NanoTrasen guidelines."
	icon_state = "fitness"
	products = list(/obj/item/reagent_containers/food/drinks/smallmilk = 16,
					/obj/item/reagent_containers/food/drinks/smallchocmilk = 16,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 10,
					/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 8,
					/obj/item/reagent_containers/food/drinks/glass2/fitnessflask = 8,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder = 16,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/vanilla = 16,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/banana = 16,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/chocolate = 16,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/strawberry = 16,
					/obj/item/reagent_containers/food/snacks/candy/proteinbar = 16,
					/obj/item/reagent_containers/food/snacks/fruitbar = 16,
					/obj/item/reagent_containers/food/snacks/liquidfood = 8,
					/obj/item/reagent_containers/food/snacks/liquidvitamin = 8,
					/obj/item/reagent_containers/food/snacks/liquidprotein = 8,
					/obj/item/reagent_containers/pill/diet = 8,
					/obj/item/towel/random = 8,
					/obj/item/toy/tennis = 4)

	prices = list(/obj/item/reagent_containers/food/drinks/smallmilk = 3,
					/obj/item/reagent_containers/food/drinks/smallchocmilk = 3,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 2,
					/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 15,
					/obj/item/reagent_containers/food/drinks/glass2/fitnessflask = 1,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder = 5,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/vanilla = 5,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/banana = 5,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/chocolate = 5,
					/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/strawberry = 5,
					/obj/item/reagent_containers/food/snacks/candy/proteinbar = 5,
					/obj/item/reagent_containers/food/snacks/fruitbar = 5,
					/obj/item/reagent_containers/food/snacks/liquidfood = 5,
					/obj/item/reagent_containers/food/snacks/liquidvitamin = 5,
					/obj/item/reagent_containers/food/snacks/liquidprotein = 5,
					/obj/item/reagent_containers/pill/diet = 25,
					/obj/item/towel/random = 20,
					/obj/item/toy/tennis = 15)

	contraband = list(/obj/item/reagent_containers/syringe/steroid = 4,
						/obj/item/reagent_containers/food/drinks/glass2/fitnessflask/proteanshake = 2,
						/obj/item/toy/baseball = 2) // VOREStation Add - Slurpable blobs.

/obj/machinery/vending/cart
	name = "PTech"
	desc = "Cartridges for PDAs."
	product_slogans = "Carts to go!"
	icon_state = "cart"
	req_access = list(access_hop)
	products = list(/obj/item/cartridge/medical = 10,/obj/item/cartridge/engineering = 10,/obj/item/cartridge/security = 10,
					/obj/item/cartridge/janitor = 10,/obj/item/cartridge/signal/science = 10,/obj/item/pda/heads = 10,
					/obj/item/cartridge/captain = 3,/obj/item/cartridge/quartermaster = 10)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/cigarette
	name = "cigarette machine"
	desc = "If you want to get cancer, might as well do it in style!"
	description_fluff = "As the ease of cancer treatment progressed to the almost routine (if costly) in the 22nd century, the tobacco industry was quick to make sure smoking went back into style. Take your pick, you've got health insurance don't ya, kid?"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	product_ads = "Probably not bad for you!;Don't believe the scientists!;It's good for you!;Don't quit, buy more!;Smoke!;Nicotine heaven.;Best cigarettes since 2150.;Award-winning cigs.;Feeling temperamental? Try a Temperamento!;Carcinoma Angels - go fuck yerself!;Don't be so hard on yourself, kid. Smoke a Lucky Star!"
	vend_delay = 34
	icon_state = "cigs"
	products = list(/obj/item/storage/fancy/cigarettes = 10,
					/obj/item/storage/fancy/cigarettes/dromedaryco = 10,
					/obj/item/storage/fancy/cigarettes/killthroat = 10,
					/obj/item/storage/fancy/cigarettes/luckystars = 10,
					/obj/item/storage/fancy/cigarettes/jerichos = 10,
					/obj/item/storage/fancy/cigarettes/menthols = 10,
					/obj/item/storage/fancy/cigarettes/carcinomas = 10,
					/obj/item/storage/fancy/cigarettes/professionals = 10,
					/obj/item/storage/rollingpapers = 10,
					/obj/item/storage/rollingpapers/blunt = 10,
					/obj/item/storage/chewables/tobacco = 5,
					/obj/item/storage/chewables/tobacco/fine = 5,
					/obj/item/storage/box/matches = 10,
					/obj/item/flame/lighter = 4,
					/obj/item/clothing/mask/smokable/ecig/util = 2,
					///obj/item/clothing/mask/smokable/ecig/deluxe = 2,
					/obj/item/clothing/mask/smokable/ecig/simple = 2,
					/obj/item/reagent_containers/ecig_cartridge/med_nicotine = 10,
					/obj/item/reagent_containers/ecig_cartridge/high_nicotine = 5,
					/obj/item/reagent_containers/ecig_cartridge/orange = 5,
					/obj/item/reagent_containers/ecig_cartridge/mint = 5,
					/obj/item/reagent_containers/ecig_cartridge/watermelon = 5,
					/obj/item/reagent_containers/ecig_cartridge/grape = 5,
					/obj/item/reagent_containers/ecig_cartridge/lemonlime = 5,
					/obj/item/reagent_containers/ecig_cartridge/coffee = 5,
					/obj/item/reagent_containers/ecig_cartridge/blanknico = 2,
					/obj/item/storage/box/fancy/chewables/tobacco/nico = 5)
	contraband = list(/obj/item/flame/lighter/zippo = 4)
	premium = list(/obj/item/storage/fancy/cigar = 5)
	prices = list(/obj/item/storage/fancy/cigarettes = 12,
					/obj/item/storage/fancy/cigarettes/dromedaryco = 20,
					/obj/item/storage/fancy/cigarettes/killthroat = 14,
					/obj/item/storage/fancy/cigarettes/luckystars = 17,
					/obj/item/storage/fancy/cigarettes/jerichos = 22,
					/obj/item/storage/fancy/cigarettes/menthols = 18,
					/obj/item/storage/fancy/cigarettes/carcinomas = 24,
					/obj/item/storage/fancy/cigarettes/professionals = 27,
					/obj/item/storage/rollingpapers = 10,
					/obj/item/storage/rollingpapers/blunt = 20,
					/obj/item/storage/chewables/tobacco = 10,
					/obj/item/storage/chewables/tobacco/fine = 20,
					/obj/item/storage/box/matches = 1,
					/obj/item/flame/lighter/ = 2,
					/obj/item/clothing/mask/smokable/ecig/util = 100,
					///obj/item/clothing/mask/smokable/ecig/deluxe = 300,
					/obj/item/clothing/mask/smokable/ecig/simple = 150,
					/obj/item/reagent_containers/ecig_cartridge/med_nicotine = 10,
					/obj/item/reagent_containers/ecig_cartridge/high_nicotine = 15,
					/obj/item/reagent_containers/ecig_cartridge/orange = 15,
					/obj/item/reagent_containers/ecig_cartridge/mint = 15,
					/obj/item/reagent_containers/ecig_cartridge/watermelon = 15,
					/obj/item/reagent_containers/ecig_cartridge/grape = 15,
					/obj/item/reagent_containers/ecig_cartridge/lemonlime = 15,
					/obj/item/reagent_containers/ecig_cartridge/coffee = 15,
					/obj/item/reagent_containers/ecig_cartridge/blanknico = 15,
					/obj/item/storage/box/fancy/chewables/tobacco/nico = 15)


/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	description_fluff = "NanoMed is NanoTrasen's medical science division, and provides almost all of the modern medbay essentials in-house at no extra charge. By using this vending machine, employees accept liability for products that may or may not be temporarily replaced by placebos or experimental treatments."
	icon_state = "med"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(access_medical)
	products = list(/obj/item/reagent_containers/glass/bottle/antitoxin = 4,
					/obj/item/reagent_containers/glass/bottle/inaprovaline = 4,
					/obj/item/reagent_containers/glass/bottle/stoxin = 4,
					/obj/item/reagent_containers/glass/bottle/toxin = 4,
					/obj/item/reagent_containers/syringe/antiviral = 4,
					/obj/item/reagent_containers/syringe = 12,
					/obj/item/healthanalyzer = 5,
					/obj/item/reagent_containers/glass/beaker = 4,
					/obj/item/reagent_containers/dropper = 2,
					/obj/item/stack/medical/advanced/bruise_pack = 6,
					/obj/item/stack/medical/advanced/ointment = 6,
					/obj/item/stack/medical/splint = 4,
					/obj/item/storage/pill_bottle/carbon = 2,
					/obj/item/clothing/mask/chewable/candy/lolli = 15,
					/obj/item/storage/box/khcrystal = 4,
					/obj/item/backup_implanter = 3,
					/obj/item/clothing/glasses/omnihud/med = 4,
					/obj/item/glasses_kit = 1,
					/obj/item/storage/quickdraw/syringe_case = 4)
	contraband = list(/obj/item/reagent_containers/pill/tox = 3,
					/obj/item/reagent_containers/pill/stox = 4,
					/obj/item/reagent_containers/pill/antitox = 6)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_log_access = access_cmo
	has_logs = 1

/obj/machinery/vending/phoronresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	products = list(/obj/item/clothing/under/rank/scientist = 6,
					/obj/item/clothing/suit/bio_suit = 6,
					/obj/item/clothing/head/bio_hood = 6,
					/obj/item/transfer_valve = 6,
					/obj/item/assembly/timer = 6,
					/obj/item/assembly/signaler = 6,
					/obj/item/assembly/prox_sensor = 6,
					/obj/item/assembly/igniter = 6)
	req_log_access = access_rd
	has_logs = 1

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	description_fluff = "NanoMed is NanoTrasen's medical science division, and provides almost all of the modern medbay essentials in-house at no extra charge. By using this vending machine, employees accept liability for products that may or may not be temporarily replaced by placebos or experimental treatments."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	layer = ABOVE_WINDOW_LAYER
	density = FALSE //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/stack/medical/bruise_pack = 2,
				/obj/item/stack/medical/ointment = 2,
				/obj/item/reagent_containers/hypospray/autoinjector = 4,
				/obj/item/healthanalyzer = 1,
				/obj/item/bodybag/cryobag = 2)
	contraband = list(/obj/item/reagent_containers/syringe/antitoxin = 4,
				/obj/item/reagent_containers/syringe/antiviral = 4,
				/obj/item/reagent_containers/pill/tox = 1)
	req_log_access = access_cmo
	has_logs = 1
	can_rotate = 0

/obj/machinery/vending/wallmed2
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	description_fluff = "NanoMed is NanoTrasen's medical science division, and provides almost all of the modern medbay essentials in-house at no extra charge. By using this vending machine, employees accept liability for products that may or may not be temporarily replaced by placebos or experimental treatments."
	icon_state = "wallmed"
	layer = ABOVE_WINDOW_LAYER
	density = FALSE //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/reagent_containers/hypospray/autoinjector = 5,
				/obj/item/reagent_containers/syringe/antitoxin = 3,
				/obj/item/stack/medical/bruise_pack = 3,
				/obj/item/stack/medical/ointment =3,
				/obj/item/healthanalyzer = 3,
				/obj/item/bodybag/cryobag = 3)
	contraband = list(/obj/item/reagent_containers/pill/tox = 3)
	req_log_access = access_cmo
	has_logs = 1
	can_rotate = 0

/obj/machinery/vending/wallmed1/public
	products = list(/obj/item/stack/medical/bruise_pack = 8,
					/obj/item/stack/medical/ointment = 8,
					/obj/item/reagent_containers/hypospray/autoinjector = 16,
					/obj/item/healthanalyzer = 4,
					/obj/item/bodybag/cryobag = 4)

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	description_fluff = "Security vending is kindly provided by the Lawson Arms company, Hephaestus Industries' law enforcement division."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	req_access = list(access_security)
	products = list(/obj/item/handcuffs = 8,
					/obj/item/grenade/flashbang = 4,
					/obj/item/flash = 5,
					/obj/item/reagent_containers/food/snacks/donut/plain = 6,
					/obj/item/reagent_containers/food/snacks/donut/plain/jelly = 6,
					/obj/item/storage/box/evidence = 6,
					/obj/item/gun/energy/taser = 8,
					/obj/item/gun/energy/stunrevolver = 4,
					/obj/item/reagent_containers/spray/pepper = 6,
					/obj/item/taperoll/police = 6,
					/obj/item/clothing/glasses/omnihud/sec = 6)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,
					/obj/item/storage/box/donut = 2,
					/obj/item/implanter/compliance = 1)
	req_log_access = access_armory
	has_logs = 1

/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor by the NanoPastures company."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri_generic"
	products = list(/obj/item/reagent_containers/glass/bottle/eznutrient = 6,
					/obj/item/reagent_containers/glass/bottle/left4zed = 4,
					/obj/item/reagent_containers/glass/bottle/robustharvest = 3,
					/obj/item/plantspray/pests = 20,
					/obj/item/reagent_containers/syringe = 5,
					/obj/item/reagent_containers/glass/beaker = 4,
					/obj/item/storage/bag/plants = 5)
	premium = list(/obj/item/reagent_containers/glass/bottle/ammonia = 10,
					/obj/item/reagent_containers/glass/bottle/diethylamine = 5)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.


/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = "seeds_generic"

	products = list(/obj/item/seeds/bananaseed = 3,
					/obj/item/seeds/berryseed = 3,
					/obj/item/seeds/carrotseed = 3,
					/obj/item/seeds/chantermycelium = 3,
					/obj/item/seeds/chiliseed = 3,
					/obj/item/seeds/cornseed = 3,
					/obj/item/seeds/eggplantseed = 3,
					/obj/item/seeds/potatoseed = 3,
					/obj/item/seeds/replicapod = 3,
					/obj/item/seeds/soyaseed = 3,
					/obj/item/seeds/sunflowerseed = 3,
					/obj/item/seeds/tomatoseed = 3,
					/obj/item/seeds/towermycelium = 3,
					/obj/item/seeds/wheatseed = 3,
					/obj/item/seeds/appleseed = 3,
					/obj/item/seeds/poppyseed = 3,
					/obj/item/seeds/sugarcaneseed = 3,
					/obj/item/seeds/ambrosiavulgarisseed = 3,
					/obj/item/seeds/peanutseed = 3,
					/obj/item/seeds/whitebeetseed = 3,
					/obj/item/seeds/watermelonseed = 3,
					/obj/item/seeds/lavenderseed = 3,
					/obj/item/seeds/limeseed = 3,
					/obj/item/seeds/lemonseed = 3,
					/obj/item/seeds/orangeseed = 3,
					/obj/item/seeds/grassseed = 3,
					/obj/item/seeds/cocoapodseed = 3,
					/obj/item/seeds/plumpmycelium = 2,
					/obj/item/seeds/cabbageseed = 3,
					/obj/item/seeds/lettuce = 3,
					/obj/item/seeds/grapeseed = 3,
					/obj/item/seeds/pumpkinseed = 3,
					/obj/item/seeds/cherryseed = 3,
					/obj/item/seeds/plastiseed = 3,
					/obj/item/seeds/riceseed = 3,
					/obj/item/seeds/shrinkshroom = 3,
					/obj/item/seeds/megashroom = 3)
	contraband = list(/obj/item/seeds/amanitamycelium = 2,
					/obj/item/seeds/glowshroom = 2,
					/obj/item/seeds/libertymycelium = 2,
					/obj/item/seeds/mtearseed = 2,
					/obj/item/seeds/nettleseed = 2,
					/obj/item/seeds/reishimycelium = 2,
					/obj/item/seeds/reishimycelium = 2,
					/obj/item/seeds/shandseed = 2,)
	premium = list(/obj/item/reagent_containers/spray/waterflower = 1)

/**
 *  Populate hydroseeds product_records
 *
 *  This needs to be customized to fetch the actual names of the seeds, otherwise
 *  the machine would simply list "packet of seeds" times 20
 */
/obj/machinery/vending/hydroseeds/build_inventory()
	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN),
		list(premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/obj/item/seeds/S = new entry(src)
			var/name = S.name
			var/datum/stored_item/vending_product/product = new/datum/stored_item/vending_product(src, entry, name)

			product.price = (entry in prices) ? prices[entry] : 0
			product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product.category = category

			product_records.Add(product)
			GLOB.vending_products[entry] = 1

/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_ads = "FJKLFJSD;AJKFLBJAKL;1234 LOONIES LOL!;>MFW;Kill them fuckers!;GET DAT FUKKEN DISK;HONK!;EI NATH;Destroy the station!;Admin conspiracies since forever!;Space-time bending hardware!"
	products = list(/obj/item/clothing/head/wizard = 1,/obj/item/clothing/suit/wizrobe = 1,/obj/item/clothing/head/wizard/red = 1,/obj/item/clothing/suit/wizrobe/red = 1,/obj/item/clothing/shoes/sandal = 1,/obj/item/staff = 2)

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A WT Galaksi brand kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(
	/obj/item/reagent_containers/food/condiment/yeast = 5,
	/obj/item/reagent_containers/food/condiment/cookingoil = 5,
	/obj/item/tray = 8,
	/obj/item/material/kitchen/utensil/fork = 6,
	/obj/item/material/knife/plastic = 6,
	/obj/item/material/kitchen/utensil/spoon = 6,
	/obj/item/material/knife = 3,
	/obj/item/material/kitchen/rollingpin = 2,
	/obj/item/reagent_containers/food/drinks/glass2/square = 8,
	/obj/item/reagent_containers/food/drinks/glass2/shake = 8,
	/obj/item/glass_extra/stick = 15,
	/obj/item/glass_extra/straw = 15,
	/obj/item/clothing/suit/chef/classic = 2,
	/obj/item/storage/bag/food = 2,
	/obj/item/storage/toolbox/lunchbox = 3,
	/obj/item/storage/toolbox/lunchbox/heart = 3,
	/obj/item/storage/toolbox/lunchbox/cat = 3,
	/obj/item/storage/toolbox/lunchbox/nt = 3,
	/obj/item/storage/toolbox/lunchbox/mars = 3,
	/obj/item/storage/toolbox/lunchbox/cti = 3,
	/obj/item/storage/toolbox/lunchbox/nymph = 3,
	/obj/item/storage/toolbox/lunchbox/syndicate = 3,
	/obj/item/reagent_containers/cooking_container/oven = 5,
	/obj/item/reagent_containers/cooking_container/fryer = 4,
	/obj/item/trash/bowl = 10) //VOREStation Add
	contraband = list(/obj/item/material/knife/butch = 2)

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	//req_access = list(access_maint_tunnels) //Maintenance access
	products = list(/obj/item/stack/cable_coil/random = 10,
					/obj/item/tool/crowbar = 5,
					/obj/item/weldingtool = 3,
					/obj/item/tool/wirecutters = 5,
					/obj/item/tool/wrench = 5,
					/obj/item/analyzer = 5,
					/obj/item/t_scanner = 5,
					/obj/item/tool/screwdriver = 5,
					/obj/item/extinguisher/mini = 3,
					/obj/item/flashlight/glowstick = 3,
					/obj/item/flashlight/glowstick/red = 3,
					/obj/item/flashlight/glowstick/blue = 3,
					/obj/item/flashlight/glowstick/orange =3,
					/obj/item/flashlight/glowstick/yellow = 3,
					/obj/item/reagent_containers/spray/windowsealant = 5)
	contraband = list(/obj/item/weldingtool/hugetank = 2,
					/obj/item/clothing/gloves/fyellow = 2)
	premium = list(/obj/item/clothing/gloves/heavy_engineer = 1) //VOREStation Edit - yellow gloves are common in engineering, let's make "premium" actually mean something
	req_log_access = access_ce
	has_logs = 1

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	req_access = list(access_engine_equip)
	products = list(/obj/item/geiger = 4,
					/obj/item/clothing/glasses/meson = 2,
					/obj/item/multitool = 4,
					/obj/item/cell/high = 10,
					/obj/item/airlock_electronics = 10,
					/obj/item/circuitboard/airlock_cycling = 20,
					/obj/item/module/power_control = 10,
					/obj/item/circuitboard/airalarm = 10,
					/obj/item/circuitboard/firealarm = 10,
					/obj/item/circuitboard/status_display = 2,
					/obj/item/circuitboard/ai_status_display = 2,
					/obj/item/circuitboard/newscaster = 2,
					/obj/item/circuitboard/holopad = 2,
					/obj/item/circuitboard/intercom = 4,
					/obj/item/circuitboard/security/telescreen/entertainment = 4,
					/obj/item/stock_parts/motor = 2,
					/obj/item/stock_parts/spring = 2,
					/obj/item/stock_parts/gear = 2,
					/obj/item/circuitboard/atm,
					/obj/item/circuitboard/guestpass,
					/obj/item/circuitboard/keycard_auth,
					/obj/item/circuitboard/geiger,
					/obj/item/circuitboard/photocopier,
					/obj/item/circuitboard/fax,
					/obj/item/circuitboard/request,
					/obj/item/circuitboard/microwave,
					/obj/item/circuitboard/washing,
					/obj/item/circuitboard/scanner_console,
					/obj/item/circuitboard/sleeper_console,
					/obj/item/circuitboard/body_scanner,
					/obj/item/circuitboard/medical_kiosk,
					/obj/item/circuitboard/sleeper,
					/obj/item/circuitboard/dna_analyzer,
					/obj/item/clothing/glasses/omnihud/eng = 6)
	contraband = list(/obj/item/cell/potato = 3,
						/obj/item/rms = 5)
	premium = list(/obj/item/storage/belt/utility = 3)
	product_records = list()
	req_log_access = access_ce
	has_logs = 1

/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	req_access = list(access_engine_equip)
	products = list(/obj/item/clothing/under/rank/chief_engineer = 4,
					/obj/item/clothing/under/rank/engineer = 4,
					/obj/item/clothing/shoes/orange = 4,
					/obj/item/clothing/head/hardhat = 4,
					/obj/item/storage/belt/utility = 4,
					/obj/item/clothing/glasses/meson = 4,
					/obj/item/clothing/gloves/yellow = 4,
					/obj/item/tool/screwdriver = 12,
					/obj/item/tool/crowbar = 12,
					/obj/item/tool/wirecutters = 12,
					/obj/item/multitool = 12,
					/obj/item/tool/wrench = 12,
					/obj/item/t_scanner = 12,
					/obj/item/stack/cable_coil/heavyduty = 8,
					/obj/item/cell = 8,
					/obj/item/weldingtool = 8,
					/obj/item/clothing/head/welding = 8,
					/obj/item/light/tube = 10,
					/obj/item/clothing/head/hardhat/firefighter = 4,
					/obj/item/clothing/suit/fire/firefighter = 4,
					/obj/item/stock_parts/scanning_module = 5,
					/obj/item/stock_parts/micro_laser = 5,
					/obj/item/stock_parts/matter_bin = 5,
					/obj/item/stock_parts/manipulator = 5,
					/obj/item/stock_parts/console_screen = 5)
	req_log_access = access_ce
	has_logs = 1

/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	req_access = list(access_robotics)
	products = list(/obj/item/clothing/suit/storage/toggle/labcoat = 4,
					/obj/item/clothing/under/rank/roboticist = 4,
					/obj/item/stack/cable_coil = 4,
					/obj/item/flash = 4,
					/obj/item/cell/high = 12,
					/obj/item/assembly/prox_sensor = 3,
					/obj/item/assembly/signaler = 3,
					/obj/item/healthanalyzer = 3,
					/obj/item/surgical/scalpel = 2,
					/obj/item/surgical/circular_saw = 2,
					/obj/item/tank/anesthetic = 2,
					/obj/item/clothing/mask/breath/medical = 5,
					/obj/item/tool/screwdriver = 5,
					/obj/item/tool/crowbar = 5)
	req_log_access = access_rd
	has_logs = 1

/obj/machinery/vending/giftvendor
	name = "AlliCo Baubles and Confectionaries"
	desc = "For that special someone!"
	description_fluff = "AlliCo Ltd. is a NanoTrasen subsidiary focused on the design and licensing of 'cute' products including toys, gifts, stationary and accessories. Their range of original characters feature in all aspects of popular culture, from snacks to animated series."
	icon_state = "giftvendor"
	vend_delay = 15
	products = list(/obj/item/storage/fancy/heartbox = 5,
					/obj/item/toy/bouquet = 5,
					/obj/item/toy/bouquet/fake = 4,
					/obj/item/paper/card/smile = 3,
					/obj/item/paper/card/heart = 3,
					/obj/item/paper/card/cat = 3,
					/obj/item/paper/card/flower = 3,
					/obj/item/clothing/accessory/bracelet/friendship = 5,
					/obj/item/toy/plushie/therapy = 2,
					/obj/item/toy/plushie/therapy/purple = 2,
					/obj/item/toy/plushie/therapy/blue = 2,
					/obj/item/toy/plushie/therapy/yellow = 2,
					/obj/item/toy/plushie/therapy/orange = 2,
					/obj/item/toy/plushie/therapy/green = 2,
					/obj/item/toy/plushie/nymph = 2,
					/obj/item/toy/plushie/mouse = 2,
					/obj/item/toy/plushie/kitten = 2,
					/obj/item/toy/plushie/lizard = 2,
					/obj/item/toy/plushie/spider = 2,
					/obj/item/toy/plushie/farwa = 2,
					/obj/item/toy/plushie/corgi = 1,
					/obj/item/toy/plushie/octopus = 1,
					/obj/item/toy/plushie/face_hugger = 1,
					/obj/item/toy/plushie/carp = 1,
					/obj/item/toy/plushie/deer = 1,
					/obj/item/toy/plushie/tabby_cat = 1,
					/obj/item/threadneedle = 3,
					/obj/item/toy/plushie/lizardplushie/kobold = 1,
					/obj/item/toy/plushie/slimeplushie = 1,
					/obj/item/toy/plushie/box = 1,
					/obj/item/toy/plushie/borgplushie = 1,
					/obj/item/toy/plushie/borgplushie/medihound = 1,
					/obj/item/toy/plushie/borgplushie/scrubpuppy = 1,
					/obj/item/toy/plushie/foxbear = 1,
					/obj/item/toy/plushie/nukeplushie = 1,
					/obj/item/toy/plushie/otter = 1,
					/obj/item/toy/plushie/vox = 1,
					/obj/item/toy/plushie/shark = 1,
					/obj/item/toy/mistletoe = 1,
					/obj/item/toy/plushie/tinytin = 1,
					/obj/item/toy/plushie/tinytin_sec = 1)
	premium = list(/obj/item/reagent_containers/food/drinks/bottle/champagne = 1,
					/obj/item/storage/trinketbox = 2)
	prices = list(/obj/item/storage/fancy/heartbox = 15,
					/obj/item/toy/bouquet = 10,
					/obj/item/toy/bouquet/fake = 3,
					/obj/item/paper/card/smile = 1,
					/obj/item/paper/card/heart = 1,
					/obj/item/paper/card/cat = 1,
					/obj/item/paper/card/flower = 1,
					/obj/item/clothing/accessory/bracelet/friendship = 5,
					/obj/item/toy/plushie/therapy = 20,
					/obj/item/toy/plushie/therapy/purple = 20,
					/obj/item/toy/plushie/therapy/blue = 20,
					/obj/item/toy/plushie/therapy/yellow = 20,
					/obj/item/toy/plushie/therapy/orange = 20,
					/obj/item/toy/plushie/therapy/green = 20,
					/obj/item/toy/plushie/nymph = 35,
					/obj/item/toy/plushie/mouse = 35,
					/obj/item/toy/plushie/kitten = 35,
					/obj/item/toy/plushie/lizard = 35,
					/obj/item/toy/plushie/spider = 35,
					/obj/item/toy/plushie/farwa = 35,
					/obj/item/toy/plushie/corgi = 50,
					/obj/item/toy/plushie/octopus = 50,
					/obj/item/toy/plushie/face_hugger = 50,
					/obj/item/toy/plushie/carp = 50,
					/obj/item/toy/plushie/deer = 50,
					/obj/item/toy/plushie/tabby_cat = 50,
					/obj/item/threadneedle = 2,
					/obj/item/toy/plushie/lizardplushie/kobold = 50,
					/obj/item/toy/plushie/slimeplushie = 50,
					/obj/item/toy/plushie/box = 50,
					/obj/item/toy/plushie/borgplushie = 50,
					/obj/item/toy/plushie/borgplushie/medihound = 50,
					/obj/item/toy/plushie/borgplushie/scrubpuppy = 50,
					/obj/item/toy/plushie/foxbear = 50,
					/obj/item/toy/plushie/nukeplushie = 50,
					/obj/item/toy/plushie/otter = 50,
					/obj/item/toy/plushie/vox = 50,
					/obj/item/toy/plushie/shark = 50,
					/obj/item/toy/mistletoe = 50,
					/obj/item/toy/plushie/tinytin = 35,
					/obj/item/toy/plushie/tinytin_sec = 50)


/obj/machinery/vending/fishing
	name = "Loot Trawler"
	desc = "A special vendor for fishing equipment."
	product_ads = "Tired of trawling across the ocean floor? Get our loot!;Chum and rods.;Don't get baited into fishing without us!;Baby is your star-sign pisces? We'd make a perfect match.;Do not fear, plenty to catch around here.;Don't get reeled in helplessly, get your own rod today!"
	icon_state = "fishvendor"
	products = list(/obj/item/material/fishing_rod/modern/cheap = 6,
					/obj/item/storage/box/wormcan = 4,
					/obj/item/storage/box/wormcan/sickly = 10,
					/obj/item/material/fishing_net = 2,
					/obj/item/glass_jar/fish = 4,
					/obj/item/stack/cable_coil/random = 6,
					/obj/item/clothing/head/fishing = 5)
	prices = list(/obj/item/material/fishing_rod/modern/cheap = 50,
					/obj/item/storage/box/wormcan = 12,
					/obj/item/storage/box/wormcan/sickly = 6,
					/obj/item/material/fishing_net = 40,
					/obj/item/glass_jar/fish = 10,
					/obj/item/stack/cable_coil/random = 4,
					/obj/item/clothing/head/fishing = 15)
	premium = list(/obj/item/storage/box/wormcan/deluxe = 1)
	contraband = list(/obj/item/storage/box/wormcan/deluxe = 1)


/obj/machinery/vending/virtual_autodrobe
	name = "Virtual AutoDrobe"
	desc = "A virtual vending machine for virtual avatar customization."
	icon_state = "Theater"
	product_slogans = "Dress for success!;Suited and booted!;It's show time!;Why leave style up to fate? Use AutoDrobe!"
	products = list(/obj/item/storage/box/syndie_kit/chameleon = 20)


/obj/machinery/vending/deathmatch
	name = "Annihilation Shop (Green)"
	desc = "A virtual vending machine for virtual murder equipment. This one's for green team."
	products = list(/obj/item/melee/energy/sword = 5,
					/obj/item/melee/energy/axe = 5,
					/obj/item/melee/baton/loaded = 5,
					/obj/item/gun/energy/laser = 5,
					/obj/item/gun/projectile/shotgun/pump/combat = 5,
					/obj/item/ammo_magazine/clip/c12g/pellet = 40,
					/obj/item/ammo_magazine/clip/c12g = 50,
					/obj/item/storage/box/flashbangs = 2,
					/obj/item/clothing/head/helmet/swat = 5,
					/obj/item/clothing/suit/armor/vest = 5,
					/obj/item/clothing/head/helmet/thunderdome = 5,
					/obj/item/clothing/shoes/brown = 5,
					/obj/item/clothing/suit/armor/tdome/green = 5,
					/obj/item/clothing/under/color/green = 5,
					/obj/item/reagent_containers/pill/adminordrazine = 10,
					/obj/item/tool/crowbar = 1)


/obj/machinery/vending/deathmatch/red
	name = "Annihilation Shop (Red)"
	desc = "A virtual vending machine for virtual murder equipment. This one's for red team."
	products = list(/obj/item/melee/energy/sword = 5,
					/obj/item/melee/energy/axe = 5,
					/obj/item/melee/baton/loaded = 5,
					/obj/item/gun/energy/laser = 5,
					/obj/item/gun/projectile/shotgun/pump/combat = 5,
					/obj/item/ammo_magazine/clip/c12g/pellet = 40,
					/obj/item/ammo_magazine/clip/c12g = 50,
					/obj/item/storage/box/flashbangs = 2,
					/obj/item/clothing/head/helmet/swat = 5,
					/obj/item/clothing/suit/armor/vest = 5,
					/obj/item/clothing/head/helmet/thunderdome = 5,
					/obj/item/clothing/shoes/brown = 5,
					/obj/item/clothing/suit/armor/tdome/red = 5,
					/obj/item/clothing/under/color/red = 5,
					/obj/item/reagent_containers/pill/adminordrazine = 10,
					/obj/item/tool/crowbar = 1)

/obj/machinery/vending/hotfood
	name = "\improper Hot Foods!"
	desc = "An old vending machine promising 'hot foods'. You doubt any of its contents are still edible."
	vend_delay = 40
	icon_state = "hotfood"
	products = list(/obj/item/reagent_containers/food/snacks/old/pizza = 3,
					/obj/item/reagent_containers/food/snacks/old/burger = 2,
					/obj/item/reagent_containers/food/snacks/old/horseburger = 2,
					/obj/item/reagent_containers/food/snacks/old/fries = 4,
					/obj/item/reagent_containers/food/snacks/old/hotdog = 3,
					/obj/item/reagent_containers/food/snacks/old/taco = 2
					)

/obj/machinery/vending/weeb
	name = "\improper Nippon-tan!"
	desc = "A distressingly ethnic vending machine loaded with high sucrose low calorie for lack of better words snacks."
	vend_delay = 30
	vend_reply = "Dōmo arigatō!"
	product_slogans = "Tanoshī! ;Itadakimasu!"
	icon_state = "weeb"
	products = list(/obj/item/reagent_containers/food/snacks/weebonuts = 8,
					/obj/item/reagent_containers/food/snacks/ricecake = 8,
					/obj/item/reagent_containers/food/snacks/wasabi_peas = 8,
					/obj/item/reagent_containers/food/snacks/namagashi = 8,
					/obj/item/reagent_containers/food/snacks/hanami_dango = 6,
					/obj/item/reagent_containers/food/snacks/goma_dango = 6,
					/obj/item/storage/box/pocky = 6,
					/obj/item/reagent_containers/food/snacks/chocobanana = 6,
					/obj/item/reagent_containers/food/snacks/dorayaki = 6,
					/obj/item/reagent_containers/food/snacks/daifuku = 6
					)

	prices = list(/obj/item/reagent_containers/food/snacks/weebonuts = 5,
					/obj/item/reagent_containers/food/snacks/ricecake = 5,
					/obj/item/reagent_containers/food/snacks/wasabi_peas = 8,
					/obj/item/reagent_containers/food/snacks/namagashi = 8,
					/obj/item/reagent_containers/food/snacks/hanami_dango = 10,
					/obj/item/reagent_containers/food/snacks/goma_dango = 10,
					/obj/item/storage/box/pocky = 8,
					/obj/item/reagent_containers/food/snacks/chocobanana = 10,
					/obj/item/reagent_containers/food/snacks/dorayaki = 5,
					/obj/item/reagent_containers/food/snacks/daifuku = 5
					)

/obj/machinery/vending/sol
	name = "\improper Sol-Snacks"
	desc = "A SolCentric vending machine dispensing a number of Sol-themed snacks, along with other foods."
	vend_delay = 30
	product_slogans = "A taste of Sol!"
	icon_state = "solsnack"
	products = list(/obj/item/reagent_containers/food/snacks/pluto = 8,
					/obj/item/reagent_containers/food/snacks/triton = 8,
					/obj/item/reagent_containers/food/snacks/saturn = 8,
					/obj/item/reagent_containers/food/snacks/jupiter = 8,
					/obj/item/reagent_containers/food/snacks/mars = 8,
					/obj/item/reagent_containers/food/snacks/venus = 8,
					/obj/item/reagent_containers/food/snacks/oort = 8,
					/obj/item/reagent_containers/food/snacks/sun_snax = 8,
					/obj/item/reagent_containers/food/snacks/canned/appleberry = 6,
					/obj/item/storage/box/jaffacake = 8,
					/obj/item/storage/box/gum = 8,
					/obj/item/storage/box/admints = 8
					)

	prices = list(	/obj/item/reagent_containers/food/snacks/pluto = 5,
					/obj/item/reagent_containers/food/snacks/triton = 5,
					/obj/item/reagent_containers/food/snacks/saturn = 5,
					/obj/item/reagent_containers/food/snacks/jupiter = 5,
					/obj/item/reagent_containers/food/snacks/mars = 5,
					/obj/item/reagent_containers/food/snacks/venus = 5,
					/obj/item/reagent_containers/food/snacks/oort = 5,
					/obj/item/reagent_containers/food/snacks/sun_snax = 5,
					/obj/item/reagent_containers/food/snacks/canned/appleberry = 8,
					/obj/item/storage/box/jaffacake = 5,
					/obj/item/storage/box/gum = 2,
					/obj/item/storage/box/admints = 2
					)

/obj/machinery/vending/snix
	name = "\improper Snix"
	desc = "A snack vending machine, offering a selection of slavic beer snacks."
	vend_delay = 30
	product_slogans = "Snix!"
	icon_state = "snix"
	products = list(/obj/item/reagent_containers/food/snacks/semki = 8,
					/obj/item/reagent_containers/food/snacks/canned/caviar = 8,
					/obj/item/reagent_containers/food/snacks/squid = 8,
					/obj/item/reagent_containers/food/snacks/croutons = 8,
					/obj/item/reagent_containers/food/snacks/salo = 8,
					/obj/item/reagent_containers/food/snacks/driedfish = 8,
					/obj/item/reagent_containers/food/snacks/pistachios = 8,
					/obj/item/reagent_containers/food/snacks/canned/maps = 4,
					/obj/item/reagent_containers/food/snacks/skrellsnacks = 8,
					/obj/item/storage/box/gum = 8,
					/obj/item/storage/box/admints = 8,
					/obj/item/reagent_containers/food/snacks/pretzels = 8,
					/obj/item/reagent_containers/food/snacks/hakarl = 8
					)

	contraband = list(/obj/item/reagent_containers/food/snacks/canned/caviar/true = 1)

	prices = list(	/obj/item/reagent_containers/food/snacks/semki = 8,
					/obj/item/reagent_containers/food/snacks/canned/caviar = 8,
					/obj/item/reagent_containers/food/snacks/squid = 8,
					/obj/item/reagent_containers/food/snacks/croutons = 8,
					/obj/item/reagent_containers/food/snacks/salo = 8,
					/obj/item/reagent_containers/food/snacks/driedfish = 8,
					/obj/item/reagent_containers/food/snacks/pistachios = 8,
					/obj/item/reagent_containers/food/snacks/canned/maps = 10,
					/obj/item/reagent_containers/food/snacks/skrellsnacks = 8,
					/obj/item/storage/box/gum = 2,
					/obj/item/storage/box/admints = 2,
					/obj/item/reagent_containers/food/snacks/pretzels = 8,
					/obj/item/reagent_containers/food/snacks/hakarl = 8
					)

/obj/machinery/vending/snlvend
	name = "\improper Shop-n-Large Snacks!"
	desc = "A Shop-n-Large brand vending machine! Enjoy all your favorites!"
	vend_delay = 30
	product_slogans = "Shop Shop-n-Large!, Buy! Buy! Buy!, Try our new Bread Tube! Now with 10% less sawdust!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "snlvendor"

	products = list(/obj/item/reagent_containers/food/snacks/tuna = 8,
					/obj/item/reagent_containers/food/snacks/semki = 8,
					/obj/item/reagent_containers/food/snacks/pistachios = 8,
					/obj/item/reagent_containers/food/snacks/salo = 8,
					/obj/item/reagent_containers/food/snacks/packaged/spacetwinkie = 8,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 8,
					/obj/item/reagent_containers/food/snacks/syndicake = 8,
					/obj/item/reagent_containers/food/snacks/no_raisin = 8,
					/obj/item/reagent_containers/food/snacks/sosjerky = 8,
					/obj/item/reagent_containers/food/snacks/packaged/vendburger = 8,
					/obj/item/reagent_containers/food/snacks/packaged/vendhotdog = 8,
					/obj/item/reagent_containers/food/snacks/packaged/vendburrito = 8,
					/obj/item/reagent_containers/food/snacks/skrellsnacks = 8,
					/obj/item/reagent_containers/food/snacks/tastybread = 8,
					/obj/item/reagent_containers/food/snacks/chips/bbq = 8,
					/obj/item/reagent_containers/food/snacks/chips = 8,
					/obj/item/reagent_containers/food/snacks/chips/snv = 8,
					/obj/item/reagent_containers/food/snacks/driedfish = 8,
					/obj/item/reagent_containers/food/snacks/cookiesnack = 8
					)
	contraband = list(/obj/item/reagent_containers/food/snacks/unajerky = 1,
					/obj/item/reagent_containers/food/snacks/canned/brainzsnax/red = 6)

	prices = list(	/obj/item/reagent_containers/food/snacks/tuna = 5,
					/obj/item/reagent_containers/food/snacks/semki = 5,
					/obj/item/reagent_containers/food/snacks/pistachios = 5,
					/obj/item/reagent_containers/food/snacks/salo = 5,
					/obj/item/reagent_containers/food/snacks/packaged/spacetwinkie = 5,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 5,
					/obj/item/reagent_containers/food/snacks/syndicake = 5,
					/obj/item/reagent_containers/food/snacks/no_raisin = 5,
					/obj/item/reagent_containers/food/snacks/sosjerky = 5,
					/obj/item/reagent_containers/food/snacks/packaged/vendburger = 7,
					/obj/item/reagent_containers/food/snacks/packaged/vendhotdog = 7,
					/obj/item/reagent_containers/food/snacks/packaged/vendburrito = 7,
					/obj/item/reagent_containers/food/snacks/skrellsnacks = 5,
					/obj/item/reagent_containers/food/snacks/tastybread = 5,
					/obj/item/reagent_containers/food/snacks/chips/bbq = 5,
					/obj/item/reagent_containers/food/snacks/chips = 5,
					/obj/item/reagent_containers/food/snacks/chips/snv = 5,
					/obj/item/reagent_containers/food/snacks/driedfish = 5,
					/obj/item/reagent_containers/food/snacks/cookiesnack = 5
					)

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old sweet water vending machine, how did this end up here?"
	icon_state = "sovietsoda"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(/obj/item/reagent_containers/food/drinks/cans/boda = 30,
					/obj/item/reagent_containers/food/drinks/cans/redarmy = 15,
					/obj/item/reagent_containers/food/drinks/cans/arstbru = 15,
					/obj/item/reagent_containers/food/drinks/cans/terra_cola = 15,
					/obj/item/reagent_containers/food/drinks/cans/kompot = 15)
	contraband = list(/obj/item/reagent_containers/food/drinks/cans/kvass = 10,
					/obj/item/reagent_containers/food/drinks/cans/bodaplus = 10)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vending_sound = "machines/vending/vending_cans.ogg"

/obj/machinery/vending/sovietvend
	name = "Ration Station"
	desc = "An old ration vendor unit. How it even still functional?"
	icon = 'icons/obj/vending.dmi'
	icon_state = "sovietvend"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(/obj/item/reagent_containers/food/snacks/packaged/genration = 8,
					/obj/item/reagent_containers/food/snacks/packaged/vegration = 8,
					/obj/item/reagent_containers/food/snacks/packaged/meatration = 8)
	contraband = list(/obj/item/reagent_containers/food/snacks/packaged/sweetration = 2)

/obj/machinery/vending/radren
	name = "Radical Renard Sodas"
	desc = "A softdrink vendor owned by a frontier based soda company that's been contracted by NanoTrasen"
	icon_state = "radren"
	product_slogans = "Enjoy the rad refreshing taste of Radical Renard brand soda!"
	product_ads = "Radically Refreshing!;Get Cool!;Have you tried our new Andromeda Apple?;Enjoy a cold one with Renard!"
	products = list(/obj/item/reagent_containers/food/drinks/cans/straw_cola = 10,
					/obj/item/reagent_containers/food/drinks/cans/apple_cola = 10,
					/obj/item/reagent_containers/food/drinks/cans/lemon_cola = 10,
					/obj/item/reagent_containers/food/drinks/cans/baconsoda = 10,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 10,
					/obj/item/reagent_containers/food/drinks/cans/sarsaparilla = 10,
					/obj/item/reagent_containers/food/drinks/cans/grape_cola = 10,
					/obj/item/reagent_containers/food/drinks/cans/orange_cola = 10,
					/obj/item/reagent_containers/food/drinks/cans/gingerale = 10)
	contraband = list()
	prices = list(/obj/item/reagent_containers/food/drinks/cans/straw_cola = 1,
					/obj/item/reagent_containers/food/drinks/cans/apple_cola = 1,
					/obj/item/reagent_containers/food/drinks/cans/lemon_cola  = 1,
					/obj/item/reagent_containers/food/drinks/cans/baconsoda = 1,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 2,
					/obj/item/reagent_containers/food/drinks/cans/sarsaparilla = 1,
					/obj/item/reagent_containers/food/drinks/cans/grape_cola = 1,
					/obj/item/reagent_containers/food/drinks/cans/orange_cola = 1,
					/obj/item/reagent_containers/food/drinks/cans/gingerale = 1)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vending_sound = "machines/vending/vending_cans.ogg"
/obj/machinery/vending/donksoft
	name = "Donk-Soft!"
	desc = "A toy vendor owned by Donk-Soft, a NanoTrasen sub-company."
	description_fluff = "Donk-Soft is a sub-company owned by NanoTrasen that distribute replica weapons that shoot squishy foam darts. \
	They've been a staple of personal entertainment for decades but their buisness has only just moved to the fringes of the galaxy."
	icon_state = "donksoft"
	product_slogans = "Get your cool toys today!;Quality toy weapons for cheap prices!"
	product_ads = "Express your inner child today!;Who needs responsibilities when you have toy weapons?;Make your next murder FUN!"
	products = list(/obj/item/ammo_magazine/ammo_box/foam = 20,
					/obj/item/storage/belt/dbandolier = 5,
					/obj/item/ammo_magazine/mfoam_dart/pistol = 10,
					/obj/item/ammo_magazine/mfoam_dart/smg = 10,
					/obj/item/gun/projectile/shotgun/pump/toy = 5,
					/obj/item/gun/projectile/revolver/toy/sawnoff = 5,
					/obj/item/gun/projectile/pistol/toy = 5,
					/obj/item/gun/projectile/pistol/toy/n99 = 5,
					/obj/item/gun/projectile/shotgun/pump/toy/levergun = 5,
					/obj/item/gun/projectile/revolver/toy = 5,
					/obj/item/gun/projectile/revolver/toy/big_iron = 5,
					/obj/item/gun/projectile/revolver/toy/crossbow = 5,
					/obj/item/gun/projectile/automatic/toy = 5
					)
	contraband = list()
	prices = list(/obj/item/ammo_magazine/ammo_box/foam = 50,
					/obj/item/storage/belt/dbandolier = 100,
					/obj/item/ammo_magazine/mfoam_dart/pistol = 25,
					/obj/item/ammo_magazine/mfoam_dart/smg  = 25,
					/obj/item/gun/projectile/shotgun/pump/toy = 250,
					/obj/item/gun/projectile/revolver/toy/sawnoff = 150,
					/obj/item/gun/projectile/pistol/toy = 100,
					/obj/item/gun/projectile/pistol/toy/n99 = 175,
					/obj/item/gun/projectile/shotgun/pump/toy/levergun = 250,
					/obj/item/gun/projectile/revolver/toy = 100,
					/obj/item/gun/projectile/revolver/toy/big_iron = 175,
					/obj/item/gun/projectile/revolver/toy/crossbow = 75,
					/obj/item/gun/projectile/automatic/toy = 300)
	vending_sound = "machines/vending/vending_cans.ogg"

/*
 * Department/job vendors to sit in place of lockers taking up space
 */

/obj/machinery/vending/wardrobe
	icon = 'icons/obj/vending_job.dmi'


/obj/machinery/vending/wardrobe/bardrobe
	name = "bartender wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "bardrobe"
	req_access = list(access_bar)
	products = list(
		/obj/item/clothing/under/rank/bartender = 5,
		/obj/item/clothing/under/rank/bartender/skirt = 5,
		/obj/item/clothing/under/rank/neo_chef_skirt = 5,
		/obj/item/clothing/under/waiter = 5,
		/obj/item/clothing/head/that = 5,
		/obj/item/clothing/head/flatcap = 5,
		/obj/item/clothing/shoes/brown = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/bar = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_civ_dep = 5,
		/obj/item/clothing/accessory/permit/gun/bar = 1
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/secdrobe
	name = "security wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "secdrobe"
	req_access = list(access_brig)
	products = list(
		/obj/item/clothing/under/rank/security = 5,
		/obj/item/clothing/under/rank/security2 = 5,
		/obj/item/clothing/under/rank/security/turtleneck = 5,
		/obj/item/clothing/under/rank/security/modern = 5,
		/obj/item/clothing/under/rank/security/aces = 5,
		/obj/item/clothing/under/rank/security/skirt = 5,
		/obj/item/clothing/shoes/boots/jackboots = 5,
		/obj/item/clothing/head/soft/sec = 5,
		/obj/item/clothing/head/beret/sec = 5,
		/obj/item/clothing/head/beret/sec/corporate/officer = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_bodyguard_dep = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_sec_blue_dep = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_sec_red_dep = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_police = 5,
		/obj/item/clothing/under/rank/bodyguard_suit = 5,
		/obj/item/clothing/under/rank/bodyguard_skirt = 5,
		/obj/item/clothing/under/rank/bodyguard_turtleneck = 5,
		/obj/item/clothing/under/rank/bodyguard_turtleskirt = 5,
		/obj/item/clothing/under/rank/neo_sec_red = 5,
		/obj/item/clothing/under/rank/neo_sec_red_skirt = 5,
		/obj/item/clothing/under/rank/neo_sec_blue = 5,
		/obj/item/clothing/under/rank/neo_sec_suit = 5,
		/obj/item/clothing/under/rank/neo_sec_suit_blue = 5,
		/obj/item/clothing/under/rank/neo_sec_turtle_red = 5,
		/obj/item/clothing/under/rank/neo_sec_turtle_red_skirt = 5,
		/obj/item/clothing/under/rank/neo_sec_turtle_blue = 5,
		/obj/item/clothing/under/rank/neo_sec_turtle_blue_skirt = 5,
		/obj/item/clothing/under/rank/neo_corrections = 5,
		/obj/item/clothing/under/rank/neo_corrections_skirt = 5,
		/obj/item/clothing/under/rank/neo_runner = 5,
		/obj/item/clothing/under/rank/neo_gorka/sec = 5,
		/obj/item/clothing/suit/neo_runner_coat = 5,
		/obj/item/clothing/shoes/boots/jackboots/silver = 5,
		/obj/item/clothing/shoes/boots/jackboots/white = 5,
		/obj/item/clothing/mask/bandana/red = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security = 5,
		/obj/item/clothing/accessory/armband = 5,
		/obj/item/clothing/glasses/sunglasses/sechud/tactical_sec_vis = 5, //VoreStation edit - cool visor!!!
		/obj/item/clothing/glasses/hud/security/eyepatch2 = 5, //VoreStation edit - cool eyepatch!
		/obj/item/clothing/accessory/holster/armpit = 2,
		/obj/item/clothing/accessory/holster/armpit/black = 2,
		/obj/item/clothing/accessory/holster/waist = 2,
		/obj/item/clothing/accessory/holster/waist/black = 2,
		/obj/item/clothing/accessory/holster/hip = 2,
		/obj/item/clothing/accessory/holster/hip/black = 2,
		/obj/item/clothing/accessory/holster/leg = 2,
		/obj/item/clothing/accessory/holster/leg/black = 2
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/chefdrobe
	name = "chef wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "chefdrobe"
	req_access = list(access_kitchen)
	products = list(
		/obj/item/clothing/under/rank/chef = 5,
		/obj/item/clothing/shoes/black = 5,
		/obj/item/clothing/shoes/cookflop = 2,
		/obj/item/clothing/suit/storage/apron/white = 5,
		/obj/item/clothing/suit/chef = 5,
		/obj/item/clothing/suit/chef/classic = 5,
		/obj/item/clothing/under/rank/neo_chef_skirt = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_civ_dep = 5,
		/obj/item/clothing/head/chefhat = 5,
		/obj/item/clothing/head/hairnet = 5,
		/obj/item/clothing/under/waiter = 5,
		/obj/item/clothing/under/sundress = 1
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/medidrobe
	name = "medical wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "medidrobe"
	req_access = list(access_medical_equip)
	products = list(
		/obj/item/clothing/under/rank/medical = 5,
		/obj/item/clothing/under/rank/medical/skirt = 5,
		/obj/item/clothing/under/rank/medical/turtleneck = 5,
		/obj/item/clothing/under/rank/medical/scrubs = 5,
		/obj/item/clothing/under/rank/medical/scrubs/green = 5,
		/obj/item/clothing/under/rank/medical/scrubs/purple = 5,
		/obj/item/clothing/under/rank/medical/scrubs/black = 5,
		/obj/item/clothing/under/rank/medical/scrubs/navyblue = 5,
		/obj/item/clothing/head/surgery/navyblue = 5,
		/obj/item/clothing/head/surgery/purple = 5,
		/obj/item/clothing/head/surgery/blue = 5,
		/obj/item/clothing/head/surgery/green = 5,
		/obj/item/clothing/head/surgery/black = 5,
		/obj/item/clothing/under/rank/neo_med = 5,
		/obj/item/clothing/under/rank/neo_med_skirt = 5,
		/obj/item/clothing/under/rank/neo_para =5,
		/obj/item/clothing/under/rank/neo_para_skirt = 5,
		/obj/item/clothing/under/rank/neo_para_light = 5,
		/obj/item/clothing/under/rank/neo_para_light_skirt = 5,
		/obj/item/clothing/under/rank/neo_med_dark = 5,
		/obj/item/clothing/under/rank/neo_med_dark_skirt = 5,
		/obj/item/clothing/under/rank/neo_gorka/med = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_emt = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_labcoat = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_highvis = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_redemt = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_blueemt = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_med_dep = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_bluemed = 5,
		/obj/item/clothing/suit/neo_medical_coat = 5,
		/obj/item/clothing/shoes/white = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/modern = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/old = 5, //VoreStation edit, pre-fulp labcoat.
		/obj/item/clothing/mask/surgical = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/alt = 5,
		/obj/item/clothing/shoes/boots/winter/medical = 5,
		/obj/item/clothing/head/beret/medical = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/chemdrobe
	name = "chemistry wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "chemdrobe"
	req_access = list(access_chemistry)
	products = list(
		/obj/item/clothing/under/rank/chemist = 5,
		/obj/item/clothing/under/rank/chemist/skirt = 5,
		/obj/item/clothing/shoes/white = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/chemist = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/old/chem = 5, //VoreStation edit, pre-fulp labcoat.
		/obj/item/clothing/under/rank/neo_chem = 5,
		/obj/item/clothing/under/rank/neo_chem_skirt = 5,
		/obj/item/clothing/under/rank/neo_pharma = 5,
		/obj/item/clothing/under/rank/neo_pharma_skirt = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/chemist = 5,
		/obj/item/clothing/head/beret/medical/chem = 5,
		/obj/item/storage/backpack/chemistry = 5,
		/obj/item/storage/backpack/satchel/chem = 5,
		/obj/item/storage/bag/chemistry = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/genedrobe
	name = "genetics wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "genedrobe"
	req_access = list(access_genetics)
	products = list(
		/obj/item/clothing/under/rank/geneticist = 5,
		/obj/item/clothing/under/rank/geneticist/skirt = 5,
		/obj/item/clothing/shoes/white = 5,
		/obj/item/clothing/under/rank/neo_gene = 5,
		/obj/item/clothing/under/rank/neo_gene_skirt = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/genetics = 5,
		/obj/item/storage/backpack/genetics = 5,
		/obj/item/storage/backpack/satchel/gen = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/virodrobe
	name = "virology wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "virodrobe"
	req_access = list(access_virology)
	products = list(
		/obj/item/clothing/under/rank/virologist = 5,
		/obj/item/clothing/under/rank/virologist/skirt = 5,
		/obj/item/clothing/shoes/white = 5,
		/obj/item/clothing/under/rank/neo_viro = 5,
		/obj/item/clothing/under/rank/neo_viro_skirt = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/virologist = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/old/vir = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/viro = 5, //VoreStation edit, pre-fulp labcoat.
		/obj/item/clothing/head/beret/medical/viro = 5,
		/obj/item/clothing/mask/surgical = 5,
		/obj/item/storage/backpack/virology = 5,
		/obj/item/storage/backpack/satchel/vir = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/scidrobe
	name = "science wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "scidrobe"
	req_access = list(access_research)
	products = list(
		/obj/item/clothing/under/rank/scientist = 5,
		/obj/item/clothing/under/rank/scientist/skirt = 5,
		/obj/item/clothing/under/rank/scientist/turtleneck = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/old = 5, //VoreStation edit, pre-fulp labcoat.
		/obj/item/clothing/suit/storage/toggle/labcoat/modern = 5,
		/obj/item/clothing/shoes/white = 5,
		/obj/item/clothing/shoes/slippers = 5,
		/obj/item/clothing/under/rank/neo_science = 5,
		/obj/item/clothing/under/rank/neo_science_skirt = 5,
		/obj/item/clothing/under/rank/neo_util_sci = 5,
		/obj/item/clothing/under/rank/neo_gorka/sci = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_sci_dep = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_labcoat = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science = 5,
		/obj/item/clothing/shoes/boots/winter/science = 5,
		/obj/item/clothing/head/beret/science = 5,
		/obj/item/storage/backpack/toxins = 5,
		/obj/item/storage/backpack/satchel/tox = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/robodrobe
	name = "robotics wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "robodrobe"
	req_access = list(access_robotics)
	products = list(
		/obj/item/clothing/under/rank/roboticist = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/roboticist = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science/robotics = 5,
		/obj/item/clothing/head/beret/science/robotics = 5,
		/obj/item/clothing/shoes/black = 5,
		/obj/item/clothing/gloves/black = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_labcoat = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_robo_coat = 5,
		/obj/item/clothing/under/rank/neo_robo = 5,
		/obj/item/clothing/under/rank/neo_robo_skirt = 5,
		/obj/item/storage/backpack/toxins = 5,
		/obj/item/storage/backpack/satchel/tox = 5
	)
	contraband = list(
		/obj/item/clothing/suit/storage/hooded/techpriest = 2
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/chapdrobe
	name = "chaplain wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "chapdrobe"
	req_access = list(access_chapel_office)
	products = list(
		/obj/item/clothing/under/rank/chaplain = 5,
		/obj/item/clothing/shoes/black = 5,
		/obj/item/clothing/suit/nun = 5,
		/obj/item/clothing/head/nun_hood = 5,
		/obj/item/clothing/suit/storage/hooded/chaplain_hoodie = 5,
		/obj/item/clothing/suit/storage/hooded/chaplain_hoodie/whiteout = 5,
		/obj/item/clothing/suit/holidaypriest = 5,
		/obj/item/clothing/under/wedding/bride_white = 5,
		/obj/item/storage/backpack/cultpack = 5,
		/obj/item/storage/fancy/candle_box = 5,
		/obj/item/storage/fancy/whitecandle_box = 5,
		/obj/item/storage/fancy/blackcandle_box = 5,
		/obj/item/godfig = 5,
		/obj/item/deck/tarot = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/ratvar = 1,
		/obj/item/clothing/suit/storage/hooded/wintercoat/narsie = 1
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/engidrobe
	name = "engineer wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "engidrobe"
	req_access = list(access_engine_equip)
	products = list(
		/obj/item/clothing/under/rank/engineer = 5,
		/obj/item/clothing/under/rank/engineer/skirt = 5,
		/obj/item/clothing/under/rank/engineer/turtleneck = 5,
		/obj/item/clothing/shoes/orange = 5,
		/obj/item/clothing/head/hardhat = 5,
		/obj/item/clothing/head/beret/engineering = 5,
		/obj/item/clothing/mask/bandana/gold = 5,
		/obj/item/clothing/under/rank/neo_engi = 5,
		/obj/item/clothing/under/rank/neo_engi_skirt = 5,
		/obj/item/clothing/under/rank/neo_gorka/engi = 5,
		/obj/item/clothing/accessory/armband/engine = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_engi_dep = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering = 5,
		/obj/item/clothing/shoes/boots/winter/engineering = 5,
		/obj/item/clothing/shoes/boots/workboots = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/atmosdrobe
	name = "atmos tech wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "atmosdrobe"
	req_access = list(access_atmospherics)
	products = list(
		/obj/item/clothing/under/rank/atmospheric_technician = 5,
		/obj/item/clothing/under/rank/atmospheric_technician/skirt = 5,
		/obj/item/clothing/shoes/black = 5,
		/obj/item/clothing/head/hardhat/red = 5,
		/obj/item/clothing/head/beret/engineering = 5,
		/obj/item/clothing/mask/bandana/gold = 5,
		/obj/item/clothing/under/rank/neo_atmos = 5,
		/obj/item/clothing/under/rank/neo_atmos_skirt = 5,
		/obj/item/clothing/accessory/armband/engine = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos = 5,
		/obj/item/clothing/shoes/boots/winter/atmos = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/hydrobe
	name = "hydroponics wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "hydrobe"
	req_access = list(access_hydroponics)
	products = list(
		/obj/item/clothing/under/rank/hydroponics = 5,
		/obj/item/analyzer/plant_analyzer = 5,
		/obj/item/clothing/head/greenbandana = 5,
		/obj/item/material/minihoe = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hydro = 5,
		/obj/item/clothing/under/rank/neo_hydro = 5,
		/obj/item/clothing/under/rank/neo_hydro_skirt = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_civ_dep = 5,
		/obj/item/clothing/shoes/boots/winter/hydro = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/cargodrobe
	name = "cargo wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "cargodrobe"
	req_access = list(access_cargo)
	products = list(
		/obj/item/clothing/under/rank/cargotech = 5,
		/obj/item/clothing/under/rank/cargotech/skirt = 5,
		/obj/item/clothing/under/rank/cargotech/jeans = 5,
		/obj/item/clothing/under/rank/cargotech/jeans/female = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo = 5,
		/obj/item/clothing/suit/storage/cargo = 5,
		/obj/item/clothing/under/rank/neo_cargo_shorts = 5,
		/obj/item/clothing/under/rank/neo_cargo_skirt = 5,
		/obj/item/clothing/under/rank/neo_miner = 5,
		/obj/item/clothing/under/rank/neo_cargo = 5,
		/obj/item/clothing/under/rank/neo_util_cargo = 5,
		/obj/item/clothing/under/rank/neo_cargo_dark = 5,
		/obj/item/clothing/under/rank/neo_cargo_casual = 5,
		/obj/item/clothing/under/rank/neo_cargo_turtle = 5,
		/obj/item/clothing/under/rank/neo_cargo_turtle_skirt = 5,
		/obj/item/clothing/under/rank/neo_gorka/cargo = 5,
		/obj/item/clothing/under/rank/neo_cargo_customs = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_cargo_dep = 5,
		/obj/item/clothing/suit/neo_gorka_cargo = 5,
		/obj/item/clothing/shoes/boots/winter/supply = 5,
		/obj/item/clothing/shoes/black = 5,
		/obj/item/clothing/gloves/black = 5,
		/obj/item/clothing/gloves/fingerless = 5,
		/obj/item/clothing/head/soft = 5
	)
	req_log_access = access_hop
	has_logs = 1
/*

/obj/machinery/vending/wardrobe/curadrobe
	name = "cura?? wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "curadrobe"
	req_access = list()
	products = list()
	req_log_access = access_hop
	has_logs = 1

*/

/obj/machinery/vending/wardrobe/janidrobe
	name = "janitor wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "janidrobe"
	req_access = list(access_janitor)
	products = list(
		/obj/item/clothing/head/soft/purple = 5,
		/obj/item/clothing/head/beret/purple = 5,
		/obj/item/clothing/head/headband/maid = 5,
		/obj/item/radio/headset/service = 5,
		/obj/item/clothing/under/rank/janitor = 5,
		/obj/item/clothing/under/dress/maid/janitor = 5,
		/obj/item/clothing/suit/storage/hooded/wintercoat/janitor = 5,
		/obj/item/clothing/under/rank/neo_janitor = 5,
		/obj/item/clothing/under/rank/neo_janitor_skirt = 5,
		/obj/item/clothing/suit/storage/toggle/labcoat/neo_civ_dep = 5,
		/obj/item/clothing/gloves/black = 5,
		/obj/item/storage/belt/janitor = 5,
		/obj/item/clothing/shoes/galoshes = 5,
		/obj/item/clothing/glasses/hud/janitor = 5,
		/obj/item/cartridge/janitor = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/lawdrobe
	name = "IAA wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "lawdrobe"
	req_access = list(access_lawyer)
	products = list(
		/obj/item/clothing/under/lawyer/female = 5,
		/obj/item/clothing/under/lawyer/black = 5,
		/obj/item/clothing/under/lawyer/black/skirt = 5,
		/obj/item/clothing/under/lawyer/red = 5,
		/obj/item/clothing/under/lawyer/red/skirt = 5,
		/obj/item/clothing/suit/storage/toggle/internalaffairs = 5,
		/obj/item/clothing/under/lawyer/bluesuit = 5,
		/obj/item/clothing/under/lawyer/bluesuit/skirt = 5,
		/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket = 5,
		/obj/item/clothing/under/lawyer/purpsuit = 5,
		/obj/item/clothing/under/lawyer/purpsuit/skirt = 5,
		/obj/item/clothing/suit/storage/toggle/lawyer/purpjacket = 5,
		/obj/item/clothing/under/rank/neo_teal = 5,
		/obj/item/clothing/under/rank/neo_teal_skirt = 5,
		/obj/item/clothing/shoes/brown = 5,
		/obj/item/clothing/shoes/black = 5,
		/obj/item/clothing/shoes/laceup = 5,
		/obj/item/clothing/glasses/sunglasses/big = 5,
		/obj/item/clothing/under/lawyer/blue = 5,
		/obj/item/clothing/under/lawyer/blue/skirt = 5,
		/obj/item/rectape/random = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/detdrobe
	name = "detective wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Want to do your job? Sure you do!"
	icon_state = "detdrobe"
	req_access = list(access_forensics_lockers)
	products = list(
		/obj/item/clothing/head/det = 5,
		/obj/item/clothing/head/det/grey = 5,
		/obj/item/clothing/head/neo_irs = 5,
		/obj/item/clothing/shoes/brown = 5,
		/obj/item/clothing/shoes/laceup = 5,
		/obj/item/clothing/under/det = 5,
		/obj/item/clothing/under/det/waistcoat = 5,
		/obj/item/clothing/under/det/grey = 5,
		/obj/item/clothing/under/det/grey/waistcoat = 5,
		/obj/item/clothing/under/det/black = 5,
		/obj/item/clothing/under/det/skirt,
		/obj/item/clothing/under/det/corporate = 5,
		/obj/item/clothing/suit/storage/det_trench = 5,
		/obj/item/clothing/suit/storage/det_trench/grey = 5,
		/obj/item/clothing/suit/storage/forensics/blue = 5,
		/obj/item/clothing/suit/storage/forensics/red = 5
	)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/mimedrobe
	name = "mime wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "..."
	icon_state = "mimedrobe"
	req_access = list(access_mime)
	products = list(
		/obj/item/clothing/under/mime = 1,
		/obj/item/clothing/under/sexymime = 1,
		/obj/item/clothing/under/sexymime/dress = 1,
		/obj/item/clothing/mask/gas/mime = 1,
		/obj/item/clothing/mask/gas/sexymime = 1,
		/obj/item/clothing/head/soft/mime = 1,
		/obj/item/clothing/head/collectable/beret = 1,
		/obj/item/clothing/suit/suspenders = 1,
		/obj/item/clothing/shoes/mime = 1
		)
	req_log_access = access_hop
	has_logs = 1

/obj/machinery/vending/wardrobe/clowndrobe
	name = "clown wardrobe vendor"
	desc = "All the things you need to perform your job! Why didn't you already have them?"
	product_slogans = "Honk!"
	icon_state = "clowndrobe"
	req_access = list(access_clown)
	products = list(
		/obj/item/clothing/under/rank/clown = 1,
		/obj/item/clothing/under/sexyclown = 1,
		/obj/item/clothing/under/clown/green = 1,
		/obj/item/clothing/under/clown/purple = 1,
		/obj/item/clothing/under/clown/yellow = 1,
		/obj/item/clothing/under/clown/orange = 1,
		/obj/item/clothing/under/clown/blue = 1,
		/obj/item/clothing/mask/gas/clown_hat = 1,
		/obj/item/clothing/mask/gas/sexyclown = 1,
		/obj/item/clothing/mask/emotions = 1,
		/obj/item/clothing/shoes/clown_shoes = 1,
		/obj/item/reagent_containers/food/snacks/pie = 5,
		/obj/item/bananapeel = 5
		)
	contraband = list(
		/obj/item/clothing/under/clown/rainbow = 1
	)
	req_log_access = access_hop
	has_logs = 1
