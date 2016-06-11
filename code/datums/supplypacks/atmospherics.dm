/*
*	Here is where any supply packs related
*	to being atmospherics tasks live.
*/
/datum/supply_packs/atmos
	group = "Atmospherics"

/datum/supply_packs/atmos/internals
	name = "Internals crate"
	contains = list(
			/obj/item/clothing/mask/gas = 3,
			/obj/item/weapon/tank/air = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/internals
	containername = "Internals crate"
	
/datum/supply_packs/atmos/evacuation
	name = "Emergency equipment"
	contains = list(
			/obj/item/weapon/storage/toolbox/emergency = 2,
			/obj/item/clothing/suit/storage/hazardvest = 2,
			/obj/item/clothing/suit/storage/vest = 2,
			/obj/item/weapon/tank/emergency_oxygen/engi = 4,
			/obj/item/clothing/suit/space/emergency = 4,
			/obj/item/clothing/head/helmet/space/emergency = 4,
			/obj/item/clothing/mask/gas = 4
			)
	cost = 45
	containertype = /obj/structure/closet/crate/internals
	containername = "Emergency crate"
	
/datum/supply_packs/atmos/inflatable
	name = "Inflatable barriers"
	contains = list(/obj/item/weapon/storage/briefcase/inflatable = 3)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Inflatable Barrier Crate"
	
/datum/supply_packs/atmos/canister_empty
	name = "Empty gas canister"
	cost = 7
	containername = "Empty gas canister crate"
	containertype = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister)
	
/datum/supply_packs/atmos/canister_air
	name = "Air canister"
	cost = 10
	containername = "Air canister crate"
	containertype = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister/air)

/datum/supply_packs/atmos/canister_oxygen
	name = "Oxygen canister"
	cost = 15
	containername = "Oxygen canister crate"
	containertype = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)

/datum/supply_packs/atmos/canister_nitrogen
	name = "Nitrogen canister"
	cost = 10
	containername = "Nitrogen canister crate"
	containertype = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)

/datum/supply_packs/atmos/canister_phoron
	name = "Phoron gas canister"
	cost = 60
	containername = "Phoron gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_atmospherics
	contains = list(/obj/machinery/portable_atmospherics/canister/phoron)

/datum/supply_packs/atmos/canister_sleeping_agent
	name = "N2O gas canister"
	cost = 40
	containername = "N2O gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_atmospherics
	contains = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent)

/datum/supply_packs/atmos/canister_carbon_dioxide
	name = "Carbon dioxide gas canister"
	cost = 40
	containername = "CO2 canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_atmospherics
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)
	
/datum/supply_packs/atmos/voidsuits
	name = "Atmospheric voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/atmos = 2,
			/obj/item/clothing/head/helmet/space/void/atmos = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2,
			)
	cost = 45
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Atmospheric voidsuit crate"
	access = access_atmospherics