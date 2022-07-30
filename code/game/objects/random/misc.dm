/*
// This is going to get so incredibly bloated.
// But this is where all of the "Loot" goes. Anything fun or useful that doesn't deserve its own file, pile in.
*/

/obj/random/tool
	name = "random tool"
	desc = "This is a random tool"
	icon_state = "tool"

/obj/random/tool/item_to_spawn()
	return pick(/obj/item/tool/screwdriver,
				/obj/item/tool/wirecutters,
				/obj/item/weldingtool,
				/obj/item/weldingtool/largetank,
				/obj/item/tool/crowbar,
				/obj/item/tool/wrench,
				/obj/item/flashlight,
				/obj/item/multitool)

/obj/random/tool/powermaint
	name = "random powertool"
	desc = "This is a random rare powertool for maintenance"
	icon_state = "tool_2"

/obj/random/tool/powermaint/item_to_spawn()
	return pick(prob(320);/obj/random/tool,
				prob(1);/obj/item/tool/screwdriver/power,
				prob(1);/obj/item/tool/wirecutters/power,
				prob(15);/obj/item/weldingtool/electric,
				prob(5);/obj/item/weldingtool/experimental)

/obj/random/tool/power
	name = "random powertool"
	desc = "This is a random powertool"
	icon_state = "tool_2"

/obj/random/tool/power/item_to_spawn()
	return pick(/obj/item/tool/screwdriver/power,
				/obj/item/tool/wirecutters/power,
				/obj/item/weldingtool/electric,
				/obj/item/weldingtool/experimental)

/obj/random/tool/alien
	name = "random alien tool"
	desc = "This is a random tool"
	icon_state = "tool_3"

/obj/random/tool/alien/item_to_spawn()
	return pick(/obj/item/tool/screwdriver/alien,
				/obj/item/tool/wirecutters/alien,
				/obj/item/weldingtool/alien,
				/obj/item/tool/crowbar/alien,
				/obj/item/tool/wrench/alien,
				/obj/item/stack/cable_coil/alien,
				/obj/item/multitool/alien)

/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon_state = "tech"

/obj/random/technology_scanner/item_to_spawn()
	return pick(prob(5);/obj/item/t_scanner,
				prob(2);/obj/item/radio,
				prob(5);/obj/item/analyzer)

/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power_cells.dmi'
	icon_state = "random"

/obj/random/powercell/item_to_spawn()
	return pick(prob(40);/obj/item/cell,
				prob(25);/obj/item/cell/device,
				prob(25);/obj/item/cell/high,
				prob(9);/obj/item/cell/super,
				prob(1);/obj/item/cell/hyper)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon_state = "tech"

