/*
*	Here is where any supply packs related
*	to being atmospherics tasks live.
*/


/datum/supply_pack/atmos
	group = "Atmospherics"

/datum/supply_pack/atmos/inflatable
	name = "Inflatable barriers"
	contains = list(/obj/item/storage/briefcase/inflatable = 3)
	cost = 20
	containertype = /obj/structure/closet/crate/aether
	containername = "Inflatable Barrier Crate"

/datum/supply_pack/atmos/canister_empty
	name = "Empty gas canister"
	cost = 7
	containername = "Empty gas canister crate"
	containertype = /obj/structure/closet/crate/large/aether
	contains = list(/obj/machinery/portable_atmospherics/canister)

/datum/supply_pack/atmos/canister_air
	name = "Air canister"
	cost = 10
	containername = "Air canister crate"
	containertype = /obj/structure/closet/crate/large/aether
	contains = list(/obj/machinery/portable_atmospherics/canister/air)

/datum/supply_pack/atmos/canister_oxygen
	name = "Oxygen canister"
	cost = 15
	containername = "Oxygen canister crate"
	containertype = /obj/structure/closet/crate/large/aether
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)

/datum/supply_pack/atmos/canister_nitrogen
	name = "Nitrogen canister"
	cost = 10
	containername = "Nitrogen canister crate"
	containertype = /obj/structure/closet/crate/large/aether
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)

/datum/supply_pack/atmos/canister_phoron
	name = "Phoron gas canister"
	cost = 60
	containername = "Phoron gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large/aether
	access = access_atmospherics
	contains = list(/obj/machinery/portable_atmospherics/canister/phoron)

/datum/supply_pack/atmos/canister_nitrous_oxide
	name = "N2O gas canister"
	cost = 15
	containername = "N2O gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large/aether
	access = access_atmospherics
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrous_oxide)

/datum/supply_pack/atmos/canister_carbon_dioxide
	name = "Carbon dioxide gas canister"
	cost = 15
	containername = "CO2 canister crate"
	containertype = /obj/structure/closet/crate/secure/large/aether
	access = access_atmospherics
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)

/datum/supply_pack/atmos/air_dispenser
	contains = list(/obj/machinery/pipedispenser/orderable)
	name = "Pipe Dispenser"
	cost = 25
	containertype = /obj/structure/closet/crate/secure/large/aether
	containername = "Pipe Dispenser Crate"
	access = access_atmospherics

/datum/supply_pack/atmos/disposals_dispenser
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	name = "Disposals Pipe Dispenser"
	cost = 25
	containertype = /obj/structure/closet/crate/secure/large/aether
	containername = "Disposal Dispenser Crate"
	access = access_atmospherics

/datum/supply_pack/atmos/internals
	name = "Internals crate"
	contains = list(
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/air = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/aether
	containername = "Internals crate"

/datum/supply_pack/atmos/evacuation
	name = "Emergency equipment"
	contains = list(
			/obj/item/storage/toolbox/emergency = 2,
			/obj/item/clothing/suit/storage/hazardvest = 2,
			/obj/item/clothing/suit/storage/vest = 2,
			/obj/item/tank/emergency/oxygen/engi = 4,
			/obj/item/clothing/suit/space/emergency = 4,
			/obj/item/clothing/head/helmet/space/emergency = 4,
			/obj/item/clothing/mask/gas = 4
			)
	cost = 35
	containertype = /obj/structure/closet/crate/aether
	containername = "Emergency crate"
/*
/datum/supply_pack/atmos/firefighting
	name = "Firefighting equipment"
	contains = list(
		/obj/item/clothing/suit/fire/heavy = 2,
		/obj/item/weapon/tank/oxygen/red = 2,
		/obj/item/weapon/watertank/atmos = 2,
		/obj/item/flashlight = 2,
		/obj/item/clothing/head/hardhat/firefighter/atmos = 2
			)
	cost = 35
	containertype = /obj/structure/closet/crate/aether
	containername = "Firefighting crate"*/
