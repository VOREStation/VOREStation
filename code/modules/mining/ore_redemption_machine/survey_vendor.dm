/obj/machinery/mineral/equipment_vendor/survey
	name = "exploration equipment vendor"
	desc = "An equipment vendor for explorers, points collected with a survey scanner can be spent here."
	icon = 'icons/obj/machines/mining_machines_vr.dmi' //VOREStation Edit
	icon_state = "exploration" //VOREStation Edit
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/exploration_equipment_vendor
	icon_deny = "exploration-deny" //VOREStation Edit
	icon_vend = "exploration-vend" //VOREStation Add

/obj/machinery/mineral/equipment_vendor/survey/Initialize(mapload)
	. = ..()
	//VOREStation Edit Start - Heavily modified list
	prize_list = list()
	prize_list["Gear"] = list(
		EQUIPMENT("Defense Equipment - Plasteel Machete",		/obj/item/weapon/material/knife/machete,							500),
		EQUIPMENT("Defense Equipment - Razor Drone Deployer",	/obj/item/weapon/grenade/spawnergrenade/manhacks/station/locked,	1000),
		EQUIPMENT("Defense Equipment - Sentry Drone Deployer",	/obj/item/weapon/grenade/spawnergrenade/ward,						1500),
		EQUIPMENT("Defense Equipment - Smoke Bomb",				/obj/item/weapon/grenade/smokebomb,									100),
		EQUIPMENT("Durasteel Fishing Rod",						/obj/item/weapon/material/fishing_rod/modern/strong,				7500),
		EQUIPMENT("Fishing Net",								/obj/item/weapon/material/fishing_net,								500),
		EQUIPMENT("Titanium Fishing Rod",						/obj/item/weapon/material/fishing_rod/modern,						1000),
		EQUIPMENT("Fulton Beacon",								/obj/item/fulton_core,												500),
		EQUIPMENT("Geiger Counter",								/obj/item/device/geiger,											750),
		EQUIPMENT("GPS Device",									/obj/item/device/gps/mining,										100),
		EQUIPMENT("Jump Boots",									/obj/item/clothing/shoes/bhop,										2500),
		EQUIPMENT("Mini-Translocator",							/obj/item/device/perfect_tele/one_beacon,							1200),
		EQUIPMENT("Survival Equipment - Insulated Poncho",		/obj/random/thermalponcho,											750),
	)
	prize_list["Consumables"] = list(
		EQUIPMENT("1 Marker Beacon",		/obj/item/stack/marker_beacon,													10),
		EQUIPMENT("10 Marker Beacons",		/obj/item/stack/marker_beacon/ten,												100),
		EQUIPMENT("30 Marker Beacons",		/obj/item/stack/marker_beacon/thirty,											300),
		EQUIPMENT("Fulton Pack",			/obj/item/extraction_pack,														1200),
		EQUIPMENT("Injector (L) - Glucose",	/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/glucose,	500),
		EQUIPMENT("Injector (L) - Panacea",	/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity,	500),
		EQUIPMENT("Injector (L) - Trauma",	/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute,	500),
		EQUIPMENT("Nanopaste Tube",			/obj/item/stack/nanopaste,														1000),
		EQUIPMENT("Point Transfer Card",	/obj/item/weapon/card/mining_point_card/survey,									500),
		EQUIPMENT("Shelter Capsule",		/obj/item/device/survivalcapsule,												500),
		EQUIPMENT("Burn Medipen",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/burn,				250),
		EQUIPMENT("Detox Medipen",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/detox,				250),
		EQUIPMENT("Oxy Medipen",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/oxy,					250),
		EQUIPMENT("Trauma Medipen",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/trauma,				250),
	)
	prize_list["Digging Tools"] = list(
		EQUIPMENT("Survey Tools - Shovel",			/obj/item/weapon/shovel,	40),
		EQUIPMENT("Survey Tools - Mechanical Trap",	/obj/item/weapon/beartrap,	50),
	)
	prize_list["Miscellaneous"] = list(
		EQUIPMENT("Absinthe",					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,	125),
		EQUIPMENT("Bar Shelter Capsule",		/obj/item/device/survivalcapsule/luxurybar,							10000),
		EQUIPMENT("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,			150),
		EQUIPMENT("Digital Tablet - Advanced",	/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,	1000),
		EQUIPMENT("Digital Tablet - Standard",	/obj/item/modular_computer/tablet/preset/custom_loadout/standard,	500),
		EQUIPMENT("Industrial Equipment - Phoron Bore",	/obj/item/weapon/gun/magnetic/matfed,						3000),
		EQUIPMENT("Laser Pointer",				/obj/item/device/laser_pointer,										900),
		EQUIPMENT("Luxury Shelter Capsule",		/obj/item/device/survivalcapsule/luxury,							3100),
		EQUIPMENT("Plush Toy",					/obj/random/plushie,												300),
		EQUIPMENT("Soap",						/obj/item/weapon/soap/nanotrasen,									200),
		EQUIPMENT("Thalers - 100",				/obj/item/weapon/spacecash/c100,									1000),
		EQUIPMENT("Umbrella",					/obj/item/weapon/melee/umbrella/random,								200),
		EQUIPMENT("UAV - Recon Skimmer",		/obj/item/device/uav,												400),
		EQUIPMENT("Whiskey",					/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,		125),
	)
	//VOREStation Edit End

/obj/machinery/mineral/equipment_vendor/survey/get_points(obj/item/weapon/card/id/target)
	if(!istype(target))
		return 0
	return target.survey_points

/obj/machinery/mineral/equipment_vendor/survey/remove_points(obj/item/weapon/card/id/target, amt)
	target.survey_points -= amt