/obj/random/bomb_supply/item_to_spawn()
	return pick(/obj/item/assembly/igniter,
				/obj/item/assembly/prox_sensor,
				/obj/item/assembly/signaler,
				/obj/item/assembly/timer,
				/obj/item/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon_state = "toolbox"

/obj/random/toolbox/item_to_spawn()
	return pick(prob(6);/obj/item/storage/toolbox/mechanical,
				prob(6);/obj/item/storage/toolbox/electrical,
				prob(2);/obj/item/storage/toolbox/emergency,
				prob(1);/obj/item/storage/toolbox/syndicate)

/obj/random/smes_coil
	name = "random smes coil"
	desc = "This is a random smes coil."
	icon_state = "cell_2"

/obj/random/smes_coil/item_to_spawn()
	return pick(prob(4);/obj/item/smes_coil,
				prob(1);/obj/item/smes_coil/super_capacity,
				prob(1);/obj/item/smes_coil/super_io)

/obj/random/pacman
	name = "random portable generator"
	desc = "This is a random portable generator."
	icon_state = "cell_3"

/obj/random/pacman/item_to_spawn()
	return pick(prob(6);/obj/machinery/power/port_gen/pacman,
				prob(3);/obj/machinery/power/port_gen/pacman/super,
				prob(1);/obj/machinery/power/port_gen/pacman/mrs)

/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power_cells.dmi'
	icon_state = "random"
	spawn_nothing_percentage = 25

/obj/random/tech_supply/item_to_spawn()
	return pick(prob(3);/obj/random/powercell,
				prob(2);/obj/random/technology_scanner,
				prob(1);/obj/item/packageWrap,
				prob(2);/obj/random/bomb_supply,
				prob(1);/obj/item/extinguisher,
				prob(1);/obj/item/clothing/gloves/fyellow,
				prob(3);/obj/item/stack/cable_coil/random,
				prob(2);/obj/random/toolbox,
				prob(2);/obj/item/storage/belt/utility,
				prob(1);/obj/item/storage/belt/utility/full,
				prob(5);/obj/random/tool,
				prob(2);/obj/item/tape_roll,
				prob(2);/obj/item/taperoll/engineering,
				prob(1);/obj/item/taperoll/atmos,
				prob(1);/obj/item/flashlight/maglight)

/obj/random/tech_supply/nofail
	name = "guaranteed random tech supply"
	spawn_nothing_percentage = 0

/obj/random/tech_supply/component
	name = "random tech component"
	desc = "This is a random machine component."
	icon_state = "tech"

/obj/random/tech_supply/component/item_to_spawn()
	return pick(prob(3);/obj/item/stock_parts/gear,
		prob(2);/obj/item/stock_parts/console_screen,
		prob(1);/obj/item/stock_parts/spring,
		prob(3);/obj/item/stock_parts/capacitor,
		prob(2);/obj/item/stock_parts/capacitor/adv,
		prob(1);/obj/item/stock_parts/capacitor/super,
		prob(3);/obj/item/stock_parts/manipulator,
		prob(2);/obj/item/stock_parts/manipulator/nano,
		prob(1);/obj/item/stock_parts/manipulator/pico,
		prob(3);/obj/item/stock_parts/matter_bin,
		prob(2);/obj/item/stock_parts/matter_bin/adv,
		prob(1);/obj/item/stock_parts/matter_bin/super,
		prob(3);/obj/item/stock_parts/scanning_module,
		prob(2);/obj/item/stock_parts/scanning_module/adv,
		prob(1);/obj/item/stock_parts/scanning_module/phasic)

/obj/random/tech_supply/component/nofail
	name = "guaranteed random tech component"
	spawn_nothing_percentage = 0

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon_state = "medical"

/obj/random/medical/item_to_spawn()
	return pick(prob(21);/obj/random/medical/lite,
				prob(5);/obj/random/medical/pillbottle,
				prob(1);/obj/item/storage/pill_bottle/tramadol,
				prob(1);/obj/item/storage/pill_bottle/antitox,
				prob(1);/obj/item/storage/pill_bottle/carbon,
				prob(3);/obj/item/bodybag/cryobag,
				prob(5);/obj/item/reagent_containers/syringe/antitoxin,
				prob(3);/obj/item/reagent_containers/syringe/antiviral,
				prob(5);/obj/item/reagent_containers/syringe/inaprovaline,
				prob(1);/obj/item/reagent_containers/hypospray,
				prob(1);/obj/item/storage/box/freezer,
				prob(2);/obj/item/stack/nanopaste)

/obj/random/medical/pillbottle
	name = "Random Pill Bottle"
	desc = "This is a random pill bottle."
	icon_state = "pillbottle"

/obj/random/medical/pillbottle/item_to_spawn()
	return pick(prob(1);/obj/item/storage/pill_bottle/spaceacillin,
				prob(1);/obj/item/storage/pill_bottle/dermaline,
				prob(1);/obj/item/storage/pill_bottle/dexalin_plus,
				prob(1);/obj/item/storage/pill_bottle/bicaridine,
				prob(1);/obj/item/storage/pill_bottle/iron)

/obj/random/medical/lite
	name = "Random Medicine"
	desc = "This is a random simple medical item."
	icon_state = "medical"
	spawn_nothing_percentage = 25

/obj/random/medical/lite/item_to_spawn()
	return pick(prob(4);/obj/item/stack/medical/bruise_pack,
				prob(4);/obj/item/stack/medical/ointment,
				prob(2);/obj/item/stack/medical/advanced/bruise_pack,
				prob(2);/obj/item/stack/medical/advanced/ointment,
				prob(1);/obj/item/stack/medical/splint,
				prob(4);/obj/item/healthanalyzer,
				prob(1);/obj/item/bodybag,
				prob(3);/obj/item/reagent_containers/hypospray/autoinjector,
				prob(2);/obj/item/storage/pill_bottle/kelotane,
				prob(2);/obj/item/storage/pill_bottle/antitox)

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon_state = "medicalkit"

/obj/random/firstaid/item_to_spawn()
	return pick(prob(10);/obj/item/storage/firstaid/regular,
				prob(8);/obj/item/storage/firstaid/toxin,
				prob(8);/obj/item/storage/firstaid/o2,
				prob(6);/obj/item/storage/firstaid/adv,
				prob(8);/obj/item/storage/firstaid/fire,
				prob(1);/obj/item/denecrotizer/medical, //VOREStation Add,
				prob(1);/obj/item/storage/firstaid/combat)

/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon_state = "sus"
	spawn_nothing_percentage = 50
/obj/random/contraband/item_to_spawn()
	return pick(prob(6);/obj/item/storage/pill_bottle/paracetamol, //VOREStation Edit,
				prob(6);/obj/item/storage/pill_bottle/tramadol,
				prob(4);/obj/item/storage/pill_bottle/happy,
				prob(4);/obj/item/storage/pill_bottle/zoom,
				prob(4);/obj/item/material/butterfly,
				prob(6);/obj/item/material/butterflyblade,
				prob(6);/obj/item/material/butterflyhandle,
				prob(2);/obj/item/material/butterfly/switchblade,
				prob(2);/obj/item/clothing/gloves/knuckledusters,
				prob(1);/obj/item/material/knife/tacknife,
				prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,
				prob(1);/obj/item/beartrap,
				prob(1);/obj/item/handcuffs,
				prob(1);/obj/item/handcuffs/legcuffs,
				prob(2);/obj/item/reagent_containers/syringe/drugs,
				prob(1);/obj/item/reagent_containers/syringe/steroid)

/obj/random/contraband/nofail
	name = "Guaranteed Random Illegal Item"
	spawn_nothing_percentage = 0

/obj/random/cash
	name = "random currency"
	desc = "LOADSAMONEY!"
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"

/obj/random/cash/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(12);/obj/item/spacecash/c1,
				prob(8);/obj/item/spacecash/c10,
				prob(4);/obj/item/spacecash/c20,
				prob(1);/obj/item/spacecash/c50,
				prob(1);/obj/item/spacecash/c100)

