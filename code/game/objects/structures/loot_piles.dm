/*
Basically, each player key gets one chance per loot pile to get them phat lewt.
When they click the pile, after a delay, they 'roll' if they get anything, using chance_nothing.  If they're unlucky, they get nothing.
Otherwise, they roll up to two times, first a roll for rare things, using chance_rare.  If they succeed, they get something quite good.
If that roll fails, they do one final roll, using chance_uncommon.  If they succeed, they get something fairly useful.
If that fails again, they walk away with some common junk.

The same player cannot roll again, however other players can.  This has two benefits.  The first benefit is that someone raiding all of
maintenance will not deprive other people from a shot at loot, and that for the surface variants, it quietly encourages bringing along
buddies, to get more chances at getting cool things instead of someone going solo to hoard all the stuff.

Loot piles can be depleted, if loot_depleted is turned on.  Note that players who searched the pile already won't deplete the loot furthers when searching again.
*/

/obj/structure/loot_pile
	name = "base loot pile"
	desc = "If you can read me, this is bugged"
	description_info = "This can be searched by clicking on it and waiting a few seconds.  You might find valuable treasures or worthless junk. \
	These can only searched each once per player."
	icon = 'icons/obj/loot_piles.dmi'
	icon_state = "randompile"
	density = FALSE
	anchored = TRUE
	unacidable = TRUE

	var/list/icon_states_to_use = list() // List of icon states the pile can choose from on initialization. If empty or null, it will stay the initial icon_state.

	var/list/searched_by = list()	// Keys that have searched this loot pile, with values of searched time.
	var/allow_multiple_looting = FALSE	// If true, the same person can loot multiple times.  Mostly for debugging.
	var/busy = FALSE				// Used so you can't spamclick to loot.

	var/chance_nothing = 0			// Unlucky people might need to loot multiple spots to find things.

	var/chance_uncommon = 10		// Probability of pulling from the uncommon_loot list.
	var/chance_rare = 1				// Ditto, but for rare_loot list.
	var/loot_depletion = FALSE		// If true, loot piles can be 'depleted' after a certain number of searches by different players, where no more loot can be obtained.
	var/loot_left = 0				// When this reaches zero, and loot_depleted is true, you can't obtain anymore loot.
	var/delete_on_depletion = FALSE	// If true, and if the loot gets depleted as above, the pile is deleted.

	var/list/common_loot = list()	// Common is generally less-than-useful junk and filler, at least for maint loot piles.
	var/list/uncommon_loot = list()	// Uncommon is actually maybe some useful items, usually the reason someone bothers looking inside.
	var/list/rare_loot = list()		// Rare is really powerful, or at least unique items.

/obj/structure/loot_pile/attack_ai(var/mob/user)
	if(isrobot(user) && Adjacent(user))
		return attack_hand(user)

/obj/structure/loot_pile/attack_hand(mob/user)
	//Human mob
	if(isliving(user))
		var/mob/living/L = user

		if(busy)
			to_chat(L, "<span class='warning'>\The [src] is already being searched.</span>")
			return

		L.visible_message("[user] searches through \the [src].","<span class='notice'>You search through \the [src].</span>")

		//Do the searching
		busy = TRUE
		if(do_after(user,rand(4 SECONDS,6 SECONDS),src))
			// The loot's all gone.
			if(loot_depletion && loot_left <= 0)
				to_chat(L, "<span class='warning'>\The [src] has been picked clean.</span>")
				busy = FALSE
				return

			//You already searched this one
			if( (user.ckey in searched_by) && !allow_multiple_looting)
				to_chat(L, "<span class='warning'>You can't find anything else vaguely useful in \the [src].  Another set of eyes might, however.</span>")
				busy = FALSE
				return

			// You got unlucky.
			if(chance_nothing && prob(chance_nothing))
				to_chat(L, "<span class='warning'>Nothing in this pile really catches your eye...</span>")
				searched_by |= user.ckey
				busy = FALSE
				return

			// You found something!
			var/obj/item/loot = null
			var/span = "notice" // Blue

			if(prob(chance_rare) && rare_loot.len) // You won THE GRAND PRIZE!
				loot = produce_rare_item()
				span = "cult" // Purple and bold.

			else if(prob(chance_uncommon) && uncommon_loot.len) // Otherwise you might still get something good.
				loot = produce_uncommon_item()
				span = "alium" // Green

			else // Welp.
				loot = produce_common_item()

			if(loot)
				searched_by |= user.ckey
				loot.forceMove(get_turf(src))
				to_chat(L, "<span class='[span]'>You found \a [loot]!</span>")
				if(loot_depletion)
					loot_left--
					if(loot_left <= 0)
						to_chat(L, "<span class='warning'>You seem to have gotten the last of the spoils inside \the [src].</span>")
						if(delete_on_depletion)
							qdel(src)

		busy = FALSE
	else
		return ..()

