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
