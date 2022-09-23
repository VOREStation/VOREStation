// Use this define to register something as a purchasable!
// * n — The proper name of the purchasable
// * o — The object type path of the purchasable to spawn
// * p — The price of the purchasable in mining points
#define EQUIPMENT(n, o, p) n = new /datum/data/mining_equipment(n, o, p)

/**********************Mining Equipment Locker**************************/

/obj/machinery/mineral/equipment_vendor
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/vending.dmi'
	icon_state = "minevend"
	density = TRUE
	anchored = TRUE
	var/icon_deny = "minevend-deny"
	var/icon_vend = "minevend-vend"
	circuit = /obj/item/weapon/circuitboard/mining_equipment_vendor
	var/obj/item/weapon/card/id/inserted_id
	var/list/prize_list = list(
		new /datum/data/mining_equipment("1 Marker Beacon",				/obj/item/stack/marker_beacon,										10),
		new /datum/data/mining_equipment("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,									100),
		new /datum/data/mining_equipment("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,								300),
		new /datum/data/mining_equipment("Whiskey",						/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,		125),
		new /datum/data/mining_equipment("Absinthe",					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,	125),
		new /datum/data/mining_equipment("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,			150),
		new /datum/data/mining_equipment("Soap",						/obj/item/weapon/soap/nanotrasen,									200),
		new /datum/data/mining_equipment("Laser Pointer",				/obj/item/device/laser_pointer,										900),
		new /datum/data/mining_equipment("Geiger Counter",				/obj/item/device/geiger,											750),
		new /datum/data/mining_equipment("Plush Toy",					/obj/random/plushie,												300),
		new /datum/data/mining_equipment("Umbrella",					/obj/item/weapon/melee/umbrella/random,								200),
//		new /datum/data/mining_equipment("Fulton Beacon",				/obj/item/fulton_core,												500),
		new /datum/data/mining_equipment("Point Transfer Card",			/obj/item/weapon/card/mining_point_card,							500),
//		new /datum/data/mining_equipment("Fulton Pack",					/obj/item/extraction_pack,											1200),
//		new /datum/data/mining_equipment("Silver Pickaxe",				/obj/item/weapon/pickaxe/silver,									1200),
//		new /datum/data/mining_equipment("Diamond Pickaxe",				/obj/item/weapon/pickaxe/diamond,									2000),
		new /datum/data/mining_equipment("Fishing Net",					/obj/item/weapon/material/fishing_net,								500),
		new /datum/data/mining_equipment("Titanium Fishing Rod",		/obj/item/weapon/material/fishing_rod/modern,						1000),
//		new /datum/data/mining_equipment("Space Cash",					/obj/item/weapon/spacecash/c1000,									2000),
		new /datum/data/mining_equipment("Industrial Hardsuit - Control Module",	/obj/item/weapon/rig/industrial,						10000),
		new /datum/data/mining_equipment("Industrial Hardsuit - Plasma Cutter",		/obj/item/rig_module/device/plasmacutter,				800),
		new /datum/data/mining_equipment("Industrial Hardsuit - Drill",				/obj/item/rig_module/device/drill,						5000),
		new /datum/data/mining_equipment("Industrial Hardsuit - Ore Scanner",		/obj/item/rig_module/device/orescanner,					1000),
		new /datum/data/mining_equipment("Industrial Hardsuit - Advanced Optics",	/obj/item/rig_module/vision/mining,						1250),
		new /datum/data/mining_equipment("Industrial Hardsuit - Maneuvering Jets",	/obj/item/rig_module/maneuvering_jets,					1250),
		new /datum/data/mining_equipment("Hardsuit - Intelligence Storage",	/obj/item/rig_module/ai_container,								2500),
		new /datum/data/mining_equipment("Hardsuit - Smoke Bomb Deployer",	/obj/item/rig_module/grenade_launcher/smoke,					2000),
		new /datum/data/mining_equipment("Industrial Equipment - Phoron Bore",	/obj/item/weapon/gun/magnetic/matfed/phoronbore/loaded,		3000),
		new /datum/data/mining_equipment("Industrial Equipment - Sheet-Snatcher",/obj/item/weapon/storage/bag/sheetsnatcher,				500),
		new /datum/data/mining_equipment("Digital Tablet - Standard",	/obj/item/modular_computer/tablet/preset/custom_loadout/standard,	500),
		new /datum/data/mining_equipment("Digital Tablet - Advanced",	/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,	1000),
		new /datum/data/mining_equipment("Fine Excavation Kit - Chisels",/obj/item/weapon/storage/excavation,								500),
		new /datum/data/mining_equipment("Fine Excavation Kit - Measuring Tape",/obj/item/device/measuring_tape,							125),
		new /datum/data/mining_equipment("Fine Excavation Kit - Hand Pick",/obj/item/weapon/pickaxe/hand,									375),
		new /datum/data/mining_equipment("Explosive Excavation Kit - Plastic Charge",/obj/item/weapon/plastique/seismic,					1500),
		new /datum/data/mining_equipment("Injector (L) - Glucose",/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/glucose,	500),
		new /datum/data/mining_equipment("Injector (L) - Panacea",/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity,	500),
		new /datum/data/mining_equipment("Injector (L) - Trauma",/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute,	500),
		new /datum/data/mining_equipment("Nanopaste Tube",				/obj/item/stack/nanopaste,											1000),
		new /datum/data/mining_equipment("Defense Equipment - Phase Pistol",/obj/item/weapon/gun/energy/phasegun/pistol,					400),
		new /datum/data/mining_equipment("Defense Equipment - Smoke Bomb",/obj/item/weapon/grenade/smokebomb,								100),
		new /datum/data/mining_equipment("Defense Equipment - Razor Drone Deployer",/obj/item/weapon/grenade/spawnergrenade/manhacks/station,	1000),
		new /datum/data/mining_equipment("Defense Equipment - Sentry Drone Deployer",/obj/item/weapon/grenade/spawnergrenade/ward,			1500),
		new /datum/data/mining_equipment("Defense Equipment - Steel Machete",	/obj/item/weapon/material/knife/machete,					500)
		)
	var/dirty_items = FALSE // Used to refresh the static/redundant data in case the machine gets VV'd

/datum/data/mining_equipment
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0

/datum/data/mining_equipment/New(name, path, cost)
	src.equipment_name = name
	src.equipment_path = path
	src.cost = cost

/obj/machinery/mineral/equipment_vendor/Initialize(mapload)
	. = ..()
	//VOREStation Edit Start - Heavily modified list
	prize_list = list()
	prize_list["Gear"] = list(
		// TODO EQUIPMENT("Advanced Scanner",	/obj/item/device/t_scanner/adv_mining_scanner,										800),
		// TODO EQUIPMENT("Explorer's Webbing",	/obj/item/storage/belt/mining,														500),
		EQUIPMENT("Defense Equipment - Plasteel Machete",		/obj/item/weapon/material/knife/machete,							500),
		EQUIPMENT("Defense Equipment - Razor Drone Deployer",	/obj/item/weapon/grenade/spawnergrenade/manhacks/station/locked,	1000),
		EQUIPMENT("Defense Equipment - Sentry Drone Deployer",	/obj/item/weapon/grenade/spawnergrenade/ward,						1500),
		EQUIPMENT("Defense Equipment - Smoke Bomb",				/obj/item/weapon/grenade/smokebomb,									100),
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Dagger",	/obj/item/weapon/kinetic_crusher/machete/dagger,					500),
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Machete",	/obj/item/weapon/kinetic_crusher/machete,							1000),
		EQUIPMENT("Durasteel Fishing Rod",						/obj/item/weapon/material/fishing_rod/modern/strong,				7500),
		EQUIPMENT("Titanium Fishing Rod",						/obj/item/weapon/material/fishing_rod/modern,						1000),
		EQUIPMENT("Fishing Net",								/obj/item/weapon/material/fishing_net,								500),
		EQUIPMENT("Fulton Beacon",								/obj/item/fulton_core,												500),
		EQUIPMENT("Geiger Counter",								/obj/item/device/geiger,											750),
		EQUIPMENT("GPS Device",									/obj/item/device/gps/mining,										100),
		// EQUIPMENT("Mining Conscription Kit",					/obj/item/storage/backpack/duffelbag/mining_conscript,				1000),
		EQUIPMENT("Jump Boots",									/obj/item/clothing/shoes/bhop,										2500),
		EQUIPMENT("Mini-Translocator",							/obj/item/device/perfect_tele/one_beacon,							1200),
		EQUIPMENT("Survival Equipment - Insulated Poncho",		/obj/random/thermalponcho,											750),
		EQUIPMENT("Mining Satchel of Holding",					/obj/item/weapon/storage/bag/ore/holding,							1500),
	)
	prize_list["Consumables"] = list(
		EQUIPMENT("1 Marker Beacon",		/obj/item/stack/marker_beacon,													1),
		EQUIPMENT("10 Marker Beacons",		/obj/item/stack/marker_beacon/ten,												10),
		EQUIPMENT("30 Marker Beacons",		/obj/item/stack/marker_beacon/thirty,											30),
		EQUIPMENT("Fulton Pack",			/obj/item/extraction_pack,														1200),
		EQUIPMENT("Injector (L) - Glucose",	/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/glucose,	500),
		EQUIPMENT("Injector (L) - Panacea",	/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity,	500),
		EQUIPMENT("Injector (L) - Trauma",	/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute,	500),
		EQUIPMENT("Nanopaste Tube",			/obj/item/stack/nanopaste,														1000),
		EQUIPMENT("Point Transfer Card",	/obj/item/weapon/card/mining_point_card,										500),
		EQUIPMENT("Shelter Capsule",		/obj/item/device/survivalcapsule,												500),
		EQUIPMENT("Burn Medipen",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/burn,				250),
		EQUIPMENT("Detox Medipen",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/detox,				250),
		EQUIPMENT("Oxy Medipen",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/oxy,					250),
		EQUIPMENT("Trauma Medipen",			/obj/item/weapon/reagent_containers/hypospray/autoinjector/trauma,				250),
	)
	prize_list["Kinetic Accelerator"] = list(
		EQUIPMENT("Kinetic Accelerator",		/obj/item/weapon/gun/energy/kinetic_accelerator,				900),
		EQUIPMENT("KA AoE Damage",				/obj/item/borg/upgrade/modkit/aoe/mobs,							2000),
		EQUIPMENT("KA Damage Increase",			/obj/item/borg/upgrade/modkit/damage,							1000),
		EQUIPMENT("KA Cooldown Decrease",		/obj/item/borg/upgrade/modkit/cooldown,							1200),
		EQUIPMENT("KA Range Increase",			/obj/item/borg/upgrade/modkit/range,							1000),
		EQUIPMENT("KA Temperature Modulator",	/obj/item/borg/upgrade/modkit/heater,							1000),
		EQUIPMENT("KA Off-Station Modulator",	/obj/item/borg/upgrade/modkit/offsite, 							1750),
		EQUIPMENT("KA Holster",					/obj/item/clothing/accessory/holster/waist/kinetic_accelerator,	350),
		EQUIPMENT("KA Super Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod,						250),
		EQUIPMENT("KA Hyper Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod/orange,				300),
		EQUIPMENT("KA Adjustable Tracer Rounds",/obj/item/borg/upgrade/modkit/tracer/adjustable,				175),
		EQUIPMENT("KA White Tracer Rounds",		/obj/item/borg/upgrade/modkit/tracer,							125),
		EQUIPMENT("Premium Kinetic Accelerator",/obj/item/weapon/gun/energy/kinetic_accelerator/premiumka,		12000),
	)
	prize_list["Digging Tools"] = list(
		// EQUIPMENT("Diamond Pickaxe",	/obj/item/weapon/pickaxe/diamond,				2000),
		// EQUIPMENT("Kinetic Crusher",	/obj/item/twohanded/required/kinetic_crusher,	750),
		EQUIPMENT("Resonator",			/obj/item/resonator,							900),
		EQUIPMENT("Silver Pickaxe",		/obj/item/weapon/pickaxe/silver,				1200),
		EQUIPMENT("Super Resonator",	/obj/item/resonator/upgraded,					2500),
		EQUIPMENT("Fine Excavation Kit - Chisels",			/obj/item/weapon/storage/excavation,			500),
		EQUIPMENT("Fine Excavation Kit - Measuring Tape",	/obj/item/device/measuring_tape,				125),
		EQUIPMENT("Fine Excavation Kit - Hand Pick",		/obj/item/weapon/pickaxe/hand,					375),
		EQUIPMENT("Explosive Excavation Kit - Plastic Charge",/obj/item/weapon/plastique/seismic/locked,	1500),
		EQUIPMENT("Industrial Equipment - Phoron Bore",		/obj/item/weapon/gun/magnetic/matfed/phoronbore/loaded,			3000),
		EQUIPMENT("Industrial Equipment - Inducer",			/obj/item/weapon/inducer,						3500),
		EQUIPMENT("Industrial Equipment - Sheet-Snatcher",	/obj/item/weapon/storage/bag/sheetsnatcher,		500),
	)
	prize_list["Hardsuit"] = list(
		EQUIPMENT("Hardsuit - Control Module",				/obj/item/weapon/rig/industrial/vendor,			2000),
		EQUIPMENT("Hardsuit - Drill",						/obj/item/rig_module/device/drill,				5000),
		EQUIPMENT("Hardsuit - Intelligence Storage",		/obj/item/rig_module/ai_container,				2500),
		EQUIPMENT("Hardsuit - Maneuvering Jets",			/obj/item/rig_module/maneuvering_jets,			1250),
		EQUIPMENT("Hardsuit - Material Scanner",			/obj/item/rig_module/vision/material,			500),
		EQUIPMENT("Hardsuit - Ore Scanner",					/obj/item/rig_module/device/orescanner,			1000),
		EQUIPMENT("Hardsuit - Plasma Cutter",				/obj/item/rig_module/device/plasmacutter,		800),
		EQUIPMENT("Hardsuit - Smoke Bomb Deployer",			/obj/item/rig_module/grenade_launcher/smoke,	2000),
		EQUIPMENT("Hardsuit - Proto-Kinetic Gauntlets",		/obj/item/rig_module/gauntlets,					2000),
	)
	prize_list["Miscellaneous"] = list(
		EQUIPMENT("Absinthe",					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe,	125),
		EQUIPMENT("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,			150),
		EQUIPMENT("Digital Tablet - Standard",	/obj/item/modular_computer/tablet/preset/custom_loadout/standard,	500),
		EQUIPMENT("Digital Tablet - Advanced",	/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,	1000),
		EQUIPMENT("Laser Pointer",				/obj/item/device/laser_pointer,										900),
		EQUIPMENT("Luxury Shelter Capsule",		/obj/item/device/survivalcapsule/luxury,							3100),
		EQUIPMENT("Bar Shelter Capsule",		/obj/item/device/survivalcapsule/luxurybar,							10000),
		EQUIPMENT("Plush Toy",					/obj/random/plushie,												300),
		EQUIPMENT("Soap",						/obj/item/weapon/soap/nanotrasen,									200),
		EQUIPMENT("Thalers - 100",				/obj/item/weapon/spacecash/c100,									1000),
		EQUIPMENT("Thalers - 1000",				/obj/item/weapon/spacecash/c1000,									10000),
		EQUIPMENT("Umbrella",					/obj/item/weapon/melee/umbrella/random,								200),
		EQUIPMENT("Whiskey",					/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,		125),
		EQUIPMENT("Mining PSG Upgrade Disk",	/obj/item/borg/upgrade/shield_upgrade,								2500),
	)
	prize_list["Extra"] = list() // Used in child vendors
	//VOREStation Edit End

/obj/machinery/mineral/equipment_vendor/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()
	if(inserted_id && !powered())
		visible_message("<span class='notice'>The ID slot indicator light flickers on \the [src] as it spits out a card before powering down.</span>")
		inserted_id.forceMove(get_turf(src))

/obj/machinery/mineral/equipment_vendor/update_icon()
	if(panel_open)
		add_overlay("[initial(icon_state)]-panel")
	else
		cut_overlay("[initial(icon_state)]-panel")

	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

/obj/machinery/mineral/equipment_vendor/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/machinery/mineral/equipment_vendor/attack_ghost(mob/user)
	tgui_interact(user)

/obj/machinery/mineral/equipment_vendor/tgui_data(mob/user)
	var/list/data = ..()

	// ID
	if(inserted_id)
		data["has_id"] = TRUE
		data["id"] = list()
		data["id"]["name"] = inserted_id.registered_name
		data["id"]["points"] = get_points(inserted_id)
	else
		data["has_id"] = FALSE

	return data

/obj/machinery/mineral/equipment_vendor/proc/get_points(obj/item/weapon/card/id/target)
	if(!istype(target))
		return 0
	return target.mining_points

/obj/machinery/mineral/equipment_vendor/proc/remove_points(obj/item/weapon/card/id/target, amt)
	target.mining_points -= amt

/obj/machinery/mineral/equipment_vendor/tgui_static_data(mob/user)
	var/list/static_data[0]

	// Available items - in static data because we don't wanna compute this list every time! It hardly changes.
	static_data["items"] = list()
	for(var/cat in prize_list)
		var/list/cat_items = list()
		for(var/prize_name in prize_list[cat])
			var/datum/data/mining_equipment/prize = prize_list[cat][prize_name]
			cat_items[prize_name] = list("name" = prize_name, "price" = prize.cost)
		static_data["items"][cat] = cat_items

	return static_data

/obj/machinery/mineral/equipment_vendor/vv_edit_var(var_name, var_value)
	// Gotta update the static data in case an admin VV's the items for some reason..!
	if(var_name == "prize_list")
		dirty_items = TRUE
	return ..()

/obj/machinery/mineral/equipment_vendor/tgui_interact(mob/user, datum/tgui/ui = null)
	// Update static data if need be
	if(dirty_items)
		update_tgui_static_data(user, ui)
		dirty_items = FALSE

	// Open the window
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningVendor", name)
		ui.open()
		ui.set_autoupdate(FALSE)


/obj/machinery/mineral/equipment_vendor/tgui_act(action, params)
	if(..())
		return

	. = TRUE
	switch(action)
		if("logoff")
			if(!inserted_id)
				return
			usr.put_in_hands(inserted_id)
			inserted_id = null
		if("purchase")
			if(!inserted_id)
				flick(icon_deny, src) //VOREStation Add
				return
			var/category = params["cat"] // meow
			var/name = params["name"]
			if(!(category in prize_list) || !(name in prize_list[category])) // Not trying something that's not in the list, are you?
				flick(icon_deny, src) //VOREStation Add
				return
			var/datum/data/mining_equipment/prize = prize_list[category][name]
			if(prize.cost > get_points(inserted_id)) // shouldn't be able to access this since the button is greyed out, but..
				to_chat(usr, "<span class='danger'>You have insufficient points.</span>")
				flick(icon_deny, src) //VOREStation Add
				return

			remove_points(inserted_id, prize.cost)
			//VOREStation Edit Start
			var/obj/I = new prize.equipment_path(loc)
			I.persist_storable = FALSE
			//VOREStation Edit End
			flick(icon_vend, src) //VOREStation Add
		else
			flick(icon_deny, src) //VOREStation Add
			return FALSE
	add_fingerprint()


/obj/machinery/mineral/equipment_vendor/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(istype(I, /obj/item/mining_voucher))
		if(!powered())
			return
		redeem_voucher(I, user)
		return
	if(istype(I,/obj/item/weapon/card/id))
		if(!powered())
			return
		else if(!inserted_id && user.unEquip(I))
			I.forceMove(src)
			inserted_id = I
			tgui_interact(user)
		return
	return ..()

/obj/machinery/mineral/equipment_vendor/dismantle()
	if(inserted_id)
		inserted_id.forceMove(loc) //Prevents deconstructing the ORM from deleting whatever ID was inside it.
	. = ..()

/**
  * Called when someone slaps the machine with a mining voucher
  *
  * Arguments:
  * * voucher - The voucher card item
  * * redeemer - The person holding it
  */
/obj/machinery/mineral/equipment_vendor/proc/redeem_voucher(obj/item/mining_voucher/voucher, mob/redeemer)
	var/selection = tgui_input_list(redeemer, "Pick your equipment", "Mining Voucher Redemption", list("Kinetic Accelerator", "Resonator", "Mining Drone", "Advanced Scanner", "Crusher"))
	if(!selection || !Adjacent(redeemer) || voucher.loc != redeemer)
		return
	//VOREStation Edit Start - Uncommented these
	var/drop_location = drop_location()
	switch(selection)
		if("Kinetic Accelerator")
			new /obj/item/weapon/gun/energy/kinetic_accelerator(drop_location)
		if("Resonator")
			new /obj/item/resonator(drop_location)
	//VOREStation Edit End
		// if("Mining Drone")
		// 	new /obj/item/storage/box/drone_kit(drop_location)
		// if("Advanced Scanner")
		// 	new /obj/item/device/t_scanner/adv_mining_scanner(drop_location)
		// if("Crusher")
		// 	new /obj/item/twohanded/required/mining_hammer(drop_location)
	qdel(voucher)

/obj/machinery/mineral/equipment_vendor/proc/new_prize(var/name, var/path, var/cost) // Generic proc for adding new entries. Good for abusing for FUN and PROFIT.
	if(!cost)
		cost = 100
	if(!path)
		path = /obj/item/stack/marker_beacon
	if(!name)
		name = "Generic Entry"
	prize_list += new /datum/data/mining_equipment(name, path, cost)

/obj/machinery/mineral/equipment_vendor/ex_act(severity, target)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(prob(50 / severity) && severity < 3)
		qdel(src)
