// Surface loot piles are considerably harder and more dangerous to reach, so you're more likely to get rare things.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/element/lootable/surface
	chance_uncommon = 20
	chance_rare = 5
	loot_depletion = TRUE
	loot_left = 5 // This is to prevent people from asking the whole station to go down to some alien ruin to get massive amounts of phat lewt.

// Base type for alien piles.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/element/lootable/surface/alien
	common_loot = list(
		/obj/item/prop/alien/junk
	)


// May contain alien tools.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/element/lootable/surface/alien/engineering
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
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/element/lootable/surface/alien/medical
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
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/element/lootable/surface/alien/security
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
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/element/lootable/surface/alien/end
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

// POI bones of other less fortunate explos
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/element/lootable/surface/bones
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

// Surface drone loot
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Since the actual drone loot is a bit stupid in how it is handled, this is a sparse and empty list with items I don't exactly want in it. But until we can get the proper items in . . .
/datum/element/lootable/surface/drone
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
		/obj/item/borg/upgrade/utility/restart,
		/obj/item/borg/upgrade/advanced/jetpack,
		/obj/item/borg/upgrade/restricted/tasercooler,
		/obj/item/borg/upgrade/basic/syndicate,
		/obj/item/borg/upgrade/basic/vtec
		)
