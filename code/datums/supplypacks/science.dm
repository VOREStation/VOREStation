/*
*	Here is where any supply packs
*	related to security tasks live
*/
/datum/supply_pack/sci
	group = "Science"

/datum/supply_pack/sci/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 15
	containertype = /obj/structure/closet/crate/large/aether
	containername = "coolant tank crate"

/datum/supply_pack/sci/phoron
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

/datum/supply_pack/sci/exoticseeds
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
	containertype = /obj/structure/closet/crate/carp
	containername = "Exotic Seeds crate"
	access = access_hydroponics

/datum/supply_pack/sci/integrated_circuit_printer
	name = "Integrated circuit printer"
	contains = list(/obj/item/device/integrated_circuit_printer = 2)
	cost = 15
	containertype = /obj/structure/closet/crate/ward
	containername = "Integrated circuit crate"

/datum/supply_pack/sci/integrated_circuit_printer_upgrade
	name = "Integrated circuit printer upgrade - advanced designs"
	contains = list(/obj/item/weapon/disk/integrated_circuit/upgrade/advanced)
	cost = 30
	containertype = /obj/structure/closet/crate/ward
	containername = "Integrated circuit crate"

/datum/supply_pack/sci/xenoarch
	name = "Xenoarchaeology Tech crate"
	contains = list(
				/obj/item/weapon/pickaxe/excavationdrill,
				/obj/item/device/xenoarch_multi_tool,
				/obj/item/clothing/suit/space/anomaly,
				/obj/item/clothing/head/helmet/space/anomaly,
				/obj/item/weapon/storage/belt/archaeology,
				/obj/item/device/flashlight/lantern,
				/obj/item/device/core_sampler,
				/obj/item/device/gps,
				/obj/item/device/beacon_locator,
				/obj/item/device/radio/beacon,
				/obj/item/clothing/glasses/meson,
				/obj/item/weapon/pickaxe,
				/obj/item/weapon/storage/bag/fossils,
				/obj/item/weapon/hand_labeler)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/xion
	containername = "Xenoarchaeology Tech crate"
	access = access_research

/*
/datum/supply_pack/sci/dune_buggy
	name = "Exploration Dune Buggy"
	contains = list(
			/obj/vehicle/train/rover/engine/dunebuggy
			)
	cost = 100
	containertype = /obj/structure/largecrate
	containername = "Exploration Dune Buggy Crate"
*/

/datum/supply_pack/sci/pred
	name = "Dangerous Predator crate"
	cost = 40
	containertype = /obj/structure/largecrate/animal/pred
	containername = "Dangerous Predator crate"
	access = access_xenobiology

/datum/supply_pack/sci/pred_doom
	name = "EXTREMELY Dangerous Predator crate"
	cost = 200
	containertype = /obj/structure/largecrate/animal/dangerous
	containername = "EXTREMELY Dangerous Predator crate"
	access = access_xenobiology
	contraband = 1

/datum/supply_pack/sci/weretiger
	name = "Exotic Weretiger crate"
	cost = 55
	containertype = /obj/structure/largecrate/animal/weretiger
	containername = "Weretiger crate"
	access = access_xenobiology
/*
/datum/supply_pack/sci/otie
	name = "VARMAcorp adoptable reject (Dangerous!)"
	cost = 100
	containertype = /obj/structure/largecrate/animal/otie
	containername = "VARMAcorp adoptable reject (Dangerous!)"
	access = access_xenobiology

/datum/supply_pack/sci/phoronotie
	name = "VARMAcorp adaptive beta subject (Experimental)"
	cost = 200
	containertype = /obj/structure/largecrate/animal/otie/phoron
	containername = "VARMAcorp adaptive beta subject (Experimental)"
	access = access_xenobiology
*/ //VORESTATION AI TEMPORARY REMOVAL. Oties commented out cuz broke.
