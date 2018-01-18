//Tweaked existing vendors
/obj/machinery/vending/hydroseeds/New()
	products += list(/obj/item/seeds/shrinkshroom = 3,/obj/item/seeds/megashroom = 3)
	..()

/obj/machinery/vending/security/New()
	products += list(/obj/item/weapon/gun/energy/taser = 8,/obj/item/weapon/gun/energy/stunrevolver = 4,
					/obj/item/weapon/reagent_containers/spray/pepper = 6,/obj/item/taperoll/police = 6,
					/obj/item/weapon/gun/projectile/sec/flash = 4, /obj/item/ammo_magazine/m45/flash = 8,
					/obj/item/clothing/glasses/omnihud/sec = 6)
	..()

/obj/machinery/vending/tool/New()
	products += list(/obj/item/weapon/reagent_containers/spray/windowsealant = 5)
	..()

/obj/machinery/vending/engivend/New()
	products += list(/obj/item/clothing/glasses/omnihud/eng = 6)
	..()

/obj/machinery/vending/medical/New()
	products += list(/obj/item/weapon/storage/box/khcrystal = 4,/obj/item/weapon/backup_implanter = 3,
					/obj/item/clothing/glasses/omnihud/med = 4, /obj/item/device/glasses_kit = 1)
	..()

//Custom vendors
/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(
	/obj/item/weapon/tray = 8,
	/obj/item/weapon/material/kitchen/utensil/fork = 6,
	/obj/item/weapon/material/knife/plastic = 6,
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
	products = list(/obj/item/weapon/tray = 8,
					/obj/item/weapon/material/kitchen/utensil/fork = 6,
					/obj/item/weapon/material/knife/plastic = 6,
					/obj/item/weapon/material/kitchen/utensil/spoon = 6,
					/obj/item/weapon/reagent_containers/food/snacks/tomatosoup = 8,
					/obj/item/weapon/reagent_containers/food/snacks/mushroomsoup = 8,
					/obj/item/weapon/reagent_containers/food/snacks/jellysandwich = 8,
					/obj/item/weapon/reagent_containers/food/snacks/taco = 8,
					/obj/item/weapon/reagent_containers/food/snacks/cheeseburger = 8,
					/obj/item/weapon/reagent_containers/food/snacks/grilledcheese = 8,
					/obj/item/weapon/reagent_containers/food/snacks/hotdog = 8,
					/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato = 8,
					/obj/item/weapon/reagent_containers/food/snacks/omelette = 8,
					/obj/item/weapon/reagent_containers/food/snacks/pastatomato = 8,
					/obj/item/weapon/reagent_containers/food/snacks/tofuburger = 8,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza = 2,
					/obj/item/weapon/reagent_containers/food/snacks/waffles = 4,
					/obj/item/weapon/reagent_containers/food/snacks/muffin = 4,
					/obj/item/weapon/reagent_containers/food/snacks/appletart = 4,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread = 2
					)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/mysterysoup = 10)
	vend_delay = 15

/obj/machinery/vending/food/arojoan //Fluff vendor for the lewd houseboat.
	name = "Custom Food-O-Mat"
	desc = "Do you think Joan cooks? Of course not. Lazy squirrel!"
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/weapon/tray = 6,
					/obj/item/weapon/material/kitchen/utensil/fork = 6,
					/obj/item/weapon/material/knife/plastic = 6,
					/obj/item/weapon/material/kitchen/utensil/spoon = 6,
					/obj/item/weapon/reagent_containers/food/snacks/hotandsoursoup = 3,
					/obj/item/weapon/reagent_containers/food/snacks/kitsuneudon = 3,
					/obj/item/weapon/reagent_containers/food/snacks/generalschicken = 3,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/sushi = 2,
					/obj/item/weapon/reagent_containers/food/snacks/jellysandwich = 3,
					/obj/item/weapon/reagent_containers/food/snacks/grilledcheese = 3,
					/obj/item/weapon/reagent_containers/food/snacks/hotdog = 3,
					/obj/item/weapon/storage/box/wings = 2,
					/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato = 3,
					/obj/item/weapon/reagent_containers/food/snacks/omelette = 3,
					/obj/item/weapon/reagent_containers/food/snacks/waffles = 3,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza = 1,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza = 1,
					/obj/item/weapon/reagent_containers/food/snacks/appletart = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake = 1,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread = 2,
					/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread = 2
					)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/mysterysoup = 10)
	vend_delay = 15
/* For later, then
/obj/machinery/vending/weapon_machine
	name = "Frozen Star Guns&Ammo"
	desc = "A self-defense equipment vending machine. When you need to take care of that clown."
	product_slogans = "The best defense is good offense!;Buy for your whole family today!;Nobody can outsmart bullet!;God created man - Frozen Star made them EQUAL!;Nobody can outsmart bullet!;Stupidity can be cured! By LEAD.;Dead kids can't bully your children!"
	product_ads = "Stunning!;Take justice in your own hands!;LEADearship!"
	icon_state = "weapon"
	products = list(/obj/item/device/flash = 6,/obj/item/weapon/reagent_containers/spray/pepper = 6, /obj/item/weapon/gun/projectile/olivaw = 5, /obj/item/weapon/gun/projectile/giskard = 5, /obj/item/ammo_magazine/mg/cl32/rubber = 20)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/syndicake = 6)
	prices = list(/obj/item/device/flash = 600,/obj/item/weapon/reagent_containers/spray/pepper = 800,  /obj/item/weapon/gun/projectile/olivaw = 1600, /obj/item/weapon/gun/projectile/giskard = 1200, /obj/item/ammo_magazine/mg/cl32/rubber = 200)
*/
