/obj/item/weapon/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/inventory/belt/item.dmi'
	icon_state = "utility"
	storage_slots = 7
	max_storage_space = ITEMSIZE_COST_NORMAL * 7 //This should ensure belts always have enough room to store whatever.
	max_w_class = ITEMSIZE_NORMAL
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined")
	equip_sound = 'sound/items/toolbelt_equip.ogg'
	drop_sound = 'sound/items/drop/toolbelt.ogg'
	pickup_sound = 'sound/items/pickup/toolbelt.ogg'
	sprite_sheets = list(SPECIES_TESHARI = 'icons/inventory/belt/mob_teshari.dmi')

	var/show_above_suit = 0

/obj/item/weapon/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"

	if(show_above_suit == -1)
		to_chat(usr, "<span class='notice'>\The [src] cannot be worn above your suit!</span>")
		return
	show_above_suit = !show_above_suit
	update_icon()

//Some belts have sprites to show icons
/obj/item/weapon/storage/belt/make_worn_icon(var/body_type,var/slot_name,var/inhands,var/default_icon,var/default_layer = 0,var/icon/clip_mask = null)
	var/image/standing = ..()
	if(!inhands && contents.len)
		for(var/obj/item/i in contents)
			var/i_state = i.item_state
			if(!i_state) i_state = i.icon_state
			var/image/add_icon = image(icon = INV_BELT_DEF_ICON, icon_state = i_state)
			if(istype(clip_mask)) //For taur bodies/tails clipping off parts of uniforms and suits.
				standing.filters += filter(type = "alpha", icon = clip_mask)
			standing.add_overlay(add_icon)
	return standing

/obj/item/weapon/storage/update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()

/obj/item/weapon/storage/belt/utility
	name = "tool-belt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "Can hold various tools."
	icon_state = "utility"
	can_hold = list(
		///obj/item/weapon/combitool,
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
		/obj/item/device/integrated_electronics/debugger, //Vorestation edit adding debugger to toolbelt can hold list
		/obj/item/weapon/shovel/spade, //VOREStation edit. If it can hold minihoes and hatchers, why not the gardening spade?
		/obj/item/stack/nanopaste, //VOREStation edit. Think of it as a tube of superglue. Belts hold that all the time.
		/obj/item/device/geiger //VOREStation edit. Engineers work with rad-slinging stuff sometimes too
		)

/obj/item/weapon/storage/belt/utility/full
	starts_with = list(
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/stack/cable_coil/random_belt
	)

/obj/item/weapon/storage/belt/utility/full/multitool
	starts_with = list(
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/stack/cable_coil/random_belt,
		/obj/item/device/multitool
	)

/obj/item/weapon/storage/belt/utility/atmostech
	starts_with = list(
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/weldingtool,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/tool/wirecutters,
		/obj/item/device/analyzer, //Vorestation edit. Gives atmos techs a few extra tools fitting their job from the start
		/obj/item/weapon/extinguisher/mini //Vorestation edit. As above, the mini's much more handy to have rather than lugging a big one around
	)

/obj/item/weapon/storage/belt/utility/chief
	name = "chief engineer's toolbelt"
	desc = "Holds tools, looks snazzy."
	icon_state = "utilitybelt_ce"
	item_state = "utility_ce"
	storage_slots = 8	//If they get better everything-else, why not the belt too?
	can_hold = list(
		/obj/item/weapon/rcd,	//They've given one from the get-go, it's hard to imagine they wouldn't be given something that can store it neater than a bag
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
		/obj/item/device/geiger,
		/obj/item/areaeditor/blueprints,	//It's a bunch of paper that could prolly be rolled up & slipped into the belt, not to mention CE only, see the RCD's thing above
		/obj/item/wire_reader	//As above
		)

/obj/item/weapon/storage/belt/utility/chief/full
	starts_with = list(
		/obj/item/weapon/tool/screwdriver/power,
		/obj/item/weapon/tool/crowbar/power,
		/obj/item/weapon/weldingtool/experimental,
		/obj/item/device/multitool,
		/obj/item/stack/cable_coil/random_belt,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/device/analyzer
	)

