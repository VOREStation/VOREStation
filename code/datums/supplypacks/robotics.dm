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
	desc = "An assortment of basic robotics assembly supplies. Requires Robotics access."
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
	desc = "A disk of robolimbs from the Morpheus catalogue. Requires Robotics access."
	contains = list(/obj/item/disk/limb/morpheus)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/morpheus
	containername = "Robolimb blueprints (Morpheus)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/cybersolutions
	name = "Cyber Solutions robolimb blueprints"
	desc = "A disk of robolimbs from the Cyber Solutions catalogue. Requires Robotics access."
	contains = list(/obj/item/disk/limb/cybersolutions)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/cybersolutions
	containername = "Robolimb blueprints (Cyber Solutions)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/xion
	name = "Xion robolimb blueprints"
	desc = "A disk of robolimbs from the Xion Manufacturing catalogue. Requires Robotics access."
	contains = list(/obj/item/disk/limb/xion)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Robolimb blueprints (Xion)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/grayson
	name = "Grayson robolimb blueprints"
	desc = "A disk of robolimbs from the Grayson Industries catalogue. Requires Robotics access."
	contains = list(/obj/item/disk/limb/grayson)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/grayson
	containername = "Robolimb blueprints (Grayson)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/hephaestus
	name = "Hephaestus robolimb blueprints"
	desc = "A disk of robolimbs from the Hephaestus Arms catalogue. Requires Robotics access."
	contains = list(/obj/item/disk/limb/hephaestus)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/heph
	containername = "Robolimb blueprints (Hephaestus)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/wardtakahashi
	name = "Ward-Takahashi robolimb blueprints"
	desc = "A disk of robolimbs from the Ward-Takahashi catalogue. Requires Robotics access."
	contains = list(/obj/item/disk/limb/wardtakahashi)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Robolimb blueprints (Ward-Takahashi)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/zenghu
	name = "Zeng Hu robolimb blueprints"
	desc = "A disk of robolimbs from the Zeng Hu Medical catalogue. Requires Robotics access."
	contains = list(/obj/item/disk/limb/zenghu)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/zenghu
	containername = "Robolimb blueprints (Zeng Hu)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/bishop
	name = "Bishop robolimb blueprints"
	desc = "A disk of robolimbs from the Bishop catalogue. Requires Robotics access."
	contains = list(/obj/item/disk/limb/bishop)
	cost = 70
	containertype = /obj/structure/closet/crate/secure/bishop
	containername = "Robolimb blueprints (Bishop)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/cenilimicybernetics
	name = "Cenilimi Cybernetics robolimb blueprints"
	desc = "A disk of teshari robolimbs from the Cenilimi Cybernetics catalogue. Requires Robotics access."
	contains = list(/obj/item/disk/limb/cenilimicybernetics)
	cost = 45
	containertype = /obj/structure/closet/crate/secure/science
	containername = "Robolimb blueprints (Cenilimi Cybernetics)"
	access = access_robotics

/datum/supply_pack/robotics/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	desc = "A set of standard core components for a Ripley Power-Loader mech, plus an assembly manual. Requires Robotics access."
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
	desc = "A set of standard core components for an Odysseus Medical Response mech. Requires Robotics access."
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
	desc = "A random Ripley customization kit, used to modify a mech's paint job."
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
	desc = "A random Durand customization kit, used to modify a mech's paint job."
	containertype = /obj/structure/closet/crate/heph

/datum/supply_pack/randomised/robotics/exosuit_mod/gygax
	contains = list(
			/obj/item/kit/paint/gygax,
			/obj/item/kit/paint/gygax/darkgygax,
			/obj/item/kit/paint/gygax/recitence
			)
	name = "Random Gygax exosuit modkit"
	desc = "A random Gygax customization kit, used to modify a mech's paint job."
	containertype = /obj/structure/closet/crate/heph