/obj/random/cash/big
	name = "random currency pile"
	desc = "DOSH!"
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash100"

/obj/random/cash/big/item_to_spawn()
	return pick(prob(64);/obj/item/spacecash/c10,
				prob(32);/obj/item/spacecash/c20,
				prob(16);/obj/item/spacecash/c50,
				prob(8);/obj/item/spacecash/c100,
				prob(4);/obj/item/spacecash/c200,
				prob(2);/obj/item/spacecash/c500,
				prob(1);/obj/item/spacecash/c1000)

/obj/random/cash/huge
	name = "random huge currency pile"
	desc = "LOOK AT MY WAD!"
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1000"

/obj/random/cash/huge/item_to_spawn()
	return pick(prob(15);/obj/item/spacecash/c200,
				prob(10);/obj/item/spacecash/c500,
				prob(5);/obj/item/spacecash/c1000)

/obj/random/soap
	name = "Random Soap"
	desc = "This is a random bar of soap."
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"

/obj/random/soap/item_to_spawn()
	return pick(prob(3);/obj/item/soap,
				prob(2);/obj/item/soap/nanotrasen,
				prob(2);/obj/item/soap/deluxe,
				prob(1);/obj/item/soap/syndie)


/obj/random/drinkbottle
	name = "random drink"
	desc = "This is a random drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "whiskeybottle"

/obj/random/drinkbottle/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/drinks/bottle/whiskey,
				/obj/item/reagent_containers/food/drinks/bottle/gin,
				/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,
				/obj/item/reagent_containers/food/drinks/bottle/vodka,
				/obj/item/reagent_containers/food/drinks/bottle/tequilla,
				/obj/item/reagent_containers/food/drinks/bottle/absinthe,
				/obj/item/reagent_containers/food/drinks/bottle/wine,
				/obj/item/reagent_containers/food/drinks/bottle/cognac,
				/obj/item/reagent_containers/food/drinks/bottle/rum,
				/obj/item/reagent_containers/food/drinks/bottle/patron,
				/obj/item/reagent_containers/food/drinks/bottle/vermouth,
				/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
				/obj/item/reagent_containers/food/drinks/bottle/kahlua,
				/obj/item/reagent_containers/food/drinks/bottle/melonliquor,
				/obj/item/reagent_containers/food/drinks/bottle/bluecuracao,
				/obj/item/reagent_containers/food/drinks/bottle/grenadine,
				/obj/item/reagent_containers/food/drinks/bottle/sake,
				/obj/item/reagent_containers/food/drinks/bottle/champagne,
				/obj/item/reagent_containers/food/drinks/bottle/peppermintschnapps,
				/obj/item/reagent_containers/food/drinks/bottle/peachschnapps,
				/obj/item/reagent_containers/food/drinks/bottle/lemonadeschnapps,
				/obj/item/reagent_containers/food/drinks/bottle/jager,
				/obj/item/reagent_containers/food/drinks/bottle/small/cider,
				/obj/item/reagent_containers/food/drinks/bottle/small/litebeer,
				/obj/item/reagent_containers/food/drinks/bottle/small/beer,
				/obj/item/reagent_containers/food/drinks/bottle/small/beer/silverdragon,
				/obj/item/reagent_containers/food/drinks/bottle/small/beer/meteor)

/obj/random/drinksoft
	name = "random soft drink"
	desc = "This is a random (once) carbonated beverage drinks can."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "cola"

/obj/random/drinksoft/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/drinks/cans/cola,
				/obj/item/reagent_containers/food/drinks/cans/waterbottle,
				/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind,
				/obj/item/reagent_containers/food/drinks/cans/thirteenloko,
				/obj/item/reagent_containers/food/drinks/cans/dr_gibb,
				/obj/item/reagent_containers/food/drinks/cans/dr_gibb_diet,
				/obj/item/reagent_containers/food/drinks/cans/starkist,
				/obj/item/reagent_containers/food/drinks/cans/space_up,
				/obj/item/reagent_containers/food/drinks/cans/lemon_lime,
				/obj/item/reagent_containers/food/drinks/cans/iced_tea,
				/obj/item/reagent_containers/food/drinks/cans/grape_juice,
				/obj/item/reagent_containers/food/drinks/cans/tonic,
				/obj/item/reagent_containers/food/drinks/cans/sodawater,
				/obj/item/reagent_containers/food/drinks/cans/gingerale,
				/obj/item/reagent_containers/food/drinks/cans/root_beer)


/obj/random/snack
	name = "random snack"
	desc = "This is a random snackfood. Probably still safe to eat?"
	icon = 'icons/obj/food_snacks.dmi'
	icon_state = "tastybread"

