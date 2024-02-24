/datum/material/durasteel/generate_recipes()
	. = ..()
	recipes += list(
		new /datum/stack_recipe("durasteel fishing rod", /obj/item/weapon/material/fishing_rod/modern/strong, 2),
		new /datum/stack_recipe("whetstone", /obj/item/weapon/whetstone, 2, time = 30),
	)