/obj/structure/loot_pile/proc/produce_common_item()
	var/path = pick(common_loot)
	return new path(src)

/obj/structure/loot_pile/proc/produce_uncommon_item()
	var/path = pick(uncommon_loot)
	return new path(src)

/obj/structure/loot_pile/proc/produce_rare_item()
	var/path = pick(rare_loot)
	return new path(src)

/obj/structure/loot_pile/Initialize()
	if(icon_states_to_use && icon_states_to_use.len)
		icon_state = pick(icon_states_to_use)
	. = ..()

// Has large amounts of possible items, most of which may or may not be useful.
/obj/structure/loot_pile/maint/junk
	name = "pile of junk"
	desc = "Lots of junk lying around.  They say one man's trash is another man's treasure."
	icon_states_to_use = list("junk_pile1", "junk_pile2", "junk_pile3", "junk_pile4", "junk_pile5")

	common_loot = list(
		/obj/item/flashlight/flare,
		/obj/item/flashlight/glowstick,
		/obj/item/flashlight/glowstick/blue,
		/obj/item/flashlight/glowstick/orange,
		/obj/item/flashlight/glowstick/red,
		/obj/item/flashlight/glowstick/yellow,
		/obj/item/flashlight/pen,
		/obj/item/cell,
		/obj/item/cell/device,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/mask/breath,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/reagent_containers/food/snacks/liquidfood,
		/obj/item/storage/secure/briefcase,
		/obj/item/storage/briefcase,
		/obj/item/storage/backpack,
		/obj/item/storage/backpack/satchel/norm,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/dufflebag,
		/obj/item/storage/box,
		/obj/item/storage/wallet,
		/obj/item/clothing/shoes/galoshes,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup/grey,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/gloves/botanic_leather,
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/clothing/gloves/white,
		/obj/item/clothing/gloves/rainbow,
		/obj/item/clothing/gloves/fyellow,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/meson/prescription,
		/obj/item/clothing/glasses/welding,
		/obj/item/clothing/head/bio_hood/general,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/space/emergency,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/bio_suit/general,
		/obj/item/clothing/suit/storage/toggle/hoodie/black,
		/obj/item/clothing/suit/storage/toggle/hoodie/blue,
		/obj/item/clothing/suit/storage/toggle/hoodie/red,
		/obj/item/clothing/suit/storage/toggle/hoodie/yellow,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/storage/toggle/leather_jacket,
		/obj/item/clothing/suit/storage/apron,
		/obj/item/clothing/under/color/grey,
		/obj/item/clothing/under/syndicate/tacticool,
		/obj/item/clothing/under/pants/camo,
		/obj/item/clothing/under/harness,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/spacecash/c1,
		/obj/item/spacecash/c10,
		/obj/item/spacecash/c20,
		/obj/item/camera_assembly,
		/obj/item/clothing/suit/caution,
		/obj/item/clothing/head/cone,
		/obj/item/card/emag_broken,
		/obj/item/camera,
		/obj/item/pda,
		/obj/item/radio/headset,
		/obj/item/paicard,
		/obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose
	)

	uncommon_loot = list(
		/obj/item/clothing/shoes/syndigaloshes,
		/obj/item/clothing/gloves/yellow,
		/obj/item/clothing/under/tactical,
		/obj/item/beartrap,
		/obj/item/clothing/suit/storage/vest/press,
		/obj/item/material/knife/tacknife,
		/obj/item/material/butterfly/switchblade
	)

	rare_loot = list(
		/obj/item/clothing/suit/storage/vest/heavy/merc,
		/obj/item/clothing/shoes/boots/combat,
	)

