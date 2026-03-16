/datum/material/gold/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe_list("floor tiles", list(
			new /datum/stack_recipe("gold floor tile", /obj/item/stack/tile/floor/gold, 1, 4, 20, recycle_material = "[name]")
		))
	)
