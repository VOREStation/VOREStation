/datum/material/leather
	name = MAT_LEATHER
	display_name = "plainleather"
	icon_colour = "#5C4831"
	stack_type = /obj/item/stack/material/leather
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 3 // 13%
	conductive = 0
	integrity = 40
	supply_conversion_value = 3

/datum/material/leather/generate_recipes()
	recipes = list(
		new /datum/stack_recipe("bedsheet", /obj/item/weapon/bedsheet, 10, time = 30 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("uniform", /obj/item/clothing/under/color/white, 8, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("foot wraps", /obj/item/clothing/shoes/footwraps, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("gloves", /obj/item/clothing/gloves/white, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("wig", /obj/item/clothing/head/powdered_wig, 4, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("philosopher's wig", /obj/item/clothing/head/collectable/philosopher_wig, 50, time = 2 MINUTES, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("taqiyah", /obj/item/clothing/head/taqiyah, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("turban", /obj/item/clothing/head/turban, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("hijab", /obj/item/clothing/head/hijab, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("kippa", /obj/item/clothing/head/kippa, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("scarf", /obj/item/clothing/accessory/scarf/white, 4, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("baggy pants", /obj/item/clothing/under/pants/baggy/white, 8, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("belt pouch", /obj/item/weapon/storage/belt/fannypack/white, 25, time = 1 MINUTE, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("pouch, medium", /obj/item/weapon/storage/pouch, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("pouch, large", /obj/item/weapon/storage/pouch/large, 15, time = 30 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("pouch, holster", /obj/item/weapon/storage/pouch/holster, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("pouch, melee", /obj/item/weapon/storage/pouch/baton, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("[display_name] net", /obj/item/weapon/material/fishing_net, 10, time = 5 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("[display_name] ring", /obj/item/clothing/gloves/ring/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("[display_name] bracelet", /obj/item/clothing/accessory/bracelet/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("[display_name] armor plate", /obj/item/weapon/material/armor_plating, 1, time = 20, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("empty sandbag", /obj/item/stack/emptysandbag, 2, time = 2 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]"),
<<<<<<< HEAD
		new /datum/stack_recipe("whip", /obj/item/weapon/material/whip, 5, time = 15 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]")
	)
=======
		new /datum/stack_recipe("whip", /obj/item/material/whip, 5, time = 15 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]")
	)
>>>>>>> 540b5cf6487... Merge pull request #8797 from Cerebulon/holloweeb
