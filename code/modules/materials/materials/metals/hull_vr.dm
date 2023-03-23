/datum/material/plastitanium/hull
	name = MAT_PLASTITANIUMHULL
	stack_type = /obj/item/stack/material/plastitanium/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	icon_colour = "#585658"
	explosion_resistance = 50
	composite_material = list(MAT_PLASTITANIUM = SHEET_MATERIAL_AMOUNT)

/datum/material/plastitanium/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plastitanium(target)

/datum/material/gold/hull
	name = MAT_GOLDHULL
	stack_type = /obj/item/stack/material/gold/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"
	explosion_resistance = 50
	composite_material = list(MAT_GOLD = SHEET_MATERIAL_AMOUNT)

/datum/material/gold/hull/place_sheet(var/turf/target) //Deconstructed into normal gold sheets.
	new /obj/item/stack/material/gold(target)
