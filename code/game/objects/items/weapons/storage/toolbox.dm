/*
 *	Toolboxes
 */
/obj/item/weapon/storage/toolbox
	name = "toolbox"
	desc = "Danger. Very robust."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "red"
	item_state_slots = list(slot_r_hand_str = "toolbox_red", slot_l_hand_str = "toolbox_red")
	center_of_mass = list("x" = 16,"y" = 11)
	force = 10
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_SMALL * 7 //enough to hold all starting contents
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("robusted")
	use_sound = 'sound/items/storage/toolbox.ogg'
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

//Emergency
/obj/item/weapon/storage/toolbox/emergency
	name = "emergency toolbox"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "red"
	item_state_slots = list(slot_r_hand_str = "toolbox_red", slot_l_hand_str = "toolbox_red")
	starts_with = list(
		/obj/item/weapon/tool/crowbar/red,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/device/radio
	)
/obj/item/weapon/storage/toolbox/emergency/Initialize()
	if(prob(50))
		new /obj/item/device/flashlight(src)
	else
		new /obj/item/device/flashlight/flare(src)
	. = ..()

//Mechanical
/obj/item/weapon/storage/toolbox/mechanical
	name = "mechanical toolbox"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "blue"
	item_state_slots = list(slot_r_hand_str = "toolbox_blue", slot_l_hand_str = "toolbox_blue")
	starts_with = list(
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/tool/crowbar,
		/obj/item/device/analyzer,
		/obj/item/weapon/tool/wirecutters
	)

//Electrical
/obj/item/weapon/storage/toolbox/electrical
	name = "electrical toolbox"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "yellow"
	item_state_slots = list(slot_r_hand_str = "toolbox_yellow", slot_l_hand_str = "toolbox_yellow")
	starts_with = list(
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/device/t_scanner,
		/obj/item/weapon/tool/crowbar,
		/obj/item/stack/cable_coil/random_belt,
		/obj/item/stack/cable_coil/random_belt
	)
/obj/item/weapon/storage/toolbox/electrical/Initialize()
	. = ..()
	if(prob(5))
		new /obj/item/clothing/gloves/yellow(src)
	else
		new /obj/item/stack/cable_coil/random(src,30)
	calibrate_size()

//Syndicate
/obj/item/weapon/storage/toolbox/syndicate
	name = "black and red toolbox"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "syndicate"
	item_state_slots = list(slot_r_hand_str = "toolbox_syndi", slot_l_hand_str = "toolbox_syndi")
	origin_tech = list(TECH_COMBAT = 1, TECH_ILLEGAL = 1)
	force = 14
	starts_with = list(
		/obj/item/clothing/gloves/yellow,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/device/multitool
	)

/obj/item/weapon/storage/toolbox/syndicate/powertools
	starts_with = list(
		/obj/item/clothing/gloves/yellow,
		/obj/item/weapon/tool/screwdriver/power,
		/obj/item/weapon/weldingtool/experimental,
		/obj/item/weapon/tool/crowbar/power,
		/obj/item/device/multitool,
		/obj/item/stack/cable_coil/random_belt,
		/obj/item/device/analyzer
	)

//Brass
/obj/item/weapon/storage/toolbox/brass
	name = "brass toolbox"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "brass"
	item_state_slots = list(slot_r_hand_str = "toolbox_yellow", slot_l_hand_str = "toolbox_yellow")
	starts_with = list(
		/obj/item/weapon/tool/crowbar/brass,
		/obj/item/weapon/tool/wirecutters/brass,
		/obj/item/weapon/tool/screwdriver/brass,
		/obj/item/weapon/tool/wrench/brass,
		/obj/item/weapon/weldingtool/brass
	)

//Hydro
/obj/item/weapon/storage/toolbox/hydro
	name = "hydroponic toolbox"
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "green"
	item_state_slots = list(slot_r_hand_str = "toolbox_green", slot_l_hand_str = "toolbox_green")
	starts_with = list(
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/weapon/material/minihoe,
		/obj/item/weapon/material/knife/machete/hatchet,
		/obj/item/weapon/tool/wirecutters/clippers/trimmers,
		/obj/item/weapon/reagent_containers/spray/plantbgone,
		/obj/item/weapon/reagent_containers/glass/beaker
	)

