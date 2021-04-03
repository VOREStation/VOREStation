
/datum/category_item/autolathe/materials/metal
	name = "steel sheets"
	path =/obj/item/stack/material/steel
	is_stack = TRUE
	no_scale = TRUE //prevents material duplication exploits

/datum/category_item/autolathe/materials/glass
	name = "glass sheets"
	path =/obj/item/stack/material/glass
	is_stack = TRUE
	no_scale = TRUE //prevents material duplication exploits

/datum/category_item/autolathe/materials/rglass
	name = "reinforced glass sheets"
	path =/obj/item/stack/material/glass/reinforced
	is_stack = TRUE
	no_scale = TRUE //prevents material duplication exploits

/datum/category_item/autolathe/materials/rods
	name = "metal rods"
	path =/obj/item/stack/rods
	is_stack = TRUE
	no_scale = TRUE //prevents material duplication exploits

/datum/category_item/autolathe/materials/plasteel
	name = "plasteel sheets"
	path =/obj/item/stack/material/plasteel
	is_stack = TRUE
	no_scale = TRUE //prevents material duplication exploits
	resources = list(MAT_PLASTEEL = 2000)

/datum/category_item/autolathe/materials/plastic
	name = "plastic sheets"
	path =/obj/item/stack/material/plastic
	is_stack = TRUE
	no_scale = TRUE //prevents material duplication exploits
	resources = list(MAT_PLASTIC = 2000)
