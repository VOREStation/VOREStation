/obj/item/weapon/storage/belt
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/belt/mob_teshari.dmi',
		SPECIES_WEREBEAST = 'icons/inventory/belt/mob_vr_werebeast.dmi')
		
/obj/item/weapon/storage/belt/explorer
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
		/obj/item/weapon/grenade,
		/obj/item/weapon/tool,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/pickaxe,
		/obj/item/device/multitool,
		/obj/item/stack/cable_coil,
		/obj/item/device/analyzer,
		/obj/item/device/flashlight,
		/obj/item/weapon/cell,
		/obj/item/weapon/gun,
		/obj/item/weapon/material,
		/obj/item/weapon/melee,
		/obj/item/weapon/shield,
		/obj/item/ammo_casing,
		/obj/item/ammo_magazine,
		/obj/item/device/healthanalyzer,
		/obj/item/device/robotanalyzer,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/bottle,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/stack/marker_beacon,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/storage/quickdraw/syringe_case,
		/obj/item/weapon/photo,
		/obj/item/device/camera_film,
		/obj/item/device/camera,
		/obj/item/device/taperecorder,
		/obj/item/device/tape,
		/obj/item/device/geiger,
		/obj/item/device/gps,
		/obj/item/device/ano_scanner,
		/obj/item/device/cataloguer,
		/obj/item/device/radio,
		/obj/item/device/mapping_unit
		)
		
/obj/item/weapon/storage/belt/explorer/pathfinder
	name = "pathfinder's belt"
	desc = "A deluxe belt with many pouches. It can hold a very wide variety of items, but less items overall than a dedicated belt. Still, it's useful for any explorer who wants to be prepared for anything they might find."
	icon = 'icons/inventory/belt/item_vr.dmi'
	icon_state = "pathfinder_belt"
	item_state = "explorer_belt"
	storage_slots = 7	//two more, bringing it on par with normal belts
	max_storage_space = ITEMSIZE_COST_NORMAL * 7
