/*
*	Here is where any supply packs
*	related to security tasks live
*/
/datum/supply_packs/sci
	group = "Security"
	
/datum/supply_packs/sci/virus
	name = "Virus sample crate"
	contains = list(/obj/item/weapon/virusdish/random = 4)
	cost = 25
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Virus sample crate"
	access = access_cmo

/datum/supply_packs/sci/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"

/datum/supply_packs/sci/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(
			/obj/item/weapon/book/manual/ripley_build_and_repair,
			/obj/item/weapon/circuitboard/mecha/ripley/main,
			/obj/item/weapon/circuitboard/mecha/ripley/peripherals
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "APLU \"Ripley\" Circuit Crate"
	access = access_robotics

/datum/supply_packs/sci/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(
			/obj/item/weapon/circuitboard/mecha/odysseus/peripherals,
			/obj/item/weapon/circuitboard/mecha/odysseus/main
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\"Odysseus\" Circuit Crate"
	access = access_robotics
	
/datum/supply_packs/sci/phoron
	name = "Phoron assembly crate"
	contains = list(
			/obj/item/weapon/tank/phoron = 3,
			/obj/item/device/assembly/igniter = 3,
			/obj/item/device/assembly/prox_sensor = 3,
			/obj/item/device/assembly/timer = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "Phoron assembly crate"
	access = access_tox_storage