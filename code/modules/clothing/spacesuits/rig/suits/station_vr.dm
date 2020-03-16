//Access restriction and seal delay, plus pat_module and rescue_pharm for medical suit
/obj/item/weapon/rig/medical/equipped
	req_access = list(access_medical)
	seal_delay = 5

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/sprinter,
		/obj/item/rig_module/pat_module,
		/obj/item/rig_module/rescue_pharm
		)

//Armor reduction for industrial suit
/obj/item/weapon/rig/industrial/vendor
	desc = "A heavy, powerful hardsuit used by construction crews and mining corporations. This is a mass production model with reduced armor."
	armor = list(melee = 50, bullet = 10, laser = 20, energy = 15, bomb = 30, bio = 100, rad = 50)

//Area allowing backpacks to be placed on rigsuits.
/obj/item/weapon/rig/vox
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/combat
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/ert
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank, /obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/tool/crowbar, \
	/obj/item/weapon/tool/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/tool/wirecutters, /obj/item/weapon/tool/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/light/ninja
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/cell, /obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/merc
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs, /obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/ce
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd,/obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/medical
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical,/obj/item/roller,/obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/hazmat
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/excavation,/obj/item/weapon/pickaxe,/obj/item/device/healthanalyzer,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/device/beacon_locator,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/hand,/obj/item/weapon/storage/bag/fossils,/obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/hazard
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/industrial
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd,/obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)

/obj/item/weapon/rig/military
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs, \
	/obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/weldingtool, /obj/item/weapon/tool, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/device/suit_cooling_unit, /obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)
/obj/item/weapon/rig/pmc
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank, /obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/tool/crowbar, \
	/obj/item/weapon/tool/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/tool/wirecutters, /obj/item/weapon/tool/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/weapon/storage/backpack,/obj/item/device/subspaceradio, /obj/item/device/defib_kit)

/obj/item/weapon/rig/robotics
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/storage/box, /obj/item/weapon/storage/belt, /obj/item/device/defib_kit/compact)
