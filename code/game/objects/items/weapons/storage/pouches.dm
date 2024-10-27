#define INVENTORY_POUCH_SPACE ITEMSIZE_COST_SMALL*4 // 25% the size of a backpack for normal size

// Pouches for small storage in pocket slots
/obj/item/storage/pouch
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

/obj/item/storage/pouch/stall_insertion(obj/item/W, mob/user)
	// No delay if you have the pouch in your hands
	if(user.get_active_hand() == src || user.get_inactive_hand() == src)
		return TRUE // Skip delay

	if(insert_delay && !do_after(user, insert_delay, src, needhand = TRUE, exclusive = TASK_USER_EXCLUSIVE))
		return FALSE // Moved while there is a delay

	return TRUE //Now we're allowed to put the item in the pouch

/obj/item/storage/pouch/stall_removal(obj/item/W, mob/user)
	// No delay if you have the pouch in your hands
	if(user.get_active_hand() == src || user.get_inactive_hand() == src)
		return TRUE // Skip delay

	if(remove_delay && !do_after(user, remove_delay, src, needhand = TRUE, exclusive = TASK_USER_EXCLUSIVE))
		return FALSE // Moved while there is a delay

	if(W in src)
		return TRUE // Item is still inside

	return FALSE //Item was somehow already removed

/obj/item/storage/pouch/pocket_description(mob/haver, mob/examiner)
	return "[src]"

/obj/item/storage/pouch/large
	name = "storage pouch (large)"
	desc = "This storage pouch can be used to provide a good amount of additional storage for quick access."
	icon_state = "large_generic"
	max_storage_space = ITEMSIZE_COST_SMALL*6
	remove_delay = 3 SECONDS //VOREStation Add: Slightly more cumbersome

/obj/item/storage/pouch/small
	name = "storage pouch (small)"
	desc = "This storage pouch can be used to provide a small amount of additional storage for quick access."
	icon_state = "small_generic"
	max_storage_space = ITEMSIZE_COST_SMALL*2
	remove_delay = 1 SECOND //VOREStation Add: Slightly less cumbersome

/obj/item/storage/pouch/ammo
	name = "storage pouch (ammo)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold ammunition, cells, explosives, and grenades."
	icon_state = "ammo"
	max_storage_space = INVENTORY_POUCH_SPACE
	can_hold = list(/obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/cell/device/weapon, /obj/item/grenade, /obj/item/plastique) //Vorestation Add - make it more useful for non-sec/explo

/obj/item/storage/pouch/eng_tool
	name = "storage pouch (tools)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold tools."
	icon_state = "engineering_tool"
	max_storage_space = INVENTORY_POUCH_SPACE
	can_hold = list(
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/tool/transforming/powerdrill,
		/obj/item/tool/transforming/jawsoflife,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/cell/device,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/pda,
		/obj/item/megaphone,
		/obj/item/taperoll,
		/obj/item/radio/headset,
		/obj/item/robotanalyzer,
		/obj/item/material/minihoe,
		/obj/item/material/knife/machete/hatchet,
		/obj/item/analyzer/plant_analyzer,
		/obj/item/extinguisher/mini,
		/obj/item/tape_roll,
		/obj/item/integrated_electronics/wirer,
		/obj/item/integrated_electronics/debugger,
		/obj/item/shovel/spade,
		/obj/item/stack/nanopaste,
		/obj/item/geiger
	) //Vorestation Add - make it the same as the tool-belt why was it not like this to start with wtf

/obj/item/storage/pouch/eng_supply
	name = "storage pouch (supplies)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold engineering supplies."
	icon_state = "engineering_supply"
	max_storage_space = INVENTORY_POUCH_SPACE
	can_hold = list(
		/obj/item/cell/device,
		/obj/item/stack/cable_coil,
		/obj/item/taperoll,
		/obj/item/extinguisher,
		/obj/item/tape_roll,
		/obj/item/stack/material/steel,
		/obj/item/stack/material/glass,
		/obj/item/lightreplacer,
		/obj/item/cell
	) //Vorestation Add - makes it actually useful lmao, adds sheets and cells as well as light replacers and lets you take any extinguisher that fits

