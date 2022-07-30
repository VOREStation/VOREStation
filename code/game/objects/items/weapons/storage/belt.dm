/obj/item/storage/belt
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

/obj/item/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"

	if(show_above_suit == -1)
		to_chat(usr, "<span class='notice'>\The [src] cannot be worn above your suit!</span>")
		return
	show_above_suit = !show_above_suit
	update_icon()

//Some belts have sprites to show icons
/obj/item/storage/belt/make_worn_icon(var/body_type,var/slot_name,var/inhands,var/default_icon,var/default_layer = 0,var/icon/clip_mask = null)
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

/obj/item/storage/update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()

/obj/item/storage/belt/utility
	name = "tool-belt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "Can hold various tools."
	icon_state = "utility"
	can_hold = list(
		///obj/item/combitool,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
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
		/obj/item/integrated_electronics/debugger, //Vorestation edit adding debugger to toolbelt can hold list
		/obj/item/shovel/spade, //VOREStation edit. If it can hold minihoes and hatchers, why not the gardening spade?
		/obj/item/stack/nanopaste, //VOREStation edit. Think of it as a tube of superglue. Belts hold that all the time.
		/obj/item/geiger //VOREStation edit. Engineers work with rad-slinging stuff sometimes too
		)

/obj/item/storage/belt/utility/full
	starts_with = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/weldingtool,
		/obj/item/tool/crowbar,
		/obj/item/tool/wirecutters,
		/obj/item/stack/cable_coil/random_belt
	)

/obj/item/storage/belt/utility/full/multitool
	starts_with = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/weldingtool,
		/obj/item/tool/crowbar,
		/obj/item/tool/wirecutters,
		/obj/item/stack/cable_coil/random_belt,
		/obj/item/multitool
	)

/obj/item/storage/belt/utility/atmostech
	starts_with = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/weldingtool,
		/obj/item/tool/crowbar,
		/obj/item/tool/wirecutters,
		/obj/item/analyzer, //Vorestation edit. Gives atmos techs a few extra tools fitting their job from the start
		/obj/item/extinguisher/mini //Vorestation edit. As above, the mini's much more handy to have rather than lugging a big one around
	)

/obj/item/storage/belt/utility/chief
	name = "chief engineer's toolbelt"
	desc = "Holds tools, looks snazzy."
	icon_state = "utilitybelt_ce"
	item_state = "utility_ce"

/obj/item/storage/belt/utility/chief/full
	starts_with = list(
		/obj/item/tool/screwdriver/power,
		/obj/item/tool/crowbar/power,
		/obj/item/weldingtool/experimental,
		/obj/item/multitool,
		/obj/item/stack/cable_coil/random_belt,
		/obj/item/extinguisher/mini,
		/obj/item/analyzer
	)

/obj/item/storage/belt/utility/holding
	name = "tool-belt of holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	icon_state = "utility_holding"
	storage_slots = 14 //twice the amount as a normal belt
	max_storage_space = ITEMSIZE_COST_NORMAL * 14
	can_hold = list(
	/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
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
		/obj/item/cell, //this is a bigger belt, might as well make it hold bigger cells too
		/obj/item/pipe_dispenser, //bigger belt for bigger tools
		/obj/item/rcd, //see above
		/obj/item/quantum_pad_booster,
		/obj/item/inducer,
		/obj/item/stack/material/steel,
		/obj/item/stack/material/glass,
		/obj/item/lightreplacer,
		/obj/item/pickaxe/plasmacutter
	)


/obj/item/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medical"
	can_hold = list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/quickdraw/syringe_case, //VOREStation Addition - Adds syringe cases,
		/obj/item/flame/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/radio/headset,
		/obj/item/pda,
		/obj/item/taperoll,
		/obj/item/megaphone,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves,
		/obj/item/reagent_containers/hypospray,
		/obj/item/clothing/glasses,
		/obj/item/tool/crowbar,
		/obj/item/flashlight,
		/obj/item/cell/device,
		/obj/item/extinguisher/mini,
		/obj/item/storage/quickdraw/syringe_case
		)

/obj/item/storage/belt/medical/emt
	name = "EMT utility belt"
	desc = "A sturdy black webbing belt with attached pouches."
	icon_state = "ems"

/obj/item/storage/belt/medical/holding
	name = "medical belt of holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	icon_state = "med_holding"
	storage_slots = 14 //twice the amount as a normal belt
	max_storage_space = ITEMSIZE_COST_NORMAL * 14

