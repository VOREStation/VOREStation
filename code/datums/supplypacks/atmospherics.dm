/*
*	Here is where any supply packs related
*	to being atmospherics tasks live.
*/


/datum/supply_pack/atmos
	group = "Atmospherics"

/datum/supply_pack/atmos/inflatable
	name = "Inflatable barriers"
	desc = "Three cases of self-inflating barriers."
	contains = list(/obj/item/storage/briefcase/inflatable = 3)
	cost = 20
	containertype = /obj/structure/closet/crate/aether
	containername = "Inflatable Barrier Crate"

/datum/supply_pack/atmos/canister_empty
	name = "Empty gas canister"
	desc = "An empty gas canister."
	cost = 7
	contains = list(/obj/machinery/portable_atmospherics/canister)

/datum/supply_pack/atmos/canister_air
	name = "Air canister"
	desc = "A large canister full of standard oxy/nitro air mix."
	cost = 10
	contains = list(/obj/machinery/portable_atmospherics/canister/air)

/datum/supply_pack/atmos/canister_oxygen
	name = "Oxygen canister"
	desc = "A large canister full of pure oxygen gas. Warning: flammable!"
	cost = 15
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)

/datum/supply_pack/atmos/canister_nitrogen
	name = "Nitrogen canister"
	desc = "A large canister full of pure nitrogen gas."
	cost = 10
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)

/datum/supply_pack/atmos/canister_phoron
	name = "Phoron gas canister"
	desc = "A large canister full of pure phoron gas. Warning: flammable!"
	cost = 60
	contains = list(/obj/machinery/portable_atmospherics/canister/phoron)

/datum/supply_pack/atmos/canister_nitrous_oxide
	name = "N2O gas canister"
	desc = "A large canister full of pure nitrous oxide gas."
	cost = 15
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrous_oxide)

/datum/supply_pack/atmos/canister_carbon_dioxide
	name = "Carbon dioxide gas canister"
	desc = "A large canister full of pure carbon dioxide gas."
	cost = 15
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)

/datum/supply_pack/atmos/air_dispenser
	contains = list(/obj/machinery/pipedispenser/orderable)
	name = "Pipe Dispenser"
	desc = "A portable atmospherics pipe dispensing/laying machine. Atmospherics Access required."
	cost = 25
	containertype = /obj/structure/closet/crate/secure/large/aether
	containername = "Pipe Dispenser Crate"
	access = access_atmospherics

/datum/supply_pack/atmos/disposals_dispenser
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	name = "Disposals Pipe Dispenser"
	desc = "A portable disposals pipe dispensing/laying machine. Atmospherics Access required."
	cost = 25
	containertype = /obj/structure/closet/crate/secure/large/aether
	containername = "Disposal Dispenser Crate"
	access = access_atmospherics

/datum/supply_pack/atmos/rapid_pipe_dispenser
	contains = list(/obj/item/pipe_dispenser)
	name = "Rapid Pipe Dispenser"
	desc = "A handheld rapid pipe deploying machine. Atmospherics Access required."
	cost = 100
	containertype = /obj/structure/closet/crate/secure/aether
	containername = "Rapid Pipe Dispenser Crate"
	access = access_atmospherics

/datum/supply_pack/atmos/internals
	name = "Internals crate"
	desc = "A set of 3 gas masks and air tanks."
	contains = list(
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/air = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/aether
	containername = "Internals crate"

/datum/supply_pack/atmos/evacuation
	name = "Emergency equipment"
	desc = "Emergency evacuation supplies."
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
		/obj/item/tank/oxygen/red = 2,
		/obj/item/watertank/atmos = 2,
		/obj/item/flashlight = 2,
		/obj/item/clothing/head/hardhat/firefighter/atmos = 2
			)
	cost = 35
	containertype = /obj/structure/closet/crate/aether
	containername = "Firefighting crate"*/