// Contains mostly useless garbage.
/obj/structure/loot_pile/maint/trash
	name = "pile of trash"
	desc = "Lots of garbage in one place.  Might be able to find something if you're in the mood for dumpster diving."
	icon_states_to_use = list("trash_pile1", "trash_pile2")

	common_loot = list(
		/obj/item/trash/candle,
		/obj/item/trash/candy,
		/obj/item/trash/candy/proteinbar,
		/obj/item/trash/candy/gums,
		/obj/item/trash/cheesie,
		/obj/item/trash/chips,
		/obj/item/trash/chips/bbq,
		/obj/item/trash/liquidfood,
		/obj/item/trash/pistachios,
		/obj/item/trash/plate,
		/obj/item/trash/popcorn,
		/obj/item/trash/raisins,
		/obj/item/trash/semki,
		/obj/item/trash/snack_bowl,
		/obj/item/trash/sosjerky,
		/obj/item/trash/syndi_cakes,
		/obj/item/trash/tastybread,
		/obj/item/trash/coffee,
		/obj/item/trash/tray,
		/obj/item/trash/unajerky,
		/obj/item/trash/waffles,
		/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat,
		/obj/item/reagent_containers/food/snacks/mysterysoup,
		/obj/item/reagent_containers/food/snacks/old/hotdog,
		/obj/item/pizzabox/old,
		/obj/item/ammo_casing/spent,
		/obj/item/stack/rods{amount = 5},
		/obj/item/stack/material/steel{amount = 5},
		/obj/item/stack/material/cardboard{amount = 5},
		/obj/item/poster,
		/obj/item/poster/custom,
		/obj/item/newspaper,
		/obj/item/paper/crumpled,
		/obj/item/paper/crumpled/bloody
	)

	uncommon_loot = list(
		/obj/item/reagent_containers/syringe/steroid,
		/obj/item/storage/pill_bottle/zoom,
		/obj/item/storage/pill_bottle/happy,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/paracetamol //VOREStation Edit
	)

// Contains loads of different types of boxes, which may have items inside!
/obj/structure/loot_pile/maint/boxfort
	name = "pile of boxes"
	desc = "A large pile of boxes sits here."
	density = TRUE
	icon_states_to_use = list("boxfort")

	common_loot = list(
		/obj/item/storage/box,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/botanydisk,
		/obj/item/storage/box/cups,
		/obj/item/storage/box/disks,
		/obj/item/storage/box/donkpockets,
		/obj/item/storage/box/donut,
		/obj/item/storage/box/donut/empty,
		/obj/item/storage/box/evidence,
		/obj/item/storage/box/lights/mixed,
		/obj/item/storage/box/lights/tubes,
		/obj/item/storage/box/lights/bulbs,
		/obj/item/storage/box/injectors,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/ids,
		/obj/item/storage/box/mousetraps,
		/obj/item/storage/box/syringes,
		/obj/item/storage/box/survival,
		/obj/item/storage/box/gloves,
		/obj/item/storage/box/PDAs
	)

	uncommon_loot = list(
		/obj/item/storage/box/sinpockets,
		/obj/item/ammo_magazine/ammo_box/b12g/practice,
		/obj/item/ammo_magazine/ammo_box/b12g/blank,
		/obj/item/storage/box/metalfoam,
		/obj/item/storage/box/handcuffs,
		/obj/item/storage/box/seccarts
	)

	rare_loot = list(
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/box/empslite,
		/obj/item/ammo_magazine/ammo_box/b12g/flash,
		/obj/item/ammo_magazine/ammo_box/b12g/stunshell,
		/obj/item/storage/box/teargas
	)

