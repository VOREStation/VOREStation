/datum/material/diamond/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe_list("floor tiles", list(
			new /datum/stack_recipe("diamond floor tile", /obj/item/stack/tile/floor/diamond, 1, 4, 20, recycle_material = "[name]")
		))
	)
