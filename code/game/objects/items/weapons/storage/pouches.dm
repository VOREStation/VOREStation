#define INVENTORY_POUCH_SPACE ITEMSIZE_COST_SMALL*4 // 25% the size of a backpack for normal size

// Pouches for small storage in pocket slots
/obj/item/weapon/storage/pouch
	name = "storage pouch (medium)"
	desc = "This storage pouch can be used to provide some additional storage for quick access."
	icon = 'icons/inventory/pockets/item.dmi'
	slot_flags = SLOT_POCKET
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

	icon_state = "medium_generic"
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = INVENTORY_POUCH_SPACE
	can_hold = null
	pocketable = TRUE

	var/insert_delay = 0 SECONDS
	var/remove_delay = 2 SECONDS

/obj/item/weapon/storage/pouch/stall_insertion(obj/item/W, mob/user)
	// No delay if you have the pouch in your hands
	if(user.get_active_hand() == src || user.get_inactive_hand() == src)
		return TRUE // Skip delay

	if(insert_delay && !do_after(user, insert_delay, src, needhand = TRUE, exclusive = TASK_USER_EXCLUSIVE))
		return FALSE // Moved while there is a delay

	return TRUE //Now we're allowed to put the item in the pouch

/obj/item/weapon/storage/pouch/stall_removal(obj/item/W, mob/user)
	// No delay if you have the pouch in your hands
	if(user.get_active_hand() == src || user.get_inactive_hand() == src)
		return TRUE // Skip delay

	if(remove_delay && !do_after(user, remove_delay, src, needhand = TRUE, exclusive = TASK_USER_EXCLUSIVE))
		return FALSE // Moved while there is a delay

	if(W in src)
		return TRUE // Item is still inside

	return FALSE //Item was somehow already removed

/obj/item/weapon/storage/pouch/pocket_description(mob/haver, mob/examiner)
	return "[src]"

/obj/item/weapon/storage/pouch/large
	name = "storage pouch (large)"
	desc = "This storage pouch can be used to provide a good amount of additional storage for quick access."
	icon_state = "large_generic"
	max_storage_space = ITEMSIZE_COST_SMALL*6

/obj/item/weapon/storage/pouch/small
	name = "storage pouch (small)"
	desc = "This storage pouch can be used to provide a small amount of additional storage for quick access."
	icon_state = "small_generic"
	max_storage_space = ITEMSIZE_COST_SMALL*2

/obj/item/weapon/storage/pouch/ammo
	name = "storage pouch (ammo)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold ammunition, cells, explosives, and grenades."
	icon_state = "ammo"
	max_storage_space = INVENTORY_POUCH_SPACE
	can_hold = list(/obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/weapon/cell/device/weapon, /obj/item/weapon/grenade, /obj/item/weapon/plastique) //Vorestation Add - make it more useful for non-sec/explo

/obj/item/weapon/storage/pouch/eng_tool
	name = "storage pouch (tools)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold tools."
	icon_state = "engineering_tool"
	max_storage_space = INVENTORY_POUCH_SPACE
	can_hold = list(
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/weapon/tool/wrench,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/weapon/cell/device,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/device/pda,
		/obj/item/device/megaphone,
		/obj/item/taperoll,
		/obj/item/device/radio/headset,
		/obj/item/device/robotanalyzer,
		/obj/item/weapon/material/minihoe,
		/obj/item/weapon/material/knife/machete/hatchet,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/tape_roll,
		/obj/item/device/integrated_electronics/wirer,
		/obj/item/device/integrated_electronics/debugger, 
		/obj/item/weapon/shovel/spade, 
		/obj/item/stack/nanopaste, 
		/obj/item/device/geiger
	) //Vorestation Add - make it the same as the tool-belt why was it not like this to start with wtf

/obj/item/weapon/storage/pouch/eng_supply
	name = "storage pouch (supplies)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold engineering supplies."
	icon_state = "engineering_supply"
	max_storage_space = INVENTORY_POUCH_SPACE
	can_hold = list(
		/obj/item/weapon/cell/device,
		/obj/item/stack/cable_coil,
		/obj/item/taperoll,
		/obj/item/weapon/extinguisher,
		/obj/item/weapon/tape_roll,
		/obj/item/stack/material/steel,
		/obj/item/stack/material/glass,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/cell
	) //Vorestation Add - makes it actually useful lmao, adds sheets and cells as well as light replacers and lets you take any extinguisher that fits

