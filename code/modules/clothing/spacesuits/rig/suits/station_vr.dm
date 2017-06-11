/obj/item/weapon/rig/hazmat/equipped
	req_access = list(access_xenoarch)
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/device/drill //The suit has nothing to mine with otherwise.
		)

/obj/item/weapon/rig/medical/equipped

	req_access = list(access_medical)
	seal_delay = 5

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/sprinter,
		/obj/item/rig_module/pat_module,
		/obj/item/rig_module/rescue_pharm
		)

//Area allowing backpacks to be placed on rigsuits.
/obj/item/weapon/rig/vox
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/backpack)
/obj/item/weapon/rig/combat
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/storage/backpack)
/obj/item/weapon/rig/ert
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank, /obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/weapon/storage/backpack)
/obj/item/weapon/rig/light/ninja
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/cell, /obj/item/weapon/storage/backpack)
/obj/item/weapon/rig/merc
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs, /obj/item/weapon/storage/backpack)
/obj/item/weapon/rig/ce
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd,/obj/item/weapon/storage/backpack)
/obj/item/weapon/rig/medical
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical,/obj/item/roller,/obj/item/weapon/storage/backpack)
/obj/item/weapon/rig/hazmat
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/excavation,/obj/item/weapon/pickaxe,/obj/item/device/healthanalyzer,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/hand,/obj/item/weapon/storage/bag/fossils,/obj/item/weapon/storage/backpack)
/obj/item/weapon/rig/hazard
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/storage/backpack)
/obj/item/weapon/rig/industrial
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd,/obj/item/weapon/storage/backpack)
