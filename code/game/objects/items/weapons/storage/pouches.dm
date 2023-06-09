/* POUCHES
 * Small storage items that can fit in your pocket slots
 *
 * Contains:
 *		Base pouch code
 *		Generic pouches
 *		Bluespace pouch
 *		Ammo pouches
 *		Engineering pouches
 *		Medical pouches
 *
 */

// Defines the storage size. Quarter the storage size of a backpack to start.
#define INVENTORY_POUCH_SPACE ITEMSIZE_COST_SMALL * 4

/*
 * Base Storage Pouch
 */
/obj/item/weapon/storage/pouch
	name = "storage pouch"
	desc = "You should not be seeing this. Contact your local admin."
	icon = 'icons/inventory/pockets/item.dmi'
	slot_flags = SLOT_POCKET | SLOT_BELT
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

	max_w_class = ITEMSIZE_NORMAL
	can_hold = null
	pocketable = TRUE

	var/insert_delay = 0 SECONDS
	var/remove_delay = 0 SECONDS

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

/*
 * Generic Pouches
 */
/obj/item/weapon/storage/pouch/small
	name = "small generic pouch"
	desc = "A storage pouch that can be used to provide a small amount of additional storage for quick access."
	icon_state = "small_generic"
	max_storage_space = INVENTORY_POUCH_SPACE * 0.5
	remove_delay = 1 SECONDS

/obj/item/weapon/storage/pouch/medium
	name = "generic pouch"
	desc = "A storage pouch that can be used to provide some additional storage for quick access."
	icon_state = "medium_generic"
	max_storage_space = INVENTORY_POUCH_SPACE
	remove_delay = 2 SECONDS

/obj/item/weapon/storage/pouch/large
	name = "large generic pouch"
	desc = "A storage pouch that can be used to provide a good amount of additional storage for quick access."
	icon_state = "large_generic"
	max_storage_space = INVENTORY_POUCH_SPACE * 1.5
	remove_delay = 3 SECONDS

/obj/item/weapon/storage/pouch/flares
	name = "flare pouch"
	desc = "A sturdy tubular pouch that is commonly used to carry flares or glowsticks."
	icon_state = "flare"
	storage_slots = 5
	can_hold = list(/obj/item/device/flashlight/flare,
					/obj/item/device/flashlight/glowstick)

/obj/item/weapon/storage/pouch/flares/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("flare_[contents.len]")
	..()

/obj/item/weapon/storage/pouch/flares/full_flare
	starts_with = list(/obj/item/device/flashlight/flare = 5)

/obj/item/weapon/storage/pouch/flares/full_glow
	starts_with = list(/obj/item/device/flashlight/glowstick = 5)

/*
 * Bluespace Pouch
 */
/obj/item/weapon/storage/pouch/holding
	name = "pouch of holding"
	desc = "If your pockets are not large enough to store all your belongings, you may want to use this high-tech pouch that opens into a localized pocket of bluespace (pun intended)."
	icon_state = "holdingpouch"
	max_storage_space = INVENTORY_POUCH_SPACE * 2
	remove_delay = 2 SECONDS

/*
 * Ammo Pouches
 */
/obj/item/weapon/storage/pouch/ammo
	name = "ammo pouch"
	desc = "A storage pouch that can hold ammo magazines and bullets, not the boxes though."
	icon_state = "ammo"
	max_storage_space = INVENTORY_POUCH_SPACE
	remove_delay = 2 SECONDS
	can_hold = list(/obj/item/ammo_magazine,
					/obj/item/ammo_casing,
					/obj/item/weapon/cell/device/weapon)

/obj/item/weapon/storage/pouch/grenade
	name = "grenade pouch"
	desc = "A storage pouch that can hold explosives and grenades."
	icon_state = "ammo"
	max_storage_space = INVENTORY_POUCH_SPACE
	remove_delay = 2 SECONDS
	can_hold = list(/obj/item/weapon/grenade,
					/obj/item/weapon/plastique)

/*
 * Engineering Pouches
 */
/obj/item/weapon/storage/pouch/eng_tool
	name = "engineering tools pouch"
	desc = "This storage pouch can be used to provide some additional storage for quick access. Can only hold tools."
	icon_state = "engineering_tool"
	max_storage_space = ITEMSIZE_COST_NORMAL * 4
	remove_delay = 0 SECONDS //Basically a weaker version of the tool belt, no need for a delay
	storage_slots = 4
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
		/obj/item/device/geiger)

/obj/item/weapon/storage/pouch/eng_supply
	name = "engineering supply pouch"
	desc = "A pouch for holding various engineering scanners, power cells and equipment."
	icon_state = "engineering_supply"
	max_storage_space = INVENTORY_POUCH_SPACE
	remove_delay = 2 SECONDS
	can_hold = list(
		/obj/item/stack/cable_coil,
		/obj/item/taperoll,
		/obj/item/device/flashlight,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/tape_roll,
		/obj/item/device/robotanalyzer,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/device/geiger,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/cell)

/obj/item/weapon/storage/pouch/eng_parts
	name = "engineering material pouch"
	desc = "A pouch for holding sheets, rods, miscellaneous parts and cable coils."
	icon_state = "part_pouch"
	max_storage_space = INVENTORY_POUCH_SPACE * 2
	remove_delay = 2 SECONDS
	can_hold = list(
		/obj/item/weapon/stock_parts,
		/obj/item/stack/cable_coil,
		/obj/item/weapon/circuitboard,
		/obj/item/stack/material,
		/obj/item/stack/rods)

/*
 * Medical Pouches
 */
/obj/item/weapon/storage/pouch/medical
	name = "medical supply pouch"
	desc = "A small pouch for holding medical supplies."
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
		/obj/item/bodybag,
		/obj/item/clothing/mask/surgical,
		/obj/item/weapon/soap,
		/obj/item/stack/nanopaste,
		/obj/item/taperoll/medical,
		/obj/item/weapon/storage/box/freezer,
		/obj/item/clothing/mask/chewable/candy/lolli)
	max_storage_space = INVENTORY_POUCH_SPACE * 1.5
	remove_delay = 4

/obj/item/weapon/storage/pouch/injector
	name = "injector pouch"
	desc = "A sturdy tubular pouch that is commonly used to carry various autoinjectors."
	icon_state = "injector"
	storage_slots = 4
	remove_delay = 2 SECONDS
	can_hold = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector)

/obj/item/weapon/storage/pouch/injector/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("injector_[contents.len]")
	..()

#undef INVENTORY_POUCH_SPACE