/obj/item/weapon/storage/belt/utility/holding
	name = "tool-belt of holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	icon_state = "utility_holding"
	storage_slots = 14 //twice the amount as a normal belt
	max_storage_space = ITEMSIZE_COST_NORMAL * 14
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
		/obj/item/weapon/cell, //this is a bigger belt, might as well make it hold bigger cells too
		/obj/item/weapon/pipe_dispenser, //bigger belt for bigger tools
		/obj/item/weapon/rcd, //see above
		/obj/item/device/quantum_pad_booster,
		/obj/item/weapon/inducer,
		/obj/item/stack/material/steel,
		/obj/item/stack/material/glass,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/pickaxe/plasmacutter
	)


/obj/item/weapon/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medical"
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/weapon/dnainjector,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/bottle,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/storage/quickdraw/syringe_case, //VOREStation Addition - Adds syringe cases,
		/obj/item/weapon/flame/lighter/zippo,
		/obj/item/weapon/storage/fancy/cigarettes,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/radio/headset,
		/obj/item/device/pda,
		/obj/item/taperoll,
		/obj/item/device/megaphone,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/clothing/glasses,
		/obj/item/weapon/tool/crowbar,
		/obj/item/device/flashlight,
		/obj/item/weapon/cell/device,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/storage/quickdraw/syringe_case
		)

/obj/item/weapon/storage/belt/medical/emt
	name = "EMT utility belt"
	desc = "A sturdy black webbing belt with attached pouches."
	icon_state = "ems"

/obj/item/weapon/storage/belt/medical/holding
	name = "medical belt of holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	icon_state = "med_holding"
	storage_slots = 14 //twice the amount as a normal belt
	max_storage_space = ITEMSIZE_COST_NORMAL * 14

/obj/item/weapon/storage/belt/security
	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "security"
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(
		/obj/item/weapon/grenade,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/handcuffs,
		/obj/item/device/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/a12g,
		/obj/item/ammo_magazine,
		/obj/item/weapon/cell/device,
		/obj/item/weapon/reagent_containers/food/snacks/donut/,
		/obj/item/weapon/melee/baton,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/weapon/gun/energy/stunrevolver,
		/obj/item/weapon/gun/energy/stunrevolver/vintage,
		/obj/item/weapon/gun/magnetic/railgun/heater/pistol,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/flame/lighter,
		/obj/item/device/flashlight,
		/obj/item/device/taperecorder,
		/obj/item/device/tape,
		/obj/item/device/pda,
		/obj/item/device/radio/headset,
		/obj/item/clothing/gloves,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/weapon/melee,
		/obj/item/clothing/accessory/badge,
		/obj/item/weapon/gun/projectile/sec,
		/obj/item/weapon/gun/projectile/p92x,
		/obj/item/taperoll,
		/obj/item/weapon/gun/projectile/colt/detective,
		/obj/item/device/holowarrant
		)

/obj/item/weapon/storage/belt/detective
	name = "forensic utility belt"
	desc = "A belt for holding forensics equipment."
	icon_state = "security"
	storage_slots = 7
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(
		/obj/item/device/taperecorder,
		/obj/item/device/tape,
		/obj/item/clothing/glasses,
		/obj/item/device/flashlight,
		/obj/item/weapon/cell/device,
		/obj/item/weapon/reagent_containers/spray/luminol,
		/obj/item/weapon/sample,
		/obj/item/weapon/forensics/sample_kit/powder,
		/obj/item/weapon/forensics/swab,
		/obj/item/device/uv_light,
		/obj/item/weapon/forensics/sample_kit,
		/obj/item/weapon/photo,
		/obj/item/device/camera_film,
		/obj/item/device/camera,
		/obj/item/weapon/autopsy_scanner,
		/obj/item/device/mass_spectrometer,
		/obj/item/clothing/accessory/badge,
		/obj/item/device/reagent_scanner,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/device/pda,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/device/radio/headset,
		/obj/item/clothing/gloves,
		/obj/item/taperoll,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/handcuffs,
		/obj/item/device/flash,
		/obj/item/weapon/flame/lighter,
		/obj/item/weapon/reagent_containers/food/snacks/donut/,
		///obj/item/ammo_magazine,	//Detectives don't get projectile weapons as standard here
		///obj/item/weapon/gun/projectile/colt/detective,	//Detectives don't get projectile weapons as standard here
		/obj/item/weapon/gun/energy/stunrevolver/detective,	//In keeping with the same vein as above, they can store their special one
		/obj/item/device/holowarrant,
		/obj/item/weapon/reagent_containers/food/drinks/flask
		)