// One of the more useful maint piles, contains electrical components.
/obj/structure/loot_pile/maint/technical
	name = "broken machine"
	desc = "A destroyed machine with unknown purpose, and doesn't look like it can be fixed.  It might still have some functional components?"
	density = TRUE
	icon_states_to_use = list("technical_pile1", "technical_pile2", "technical_pile3")

	common_loot = list(
		/obj/item/stock_parts/gear,
		/obj/item/stock_parts/console_screen,
		/obj/item/stock_parts/spring,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/capacitor/adv,
		/obj/item/stock_parts/capacitor/super,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator/nano,
		/obj/item/stock_parts/manipulator/pico,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin/adv,
		/obj/item/stock_parts/matter_bin/super,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/scanning_module/adv,
		/obj/item/stock_parts/scanning_module/phasic,
		/obj/item/stock_parts/subspace/amplifier,
		/obj/item/stock_parts/subspace/analyzer,
		/obj/item/stock_parts/subspace/ansible,
		/obj/item/stock_parts/subspace/crystal,
		/obj/item/stock_parts/subspace/sub_filter,
		/obj/item/stock_parts/subspace/transmitter,
		/obj/item/stock_parts/subspace/treatment,
		/obj/item/frame,
		/obj/item/broken_device/random,
		/obj/item/borg/upgrade/restart,
		/obj/item/cell,
		/obj/item/cell/high,
		/obj/item/cell/device,
		/obj/item/circuitboard/broken,
		/obj/item/circuitboard/arcade,
		/obj/item/circuitboard/autolathe,
		/obj/item/circuitboard/atmos_alert,
		/obj/item/circuitboard/airalarm,
		/obj/item/circuitboard/fax,
		/obj/item/circuitboard/jukebox,
		/obj/item/circuitboard/batteryrack,
		/obj/item/circuitboard/message_monitor,
		/obj/item/circuitboard/rcon_console,
		/obj/item/smes_coil,
		/obj/item/cartridge/engineering,
		/obj/item/analyzer,
		/obj/item/healthanalyzer,
		/obj/item/robotanalyzer,
		/obj/item/lightreplacer,
		/obj/item/radio,
		/obj/item/hailer,
		/obj/item/gps,
		/obj/item/geiger,
		/obj/item/mass_spectrometer,
		/obj/item/tool/wrench,
		/obj/item/tool/screwdriver,
		/obj/item/tool/wirecutters,
		/obj/item/mining_scanner/advanced,
		/obj/item/multitool,
		/obj/item/mecha_parts/mecha_equipment/generator,
		/obj/item/mecha_parts/mecha_equipment/tool/cable_layer,
		/obj/item/mecha_parts/mecha_equipment/tool/drill,
		/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp,
		/obj/item/mecha_parts/mecha_equipment/tool/passenger,
		/obj/item/mecha_parts/mecha_equipment/tool/sleeper,
		/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun,
		/obj/item/robot_parts/robot_component/binary_communication_device,
		/obj/item/robot_parts/robot_component/armour,
		/obj/item/robot_parts/robot_component/actuator,
		/obj/item/robot_parts/robot_component/camera,
		/obj/item/robot_parts/robot_component/diagnosis_unit,
		/obj/item/robot_parts/robot_component/radio
	)

	uncommon_loot = list(
		/obj/item/cell/super,
		/obj/item/cell/device/weapon,
		/obj/item/circuitboard/security,
		/obj/item/circuitboard/crew,
		/obj/item/aiModule/reset,
		/obj/item/smes_coil/super_capacity,
		/obj/item/smes_coil/super_io,
		/obj/item/cartridge/captain,
		/obj/item/disk/integrated_circuit/upgrade/advanced,
		/obj/item/tvcamera,
		/obj/item/universal_translator,
		/obj/item/aicard,
		/obj/item/borg/upgrade/jetpack,
		/obj/item/borg/upgrade/advhealth,
		/obj/item/borg/upgrade/vtec,
		/obj/item/borg/upgrade/tasercooler,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser,
		/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/plasmacutter,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/sprinter
	)

	rare_loot = list(
		/obj/item/cell/hyper,
		/obj/item/aiModule/freeform,
		/obj/item/aiModule/asimov,
		/obj/item/aiModule/paladin,
		/obj/item/aiModule/safeguard,
		/obj/item/disposable_teleporter,
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	)


// Surface base type
/obj/structure/loot_pile/surface
	// Surface loot piles are considerably harder and more dangerous to reach, so you're more likely to get rare things.
	chance_uncommon = 20
	chance_rare = 5
	loot_depletion = TRUE
	loot_left = 5 // This is to prevent people from asking the whole station to go down to some alien ruin to get massive amounts of phat lewt.

// Base type for alien piles.
/obj/structure/loot_pile/surface/alien
	name = "alien pod"
	desc = "A pod which looks bigger on the inside. Something quite shiny might be inside?"
	icon_state = "alien_pile1"

/obj/structure/loot_pile/surface/alien
	common_loot = list(
		/obj/item/prop/alien/junk
	)

// May contain alien tools.
/obj/structure/loot_pile/surface/alien/engineering
	uncommon_loot = list(
		/obj/item/multitool/alien,
		/obj/item/stack/cable_coil/alien,
		/obj/item/tool/crowbar/alien,
		/obj/item/tool/screwdriver/alien,
		/obj/item/weldingtool/alien,
		/obj/item/tool/wirecutters/alien,
		/obj/item/tool/wrench/alien
	)
	rare_loot = list(
		/obj/item/storage/belt/utility/alien/full
	)