/obj/random/snack/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/snacks/candy,
				/obj/item/reagent_containers/food/snacks/candy/proteinbar,
				/obj/item/reagent_containers/food/snacks/candy/gummy,
				/obj/item/reagent_containers/food/snacks/candy/donor,
				/obj/item/reagent_containers/food/snacks/candy_corn,
				/obj/item/reagent_containers/food/snacks/chips,
				/obj/item/reagent_containers/food/snacks/chips/bbq,
				/obj/item/reagent_containers/food/snacks/cookiesnack,
				/obj/item/reagent_containers/food/snacks/fruitbar,
				/obj/item/reagent_containers/food/snacks/chocolatebar,
				/obj/item/reagent_containers/food/snacks/chocolatepiece,
				/obj/item/reagent_containers/food/snacks/chocolatepiece/white,
				/obj/item/reagent_containers/food/snacks/chocolatepiece/truffle,
				/obj/item/reagent_containers/food/snacks/chocolateegg,
				/obj/item/reagent_containers/food/snacks/donut/plain,
				/obj/item/reagent_containers/food/snacks/donut/plain/jelly,
				/obj/item/reagent_containers/food/snacks/donut/pink,
				/obj/item/reagent_containers/food/snacks/donut/pink/jelly,
				/obj/item/reagent_containers/food/snacks/donut/purple,
				/obj/item/reagent_containers/food/snacks/donut/purple/jelly,
				/obj/item/reagent_containers/food/snacks/donut/green,
				/obj/item/reagent_containers/food/snacks/donut/green/jelly,
				/obj/item/reagent_containers/food/snacks/donut/beige,
				/obj/item/reagent_containers/food/snacks/donut/beige/jelly,
				/obj/item/reagent_containers/food/snacks/donut/choc,
				/obj/item/reagent_containers/food/snacks/donut/choc/jelly,
				/obj/item/reagent_containers/food/snacks/donut/blue,
				/obj/item/reagent_containers/food/snacks/donut/blue/jelly,
				/obj/item/reagent_containers/food/snacks/donut/yellow,
				/obj/item/reagent_containers/food/snacks/donut/yellow/jelly,
				/obj/item/reagent_containers/food/snacks/donut/olive,
				/obj/item/reagent_containers/food/snacks/donut/olive/jelly,
				/obj/item/reagent_containers/food/snacks/donut/homer,
				/obj/item/reagent_containers/food/snacks/donut/homer/jelly,
				/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles,
				/obj/item/reagent_containers/food/snacks/donut/choc_sprinkles/jelly,
				/obj/item/reagent_containers/food/snacks/tuna,
				/obj/item/reagent_containers/food/snacks/pistachios,
				/obj/item/reagent_containers/food/snacks/semki,
				/obj/item/reagent_containers/food/snacks/cb01,
				/obj/item/reagent_containers/food/snacks/cb02,
				/obj/item/reagent_containers/food/snacks/cb03,
				/obj/item/reagent_containers/food/snacks/cb04,
				/obj/item/reagent_containers/food/snacks/cb05,
				/obj/item/reagent_containers/food/snacks/cb06,
				/obj/item/reagent_containers/food/snacks/cb07,
				/obj/item/reagent_containers/food/snacks/cb08,
				/obj/item/reagent_containers/food/snacks/cb09,
				/obj/item/reagent_containers/food/snacks/cb10,
				/obj/item/reagent_containers/food/snacks/tofu,
				/obj/item/reagent_containers/food/snacks/donkpocket,
				/obj/item/reagent_containers/food/snacks/muffin,
				/obj/item/reagent_containers/food/snacks/soylentgreen,
				/obj/item/reagent_containers/food/snacks/soylenviridians,
				/obj/item/reagent_containers/food/snacks/popcorn,
				/obj/item/reagent_containers/food/snacks/sosjerky,
				/obj/item/reagent_containers/food/snacks/no_raisin,
				/obj/item/reagent_containers/food/snacks/packaged/spacetwinkie,
				/obj/item/reagent_containers/food/snacks/cheesiehonkers,
				/obj/item/reagent_containers/food/snacks/poppypretzel,
				/obj/item/reagent_containers/food/snacks/baguette,
				/obj/item/reagent_containers/food/snacks/carrotfries,
				/obj/item/reagent_containers/food/snacks/candiedapple,
				/obj/item/storage/box/admints,
				/obj/item/reagent_containers/food/snacks/tastybread,
				/obj/item/reagent_containers/food/snacks/liquidfood,
				/obj/item/reagent_containers/food/snacks/liquidprotein,
				/obj/item/reagent_containers/food/snacks/liquidvitamin,
				/obj/item/reagent_containers/food/snacks/skrellsnacks,
				/obj/item/reagent_containers/food/snacks/unajerky,
				/obj/item/reagent_containers/food/snacks/croissant,
				/obj/item/reagent_containers/food/snacks/sugarcookie,
				/obj/item/reagent_containers/food/drinks/dry_ramen)

/obj/random/meat
	name = "random meat"
	desc = "This is a random slab of meat."
	icon = 'icons/obj/food.dmi'
	icon_state = "meat"

/obj/random/meat/item_to_spawn()
	return pick(prob(60);/obj/item/reagent_containers/food/snacks/meat,
				prob(20);/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat,
				prob(10);/obj/item/reagent_containers/food/snacks/carpmeat,
				prob(5);/obj/item/reagent_containers/food/snacks/bearmeat,
				prob(1);/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
				prob(1);/obj/item/reagent_containers/food/snacks/meat/human,
				prob(1);/obj/item/reagent_containers/food/snacks/meat/monkey,
				prob(1);/obj/item/reagent_containers/food/snacks/meat/corgi,
				prob(1);/obj/item/reagent_containers/food/snacks/xenomeat)

/obj/random/pizzabox
	name = "random pizza box"
	desc = "This is a random pizza box."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"

/obj/random/pizzabox/item_to_spawn()
	return pick(/obj/item/pizzabox/margherita,
				/obj/item/pizzabox/mushroom,
				/obj/item/pizzabox/meat,
				/obj/item/pizzabox/vegetable,
				/obj/item/pizzabox/pineapple)

