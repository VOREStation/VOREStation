/*
// This is going to get so incredibly bloated.
// But this is where all of the "Loot" goes. Anything fun or useful that doesn't deserve its own file, pile in.
*/

/obj/random/tool
	name = "random tool"
	desc = "This is a random tool"
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"

/obj/random/tool/item_to_spawn()
	return pick(/obj/item/weapon/tool/screwdriver,
				/obj/item/weapon/tool/wirecutters,
				/obj/item/weapon/weldingtool,
				/obj/item/weapon/weldingtool/largetank,
				/obj/item/weapon/tool/crowbar,
				/obj/item/weapon/tool/wrench,
				/obj/item/device/flashlight,
				/obj/item/device/multitool)

/obj/random/tool/powermaint
	name = "random powertool"
	desc = "This is a random rare powertool for maintenance"
	icon_state = "jaws_pry"

/obj/random/tool/powermaint/item_to_spawn()
	return pick(prob(320);/obj/random/tool,
				prob(1);/obj/item/weapon/tool/screwdriver/power,
				prob(1);/obj/item/weapon/tool/wirecutters/power,
				prob(15);/obj/item/weapon/weldingtool/electric,
				prob(5);/obj/item/weapon/weldingtool/experimental)

/obj/random/tool/power
	name = "random powertool"
	desc = "This is a random powertool"
	icon_state = "jaws_pry"

/obj/random/tool/power/item_to_spawn()
	return pick(/obj/item/weapon/tool/screwdriver/power,
				/obj/item/weapon/tool/wirecutters/power,
				/obj/item/weapon/weldingtool/electric,
				/obj/item/weapon/weldingtool/experimental)

/obj/random/tool/alien
	name = "random alien tool"
	desc = "This is a random tool"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "welder"

/obj/random/tool/alien/item_to_spawn()
	return pick(/obj/item/weapon/tool/screwdriver/alien,
				/obj/item/weapon/tool/wirecutters/alien,
				/obj/item/weapon/weldingtool/alien,
				/obj/item/weapon/tool/crowbar/alien,
				/obj/item/weapon/tool/wrench/alien,
				/obj/item/stack/cable_coil/alien,
				/obj/item/device/multitool/alien)

/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/device.dmi'
	icon_state = "atmos"

/obj/random/technology_scanner/item_to_spawn()
	return pick(prob(5);/obj/item/device/t_scanner,
				prob(2);/obj/item/device/radio,
				prob(5);/obj/item/device/analyzer)

/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"

/obj/random/powercell/item_to_spawn()
	return pick(prob(40);/obj/item/weapon/cell,
				prob(25);/obj/item/weapon/cell/device,
				prob(25);/obj/item/weapon/cell/high,
				prob(9);/obj/item/weapon/cell/super,
				prob(1);/obj/item/weapon/cell/hyper)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"

