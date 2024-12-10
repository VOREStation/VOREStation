/datum/material/diona
	name = MAT_BIOMASS
	icon_colour = null
	stack_type = null
	integrity = 600
	icon_base = "diona"
	icon_reinf = "noreinf"

/datum/material/diona/place_dismantled_product()
	return

/datum/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)

/datum/material/chitin
	name = MAT_CHITIN
	icon_colour = "#8d6653"
	stack_type = /obj/item/stack/material/chitin
	stack_origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4)
	icon_base = "solid"
	icon_reinf = "reinf_mesh"
	integrity = 60
	weight = 10
	ignition_point = T0C+400
	melting_point = T0C+500
	protectiveness = 20
	conductive = 0
	supply_conversion_value = 4