/obj/random/material //Random materials for building stuff
	name = "random material"
	desc = "This is a random material."
	icon_state = "material"

/obj/random/material/item_to_spawn()
	return pick(/obj/item/stack/material/steel{amount = 10},
				/obj/item/stack/material/glass{amount = 10},
				/obj/item/stack/material/glass/reinforced{amount = 10},
				/obj/item/stack/material/plastic{amount = 10},
				/obj/item/stack/material/wood{amount = 10},
				/obj/item/stack/material/wood/sif{amount = 10},
				/obj/item/stack/material/cardboard{amount = 10},
				/obj/item/stack/rods{amount = 10},
				/obj/item/stack/material/sandstone{amount = 10},
				/obj/item/stack/material/marble{amount = 10},
				/obj/item/stack/material/plasteel{amount = 10})

/obj/random/material/refined //Random materials for building stuff
	name = "random refined material"
	desc = "This is a random refined metal."
	icon_state = "material_2"

/obj/random/material/refined/item_to_spawn()
	return pick(/obj/item/stack/material/steel{amount = 10},
				/obj/item/stack/material/glass{amount = 10},
				/obj/item/stack/material/glass/reinforced{amount = 5},
				/obj/item/stack/material/glass/phoronglass{amount = 5},
				/obj/item/stack/material/glass/phoronrglass{amount = 5},
				/obj/item/stack/material/plasteel{amount = 5},
				/obj/item/stack/material/durasteel{amount = 5},
				/obj/item/stack/material/gold{amount = 5},
				/obj/item/stack/material/iron{amount = 10},
				/obj/item/stack/material/copper{amount = 10},
				/obj/item/stack/material/aluminium{amount = 10},
				/obj/item/stack/material/lead{amount = 10},
				/obj/item/stack/material/diamond{amount = 3},
				/obj/item/stack/material/deuterium{amount = 5},
				/obj/item/stack/material/uranium{amount = 5},
				/obj/item/stack/material/phoron{amount = 5},
				/obj/item/stack/material/silver{amount = 5},
				/obj/item/stack/material/platinum{amount = 5},
				/obj/item/stack/material/mhydrogen{amount = 3},
				/obj/item/stack/material/osmium{amount = 3},
				/obj/item/stack/material/titanium{amount = 5},
				/obj/item/stack/material/tritium{amount = 3},
				/obj/item/stack/material/verdantium{amount = 2})

/obj/random/material/precious //Precious metals, go figure
	name = "random precious metal"
	desc = "This is a small stack of a random precious metal."
	icon_state = "material_3"

/obj/random/material/precious/item_to_spawn()
	return pick(/obj/item/stack/material/gold{amount = 5},
				/obj/item/stack/material/copper{amount = 5},
				/obj/item/stack/material/silver{amount = 5},
				/obj/item/stack/material/platinum{amount = 5},
				/obj/item/stack/material/osmium{amount = 5})

/obj/random/tank
	name = "random tank"
	desc = "This is a tank."
	icon = 'icons/obj/tank.dmi'
	icon_state = "canister"

/obj/random/tank/item_to_spawn()
	return pick(prob(5);/obj/item/tank/oxygen,
				prob(4);/obj/item/tank/oxygen/yellow,
				prob(4);/obj/item/tank/oxygen/red,
				prob(3);/obj/item/tank/air,
				prob(4);/obj/item/tank/emergency/oxygen,
				prob(3);/obj/item/tank/emergency/oxygen/engi,
				prob(2);/obj/item/tank/emergency/oxygen/double,
				prob(1);/obj/item/suit_cooling_unit)

/obj/random/cigarettes
	name = "random cigarettes"
	desc = "This is a cigarette."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"

/obj/random/cigarettes/item_to_spawn()
	return pick(prob(5);/obj/item/storage/fancy/cigarettes,
				prob(4);/obj/item/storage/fancy/cigarettes/dromedaryco,
				prob(3);/obj/item/storage/fancy/cigarettes/killthroat,
				prob(3);/obj/item/storage/fancy/cigarettes/luckystars,
				prob(3);/obj/item/storage/fancy/cigarettes/jerichos,
				prob(3);/obj/item/storage/fancy/cigarettes/menthols,
				prob(3);/obj/item/storage/fancy/cigarettes/carcinomas,
				prob(3);/obj/item/storage/fancy/cigarettes/professionals,
				prob(1);/obj/item/storage/fancy/cigar,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/havana)

/obj/random/coin
	name = "random coin"
	desc = "This is a coin spawn."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/random/coin/item_to_spawn()
	return pick(prob(5);/obj/item/coin/silver,
				prob(3);/obj/item/coin/iron,
				prob(4);/obj/item/coin/gold,
				prob(3);/obj/item/coin/phoron,
				prob(1);/obj/item/coin/uranium,
				prob(2);/obj/item/coin/platinum,
				prob(1);/obj/item/coin/diamond)

//VOREStation Add Start
/obj/random/coin/sometimes
	spawn_nothing_percentage = 66

//VOREStation Add End

/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"