/obj/item/storage/belt/security
	name = "security belt"
	desc = "Can hold security gear like handcuffs and flashes."
	icon_state = "security"
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(
		/obj/item/grenade,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/flash,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing/a12g,
		/obj/item/ammo_magazine,
		/obj/item/cell/device,
		/obj/item/reagent_containers/food/snacks/donut/,
		/obj/item/melee/baton,
		/obj/item/gun/energy/taser,
		/obj/item/gun/energy/stunrevolver,
		/obj/item/gun/energy/stunrevolver/vintage,
		/obj/item/gun/magnetic/railgun/heater/pistol,
		/obj/item/gun/energy/gun,
		/obj/item/flame/lighter,
		/obj/item/flashlight,
		/obj/item/taperecorder,
		/obj/item/tape,
		/obj/item/pda,
		/obj/item/radio/headset,
		/obj/item/clothing/gloves,
		/obj/item/hailer,
		/obj/item/megaphone,
		/obj/item/melee,
		/obj/item/clothing/accessory/badge,
		/obj/item/gun/projectile/sec,
		/obj/item/gun/projectile/p92x,
		/obj/item/taperoll,
		/obj/item/gun/projectile/colt/detective,
		/obj/item/holowarrant
		)

/obj/item/storage/belt/detective
	name = "forensic utility belt"
	desc = "A belt for holding forensics equipment."
	icon_state = "security"
	storage_slots = 7
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(
		/obj/item/taperecorder,
		/obj/item/tape,
		/obj/item/clothing/glasses,
		/obj/item/flashlight,
		/obj/item/cell/device,
		/obj/item/reagent_containers/spray/luminol,
		/obj/item/sample,
		/obj/item/forensics/sample_kit/powder,
		/obj/item/forensics/swab,
		/obj/item/uv_light,
		/obj/item/forensics/sample_kit,
		/obj/item/photo,
		/obj/item/camera_film,
		/obj/item/camera,
		/obj/item/autopsy_scanner,
		/obj/item/mass_spectrometer,
		/obj/item/clothing/accessory/badge,
		/obj/item/reagent_scanner,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/syringe,
		/obj/item/pda,
		/obj/item/hailer,
		/obj/item/megaphone,
		/obj/item/radio/headset,
		/obj/item/clothing/gloves,
		/obj/item/taperoll,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/handcuffs,
		/obj/item/flash,
		/obj/item/flame/lighter,
		/obj/item/reagent_containers/food/snacks/donut/,
		/obj/item/ammo_magazine,
		/obj/item/gun/projectile/colt/detective,
		/obj/item/holowarrant
		)

/obj/item/storage/belt/soulstone
	name = "soul stone belt"
	desc = "Designed for ease of access to the shards during a fight, as to not let a single enemy spirit slip away"
	icon_state = "soulstone"
	storage_slots = 6
	can_hold = list(
		/obj/item/soulstone
		)

/obj/item/storage/belt/soulstone/full
	starts_with = list(/obj/item/soulstone = 6)

/obj/item/storage/belt/utility/alien
	name = "alien belt"
	desc = "A belt(?) that can hold things."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "belt"
	item_state = "security"

/obj/item/storage/belt/utility/alien/full
	starts_with = list(
		/obj/item/tool/screwdriver/alien,
		/obj/item/tool/wrench/alien,
		/obj/item/weldingtool/alien,
		/obj/item/tool/crowbar/alien,
		/obj/item/tool/wirecutters/alien,
		/obj/item/multitool/alien,
		/obj/item/stack/cable_coil/alien
	)

/obj/item/storage/belt/medical/alien
	name = "alien belt"
	desc = "A belt(?) that can hold things."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "belt"
	item_state = "security"
	storage_slots = 8
	can_hold = list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/flame/lighter/zippo,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/radio/headset,
		/obj/item/pda,
		/obj/item/taperoll,
		/obj/item/megaphone,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves,
		/obj/item/reagent_containers/hypospray,
		/obj/item/clothing/glasses,
		/obj/item/tool/crowbar,
		/obj/item/flashlight,
		/obj/item/cell/device,
		/obj/item/extinguisher/mini,
		/obj/item/surgical
		)

/obj/item/storage/belt/medical/alien
	starts_with = list(
		/obj/item/surgical/scalpel/alien,
		/obj/item/surgical/hemostat/alien,
		/obj/item/surgical/retractor/alien,
		/obj/item/surgical/circular_saw/alien,
		/obj/item/surgical/FixOVein/alien,
		/obj/item/surgical/bone_clamp/alien,
		/obj/item/surgical/cautery/alien,
		/obj/item/surgical/surgicaldrill/alien
	)

