/datum/material/phoron/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe_list("floor tiles", list(
			new /datum/stack_recipe("phoron floor tile", /obj/item/stack/tile/floor/phoron, 1, 4, 20, recycle_material = "[name]")
		))
	)