/obj/random/action_figure/item_to_spawn()
	return pick(/obj/item/toy/figure/cmo,
				/obj/item/toy/figure/assistant,
				/obj/item/toy/figure/atmos,
				/obj/item/toy/figure/bartender,
				/obj/item/toy/figure/borg,
				/obj/item/toy/figure/gardener,
				/obj/item/toy/figure/captain,
				/obj/item/toy/figure/cargotech,
				/obj/item/toy/figure/ce,
				/obj/item/toy/figure/chaplain,
				/obj/item/toy/figure/chef,
				/obj/item/toy/figure/chemist,
				/obj/item/toy/figure/clown,
				/obj/item/toy/figure/corgi,
				/obj/item/toy/figure/detective,
				/obj/item/toy/figure/dsquad,
				/obj/item/toy/figure/engineer,
				/obj/item/toy/figure/geneticist,
				/obj/item/toy/figure/hop,
				/obj/item/toy/figure/hos,
				/obj/item/toy/figure/qm,
				/obj/item/toy/figure/janitor,
				/obj/item/toy/figure/agent,
				/obj/item/toy/figure/librarian,
				/obj/item/toy/figure/md,
				/obj/item/toy/figure/mime,
				/obj/item/toy/figure/miner,
				/obj/item/toy/figure/ninja,
				/obj/item/toy/figure/wizard,
				/obj/item/toy/figure/rd,
				/obj/item/toy/figure/roboticist,
				/obj/item/toy/figure/scientist,
				/obj/item/toy/figure/syndie,
				/obj/item/toy/figure/secofficer,
				/obj/item/toy/figure/warden,
				/obj/item/toy/figure/psychologist,
				/obj/item/toy/figure/paramedic,
				/obj/item/toy/figure/ert)

/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"

/obj/random/plushie/item_to_spawn()
	return pick(/obj/item/toy/plushie/nymph,
				/obj/item/toy/plushie/mouse,
				/obj/item/toy/plushie/kitten,
				/obj/item/toy/plushie/lizard,
				/obj/item/toy/plushie/black_cat,
				/obj/item/toy/plushie/black_fox,
				/obj/item/toy/plushie/blue_fox,
				/obj/random/carp_plushie,
				/obj/item/toy/plushie/coffee_fox,
				/obj/item/toy/plushie/corgi,
				/obj/item/toy/plushie/crimson_fox,
				/obj/item/toy/plushie/deer,
				/obj/item/toy/plushie/girly_corgi,
				/obj/item/toy/plushie/grey_cat,
				/obj/item/toy/plushie/marble_fox,
				/obj/item/toy/plushie/octopus,
				/obj/item/toy/plushie/orange_cat,
				/obj/item/toy/plushie/orange_fox,
				/obj/item/toy/plushie/pink_fox,
				/obj/item/toy/plushie/purple_fox,
				/obj/item/toy/plushie/red_fox,
				/obj/item/toy/plushie/robo_corgi,
				/obj/item/toy/plushie/siamese_cat,
				/obj/item/toy/plushie/spider,
				/obj/item/toy/plushie/tabby_cat,
				/obj/item/toy/plushie/tuxedo_cat,
				/obj/item/toy/plushie/white_cat,
				//VOREStation Add Start
				/obj/item/toy/plushie/lizardplushie,
				/obj/item/toy/plushie/lizardplushie/kobold,
				/obj/item/toy/plushie/lizardplushie/resh,
				/obj/item/toy/plushie/slimeplushie,
				/obj/item/toy/plushie/box,
				/obj/item/toy/plushie/borgplushie,
				/obj/item/toy/plushie/borgplushie/medihound,
				/obj/item/toy/plushie/borgplushie/scrubpuppy,
				/obj/item/toy/plushie/foxbear,
				/obj/item/toy/plushie/nukeplushie,
				/obj/item/toy/plushie/otter,
				/obj/item/toy/plushie/vox,
				/obj/item/toy/plushie/borgplushie/drakiesec,
				/obj/item/toy/plushie/borgplushie/drakiemed)
				//VOREStation Add End

/obj/random/plushielarge
	name = "random large plushie"
	desc = "This is a randomn large plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "droneplushie"

/obj/random/plushielarge/item_to_spawn()
	return pick(/obj/structure/plushie/ian,
				/obj/structure/plushie/drone,
				/obj/structure/plushie/carp,
				/obj/structure/plushie/beepsky)

/obj/random/toy
	name = "random toy"
	desc = "This is a random toy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"

/obj/random/toy/item_to_spawn()
	return pick(/obj/item/toy/bosunwhistle,
				/obj/item/toy/plushie/therapy/red,
				/obj/item/toy/plushie/therapy/purple,
				/obj/item/toy/plushie/therapy/blue,
				/obj/item/toy/plushie/therapy/yellow,
				/obj/item/toy/plushie/therapy/orange,
				/obj/item/toy/plushie/therapy/green,
				/obj/item/toy/cultsword,
				/obj/item/toy/katana,
				/obj/item/toy/snappop,
				/obj/item/toy/sword,
				/obj/item/toy/balloon,
				/obj/item/gun/projectile/revolver/toy/crossbow,
				/obj/item/toy/blink,
				/obj/item/reagent_containers/spray/waterflower,
				/obj/item/toy/eight_ball,
				/obj/item/toy/eight_ball/conch,
				/obj/item/toy/mecha/ripley,
				/obj/item/toy/mecha/fireripley,
				/obj/item/toy/mecha/deathripley,
				/obj/item/toy/mecha/gygax,
				/obj/item/toy/mecha/durand,
				/obj/item/toy/mecha/honk,
				/obj/item/toy/mecha/marauder,
				/obj/item/toy/mecha/seraph,
				/obj/item/toy/mecha/mauler,
				/obj/item/toy/mecha/odysseus,
				/obj/item/toy/mecha/phazon)