/obj/item/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "champion"
	storage_slots = 1
	can_hold = list(
		"/obj/item/clothing/mask/luchador"
		)

/obj/item/storage/belt/security/tactical
	name = "combat belt"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "swat"
	storage_slots = 9
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 7

/obj/item/storage/belt/bandolier
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

/obj/item/storage/belt/security/tactical/bandolier
	name = "combat bandolier"
	desc = "Can hold security gear like handcuffs and flashes, with more pouches for more storage."
	icon_state = "bandolier2"

/obj/item/storage/belt/janitor
	name = "janitorial belt"
	desc = "A belt used to hold most janitorial supplies."
	icon_state = "janitor"
	storage_slots = 7
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(
		/obj/item/clothing/glasses,
		/obj/item/flashlight,
		/obj/item/cell/device,
		/obj/item/grenade,
		/obj/item/pda,
		/obj/item/radio/headset,
		/obj/item/clothing/gloves,
		/obj/item/clothing/mask/surgical, //sterile mask,
		/obj/item/assembly/mousetrap,
		/obj/item/light/bulb,
		/obj/item/light/tube,
		/obj/item/flame/lighter,
		/obj/item/megaphone,
		/obj/item/taperoll,
		/obj/item/reagent_containers/spray,
		/obj/item/soap,
		/obj/item/lightreplacer //VOREStation edit
		)

/obj/item/storage/belt/archaeology
	name = "excavation gear-belt"
	desc = "Can hold various excavation gear."
	icon_state = "gear"
	can_hold = list(
		/obj/item/storage/box/samplebags,
		/obj/item/core_sampler,
		/obj/item/beacon_locator,
		/obj/item/radio/beacon,
		/obj/item/gps,
		/obj/item/measuring_tape,
		/obj/item/flashlight,
		/obj/item/cell/device,
		/obj/item/pickaxe,
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
		/obj/item/pickaxe/excavationdrill
		)

/obj/item/storage/belt/fannypack
	name = "leather fannypack"
	desc = "A dorky fannypack for keeping small items in."
	icon_state = "fannypack_leather"
	item_state = "fannypack_leather"
	max_w_class = ITEMSIZE_SMALL
	storage_slots = null
	max_storage_space = ITEMSIZE_COST_NORMAL * 2

/obj/item/storage/belt/fannypack/black
 	name = "black fannypack"
 	icon_state = "fannypack_black"
 	item_state = "fannypack_black"

/obj/item/storage/belt/fannypack/blue
 	name = "blue fannypack"
 	icon_state = "fannypack_blue"
 	item_state = "fannypack_blue"

/obj/item/storage/belt/fannypack/cyan
 	name = "cyan fannypack"
 	icon_state = "fannypack_cyan"
 	item_state = "fannypack_cyan"

/obj/item/storage/belt/fannypack/green
 	name = "green fannypack"
 	icon_state = "fannypack_green"
 	item_state = "fannypack_green"

/obj/item/storage/belt/fannypack/orange
 	name = "orange fannypack"
 	icon_state = "fannypack_orange"
 	item_state = "fannypack_orange"

/obj/item/storage/belt/fannypack/purple
 	name = "purple fannypack"
 	icon_state = "fannypack_purple"
 	item_state = "fannypack_purple"

/obj/item/storage/belt/fannypack/red
 	name = "red fannypack"
 	icon_state = "fannypack_red"
 	item_state = "fannypack_red"

/obj/item/storage/belt/fannypack/white
 	name = "white fannypack"
 	icon_state = "fannypack_white"
 	item_state = "fannypack_white"

/obj/item/storage/belt/fannypack/yellow
 	name = "yellow fannypack"
 	icon_state = "fannypack_yellow"
 	item_state = "fannypack_yellow"

/obj/item/storage/belt/ranger
	name = "ranger belt"
	desc = "The fancy utility-belt holding the tools, cuffs and gadgets of the Go Go ERT-Rangers. The belt buckle is not real phoron, but it is still surprisingly comfortable to wear."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_belt"

/obj/item/storage/belt/dbandolier
	name = "\improper Donk-Soft bandolier"
	desc = "A Donk-Soft bandolier! Carry your spare darts anywhere! Ages 8 and up."
	icon_state = "dbandolier"
	storage_slots = 8
	can_hold = list(
		/obj/item/ammo_casing/afoam_dart
		)
