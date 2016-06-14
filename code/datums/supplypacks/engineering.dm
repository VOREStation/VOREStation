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
	
/datum/supply_packs/eng/metal50
	name = "50 metal sheets"
	contains = list(/obj/item/stack/material/steel)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Metal sheets crate"

/datum/supply_packs/eng/glass50
	name = "50 glass sheets"
	contains = list(/obj/item/stack/material/glass)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Glass sheets crate"

/datum/supply_packs/eng/wood50
	name = "50 wooden planks"
	contains = list(/obj/item/stack/material/wood)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Wooden planks crate"

/datum/supply_packs/eng/plastic50
	name = "50 plastic sheets"
	contains = list(/obj/item/stack/material/plastic)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Plastic sheets crate"

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
	cost = 15
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
	cost = 8
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
	
/datum/supply_packs/engine/eng/field_gen
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
	
/datum/supply_packs/eng/robotics
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
	
/datum/supply_packs/eng/robolimbs_basic
	name = "Basic robolimb blueprints"
	contains = list(
			/obj/item/weapon/disk/limb/morpheus,
			/obj/item/weapon/disk/limb/xion
			)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robolimb blueprints (basic)"
	access = access_robotics
	
/datum/supply_packs/eng/robolimbs_adv
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
	
/datum/supply_packs/eng/shield_gen
	contains = list(/obj/item/weapon/circuitboard/shield_gen)
	name = "Bubble shield generator circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "bubble shield generator circuitry crate"
	access = access_ce
	
/datum/supply_packs/eng/shield_gen_ex
	contains = list(/obj/item/weapon/circuitboard/shield_gen_ex)
	name = "Hull shield generator circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "hull shield generator circuitry crate"
	access = access_ce
	
/datum/supply_packs/eng/shield_cap
	contains = list(/obj/item/weapon/circuitboard/shield_cap)
	name = "Bubble shield capacitor circuitry"
	cost = 50
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
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Mk1 TEG crate"
	access = access_engine
	
/datum/supply_packs/eng/circulator
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	name = "Binary atmospheric circulator"
	cost = 60
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Atmospheric circulator crate"
	access = access_engine
	
/datum/supply_packs/eng/air_dispenser
	contains = list(/obj/machinery/pipedispenser/orderable)
	name = "Pipe Dispenser"
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Pipe Dispenser Crate"
	access = access_atmospherics
	
/datum/supply_packs/eng/disposals_dispenser
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	name = "Disposals Pipe Dispenser"
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Disposal Dispenser Crate"
	access = access_atmospherics
	
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
	cost = 45
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
	cost = 55
	containername = "Super P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate/secure
	access = access_tech_storage
	contains = list(
			/obj/item/weapon/stock_parts/micro_laser,
			/obj/item/weapon/stock_parts/capacitor,
			/obj/item/weapon/stock_parts/matter_bin,
			/obj/item/weapon/circuitboard/pacman/super
			)
			
/datum/supply_packs/eng/painters
	name = "Station Painting Supplies"
	cost = 10
	containername = "station painting supplies crate"
	containertype = /obj/structure/closet/crate
	contains = list(
			/obj/item/device/pipe_painter = 2,
			/obj/item/device/floor_painter = 2,
			/obj/item/device/closet_painter = 2
			)
			
/datum/supply_packs/eng/voidsuits
	name = "Engineering voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering = 2,
			/obj/item/clothing/head/helmet/space/void/engineering = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Engineering voidsuit crate"
	access = access_engine_equip