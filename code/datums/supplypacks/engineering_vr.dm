/datum/supply_pack/eng/modern_shield
	name = "Modern Shield Construction Kit"
	contains = list(
		/obj/item/circuitboard/shield_generator,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/micro_laser,
		/obj/item/smes_coil,
		/obj/item/stock_parts/console_screen,
		/obj/item/stock_parts/subspace/amplifier
		)
	cost = 80
	containertype = /obj/structure/closet/crate/focalpoint
	containername = "shield generator construction kit crate"

/datum/supply_pack/eng/thermoregulator
	contains = list(/obj/machinery/power/thermoregulator)
	name = "Thermal Regulator"
	cost = 30
	containertype = /obj/structure/closet/crate/large
	containername = "thermal regulator crate"
	access = access_atmospherics

/datum/supply_pack/eng/radsuit
	contains = list(
			/obj/item/clothing/suit/radiation = 3,
			/obj/item/clothing/head/radiation = 3
			)

/datum/supply_pack/eng/dosimeter
	contains = list(/obj/item/storage/box/dosimeter = 6)
	name = "Dosimeters"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "dosimeter crate"

/datum/supply_pack/eng/algae
	contains = list(/obj/item/stack/material/algae/ten)
	name = "Algae Sheets (10)"
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "algae sheets crate"

/datum/supply_pack/eng/engine/tesla_gen
	name = "Tesla Generator crate"
	contains = list(/obj/machinery/the_singularitygen/tesla)
	containertype = /obj/structure/closet/crate/secure/engineering
	containername = "Tesla Generator crate"
	access = access_ce

/datum/supply_pack/eng/inducer
	contains = list(/obj/item/inducer = 3)
	name = "inducer"
	cost = 90	//Relatively expensive
	containertype = /obj/structure/closet/crate/xion
	containername = "Inducers crate"
	access = access_engine