// May contain alien surgery equipment or powerful medication.
/obj/structure/loot_pile/surface/alien/medical
	uncommon_loot = list(
		/obj/item/surgical/FixOVein/alien,
		/obj/item/surgical/bone_clamp/alien,
		/obj/item/surgical/cautery/alien,
		/obj/item/surgical/circular_saw/alien,
		/obj/item/surgical/hemostat/alien,
		/obj/item/surgical/retractor/alien,
		/obj/item/surgical/scalpel/alien,
		/obj/item/surgical/surgicaldrill/alien
	)
	rare_loot = list(
		/obj/item/storage/belt/medical/alien
	)

// May contain powercells or alien weaponry.
/obj/structure/loot_pile/surface/alien/security
	uncommon_loot = list(
		/obj/item/cell/device/weapon/recharge/alien,
		/obj/item/clothing/suit/armor/alien,
		/obj/item/clothing/head/helmet/alien
	)
	rare_loot = list(
		/obj/item/clothing/suit/armor/alien/tank,
		/obj/item/gun/energy/alien
	)

// The pile found at the very end, and as such has the best loot.
/obj/structure/loot_pile/surface/alien/end
	chance_uncommon = 30
	chance_rare = 10

	common_loot = list(
		/obj/item/multitool/alien,
		/obj/item/stack/cable_coil/alien,
		/obj/item/tool/crowbar/alien,
		/obj/item/tool/screwdriver/alien,
		/obj/item/weldingtool/alien,
		/obj/item/tool/wirecutters/alien,
		/obj/item/tool/wrench/alien,
		/obj/item/surgical/FixOVein/alien,
		/obj/item/surgical/bone_clamp/alien,
		/obj/item/surgical/cautery/alien,
		/obj/item/surgical/circular_saw/alien,
		/obj/item/surgical/hemostat/alien,
		/obj/item/surgical/retractor/alien,
		/obj/item/surgical/scalpel/alien,
		/obj/item/surgical/surgicaldrill/alien,
		/obj/item/cell/device/weapon/recharge/alien,
		/obj/item/clothing/suit/armor/alien,
		/obj/item/clothing/head/helmet/alien,
		/obj/item/gun/energy/alien
	)
	uncommon_loot = list(
		/obj/item/storage/belt/medical/alien,
		/obj/item/storage/belt/utility/alien/full,
		/obj/item/clothing/suit/armor/alien/tank,
		/obj/item/clothing/head/helmet/alien/tank,
	)

/obj/structure/loot_pile/surface/bones
    name = "bone pile"
    desc = "A pile of various dusty bones. Your graverobbing instincts tell you there might be valuables here."
    icon = 'icons/obj/bones.dmi'
    icon_state = "bonepile"
    delete_on_depletion = TRUE

    common_loot = list(
        /obj/item/bone,
        /obj/item/bone/skull,
        /obj/item/bone/skull/tajaran,
        /obj/item/bone/skull/unathi,
        /obj/item/bone/skull/unknown,
        /obj/item/bone/leg,
        /obj/item/bone/arm,
        /obj/item/bone/ribs,
    )
    uncommon_loot = list(
        /obj/item/coin/gold,
        /obj/item/coin/silver,
        /obj/item/deck/tarot,
        /obj/item/flame/lighter/zippo/gold,
        /obj/item/flame/lighter/zippo/black,
        /obj/item/material/knife/tacknife/survival,
        /obj/item/material/knife/tacknife/combatknife,
        /obj/item/material/knife/machete/hatchet,
        /obj/item/material/knife/butch,
        /obj/item/storage/wallet/random,
        /obj/item/clothing/accessory/bracelet/material/gold,
        /obj/item/clothing/accessory/bracelet/material/silver,
        /obj/item/clothing/accessory/locket,
        /obj/item/clothing/accessory/poncho/blue,
        /obj/item/clothing/shoes/boots/cowboy,
        /obj/item/clothing/suit/storage/toggle/bomber,
        /obj/item/clothing/under/frontier,
        /obj/item/clothing/under/overalls,
        /obj/item/clothing/under/pants/classicjeans/ripped,
        /obj/item/clothing/under/sl_suit
    )
    rare_loot = list(
        /obj/item/storage/belt/utility/alien/full,
        /obj/item/gun/projectile/revolver,
        /obj/item/gun/projectile/sec,
        /obj/item/gun/launcher/crossbow
    )