/obj/item/weapon/storage/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away"
	icon_state = "soulstone"
	storage_slots = 6
	can_hold = list(
		/obj/item/device/soulstone
		)

/obj/item/weapon/storage/belt/soulstone/full
	starts_with = list(/obj/item/device/soulstone = 6)

/obj/item/weapon/storage/belt/utility/alien
	name = "alien belt"
	desc = "A belt(?) that can hold things."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "belt"
	item_state = "security"

/obj/item/weapon/storage/belt/utility/alien/full
	starts_with = list(
		/obj/item/weapon/tool/screwdriver/alien,
		/obj/item/weapon/tool/wrench/alien,
		/obj/item/weapon/weldingtool/alien,
		/obj/item/weapon/tool/crowbar/alien,
		/obj/item/weapon/tool/wirecutters/alien,
		/obj/item/device/multitool/alien,
		/obj/item/stack/cable_coil/alien
	)

/obj/item/weapon/storage/belt/medical/alien
	name = "alien belt"
	desc = "A belt(?) that can hold things."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "belt"
	item_state = "security"
	storage_slots = 8
	can_hold = list(
		/obj/item/device/healthanalyzer,
		/obj/item/weapon/dnainjector,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/bottle,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/flame/lighter/zippo,
		/obj/item/weapon/storage/fancy/cigarettes,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/device/radio/headset,
		/obj/item/device/pda,
		/obj/item/taperoll,
		/obj/item/device/megaphone,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/clothing/glasses,
		/obj/item/weapon/tool/crowbar,
		/obj/item/device/flashlight,
		/obj/item/weapon/cell/device,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/surgical
		)

/obj/item/weapon/storage/belt/medical/alien
	starts_with = list(
		/obj/item/weapon/surgical/scalpel/alien,
		/obj/item/weapon/surgical/hemostat/alien,
		/obj/item/weapon/surgical/retractor/alien,
		/obj/item/weapon/surgical/circular_saw/alien,
		/obj/item/weapon/surgical/FixOVein/alien,
		/obj/item/weapon/surgical/bone_clamp/alien,
		/obj/item/weapon/surgical/cautery/alien,
		/obj/item/weapon/surgical/surgicaldrill/alien
	)

/obj/item/weapon/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "champion"
	storage_slots = 1
	can_hold = list(
		"/obj/item/clothing/mask/luchador"
		)

/obj/item/weapon/storage/belt/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swat"
	storage_slots = 9
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 7

/obj/item/weapon/storage/belt/bandolier
	name = "shotgun bandolier"
	desc = "Designed to hold shotgun shells. Can't really hold more than that."
	icon_state = "bandolier1"
	storage_slots = 8
	max_w_class = ITEMSIZE_TINY
	can_hold = list(
		/obj/item/ammo_casing/a12g,
		/obj/item/ammo_casing/a12g/pellet,
		/obj/item/ammo_casing/a12g/blank,
		/obj/item/ammo_casing/a12g/practice,
		/obj/item/ammo_casing/a12g/beanbag,
		/obj/item/ammo_casing/a12g/stunshell,
		/obj/item/ammo_casing/a12g/flash,
		/obj/item/ammo_casing/a12g/emp,
		/obj/item/ammo_casing/a12g/flechette
		)

/obj/item/weapon/storage/belt/security/tactical/bandolier
	name = "combat bandolier"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "bandolier2"

/obj/item/weapon/storage/belt/janitor
	name = "janitorial belt"
	desc = "A belt used to hold most janitorial supplies."
	icon_state = "janitor"
	storage_slots = 7
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(
		/obj/item/clothing/glasses,
		/obj/item/device/flashlight,
		/obj/item/weapon/cell/device,
		/obj/item/weapon/grenade,
		/obj/item/device/pda,
		/obj/item/device/radio/headset,
		/obj/item/clothing/gloves,
		/obj/item/clothing/mask/surgical, //sterile mask,
		/obj/item/device/assembly/mousetrap,
		/obj/item/weapon/light/bulb,
		/obj/item/weapon/light/tube,
		/obj/item/weapon/flame/lighter,
		/obj/item/device/megaphone,
		/obj/item/taperoll,
		/obj/item/weapon/reagent_containers/spray,
		/obj/item/weapon/soap,
		/obj/item/device/lightreplacer //VOREStation edit
		)