/obj/random/mouseremains
	name = "random mouseremains"
	desc = "For use with mouse spawners."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "mousetrap"

/obj/random/mouseremains/item_to_spawn()
	return pick(/obj/item/assembly/mousetrap,
				/obj/item/assembly/mousetrap/armed,
				/obj/effect/decal/cleanable/bug_remains,
				/obj/effect/decal/cleanable/ash,
				/obj/item/trash/cigbutt,
				/obj/item/trash/cigbutt/cigarbutt,
				/obj/effect/decal/remains/mouse)

/obj/random/janusmodule
	name = "random janus circuit"
	desc = "A random (possibly broken) Janus module."
	icon_state = "tech_2"

/obj/random/janusmodule/item_to_spawn()
	return pick(subtypesof(/obj/item/circuitboard/mecha/imperion))

/obj/random/curseditem
	name = "random cursed item"
	desc = "For use in dungeons."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"

/obj/random/curseditem/item_to_spawn()
	var/possible_object_paths = list(/obj/item/paper/carbon/cursedform)
	possible_object_paths |= subtypesof(/obj/item/clothing/head/psy_crown)
	return pick(possible_object_paths)

//Random MRE stuff

/obj/random/mre
	name = "random MRE"
	desc = "This is a random single MRE."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	drop_get_turf = FALSE

/obj/random/mre/item_to_spawn()
	return pick(/obj/item/storage/mre,
				/obj/item/storage/mre/menu2,
				/obj/item/storage/mre/menu3,
				/obj/item/storage/mre/menu4,
				/obj/item/storage/mre/menu5,
				/obj/item/storage/mre/menu6,
				/obj/item/storage/mre/menu7,
				/obj/item/storage/mre/menu8,
				/obj/item/storage/mre/menu9,
				/obj/item/storage/mre/menu10)


/obj/random/mre/main
	name = "random MRE main course"
	desc = "This is a random main course for MREs."
	icon_state = "pouch"
	drop_get_turf = FALSE

/obj/random/mre/main/item_to_spawn()
	return pick(/obj/item/storage/mrebag,
				/obj/item/storage/mrebag/menu2,
				/obj/item/storage/mrebag/menu3,
				/obj/item/storage/mrebag/menu4,
				/obj/item/storage/mrebag/menu5,
				/obj/item/storage/mrebag/menu6,
				/obj/item/storage/mrebag/menu7,
				/obj/item/storage/mrebag/menu8)

/obj/random/mre/side
	name = "random MRE side dish"
	desc = "This is a random side dish for MREs."
	icon_state = "pouch"
	drop_get_turf = FALSE

/obj/random/mre/side/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/snacks/tossedsalad,
				/obj/item/reagent_containers/food/snacks/boiledrice,
				/obj/item/reagent_containers/food/snacks/poppypretzel,
				/obj/item/reagent_containers/food/snacks/twobread,
				/obj/item/reagent_containers/food/snacks/jelliedtoast)

/obj/random/mre/dessert
	name = "random MRE dessert"
	desc = "This is a random dessert for MREs."
	icon_state = "pouch"
	drop_get_turf = FALSE

/obj/random/mre/dessert/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/snacks/candy,
				/obj/item/reagent_containers/food/snacks/candy/proteinbar,
				/obj/item/reagent_containers/food/snacks/donut/plain,
				/obj/item/reagent_containers/food/snacks/donut/plain/jelly,
				/obj/item/reagent_containers/food/snacks/chocolatebar,
				/obj/item/reagent_containers/food/snacks/cookiesnack)

/obj/random/mre/dessert/vegan
	name = "random vegan MRE dessert"
	desc = "This is a random vegan dessert for MREs."

/obj/random/mre/dessert/vegan/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/snacks/candy,
				/obj/item/reagent_containers/food/snacks/chocolatebar,
				/obj/item/reagent_containers/food/snacks/donut/plain/jelly,
				/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit)

/obj/random/mre/drink
	name = "random MRE drink"
	desc = "This is a random drink for MREs."
	icon_state = "packet"
	drop_get_turf = FALSE

/obj/random/mre/drink/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/coffee,
				/obj/item/reagent_containers/food/condiment/small/packet/tea,
				/obj/item/reagent_containers/food/condiment/small/packet/cocoa,
				/obj/item/reagent_containers/food/condiment/small/packet/grape,
				/obj/item/reagent_containers/food/condiment/small/packet/orange,
				/obj/item/reagent_containers/food/condiment/small/packet/watermelon,
				/obj/item/reagent_containers/food/condiment/small/packet/apple)

/obj/random/mre/spread
	name = "random MRE spread"
	desc = "This is a random spread packet for MREs."
	icon_state = "packet"
	drop_get_turf = FALSE

/obj/random/mre/spread/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/jelly,
				/obj/item/reagent_containers/food/condiment/small/packet/honey)

/obj/random/mre/spread/vegan
	name = "random vegan MRE spread"
	desc = "This is a random vegan spread packet for MREs"

/obj/random/mre/spread/vegan/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/jelly)