/obj/item/storage/pouch/eng_parts
	name = "storage pouch (parts)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold machinery components."
	icon_state = "part_pouch"
	max_storage_space = INVENTORY_POUCH_SPACE*2 //Vorestation Add - yeah lemme give up my pocket to hold FOUR CAPACITORS or have an inferior box... now you can hold eight in your pocket so its at least a box
	can_hold = list(
		/obj/item/stock_parts,
		/obj/item/stack/cable_coil,
		/obj/item/circuitboard
	)

/obj/item/storage/pouch/medical
	name = "storage pouch (medical)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold medical supplies."
	icon_state = "medical_supply"
	max_storage_space = INVENTORY_POUCH_SPACE
	can_hold = list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/quickdraw/syringe_case,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/reagent_containers/hypospray,
		/obj/item/storage/quickdraw/syringe_case,
		/obj/item/syringe_cartridge,
		/obj/item/clothing/gloves/sterile,
		/obj/item/sleevemate,
		/obj/item/bodybag,
		/obj/item/clothing/mask/surgical,
		/obj/item/soap,
		/obj/item/stack/nanopaste,
		/obj/item/taperoll/medical,
		/obj/item/storage/box/freezer,
		/obj/item/clothing/mask/chewable/candy/lolli,
	) //Vorestation add - added a bunch of misc medical stuff
	max_storage_space = ITEMSIZE_COST_SMALL*3 //Vorestation Add - makes it slightly smaller since its a lot of stuff with pocket access
	remove_delay = 5 //Vorestation Add - .5 second delay, get the medical things faster because there is no reason to use this otherwise. still gotta stop moving to take things out.

/obj/item/storage/pouch/flares
	name = "storage pouch (flares)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold flares and glowsticks."
	icon_state = "flare"
	storage_slots = 5
	can_hold = list(/obj/item/flashlight/flare, /obj/item/flashlight/glowstick)
/obj/item/storage/pouch/flares/full_flare
	starts_with = list(/obj/item/flashlight/flare = 5)
/obj/item/storage/pouch/flares/full_glow
	starts_with = list(/obj/item/flashlight/glowstick = 5)

/obj/item/storage/pouch/flares/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("flare_[contents.len]")
	..()

/obj/item/storage/pouch/holster
	name = "storage pouch (holster)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can hold one normal sized weapon."
	icon_state = "pistol_holster"
	storage_slots = 1
	can_hold = list(/obj/item/gun) //this covers basically everything I think so its fine
	remove_delay = 0
/obj/item/storage/pouch/holster/full_stunrevolver
	starts_with = list(/obj/item/gun/energy/stunrevolver)
/obj/item/storage/pouch/holster/full_taser
	starts_with = list(/obj/item/gun/energy/taser)

/obj/item/storage/pouch/holster/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("pistol_layer")
	..()

/obj/item/storage/pouch/baton
	name = "storage pouch (melee)"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can hold one normal size melee." //Vorestation add - make it a melee pouch literally why would you hold ONE BATON
	icon_state = "baton_holster"
	storage_slots = 1
	can_hold = list(/obj/item/melee, /obj/item/material, /obj/item/tool/wrench) //should be like, every melee weapon I could think of that was normal size. Can make it more specific if needed. Also wrench because I thought it was funny.
	remove_delay = 0
/obj/item/storage/pouch/baton/full
	starts_with = list(/obj/item/melee/baton)

/obj/item/storage/pouch/baton/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("baton_layer")
	..()

/obj/item/storage/pouch/holding
	name = "storage pouch of holding"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Seems to use extradimensional storage!"
	icon_state = "holdingpouch"
	max_storage_space = INVENTORY_POUCH_SPACE*2 //VOREStation Edit: Consistency with normal bags of holding

#undef INVENTORY_POUCH_SPACE