/obj/item/weapon/storage/belt/archaeology
	name = "excavation gear-belt"
	desc = "Can hold various excavation gear."
	icon_state = "gear"
	can_hold = list(
		/obj/item/weapon/storage/box/samplebags,
		/obj/item/device/core_sampler,
		/obj/item/device/beacon_locator,
		/obj/item/device/radio/beacon,
		/obj/item/device/gps,
		/obj/item/device/measuring_tape,
		/obj/item/device/flashlight,
		/obj/item/weapon/cell/device,
		/obj/item/weapon/pickaxe,
		/obj/item/device/depth_scanner,
		/obj/item/device/camera,
		/obj/item/weapon/paper,
		/obj/item/weapon/photo,
		/obj/item/weapon/folder,
		/obj/item/weapon/pen,
		/obj/item/weapon/folder,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/anodevice,
		/obj/item/clothing/glasses,
		/obj/item/weapon/tool/wrench,
		/obj/item/weapon/storage/excavation,
		/obj/item/weapon/anobattery,
		/obj/item/device/ano_scanner,
		/obj/item/weapon/pickaxe/hand,
		/obj/item/device/xenoarch_multi_tool,
		/obj/item/weapon/pickaxe/excavationdrill
		)

/obj/item/weapon/storage/belt/fannypack
	name = "leather fannypack"
	desc = "A dorky fannypack for keeping small items in."
	icon_state = "fannypack_leather"
	item_state = "fannypack_leather"
	max_w_class = ITEMSIZE_SMALL
	storage_slots = null
	max_storage_space = ITEMSIZE_COST_NORMAL * 2

/obj/item/weapon/storage/belt/fannypack/black
 	name = "black fannypack"
 	icon_state = "fannypack_black"
 	item_state = "fannypack_black"

/obj/item/weapon/storage/belt/fannypack/blue
 	name = "blue fannypack"
 	icon_state = "fannypack_blue"
 	item_state = "fannypack_blue"

/obj/item/weapon/storage/belt/fannypack/cyan
 	name = "cyan fannypack"
 	icon_state = "fannypack_cyan"
 	item_state = "fannypack_cyan"

/obj/item/weapon/storage/belt/fannypack/green
 	name = "green fannypack"
 	icon_state = "fannypack_green"
 	item_state = "fannypack_green"

/obj/item/weapon/storage/belt/fannypack/orange
 	name = "orange fannypack"
 	icon_state = "fannypack_orange"
 	item_state = "fannypack_orange"

/obj/item/weapon/storage/belt/fannypack/purple
 	name = "purple fannypack"
 	icon_state = "fannypack_purple"
 	item_state = "fannypack_purple"

/obj/item/weapon/storage/belt/fannypack/red
 	name = "red fannypack"
 	icon_state = "fannypack_red"
 	item_state = "fannypack_red"

/obj/item/weapon/storage/belt/fannypack/white
 	name = "white fannypack"
 	icon_state = "fannypack_white"
 	item_state = "fannypack_white"

/obj/item/weapon/storage/belt/fannypack/yellow
 	name = "yellow fannypack"
 	icon_state = "fannypack_yellow"
 	item_state = "fannypack_yellow"

/obj/item/weapon/storage/belt/ranger
	name = "ranger belt"
	desc = "The fancy utility-belt holding the tools, cuffs and gadgets of the Go Go ERT-Rangers. The belt buckle is not real phoron, but it is still surprisingly comfortable to wear."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_belt"

/obj/item/weapon/storage/belt/dbandolier
	name = "\improper Donk-Soft bandolier"
	desc = "A Donk-Soft bandolier! Carry your spare darts anywhere! Ages 8 and up."
	icon_state = "dbandolier"
	storage_slots = 8
	can_hold = list(
		/obj/item/ammo_casing/afoam_dart
		)
