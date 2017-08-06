/*
*	Here is where any supply packs
*	related to security tasks live
*/
/datum/supply_packs/sci
	group = "Science"

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
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"

/datum/supply_packs/sci/phoron
	name = "Phoron research crate"
	contains = list(
			/obj/item/weapon/tank/phoron = 3,
			/obj/item/weapon/tank/oxygen = 3,
			/obj/item/device/assembly/igniter = 3,
			/obj/item/device/assembly/prox_sensor = 3,
			/obj/item/device/assembly/timer = 3,
			/obj/item/device/assembly/signaler = 3,
			/obj/item/device/transfer_valve = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "Phoron assembly crate"
	access = access_tox_storage

/datum/supply_packs/sci/exoticseeds
	name = "Exotic seeds crate"
	contains = list(
			/obj/item/seeds/replicapod = 2,
			/obj/item/seeds/ambrosiavulgarisseed = 2,
			/obj/item/seeds/libertymycelium,
			/obj/item/seeds/reishimycelium,
			/obj/item/seeds/random = 6,
			/obj/item/seeds/kudzuseed
			)
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Exotic Seeds crate"
	access = access_hydroponics

/datum/supply_packs/sci/integrated_circuit_printer
	name = "Integrated circuit printer"
	contains = list(/obj/item/device/integrated_circuit_printer = 2)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Integrated circuit crate"

/datum/supply_packs/sci/integrated_circuit_printer_upgrade
	name = "Integrated circuit printer upgrade - advanced designs"
	contains = list(/obj/item/weapon/disk/integrated_circuit/upgrade/advanced)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Integrated circuit crate"
