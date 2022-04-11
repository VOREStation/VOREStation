/datum/material/cloth
	name = "cloth"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	door_icon_base = "wood"
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	flags = MATERIAL_PADDING
	conductive = 0
	integrity = 40
	pass_stack_colors = TRUE
	supply_conversion_value = 2
	hardness = 5


/datum/material/cloth/generate_recipes()
	recipes = list(
		new /datum/stack_recipe("woven net", /obj/item/weapon/material/fishing_net, 10, time = 30 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]"),
		new /datum/stack_recipe("bedsheet", /obj/item/weapon/bedsheet, 10, time = 30 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("uniform", /obj/item/clothing/under/color/white, 8, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("foot wraps", /obj/item/clothing/shoes/footwraps, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("gloves", /obj/item/clothing/gloves/white, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("wig", /obj/item/clothing/head/powdered_wig, 4, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("philosopher's wig", /obj/item/clothing/head/philosopher_wig, 50, time = 2 MINUTES, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("taqiyah", /obj/item/clothing/head/taqiyah, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("turban", /obj/item/clothing/head/turban, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("hijab", /obj/item/clothing/head/hijab, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("kippa", /obj/item/clothing/head/kippa, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("scarf", /obj/item/clothing/accessory/scarf/white, 4, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("baggy pants", /obj/item/clothing/under/pants/baggy/white, 8, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("belt pouch", /obj/item/weapon/storage/belt/fannypack/white, 25, time = 1 MINUTE, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("crude bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("empty sandbag", /obj/item/stack/emptysandbag, 2, time = 2 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]"),
		new /datum/stack_recipe("painting canvas (11x11)", /obj/item/canvas, 2, time = 2 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("painting canvas (19x19)", /obj/item/canvas/nineteen_nineteen, 3, time = 2 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("painting canvas (23x19)", /obj/item/canvas/twentythree_nineteen, 4, time = 3 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("painting canvas (23x23), AI", /obj/item/canvas/twentythree_twentythree, 5, time = 3 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]"),
		new /datum/stack_recipe("painting canvas (24x24)", /obj/item/canvas/twentyfour_twentyfour, 6, time = 3 SECONDS, pass_stack_color = FALSE, supplied_material = "[name]")
	)

/datum/material/cloth/syncloth
	name = "syncloth"
	stack_origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 2)
	ignition_point = T0C+532
	melting_point = T0C+600
	integrity = 200
	protectiveness = 15 // 4%
	pass_stack_colors = TRUE
	supply_conversion_value = 3
	hardness = 5

/datum/material/cloth/teal
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"

/datum/material/cloth/black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"

/datum/material/cloth/green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"

/datum/material/cloth/puple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"

/datum/material/cloth/blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"

/datum/material/cloth/beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"

/datum/material/cloth/lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"

/datum/material/cloth/yellow
	name = "yellow"
	display_name = "yellow"
	use_name = "yellow cloth"
	icon_colour = "#EEF573"

/datum/material/cloth/orange
	name = "orange"
	display_name = "orange"
	use_name = "orange cloth"
	icon_colour = "#E3BF49"



/datum/material/carpet
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	flags = MATERIAL_PADDING|MATERIAL_BRITTLE
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	protectiveness = 1 // 4%
	conductive = 0
	hardness = 5
	integrity = 40

/datum/material/cotton
	name = "cotton"
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	flags = MATERIAL_PADDING|MATERIAL_BRITTLE
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0
	hardness = 5
	integrity = 10

/datum/material/fibers
	name = MAT_FIBERS
	display_name = "plant"
	sheet_singular_name = "fiber"
	sheet_singular_name = "fibers"
	icon_colour = "#006b0e"
	flags = MATERIAL_PADDING|MATERIAL_BRITTLE
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	conductive = 0
	pass_stack_colors = TRUE
	hardness = 5
	integrity = 5