// Subtype for mecha and mecha accessories. These might not always be on the surface.
/obj/structure/loot_pile/mecha
	name = "pod wreckage"
	desc = "The ruins of some unfortunate pod. Perhaps something is salvageable."
	icon = 'icons/mecha/mecha.dmi'
	icon_state = "engineering_pod-broken"
	density = TRUE
	anchored = FALSE // In case a dead mecha-mob dies in a bad spot.

	chance_uncommon = 20
	chance_rare = 10

	loot_depletion = TRUE
	loot_left = 9

	common_loot = list(
		/obj/random/tool,
		/obj/random/tool,
		/obj/random/tool,
		/obj/random/tool,
		/obj/item/stack/cable_coil/random,
		/obj/random/tank,
		/obj/random/tech_supply/component,
		/obj/random/tech_supply/component,
		/obj/random/tech_supply/component,
		/obj/effect/decal/remains/lizard,
		/obj/effect/decal/remains/mouse,
		/obj/effect/decal/remains/robot,
		/obj/item/stack/material/steel{amount = 40}
		)

	uncommon_loot = list(
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser,
		/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp,
		/obj/item/mecha_parts/mecha_equipment/tool/drill,
		/obj/item/mecha_parts/mecha_equipment/generator
		)

	rare_loot = list(
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser,
		/obj/item/mecha_parts/mecha_equipment/generator/nuclear,
		/obj/item/mecha_parts/mecha_equipment/tool/jetpack
		)

//Stuff you may find attached to a ripley.
/obj/structure/loot_pile/mecha/ripley
	name = "ripley wreckage"
	desc = "The ruins of some unfortunate ripley. Perhaps something is salvageable."
	icon_state = "ripley-broken"

	common_loot = list(
		/obj/random/tool,
		/obj/item/stack/cable_coil/random,
		/obj/random/tank,
		/obj/random/tech_supply/component,
		/obj/item/stack/material/steel{amount = 25},
		/obj/item/stack/material/glass{amount = 10},
		/obj/item/stack/material/plasteel{amount = 5},
		/obj/item/mecha_parts/chassis/ripley,
		/obj/item/mecha_parts/part/ripley_torso,
		/obj/item/mecha_parts/part/ripley_left_arm,
		/obj/item/mecha_parts/part/ripley_right_arm,
		/obj/item/mecha_parts/part/ripley_left_leg,
		/obj/item/mecha_parts/part/ripley_right_leg,
		/obj/item/kit/paint/ripley,
		/obj/item/kit/paint/ripley/flames_red,
		/obj/item/kit/paint/ripley/flames_blue
		)

	uncommon_loot = list(
		/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp,
		/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill,
		/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster,
		/obj/item/mecha_parts/mecha_equipment/tool/extinguisher,
		)

	rare_loot = list(
		/obj/item/mecha_parts/mecha_equipment/gravcatapult,
		/obj/item/mecha_parts/mecha_equipment/tool/rcd,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged
		)

/obj/structure/loot_pile/mecha/ripley/firefighter
	icon_state = "firefighter-broken"

/obj/structure/loot_pile/mecha/ripley/random_sprite
	icon_states_to_use = list("ripley-broken", "firefighter-broken", "ripley-broken-old")

//Death-Ripley, same common, but more combat-exosuit-based
/obj/structure/loot_pile/mecha/deathripley
	name = "strange ripley wreckage"
	icon_state = "deathripley-broken"

	common_loot = list(
		/obj/random/tool,
		/obj/item/stack/cable_coil/random,
		/obj/random/tank,
		/obj/random/tech_supply/component,
		/obj/item/stack/material/steel{amount = 40},
		/obj/item/stack/material/glass{amount = 20},
		/obj/item/stack/material/plasteel{amount = 10},
		/obj/item/mecha_parts/chassis/ripley,
		/obj/item/mecha_parts/part/ripley_torso,
		/obj/item/mecha_parts/part/ripley_left_arm,
		/obj/item/mecha_parts/part/ripley_right_arm,
		/obj/item/mecha_parts/part/ripley_left_leg,
		/obj/item/mecha_parts/part/ripley_right_leg,
		/obj/item/kit/paint/ripley/death
		)

	uncommon_loot = list(
		/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/safety,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser,
		/obj/item/mecha_parts/mecha_equipment/repair_droid,
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
		)

	rare_loot = list(
		/obj/item/mecha_parts/mecha_equipment/tool/rcd,
		/obj/item/mecha_parts/mecha_equipment/wormhole_generator,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged
		)

