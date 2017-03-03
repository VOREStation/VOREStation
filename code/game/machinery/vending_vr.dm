/obj/machinery/vending/hydroseeds
	products = list(/obj/item/seeds/bananaseed = 3,/obj/item/seeds/berryseed = 3,/obj/item/seeds/carrotseed = 3,/obj/item/seeds/chantermycelium = 3,/obj/item/seeds/chiliseed = 3,
					/obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/potatoseed = 3, /obj/item/seeds/replicapod = 3,/obj/item/seeds/soyaseed = 3,
					/obj/item/seeds/sunflowerseed = 3,/obj/item/seeds/tomatoseed = 3,/obj/item/seeds/towermycelium = 3,/obj/item/seeds/wheatseed = 3,/obj/item/seeds/appleseed = 3,
					/obj/item/seeds/poppyseed = 3,/obj/item/seeds/sugarcaneseed = 3,/obj/item/seeds/ambrosiavulgarisseed = 3,/obj/item/seeds/peanutseed = 3,/obj/item/seeds/whitebeetseed = 3,/obj/item/seeds/watermelonseed = 3,/obj/item/seeds/lavenderseed = 3,/obj/item/seeds/limeseed = 3,
					/obj/item/seeds/lemonseed = 3,/obj/item/seeds/orangeseed = 3,/obj/item/seeds/grassseed = 3,/obj/item/seeds/cocoapodseed = 3,/obj/item/seeds/plumpmycelium = 2,
					/obj/item/seeds/cabbageseed = 3,/obj/item/seeds/grapeseed = 3,/obj/item/seeds/pumpkinseed = 3,/obj/item/seeds/cherryseed = 3,/obj/item/seeds/plastiseed = 3,/obj/item/seeds/riceseed = 3,/obj/item/seeds/shrinkshroom = 3,/obj/item/seeds/megashroom = 3)

/obj/machinery/vending/security
	req_access = list(access_security)
	products = list(/obj/item/weapon/handcuffs = 8,/obj/item/weapon/grenade/flashbang = 4,/obj/item/device/flash = 5,
					/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 12,/obj/item/weapon/storage/box/evidence = 6,
					/obj/item/weapon/gun/energy/taser = 8,/obj/item/weapon/gun/energy/stunrevolver = 4,
					/obj/item/weapon/reagent_containers/spray/pepper = 6,/obj/item/taperoll/police = 6,
					/obj/item/weapon/gun/projectile/sec/flash = 4, /obj/item/ammo_magazine/c45m/flash = 8)


/obj/machinery/vending/tool
	products = list(/obj/item/stack/cable_coil/random = 10,/obj/item/weapon/crowbar = 5,/obj/item/weapon/weldingtool = 3,/obj/item/weapon/wirecutters = 5,
					/obj/item/weapon/wrench = 5,/obj/item/device/analyzer = 5,/obj/item/device/t_scanner = 5,/obj/item/weapon/screwdriver = 5,
					/obj/item/device/flashlight/glowstick = 3, /obj/item/device/flashlight/glowstick/red = 3, /obj/item/device/flashlight/glowstick/blue = 3,
					/obj/item/device/flashlight/glowstick/orange =3, /obj/item/device/flashlight/glowstick/yellow = 3, /obj/item/weapon/reagent_containers/spray/windowsealant = 5)

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(
	/obj/item/weapon/tray = 8,
	/obj/item/weapon/material/kitchen/utensil/fork = 6,
	/obj/item/weapon/material/kitchen/utensil/knife = 6,
	/obj/item/weapon/material/kitchen/utensil/spoon = 6,
	/obj/item/weapon/material/knife = 3,
	/obj/item/weapon/material/kitchen/rollingpin = 2,
	/obj/item/weapon/reagent_containers/food/drinks/glass2/square = 8,
	/obj/item/weapon/reagent_containers/food/drinks/glass2/shake = 8,
	/obj/item/weapon/glass_extra/stick = 15,
	/obj/item/weapon/glass_extra/straw = 15,
	/obj/item/clothing/suit/chef/classic = 2,
	/obj/item/weapon/storage/toolbox/lunchbox = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/heart = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/cat = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/nt = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/mars = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/cti = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/nymph = 3,
	/obj/item/weapon/storage/toolbox/lunchbox/syndicate = 3,
	/obj/item/trash/bowl = 30)
	contraband = list(/obj/item/weapon/material/knife/butch = 2)

//I want this not just as part of the zoo. ;v
/obj/machinery/vending/food
	name = "Food-O-Mat"
	desc = "A technological marvel, supposedly able to cook or mix a large variety of food or drink."
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 4,
					/obj/item/weapon/reagent_containers/food/drinks/milk = 4,
					/obj/item/weapon/reagent_containers/food/drinks/cans/cola = 8,
					/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater = 15,
					/obj/item/weapon/reagent_containers/food/drinks/flask/barflask = 2,
					/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask = 2,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 9,
					/obj/item/weapon/reagent_containers/food/drinks/tea = 10,
					/obj/item/weapon/reagent_containers/food/snacks/appletart = 4,
					/obj/item/weapon/reagent_containers/food/snacks/cheeseburger = 10,
					/obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice = 10,
					/obj/item/weapon/reagent_containers/food/snacks/grilledcheese = 10,
					/obj/item/weapon/reagent_containers/food/snacks/hotdog = 10,
					/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato = 10,
					/obj/item/weapon/reagent_containers/food/snacks/margheritaslice = 10,
					/obj/item/weapon/reagent_containers/food/snacks/muffin = 10,
					/obj/item/weapon/reagent_containers/food/snacks/omelette = 10,
					/obj/item/weapon/reagent_containers/food/snacks/pastatomato = 10,
					/obj/item/weapon/reagent_containers/food/snacks/tofuburger = 10,
					/obj/item/weapon/reagent_containers/food/snacks/waffles = 10
					)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/mysterysoup = 10)
	vend_delay = 15