/datum/supply_pack/robotics/jumper_cables
	name = "Jumper kit crate"
	desc = "A pair of jumper kits, for restarting damaged synthetics."
	contains = list(
			/obj/item/defib_kit/jumper_kit = 2
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/einstein
	containername = "Jumper kit crate"
	access = access_robotics

/datum/supply_pack/robotics/restrainingbolt
	name = "Restraining bolt crate"
	desc = "A pair of restraining bolts and an implanter. Requires Robotics access."
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
	desc = "A spacebike. Drive with extreme care."
	contains = list()
	cost = 350
	containertype = /obj/structure/largecrate/vehicle/bike
	containername = "Spacebike Crate"

/datum/supply_pack/robotics/quadbike
	name = "ATV Crate"
	desc = "An all-terrain vehicle in a crate. Can tow a trailer."
	contains = list()
	cost = 300
	containertype = /obj/structure/largecrate/vehicle/quadbike
	containername = "ATV Crate"

/datum/supply_pack/robotics/quadtrailer
	name = "ATV Trailer Crate"
	desc = "A trailer for an all-terrain vehicle."
	contains = list()
	cost = 250
	containertype = /obj/structure/largecrate/vehicle/quadtrailer
	containername = "ATV Trailer Crate"

/datum/supply_pack/robotics/mecha_gopher
	name = "Circuit Crate (\"Gopher\" APLU)"
	desc = "A set of standard core components for a Gopher micro-mech. Requires Robotics access."
	contains = list(
			/obj/item/circuitboard/mecha/gopher/main,
			/obj/item/circuitboard/mecha/gopher/peripherals
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/science
	containername = "APLU \"Gopher\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/robotics/mecha_polecat
	name = "Circuit Crate (\"Polecat\" APLU)"
	desc = "A set of standard core components for a Polecat micro-mech. Requires Robotics access."
	contains = list(
			/obj/item/circuitboard/mecha/polecat/main,
			/obj/item/circuitboard/mecha/polecat/peripherals,
			/obj/item/circuitboard/mecha/polecat/targeting
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/science
	containername = "APLU \"Polecat\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/robotics/mecha_weasel
	name = "Circuit Crate (\"Weasel\" APLU)"
	desc = "A set of standard core components for a Weasel micro-mech. Requires Robotics access."
	contains = list(
			/obj/item/circuitboard/mecha/weasel/main,
			/obj/item/circuitboard/mecha/weasel/peripherals,
			/obj/item/circuitboard/mecha/weasel/targeting
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/science
	containername = "APLU \"Weasel\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/robotics/some_robolimbs
	name = "Basic Robolimb Blueprints"
	desc = "A set of standard cyberlimb blueprints, from the Morpheus, Xion, and Talon LLC catalogues. Requires Robotics access."
	contains = list(
			/obj/item/disk/limb/morpheus,
			/obj/item/disk/limb/xion,
			/obj/item/disk/limb/talon
			)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "Basic Robolimb Blueprint Crate"
	access = access_robotics

/datum/supply_pack/robotics/all_robolimbs
	name = "Advanced Robolimb Blueprints"
	desc = "A wide selection of advanced cyberlimb blueprints. Includes hyperrealistic prosthetic designs from Vey-Medical and DSI. Requires Robotics access."
	contains = list(
			/obj/item/disk/limb/bishop,
			/obj/item/disk/limb/hephaestus,
			/obj/item/disk/limb/morpheus,
			/obj/item/disk/limb/veymed,
			/obj/item/disk/limb/wardtakahashi,
			/obj/item/disk/limb/xion,
			/obj/item/disk/limb/zenghu,
			/obj/item/disk/limb/talon,
			/obj/item/disk/limb/dsi_tajaran,
			/obj/item/disk/limb/dsi_lizard,
			/obj/item/disk/limb/dsi_sergal,
			/obj/item/disk/limb/dsi_nevrean,
			/obj/item/disk/limb/dsi_vulpkanin,
			/obj/item/disk/limb/dsi_akula,
			/obj/item/disk/limb/dsi_spider,
			/obj/item/disk/limb/dsi_teshari,
			/obj/item/disk/limb/eggnerdltd,
			/obj/item/disk/limb/eggnerdltdred
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Advanced Robolimb Blueprint Crate"
	access = access_robotics