/obj/random/bomb_supply/item_to_spawn()
	return pick(/obj/item/device/assembly/igniter,
				/obj/item/device/assembly/prox_sensor,
				/obj/item/device/assembly/signaler,
				/obj/item/device/assembly/timer,
				/obj/item/device/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"

/obj/random/toolbox/item_to_spawn()
	return pick(prob(6);/obj/item/weapon/storage/toolbox/mechanical,
				prob(6);/obj/item/weapon/storage/toolbox/electrical,
				prob(2);/obj/item/weapon/storage/toolbox/emergency,
				prob(1);/obj/item/weapon/storage/toolbox/syndicate)


/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 25

/obj/random/tech_supply/item_to_spawn()
	return pick(prob(3);/obj/random/powercell,
				prob(2);/obj/random/technology_scanner,
				prob(1);/obj/item/weapon/packageWrap,
				prob(2);/obj/random/bomb_supply,
				prob(1);/obj/item/weapon/extinguisher,
				prob(1);/obj/item/clothing/gloves/fyellow,
				prob(3);/obj/item/stack/cable_coil/random,
				prob(2);/obj/random/toolbox,
				prob(2);/obj/item/weapon/storage/belt/utility,
				prob(1);/obj/item/weapon/storage/belt/utility/full,
				prob(5);/obj/random/tool,
				prob(2);/obj/item/weapon/tape_roll,
				prob(2);/obj/item/taperoll/engineering,
				prob(1);/obj/item/taperoll/atmos,
				prob(1);/obj/item/device/flashlight/maglight)

/obj/random/tech_supply/component
	name = "random tech component"
	desc = "This is a random machine component."
	icon = 'icons/obj/items.dmi'
	icon_state = "portable_analyzer"

/obj/random/tech_supply/component/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/stock_parts/gear,
		prob(2);/obj/item/weapon/stock_parts/console_screen,
		prob(1);/obj/item/weapon/stock_parts/spring,
		prob(3);/obj/item/weapon/stock_parts/capacitor,
		prob(2);/obj/item/weapon/stock_parts/capacitor/adv,
		prob(1);/obj/item/weapon/stock_parts/capacitor/super,
		prob(3);/obj/item/weapon/stock_parts/manipulator,
		prob(2);/obj/item/weapon/stock_parts/manipulator/nano,
		prob(1);/obj/item/weapon/stock_parts/manipulator/pico,
		prob(3);/obj/item/weapon/stock_parts/matter_bin,
		prob(2);/obj/item/weapon/stock_parts/matter_bin/adv,
		prob(1);/obj/item/weapon/stock_parts/matter_bin/super,
		prob(3);/obj/item/weapon/stock_parts/scanning_module,
		prob(2);/obj/item/weapon/stock_parts/scanning_module/adv,
		prob(1);/obj/item/weapon/stock_parts/scanning_module/phasic)

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon = 'icons/obj/stacks.dmi'
	icon_state = "traumakit"

/obj/random/medical/item_to_spawn()
	return pick(prob(21);/obj/random/medical/lite,
				prob(5);/obj/random/medical/pillbottle,
				prob(1);/obj/item/weapon/storage/pill_bottle/tramadol,
				prob(1);/obj/item/weapon/storage/pill_bottle/antitox,
				prob(1);/obj/item/weapon/storage/pill_bottle/carbon,
				prob(3);/obj/item/bodybag/cryobag,
				prob(5);/obj/item/weapon/reagent_containers/syringe/antitoxin,
				prob(3);/obj/item/weapon/reagent_containers/syringe/antiviral,
				prob(5);/obj/item/weapon/reagent_containers/syringe/inaprovaline,
				prob(1);/obj/item/weapon/reagent_containers/hypospray,
				prob(1);/obj/item/weapon/storage/box/freezer,
				prob(2);/obj/item/stack/nanopaste)

/obj/random/medical/pillbottle
	name = "Random Pill Bottle"
	desc = "This is a random pill bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill_canister"

/obj/random/medical/pillbottle/item_to_spawn()
	return pick(prob(1);/obj/item/weapon/storage/pill_bottle/spaceacillin,
				prob(1);/obj/item/weapon/storage/pill_bottle/dermaline,
				prob(1);/obj/item/weapon/storage/pill_bottle/dexalin_plus,
				prob(1);/obj/item/weapon/storage/pill_bottle/bicaridine,
				prob(1);/obj/item/weapon/storage/pill_bottle/iron)

/obj/random/medical/lite
	name = "Random Medicine"
	desc = "This is a random simple medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25

/obj/random/medical/lite/item_to_spawn()
	return pick(prob(4);/obj/item/stack/medical/bruise_pack,
				prob(4);/obj/item/stack/medical/ointment,
				prob(2);/obj/item/stack/medical/advanced/bruise_pack,
				prob(2);/obj/item/stack/medical/advanced/ointment,
				prob(1);/obj/item/stack/medical/splint,
				prob(4);/obj/item/device/healthanalyzer,
				prob(1);/obj/item/bodybag,
				prob(3);/obj/item/weapon/reagent_containers/hypospray/autoinjector,
				prob(2);/obj/item/weapon/storage/pill_bottle/kelotane,
				prob(2);/obj/item/weapon/storage/pill_bottle/antitox)

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"

