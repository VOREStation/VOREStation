/obj/item/storage/belt
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/belt/mob_teshari.dmi',
		SPECIES_WEREBEAST = 'icons/inventory/belt/mob_vr_werebeast.dmi')

/obj/item/storage/belt/explorer
	name = "explorer's belt"
	desc = "A versatile belt with several pouches. It can hold a very wide variety of items, but less items overall than a dedicated belt. Still, it's useful for any explorer who wants to be prepared for anything they might find."
	icon = 'icons/inventory/belt/item_vr.dmi'
	icon_override = 'icons/inventory/belt/mob_vr.dmi'
	icon_state = "explo_belt"
	item_state = "explorer_belt"
	storage_slots = 5	//makes it strictly inferior to any specialized belt as they have seven slots, but it's far more versatile
	max_w_class = ITEMSIZE_NORMAL	//limits the max size of thing that can be put in, so no using it to hold five laser cannons
	max_storage_space = ITEMSIZE_COST_NORMAL * 5
	can_hold = list(
		/obj/item/grenade,
		/obj/item/tool,
		/obj/item/weldingtool,
		/obj/item/pickaxe,
		/obj/item/multitool,
		/obj/item/stack/cable_coil,
		/obj/item/analyzer,
		/obj/item/flashlight,
		/obj/item/cell,
		/obj/item/gun,
		/obj/item/material,
		/obj/item/melee,
		/obj/item/shield,
		/obj/item/ammo_casing,
		/obj/item/ammo_magazine,
		/obj/item/healthanalyzer,
		/obj/item/robotanalyzer,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/stack/marker_beacon,
		/obj/item/extinguisher/mini,
		/obj/item/storage/quickdraw/syringe_case,
		/obj/item/photo,
		/obj/item/camera_film,
		/obj/item/camera,
		/obj/item/taperecorder,
		/obj/item/tape,
		/obj/item/geiger,
		/obj/item/gps,
		/obj/item/ano_scanner,
		/obj/item/cataloguer,
		/obj/item/radio,
		/obj/item/mapping_unit,
		/obj/item/kinetic_crusher
		)

/obj/item/storage/belt/explorer/pathfinder
	name = "pathfinder's belt"
	desc = "A deluxe belt with many pouches. It can hold a very wide variety of items, but less items overall than a dedicated belt. Still, it's useful for any explorer who wants to be prepared for anything they might find."
	icon = 'icons/inventory/belt/item_vr.dmi'
	icon_state = "pathfinder_belt"
	item_state = "explorer_belt"
	storage_slots = 7	//two more, bringing it on par with normal belts
	max_storage_space = ITEMSIZE_COST_NORMAL * 7

/obj/item/storage/belt/miner
	name = "mining belt"
	desc = "A versatile and durable looking belt with several pouches and straps. It can hold a very wide variety of items that any typical miner might need out in the deep."
	icon = 'icons/inventory/belt/item_vr.dmi'
	icon_state = "mining"
	item_state = "mining"
	storage_slots = 6
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = ITEMSIZE_COST_NORMAL * 6
	can_hold = list(
		/obj/item/storage/box/samplebags,
		/obj/item/core_sampler,
		/obj/item/beacon_locator,
		/obj/item/radio/beacon,
		/obj/item/measuring_tape,
		/obj/item/flashlight,
		/obj/item/cell/device,
		/obj/item/pickaxe,
		/obj/item/shovel,
		/obj/item/depth_scanner,
		/obj/item/camera,
		/obj/item/paper,
		/obj/item/photo,
		/obj/item/folder,
		/obj/item/pen,
		/obj/item/folder,
		/obj/item/clipboard,
		/obj/item/anodevice,
		/obj/item/clothing/glasses,
		/obj/item/tool/wrench,
		/obj/item/storage/excavation,
		/obj/item/anobattery,
		/obj/item/ano_scanner,
		/obj/item/pickaxe/hand,
		/obj/item/xenoarch_multi_tool,
		/obj/item/pickaxe/excavationdrill,
		/obj/item/geiger,
		/obj/item/gps,
		/obj/item/stack/marker_beacon,
		/obj/item/stack/flag,
		/obj/item/melee
		)
