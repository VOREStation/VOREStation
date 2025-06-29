// Use this define to register something as a purchasable!
// * n — The proper name of the purchasable
// * o — The object type path of the purchasable to spawn
// * p — The price of the purchasable in mining points
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
	circuit = /obj/item/circuitboard/mining_equipment_vendor
	var/obj/item/card/id/inserted_id
	var/list/prize_list //Generated during Initialize
	var/dirty_items = FALSE // Used to refresh the static/redundant data in case the machine gets VV'd

/obj/machinery/mineral/equipment_vendor/Destroy()
	if(inserted_id)
		var/turf/T = get_turf(src)
		if(T)
			inserted_id.forceMove(T)
			inserted_id = null
		else
			qdel_null(inserted_id)
	QDEL_NULL_LIST(prize_list)
	. = ..()

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
	prize_list = list()
	prize_list["Gear"] = list(
		EQUIPMENT("Brown Webbing",								/obj/item/clothing/accessory/storage/brown_vest,			500),
		EQUIPMENT("Defense Equipment - Plasteel Machete",		/obj/item/material/knife/machete,							500),
		EQUIPMENT("Defense Equipment - Razor Drone Deployer",	/obj/item/grenade/spawnergrenade/manhacks/station/locked,	1000),
		EQUIPMENT("Defense Equipment - Sentry Drone Deployer",	/obj/item/grenade/spawnergrenade/ward,						1500),
		EQUIPMENT("Defense Equipment - Smoke Bomb",				/obj/item/grenade/smokebomb,								100),
		EQUIPMENT("Defense Equipment - Phase Pistol",			/obj/item/gun/energy/phasegun/pistol,						1500),
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Crusher",	/obj/item/kinetic_crusher,									1000),
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Dagger",	/obj/item/kinetic_crusher/machete/dagger,					500),
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Machete",	/obj/item/kinetic_crusher/machete,							1000),
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Gauntlets",	/obj/item/kinetic_crusher/machete/gauntlets,				1000), //eh this is two-handed so whatever, same price for slight dmg increase!
		EQUIPMENT("Hybrid Equipment - Proto-Kinetic Glaive",	/obj/item/kinetic_crusher/glaive,							10000), //strong spear. Pay up.
		EQUIPMENT("Machete Holster",							/obj/item/clothing/accessory/holster/machete,				350),
		EQUIPMENT("Defense Equipment - PSG-B (Melee)",			/obj/item/personal_shield_generator/belt/melee/loaded, 		5000),
		EQUIPMENT("Defense Equipment - PSG-M (General)",		/obj/item/personal_shield_generator/belt/mining/loaded,		1000),
		EQUIPMENT("PSG-M Upgrade Disk",							/obj/item/borg/upgrade/shield_upgrade,						50),
		EQUIPMENT("Durasteel Fishing Rod",						/obj/item/material/fishing_rod/modern/strong,				5000),
		EQUIPMENT("Titanium Fishing Rod",						/obj/item/material/fishing_rod/modern,						1000),
		EQUIPMENT("Fishing Net",								/obj/item/material/fishing_net,								500),
		EQUIPMENT("Fulton Beacon",								/obj/item/fulton_core,										500),
		EQUIPMENT("Geiger Counter",								/obj/item/geiger,											750),
		EQUIPMENT("GPS Device",									/obj/item/gps/mining,										100),
		EQUIPMENT("Jump Boots",									/obj/item/clothing/shoes/bhop,								2500),
		EQUIPMENT("Mini-Translocator",							/obj/item/perfect_tele/one_beacon,							1200),
		EQUIPMENT("Survival Equipment - Insulated Poncho",		/obj/random/thermalponcho,									750),
		EQUIPMENT("Mining Satchel of Holding",					/obj/item/storage/bag/ore/holding,							1500),
		EQUIPMENT("Industrial Equipment - Sheet-Snatcher",		/obj/item/storage/bag/sheetsnatcher,						500),
		EQUIPMENT("Sheet Snatcher of Holding",					/obj/item/storage/bag/sheetsnatcher/holding,				1000),
		EQUIPMENT("Advanced Ore Scanner",						/obj/item/mining_scanner/advanced,							500),
		EQUIPMENT("Exotic Sample Container",					/obj/item/storage/sample_container,							100),
	)
	prize_list["Consumables"] = list(
		EQUIPMENT("1 Marker Beacon",		/obj/item/stack/marker_beacon,													1),
		EQUIPMENT("10 Marker Beacons",		/obj/item/stack/marker_beacon/ten,												10),
		EQUIPMENT("30 Marker Beacons",		/obj/item/stack/marker_beacon/thirty,											30),
		EQUIPMENT("Fulton Pack",			/obj/item/extraction_pack,														1200),
		EQUIPMENT("Injector (L) - Glucose",	/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose,		500),
		EQUIPMENT("Injector (L) - Panacea",	/obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity,			500),
		EQUIPMENT("Injector (L) - Trauma",	/obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute,			500),
		EQUIPMENT("Nanopaste Tube",			/obj/item/stack/nanopaste,														1000),
		EQUIPMENT("Point Transfer Card",	/obj/item/card/mining_point_card,												500),
		EQUIPMENT("Shelter Capsule",		/obj/item/survivalcapsule,														500),
		EQUIPMENT("Burn Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/burn,						250),
		EQUIPMENT("Detox Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/detox,						250),
		EQUIPMENT("Oxy Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/oxy,						250),
		EQUIPMENT("Trauma Medipen",			/obj/item/reagent_containers/hypospray/autoinjector/trauma,						250),
	)
	prize_list["Kinetic Accelerator"] = list(
		EQUIPMENT("Kinetic Accelerator",		/obj/item/gun/energy/kinetic_accelerator,									900),
		EQUIPMENT("KA AoE Damage",				/obj/item/borg/upgrade/modkit/aoe/mobs,										2000),
		EQUIPMENT("KA Damage Increase",			/obj/item/borg/upgrade/modkit/damage,										1000),
		EQUIPMENT("KA Cooldown Decrease",		/obj/item/borg/upgrade/modkit/cooldown,										1200),
		EQUIPMENT("KA Range Increase",			/obj/item/borg/upgrade/modkit/range,										1000),
		EQUIPMENT("KA Temperature Modulator",	/obj/item/borg/upgrade/modkit/heater,										1000),
		EQUIPMENT("KA Off-Station Modulator",	/obj/item/borg/upgrade/modkit/offsite, 										1750),
		EQUIPMENT("KA Holster",					/obj/item/clothing/accessory/holster/waist/kinetic_accelerator,				350),
		EQUIPMENT("KA Super Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod,									250),
		EQUIPMENT("KA Hyper Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod/orange,							300),
		EQUIPMENT("KA Adjustable Tracer Rounds",/obj/item/borg/upgrade/modkit/tracer/adjustable,							175),
		EQUIPMENT("KA White Tracer Rounds",		/obj/item/borg/upgrade/modkit/tracer,										125),
		EQUIPMENT("Premium Kinetic Accelerator",/obj/item/gun/energy/kinetic_accelerator/premiumka,							12000),
	)
	prize_list["Digging Tools"] = list(
		EQUIPMENT("Resonator",									/obj/item/resonator,										900),
		EQUIPMENT("Silver Pickaxe",								/obj/item/pickaxe/silver,									1200),
		EQUIPMENT("Diamond Pickaxe",							/obj/item/pickaxe/diamond,									2000),
		EQUIPMENT("Super Resonator",							/obj/item/resonator/upgraded,								2500),
		EQUIPMENT("Archeology Equipment - Chisels",				/obj/item/storage/excavation,								500),
		EQUIPMENT("Archeology Equipment - Scanner",				/obj/item/depth_scanner,									1000), // They can get a basic scanner for archeology, but not the anomaly scanner. Keeps job stealing at a minimum while also allowing miners to excavate any cool rocks they come across.
		EQUIPMENT("Fine Excavation Kit - Measuring Tape",		/obj/item/measuring_tape,									125),
		EQUIPMENT("Explosive Excavation Kit - Plastic Charge",	/obj/item/plastique/seismic/locked,							1500),
		EQUIPMENT("Industrial Equipment - Phoron Bore",			/obj/item/gun/magnetic/matfed/phoronbore/loaded,			3000),
		EQUIPMENT("Industrial Equipment - Inducer",				/obj/item/inducer,											3500),
	)
	prize_list["Hardsuit"] = list(
		EQUIPMENT("Hardsuit - Cheap Control Module",		/obj/item/rig/industrial/vendor,								2000),
		EQUIPMENT("Hardsuit - Premium Control Module",		/obj/item/rig/industrial,										5000),
		EQUIPMENT("Hardsuit - Drill",						/obj/item/rig_module/device/drill,								2500),
		EQUIPMENT("Hardsuit - Intelligence Storage",		/obj/item/rig_module/ai_container,								2500),
		EQUIPMENT("Hardsuit - Maneuvering Jets",			/obj/item/rig_module/maneuvering_jets,							1250),
		EQUIPMENT("Hardsuit - Material Scanner",			/obj/item/rig_module/vision/material,							1000),
		EQUIPMENT("Hardsuit - Advanced Optics",				/obj/item/rig_module/vision/mining,								2000),
		EQUIPMENT("Hardsuit - Ore Scanner",					/obj/item/rig_module/device/orescanner,							1000),
		EQUIPMENT("Hardsuit - Plasma Cutter",				/obj/item/rig_module/device/plasmacutter,						800),
		EQUIPMENT("Hardsuit - Anomaly Scanner",				/obj/item/rig_module/device/anomaly_scanner,					2500),
		EQUIPMENT("Hardsuit - Anomaly Drill",				/obj/item/rig_module/device/arch_drill,							2500),
		EQUIPMENT("Hardsuit - Radiation Shield",			/obj/item/rig_module/rad_shield,								2000),
		EQUIPMENT("Hardsuit - Smoke Bomb Deployer",			/obj/item/rig_module/grenade_launcher/smoke,					2000),
		EQUIPMENT("Hardsuit - Proto-Kinetic Gauntlets",		/obj/item/rig_module/gauntlets,									2000),
	)
	prize_list["Miscellaneous"] = list(
		EQUIPMENT(REAGENT_ABSINTHE,				/obj/item/reagent_containers/food/drinks/bottle/absinthe,					125),
		EQUIPMENT("Cigar",						/obj/item/clothing/mask/smokable/cigarette/cigar/havana,					150),
		EQUIPMENT("Digital Tablet - Standard",	/obj/item/modular_computer/tablet/preset/custom_loadout/standard,			500),
		EQUIPMENT("Digital Tablet - Advanced",	/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,			1000),
		EQUIPMENT("Laser Pointer",				/obj/item/laser_pointer,													900),
		EQUIPMENT("Luxury Shelter Capsule",		/obj/item/survivalcapsule/luxury,											3100),
		EQUIPMENT("Bar Shelter Capsule",		/obj/item/survivalcapsule/luxurybar,										10000),
		EQUIPMENT("Plush Toy",					/obj/random/plushie,														300),
		EQUIPMENT("Soap",						/obj/item/soap/nanotrasen,													200),
		EQUIPMENT("Thalers - 100",				/obj/item/spacecash/c100,													1000),
		EQUIPMENT("Thalers - 1000",				/obj/item/spacecash/c1000,													10000),
		EQUIPMENT("Umbrella",					/obj/item/melee/umbrella/random,											200),
		EQUIPMENT(REAGENT_WHISKEY,				/obj/item/reagent_containers/food/drinks/bottle/whiskey,					125),
	)
	prize_list["Extra"] = list() // Used in child vendors

/obj/machinery/mineral/equipment_vendor/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()
	if(inserted_id && !powered())
		visible_message(span_notice("The ID slot indicator light flickers on \the [src] as it spits out a card before powering down."))
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

/obj/machinery/mineral/equipment_vendor/proc/get_points(obj/item/card/id/target)
	if(!istype(target))
		return 0
	return target.mining_points

/obj/machinery/mineral/equipment_vendor/proc/remove_points(obj/item/card/id/target, amt)
	target.adjust_mining_points(-amt)

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


/obj/machinery/mineral/equipment_vendor/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return

	. = TRUE
	switch(action)
		if("logoff")
			if(!inserted_id)
				return
			ui.user.put_in_hands(inserted_id)
			inserted_id = null
		if("purchase")
			if(!inserted_id)
				flick(icon_deny, src)
				return
			var/category = params["cat"] // meow
			var/name = params["name"]
			if(!(category in prize_list) || !(name in prize_list[category])) // Not trying something that's not in the list, are you?
				flick(icon_deny, src)
				return
			var/datum/data/mining_equipment/prize = prize_list[category][name]
			if(prize.cost > get_points(inserted_id)) // shouldn't be able to access this since the button is greyed out, but..
				to_chat(ui.user, span_danger("You have insufficient points."))
				flick(icon_deny, src)
				return

			remove_points(inserted_id, prize.cost)
			var/obj/I = new prize.equipment_path(loc)
			I.persist_storable = FALSE
			flick(icon_vend, src)
		else
			flick(icon_deny, src)
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
	if(istype(I,/obj/item/card/id))
		if(!powered())
			return
		else if(!inserted_id && (user.unEquip(I) || isrobot(user)))
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
	to_chat(redeemer, span_notice("You insert your voucher into the machine!"))
	var/selection = tgui_input_list(redeemer, "Pick your equipment.", "Mining Voucher Redemption", list("Kinetic Accelerator + KA Addon", "Resonator + Advanced Ore Scanner", "Survival Pistol & Machete + Survival Addon","1000 Points"))
	var/drop_location = drop_location()
	if(!Adjacent(redeemer))
		to_chat(redeemer, span_warning("You must stay near the machine to use it."))
		return
	if(!selection)
		to_chat(redeemer, span_notice("You decide not to redeem anything for now."))
		return
	switch(selection)

		if("Kinetic Accelerator + KA Addon") //1250-2100 points worth
			var/addon_selection = tgui_input_list(redeemer, "Pick your addon", "Mining Voucher Redemption", list("Cooldown", "Range","Holster")) //Just the basics. Nothing too crazy.
			if(!addon_selection)
				to_chat(redeemer, span_warning("You must select an addon."))
				return
			new /obj/item/gun/energy/kinetic_accelerator(drop_location)
			switch(addon_selection)
				if("Cooldown")
					new /obj/item/borg/upgrade/modkit/cooldown(drop_location)
				if("Range")
					new /obj/item/borg/upgrade/modkit/range(drop_location)
				if("Holster")
					new /obj/item/clothing/accessory/holster/waist/kinetic_accelerator(drop_location)


		if("Resonator + Advanced Ore Scanner") //1400 points worth
			new /obj/item/resonator(drop_location)
			new /obj/item/mining_scanner/advanced(drop_location)
			qdel(voucher)

		if("Survival Pistol & Machete + Survival Addon") // ~3000-3500 points worth.
			var/addon_selection = tgui_input_list(redeemer, "Pick your survival addon", "Mining Voucher Redemption", list("Shelter Capsule", "Glucose", "Panacea", "Trauma", "Medipens")) //Just the basics. Nothing too crazy.
			if(!addon_selection)
				to_chat(redeemer, span_warning("You must select an addon."))
				return
			new /obj/item/gun/energy/phasegun/pistol(drop_location) //1500
			new /obj/item/material/knife/machete(drop_location) //1000
			switch(addon_selection)
				if("Shelter Capsule")
					new /obj/item/survivalcapsule(drop_location) //500
				if("Glucose")
					new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose(drop_location) //500
				if("Panacea")
					new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity(drop_location) //500
				if("Trauma")
					new /obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute(drop_location) //500
				if("Medipens")
					var/obj/item/storage/box/medbox = new /obj/item/storage/box(drop_location) //1000
					new /obj/item/reagent_containers/hypospray/autoinjector/burn(medbox)
					new /obj/item/reagent_containers/hypospray/autoinjector/detox(medbox)
					new /obj/item/reagent_containers/hypospray/autoinjector/oxy(medbox)
					new /obj/item/reagent_containers/hypospray/autoinjector/trauma(medbox)
		if("1000 Points") //1000 points
			var/obj/item/card/mining_point_card/new_card = new(drop_location)
			new_card.mine_points = 1000
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