/*
 *	Lunchboxes
 */

/obj/item/weapon/storage/toolbox/lunchbox
	max_storage_space = ITEMSIZE_COST_SMALL * 4 //slightly smaller than a toolbox
	name = "rainbow lunchbox"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lunchbox_rainbow"
	item_state_slots = list(slot_r_hand_str = "toolbox_pink", slot_l_hand_str = "toolbox_pink")
	desc = "A little lunchbox. This one is the colors of the rainbow!"
	w_class = ITEMSIZE_NORMAL
	max_w_class = ITEMSIZE_SMALL
	var/filled = FALSE
	attack_verb = list("lunched")

/obj/item/weapon/storage/toolbox/lunchbox/Initialize()
	if(filled)
		var/list/lunches = lunchables_lunches()
		var/lunch = lunches[pick(lunches)]
		new lunch(src)

		var/list/snacks = lunchables_snacks()
		var/snack = snacks[pick(snacks)]
		new snack(src)

		var/list/drinks = lunchables_drinks()
		var/drink = drinks[pick(drinks)]
		new drink(src)
	. = ..()

/obj/item/weapon/storage/toolbox/lunchbox/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/heart
	name = "heart lunchbox"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lunchbox_lovelyhearts"
	item_state_slots = list(slot_r_hand_str = "toolbox_pink", slot_l_hand_str = "toolbox_pink")
	desc = "A little lunchbox. This one has cute little hearts on it!"

/obj/item/weapon/storage/toolbox/lunchbox/heart/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/cat
	name = "cat lunchbox"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lunchbox_sciencecatshow"
	item_state_slots = list(slot_r_hand_str = "toolbox_green", slot_l_hand_str = "toolbox_green")
	desc = "A little lunchbox. This one has a cute little science cat from a popular show on it!"

/obj/item/weapon/storage/toolbox/lunchbox/cat/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/nt
	name = "NanoTrasen brand lunchbox"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lunchbox_nanotrasen"
	item_state_slots = list(slot_r_hand_str = "toolbox_blue", slot_l_hand_str = "toolbox_blue")
	desc = "A little lunchbox. This one is branded with the NanoTrasen logo!"

/obj/item/weapon/storage/toolbox/lunchbox/nt/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/mars
	name = "\improper Mojave university lunchbox"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lunchbox_marsuniversity"
	item_state_slots = list(slot_r_hand_str = "toolbox_red", slot_l_hand_str = "toolbox_red")
	desc = "A little lunchbox. This one is branded with the Mojave university logo!"

/obj/item/weapon/storage/toolbox/lunchbox/mars/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/cti
	name = "\improper CTI lunchbox"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lunchbox_cti"
	item_state_slots = list(slot_r_hand_str = "toolbox_blue", slot_l_hand_str = "toolbox_blue")
	desc = "A little lunchbox. This one is branded with the CTI logo!"

/obj/item/weapon/storage/toolbox/lunchbox/cti/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/nymph
	name = "\improper Diona nymph lunchbox"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lunchbox_dionanymph"
	item_state_slots = list(slot_r_hand_str = "toolbox_yellow", slot_l_hand_str = "toolbox_yellow")
	desc = "A little lunchbox. This one is an adorable Diona nymph on the side!"

/obj/item/weapon/storage/toolbox/lunchbox/nymph/filled
	filled = TRUE

/obj/item/weapon/storage/toolbox/lunchbox/syndicate
	name = "black and red lunchbox"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lunchbox_syndie"
	item_state_slots = list(slot_r_hand_str = "toolbox_syndi", slot_l_hand_str = "toolbox_syndi")
	desc = "A little lunchbox. This one is a sleek black and red, made of a durable steel!"

/obj/item/weapon/storage/toolbox/lunchbox/syndicate/filled
	filled = TRUE
