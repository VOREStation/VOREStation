/*
*	Here is where any supply packs
*	related to robotics tasks live.
*/


/datum/supply_packs/robotics
	group = "Robotics"

/datum/supply_packs/randomised/robotics
	group = "Robotics"
	access = access_robotics

/datum/supply_packs/robotics/robotics_assembly
	name = "Robotics assembly crate"
	contains = list(
			/obj/item/device/assembly/prox_sensor = 3,
			/obj/item/weapon/storage/toolbox/electrical,
			/obj/item/device/flash = 4,
			/obj/item/weapon/cell/high = 2
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robotics assembly"
	access = access_robotics

/datum/supply_packs/robotics/robolimbs_basic
	name = "Basic robolimb blueprints"
	contains = list(
			/obj/item/weapon/disk/limb/morpheus,
			/obj/item/weapon/disk/limb/xion
			)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robolimb blueprints (basic)"
	access = access_robotics

/datum/supply_packs/robotics/robolimbs_adv
	name = "All robolimb blueprints"
	contains = list(
	/obj/item/weapon/disk/limb/bishop,
	/obj/item/weapon/disk/limb/hesphiastos,
	/obj/item/weapon/disk/limb/morpheus,
	/obj/item/weapon/disk/limb/veymed,
	/obj/item/weapon/disk/limb/wardtakahashi,
	/obj/item/weapon/disk/limb/xion,
	/obj/item/weapon/disk/limb/zenghu,
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robolimb blueprints (adv)"
	access = access_robotics

/datum/supply_packs/robotics/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(
			/obj/item/weapon/book/manual/ripley_build_and_repair,
			/obj/item/weapon/circuitboard/mecha/ripley/main,
			/obj/item/weapon/circuitboard/mecha/ripley/peripherals
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "APLU \"Ripley\" Circuit Crate"
	access = access_robotics

/datum/supply_packs/robotics/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(
			/obj/item/weapon/circuitboard/mecha/odysseus/peripherals,
			/obj/item/weapon/circuitboard/mecha/odysseus/main
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\"Odysseus\" Circuit Crate"
	access = access_robotics

/datum/supply_packs/randomised/robotics/exosuit_mod
	num_contained = 1
	contains = list(
			/obj/item/device/kit/paint/ripley,
			/obj/item/device/kit/paint/ripley/death,
			/obj/item/device/kit/paint/ripley/flames_red,
			/obj/item/device/kit/paint/ripley/flames_blue
			)
	name = "Random APLU modkit"
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "heavy crate"

/datum/supply_packs/randomised/robotics/exosuit_mod/durand
	contains = list(
			/obj/item/device/kit/paint/durand,
			/obj/item/device/kit/paint/durand/seraph,
			/obj/item/device/kit/paint/durand/phazon
			)
	name = "Random Durand exosuit modkit"

/datum/supply_packs/randomised/robotics/exosuit_mod/gygax
	contains = list(
			/obj/item/device/kit/paint/gygax,
			/obj/item/device/kit/paint/gygax/darkgygax,
			/obj/item/device/kit/paint/gygax/recitence
			)
	name = "Random Gygax exosuit modkit"