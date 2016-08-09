/*
*	Here is where any supply packs
*	related to engineering tasks live.
*/


/datum/supply_packs/eng
	group = "Engineering"

/datum/supply_packs/eng/lightbulbs
	name = "Replacement lights"
	contains = list(/obj/item/weapon/storage/box/lights/mixed = 3)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Replacement lights"

/datum/supply_packs/eng/smescoil
	name = "Superconducting Magnetic Coil"
	contains = list(/obj/item/weapon/smes_coil)
	cost = 75
	containertype = /obj/structure/closet/crate
	containername = "Superconducting Magnetic Coil crate"

/datum/supply_packs/eng/electrical
	name = "Electrical maintenance crate"
	contains = list(
			/obj/item/weapon/storage/toolbox/electrical = 2,
			/obj/item/clothing/gloves/yellow = 2,
			/obj/item/weapon/cell = 2,
			/obj/item/weapon/cell/high = 2
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Electrical maintenance crate"

/datum/supply_packs/eng/mechanical
	name = "Mechanical maintenance crate"
	contains = list(
			/obj/item/weapon/storage/belt/utility/full = 3,
			/obj/item/clothing/suit/storage/hazardvest = 3,
			/obj/item/clothing/head/welding = 2,
			/obj/item/clothing/head/hardhat
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Mechanical maintenance crate"

/datum/supply_packs/eng/fueltank
	name = "Fuel tank crate"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 10
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"

/datum/supply_packs/eng/solar
	name = "Solar Pack crate"
	contains  = list(
			/obj/item/solar_assembly = 21,
			/obj/item/weapon/circuitboard/solar_control,
			/obj/item/weapon/tracker_electronics,
			/obj/item/weapon/paper/solar
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Solar pack crate"

/datum/supply_packs/eng/engine
	name = "Emitter crate"
	contains = list(/obj/machinery/power/emitter = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Emitter crate"
	access = access_ce

/datum/supply_packs/eng/engine/field_gen
	name = "Field Generator crate"
	contains = list(/obj/machinery/field_generator = 2)
	containertype = /obj/structure/closet/crate/secure
	containername = "Field Generator crate"
	access = access_ce

/datum/supply_packs/eng/engine/sing_gen
	name = "Singularity Generator crate"
	contains = list(/obj/machinery/the_singularitygen)
	containertype = /obj/structure/closet/crate/secure
	containername = "Singularity Generator crate"
	access = access_ce

/datum/supply_packs/eng/engine/collector
	name = "Collector crate"
	contains = list(/obj/machinery/power/rad_collector = 3)
	containername = "Collector crate"

/datum/supply_packs/eng/engine/PA
	name = "Particle Accelerator crate"
	cost = 40
	contains = list(
			/obj/structure/particle_accelerator/fuel_chamber,
			/obj/machinery/particle_accelerator/control_box,
			/obj/structure/particle_accelerator/particle_emitter/center,
			/obj/structure/particle_accelerator/particle_emitter/left,
			/obj/structure/particle_accelerator/particle_emitter/right,
			/obj/structure/particle_accelerator/power_box,
			/obj/structure/particle_accelerator/end_cap
			)
	containertype = /obj/structure/closet/crate/secure
	containername = "Particle Accelerator crate"
	access = access_ce

/datum/supply_packs/eng/shield_gen
	contains = list(/obj/item/weapon/circuitboard/shield_gen)
	name = "Bubble shield generator circuitry"
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "bubble shield generator circuitry crate"
	access = access_ce

/datum/supply_packs/eng/shield_gen_ex
	contains = list(/obj/item/weapon/circuitboard/shield_gen_ex)
	name = "Hull shield generator circuitry"
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "hull shield generator circuitry crate"
	access = access_ce

/datum/supply_packs/eng/shield_cap
	contains = list(/obj/item/weapon/circuitboard/shield_cap)
	name = "Bubble shield capacitor circuitry"
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "shield capacitor circuitry crate"
	access = access_ce

/datum/supply_packs/eng/smbig
	name = "Supermatter Core"
	contains = list(/obj/machinery/power/supermatter)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "Supermatter crate (CAUTION)"
	access = access_ce

/datum/supply_packs/eng/teg
	contains = list(/obj/machinery/power/generator)
	name = "Mark I Thermoelectric Generator"
	cost = 50
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Mk1 TEG crate"
	access = access_engine

/datum/supply_packs/eng/circulator
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	name = "Binary atmospheric circulator"
	cost = 50
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Atmospheric circulator crate"
	access = access_engine

/datum/supply_packs/eng/radsuit
	contains = list(
			/obj/item/clothing/suit/radiation = 3,
			/obj/item/clothing/head/radiation = 3
			)
	name = "Radiation suits package"
	cost = 20
	containertype = /obj/structure/closet/radiation
	containername = "Radiation suit locker"

/datum/supply_packs/eng/pacman_parts
	name = "P.A.C.M.A.N. portable generator parts"
	cost = 25
	containername = "P.A.C.M.A.N. Portable Generator Construction Kit"
	containertype = /obj/structure/closet/crate/secure
	access = access_tech_storage
	contains = list(
			/obj/item/weapon/stock_parts/micro_laser,
			/obj/item/weapon/stock_parts/capacitor,
			/obj/item/weapon/stock_parts/matter_bin,
			/obj/item/weapon/circuitboard/pacman
			)

/datum/supply_packs/eng/super_pacman_parts
	name = "Super P.A.C.M.A.N. portable generator parts"
	cost = 35
	containername = "Super P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate/secure
	access = access_tech_storage
	contains = list(
			/obj/item/weapon/stock_parts/micro_laser,
			/obj/item/weapon/stock_parts/capacitor,
			/obj/item/weapon/stock_parts/matter_bin,
			/obj/item/weapon/circuitboard/pacman/super
			)
