/obj/machinery/mineral/equipment_vendor/survey
	name = "exploration equipment vendor"
	desc = "An equipment vendor for explorers, points collected with a survey scanner can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "exploration"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/exploration_equipment_vendor
	icon_deny = "exploration-deny"
	icon_vend = "exploration-vend"

/obj/machinery/mineral/equipment_vendor/survey/Initialize(mapload)
	. = ..()
	prize_list = list()
	prize_list["Gear"] = list(
		EQUIPMENT("Brown Webbing",									/obj/item/clothing/accessory/storage/brown_vest,							500),
		EQUIPMENT("Defense Equipment - Smoke Bomb",					/obj/item/grenade/smokebomb,												10),
		EQUIPMENT("Defense Equipment - Razor Drone Deployer",		/obj/item/grenade/spawnergrenade/manhacks/station/locked,					100),
		EQUIPMENT("Defense Equipment - Sentry Drone Deployer",		/obj/item/grenade/spawnergrenade/ward,										150),
		EQUIPMENT("Defense Equipment - Phase Pistol",				/obj/item/gun/energy/phasegun/pistol,										100),
		EQUIPMENT("Defense Equipment - Phase Carbine",				/obj/item/gun/energy/phasegun,												200),
		EQUIPMENT("Defense Equipment - Phase Rifle",				/obj/item/gun/energy/phasegun/rifle,										350),
		EQUIPMENT("Defense Equipment - Plasteel Machete",			/obj/item/material/knife/machete,											50),
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Machete",		/obj/item/kinetic_crusher/machete,											100),
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Dagger",		/obj/item/kinetic_crusher/machete/dagger,									75),
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Gauntlets",		/obj/item/kinetic_crusher/machete/gauntlets,								150),
		EQUIPMENT("Machete Holster",								/obj/item/clothing/accessory/holster/machete,								10),
		EQUIPMENT("Defense Equipment - PSG-B (Melee)",				/obj/item/personal_shield_generator/belt/melee/loaded, 						500),
		EQUIPMENT("Defense Equipment - PSG-M (General)",			/obj/item/personal_shield_generator/belt/mining/loaded,						100),
		EQUIPMENT("PSG-M Upgrade Disk",								/obj/item/borg/upgrade/shield_upgrade,										50),
		EQUIPMENT("Fishing Net",									/obj/item/material/fishing_net,												50),
		EQUIPMENT("Titanium Fishing Rod",							/obj/item/material/fishing_rod/modern,										100),
		EQUIPMENT("Durasteel Fishing Rod",							/obj/item/material/fishing_rod/modern/strong,								750),
		EQUIPMENT("Fulton Beacon",									/obj/item/fulton_core,														300),
		EQUIPMENT("Geiger Counter",									/obj/item/geiger,															75),
		EQUIPMENT("GPS Device",										/obj/item/gps/mining,														10),
		EQUIPMENT("Jump Boots",										/obj/item/clothing/shoes/bhop,												250),
		EQUIPMENT("Mini-Translocator",								/obj/item/perfect_tele/one_beacon,											120),
		EQUIPMENT("Survey Tools - Mapping Unit",					/obj/item/mapping_unit,														150),
		EQUIPMENT("Survey Tools - Mapping Beacon",					/obj/item/holomap_beacon,													25),
		EQUIPMENT("Survival Equipment - Insulated Poncho",			/obj/random/thermalponcho,													75),
		EQUIPMENT("Survival Equipment - Glowstick", 				/obj/item/flashlight/glowstick,												5),
		EQUIPMENT("Survival Equipment - Flare", 					/obj/item/flashlight/flare,													5),
		EQUIPMENT("Survival Equipment - Radioisotope Glowstick",	/obj/item/flashlight/glowstick/radioisotope,								40),
		EQUIPMENT("Survival Equipment - Modular Explorer Suit",		/obj/item/clothing/suit/armor/pcarrier/explorer,							200),
		EQUIPMENT("Survival Equipment - Armored Jumpsuit",			/obj/item/clothing/under/explorer/armored,									200),
		EQUIPMENT("Exotic Sample Container",						/obj/item/storage/sample_container,											100),
	)
	prize_list["Consumables"] = list(
		EQUIPMENT("1 Marker Beacon",								/obj/item/stack/marker_beacon,												1),
		EQUIPMENT("10 Marker Beacons",								/obj/item/stack/marker_beacon/ten,											10),
		EQUIPMENT("30 Marker Beacons",								/obj/item/stack/marker_beacon/thirty,										30),
		EQUIPMENT("Fulton Pack",									/obj/item/extraction_pack,													125),
		EQUIPMENT("Injector (L) - Glucose",							/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose,	50),
		EQUIPMENT("Injector (L) - Panacea",							/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity,		50),
		EQUIPMENT("Injector (L) - Trauma",							/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute,		50),
		EQUIPMENT("Nanopaste Tube",									/obj/item/stack/nanopaste,													100),
		EQUIPMENT("Point Transfer Card",							/obj/item/card/mining_point_card/survey,									50),
		EQUIPMENT("Shelter Capsule",								/obj/item/survivalcapsule,													50),
		EQUIPMENT("Burn Medipen",									/obj/item/reagent_containers/hypospray/autoinjector/burn,					25),
		EQUIPMENT("Detox Medipen",									/obj/item/reagent_containers/hypospray/autoinjector/detox,					25),
		EQUIPMENT("Oxy Medipen",									/obj/item/reagent_containers/hypospray/autoinjector/oxy,					25),
		EQUIPMENT("Trauma Medipen",									/obj/item/reagent_containers/hypospray/autoinjector/trauma,					25),
	)
	prize_list["Digging Tools"] = list(
		EQUIPMENT("Survey Tools - Shovel",							/obj/item/shovel,															40),
		EQUIPMENT("Survey Tools - Mechanical Trap",					/obj/item/beartrap,															50),
		EQUIPMENT("Survey Tools - Binoculars",						/obj/item/binoculars,														40),
		EQUIPMENT("Archeology Equipment - Chisels",					/obj/item/storage/excavation,												50),
		EQUIPMENT("Archeology Equipment - Scanner",					/obj/item/depth_scanner,													50),
		EQUIPMENT("Fine Excavation Kit - Measuring Tape",			/obj/item/measuring_tape,													10),

	)
	prize_list["Miscellaneous"] = list(
		EQUIPMENT(REAGENT_ABSINTHE,									/obj/item/reagent_containers/food/drinks/bottle/absinthe,					10),
		EQUIPMENT(REAGENT_WHISKEY,									/obj/item/reagent_containers/food/drinks/bottle/whiskey,					10),
		EQUIPMENT("Cigar",											/obj/item/clothing/mask/smokable/cigarette/cigar/havana,					15),
		EQUIPMENT("Digital Tablet - Standard",						/obj/item/modular_computer/tablet/preset/custom_loadout/standard,			50),
		EQUIPMENT("Digital Tablet - Advanced",						/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,			100),
		EQUIPMENT("Industrial Equipment - Phoron Bore",				/obj/item/gun/magnetic/matfed/phoronbore/loaded,							300),
		EQUIPMENT("Industrial Equipment - Inducer",					/obj/item/inducer,															750),
		EQUIPMENT("Laser Pointer",									/obj/item/laser_pointer,													90),
		EQUIPMENT("Luxury Shelter Capsule",							/obj/item/survivalcapsule/luxury,											310),
		EQUIPMENT("Bar Shelter Capsule",							/obj/item/survivalcapsule/luxurybar,										1000),
		EQUIPMENT("Plush Toy",										/obj/random/plushie,														30),
		EQUIPMENT("Soap",											/obj/item/soap/nanotrasen,													20),
		EQUIPMENT("Thalers - 100",									/obj/item/spacecash/c100,													100),
		EQUIPMENT("Thalers - 1000",									/obj/item/spacecash/c1000,													1000),
		EQUIPMENT("Umbrella",										/obj/item/melee/umbrella/random,											20),
		EQUIPMENT("UAV - Recon Skimmer",							/obj/item/uav,																40),

	)

/obj/machinery/mineral/equipment_vendor/survey/get_points(obj/item/card/id/target)
	if(!istype(target))
		return 0
	return target.survey_points

/obj/machinery/mineral/equipment_vendor/survey/remove_points(obj/item/card/id/target, amt)
	target.survey_points -= amt