/obj/random/mre/sauce
	name = "random MRE sauce"
	desc = "This is a random sauce packet for MREs."
	icon_state = "packet"
	drop_get_turf = FALSE

/obj/random/mre/sauce/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/salt,
				/obj/item/reagent_containers/food/condiment/small/packet/pepper,
				/obj/item/reagent_containers/food/condiment/small/packet/sugar,
				/obj/item/reagent_containers/food/condiment/small/packet/capsaicin,
				/obj/item/reagent_containers/food/condiment/small/packet/ketchup,
				/obj/item/reagent_containers/food/condiment/small/packet/mayo,
				/obj/item/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/vegan/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/salt,
				/obj/item/reagent_containers/food/condiment/small/packet/pepper,
				/obj/item/reagent_containers/food/condiment/small/packet/sugar,
				/obj/item/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/sugarfree/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/salt,
				/obj/item/reagent_containers/food/condiment/small/packet/pepper,
				/obj/item/reagent_containers/food/condiment/small/packet/capsaicin,
				/obj/item/reagent_containers/food/condiment/small/packet/ketchup,
				/obj/item/reagent_containers/food/condiment/small/packet/mayo,
				/obj/item/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/crayon/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/condiment/small/packet/crayon/generic,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/red,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/orange,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/yellow,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/green,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/blue,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/purple,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/grey,
				/obj/item/reagent_containers/food/condiment/small/packet/crayon/brown)

/obj/random/thermalponcho
	name = "random thermal poncho"
	desc = "This is a thermal poncho spawn."
	icon = 'icons/inventory/accessory/item.dmi'
	icon_state = "classicponcho"

/obj/random/thermalponcho/item_to_spawn()
	return pick(prob(5);/obj/item/clothing/accessory/poncho/thermal,
				prob(3);/obj/item/clothing/accessory/poncho/thermal/red,
				prob(3);/obj/item/clothing/accessory/poncho/thermal/green,
				prob(3);/obj/item/clothing/accessory/poncho/thermal/purple,
				prob(3);/obj/item/clothing/accessory/poncho/thermal/blue)

/obj/random/pouch
	name = "Random Storage Pouch"
	desc = "This is a random storage pouch."
	icon = 'icons/inventory/pockets/item.dmi'
	icon_state = "random"

/obj/random/pouch/item_to_spawn()
	return pick(
		prob(10);/obj/item/weapon/storage/pouch, // medium
		prob(3);/obj/item/weapon/storage/pouch/large,
		prob(8);/obj/item/weapon/storage/pouch/small,
		prob(5);/obj/item/weapon/storage/pouch/ammo,
		prob(5);/obj/item/weapon/storage/pouch/eng_tool,
		prob(5);/obj/item/weapon/storage/pouch/eng_supply,
		prob(5);/obj/item/weapon/storage/pouch/eng_parts,
		prob(5);/obj/item/weapon/storage/pouch/medical,
		prob(5);/obj/item/weapon/storage/pouch/flares/full_flare,
		prob(5);/obj/item/weapon/storage/pouch/flares/full_glow,
		prob(5);/obj/item/weapon/storage/pouch/holster,
		prob(5);/obj/item/weapon/storage/pouch/baton/full,
		prob(1);/obj/item/weapon/storage/pouch/holding
	)

/obj/random/flashlight
	name = "Random Flashlight"
	desc = "This is a random storage pouch."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "random_flashlight"

/obj/random/flashlight/item_to_spawn()
	return pick(
		prob(8);/obj/item/flashlight,
		prob(6);/obj/item/flashlight/color,
		prob(6);/obj/item/flashlight/color/green,
		prob(6);/obj/item/flashlight/color/purple,
		prob(6);/obj/item/flashlight/color/red,
		prob(6);/obj/item/flashlight/color/orange,
		prob(6);/obj/item/flashlight/color/yellow,
		prob(2);/obj/item/flashlight/maglight
	)

/obj/random/mug
	name = "Random Mug"
	desc = "This is a random coffee mug."
	icon = 'icons/obj/drinks_mugs.dmi'
	icon_state = "coffeecup_spawner"

/obj/random/mug/item_to_spawn()
	return pick(/obj/item/reagent_containers/food/drinks/glass2/coffeemug,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/sol,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/fleet,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/fivearrows,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/psc,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/alma,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/almp,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/nt,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/metal/wulf,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/gilthari,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/zeng,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/wt,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/aether,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/bishop,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/oculum,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/one,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/puni,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/heart,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/pawn,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/diona,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/britcup,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/tourist,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/flame,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/blue,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/black,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/green,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/green/dark,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/rainbow,
				/obj/item/reagent_containers/food/drinks/glass2/coffeemug/metal)

/obj/random/donkpocketbox
	name = "Random Donk-pocket Box"
	desc = "This is a random Donk-pocket Box."
	icon = 'icons/obj/boxes.dmi'
	icon_state = "donkpocket_spawner"

/obj/random/donkpocketbox/item_to_spawn()
	return pick(/obj/item/storage/box/donkpockets,
				/obj/item/storage/box/donkpockets/spicy,
				/obj/item/storage/box/donkpockets/teriyaki,
				/obj/item/storage/box/donkpockets/pizza,
				/obj/item/storage/box/donkpockets/honk,
				/obj/item/storage/box/donkpockets/gondola,
				/obj/item/storage/box/donkpockets/berry)