/obj/random/firstaid/item_to_spawn()
	return pick(prob(10);/obj/item/weapon/storage/firstaid/regular,
				prob(8);/obj/item/weapon/storage/firstaid/toxin,
				prob(8);/obj/item/weapon/storage/firstaid/o2,
				prob(6);/obj/item/weapon/storage/firstaid/adv,
				prob(8);/obj/item/weapon/storage/firstaid/fire,
				prob(1);/obj/item/weapon/storage/firstaid/combat)

/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 50
/obj/random/contraband/item_to_spawn()
	return pick(prob(6);/obj/item/weapon/storage/pill_bottle/paracetamol, //VOREStation Edit,
				prob(8);/obj/item/weapon/haircomb,
				prob(4);/obj/item/weapon/storage/pill_bottle/happy,
				prob(4);/obj/item/weapon/storage/pill_bottle/zoom,
				prob(10);/obj/item/weapon/contraband/poster,
				prob(4);/obj/item/weapon/material/butterfly,
				prob(6);/obj/item/weapon/material/butterflyblade,
				prob(6);/obj/item/weapon/material/butterflyhandle,
				prob(6);/obj/item/weapon/material/wirerod,
				prob(2);/obj/item/weapon/material/butterfly/switchblade,
				prob(2);/obj/item/clothing/gloves/knuckledusters,
				prob(1);/obj/item/weapon/material/knife/tacknife,
				prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,
				prob(1);/obj/item/weapon/beartrap,
				prob(1);/obj/item/weapon/handcuffs,
				prob(1);/obj/item/weapon/handcuffs/legcuffs,
				prob(2);/obj/item/weapon/reagent_containers/syringe/drugs,
				prob(1);/obj/item/weapon/reagent_containers/syringe/steroid)

/obj/random/cash
	name = "random currency"
	desc = "LOADSAMONEY!"
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"

/obj/random/cash/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(12);/obj/item/weapon/spacecash/c1,
				prob(8);/obj/item/weapon/spacecash/c10,
				prob(4);/obj/item/weapon/spacecash/c20,
				prob(1);/obj/item/weapon/spacecash/c50,
				prob(1);/obj/item/weapon/spacecash/c100)

/obj/random/soap
	name = "Random Soap"
	desc = "This is a random bar of soap."
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"

/obj/random/soap/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/soap,
				prob(2);/obj/item/weapon/soap/nanotrasen,
				prob(2);/obj/item/weapon/soap/deluxe,
				prob(1);/obj/item/weapon/soap/syndie)


/obj/random/drinkbottle
	name = "random drink"
	desc = "This is a random drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "whiskeybottle"

/obj/random/drinkbottle/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/gin,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/wine,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/patron)

/obj/random/meat
	name = "random meat"
	desc = "This is a random slab of meat."
	icon = 'icons/obj/food.dmi'
	icon_state = "meat"

/obj/random/meat/item_to_spawn()
	return pick(prob(60);/obj/item/weapon/reagent_containers/food/snacks/meat,
				prob(20);/obj/item/weapon/reagent_containers/food/snacks/xenomeat/spidermeat,
				prob(10);/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
				prob(5);/obj/item/weapon/reagent_containers/food/snacks/bearmeat,
				prob(1);/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh,
				prob(1);/obj/item/weapon/reagent_containers/food/snacks/meat/human,
				prob(1);/obj/item/weapon/reagent_containers/food/snacks/meat/monkey,
				prob(1);/obj/item/weapon/reagent_containers/food/snacks/meat/corgi,
				prob(1);/obj/item/weapon/reagent_containers/food/snacks/xenomeat)

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
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-metal"