/obj/structure/loot_pile/mecha/odysseus
	name = "odysseus wreckage"
	desc = "The ruins of some unfortunate odysseus. Perhaps something is salvageable."
	icon_state = "odysseus-broken"

	common_loot = list(
		/obj/random/tool,
		/obj/item/stack/cable_coil/random,
		/obj/random/tank,
		/obj/random/tech_supply/component,
		/obj/item/stack/material/steel{amount = 25},
		/obj/item/stack/material/glass{amount = 10},
		/obj/item/stack/material/plasteel{amount = 5},
		/obj/item/mecha_parts/chassis/odysseus,
		/obj/item/mecha_parts/part/odysseus_head,
		/obj/item/mecha_parts/part/odysseus_torso,
		/obj/item/mecha_parts/part/odysseus_left_arm,
		/obj/item/mecha_parts/part/odysseus_right_arm,
		/obj/item/mecha_parts/part/odysseus_left_leg,
		/obj/item/mecha_parts/part/odysseus_right_leg
		)

	uncommon_loot = list(
		/obj/item/mecha_parts/mecha_equipment/tool/sleeper,
		/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare,
		/obj/item/mecha_parts/mecha_equipment/tool/extinguisher,
		)

	rare_loot = list(
		/obj/item/mecha_parts/mecha_equipment/gravcatapult,
		/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster,
		/obj/item/mecha_parts/mecha_equipment/shocker
		)

/obj/structure/loot_pile/mecha/odysseus/murdysseus
	icon_state = "murdysseus-broken"

/obj/structure/loot_pile/mecha/hoverpod
	name = "hoverpod wreckage"
	desc = "The ruins of some unfortunate hoverpod. Perhaps something is salvageable."
	icon_state = "engineering_pod"

/obj/structure/loot_pile/mecha/gygax
	name = "gygax wreckage"
	desc = "The ruins of some unfortunate gygax. Perhaps something is salvageable."
	icon_state = "gygax-broken"

	common_loot = list(
		/obj/random/tool,
		/obj/item/stack/cable_coil/random,
		/obj/random/tank,
		/obj/random/tech_supply/component,
		/obj/item/stack/material/steel{amount = 25},
		/obj/item/stack/material/glass{amount = 10},
		/obj/item/stack/material/plasteel{amount = 5},
		/obj/item/mecha_parts/chassis/gygax,
		/obj/item/mecha_parts/part/gygax_head,
		/obj/item/mecha_parts/part/gygax_torso,
		/obj/item/mecha_parts/part/gygax_left_arm,
		/obj/item/mecha_parts/part/gygax_right_arm,
		/obj/item/mecha_parts/part/gygax_left_leg,
		/obj/item/mecha_parts/part/gygax_right_leg,
		/obj/item/mecha_parts/part/gygax_armour
		)

	uncommon_loot = list(
		/obj/item/mecha_parts/mecha_equipment/shocker,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser,
		/obj/item/kit/paint/gygax,
		/obj/item/kit/paint/gygax/darkgygax,
		/obj/item/kit/paint/gygax/recitence
		)

	rare_loot = list(
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg,
		/obj/item/mecha_parts/mecha_equipment/repair_droid,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
		)

/obj/structure/loot_pile/mecha/gygax/dark
	icon_state = "darkgygax-broken"

// Todo: Better loot.
/obj/structure/loot_pile/mecha/gygax/dark/adv
	icon_state = "darkgygax_adv-broken"
	icon_scale_x = 1.5
	icon_scale_y = 1.5
	pixel_y = 8

/obj/structure/loot_pile/mecha/gygax/medgax
	icon_state = "medgax-broken"

/obj/structure/loot_pile/mecha/durand
	name = "durand wreckage"
	desc = "The ruins of some unfortunate durand. Perhaps something is salvageable."
	icon_state = "durand-broken"

	common_loot = list(
		/obj/random/tool,
		/obj/item/stack/cable_coil/random,
		/obj/random/tank,
		/obj/random/tech_supply/component,
		/obj/item/stack/material/steel{amount = 25},
		/obj/item/stack/material/glass{amount = 10},
		/obj/item/stack/material/plasteel{amount = 5},
		/obj/item/mecha_parts/chassis/durand,
		/obj/item/mecha_parts/part/durand_head,
		/obj/item/mecha_parts/part/durand_torso,
		/obj/item/mecha_parts/part/durand_left_arm,
		/obj/item/mecha_parts/part/durand_right_arm,
		/obj/item/mecha_parts/part/durand_left_leg,
		/obj/item/mecha_parts/part/durand_right_leg,
		/obj/item/mecha_parts/part/durand_armour
		)

	uncommon_loot = list(
		/obj/item/mecha_parts/mecha_equipment/shocker,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser,
		/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster,
		/obj/item/kit/paint/durand,
		/obj/item/kit/paint/durand/seraph,
		/obj/item/kit/paint/durand/phazon
		)

	rare_loot = list(
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot,
		/obj/item/mecha_parts/mecha_equipment/repair_droid,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
		)

