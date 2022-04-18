/*
*	Here is where any supply packs
*	related to robotics tasks live.
*/


/datum/supply_pack/robotics
	group = "Robotics"

/datum/supply_pack/randomised/robotics
	group = "Robotics"
	access = access_robotics

/datum/supply_pack/robotics/robotics_assembly
	name = "Robotics assembly crate"
	contains = list(
			/obj/item/assembly/prox_sensor = 3,
			/obj/item/storage/toolbox/electrical,
			/obj/item/flash = 4,
			/obj/item/cell/high = 2
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/nanotrasen
	containername = "Robotics assembly"
	access = access_robotics

/*/datum/supply_pack/robotics/robolimbs_basic
	name = "Basic robolimb blueprints"
	contains = list(
			/obj/item/disk/limb/morpheus,
			/obj/item/disk/limb/xion
			)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robolimb blueprints (basic)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs_adv
	name = "All robolimb blueprints"
	contains = list(
	/obj/item/disk/limb/bishop,
	/obj/item/disk/limb/hephaestus,
	/obj/item/disk/limb/morpheus,
	/obj/item/disk/limb/veymed,
	/obj/item/disk/limb/wardtakahashi,
	/obj/item/disk/limb/xion,
	/obj/item/disk/limb/zenghu,
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robolimb blueprints (adv)"
	access = access_robotics
*/

/datum/supply_pack/robotics/robolimbs/morpheus
	name = "Morpheus robolimb blueprints"
	contains = list(/obj/item/disk/limb/morpheus)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/morpheus
	containername = "Robolimb blueprints (Morpheus)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/cybersolutions
	name = "Cyber Solutions robolimb blueprints"
	contains = list(/obj/item/disk/limb/cybersolutions)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/cybersolutions
	containername = "Robolimb blueprints (Cyber Solutions)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/xion
	name = "Xion robolimb blueprints"
	contains = list(/obj/item/disk/limb/xion)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Robolimb blueprints (Xion)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/grayson
	name = "Grayson robolimb blueprints"
	contains = list(/obj/item/disk/limb/grayson)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/grayson
	containername = "Robolimb blueprints (Grayson)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/hephaestus
	name = "Hephaestus robolimb blueprints"
	contains = list(/obj/item/disk/limb/hephaestus)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Robolimb blueprints (Hephaestus)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/wardtakahashi
	name = "Ward-Takahashi robolimb blueprints"
	contains = list(/obj/item/disk/limb/wardtakahashi)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Robolimb blueprints (Ward-Takahashi)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/zenghu
	name = "Zeng Hu robolimb blueprints"
	contains = list(/obj/item/disk/limb/zenghu)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/zenghu
	containername = "Robolimb blueprints (Zeng Hu)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/bishop
	name = "Bishop robolimb blueprints"
	contains = list(/obj/item/disk/limb/bishop)
	cost = 70
	containertype = /obj/structure/closet/crate/secure/bishop
	containername = "Robolimb blueprints (Bishop)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/cenilimicybernetics
	name = "Cenilimi Cybernetics robolimb blueprints"
	contains = list(/obj/item/disk/limb/cenilimicybernetics)
	cost = 45
	containertype = /obj/structure/closet/crate/secure/science
	containername = "Robolimb blueprints (Cenilimi Cybernetics)"
	access = access_robotics


/datum/supply_pack/robotics/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(
			/obj/item/book/manual/ripley_build_and_repair,
			/obj/item/circuitboard/mecha/ripley/main,
			/obj/item/circuitboard/mecha/ripley/peripherals
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "APLU \"Ripley\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/robotics/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(
			/obj/item/circuitboard/mecha/odysseus/peripherals,
			/obj/item/circuitboard/mecha/odysseus/main
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/veymed
	containername = "\"Odysseus\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/randomised/robotics/exosuit_mod
	num_contained = 1
	contains = list(
			/obj/item/kit/paint/ripley,
			/obj/item/kit/paint/ripley/death,
			/obj/item/kit/paint/ripley/flames_red,
			/obj/item/kit/paint/ripley/flames_blue
			)
	name = "Random APLU modkit"
	cost = 200
	containertype = /obj/structure/closet/crate/xion
	containername = "heavy crate"

/datum/supply_pack/randomised/robotics/exosuit_mod/durand
	contains = list(
			/obj/item/kit/paint/durand,
			/obj/item/kit/paint/durand/seraph,
			/obj/item/kit/paint/durand/phazon
			)
	name = "Random Durand exosuit modkit"
	containertype = /obj/structure/closet/crate/heph

/datum/supply_pack/randomised/robotics/exosuit_mod/gygax
	contains = list(
			/obj/item/kit/paint/gygax,
			/obj/item/kit/paint/gygax/darkgygax,
			/obj/item/kit/paint/gygax/recitence
			)
	name = "Random Gygax exosuit modkit"
	containertype = /obj/structure/closet/crate/heph

/datum/supply_pack/robotics/jumper_cables
	name = "Jumper kit crate"
	contains = list(
			/obj/item/defib_kit/jumper_kit = 2
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/einstein
	containername = "Jumper kit crate"
	access = access_robotics

/datum/supply_pack/robotics/restrainingbolt
	name = "Restraining bolt crate"
	contains = list(
			/obj/item/implanter = 1,
			/obj/item/implantcase/restrainingbolt = 2
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/cybersolutions
	containername = "Restraining bolt crate"
	access = access_robotics

/datum/supply_pack/robotics/bike
	name = "Spacebike Crate"
	contains = list()
	cost = 350
	containertype = /obj/structure/largecrate/vehicle/bike
	containername = "Spacebike Crate"

/datum/supply_pack/robotics/quadbike
	name = "ATV Crate"
	contains = list()
	cost = 300
	containertype = /obj/structure/largecrate/vehicle/quadbike
	containername = "ATV Crate"

/datum/supply_pack/robotics/quadtrailer
	name = "ATV Trailer Crate"
	contains = list()
	cost = 250
	containertype = /obj/structure/largecrate/vehicle/quadtrailer
	containername = "ATV Trailer Crate"