/obj/random/material/item_to_spawn()
	return pick(/obj/item/stack/material/steel{amount = 10},
				/obj/item/stack/material/glass{amount = 10},
				/obj/item/stack/material/glass/reinforced{amount = 10},
				/obj/item/stack/material/plastic{amount = 10},
				/obj/item/stack/material/wood{amount = 10},
				/obj/item/stack/material/cardboard{amount = 10},
				/obj/item/stack/rods{amount = 10},
				/obj/item/stack/material/plasteel{amount = 10})

/obj/random/tank
	name = "random tank"
	desc = "This is a tank."
	icon = 'icons/obj/tank.dmi'
	icon_state = "canister"

/obj/random/tank/item_to_spawn()
	return pick(prob(5);/obj/item/weapon/tank/oxygen,
				prob(4);/obj/item/weapon/tank/oxygen/yellow,
				prob(4);/obj/item/weapon/tank/oxygen/red,
				prob(3);/obj/item/weapon/tank/air,
				prob(4);/obj/item/weapon/tank/emergency/oxygen,
				prob(3);/obj/item/weapon/tank/emergency/oxygen/engi,
				prob(2);/obj/item/weapon/tank/emergency/oxygen/double,
				prob(1);/obj/item/device/suit_cooling_unit)

/obj/random/cigarettes
	name = "random cigarettes"
	desc = "This is a cigarette."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"

/obj/random/cigarettes/item_to_spawn()
	return pick(prob(5);/obj/item/weapon/storage/fancy/cigarettes,
				prob(4);/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/killthroat,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/luckystars,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/jerichos,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/menthols,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/carcinomas,
				prob(3);/obj/item/weapon/storage/fancy/cigarettes/professionals,
				prob(1);/obj/item/weapon/storage/fancy/cigar,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba,
				prob(1);/obj/item/clothing/mask/smokable/cigarette/cigar/havana)

/obj/random/coin
	name = "random coin"
	desc = "This is a coin spawn."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/random/coin/item_to_spawn()
	return pick(prob(5);/obj/item/weapon/coin/silver,
				prob(3);/obj/item/weapon/coin/iron,
				prob(4);/obj/item/weapon/coin/gold,
				prob(3);/obj/item/weapon/coin/phoron,
				prob(1);/obj/item/weapon/coin/uranium,
				prob(2);/obj/item/weapon/coin/platinum,
				prob(1);/obj/item/weapon/coin/diamond)

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
				/obj/item/toy/plushie/white_cat)

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
				/obj/item/toy/crossbow,
				/obj/item/toy/blink,
				/obj/item/toy/waterflower,
				/obj/item/toy/eight_ball,
				/obj/item/toy/eight_ball/conch,
				/obj/item/toy/prize/ripley,
				/obj/item/toy/prize/fireripley,
				/obj/item/toy/prize/deathripley,
				/obj/item/toy/prize/gygax,
				/obj/item/toy/prize/durand,
				/obj/item/toy/prize/honk,
				/obj/item/toy/prize/marauder,
				/obj/item/toy/prize/seraph,
				/obj/item/toy/prize/mauler,
				/obj/item/toy/prize/odysseus,
				/obj/item/toy/prize/phazon)

/obj/random/mouseremains
	name = "random mouseremains"
	desc = "For use with mouse spawners."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "mousetrap"

/obj/random/mouseremains/item_to_spawn()
	return pick(/obj/item/device/assembly/mousetrap,
				/obj/item/device/assembly/mousetrap/armed,
				/obj/effect/decal/cleanable/spiderling_remains,
				/obj/effect/decal/cleanable/ash,
				/obj/item/weapon/cigbutt,
				/obj/item/weapon/cigbutt/cigarbutt,
				/obj/effect/decal/remains/mouse)

/obj/random/janusmodule
	name = "random janus circuit"
	desc = "A random (possibly broken) Janus module."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "circuit_damaged"

/obj/random/janusmodule/item_to_spawn()
	return pick(subtypesof(/obj/item/weapon/circuitboard/mecha/imperion))

/obj/random/curseditem
	name = "random cursed item"
	desc = "For use in dungeons."
	icon = 'icons/obj/storage.dmi'
	icon_state = "red"