/obj/structure/loot_pile/mecha/marauder
	name = "marauder wreckage"
	desc = "The ruins of some unfortunate marauder. Perhaps something is salvagable."
	icon_state = "marauder-broken"
	// Todo: Better loot.

/obj/structure/loot_pile/mecha/marauder/seraph
	name = "seraph wreckage"
	desc = "The ruins of some unfortunate seraph. Perhaps something is salvagable."
	icon_state = "seraph-broken"

/obj/structure/loot_pile/mecha/marauder/mauler
	name = "mauler wreckage"
	desc = "The ruins of some unfortunate mauler. Perhaps something is salvagable."
	icon_state = "mauler-broken"

/obj/structure/loot_pile/mecha/phazon
	name = "phazon wreckage"
	desc = "The ruins of some unfortunate phazon. Perhaps something is salvageable."
	icon_state = "phazon-broken"

	common_loot = list(
		/obj/item/storage/toolbox/syndicate/powertools,
		/obj/item/stack/material/plasteel{amount = 20},
		/obj/item/stack/material/durasteel{amount = 10},
		/obj/item/mecha_parts/chassis/phazon,
		/obj/item/mecha_parts/part/phazon_head,
		/obj/item/mecha_parts/part/phazon_torso,
		/obj/item/mecha_parts/part/phazon_left_arm,
		/obj/item/mecha_parts/part/phazon_right_arm,
		/obj/item/mecha_parts/part/phazon_left_leg,
		/obj/item/mecha_parts/part/phazon_right_leg
		)

	uncommon_loot = list(
		/obj/item/mecha_parts/mecha_equipment/shocker,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy,
		/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster
		)

	rare_loot = list(
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay,
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion,
		/obj/item/mecha_parts/mecha_equipment/repair_droid,
		/obj/item/mecha_parts/mecha_equipment/teleporter
		)

/obj/structure/loot_pile/surface/drone
	name = "drone wreckage"
	desc = "The ruins of some unfortunate drone. Perhaps something is salvageable."
	icon = 'icons/mob/animal.dmi'
	icon_state = "drone_dead"

// Since the actual drone loot is a bit stupid in how it is handled, this is a sparse and empty list with items I don't exactly want in it. But until we can get the proper items in . . .

	common_loot = list(
		/obj/random/tool,
		/obj/item/stack/cable_coil/random,
		/obj/random/tank,
		/obj/random/tech_supply/component,
		/obj/item/stack/material/steel{amount = 25},
		/obj/item/stack/material/glass{amount = 10},
		/obj/item/stack/material/plasteel{amount = 5},
		/obj/item/cell,
		/obj/item/material/shard
		)

	uncommon_loot = list(
		/obj/item/cell/high,
		/obj/item/robot_parts/robot_component/actuator,
		/obj/item/robot_parts/robot_component/armour,
		/obj/item/robot_parts/robot_component/binary_communication_device,
		/obj/item/robot_parts/robot_component/camera,
		/obj/item/robot_parts/robot_component/diagnosis_unit,
		/obj/item/robot_parts/robot_component/radio
		)

	rare_loot = list(
		/obj/item/cell/super,
		/obj/item/borg/upgrade/restart,
		/obj/item/borg/upgrade/jetpack,
		/obj/item/borg/upgrade/tasercooler,
		/obj/item/borg/upgrade/syndicate,
		/obj/item/borg/upgrade/vtec
		)

// Contains old mediciation, most of it unidentified and has a good chance of being useless.
/obj/structure/loot_pile/surface/medicine_cabinet
	name = "abandoned medicine cabinet"
	desc = "An old cabinet, it might still have something of use inside."
	icon_state = "medicine_cabinet"
	density = FALSE
	chance_uncommon = 0
	chance_rare = 0

	common_loot = list(
		/obj/random/unidentified_medicine/old_medicine
	)

// Like the above but has way better odds, in exchange for being in a place still inhabited (or was recently).
/obj/structure/loot_pile/surface/medicine_cabinet/fresh
	name = "medicine cabinet"
	desc = "A cabinet designed to hold medicine, it might still have something of use inside."
	icon_state = "medicine_cabinet"
	density = FALSE

	common_loot = list(
		/obj/random/unidentified_medicine/fresh_medicine
	)