/obj/item/weapon/storage/pouch/eng_parts
	name = "storage pouch (parts)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold machinery components."
	icon_state = "part_pouch"
	max_storage_space = INVENTORY_POUCH_SPACE*2 //Vorestation Add - yeah lemme give up my pocket to hold FOUR CAPACITORS or have an inferior box... now you can hold eight in your pocket so its at least a box
	can_hold = list(
		/obj/item/weapon/stock_parts,
		/obj/item/stack/cable_coil,
		/obj/item/weapon/circuitboard
	)

/obj/item/weapon/storage/pouch/medical
	name = "storage pouch (medical)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold medical supplies."
	icon_state = "medical_supply"
	max_storage_space = INVENTORY_POUCH_SPACE
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/weapon/dnainjector,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/bottle,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/storage/quickdraw/syringe_case,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/weapon/storage/quickdraw/syringe_case,
		/obj/item/weapon/syringe_cartridge,
		/obj/item/clothing/gloves/sterile,
		/obj/item/device/sleevemate,
		/obj/item/bodybag/,
		/obj/item/clothing/mask/surgical,
		/obj/item/weapon/soap,
		/obj/item/stack/nanopaste,
		/obj/item/taperoll/medical,
		/obj/item/weapon/storage/box/freezer,
		/obj/item/device/defib_kit/compact     
	) //Vorestation add - added a bunch of misc medical stuff
	remove_delay = 5 //Vorestation Add - .5 second delay, get the medical things faster because there is no reason to use this otherwise

/obj/item/weapon/storage/pouch/flares
	name = "storage pouch (flares)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold flares and glowsticks."
	icon_state = "flare"
	storage_slots = 5
	can_hold = list(/obj/item/device/flashlight/flare, /obj/item/device/flashlight/glowstick)
/obj/item/weapon/storage/pouch/flares/full_flare
	starts_with = list(/obj/item/device/flashlight/flare = 5)
/obj/item/weapon/storage/pouch/flares/full_glow
	starts_with = list(/obj/item/device/flashlight/glowstick = 5)

/obj/item/weapon/storage/pouch/flares/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("flare_[contents.len]")
	..()

/obj/item/weapon/storage/pouch/holster
	name = "storage pouch (holster)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can hold one normal sized weapon."
	icon_state = "pistol_holster"
	storage_slots = 1
	can_hold = list(/obj/item/weapon/gun) //this covers basically everything I think so its fine
	remove_delay = 0
/obj/item/weapon/storage/pouch/holster/full_stunrevolver
	starts_with = list(/obj/item/weapon/gun/energy/stunrevolver)
/obj/item/weapon/storage/pouch/holster/full_taser
	starts_with = list(/obj/item/weapon/gun/energy/taser)

/obj/item/weapon/storage/pouch/holster/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("pistol_layer")
	..()

/obj/item/weapon/storage/pouch/baton
	name = "storage pouch (melee)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can hold one normal size melee." //Vorestation add - make it a melee pouch literally why would you hold ONE BATON
	icon_state = "baton_holster"
	storage_slots = 1
	can_hold = list(/obj/item/weapon/melee, /obj/item/weapon/material, /obj/item/weapon/tool/wrench) //should be like, every melee weapon I could think of that was normal size. Can make it more specific if needed. Also wrench because I thought it was funny.
	remove_delay = 0
/obj/item/weapon/storage/pouch/baton/full
	starts_with = list(/obj/item/weapon/melee/baton)

/obj/item/weapon/storage/pouch/baton/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("baton_layer")
	..()

/obj/item/weapon/storage/pouch/holding
	name = "storage pouch of holding"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Seems to use extradimensional storage!"
	icon_state = "holdingpouch"
	max_storage_space = INVENTORY_STANDARD_SPACE // Size of a normal backpack, compared to a normal BoH, which is way bigger

#undef INVENTORY_POUCH_SPACE