/obj/random/curseditem/item_to_spawn()
	var/possible_object_paths = list(/obj/item/weapon/paper/carbon/cursedform)
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
	return pick(/obj/item/weapon/storage/mre,
				/obj/item/weapon/storage/mre/menu2,
				/obj/item/weapon/storage/mre/menu3,
				/obj/item/weapon/storage/mre/menu4,
				/obj/item/weapon/storage/mre/menu5,
				/obj/item/weapon/storage/mre/menu6,
				/obj/item/weapon/storage/mre/menu7,
				/obj/item/weapon/storage/mre/menu8,
				/obj/item/weapon/storage/mre/menu9,
				/obj/item/weapon/storage/mre/menu10)


/obj/random/mre/main
	name = "random MRE main course"
	desc = "This is a random main course for MREs."
	icon_state = "pouch"
	drop_get_turf = FALSE

/obj/random/mre/main/item_to_spawn()
	return pick(/obj/item/weapon/storage/mrebag,
				/obj/item/weapon/storage/mrebag/menu2,
				/obj/item/weapon/storage/mrebag/menu3,
				/obj/item/weapon/storage/mrebag/menu4,
				/obj/item/weapon/storage/mrebag/menu5,
				/obj/item/weapon/storage/mrebag/menu6,
				/obj/item/weapon/storage/mrebag/menu7,
				/obj/item/weapon/storage/mrebag/menu8)

/obj/random/mre/side
	name = "random MRE side dish"
	desc = "This is a random side dish for MREs."
	icon_state = "pouch"
	drop_get_turf = FALSE

/obj/random/mre/side/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/snacks/tossedsalad,
				/obj/item/weapon/reagent_containers/food/snacks/boiledrice,
				/obj/item/weapon/reagent_containers/food/snacks/poppypretzel,
				/obj/item/weapon/reagent_containers/food/snacks/twobread,
				/obj/item/weapon/reagent_containers/food/snacks/jelliedtoast)

/obj/random/mre/dessert
	name = "random MRE dessert"
	desc = "This is a random dessert for MREs."
	icon_state = "pouch"
	drop_get_turf = FALSE

/obj/random/mre/dessert/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/snacks/candy,
				/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar,
				/obj/item/weapon/reagent_containers/food/snacks/donut/normal,
				/obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly,
				/obj/item/weapon/reagent_containers/food/snacks/chocolatebar,
				/obj/item/weapon/reagent_containers/food/snacks/cookie)

/obj/random/mre/dessert/vegan
	name = "random vegan MRE dessert"
	desc = "This is a random vegan dessert for MREs."

/obj/random/mre/dessert/vegan/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/snacks/candy,
				/obj/item/weapon/reagent_containers/food/snacks/chocolatebar,
				/obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly,
				/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit)

/obj/random/mre/drink
	name = "random MRE drink"
	desc = "This is a random drink for MREs."
	icon_state = "packet"
	drop_get_turf = FALSE

/obj/random/mre/drink/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/condiment/small/packet/coffee,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/tea,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/cocoa,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/grape,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/orange,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/watermelon,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/apple)

/obj/random/mre/spread
	name = "random MRE spread"
	desc = "This is a random spread packet for MREs."
	icon_state = "packet"
	drop_get_turf = FALSE

/obj/random/mre/spread/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/condiment/small/packet/jelly,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/honey)

/obj/random/mre/spread/vegan
	name = "random vegan MRE spread"
	desc = "This is a random vegan spread packet for MREs"

/obj/random/mre/spread/vegan/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/condiment/small/packet/jelly)

/obj/random/mre/sauce
	name = "random MRE sauce"
	desc = "This is a random sauce packet for MREs."
	icon_state = "packet"
	drop_get_turf = FALSE

/obj/random/mre/sauce/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/vegan/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/sugarfree/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/crayon/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/generic,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/red,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/orange,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/yellow,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/green,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/blue,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/purple,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/grey,
				/obj/item/weapon/reagent_containers/food/condiment/small/packet/crayon/brown)
